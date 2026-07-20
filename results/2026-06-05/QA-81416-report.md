# QA-81416 — Reporting > Data Studio - Report Table - CSV & Google Sheets Export Functionality

- **Date:** 2026-06-08 (batch 4/12 of QA-22296)
- **Source spec:** Jira QA-81416 (title + description "verifies the Export Functionality of the Report Table in the Data Studio Page")
- **Skills mapped:** `export-csv` v2 (untrusted, pass_streak 21) + `export-google-sheets` v2 (untrusted, pass_streak 7) — both eligible for stable promotion
- **Bug history:** None
- **Labels:** Playwright

## Result: PASS — both CSV and Google Sheets exports verified end-to-end on disk + in GS tab

## Execution
1. Adam Orfei account (account_id=54) login confirmed.
2. Navigated to `https://app.lfmdev.in/#explore/reporting/data_studio?brand_id=4018&account_id=54&channels=facebook&perspective=standard`.
3. Builder rendered: Add a Brand typeahead + Page Level Metrics + Go button.
4. Brand: typed `MTV` in `Search for a Brand` (React InputEvent dispatch + `value` set) → clicked `.al-typeahead__option` Results item `MTV` (Rule 1 exact match).
5. View defaulted to `Public` (per known-quirk).
6. Clicked `Select Metrics` → metric picker opened → typed `Total Fans` in `Search for a Metric` → clicked `label.controlled-check-box__label` for `Facebook Total Fans` (verified via Find tool ref_1285).
7. Date range defaulted to 7-day window `May 31, 2026 – Jun 06, 2026`.
8. Clicked `Go`. URL updated with `report_id=294839`. Report rendered with:
   - Line chart `Facebook Total Fans` for MTV(P) with daily values from ~45.5M
   - Data table: `Metric | Brand | Sum | Average | May. 31, 2026 | Jun. 01, 2026 | Jun. 02, 2026 | Jun. 03, 2026 | Jun. 04, 2026 | Jun. 05, 2026 | Jun. 06, 2026`
   - Row: `Facebook Total Fans | MTVP | 318,656,944 | 45,522,421 | 45,528,003 | 45,526,325 | 45,524,161 | 45,522,187 | 45,520,400 | 45,518,517 | 45,517,351`
9. **CSV export:** Clicked `Export` → dropdown surfaced `CSV` + `Google Sheets` → clicked `CSV` → file saved to `~/Downloads/MTV-Data-Studio-May-31-2026-Jun-06-2026.csv` (326 bytes, 8 lines).
10. **Google Sheets export:** Installed window.open hook → clicked `Export` → clicked `Google Sheets` → captured URL `https://docs.google.com/spreadsheets/d/1enODXDmMm9kkcoJpqKlSg6pLptAzykMcrxBrgLgOqNY` → GS opened in tab `1804438490` with title `MTV-Data-Studio-May-31-2026-Jun-06-2026 - Google Sheets`.

## CSV content (on-disk verification)

```
"Brand","View","Date","Facebook Total Fans"
"MTV","Public","2026-05-31","45528003"
"MTV","Public","2026-06-01","45526325"
"MTV","Public","2026-06-02","45524161"
"MTV","Public","2026-06-03","45522187"
"MTV","Public","2026-06-04","45520400"
"MTV","Public","2026-06-05","45518517"
"MTV","Public","2026-06-06","45517351"
```

UI value 45,528,003 → CSV 45528003 (exact match).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-8 | Report renders with metric + brand + date range | MTV / FB Total Fans / 7-day window rendered with chart + data table | PASS |
| A2 | 9 | CSV export downloads with brand-Data-Studio filename pattern | `MTV-Data-Studio-May-31-2026-Jun-06-2026.csv` saved to disk (326 bytes) | PASS |
| A3 | 9 | CSV content matches the UI data row-for-row | All 7 daily values exact match between UI and CSV; column headers Brand/View/Date/Facebook Total Fans verbatim | PASS |
| A4 | 10 | Google Sheets export opens a sheet with the same filename pattern | GS tab title `MTV-Data-Studio-May-31-2026-Jun-06-2026 - Google Sheets` (Google's ` - Google Sheets` suffix per known-quirk; effective filename matches CSV exactly) | PASS |
| A5 | 10 | GS spreadsheet URL captured via window.open hook | URL `https://docs.google.com/spreadsheets/d/1enODXDmMm9kkcoJpqKlSg6pLptAzykMcrxBrgLgOqNY/edit?gid=0#gid=0` captured | PASS |

## Bug reproduction outcomes
No prior open bugs for QA-81416. No new regressions detected.

## Skill registry impact
- `export-csv` v2 pass_streak 21 → 22 (Data Studio Report Table CSV export end-to-end on disk).
- `export-google-sheets` v2 pass_streak 7 → 8 (Data Studio Report Table GS export with window.open hook + cross-tab title capture).

## Files
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-81416-report.md` (this report)
- `/Users/yashsharma/Downloads/MTV-Data-Studio-May-31-2026-Jun-06-2026.csv` (verified CSV — 326 bytes, 8 lines, 7 data rows)
- GS sheet `https://docs.google.com/spreadsheets/d/1enODXDmMm9kkcoJpqKlSg6pLptAzykMcrxBrgLgOqNY`

## Bugs filed
None.
