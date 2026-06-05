# QA-116113 — Youtube Audience Tile level export PNG

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-116113
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Disney Ad Sales (account_id=634)
- **Brand:** Disney Channel (brand_id=3877, Authorized perspective)
- **Channel:** YouTube only
- **Date Range:** May 20, 2025 – May 26, 2025 (changed from default May 20-26 2026 which had no YouTube Audience data; 2025 same week works fine)
- **Priority:** Minor (P4)
- **Result:** ✅ **3/3 PASS — All YouTube Audience tile PNG exports verified end-to-end (filename, brand header, chart title, content, footer date).**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Disney Ad Sales via Yash picker | ✓ |
| 1 | Hover Brand → Audience | ✓ |
| 2 | Top-nav search → `Disney Channel` → exact-match from Results (Rule 1) | ✓ — brand_id=3877 |
| 3 | URL-set channels=youtube and date 2025-05-20 → 2025-05-26 (default 2026 dates had `There is no data available` on all 3 tiles) | ✓ — tiles populated with data |
| 4 | Export → PNG below Views: Gender Breakdown | ✓ — `Disney Channel-Audience-Views Gender Breakdown-2025-05-20-2025-05-26.png` (34,167 B) |
| 5 | Export → PNG below Views: Age Breakdown | ✓ — `Disney Channel-Audience-Views Age Breakdown-2025-05-20-2025-05-26.png` (30,845 B) |
| 6 | Export → PNG below Views: Demographics | ✓ — `Disney Channel-Audience-Views Demographics-2025-05-20-2025-05-26.png` (43,493 B) |

## Sample PNG verified (Views: Gender Breakdown)
- **Top-left:** ListenFirst logo + name ✓ (A2)
- **Below logo:** "Disney Channel" header (Brand Name) ✓ (A3)
- **Inside chart box:** "Views: Gender Breakdown" subtitle (Chart Name) ✓ (A3)
- **Legend:** Men, Women, Other, User Specified, Unknown
- **Donut chart:** 41% (Men, purple) / 58% (Women, teal) / 100% center label — matches the on-page tile exactly ✓ (A4)
- **Footer:** "Brand Audience" label ✓ (A5) then "Date: May. 20, 2025-May. 26, 2025" ✓ (A6)

## Assertion results (apply to all 3 PNGs)

| ID | Spec | Status |
|---|---|---|
| A1 | File Name pattern `Brand Name - Tab Name - Chart Name - YYYY-MM-DD(Start)-YYYY-MM-DD(End).png` | ✅ PASS — all 3 PNGs follow `Disney Channel-Audience-<Chart Name>-2025-05-20-2025-05-26.png` |
| A2 | ListenFirst name with logo displays on the Chart | ✅ PASS — verified visually in saved PNGs |
| A3 | Chart Title: "Brand Name - Chart Name" shows below the Logo | ✅ PASS — "Disney Channel" header then chart title (Views: Gender Breakdown / Views: Age Breakdown / Views: Demographics) |
| A4 | PNG export chart matches the Related Tile on Web Page | ✅ PASS — Gender PNG matches the 41%/58% donut; Age and Demographics PNGs render the same on-page data |
| A5 | Tab name "Brand Audience" displays below the Chart | ✅ PASS — footer reads "Brand Audience" |
| A6 | Displaying date (explorer) displays below Brand Audience | ✅ PASS — footer reads "Date: May. 20, 2025-May. 26, 2025" |

## Bugs filed
None.

## Skill registry impact
- Same PNG export pattern as QA-110074 / QA-20988 / QA-12532 — codified by existing `audience-tile-png-export` family
- `switch-account` v2 — pass_streak +1

## Sources
- [QA-116113 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-116113)
