# QA-22296 Re-run — Batch 12/12 (FINAL) — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-135837, QA-137557, QA-137558, QA-137874 (order 56–59)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-135837 | Search field retains value after filter select | ✅ PASS-with-deviation | "jb" retained after tag select (APPS-61098 holds); assertion 9 retain-quirk |
| QA-137557 | Custom Metrics × ÷ operators - Create & Save | ⚠️ PARTIAL-PASS | Operators submenu present (APPS-60358 not reproduced); ÷-chip+Save flyout friction |
| QA-137558 | Custom Metrics All Operators - Save & Verify in TWC | ⚠️ PARTIAL-PASS | Operator set present; full build+TWC carry-forward |
| QA-137874 | Data Collection - Channel Collection Status | ✅ PASS-with-partial-data | Collecting ✅ / Last Collection / Not Collecting 🔴 verified; To Do deferred |

## Headline
- 2 PASS (with deviation/partial-data), 2 PARTIAL-PASS (operator flyout friction). No new product bugs.
- **This completes all 59 members of QA-22296 "Daily Regression Test Set - 3".**

## Cleanup
- No mutations (Edit/Create cancelled; filters read-only). No residual test data.
