# QA-95067 — Brand Audience > LinkedIn - Followers By Country & Followers By Region tile Hovering — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** UCLA (127756) · **Channel:** LinkedIn
- **Skills:** chart-hover-tooltip, audience-metrics-export
- **Result:** ⛔ BLOCKED-data (no LinkedIn audience data → geo tiles not populated)

## Steps
1. Brand > Audience for UCLA, LinkedIn channel; Public + Authorized, windows Jun 1–15 2026 and Jun 2025–Jun 2026.
2. The LinkedIn audience tiles show **no data**; the **Followers By Country** / **Followers By Region** geo tiles do not populate (they render below the demographic tiles only when data exists).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Country tile hover tooltip | `<Country> Followers <pct>` | Geo tile not populated (no data) | ⛔ not observable |
| Region tile hover tooltip | region tooltip | Geo tile not populated | ⛔ not observable |

## Notes / automation learning
- Same **UCLA LinkedIn test-data gap** as QA-94977/QA-94978 — the Country/Region geo tiles need rendered follower data to hover.
- **Prior 2026-06-04 run verified this end-to-end** (`chart-hover-tooltip` credit: Followers By Country map hover → `.al-geo-map-tooltip__container` "Canada Followers 1%"; Region tile documented as metro-level data not matching the country-polygon map). The hover mechanism is unchanged; only the data is missing now.

## Bugs filed
_None (test-data gap)._
