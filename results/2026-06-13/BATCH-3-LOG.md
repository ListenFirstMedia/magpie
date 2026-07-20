# QA-22296 Re-run — Batch 3/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-22072, QA-23991, QA-24021, QA-27292, QA-43915 (order 11–15)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-22072 | Brand>Partnerships - Basic Filter of Metrics | ⚠️ PARTIAL | No metric-based sub-filter (10 attribute filters only); re-confirms 2026-06-05 gap |
| QA-23991 | Reporting > CPR - Download | ✅ PASS | story 154575; PDF 113,629 B, %PDF-1.3, 1pg. LFMP-32010 not tested |
| QA-24021 | Reporting > TWC - Download | ✅ PASS | story 154574; PDF 318,507 B, %PDF-1.3, 1pg |
| QA-27292 | Update Tag Modal - Download CSV Template | ✅ PASS | Link → `LF Upload Tags Sample - Sheet1.csv`; content carry-forward (CORS-blocked read) |
| QA-43915 | Ads Account IDs Radaac Report | 🚫 BLOCKED | Cognito SSO login required (safety — no creds); LFMP-30870 carry-forward |

## Headline
- 3 PASS, 1 PARTIAL, 1 BLOCKED. No new product bugs. PDF download pipeline (jsPDF) verified end-to-end via blob read for both CPR and TWC.

## Cleanup
- TWC story 154574 + CPR story 154575 created (harmless). No mutations.
