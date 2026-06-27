#!/usr/bin/env bash
# Run a single magpie regression case unattended (headless Playwright MCP + claude -p).
#
# Usage:   scripts/run-case.sh QA-84193
#          scripts/run-case.sh QA-84193 --login-only   # just prove headless SSO, run no case
#
# Prereqs: .mcp.json has the playwright server with --headless; config/.env holds
#          LFM_EMAIL / LFM_PASSWORD; the case exists at testcases/english/<ID>.md.
set -euo pipefail

cd "$(dirname "$0")/.."   # repo root

ID="${1:?usage: run-case.sh <QA-ID> [--login-only]}"
MODE="${2:-full}"
CASE_TIMEOUT="${CASE_TIMEOUT:-900}"   # hard cap per case (seconds); stuck case is killed + marked failed
DATE="$(date +%F)"
RUN_DIR="runs/${DATE}"
CASE_FILE="testcases/english/${ID}.md"
mkdir -p "$RUN_DIR"

if [[ "$MODE" != "--login-only" && ! -f "$CASE_FILE" ]]; then
  echo "ERROR: case file not found: $CASE_FILE" >&2
  exit 1
fi

read -r -d '' COMMON <<'EOF' || true
You are running the magpie regression-testing framework (feature/playwright-mcp branch)
at ~/git/magpie, HEADLESS and UNATTENDED. No human can approve prompts or read chat.

Read first, in order:
1. skills/_shared/spec-adherence-rules.md  (the 6 hard rules — non-negotiable)
2. config/env.md                            (pre-flight + programmatic login)
3. knowledge-base/known-quirks.md

PRE-FLIGHT (always): browser_navigate to https://app.lfmdev.in; when redirected to the
Cognito hosted UI, fill the "With existing account" form (Email + Password) from config/.env
and click THAT form's Sign in button (not the Corporate/SSO one). Confirm app.lfmdev.in/#home
renders (title "Home - ListenFirst"). If login fails (still on auth.lfmdev.in), abort.
EOF

if [[ "$MODE" == "--login-only" ]]; then
  PROMPT="$COMMON

TASK: Do ONLY the pre-flight login. Then report exactly one line to chat:
'LOGIN OK <current-url>' on success, or 'LOGIN FAIL <reason>' on failure. Do nothing else."
else
  PROMPT="$COMMON
4. The skill that covers this flow — scan skills/REGISTRY.md and read the matching SKILL.md.

TASK: Execute test case ${CASE_FILE} in full — every step, in order, applying all 6
spec-adherence rules (exact brand from the typeahead Results; explicit toggle clicks; never
fake a download/export verification). Reuse the matching skill; do not improvise brands/dates.

ARTIFACTS: Save ALL screenshots and page snapshots under .playwright-out/${ID}/<name> —
always pass that full relative path to browser_take_screenshot / browser_snapshot. NEVER pass a
bare filename: a bare filename lands in the repo root and clutters it (see known-quirks.md).

OUTPUT: Write ${RUN_DIR}/${ID}-report.md with: steps executed, an assertions table
(ID | Step | Expected | Actual | Status), evidence (exact numbers/text, screenshot refs under
.playwright-out/${ID}/), and a 'Bugs filed' section (markdown only — never create Jira tickets).
Be terse in chat; verbose in the report file."
fi

echo ">> ${ID} (${MODE}) — $(date)  [timeout ${CASE_TIMEOUT}s]"

# Run claude in the background and enforce a hard per-case timeout via a watchdog
# (macOS has no `timeout` binary). On overrun, kill the case and its child browser.
claude -p "$PROMPT" --dangerously-skip-permissions &
CLAUDE_PID=$!
(
  sleep "$CASE_TIMEOUT"
  if kill -0 "$CLAUDE_PID" 2>/dev/null; then
    echo ">> TIMEOUT after ${CASE_TIMEOUT}s — killing ${ID}"
    pkill -P "$CLAUDE_PID" 2>/dev/null
    kill -9 "$CLAUDE_PID" 2>/dev/null
  fi
) &
WATCHDOG_PID=$!
wait "$CLAUDE_PID" 2>/dev/null
RC=$?
kill "$WATCHDOG_PID" 2>/dev/null   # cancel watchdog if the case finished on its own

# Reap any browser the case left behind (safe while runs are sequential).
pkill -f "ms-playwright-mcp" 2>/dev/null || true
pkill -f "@playwright/mcp"   2>/dev/null || true

echo ">> done (rc=${RC}) — report: ${RUN_DIR}/${ID}-report.md"
