# QA-24021 — Reporting > TWC - Download — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Metric:** Total Followers · **Window:** Jun 5–11 2026 · **Story:** 154574
- **Skills:** time-window-comparison-run v5, pdf-end-to-end-verification v2
- **Result:** ✅ PASS — consistent with 2026-06-05

## Steps
1. TWC builder → add MTV (Rule 1) → Total Followers metric → Run Report → story 154574 (Jun 05 = 104,726,072).
2. Preview & Share Report → LISTENFIRST-branded preview with Share + Download.
3. Download → jsPDF blob captured + inspected in-page (Rule 6).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Report builds + renders | TWC story renders Total Followers line + table | story 154574, line chart + data table (Jun 05 104,726,072) | ✅ |
| Download produces valid PDF | jsPDF PDF on download | Blob: **318,507 bytes**, `application/pdf`, header `%PDF-1.3`, **1 page** (≈ prior 313K/1pg) | ✅ |

## Bugs filed
_None._

## Cleanup
- TWC story 154574 created (harmless).
