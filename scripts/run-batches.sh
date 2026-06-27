#!/usr/bin/env bash
# Run magpie regression cases in batches of N (default 5), unattended headless.
#
# Usage:   scripts/run-batches.sh                 # all cases in testcases/english
#          scripts/run-batches.sh batches/daily.txt   # only IDs listed in a file (one per line)
#          BATCH_SIZE=5 scripts/run-batches.sh
#
# Behaviour:
#   1. One login pre-flight smoke gate up front; abort the whole run if the app is down.
#   2. Run cases sequentially, grouped into batches of BATCH_SIZE (checkpoint after each batch).
#   3. Parse PASS/FAIL/BLOCKED from each case report; write runs/<date>/summary.json (rebuilt
#      after every batch so progress survives an interrupt).
set -uo pipefail
cd "$(dirname "$0")/.."

BATCH_SIZE="${BATCH_SIZE:-5}"
DATE="$(date +%F)"
RUN_DIR="runs/${DATE}"
RESULTS="${RUN_DIR}/results.tsv"
SUMMARY="${RUN_DIR}/summary.json"
mkdir -p "$RUN_DIR"

# --- build case list ---
CASES=()
if [[ $# -ge 1 && -f "$1" ]]; then
  while IFS= read -r line; do CASES+=("$line"); done < <(grep -vE '^[[:space:]]*(#|$)' "$1")
  SOURCE="$1"
else
  while IFS= read -r line; do CASES+=("$line"); done < <(ls testcases/english/*.md | grep -v _TEMPLATE | xargs -n1 basename | sed 's/\.md$//' | sort)
  SOURCE="testcases/english (all)"
fi
TOTAL=${#CASES[@]}
NBATCH=$(( (TOTAL + BATCH_SIZE - 1) / BATCH_SIZE ))
echo "== batch run: ${TOTAL} cases from ${SOURCE}, ${NBATCH} batches of ${BATCH_SIZE} =="

: > "$RESULTS"   # truncate this run's results ledger

rebuild_summary() {
  python3 - "$RESULTS" "$SUMMARY" "$DATE" "$TOTAL" <<'PY'
import json, sys
results_path, summary_path, date, total = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
cases=[]
for line in open(results_path):
    line=line.rstrip("\n")
    if not line: continue
    parts=line.split("\t")
    cases.append({"id":parts[0],"status":parts[1],"report":parts[2] if len(parts)>2 else ""})
counts={}
for c in cases: counts[c["status"]]=counts.get(c["status"],0)+1
json.dump({"date":date,"total":total,"run":len(cases),
           "passed":counts.get("PASS",0),"failed":counts.get("FAIL",0),
           "blocked":counts.get("BLOCKED",0),"unknown":counts.get("UNKNOWN",0),
           "cases":cases}, open(summary_path,"w"), indent=2)
PY
}

status_of() {  # parse a case report for its result; echo PASS/FAIL/BLOCKED/UNKNOWN
  local report="$1" line
  [[ -f "$report" ]] || { echo "BLOCKED"; return; }
  line=$(grep -iE 'result:' "$report" | head -1)   # matches **Result:** PASS and **Result: PASS**
  if   printf '%s' "$line" | grep -qi 'pass';  then echo "PASS"
  elif printf '%s' "$line" | grep -qi 'fail';  then echo "FAIL"
  elif printf '%s' "$line" | grep -qi 'block'; then echo "BLOCKED"
  elif grep -qiE 'smoke-failure|LOGIN FAIL|BLOCKED' "$report"; then echo "BLOCKED"
  else echo "UNKNOWN"; fi
}

# --- smoke gate (once) ---
echo ">> smoke gate: login pre-flight"
scripts/run-case.sh "${CASES[0]}" --login-only > "${RUN_DIR}/_smoke.log" 2>&1 || true
if ! grep -q "LOGIN OK" "${RUN_DIR}/_smoke.log"; then
  echo "!! smoke gate FAILED — app not reachable/bootstrapping. Aborting batch run."
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
      scripts/run-case.sh "$id" >>"${RUN_DIR}/_batch-${batch}.log" 2>&1 || true
    fi
    printf '%s\t%s\t%s\n' "$id" "$(status_of "$report")" "$report" >> "$RESULTS"
  done
  rebuild_summary
  echo "   checkpoint written: ${SUMMARY}"
done

echo "== done. summary: ${SUMMARY} =="
python3 -c "import json;s=json.load(open('${SUMMARY}'));print(f\"PASS {s['passed']} / FAIL {s['failed']} / BLOCKED {s['blocked']} / UNKNOWN {s['unknown']}  (of {s['run']} run)\")"
