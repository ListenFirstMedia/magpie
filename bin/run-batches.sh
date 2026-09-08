#!/usr/bin/env bash
# Run magpie regression cases in batches of N (default 5), unattended headless.
#
# Usage:   bin/run-batches.sh                 # all cases in cases/
#          bin/run-batches.sh batches/daily.txt   # only IDs listed in a file (one per line)
#          BATCH_SIZE=5 bin/run-batches.sh
#
# Behaviour:
#   1. One login pre-flight smoke gate up front; abort the whole run if the app is down.
#   2. Run cases sequentially, grouped into batches of BATCH_SIZE (checkpoint after each batch).
#   3. Parse PASS/FAIL/BLOCKED from each case report; write results/<date>/summary.json (rebuilt
#      after every batch so progress survives an interrupt).
set -uo pipefail
cd "$(dirname "$0")/.."

BATCH_SIZE="${BATCH_SIZE:-5}"
# On a Claude usage/session limit (or transient rate-limit/overload):
#   ON_LIMIT=wait (default) → sleep LIMIT_WAIT and auto-resume the SAME case, up to MAX_LIMIT_WAITS
#                             times (poll-until-reset). Unattended-friendly; no manual re-run needed.
#   ON_LIMIT=stop           → exit cleanly and resume on the next invocation (old behavior).
ON_LIMIT="${ON_LIMIT:-wait}"
LIMIT_WAIT="${LIMIT_WAIT:-1800}"          # sleep between resume attempts, seconds (default 30 min)
MAX_LIMIT_WAITS="${MAX_LIMIT_WAITS:-48}"  # safety cap: 48 x 30min ~= 24h of waiting before giving up
CASE_TIMEOUT="${CASE_TIMEOUT:-900}"       # per-case hard cap for the main pass (ci-runner sets 1800)

# Retry sweep: after the main pass, re-run cases that reached NO verdict (TIMEOUT = killed at the
# cap, UNKNOWN = crashed / wrote no parsable verdict). A case killed at the wall is usually just
# slow, not broken — on the 2026-07-29 run that was 21 of 64 cases, all reported as BLOCKED.
# Retrying at the END rather than in place keeps the first pass fast (a whole batch isn't held up
# by one slow case) and gives the retry a quieter node.
#
# The sweep is HARD-BOUNDED so it can't blow up a nightly build: at most RETRY_MAX cases per round
# at RETRY_CASE_TIMEOUT each (default 2 x 900s = 30 min of sweep, worst case). Cases beyond the cap
# keep their TIMEOUT/UNKNOWN verdict and are logged by name — never silently dropped.
#
# NOTE: RETRY_CASE_TIMEOUT is a FIXED 900s, not a multiple of CASE_TIMEOUT. CI runs the main pass at
# CASE_TIMEOUT=1800 (ci-runner.sh), so a swept case gets LESS wall clock than the attempt that
# already timed out — the sweep is there to recover crashes and flaky-slow cases cheaply, not to
# give genuinely long cases the time they need. Raise RETRY_CASE_TIMEOUT if you want the latter.
#
# 2026-09-08 (after build #102, the first sonnet-default run): the sweep used to inherit the SAME
# turn cap the case had just exhausted, so a turn-capped case was certain to exhaust it again —
# paying the full case cost a second time for nothing. Sonnet needs ~2-3x opus's turns for the same
# verification (12 of 64 cases hit the 150-turn cap on #102; a turn-killed case writes no report and
# scores UNKNOWN), so the sweep now gets +100 turns. Wall clock and case count are UNCHANGED: the
# sweep is still bounded at RETRY_MAX x RETRY_CASE_TIMEOUT.
RETRY_NO_VERDICT="${RETRY_NO_VERDICT:-1}"          # 0 disables the sweep entirely
RETRY_ROUNDS="${RETRY_ROUNDS:-1}"                  # how many sweeps to attempt
RETRY_MAX="${RETRY_MAX:-2}"                        # max cases retried per round (0 = unlimited)
RETRY_CASE_TIMEOUT="${RETRY_CASE_TIMEOUT:-900}"    # per-case cap during a sweep
RETRY_MAX_TURNS="${RETRY_MAX_TURNS:-0}"            # turn cap during a sweep (0 = +100 over the main pass)
DATE="$(date +%F)"
RUN_DIR="results/${DATE}"
export RUN_DIR DATE   # pin the run dir and share it with run-case.sh so a midnight date rollover
                      # can't split reports into results/<next-day>/ and mis-score them as BLOCKED.
RESULTS="${RUN_DIR}/results.tsv"
SUMMARY="${RUN_DIR}/summary.json"
mkdir -p "$RUN_DIR"

# --- build case list ---
CASES=()
if [[ $# -ge 1 && -f "$1" ]]; then
  while IFS= read -r line; do CASES+=("$line"); done < <(grep -vE '^[[:space:]]*(#|$)' "$1")
  SOURCE="$1"
else
  while IFS= read -r line; do CASES+=("$line"); done < <(ls cases/*.md | grep -v _TEMPLATE | xargs -n1 basename | sed 's/\.md$//' | sort)
  SOURCE="cases (all)"
fi
TOTAL=${#CASES[@]}
NBATCH=$(( (TOTAL + BATCH_SIZE - 1) / BATCH_SIZE ))
echo "== batch run: ${TOTAL} cases from ${SOURCE}, ${NBATCH} batches of ${BATCH_SIZE} =="

: > "$RESULTS"   # truncate this run's results ledger

rebuild_summary() {
  python3 - "$RESULTS" "$SUMMARY" "$DATE" "$TOTAL" <<'PY'
import json, sys
results_path, summary_path, date, total = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
VALID = {"PASS", "FAIL", "BLOCKED", "SKIPPED", "TIMEOUT", "UNKNOWN"}
# De-dupe by case id (last verdict wins) and drop malformed rows, so a stray/duplicate
# ledger line can't inflate the count or corrupt the Xray import downstream.
by_id, order = {}, []
for line in open(results_path):
    line = line.rstrip("\n")
    if not line: continue
    parts = line.split("\t")
    if len(parts) < 2 or parts[1] not in VALID: continue
    cid = parts[0]
    if cid not in by_id: order.append(cid)
    by_id[cid] = {"id": cid, "status": parts[1], "report": parts[2] if len(parts) > 2 else ""}
cases = [by_id[c] for c in order]
counts = {}
for c in cases: counts[c["status"]] = counts.get(c["status"], 0) + 1
json.dump({"date":date,"total":total,"run":len(cases),
           "passed":counts.get("PASS",0),"failed":counts.get("FAIL",0),
           "blocked":counts.get("BLOCKED",0),"skipped":counts.get("SKIPPED",0),
           "timeout":counts.get("TIMEOUT",0),"unknown":counts.get("UNKNOWN",0),
           "cases":cases}, open(summary_path,"w"), indent=2)
PY
}

status_of() {  # parse a case report for its result; echo PASS/FAIL/BLOCKED/SKIPPED/TIMEOUT/UNKNOWN
  local report="$1" line
  # No report at all means the case produced no verdict (crash, or killed before it could write).
  # Score that UNKNOWN, never BLOCKED: BLOCKED is a real verdict ("stage unreachable", "no test
  # data") and conflating the two hid 21 timeout kills as environment blocks in the 2026-07-29 run.
  [[ -f "$report" ]] || { echo "UNKNOWN"; return; }
  line=$(grep -iE '(result|verdict|status):' "$report" | head -1)   # verdict wording varies: Result:/Verdict:/Status:
  # Take the status keyword AFTER the label, and use the LEFTMOST match — so
  # "BLOCKED - pre-flight login failure" resolves to BLOCKED, not FAIL (the word "failure").
  local rest first
  rest=${line#*:}
  first=$(printf '%s' "$rest" | grep -oiE 'passed|pass|skipped|skip|blocked|block|timed out|timeout|failed|fail' | head -1 | tr 'A-Z' 'a-z')
  case "$first" in
    pass*)  echo "PASS";    return;;
    skip*)  echo "SKIPPED"; return;;
    block*) echo "BLOCKED"; return;;
    time*)  echo "TIMEOUT"; return;;
    fail*)  echo "FAIL";    return;;
  esac
  if grep -qiE 'smoke-failure|LOGIN FAIL|BLOCKED' "$report"; then echo "BLOCKED"; else echo "UNKNOWN"; fi
}

run_one() {  # run ONE case to completion, waiting out Claude usage/rate limits.
             # $1 = case id, $2 = console log to tee into, $3 = per-case hard cap (seconds).
             # The cap is passed as a command-prefix assignment so it is exported to run-case.sh
             # even when CASE_TIMEOUT isn't exported in this shell (standalone, no ci-runner).
  local id="$1" log="$2" cap="$3"
  local report="${RUN_DIR}/${id}-report.md" waits=0
  while :; do
    CASE_TIMEOUT="$cap" bin/run-case.sh "$id" 2>&1 | tee -a "$log" || true
    if tail -8 "$log" | grep -qiE 'session limit|hit your .*limit|usage limit|rate.?limit|overloaded|status 429'; then
      # No trustworthy result was produced — drop any partial/UNKNOWN report so the retry re-judges.
      [[ "$(status_of "$report")" == "UNKNOWN" ]] && rm -f "$report"
      if [[ "$ON_LIMIT" == "wait" && $waits -lt $MAX_LIMIT_WAITS ]]; then
        waits=$((waits+1))
        echo "!! usage/rate limit at ${id} — waiting ${LIMIT_WAIT}s then resuming (attempt ${waits}/${MAX_LIMIT_WAITS}) $(date)"
        rebuild_summary   # checkpoint before the long sleep
        sleep "$LIMIT_WAIT"
        continue          # retry the SAME case after the window (may reset) — loops until it clears or cap hit
      fi
      printf '%s\t%s\t%s\n' "$id" "$(status_of "$report")" "$report" >> "$RESULTS"
      rebuild_summary
      echo "!! usage/session limit at ${id}; ON_LIMIT=${ON_LIMIT} / max waits reached — stopping cleanly at $(date). Re-run to resume."
      exit 3
    fi
    break   # case finished without a limit signal
  done
}

# --- smoke gate (with retries) ---
# The login pre-flight can fail transiently: app still bootstrapping, a slow browser launch, or a
# leftover orphan from a prior crashed build. Retry a few times with backoff before aborting the
# whole run, so one blip doesn't waste the build. (ci-runner.sh sweeps orphans before we get here.)
SMOKE_TRIES="${SMOKE_TRIES:-3}"
SMOKE_WAIT="${SMOKE_WAIT:-30}"
smoke_ok=0
for ((attempt=1; attempt<=SMOKE_TRIES; attempt++)); do
  echo ">> smoke gate: login pre-flight (attempt ${attempt}/${SMOKE_TRIES})"
  # tee (overwrite) so the console shows the attempt and _smoke.log holds the latest result.
  bin/run-case.sh "${CASES[0]}" --login-only 2>&1 | tee "${RUN_DIR}/_smoke.log" || true
  if grep -q "LOGIN OK" "${RUN_DIR}/_smoke.log"; then smoke_ok=1; break; fi
  echo "!! smoke gate attempt ${attempt} did not report LOGIN OK"
  if [[ $attempt -lt $SMOKE_TRIES ]]; then echo ">> retrying in ${SMOKE_WAIT}s"; sleep "$SMOKE_WAIT"; fi
done
if [[ $smoke_ok -ne 1 ]]; then
  echo "!! smoke gate FAILED after ${SMOKE_TRIES} attempts — login never reported LOGIN OK. Aborting. See ${RUN_DIR}/_smoke.log"
  exit 2
fi
echo ">> smoke gate passed"

# --- run in batches ---
idx=0; batch=0
while [[ $idx -lt $TOTAL ]]; do
  batch=$((batch+1))
  echo "== batch ${batch}/${NBATCH} =="
  for ((j=0; j<BATCH_SIZE && idx<TOTAL; j++, idx++)); do
    id="${CASES[$idx]}"
    report="${RUN_DIR}/${id}-report.md"
    pre="$(status_of "$report")"
    # Resume skips a case only if it already reached a REAL verdict. UNKNOWN and TIMEOUT are
    # retryable — otherwise the TIMEOUT stub report we now write would make a re-run (typically
    # with a bigger CASE_TIMEOUT, which is the whole point) skip the very cases it means to retry.
    if [[ "${RESUME:-1}" == "1" && -f "$report" && "$pre" != "UNKNOWN" && "$pre" != "TIMEOUT" ]]; then
      echo "  -> [$((idx+1))/${TOTAL}] ${id} — skip (already ${pre})"
    else
      echo "  -> [$((idx+1))/${TOTAL}] ${id}"
      run_one "$id" "${RUN_DIR}/_batch-${batch}.log" "$CASE_TIMEOUT"
    fi
    printf '%s\t%s\t%s\n' "$id" "$(status_of "$report")" "$report" >> "$RESULTS"
  done
  rebuild_summary
  echo "   checkpoint written: ${SUMMARY}"
done

# --- retry sweep: cases that reached no verdict (killed at the cap, or crashed) ---
# The ledger is de-duped by case id with LAST verdict winning, so simply appending the retry's
# verdict supersedes the TIMEOUT/UNKNOWN one — no bookkeeping needed.
if [[ "$RETRY_NO_VERDICT" == "1" ]]; then
  # Give the sweep more turns than the attempt that just ran out of them. Exported (not passed
  # per-case) because the sweep is the last thing this script does, so nothing else sees it — and
  # a turn cap costs nothing unless a case actually uses it.
  [[ "$RETRY_MAX_TURNS" == "0" ]] && RETRY_MAX_TURNS=$(( ${MAX_TURNS:-150} + 100 ))
  export MAX_TURNS="$RETRY_MAX_TURNS"
  for ((round=1; round<=RETRY_ROUNDS; round++)); do
    pending=()
    for id in "${CASES[@]}"; do
      st="$(status_of "${RUN_DIR}/${id}-report.md")"
      [[ "$st" == "TIMEOUT" || "$st" == "UNKNOWN" ]] && pending+=("$id")
    done
    if [[ ${#pending[@]} -eq 0 ]]; then
      echo "== retry sweep ${round}/${RETRY_ROUNDS}: no cases without a verdict — nothing to retry =="
      break
    fi
    # Apply the cap, and name what it drops. A silent truncation here would read as "everything got
    # a second chance" in the summary when most cases never did.
    deferred=()
    if [[ "$RETRY_MAX" != "0" && ${#pending[@]} -gt $RETRY_MAX ]]; then
      deferred=("${pending[@]:$RETRY_MAX}")
      pending=("${pending[@]:0:$RETRY_MAX}")
    fi
    echo "== retry sweep ${round}/${RETRY_ROUNDS}: retrying ${#pending[@]} case(s) at CASE_TIMEOUT=${RETRY_CASE_TIMEOUT}s MAX_TURNS=${RETRY_MAX_TURNS} =="
    printf '   %s\n' "${pending[*]}"
    if [[ ${#deferred[@]} -gt 0 ]]; then
      echo "   !! RETRY_MAX=${RETRY_MAX} reached — ${#deferred[@]} case(s) NOT retried, keeping their no-verdict status:"
      printf '      %s\n' "${deferred[*]}"
    fi
    for id in "${pending[@]}"; do
      report="${RUN_DIR}/${id}-report.md"
      echo "  -> retry [${round}] ${id} (was $(status_of "$report"))"
      # Drop the stub so a second kill writes a fresh TIMEOUT report stamped with the retry's cap
      # (and so a crashed retry doesn't silently inherit the previous attempt's report).
      rm -f "$report"
      run_one "$id" "${RUN_DIR}/_retry-${round}.log" "$RETRY_CASE_TIMEOUT"
      printf '%s\t%s\t%s\n' "$id" "$(status_of "$report")" "$report" >> "$RESULTS"
      rebuild_summary
    done
    echo "   checkpoint written after retry sweep ${round}: ${SUMMARY}"
  done
fi

echo "== done. summary: ${SUMMARY} =="
python3 -c "import json;s=json.load(open('${SUMMARY}'));print(f\"PASS {s['passed']} / FAIL {s['failed']} / BLOCKED {s['blocked']} / SKIPPED {s.get('skipped',0)} / TIMEOUT {s.get('timeout',0)} / UNKNOWN {s['unknown']}  (of {s['run']} run)\")"
