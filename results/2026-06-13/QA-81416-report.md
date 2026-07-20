# QA-81416 — Reporting > Data Studio - Report Table - CSV & Google Sheets Export — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (Public) · **Metric:** Total Followers · **Window:** 7D (Jun 5–11 2026) · **report_id:** 296281
- **Skills:** data-studio-post-level-run, export-csv v2, export-google-sheets v2
- **Result:** ✅ PASS — consistent with 2026-06-05/08

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Report Table builds | DS Page Level report renders metric table | Total Followers, MTV[P], Sum 733,114,766 / Avg 104,730,681 + 7 daily cols | ✅ |
| CSV export matches UI | CSV row-by-row equals table | Header `Brand,View,Date,Total Followers`; MTV/Public 06-05→104726072, 06-06→104729455, 06-07→104731388, 06-08→104734901, 06-09→104729704, 06-10→104730977, 06-11→104732269 — exact match | ✅ |
| Google Sheets export | Opens a Google Sheet | `window.open` fired `docs.google.com/spreadsheets/...`; new sheet tab opened | ✅ |

## Bugs filed
_None._

## Cleanup
- DS report 296281 created (harmless). GS sheet tab closed.
