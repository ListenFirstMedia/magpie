#!/usr/bin/env bash
# Run a single magpie regression case unattended (headless Playwright MCP + claude -p).
#
# Usage:   bin/run-case.sh QA-84193
#          bin/run-case.sh QA-84193 --login-only   # just prove headless SSO, run no case
#
# Prereqs: .mcp.json has the playwright server with --headless; config/.env holds
#          LFM_EMAIL / LFM_PASSWORD; the case exists at cases/<ID>.md.
#
# The full-case prompt is sourced from docs/PROMPT.md (the single-source-of-truth execution guide)
# plus a small UNATTENDED/HEADLESS override, so batch/single runs follow the SAME spec as an
# interactive session. The --login-only smoke gate uses a lightweight preamble.
set -euo pipefail

cd "$(dirname "$0")/.."   # repo root

ID="${1:?usage: run-case.sh <QA-ID> [--login-only]}"
MODE="${2:-full}"
CASE_TIMEOUT="${CASE_TIMEOUT:-900}"   # hard cap per case (seconds); stuck case is killed + marked failed
DATE="$(date +%F)"
RUN_DIR="${RUN_DIR:-results/${DATE}}"   # honor an inherited RUN_DIR (run-batches.sh pins it) so a
                                     # midnight rollover doesn't scatter reports across date dirs.
CASE_FILE="cases/${ID}.md"
mkdir -p "$RUN_DIR"

if [[ "$MODE" != "--login-only" && ! -f "$CASE_FILE" ]]; then
  echo "ERROR: case file not found: $CASE_FILE" >&2
  exit 1
fi

if [[ "$MODE" == "--login-only" ]]; then
  # Lightweight connectivity/SSO smoke gate — not a test case, so it doesn't need the full guide.
  read -r -d '' PROMPT <<'EOF' || true
You are running the magpie regression-testing framework (feature/playwright-mcp branch)
at ~/git/magpie, HEADLESS and UNATTENDED. No human can approve prompts or read chat.
Read docs/env.md for the programmatic login.

PRE-FLIGHT: browser_navigate to https://app.lfmdev.in; when redirected to the Cognito hosted UI,
fill the "With existing account" form (Email + Password) from config/.env and click THAT form's
Sign in button (not the Corporate/SSO one). Confirm app.lfmdev.in/#home renders (title
"Home - ListenFirst").

TASK: Do ONLY the pre-flight login. Then report exactly one line to chat:
'LOGIN OK <current-url>' on success, or 'LOGIN FAIL <reason>' on failure. Do nothing else.
EOF
else
  # Extract the authoritative fenced prompt block from docs/PROMPT.md (single source of truth).
  GUIDE="$(awk '/^```/{ if (b) exit; else { b=1; next } } b' docs/PROMPT.md)"
  if [[ -z "$GUIDE" ]]; then
    echo "ERROR: could not extract the prompt block from docs/PROMPT.md" >&2
    exit 1
  fi

  PROMPT="${GUIDE}

═══ THIS RUN — UNATTENDED & HEADLESS (overrides the interactive EXECUTION MODE above) ═══
You are launched via \`claude -p\`, HEADLESS, with NO human to watch the browser or answer
questions. Override the interactive rule that says to STOP on a failure and ask the user:
instead, when a step fails or blocks, MAKE THE CALL YOURSELF using the 5-MINUTE STEP BUDGET and
the SCOPE RULES above, write the report with a clear verdict (PASS / FAIL / BLOCKED / SKIPPED),
and finish. Never wait for input.

The case is ALREADY INGESTED — do NOT re-fetch from Jira (the Atlassian MCP is absent in this
headless run). Read the local file ${CASE_FILE} and execute it IN FULL, every step in order.
Still do the linked/known-bug check from knowledge-base/bug-history.md (grep ${ID}) plus the
case's own notes, and reuse the matching skill from skills/REGISTRY.md.

Save ALL screenshots/snapshots under .playwright-out/${ID}/<name> (never a bare filename).
Write the report to ${RUN_DIR}/${ID}-report.md (steps, assertions table
ID | Step | Expected | Actual | Status, evidence, 'Known bugs checked', 'Bugs filed' markdown-only).
Do NOT do skill/REGISTRY maintenance now — that is deferred to harvest.sh. Be terse in chat."
fi

echo ">> ${ID} (${MODE}) — $(date)  [timeout ${CASE_TIMEOUT}s]"

# Reap the whole process GROUP led by $1 (the case's claude + node Playwright-MCP + headless
# chromium). A process keeps its group even after being reparented to init when its parent
# exits, so `kill -- -PGID` still reaches orphaned browsers that a parent-tree walk (pgrep -P)
# can no longer find — that orphaned-chromium pileup is what starved the CI node. Scoped to
# THIS case's group, so it never touches a sibling case sharing the node (unlike a global pkill).
reap_group() {
  kill -TERM -- "-$1" 2>/dev/null || true
  sleep 2
  kill -KILL -- "-$1" 2>/dev/null || true
}

# Run claude in its OWN process group so we can reap the entire case tree (node Playwright-MCP
# + headless chromium) without touching a sibling case on the same node. `set -m` (job control)
# puts each backgrounded job in a fresh process group whose PGID == the job PID; portable to
# macOS + Linux (no `setsid` needed).
set -m
claude -p "$PROMPT" --dangerously-skip-permissions &
CLAUDE_PID=$!          # == this case's process-group id (PGID)
set +m

# Watchdog: hard per-case timeout (macOS has no `timeout` binary). On overrun, reap the group.
(
  sleep "$CASE_TIMEOUT"
  if kill -0 "$CLAUDE_PID" 2>/dev/null; then
    echo ">> TIMEOUT after ${CASE_TIMEOUT}s — killing ${ID} (process group)"
    reap_group "$CLAUDE_PID"
  fi
) &
WATCHDOG_PID=$!

# Heartbeat: emit a line every 60s while the case runs. `claude -p` is otherwise silent until
# it finishes, so a long case leaves the Jenkins durable-task wrapper with no fresh output and
# it false-kills the step ("wrapper script does not seem to be touching the log file",
# JENKINS-48300). This keeps output flowing. (run-batches.sh tees run-case stdout to the console.)
(
  t=0
  while kill -0 "$CLAUDE_PID" 2>/dev/null; do
    sleep 60; t=$((t+60))
    echo ">> .. ${ID} still running (${t}s / ${CASE_TIMEOUT}s cap) — $(date +%H:%M:%S)"
  done
) &
HEARTBEAT_PID=$!

wait "$CLAUDE_PID" 2>/dev/null
RC=$?
kill "$WATCHDOG_PID" "$HEARTBEAT_PID" 2>/dev/null   # cancel helpers once the case finishes

# Reap the case's MCP server + any orphaned chromium, scoped to THIS case's process group
# (never a machine-wide pkill — safe when sibling cases share the node under parallel runs).
reap_group "$CLAUDE_PID"

echo ">> done (rc=${RC}) — report: ${RUN_DIR}/${ID}-report.md"
