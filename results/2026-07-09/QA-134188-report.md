# QA-134188 — Brand > Insights - Verify Export (Monthly Interval)

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Blocker (P1)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV Insights · Monthly interval · Last 3 Months (Apr 1 – Jun 30, 2026)

## Verdict: PASS (Google Sheets A14 out of scope)

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (6a) | All tiles display | Total Followers, Follower Growth, Fan Growth Rate, New Posts, Engagements, Content Engagement Rate … all rendered | PASS |
| A2 (6b) | No blank/broken/error | all tiles rendered with data | PASS |
| A3 (7a) | X-axis shows selected months | Follower Growth + Fan Growth Rate charts show **Apr 2026, May 2026, Jun 2026** | PASS |
| A4 (7b) | Y-axis numeric except Fan Growth Rate | Follower Growth Y-axis numeric (−450K…0); Fan Growth Rate in % | PASS |
| A5 (9a) | Export → CSV downloads | `MTV-Insights-Follower Growth-2026-04-01-2026-06-30.csv` downloaded | PASS |
| A6 (9b) | No error during export | clean download | PASS |
| A7 (10a) | Filename `Brand-Insights-Follower Growth-YYYY-MM-DD-YYYY-MM-DD.csv` | matches exactly | PASS |
| A8 (10b) | Columns Start Date, End Date, Brand Name, Channel, Follower Growth | header = **"Start Date","End Date","Brand Name","Channel","Follower Growth"** | PASS |
| A9 (10c) | Monthly records for the range | 12 rows = **3 months × 4 channels** (Apr/May/Jun 2026 × Facebook/Twitter/Instagram/TikTok) | PASS |
| A10 (10d) | Each row = correct monthly date range | 06/01–06/30, 05/01–05/31, 04/01–04/30 (1st→last of each month) | PASS |
| A11 (11a) | CSV data matches page | CSV sum = (Jun 1,335) + (May −267,034) + (Apr 10,309) = **−255,390** = tile "Follower Growth: -255K" / hover "Value -255,390" | PASS |
| A12 (11b) | No data outside Last 3 Months | only Apr/May/Jun 2026 present | PASS |
| A13 (11c) | No duplicate/missing monthly records | each month×channel exactly once; all 12 present | PASS |
| A14 (13) | CSV matches Google Sheets | **out of scope** (Google Sheets export excluded from this track) | N/A |

## Evidence
- `.playwright-out/MTV-Insights-Follower-Growth-2026-04-01-2026-06-30.csv` (12 rows)
- `QA-134188-monthly.png` (Monthly tiles, Apr/May/Jun X-axis, Follower Growth −255K hover)

## Bugs filed
None.
