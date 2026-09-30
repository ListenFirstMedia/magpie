#!/usr/bin/env bash
# magpie CI runner — the build step invoked by the "magpie-tests-runner" Jenkins job.
#
# Unlike the qa Playwright runner (npx playwright test --grep @CASE_...), magpie's cases are
# executed BY Claude via the Playwright MCP: this script just prepares the environment and hands
# off to bin/run-batches.sh, which runs the set sequentially (login smoke gate -> batches ->
# results/<date>/*.md + summary.json). Runs on a Linux node inside the LFM network.
#
# Inputs (env, set by the Jenkins job):
#   SET               batch name under batches/ (e.g. qa-4325) OR a path to a batch file
#   TEST_CASES        OPTIONAL comma/space-separated QA-IDs. When non-empty it OVERRIDES SET —
#                     the runner builds an ad-hoc batch from exactly these cases (bare numbers ok).
#   CASE_TIMEOUT      per-case hard cap in seconds (default 1800 — long cases need it)
#   BATCH_SIZE        cases per checkpoint (default 5)
#   CLAUDE_CODE_OAUTH_TOKEN   from `claude setup-token`, bound by the pipeline (subscription auth)
#   LFMRC_S3          override for the creds file (default s3://conf.dev.lfm/qa/.lfmrc_qa)
#   PW_VERSION        Playwright version/range for the browser install (default 1.62 — the last
#                     line that supports Ubuntu 20.04, which QAPipelineMaster runs)
#   PW_MCP_VERSION    exact @playwright/mcp version; empty = auto-pick the newest release built
#                     on playwright PW_VERSION.x. Exported so run-case.sh launches the same one.
#   PLAYWRIGHT_SKIP_BROWSER_GC  set to 1 by the pipeline: an install must never delete the
#                     browser we run on
set -euo pipefail

echo "== magpie ci-runner =="
echo "shell: $SHELL ($0) | whoami: $(whoami) | node: $(node -v 2>/dev/null || echo none) | date: $(date)"

cd "$(dirname "$0")/.."   # repo root

SET="${SET:-}"
TEST_CASES="${TEST_CASES:-}"
export CASE_TIMEOUT="${CASE_TIMEOUT:-1800}"
export BATCH_SIZE="${BATCH_SIZE:-5}"
# Pin model + effort (run-case.sh passes these to every `claude -p`) so the node's default can't
# silently decide. Default Sonnet 5.5 (user call 2026-08-26: an opus set costs ~10% of the weekly
# Max-20x limit — unsustainable at 3 sets/night; sonnet is near-opus on this scaffolded
# workload at ~1.7x fewer limit-tokens). Per-build override via the Jenkins params — pick opus
# for targeted quality reruns.
export CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-5-5}"
export CLAUDE_EFFORT="${CLAUDE_EFFORT:-medium}"
LFMRC_S3="${LFMRC_S3:-s3://conf.dev.lfm/qa/.lfmrc_qa}"

# Choose what to run: explicit TEST_CASES (ad-hoc) OVERRIDES the SET batch.
if [[ -n "${TEST_CASES//[[:space:]]/}" ]]; then
  BATCH_FILE="$(mktemp -t magpie-adhoc.XXXXXX)"
  echo "# ad-hoc run from TEST_CASES" > "$BATCH_FILE"
  missing=""
  for raw in ${TEST_CASES//,/ }; do
    id="${raw//[[:space:]]/}"; [[ -z "$id" ]] && continue
    [[ "$id" == QA-* ]] || id="QA-${id}"
    if [[ -f "cases/${id}.md" ]]; then echo "$id" >> "$BATCH_FILE"; else missing="${missing} ${id}"; fi
  done
  [[ -n "$missing" ]] && { echo "ERROR: no local case file for:${missing}" >&2; exit 1; }
  echo ">> ad-hoc: $(grep -vcE '^[[:space:]]*(#|$)' "$BATCH_FILE") case(s) from TEST_CASES (SET ignored)"
else
  [[ -n "$SET" ]] || { echo "ERROR: set SET or TEST_CASES" >&2; exit 1; }
  if [[ -f "$SET" ]]; then BATCH_FILE="$SET"; else BATCH_FILE="batches/${SET}.txt"; fi
  [[ -f "$BATCH_FILE" ]] || { echo "ERROR: batch file not found: $BATCH_FILE" >&2; exit 1; }

  # --- live Test Set sync ---
  # The committed batches/<set>.txt + cases/*.md are snapshots: tests added to the Xray Test Set
  # after ingestion never ran, removed ones kept running, edited steps went stale. Rebuild the
  # member list live and ingest/refresh case files (local sections preserved) via Xray GraphQL —
  # same XRAY_CLIENT_ID/SECRET the reporting step already uses. Non-fatal: any failure falls back
  # to the committed snapshot so a Jira/Xray hiccup can't kill the nightly.
  if [[ "${SYNC_SET:-1}" == "1" && "$SET" =~ ^qa-[0-9]+$ ]]; then
    if [[ -n "${XRAY_CLIENT_ID:-}" && -n "${XRAY_CLIENT_SECRET:-}" ]]; then
      SET_KEY="$(echo "$SET" | tr '[:lower:]' '[:upper:]')"
      SYNCED_BATCH="$(mktemp -t magpie-synced.XXXXXX)"
      echo ">> syncing ${SET_KEY} from Xray (SYNC_SET=0 to skip)"
      if python3 bin/sync_set.py "$SET_KEY" "$SYNCED_BATCH"; then
        BATCH_FILE="$SYNCED_BATCH"
      else
        echo ">> WARN: Test Set sync failed — falling back to committed ${BATCH_FILE} (may be stale)"
      fi
    else
      echo ">> WARN: XRAY_CLIENT_ID/SECRET not in env — running committed ${BATCH_FILE} (may be stale)"
    fi
  fi
fi

# --- Claude auth: subscription OAuth token, never a metered API key ---
: "${CLAUDE_CODE_OAUTH_TOKEN:?CLAUDE_CODE_OAUTH_TOKEN must be bound by the pipeline}"
unset ANTHROPIC_API_KEY || true   # if both are set, the API key wins — make sure it can't

# --- App login: pull the same creds file the qa suite uses, map to config/.env ---
# .lfmrc_qa is a structured (YAML-ish) config, NOT a shell env file — parse "key: value" lines.
echo ">> fetching login creds from ${LFMRC_S3}"
LFMRC="$HOME/.lfmrc_qa"
aws s3 cp "$LFMRC_S3" "$LFMRC" >/dev/null

lfm_cred() {   # value of credentials.lfm_qa.<key>  (key = username|password), quotes/CR stripped
  awk -v key="$1" '
    /^credentials:[[:space:]]*$/ { c=1; next }
    c && /^[^[:space:]]/         { c=0 }
    c && /^  lfm_qa:[[:space:]]*$/ { f=1; next }
    f && /^  [^[:space:]]/       { f=0 }
    f && $0 ~ ("^[[:space:]]+" key "[[:space:]]*:") { sub(/^[^:]*:[[:space:]]*/, ""); print; exit }
  ' "$LFMRC" | sed -E 's/^["'"'"']//; s/["'"'"']$//' | tr -d '\r'
}
LFM_EMAIL="$(lfm_cred username)"
LFM_PASSWORD="$(lfm_cred password)"
if [[ -z "$LFM_EMAIL" || -z "$LFM_PASSWORD" ]]; then
  echo "ERROR: could not read credentials.lfm_qa username/password from .lfmrc_qa" >&2
  exit 1
fi
mkdir -p config
umask 077
printf 'LFM_EMAIL=%s\nLFM_PASSWORD=%s\n' "$LFM_EMAIL" "$LFM_PASSWORD" > config/.env   # gitignored
umask 022
[[ -s config/.env ]] || { echo "ERROR: config/.env was not written" >&2; exit 3; }
echo ">> wrote config/.env for ${LFM_EMAIL}"

# --- MCP config for CI ---
# run-case.sh generates a STRICT playwright-only headless config per run and passes it with
# --strict-mcp-config: the committed .mcp.json is never loaded, so atlassian tool schemas can't
# land in a case's context and --image-responses omit is always on. The only CI-specific choice
# left is the browser: chromium (self-contained download, NO root — `chrome` channel needs sudo).
export PLAYWRIGHT_BROWSER=chromium

# --- Pinned Playwright / Playwright-MCP ---
# QAPipelineMaster is Ubuntu 20.04. Playwright 1.63+ refuses to install browsers there, and
# `@latest` let the install step and the MCP drift onto different browser revisions (the install
# GC'd chromium-1247 that the MCP still needed). Pin both to the 1.62 line, never GC, and fail
# HARD if no usable browser ends up on disk — no more silent fallback into a failing smoke gate.
export PLAYWRIGHT_SKIP_BROWSER_GC="${PLAYWRIGHT_SKIP_BROWSER_GC:-1}"
PW_VERSION="${PW_VERSION:-1.62}"
PW_MCP_VERSION="${PW_MCP_VERSION:-}"

# Newest @playwright/mcp release whose playwright / playwright-core dependency is on $1.x
resolve_mcp_version() {
  local want="$1" v deps
  for v in $(npm view @playwright/mcp versions --json 2>/dev/null \
      | python3 -c 'import json,sys; v=json.load(sys.stdin); v=v if isinstance(v,list) else [v]; print("\n".join(reversed(v[-60:])))'); do
    deps="$(npm view "@playwright/mcp@$v" dependencies --json 2>/dev/null || true)"
    if printf '%s' "$deps" | grep -Eq "\"playwright(-core)?\": *\"[~^]?${want//./\\.}\."; then
      echo "$v"
      return 0
    fi
  done
  return 1
}

if [[ -z "$PW_MCP_VERSION" ]]; then
  echo ">> resolving newest @playwright/mcp built on playwright ${PW_VERSION}.x"
  if ! PW_MCP_VERSION="$(resolve_mcp_version "$PW_VERSION")"; then
    echo "ERROR: no @playwright/mcp release found on playwright ${PW_VERSION}.x — set the PW_MCP_VERSION build parameter" >&2
    exit 3
  fi
fi
export PW_VERSION PW_MCP_VERSION
echo ">> pinned playwright@${PW_VERSION} / @playwright/mcp@${PW_MCP_VERSION}"

# run-case.sh builds the MCP config; it must launch the SAME pinned MCP, or it will look for a
# browser revision we didn't install. Refuse to run if it still hardcodes its own version.
if ! grep -q 'PW_MCP_VERSION' bin/run-case.sh; then
  echo "ERROR: bin/run-case.sh does not use \$PW_MCP_VERSION for @playwright/mcp — update it so the" >&2
  echo "       generated MCP config launches @playwright/mcp@\${PW_MCP_VERSION}" >&2
  grep -n '@playwright/mcp' bin/run-case.sh >&2 || true
  exit 3
fi

echo ">> ensuring headless Chromium for Playwright MCP"
# Prefer the MCP's own installer: it installs exactly the revision the MCP will look for.
if ! npx --yes "@playwright/mcp@${PW_MCP_VERSION}" install-browser chrome-for-testing; then
  echo ">> MCP installer failed; trying playwright@${PW_VERSION} CLI"
  if ! npx --yes "playwright@${PW_VERSION}" install chromium; then
    echo "ERROR: chromium install failed for playwright@${PW_VERSION} — not starting the smoke gate" >&2
    ls -la "$HOME/.cache/ms-playwright" 2>/dev/null || true
    exit 3
  fi
fi

if ! ls -1 "$HOME"/.cache/ms-playwright/chromium-*/chrome-linux*/chrome >/dev/null 2>&1; then
  echo "ERROR: no chromium executable in ~/.cache/ms-playwright after install — not starting the smoke gate" >&2
  ls -la "$HOME/.cache/ms-playwright" 2>/dev/null || true
  exit 3
fi
echo ">> browser cache:"
ls -1 "$HOME/.cache/ms-playwright" | sed 's/^/     /'

# --- claude CLI present? (install fallback, matching the qa runner) ---
command -v claude >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code

# --- pre-run orphan sweep ---
# A build that was hard-killed (e.g. the JENKINS-48300 heartbeat kill) can leave its
# Playwright-MCP server + headless chromium running on the node. Those orphans hold RAM/ports and
# can make THIS build's login smoke gate fail to launch a browser. Reap them before we start.
# Only true orphans are touched: MCP servers (a signature the qa `playwright test` suite doesn't
# use) and chromium reparented to init (ppid==1) — a concurrent job's live browser has a live
# parent (ppid!=1) and is left alone.
# NOTE: the MCP pkill is machine-wide — it WOULD kill a concurrent magpie build's MCP. The
# Jenkinsfile's disableConcurrentBuilds() is what makes this safe.
echo ">> pre-run sweep: reaping orphaned Playwright-MCP / chromium from any prior crashed build"
pkill -f '@playwright/mcp' 2>/dev/null && echo "   killed stray @playwright/mcp server(s)" || true
ps -eo pid=,ppid=,args= 2>/dev/null \
  | awk '$2==1 && /ms-playwright/ && /--headless/ {print $1}' \
  | while read -r p; do kill -KILL "$p" 2>/dev/null && echo "   killed orphaned chromium pid $p" || true; done

# --- run (sequential; run-batches.sh does the login smoke gate + checkpoints + resume) ---
echo ">> running ${BATCH_FILE}  [CASE_TIMEOUT=${CASE_TIMEOUT}s BATCH_SIZE=${BATCH_SIZE} model=${CLAUDE_MODEL}@${CLAUDE_EFFORT} max_turns=${MAX_TURNS:-60} mcp=@playwright/mcp@${PW_MCP_VERSION}]"
bin/run-batches.sh "$BATCH_FILE"

# --- surface the run dir + summary for the pipeline to archive ---
RUN_DIR="results/$(date +%F)"
echo ">> done. results in ${RUN_DIR}"
[[ -f "${RUN_DIR}/summary.json" ]] && cat "${RUN_DIR}/summary.json" || true