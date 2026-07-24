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
set -euo pipefail

echo "== magpie ci-runner =="
echo "shell: $SHELL ($0) | whoami: $(whoami) | node: $(node -v 2>/dev/null || echo none) | date: $(date)"

cd "$(dirname "$0")/.."   # repo root

SET="${SET:-}"
TEST_CASES="${TEST_CASES:-}"
export CASE_TIMEOUT="${CASE_TIMEOUT:-1800}"
export BATCH_SIZE="${BATCH_SIZE:-5}"
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
echo ">> wrote config/.env for ${LFM_EMAIL}"

# --- Browser for the Playwright MCP ---
# CI uses Chromium (self-contained download, NO root). The committed .mcp.json stays on the
# `chrome` channel for local headed runs; flip this ephemeral CI checkout to chromium.
# (`chrome` channel and `--with-deps` need sudo, which the agent can't provide.)
sed -i 's/"chrome"/"chromium"/' .mcp.json
echo ">> ensuring headless Chromium for Playwright MCP"
npx --yes playwright install chromium || echo ">> WARN: chromium install failed; relying on a browser already cached on the node"

# --- claude CLI present? (install fallback, matching the qa runner) ---
command -v claude >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code

# --- pre-run orphan sweep ---
# A build that was hard-killed (e.g. the JENKINS-48300 heartbeat kill) can leave its
# Playwright-MCP server + headless chromium running on the node. Those orphans hold RAM/ports and
# can make THIS build's login smoke gate fail to launch a browser. Reap them before we start.
# Only true orphans are touched: MCP servers (a signature the qa `playwright test` suite doesn't
# use) and chromium reparented to init (ppid==1) — a concurrent job's live browser has a live
# parent (ppid!=1) and is left alone.
echo ">> pre-run sweep: reaping orphaned Playwright-MCP / chromium from any prior crashed build"
pkill -f '@playwright/mcp' 2>/dev/null && echo "   killed stray @playwright/mcp server(s)" || true
ps -eo pid=,ppid=,args= 2>/dev/null \
  | awk '$2==1 && /ms-playwright/ && /--headless/ {print $1}' \
  | while read -r p; do kill -KILL "$p" 2>/dev/null && echo "   killed orphaned chromium pid $p" || true; done

# --- run (sequential; run-batches.sh does the login smoke gate + checkpoints + resume) ---
echo ">> running ${BATCH_FILE}  [CASE_TIMEOUT=${CASE_TIMEOUT}s BATCH_SIZE=${BATCH_SIZE}]"
bin/run-batches.sh "$BATCH_FILE"

# --- surface the run dir + summary for the pipeline to archive ---
RUN_DIR="results/$(date +%F)"
echo ">> done. results in ${RUN_DIR}"
[[ -f "${RUN_DIR}/summary.json" ]] && cat "${RUN_DIR}/summary.json" || true
