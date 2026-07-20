# QA-134188 — Brand > Insights - Verify Export — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** export-csv, brand-insights-interval-picker
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang

## Summary
Brand>Insights renderer hang (cross-brand, this session) prevents reaching the Insights tiles/export controls. The Export (CSV/PNG/GS) of an Insights metric cannot be exercised.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Insights Export | CSV/PNG/Google Sheets of an Insights metric | Surface unreachable — renderer hang | ⛔ |

## Notes
- **Prior-verified** (`export-csv` / `brand-insights-interval-picker`): MTV Insights Total Followers CSV (`MTV-Insights-Total Followers-…csv`) end-to-end + filename pattern. Re-verify manually.

## Bugs filed
_None new — Brand>Insights renderer-hang carry-forward._
