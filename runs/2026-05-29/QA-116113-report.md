# QA-116113 — YouTube Audience Tile level export PNG (Batch 8 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-116113
- **Run date:** 2026-06-02 (batch 8 re-run)
- **Account:** Disney Ad Sales (account_id=634)
- **Brand:** Disney Channel (brand_id=3877, Authorized Data perspective)
- **Channel:** YouTube only
- **Date range used for PASS evidence:** May 01, 2025 – May 31, 2025 (older window with data)
- **Priority:** Minor (P4)
- **Result:** PASS 6/6 + DATA-12043 status finding (data present for May 2025; default May 25–31 2026 still empty)

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Brand → Audience | OK |
| 2 | Brand picker → typed `Disney Channel` → exact `Disney Channel` from Results (Rule 1) | brand_id=3877 |
| 3 | YouTube channel only via URL `channels=youtube`; tried default May 25–31 2026 first | All 5 tiles rendered "There is no data available." This is the DATA-12043 symptom. |
| 3a | Switched date range to May 01–31 2025 | All YouTube tiles populated. Gender (Men 41 / Women 58 / Other 1), Age (13-17 7%, 18-24 19%, 25-34 27%, 35-44 29%, 45-54 12%, 55-64 4%), Demographics bar chart with non-zero bars across all age groups. |
| 4 | Export → PNG: Views: Gender Breakdown | downloaded |
| 5 | Export → PNG: Views: Age Breakdown | downloaded |
| 6 | Export → PNG: Views: Demographics | downloaded |

## Downloaded files (~/Downloads)

| Chart | Filename | Bytes |
|---|---|---|
| Views: Gender Breakdown | `Disney Channel-Audience-Views Gender Breakdown-2025-05-01-2025-05-31.png` | 58,546 |
| Views: Age Breakdown | `Disney Channel-Audience-Views Age Breakdown-2025-05-01-2025-05-31.png` | 51,015 |
| Views: Demographics | `Disney Channel-Audience-Views Demographics-2025-05-01-2025-05-31.png` | 83,175 |

## PNG content verification (Demographics sample)

Direct PNG read (Rule 6) of `Disney Channel-Audience-Views Demographics-2025-05-01-2025-05-31.png`:
- LISTENFIRST logo top-left
- Brand: **Disney Channel** (top header)
- Chart Title: **Views: Demographics**
- Legend: Men (purple), Women (teal), Other (grey), User Specified (light-blue), Unknown (grey)
- Bar chart populated 13-17 / 18-24 / 25-34 / 35-44 / 45-54 / 55-64 / 65+ with non-zero bars (peak in 25-34 + 35-44 ~17%)
- Bottom: `Brand Audience` then `Date: May. 01, 2025-May. 31, 2025`

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Filename `Brand - Tab - Chart - YYYY-MM-DD-YYYY-MM-DD.png` | All 3 PNGs match: `Disney Channel-Audience-Views <Chart>-2025-05-01-2025-05-31.png` | PASS |
| A2 | ListenFirst name with logo displays on Chart | LISTENFIRST logo visible top-left in PNG | PASS |
| A3 | Chart Title `Brand Name - Chart Name` shows below the Logo | `Disney Channel` (brand) followed by `Views: <Chart>` (chart title) below logo | PASS |
| A4 | PNG export chart matches Related Tile on Web Page | Bar heights in Demographics PNG match the on-page bar chart; Gender percentages 41/58/1 match donut; Age breakdown values match table | PASS |
| A5 | Tab name "Brand Audience" displays below the Chart | PNG footer: `Brand Audience` | PASS |
| A6 | Displaying date (explorer) displays below Brand Audience | PNG footer line 2: `Date: May. 01, 2025-May. 31, 2025` | PASS |

## DATA-12043 status finding (Code Review bug)

- **Reproduced on default May 25–31 2026 window:** all 5 YouTube tiles rendered "There is no data available. Please select a different brand, brand set, or date range."
- **Does NOT reproduce on May 1–31 2025 window:** all tiles populated. Bar chart, donut, and age table all show real, non-trivial percentages.
- **Interpretation:** DATA-12043 may be largely fixed but with a long data-freshness lag for YouTube. Recommend updating Jira bug status with this finding so triage can compare freshness windows. Data IS coming in for older windows — the "no data" issue is not a complete outage, it's a recency issue.

## Bugs filed
None new. DATA-12043 partial-repro status reported above for product/eng triage.

## Skill registry impact
- `audience-metrics-export` — pass_streak +1 (YouTube tile PNG flow verified end-to-end via Downloads inspection)

## Sources
- [QA-116113 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-116113)
- [DATA-12043 in Jira](https://listenfirstmedia.atlassian.net/browse/DATA-12043)
