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

# The monitor subshell can't set variables in this shell, so it flags a timeout via this marker.
TIMEOUT_FLAG="${RUN_DIR}/.${ID}.timeout"
rm -f "$TIMEOUT_FLAG"

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

# Monitor: ONE helper that both (a) emits a heartbeat every ~60s so the Jenkins durable-task
# wrapper keeps seeing output (`claude -p` is otherwise silent until it finishes → JENKINS-48300
# false-kill), and (b) enforces the hard per-case timeout (macOS has no `timeout` binary).
#
# It polls in short 5s sleeps and self-exits the instant claude finishes. This is deliberate: a
# single long `sleep "$CASE_TIMEOUT"` runs as a grandchild that `kill $PID` on the subshell does
# NOT reap — the orphaned sleep would keep run-case.sh's stdout (the pipe to `tee` in
# run-batches.sh) open until the FULL timeout elapsed, padding every case out to CASE_TIMEOUT
# regardless of how fast it actually ran. Short sleeps cap that leak at ~5s.
(
  waited=0; since_beat=0
  while kill -0 "$CLAUDE_PID" 2>/dev/null; do
    sleep 5; waited=$((waited+5)); since_beat=$((since_beat+5))
    if [ "$since_beat" -ge 60 ]; then
      since_beat=0
      echo ">> .. ${ID} still running (${waited}s / ${CASE_TIMEOUT}s cap) — $(date +%H:%M:%S)"
    fi
    if [ "$waited" -ge "$CASE_TIMEOUT" ]; then
      echo ">> TIMEOUT after ${CASE_TIMEOUT}s — killing ${ID} (process group)"
      : > "$TIMEOUT_FLAG"
      reap_group "$CLAUDE_PID"
      break
    fi
  done
) &
MONITOR_PID=$!
# Drop the monitor from the job table: we kill it below while it may still be mid-reap, and bash
# would otherwise echo a "Terminated" job notice that dumps this whole subshell into the console log.
disown "$MONITOR_PID" 2>/dev/null || true

# `|| RC=$?` is required, not stylistic: under `set -e` a bare failing `wait` (which is exactly what
# happens when the monitor kills a timed-out case) exits run-case.sh on the spot, skipping the reap,
# the TIMEOUT report and the final `>> done` line. That silent early exit is why timed-out cases used
# to leave no report at all and get mis-scored as BLOCKED.
RC=0
wait "$CLAUDE_PID" 2>/dev/null || RC=$?
kill "$MONITOR_PID" 2>/dev/null || true   # stop the monitor; its worst-case orphaned sleep is 5s

# Reap the case's MCP server + any orphaned chromium, scoped to THIS case's process group
# (never a machine-wide pkill — safe when sibling cases share the node under parallel runs).
reap_group "$CLAUDE_PID"

# A reaped case writes no report, and a missing report is otherwise scored BLOCKED — which reads as
# an app/environment block when in fact the case never reached a verdict. Leave an explicit TIMEOUT
# report so the summary, the HTML report and Xray all say "ran out of time", not "blocked".
REPORT="${RUN_DIR}/${ID}-report.md"
if [[ -f "$TIMEOUT_FLAG" && ! -f "$REPORT" ]]; then
  cat > "$REPORT" <<EOF
# ${ID} — TIMEOUT

Verdict: TIMEOUT — killed at the ${CASE_TIMEOUT}s per-case cap ($(date)).

The case was still executing when \`CASE_TIMEOUT\` elapsed, so its process group (claude +
Playwright MCP + headless chromium) was reaped before it could write a report. **No assertion was
evaluated** — this is not a product failure and not an environment block; the case simply ran out of
wall clock. Re-run it with a larger \`CASE_TIMEOUT\` (the CI default is 1800s).

| Field | Value |
|-------|-------|
| Case | ${ID} |
| Cap | ${CASE_TIMEOUT}s |
| Killed at | $(date) |
| Console log | ${RUN_DIR}/_batch-*.log (grep ${ID}) |
| Screenshots | .playwright-out/${ID}/ (partial, if any) |

Known bugs checked: not reached.
Bugs filed: none.
EOF
  rm -f "$TIMEOUT_FLAG"
fi

echo ">> done (rc=${RC}) — report: ${REPORT}"
