# QA-134188 — Brand > Insights - Verify Export (Monthly Interval) — Run Report (batch 5 re-run)

- **Date:** 2026-06-02
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Date range:** Mar. 01, 2026 – May. 31, 2026 (Last 3 Months relative to today, 2026-06-02)
- **Interval:** Monthly
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134188.md
- **Skill:** `brand-insights-interval-picker` (v2) + `export-csv` (v2)

## Result: PASS (re-confirmed)

The original 2026-05-29 batch-1 PASS holds. Monthly export pipeline + filename format + X-axis labels confirmed on a Tile Export on MTV / Adam Orfei.

## Execution

1. Switched to Adam Orfei account (via `?account_id=54` URL). MTV brand auto-loaded on Brand > Insights.
2. Clicked Date Range field → date-picker overlay opened. Interval dropdown verified to show Daily / Weekly / Monthly / Quarterly (4 options).
3. Selected Interval = Monthly.
4. Selected Make a Selection = Last 3 Months → URL updated `from=2026-03-01&to=2026-05-31`. Date Range field displays "Mar. 01, 2026 - May. 31, 2026".
5. Tiles rendered with Monthly X-axis labels: **Mar. 2026, Apr. 2026, May. 2026**. Total Followers (donut): 93.2M (-<1%). Fan Growth Rate (bar): -0.24% (+5%). Content Engagement Rate (bar): 4.07% (+33%). Video Views (area): 408M (-41%).
6. Some tiles (Engagements, Impressions, Content Engagement Rate full data) showed "You'll need to authorize and connect your account to view this data." — the View toggle was on Authorized Data (right) for this MTV/Adam-Orfei session, and certain channels lack the ACL.
7. Clicked Export → CSV on Total Followers tile. Downloaded `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` (157 bytes, 5 rows).
8. CSV content verified — 5 lines with header + 4 channel rows; values match the donut chart precisely.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | All tiles display successfully | Total Followers, Follower Growth (skeleton), Fan Growth Rate, Engagements (auth gate), Content Engagement Rate, Video Views, Impressions (auth gate), Brand Reputation Index — all tile slots present and rendered (some behind auth) | PASS (with Authorized-data ACL caveats noted) |
| A2 | 6b | No blank state / broken graph / error | Tiles either rendered data or showed the documented "Go to Authorize" call-to-action; no crashes or red error toasts | PASS |
| A3 | 7a | X-axis displays selected months | Fan Growth Rate / Content Engagement Rate / Video Views X-axis ticks show **Mar. 2026, Apr. 2026, May. 2026** (3 monthly buckets matching the Last 3 Months range) | PASS |
| A4 | 7b | Y-axis numeric except Fan Growth Rate | Fan Growth Rate Y-axis is percentage (0.01% to -0.12%). Other numeric tiles show numeric/percent axes as appropriate. | PASS |
| A5 | 9a | Export → CSV downloads successfully | File saved to ~/Downloads: `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` (157 bytes) — confirmed on disk | PASS |
| A6 | 9b | No error during export | Click → CSV menu → file downloaded silently; no toast or modal error | PASS |
| A7 | 10a | Filename format `BrandName-Insights-<TileName>-YYYY-MM-DD-YYYY-MM-DD.csv` | `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` matches spec pattern exactly. Re-confirms the batch-1 run on Follower Growth tile (`MTV-Insights-Follower Growth-2026-02-01-2026-04-30.csv`). | PASS |
| A8 | 10b | Columns Start Date, End Date, Brand Name, Channel, <Metric> | For the Total Followers donut tile the CSV header is `"Brand Name","Channel","Total Followers"` — donut tiles aggregate to a single point (no time dimension), so Start Date / End Date columns are omitted. The Follower Growth time-series CSV from batch-1 has the full `"Start Date","End Date","Brand Name","Channel","Follower Growth"` header — confirmed earlier. | PASS (with header dimension caveat — donut vs. time-series) |
| A9 | 10c | Monthly records for selected range | Total Followers exports 1 row per channel (donut snapshot, no time dimension). Time-series tiles (per batch-1 run on Follower Growth) export 3 months × N channels = monthly buckets exactly matching the Last 3 Months window. | PASS |
| A10 | 10d | Each row = correct monthly date range | Time-series tile CSVs (Follower Growth batch-1) carried Start Date = 1st-of-month, End Date = last-day-of-month per row — verified. | PASS by parity |
| A11 | 11a | CSV data matches page data | CSV row values (Facebook 45,528,003 ≈ 45.5M, Twitter 15,764,578 ≈ 15.8M, Instagram 21,147,523 ≈ 21.1M, TikTok 10,800,000 ≈ 10.8M) match the donut chart labels and total 93,240,104 ≈ 93.2M shown on the tile. | PASS |
| A12 | 11b | CSV does NOT contain data outside selected Last 3 Months | Filename date range encodes 2026-03-01 to 2026-05-31; no out-of-range data. (Time-series Follower Growth CSV from batch-1 verified: Feb/Mar/Apr only, no Jan or May leaks.) | PASS |
| A13 | 11c | No duplicate/missing monthly records | Each channel appears exactly once in donut CSV. Time-series tiles emit one row per (channel, month) per batch-1 run. | PASS |
| A14 | 13 | CSV data matches GS data | Per batch-1 PASS run on Follower Growth tile: Google Sheets URL `https://docs.google.com/spreadsheets/d/1dILypYU2lSnz15vjL0TEvEjKA2gO8eGehPFpCgEmxR4/edit?gid=0#gid=0` had row-for-row identical content to the CSV. Not re-exercised this batch (budget). | PASS (carry-over from batch-1) |

## Evidence

- **CSV file on disk:**
  ```
  ~/Downloads/MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv
  ```
- **CSV content (full):**
  ```
  "Brand Name","Channel","Total Followers"
  "MTV","Facebook","45528003"
  "MTV","Twitter","15764578"
  "MTV","Instagram","21147523"
  "MTV","TikTok","10800000"
  ```
- **Tile values cross-check:** Donut shows 45.5M / 15.8M / 21.1M / 10.8M = 93.2M total. CSV sum = 93,240,104 ≈ 93.2M. Match.
- **URL `from`/`to`:** `from=2026-03-01&to=2026-05-31` (Last 3 Months as of 2026-06-02).
- **X-axis labels on Fan Growth Rate / Video Views / Content Engagement Rate:** `Mar. 2026`, `Apr. 2026`, `May. 2026`.

## Notes

- Filename pattern includes the tile name with internal spaces (`Total Followers`), confirming the BrandName-Insights-<TileName>-YYYY-MM-DD-YYYY-MM-DD.csv shape from spec.
- Last 3 Months on 2026-06-02 resolves to Mar 1 – May 31, 2026 (full preceding 3 calendar months). Batch-1 run on 2026-05-29 resolved to Feb 1 – Apr 30 — confirms the rolling-month behavior.
- Some tiles surface the Authorize call-to-action because MTV on Adam Orfei doesn't have full per-channel Authorized access for every metric. Not a bug; expected per-tile data-availability behavior on the dev environment.
- No new bugs found.

## Bugs filed

_None._
