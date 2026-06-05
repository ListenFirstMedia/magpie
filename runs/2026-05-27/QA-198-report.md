# QA-198 — TWC Exports - Absolute dates — Run Report

- **Date:** 2026-05-27
- **Account:** Disney Ad Sales (account_id=634)
- **Story:** time_window_comparison/153795 — "Time Window Comparison (Jan 1, 2026 - Jan 7, 2026)"
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-198.md

## Result: PASS

## Execution

1. Logged in app.lfmdev.in (already on Disney Ad Sales).
2. Reporting → Time Window Comparison.
3. **Absolute Dates** tab pre-selected (already active).
4. Added 4 brands via React-aware typeahead in spec order: **Disney Channel** (Primary), **CBS News**, **CNN**, **FOX News** — all view = Public Data.
5. Date range set to **Jan 1, 2026 – Jan 7, 2026** via JS-driven prev-arrow clicks + bounding-box-filtered day-cell selection (both calendars rewound to January 2026).
6. Channel Data selected via `controlled-check-box` focus + Space dispatch (the metric tree uses custom widgets, not native `<input type="checkbox">`):
   - **New Followers** (top-level aggregate)
   - **Facebook New Fans** (Fan Growth subtree)
   - **Instagram Follower Growth Rate** (Growth Rate subtree)
7. Clicked **Run Report** → story 153795 generated, Cross-Channel chart rendered, brand chips ordered Disney Channel / CBS News / CNN / FOX News.
8. Export dropdown opened — saw 4 options: Google Sheets, CSV, TSV, XLS.
9. Downloaded CSV, TSV, XLS in sequence. Each saved to ~/Downloads.
10. Google Sheets → opened a new tab (tabId 1804437229) titled "Disney Channel - Time Window Comparison - Jan 1, 2026 - Jan 7, 2026" — Sheet1 populated with 1 header row + 28 data rows in `Perspective | Brand | Date | New Followers | Facebook New Fans | Instagram Follower Growth Rate` order.

## Assertions

- **A1 (Export → Google Sheets, TSV, CSV, XLS options available):** PASS — all 4 visible in the Export dropdown.
- **A2 (Brands and data points in same order as report screen):** PASS — every export lists `Perspective, Brand, Date, New Followers, Facebook New Fans, Instagram Follower Growth Rate` as columns, and rows are grouped Disney Channel → CBS News → CNN → FOX News, matching the report's brand-chip order.
- **A3 (Only selected datapoints displayed):** PASS — exactly the 3 selected metrics appear; no extra columns.
- **A4 (Dates match report):** PASS — every row covers Jan 01 2026 – Jan 07 2026, matching the TWC report header "Time Window Comparison (Jan 1, 2026 - Jan 7, 2026)".
- **A5 (Rate % displays as float value):** PASS — Instagram Follower Growth Rate values render as floats (`0.00008755849216181065`, `0.0037716598127153058`, etc.), never as percent strings.
- **A6 (En-dash NOT displayed in export):** PASS — `grep -c "—\|–"` returned `0` in both CSV and TSV.
- **A7 (Exports match TWC report):** PASS — values in exports match those plotted in the New Followers line chart on the report.
- **A8 (TSV data matches CSV):** PASS — line-by-line diff confirms identical content (only the delimiter differs).
- **A9 (XLS data matches CSV):** PASS — openpyxl read of the .xlsx file returns identical headers, ordering, and per-cell numeric values (floats round-trip exactly).
- **A10 (Google Sheets data matches CSV):** PASS — Sheet1 columns A–F and the 28 data rows match CSV row-for-row in both order and values.

## Evidence

- CSV (first 3 rows after header):
  - `"Public","Disney Channel","01/01/2026","1991","1143","0.00008755849216181065"`
  - `"Public","Disney Channel","01/02/2026","1302","1254","0.000004686418928360844"`
  - `"Public","Disney Channel","01/03/2026","4063","3086","0.00010320724227266394"`
- TSV row for Disney Channel 01/03/2026 — `4063` `3086` `0.00010320724227266394` (matches CSV).
- XLSX cell C5 = `01/03/2026`, D5 = `4063`, E5 = `3086`, F5 = `0.00010320724227266394` (matches).
- Google Sheets row 4 (Disney Channel 01/03/2026): same values.

## Notes

- The "View" toggle stayed on Public Data (default) for all 4 brands — spec didn't require Authorized switching, just Absolute Dates.
- Server returned exports immediately (small payload, 28 rows × 6 cols); no Recent Activity bell queue needed.
- The metric tree's "controlled-check-box" custom widget requires either focus + Space or a coordinate click; standard JS `cb.click()` fails because `<input type="checkbox">` is not used (see [[known-quirks]]).
- En-dash absence in exports confirms ListenFirst replaced the on-screen `–` lock-icon placeholder with a blank/zero cell for the export pipeline.
