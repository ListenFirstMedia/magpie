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

STEP TIME BUDGET — 5 MINUTES MAX PER STEP (hard rule):
Never wait on or retry a single step/render for more than ~5 minutes. Use BOUNDED waits
(browser_wait_for with an explicit short timeout), never open-ended ones. If a page, chart,
tile, or element has NOT finished rendering within ~5 minutes on one step:
  1. STOP waiting. Take a screenshot to .playwright-out/${ID}/<step>-stuck.png.
  2. ANALYZE it yourself (you are multimodal): read that screenshot PLUS the DOM
     (browser_snapshot / browser_evaluate) and decide what is actually happening —
     stuck spinner, partial render, error banner, unexpected state, or it already rendered
     something you can use.
  3. MAKE A CALL — do not hang:
     - Transient hang → ONE reload + retry (still inside the 5-min budget).
     - Already usable → proceed and read the value.
     - Still stuck → the WHOLE CASE is BLOCKED. Write the report with verdict
       'BLOCKED - render-hang at step N' (cite the screenshot) and STOP. Do not continue or
       report a partial PASS — one stuck in-scope step makes the case result untrustworthy.
  EXCEPTIONS (these do NOT block the whole case):
     - A stuck/unavailable GOOGLE SHEETS step → just skip it (out of scope) and keep judging the
       case on the in-scope assertions (PASS still possible).
     - An external-user precondition → the whole case is SKIPPED (not BLOCKED) — see SCOPE RULES.

SCOPE RULES (apply before and during execution):
- EXTERNAL-USER / SECOND-IDENTITY cases: if the preconditions require authenticating as a
  DIFFERENT user identity than config/.env (e.g. an 'External' role user, or signing in as a
  second account) — which in-app account-switching CANNOT satisfy — do NOT attempt the flow.
  Immediately write the report with verdict 'SKIPPED - external-user precondition (deferred)'
  and stop. Do not spend the timeout exploring. (Account/brand SWITCHES of the SAME user are fine.)
- GOOGLE SHEETS is OUT OF SCOPE (Google 2FA). Execute every OTHER step of the case normally;
  SKIP only the Google Sheets steps/assertions (never open docs.google.com). Judge the case on
  the IN-SCOPE (non-GS) assertions only: if those pass, the verdict is PASS — add a note
  'GS steps skipped (out of scope)'. Do NOT mark the whole case BLOCKED merely because the GS
  assertion was skipped. (CSV/TSV/XLS exports stay in scope and must be verified on disk.)

ARTIFACTS: Save ALL screenshots and page snapshots under .playwright-out/${ID}/<name> —
always pass that full relative path to browser_take_screenshot / browser_snapshot. NEVER pass a
bare filename: a bare filename lands in the repo root and clutters it (see known-quirks.md).

OUTPUT: Write ${RUN_DIR}/${ID}-report.md with: steps executed, an assertions table
(ID | Step | Expected | Actual | Status), evidence (exact numbers/text, screenshot refs under
.playwright-out/${ID}/), and a 'Bugs filed' section (markdown only — never create Jira tickets).
Be terse in chat; verbose in the report file."
fi

echo ">> ${ID} (${MODE}) — $(date)  [timeout ${CASE_TIMEOUT}s]"

# Recursively kill a process and ALL descendants (claude spawns node MCP + chrome children
# that survive a kill of the parent PID alone — the bug behind 90-min "capped" cases).
kill_tree() {
  local pid=$1 child
  for child in $(pgrep -P "$pid" 2>/dev/null); do kill_tree "$child"; done
  kill -9 "$pid" 2>/dev/null
}

# Run claude in the background and enforce a hard per-case timeout via a watchdog
# (macOS has no `timeout` binary). On overrun, kill the whole process tree.
claude -p "$PROMPT" --dangerously-skip-permissions &
CLAUDE_PID=$!
(
  sleep "$CASE_TIMEOUT"
  if kill -0 "$CLAUDE_PID" 2>/dev/null; then
    echo ">> TIMEOUT after ${CASE_TIMEOUT}s — killing ${ID} (process tree)"
    kill_tree "$CLAUDE_PID"
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
