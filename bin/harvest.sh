#!/usr/bin/env bash
# M2.5 "harvest" — single-threaded skill-maintenance pass over a day's run.
#
# Reads results/<date>/summary.json + the case reports and applies docs/PROMPT.md's post-pass
# maintenance: bump pass_streak for reused skills, author skills for genuinely new flows,
# update REGISTRY.md + knowledge-base/, promote untrusted->stable, quarantine real drift.
#
# Runs ONE claude -p (no browser) so there is never a concurrent writer to REGISTRY.md.
# Run it AFTER run-batches.sh completes (never in parallel with case runs).
#
# Usage:  bin/harvest.sh                 # today's run
#         bin/harvest.sh 2026-06-27      # a specific run date
set -uo pipefail
cd "$(dirname "$0")/.."

DATE="${1:-$(date +%F)}"
RUN_DIR="results/${DATE}"
SUMMARY="${RUN_DIR}/summary.json"
LOG="${RUN_DIR}/harvest-log.md"

if [[ ! -f "$SUMMARY" ]]; then
  echo "ERROR: no summary at ${SUMMARY} — run bin/run-batches.sh first." >&2
  exit 1
fi

read -r -d '' PROMPT <<EOF || true
You are doing the magpie SKILL-MAINTENANCE pass (the "harvest") for the run on ${DATE}.
This is file-only work — do NOT open a browser. You ARE permitted to edit skills/, the
skill registry, and the knowledge-base; that is the whole point of this pass.

Read first, in order:
1. docs/PROMPT.md — apply the rules in its OUTPUT section about skills/registry/KB maintenance.
2. skills/REGISTRY.md — current trust states, pass_streak counts, Last verified dates.
3. skills/_TEMPLATE.md — the shape of a new skill file.
4. ${SUMMARY} — the run result index, then read each case's report at ${RUN_DIR}/<ID>-report.md.

For this run, apply the maintenance rules EXACTLY:

- PASS that REUSED an existing skill -> bump that skill's pass_streak +1 and update its
  "Last verified" date to ${DATE} in REGISTRY.md. (Find the skill from the report's
  "Skills used" / "Skill reused" line.)
- PASS that exercised a genuinely NEW flow with no existing skill -> author
  skills/<flow>/SKILL.md from skills/_TEMPLATE.md and add a REGISTRY.md row as **untrusted**.
- PROMOTION: untrusted -> stable ONLY when a skill has 3+ passes on SEPARATE days. Verify the
  separate-day evidence in REGISTRY notes before promoting; if unsure, leave untrusted and
  note why.
- New reusable quirk learned -> add it to knowledge-base/known-quirks.md (newest-first), and
  update app-map.md / glossary.md if a new page or term appeared.

CRITICAL — do NOT over-react to non-skill failures:
- BLOCKED/FAIL caused by environment (app hang, throttled bundles), a 15-min TIMEOUT, or a
  data/precondition gap is NOT skill drift. Do NOT quarantine or rewrite a skill for those —
  just note them in the harvest log.
- Quarantine a skill ONLY when the report shows the skill's documented steps/selectors no
  longer match the app (true drift) AND no documented fallback worked.
- Be conservative. When a change is ambiguous, DO NOT guess — record it under "Needs human
  review" in the harvest log and leave the file unchanged.

OUTPUT: write ${LOG} summarizing every change you made — one section per skill touched
(streak bumps with old->new, new skills authored, promotions, KB additions) plus a
"Needs human review" section. Be terse in chat; the harvest log is the record.
EOF

echo ">> harvest ${DATE} — $(date)"
claude -p "$PROMPT" --dangerously-skip-permissions
echo ">> done — harvest log: ${LOG}"
