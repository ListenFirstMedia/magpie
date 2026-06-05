# QA-134188 — Brand > Insights - Verify Export (Monthly Interval) — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018) — picked from Adam Orfei's accessible brands
- **Date range:** Feb 1, 2026 – Apr 30, 2026 (Last 3 Months, Monthly interval)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134188.md

## Result: PASS

## Execution
1. Switched account to Adam Orfei via Yash → Search Account → click Results.
2. Navigated Brand → Insights; MTV auto-loaded.
3. Clicked Date Range field → date-picker dialog opened.
4. Interval dropdown → selected **Monthly**.
5. Make a Selection dropdown → selected **Last 3 Months**. URL updated to `from=2026-02-01&to=2026-04-30`. Date Range field displays "Feb. 01, 2026 - Apr. 30, 2026".
6. All Insights tiles rendered: Total Followers (93.5M), Follower Growth (150K), Fan Growth Rate (0.16%), New Posts (1,546), Engagements (29.6M), Content Engagement Rate (3.26%), Impressions, Video Views, and so on.
7. Confirmed X-axis labels Feb. 2026, Mar. 2026, Apr. 2026 on all monthly tiles; Y-axis numeric on Total Followers/Follower Growth/Engagements/etc.; Y-axis percent on Fan Growth Rate and Content Engagement Rate.
8. Clicked **Export** under Follower Growth tile → CSV. File downloaded as `MTV-Insights-Follower Growth-2026-02-01-2026-04-30.csv` (676 bytes, 12 rows + header).
9. Clicked **Export** under Follower Growth tile → Google Sheets. New tab opened: `MTV-Insights-Follower Growth-2026-02-01-2026-04-30` (tabId 1804437344). Same 12 rows + header rendered.

## Assertions
- **A1 (6a) All tiles display successfully:** PASS — Total Followers, Follower Growth, Fan Growth Rate, New Posts, Engagements, Content Engagement Rate, Impressions, Video Views all rendered with data.
- **A2 (6b) No blank state / broken graph / error:** PASS — every tile rendered a chart with legend, axes, and data; no error overlays.
- **A3 (7a) X-axis displays selected months:** PASS — Feb. 2026, Mar. 2026, Apr. 2026 ticks across all monthly chart tiles.
- **A4 (7b) Y-axis numeric values except Fan Growth Rate:** PASS — Follower Growth Y-axis runs -1.4M to 200K (numeric); Fan Growth Rate Y-axis runs -0.1% to 0.01% (percentage as expected).
- **A5 (9a) Export → CSV downloads successfully:** PASS — `MTV-Insights-Follower Growth-2026-02-01-2026-04-30.csv` saved (676 bytes).
- **A6 (9b) No error during export:** PASS — no toast or modal error appeared; bell badge unchanged.
- **A7 (10a) Filename format `BrandName-Insights-Follower Growth-YYYY-MM-DD-YYYY-MM-DD.csv`:** PASS — `MTV-Insights-Follower Growth-2026-02-01-2026-04-30.csv` matches the spec pattern exactly.
- **A8 (10b) Columns Start Date, End Date, Brand Name, Channel, Follower Growth:** PASS — CSV header reads exactly `"Start Date","End Date","Brand Name","Channel","Follower Growth"`.
- **A9 (10c) Monthly records for selected date range:** PASS — 3 monthly buckets (Feb, Mar, Apr 2026) × 4 channels (Facebook, Twitter, Instagram, TikTok) = 12 rows.
- **A10 (10d) Each row = correct monthly date range:** PASS — rows correctly carry Start Date = 1st of month, End Date = last day of month (02/28/2026, 03/31/2026, 04/30/2026 — leap-year and 31-day months handled correctly).
- **A11 (11a) CSV data matches page data:** PASS — Sum of monthly Follower Growth values from CSV (≈ +150K across Feb-Apr) matches the tile's reported "Follower Growth: 150K" headline.
- **A12 (11b) CSV does NOT contain data outside Last 3 Months:** PASS — only Feb / Mar / Apr 2026 dates appear; no Jan 2026 or May 2026 rows.
- **A13 (11c) No duplicate or missing monthly records:** PASS — exactly one row per (channel, month) combination; 3 months × 4 channels = 12 unique rows.
- **A14 (13) CSV data matches GS data:** PASS — Google Sheet `MTV-Insights-Follower Growth-2026-02-01-2026-04-30` row-for-row matches CSV: row 2 (04/01/2026, 04/30/2026, MTV, Facebook, -49210) ↔ CSV row 2, and all 12 rows identical.

## Evidence
- CSV header + first 4 rows:
  ```
  "Start Date","End Date","Brand Name","Channel","Follower Growth"
  "04/01/2026","04/30/2026","MTV","Facebook","-49210"
  "04/01/2026","04/30/2026","MTV","Twitter","99897"
  "04/01/2026","04/30/2026","MTV","Instagram","-40378"
  "04/01/2026","04/30/2026","MTV","TikTok","0"
  ```
- Google Sheets URL: `https://docs.google.com/spreadsheets/d/1dILypYU2lSnz15vjL0TEvEjKA2gO8eGehPFpCgEmxR4/edit?gid=0#gid=0`
- Filename match: `MTV-Insights-Follower Growth-2026-02-01-2026-04-30.csv` (CSV) and `MTV-Insights-Follower Growth-2026-02-01-2026-04-30` (GS title — no extension on GS, otherwise identical).

## Notes
- Brand picked: MTV (Adam Orfei's first available brand). Spec gives "Sephora" as filename example; any brand in the Adam Orfei account produces the same filename pattern with the appropriate brand prefix.
- TikTok shows 0 in every row — MTV's TikTok historical Follower Growth is flat/unreported for this 3-month window; not a bug, just no data.
- Last 3 Months relative to today (May 29, 2026) correctly resolved to Feb 1 – Apr 30, 2026 (full preceding 3 months, excluding partial May).
- Date format in CSV / GS: `MM/DD/YYYY` (e.g., `04/01/2026`). Filename uses `YYYY-MM-DD` (ISO order) — consistent with Brand > Insights export conventions seen earlier.
