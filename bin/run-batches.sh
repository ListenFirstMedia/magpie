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
VALID = {"PASS", "FAIL", "BLOCKED", "SKIPPED", "UNKNOWN"}
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
           "unknown":counts.get("UNKNOWN",0),
           "cases":cases}, open(summary_path,"w"), indent=2)
PY
}

status_of() {  # parse a case report for its result; echo PASS/FAIL/BLOCKED/UNKNOWN
  local report="$1" line
  [[ -f "$report" ]] || { echo "BLOCKED"; return; }
  line=$(grep -iE '(result|verdict|status):' "$report" | head -1)   # verdict wording varies: Result:/Verdict:/Status:
  # Take the status keyword AFTER the label, and use the LEFTMOST match — so
  # "BLOCKED - pre-flight login failure" resolves to BLOCKED, not FAIL (the word "failure").
  local rest first
  rest=${line#*:}
  first=$(printf '%s' "$rest" | grep -oiE 'passed|pass|skipped|skip|blocked|block|failed|fail' | head -1 | tr 'A-Z' 'a-z')
  case "$first" in
    pass*)  echo "PASS";    return;;
    skip*)  echo "SKIPPED"; return;;
    block*) echo "BLOCKED"; return;;
    fail*)  echo "FAIL";    return;;
  esac
  if grep -qiE 'smoke-failure|LOGIN FAIL|BLOCKED' "$report"; then echo "BLOCKED"; else echo "UNKNOWN"; fi
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
    if [[ "${RESUME:-1}" == "1" && -f "$report" && "$pre" != "UNKNOWN" ]]; then
      echo "  -> [$((idx+1))/${TOTAL}] ${id} — skip (already ${pre})"
    else
      echo "  -> [$((idx+1))/${TOTAL}] ${id}"
      # Run the case; on a usage/session limit (or transient rate-limit/overload), either
      # wait-and-resume the SAME case (ON_LIMIT=wait) or stop cleanly (ON_LIMIT=stop).
      waits=0
      while :; do
        bin/run-case.sh "$id" 2>&1 | tee -a "${RUN_DIR}/_batch-${batch}.log" || true
        if tail -8 "${RUN_DIR}/_batch-${batch}.log" | grep -qiE 'session limit|hit your .*limit|usage limit|rate.?limit|overloaded|status 429'; then
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
    fi
    printf '%s\t%s\t%s\n' "$id" "$(status_of "$report")" "$report" >> "$RESULTS"
  done
  rebuild_summary
  echo "   checkpoint written: ${SUMMARY}"
done

echo "== done. summary: ${SUMMARY} =="
python3 -c "import json;s=json.load(open('${SUMMARY}'));print(f\"PASS {s['passed']} / FAIL {s['failed']} / BLOCKED {s['blocked']} / SKIPPED {s.get('skipped',0)} / UNKNOWN {s['unknown']}  (of {s['run']} run)\")"
