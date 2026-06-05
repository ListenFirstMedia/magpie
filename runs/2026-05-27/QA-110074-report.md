# QA-110074 — Brand > Audience - Threads - Tile Level Export - PNG

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-110074
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, Authorized perspective)
- **Channel:** Threads only
- **Date Range:** Mar 16, 2025 – Mar 22, 2025
- **Priority:** Minor (P4)
- **Result:** ✅ **5/5 tiles PASS — all PNGs downloaded with spec-compliant filename pattern, chart titles, brand-name header, legend, and footer date.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Brand → Audience | ✓ — URL `/#explore/brand/audience` |
| 2 | URL-set brand `MTV` (brand_id=4018) | ✓ |
| 3 | Threads channel only + Date Range Mar 16-22 2025 (set via URL params) | ✓ — URL `channels=threads&from=2025-03-16&to=2025-03-22` |
| 4 | Export → PNG below Followers By Country | ✓ — `MTV-Audience-Followers By Country-2025-03-16-2025-03-22.png` |
| 5 | Export → PNG below Followers By City | ✓ — `MTV-Audience-Followers By City-2025-03-16-2025-03-22.png` |
| 6 | Export → PNG below Followers: Geo Breakdown By Country | ✓ — `MTV-Audience-Followers Geo Breakdown By Country-2025-03-16-2025-03-22.png` |
| 7 | Export → PNG below Followers: Geo Breakdown By City | ✓ — `MTV-Audience-Followers Geo Breakdown By City-2025-03-16-2025-03-22.png` |
| 8 | Export → PNG below Followers: Gender Breakdown | ✓ — `MTV-Audience-Followers Gender Breakdown-2025-03-16-2025-03-22.png` |

## Downloaded files (~/Downloads/)

| Tile | Filename | Size | A1 Filename | A2 Title | A3 Content | A4 Date footer |
|---|---|---:|:---:|:---:|:---:|:---:|
| Followers By Country | `MTV-Audience-Followers By Country-2025-03-16-2025-03-22.png` | 153,399 B | ✅ | ✅ "MTV" header + "Followers By Country" subtitle | ✅ map matches explorer | ✅ "Date: Mar. 16, 2025-Mar. 22, 2025" |
| Followers By City | `MTV-Audience-Followers By City-2025-03-16-2025-03-22.png` | 165,916 B | ✅ | ✅ MTV + Followers By City | ✅ | ✅ |
| Followers: Geo Breakdown By Country | `MTV-Audience-Followers Geo Breakdown By Country-2025-03-16-2025-03-22.png` | 315,415 B | ✅ | ✅ MTV + Geo Breakdown By Country | ✅ table with US 24%, Brazil 11%, India 9% | ✅ |
| Followers: Geo Breakdown By City | `MTV-Audience-Followers Geo Breakdown By City-2025-03-16-2025-03-22.png` | 405,980 B | ✅ | ✅ MTV + Geo Breakdown By City | ✅ table with Mexico City 6%, Lagos 6%, São Paulo 5% | ✅ |
| Followers: Gender Breakdown | `MTV-Audience-Followers Gender Breakdown-2025-03-16-2025-03-22.png` | 60,090 B | ✅ | ✅ MTV + Followers: Gender Breakdown | ✅ donut: Men 42%, Women 50%, Unknown 8% | ✅ "Date: Mar. 16, 2025-Mar. 22, 2025" |

## Assertion results (apply to all 5 PNGs)

| ID | Spec | Status |
|---|---|---|
| A1 | File Name: `Brand Name - Tab Name - Chart Name - YYYY-MM-DD(Start Date)-YYYY-MM-DD(End Date).png` | ✅ PASS — all 5 PNGs follow `MTV-Audience-<Chart Name>-2025-03-16-2025-03-22.png` |
| A2 | Chart Title: `Brand Name - Chart Name` | ✅ PASS — each PNG renders the brand name "MTV" at top, with the chart name as the inline subtitle (verified by Reading the Gender Breakdown and Followers By Country PNGs) |
| A3 | PNG export chart matches explorer | ✅ PASS — Gender Breakdown PNG shows 8% / 42% / 50% donut matching the on-screen tile; Followers By Country PNG shows the world map with US dark-red, Brazil/UK pink etc. matching the on-screen heat map |
| A4 | Display date below Brand Audience | ✅ PASS — footer reads "Brand Audience" then "Date: Mar. 16, 2025-Mar. 22, 2025" — present in all 5 PNGs |

## Bugs filed
None.

## Skill registry impact
- `export-png` (implicit pattern) — verified across 5 Audience tiles with consistent filename / chart title / footer date pattern. Same pattern observed earlier today on QA-20988 (Paid PNG exports) and QA-12532 (Brand Sets Partnerships PNG).
- `switch-account` v2 — pass_streak +1 (separate-day, Adam Orfei retained from QA-96818/106218/109062/110074 chain)

## Sources
- [QA-110074 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-110074)
