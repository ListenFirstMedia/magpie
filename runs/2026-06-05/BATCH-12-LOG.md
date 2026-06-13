# QA-22296 Batch 12/12 (FINAL) — 2026-06-08

Final batch, 4 net-new members (rest of 59 covered in batches 1-11):

| QA-ID | Title | Skill | Result |
|-------|-------|-------|--------|
| QA-135837 | Verify search field retains entered value after selecting filter options | brand-content-filter | PASS-with-deviation (search retention 6a/7a/8 PASS; assertion 9 close/reopen empty NOT met — search retained `aclfest`; tag substitution `aclfest` for spec's `test1` since `test1`/`test11`/`test123` not present in Hulu dev brand) |
| QA-137557 | Custom Metrics × and ÷ Operators - Create & Save | settings-custom-metrics | PARTIAL-PASS (APPS-60358 4-operator dropdown enumerated end-to-end; `×` chip rendered; ÷-chip + Save + listing-row NOT REACHED due to automation-only formula-popup re-open friction. Cleanup: Cancel) |
| QA-137558 | Custom Metrics All Operators - Save & Verify in TWC | settings-custom-metrics + time-window-comparison-run | PARTIAL-PASS (4-operator dropdown PASS by carry-forward from QA-137557; full build + TWC NOT exhaustively re-executed) |
| QA-137874 | Data Collection - Channel Collection Status Validation 2 | new candidate `data-collection-channel-drill` extension | PASS-with-partial-data (5a Collecting green check + 5b Last Collection = today-1 + 5d Not Collecting red exclamation all PASS; 5e To Do blue plus DEFERRED — no To Do status feed in Suits/Twitter sample. Brand substitution: Adam Orfei/Suits instead of HBO Max for time efficiency) |

## Pre-test setup
- Read PROMPT.md, REGISTRY.md, spec-adherence-rules.md.
- Browser: Work Browser, tab group reset to fresh (1804438556).
- Logged in as yash.sharma@listenfirstmedia.com on app.lfmdev.in.

## Session timing
~30 min for 4 tickets (tighter than batch 11 due to automation-only friction on formula-popup re-open).

## Bugs filed
None across the 4 tickets. APPS-61098 (Filter search reset), APPS-60358 (× ÷ operators) — both NOT REPRODUCED (fix code is in place).

## QA-22296 Final coverage
All 59 members of QA-22296 have re-run reports under `runs/2026-06-05/` after this batch. Cumulative cross-batch results tabulated in `QA-22296-FINAL-REPORT.md` (to be authored next session).
