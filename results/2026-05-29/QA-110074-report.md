# QA-110074 — Brand > Audience - Threads - Tile Level Export - PNG (Batch 8 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-110074
- **Run date:** 2026-06-02 (batch 8 re-run)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, Authorized Data perspective)
- **Channel:** Threads only
- **Date range:** Mar. 16, 2025 – Mar. 22, 2025
- **Priority:** Minor (P4)
- **Result:** PASS 5/5 (5 PNGs downloaded end-to-end, content verified by direct PNG read)

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Brand → Audience | OK |
| 2 | Brand picker → typed `MTV` → clicked exact `MTV` from Results (Rule 1) | brand_id=4018 |
| 3 | Threads channel filter + date Mar 16 – Mar 22 2025 | URL `channels=threads&from=2025-03-16&to=2025-03-22` |
| 4 | Export → PNG: Followers By Country | downloaded |
| 5 | Export → PNG: Followers By City | downloaded |
| 6 | Export → PNG: Followers: Geo Breakdown By Country | downloaded |
| 7 | Export → PNG: Followers: Geo Breakdown By City | downloaded |
| 8 | Export → PNG: Followers: Gender Breakdown | downloaded |

## Downloaded files (~/Downloads)

| Chart | Filename | Bytes |
|---|---|---|
| Followers By Country | `MTV-Audience-Followers By Country-2025-03-16-2025-03-22 (1).png` | 134,683 |
| Followers By City | `MTV-Audience-Followers By City-2025-03-16-2025-03-22 (1).png` | 145,865 |
| Followers: Geo Breakdown By Country | `MTV-Audience-Followers Geo Breakdown By Country-2025-03-16-2025-03-22 (2).png` | 273,307 |
| Followers: Geo Breakdown By City | `MTV-Audience-Followers Geo Breakdown By City-2025-03-16-2025-03-22 (2).png` | 356,258 |
| Followers: Gender Breakdown | `MTV-Audience-Followers Gender Breakdown-2025-03-16-2025-03-22 (1).png` | 53,638 |

## PNG content verification (Gender Breakdown sample)

Direct PNG read (Rule 6) confirmed for `MTV-Audience-Followers Gender Breakdown-2025-03-16-2025-03-22 (1).png` (745 x 838 RGBA):
- ListenFirst logo top-left
- Brand: **MTV** (header)
- Chart Title: **Followers: Gender Breakdown**
- Donut: 42% Men, 50% Women, 8% Unknown, center 100%
- Bottom: **Brand Audience** label and **Date: Mar. 16, 2025-Mar. 22, 2025**

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | File Name pattern `Brand Name - Tab Name - Chart Name - YYYY-MM-DD-YYYY-MM-DD.png` | All 5 filenames match. Format: `MTV-Audience-<Chart>-2025-03-16-2025-03-22.png` | PASS |
| A2 | Chart Title `Brand Name - Chart Name` | PNG header shows `MTV` (brand) followed by chart sub-title (`Followers: Gender Breakdown`) below logo. | PASS |
| A3 | PNG export matches the explorer chart | Donut percentages on PNG (42/50/8) match Brand>Audience Followers Gender Breakdown tile on screen. | PASS |
| A4 | Display date below "Brand Audience" | PNG footer: `Brand Audience` then `Date: Mar. 16, 2025-Mar. 22, 2025`. | PASS |

## Bugs filed
None.

## Skill registry impact
- `audience-metrics-export` — pass_streak +1 (Threads tile PNG flow reproduced end-to-end via Downloads inspection)

## Sources
- [QA-110074 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-110074)
