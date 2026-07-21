#!/usr/bin/env bash
# magpie CI runner — the build step invoked by the "magpie-tests-runner" Jenkins job.
#
# Unlike the qa Playwright runner (npx playwright test --grep @CASE_...), magpie's cases are
# executed BY Claude via the Playwright MCP: this script just prepares the environment and hands
# off to bin/run-batches.sh, which runs the set sequentially (login smoke gate -> batches ->
# results/<date>/*.md + summary.json). Runs on a Linux node inside the LFM network.
#
# Inputs (env, set by the Jenkins job):
#   SET               batch name under batches/ (e.g. qa4325) OR a path to a batch file
#   CASE_TIMEOUT      per-case hard cap in seconds (default 1800 — long cases need it)
#   BATCH_SIZE        cases per checkpoint (default 5)
#   CLAUDE_CODE_OAUTH_TOKEN   from `claude setup-token`, bound by the pipeline (subscription auth)
#   LFMRC_S3          override for the creds file (default s3://conf.dev.lfm/qa/.lfmrc_qa)
set -euo pipefail

echo "== magpie ci-runner =="
echo "shell: $SHELL ($0) | whoami: $(whoami) | node: $(node -v 2>/dev/null || echo none) | date: $(date)"

cd "$(dirname "$0")/.."   # repo root

SET="${SET:?SET is required (batch name under batches/, or a path to a batch file)}"
export CASE_TIMEOUT="${CASE_TIMEOUT:-1800}"
export BATCH_SIZE="${BATCH_SIZE:-5}"
LFMRC_S3="${LFMRC_S3:-s3://conf.dev.lfm/qa/.lfmrc_qa}"

# Resolve the batch file: accept either "qa4325" or "batches/qa4325.txt" or a full path.
if [[ -f "$SET" ]]; then BATCH_FILE="$SET"; else BATCH_FILE="batches/${SET}.txt"; fi
[[ -f "$BATCH_FILE" ]] || { echo "ERROR: batch file not found: $BATCH_FILE" >&2; exit 1; }

# --- Claude auth: subscription OAuth token, never a metered API key ---
: "${CLAUDE_CODE_OAUTH_TOKEN:?CLAUDE_CODE_OAUTH_TOKEN must be bound by the pipeline}"
unset ANTHROPIC_API_KEY || true   # if both are set, the API key wins — make sure it can't

# --- App login: pull the same creds file the qa suite uses, map to config/.env ---
# .lfmrc_qa is a structured (YAML-ish) config, NOT a shell env file — parse "key: value" lines.
echo ">> fetching login creds from ${LFMRC_S3}"
LFMRC="$HOME/.lfmrc_qa"
aws s3 cp "$LFMRC_S3" "$LFMRC" >/dev/null

echo ">> .lfmrc_qa structure (values redacted):"
sed -E 's/(:)[[:space:]]*.+/\1 <redacted>/' "$LFMRC" || true

yaml_val() {   # first "key: value" for any of the alternated keys (top-level or indented), unquoted
  grep -iE "^[[:space:]]*(${1})[[:space:]]*:" "$LFMRC" | head -1 \
    | sed -E 's/^[^:]*:[[:space:]]*//; s/^["'"'"']//; s/["'"'"']$//' | tr -d '\r'
}
LFM_EMAIL="$(yaml_val 'email|username|user|login')"
LFM_PASSWORD="$(yaml_val 'password|passwd|pass')"
if [[ -z "$LFM_EMAIL" || -z "$LFM_PASSWORD" ]]; then
  echo "ERROR: could not find email/password keys in .lfmrc_qa (see redacted structure above)" >&2
  exit 1
fi
mkdir -p config
umask 077
printf 'LFM_EMAIL=%s\nLFM_PASSWORD=%s\n' "$LFM_EMAIL" "$LFM_PASSWORD" > config/.env   # gitignored
echo ">> wrote config/.env for ${LFM_EMAIL}"

# --- Browser for the Playwright MCP (.mcp.json uses --browser chrome --headless) ---
echo ">> ensuring headless Chrome for Playwright MCP"
npx --yes playwright install --with-deps chrome || npx --yes playwright install chrome

# --- claude CLI present? (install fallback, matching the qa runner) ---
command -v claude >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code

# --- run the set (sequential; run-batches.sh does the login smoke gate + checkpoints + resume) ---
echo ">> running set '${SET}' from ${BATCH_FILE}  [CASE_TIMEOUT=${CASE_TIMEOUT}s BATCH_SIZE=${BATCH_SIZE}]"
bin/run-batches.sh "$BATCH_FILE"

# --- surface the run dir + summary for the pipeline to archive ---
RUN_DIR="results/$(date +%F)"
echo ">> done. results in ${RUN_DIR}"
[[ -f "${RUN_DIR}/summary.json" ]] && cat "${RUN_DIR}/summary.json" || true
