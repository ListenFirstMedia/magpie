#!/usr/bin/env bash
# Run a single magpie regression case unattended (headless Playwright MCP + claude -p).
#
# Usage:   bin/run-case.sh QA-84193
#          bin/run-case.sh QA-84193 --login-only   # just prove headless SSO, run no case
#
# Prereqs: config/.env holds LFM_EMAIL / LFM_PASSWORD; the case exists at cases/<ID>.md.
#          MCP: a strict playwright-only headless config is generated per run and passed with
#          --strict-mcp-config, so the committed .mcp.json (headed/local, may list atlassian)
#          is never loaded into a case's context.
#
# The full-case prompt is sourced from docs/PROMPT.md (the single-source-of-truth execution guide)
# plus a small UNATTENDED/HEADLESS override, so batch/single runs follow the SAME spec as an
# interactive session. The --login-only smoke gate uses a lightweight preamble.
set -euo pipefail

cd "$(dirname "$0")/.."   # repo root

ID="${1:?usage: run-case.sh <QA-ID> [--login-only]}"
MODE="${2:-full}"
CASE_TIMEOUT="${CASE_TIMEOUT:-900}"   # hard cap per case (seconds); stuck case is killed + marked failed
# Pin model + effort: unpinned `claude -p` inherits the node's default model — pin it so the run
# is deterministic. Default opus (user call 2026-08-13: quality first; switch the default to
# sonnet — ~5x cheaper against the weekly usage limit — if runs keep exhausting the limit).
# Override per-build via the Jenkins CLAUDE_MODEL/CLAUDE_EFFORT params.
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"
CLAUDE_EFFORT="${CLAUDE_EFFORT:-medium}"
# Hard TURN cap alongside the wall-clock cap: a case stuck in a retry loop burns tokens fast for
# the full CASE_TIMEOUT before the monitor kills it — by turn count it dies much cheaper. A killed
# case writes no report -> scored UNKNOWN -> picked up by run-batches' retry sweep, same as a
# timeout. 150 is a LOOP-BREAKER, not a budget: build #76 (2026-08-25) showed normal browser cases
# complete in 26-64 turns, and its 60-cap killed 33/62 cases mid-flight AFTER they'd each already
# spent $1.6-2.5 — a too-tight cap costs the tokens AND loses the verdict. CASE_TIMEOUT stays the
# real cost bound; only lower this if usage.tsv shows loops that the wall clock isn't catching.
MAX_TURNS="${MAX_TURNS:-150}"
DATE="$(date +%F)"
RUN_DIR="${RUN_DIR:-results/${DATE}}"   # honor an inherited RUN_DIR (run-batches.sh pins it) so a
                                     # midnight rollover doesn't scatter reports across date dirs.
CASE_FILE="cases/${ID}.md"
mkdir -p "$RUN_DIR"

# Strict MCP config: exactly ONE server (playwright, headless) loads into the case's context,
# regardless of what the committed .mcp.json says — if atlassian ever connected, its ~80 tool
# schemas would bill EVERY case session. --image-responses omit: screenshots still save to
# .playwright-out/ but are not echoed back into context (a case Reads a PNG only when it must
# judge one visually).
PLAYWRIGHT_BROWSER="${PLAYWRIGHT_BROWSER:-chrome}"   # ci-runner exports chromium (no-root download)
MCP_CONFIG="${RUN_DIR}/.mcp-headless.json"
cat > "$MCP_CONFIG" <<EOF
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest",
               "--browser", "${PLAYWRIGHT_BROWSER}",
               "--isolated", "--headless", "--save-session",
               "--output-dir", "./.playwright-out",
               "--image-responses", "omit",
               "--console-level", "error"]
    }
  }
}
EOF

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

  # Pre-grep the big indexes SHELL-SIDE (free) and inject the hits into the prompt, instead of
  # having the agent grep them itself — each agent grep is a whole turn that re-bills the entire
  # conversation as input, and it risks the model "just reading" a 100KB+ index. Bounded so a
  # chatty index can't bloat the prompt. -w not \b: portable across BSD/GNU grep, and the hyphen
  # in QA-#### makes -w behave as a proper ID boundary.
  SKILL_MATCHES="$(grep -iw "${ID}" skills/REGISTRY.md 2>/dev/null \
                   | grep -oE '\([A-Za-z0-9_-]+/SKILL\.md\)' | tr -d '()' \
                   | sort -u | sed 's|^|skills/|' | head -3 || true)"
  BUG_MATCHES="$(grep -iw -A 8 -m 3 "${ID}" knowledge-base/bug-history.md 2>/dev/null | head -c 3500 || true)"
  QUIRK_MATCHES="$(grep -iw -B 1 -A 8 -m 2 "${ID}" knowledge-base/known-quirks.md 2>/dev/null | head -c 2000 || true)"

  PROMPT="${GUIDE}

═══ THIS RUN — UNATTENDED & HEADLESS (overrides the interactive EXECUTION MODE above) ═══
You are launched via \`claude -p\`, HEADLESS, with NO human to watch the browser or answer
questions. Override the interactive rule that says to STOP on a failure and ask the user:
instead, when a step fails or blocks, MAKE THE CALL YOURSELF using the 5-MINUTE STEP BUDGET and
the SCOPE RULES above, write the report with a clear verdict (PASS / FAIL / BLOCKED / SKIPPED),
and finish. Never wait for input.

The case is ALREADY INGESTED — do NOT re-fetch from Jira (the Atlassian MCP is absent in this
headless run). Read the local file ${CASE_FILE} and execute it IN FULL, every step in order.
The linked/known-bug check and the skill lookup are ALREADY DONE — their grep results are in the
PRE-FETCHED CONTEXT section below; combine them with the case's own notes.

TOKEN ECONOMY (this run bills a shared weekly usage limit — every case session pays for what it
reads, so read narrowly; this overrides the guide's numbered reading list):
- Read IN FULL only: ${CASE_FILE}, docs/env.md (login), skills/_shared/spec-adherence-rules.md,
  and the ONE matching skills/<flow>/SKILL.md (pre-resolved below when found).
- The big indexes were ALREADY GREPPED for ${ID} shell-side — see PRE-FETCHED CONTEXT. Do NOT
  re-grep skills/REGISTRY.md, knowledge-base/bug-history.md or knowledge-base/known-quirks.md
  for ${ID}, and NEVER read any of them in full. Only two narrow follow-up greps are allowed:
  if no skill was pre-resolved, grep skills/REGISTRY.md ONCE by flow/page keyword and open just
  that SKILL.md; and if an assertion result looks like accepted-product behavior, grep
  knowledge-base/known-quirks.md ONCE by the page/feature name.
- Read skills/_shared/playwright-porting.md only if the matching skill still contains un-ported
  Chrome-MCP steps. Skip README.md, glossary.md and app-map.md unless you are genuinely lost.
- Screenshots still save to disk but are NOT echoed back into your context (--image-responses
  omit). When an assertion or a render-hang call truly needs visual inspection, Read the saved
  PNG from .playwright-out/${ID}/ — sparingly, only the shots you must judge.

Save ALL screenshots/snapshots under .playwright-out/${ID}/<name> (never a bare filename).
Write the report to ${RUN_DIR}/${ID}-report.md (steps, assertions table
ID | Step | Expected | Actual | Status, evidence, 'Known bugs checked', 'Bugs filed' markdown-only).
Do NOT do skill/REGISTRY maintenance now — that is deferred to harvest.sh. Be terse in chat.

═══ PRE-FETCHED CONTEXT (grepped shell-side — do not repeat these greps) ═══
Matching skill file(s) from skills/REGISTRY.md:
${SKILL_MATCHES:-none found — grep skills/REGISTRY.md ONCE by flow/page keyword, then open only that SKILL.md}

knowledge-base/bug-history.md matches for ${ID}:
${BUG_MATCHES:-none}

knowledge-base/known-quirks.md matches for ${ID}:
${QUIRK_MATCHES:-none}"
fi

echo ">> ${ID} (${MODE}) — $(date)  [timeout ${CASE_TIMEOUT}s | model ${CLAUDE_MODEL}@${CLAUDE_EFFORT}]"

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
USAGE_JSON="${RUN_DIR}/${ID}-usage.json"
set -m
if [[ "$MODE" == "--login-only" ]]; then
  # Plain text output — the smoke gate greps the tee'd console for 'LOGIN OK'. A login needs only
  # a handful of turns; the tight cap kills a wedged Cognito redirect loop cheaply.
  claude -p "$PROMPT" --model "$CLAUDE_MODEL" --effort "$CLAUDE_EFFORT" \
    --mcp-config "$MCP_CONFIG" --strict-mcp-config --max-turns 15 \
    --dangerously-skip-permissions &
else
  # JSON result envelope -> ${ID}-usage.json: exact turns/tokens/cost per case. The model's final
  # text lands in the envelope's "result" field; it is echoed back to the console below so
  # run-batches' usage-limit grep still sees it.
  claude -p "$PROMPT" --model "$CLAUDE_MODEL" --effort "$CLAUDE_EFFORT" \
    --mcp-config "$MCP_CONFIG" --strict-mcp-config --max-turns "$MAX_TURNS" \
    --output-format json --dangerously-skip-permissions > "$USAGE_JSON" &
fi
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

# Surface the JSON envelope: append a run-level usage ledger row (usage.tsv — gen_report.py adds
# it as columns), log a one-line usage summary, and echo the model's final text so run-batches'
# limit-signal grep (tail of the tee'd log) still works with --output-format json.
if [[ "$MODE" != "--login-only" && -s "$USAGE_JSON" ]]; then
  python3 - "$ID" "$USAGE_JSON" "$RUN_DIR" <<'PY' || echo ">> WARN: could not parse usage json for ${ID}"
import json, os, sys
cid, path, run_dir = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    d = json.load(open(path))
except Exception:
    # Partial/empty file (case killed mid-write, or a non-JSON CLI error) — show the raw tail so
    # any error text (incl. usage-limit messages) still reaches the console log for the grep.
    sys.stdout.write(open(path, errors="ignore").read()[-2000:] + "\n")
    sys.exit(0)
u = d.get("usage") or {}
res = (d.get("result") or "").strip()
row = [cid, d.get("num_turns"), u.get("input_tokens"), u.get("cache_read_input_tokens"),
       u.get("cache_creation_input_tokens"), u.get("output_tokens"),
       round(d.get("total_cost_usd") or 0, 4), d.get("duration_ms"), d.get("subtype")]
ledger = os.path.join(run_dir, "usage.tsv")
new = not os.path.exists(ledger)
with open(ledger, "a") as f:
    if new:
        f.write("id\tturns\tinput\tcache_read\tcache_creation\toutput\tcost_usd\tduration_ms\tsubtype\n")
    f.write("\t".join("" if x is None else str(x) for x in row) + "\n")
print(f">> usage: {d.get('num_turns')} turns | in {u.get('input_tokens', 0)} "
      f"(+{u.get('cache_read_input_tokens', 0)} cache-read, +{u.get('cache_creation_input_tokens', 0)} cache-write) "
      f"| out {u.get('output_tokens', 0)} | est ${(d.get('total_cost_usd') or 0):.2f}")
if d.get("is_error") or d.get("subtype") not in (None, "success"):
    print(f"!! claude ended with subtype={d.get('subtype')}: {res[:400]}")
elif res:
    print(res[:400])
PY
fi

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
