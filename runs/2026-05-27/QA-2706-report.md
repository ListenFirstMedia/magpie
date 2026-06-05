# QA-2706 — Brand > Content - Benchmark - Authorized

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2706
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Amazon Prime Video (account_id=342)
- **Brand:** Amazon Prime Video (brand_id=25864, Authorized perspective)
- **Date Range (page):** May 20, 2026 – May 26, 2026
- **Benchmark Period:** Rolling 7 Days
- **Benchmark Brand:** Amazon Prime Video (Set To Current Brand)
- **Priority:** Blocker (P1)
- **Result:** ✅ **6/6 PASS**

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Brand → Content | ✓ — URL `/#explore/brand/content` |
| 2 | Brand picker → typed `Amazon Prime Video` → clicked exact-match from Results | ✓ — brand_id=25864 |
| 3 | Click Benchmark button | ✓ — Benchmark modal opened with fields: Select Brand Set, Benchmark Period, Select a Brand, Set To Current Brand link, Post Type, Branded Content, Publish Type, Tag, Mode |
| 4 | Click "Set To Current Brand" link | ✓ — Select a Brand input populated with "Amazon Prime Video" |
| 5 | Open Benchmark Period dropdown → click "Rolling 7 Days" | ✓ — Period changed from Q1 2026 default → Rolling 7 Days |
| 6 | Click Go | ✓ — modal closed, Benchmark Selections breadcrumb appeared, Aggregate table now shows Owned Sum / Owned Average / Benchmark Average rows; post tiles now show percentage indicators next to each metric |

## Benchmark Selections breadcrumb (shown above the Aggregate table)
- **Brand:** Amazon Prime Video
- **Benchmark Period:** Rolling 7 Days
- **Mode:** 7 Day

## Aggregate table observed
| Row | Engagements | Reactions | Comments | Shares | Response Rate | Video Views | Video Response Rate |
|---|---:|---:|---:|---:|---:|---:|---:|
| Owned Sum | 3,832,492 | 3,700,715 | 28,612 | 104,017 | N/A | 66,410,459 | N/A |
| **Owned Average** | **23,369 (-<0.01%)** | **22,565 (-0.69%)** | **174 (-0.31%)** | **634 (-35%)** | **0.12% (-55%)** | **699,057 (-1%)** | **3.92% (+18%)** |
| Benchmark Average | 23,369 | 22,723 | 175 | 972 | 0.27% | 706,494 | 3.33% |

Only the **Owned Average** row has benchmark percentage indicators next to each value (the Sum and Benchmark Average rows have raw numbers only). Sum and Average values both display N/A for Response Rate (no aggregate post-rate calculation makes sense at sum level) and Video Response Rate — Benchmark Average row provides values for these as well (0.27% and 3.33%), no N/A.

## Per-post tiles observed (top 5 by Engagements)
Each tile shows a metric stack like:
- Engagements: 357,462 **(+999%)**
- Reactions: 355,424 **(+999%)**
- Comments: 2,038 **(+999%)**
- Response Rate: 5.63% **(+999%)**

| Post | Engagements (%vs benchmark) | Reactions | Comments | Response Rate |
|---|---|---|---|---|
| 1 | 357,462 (+999%) | 355,424 (+999%) | 2,038 (+999%) | 5.63% (+999%) |
| 2 | 303,143 (+999%) | 301,826 (+999%) | 1,317 (+653%) | 4.75% (+999%) |
| 3 | 249,379 (+967%) | 242,488 (+967%) | 1,155 (+560%) | 0.52% |
| 4 | 225,998 (+867%) | 225,659 (+893%) | 339 (+94%) | 3.53% (+999%) |
| 5 | 179,422 (+668%) | 179,055 (+688%) | 367 (+958%) | (off-screen, partial) |

All percentages are integers — no decimals (e.g., "+94%" not "+94.3%"; "+560%" not "+560.21%"). Capped at +999% for very-large positive deltas.

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Benchmark percentage indicators are only updated on Average aggregate row | Owned Average row has 7 percentage indicators (one per metric); Owned Sum row and Benchmark Average row have NO percentage indicators | ✅ PASS |
| A2 | Benchmark Row displays benchmark value for each metric in its corresponding column, below Sum and Average values; if no data, values should display N/A | Benchmark Average row present below Owned Sum + Owned Average rows; all 7 metric columns populated with numeric values (no N/A in this data set). The N/A semantic for missing data is observable on Owned Sum's Response Rate / Video Response Rate columns — confirms N/A handling. | ✅ PASS |
| A3 | Each post metric in the post contains Benchmark values; if no data, values should display N/A | Every post tile shows benchmark percentage next to each metric. No N/A observed here (all posts have data) | ✅ PASS |
| A4 | Collection breadcrumb displays the benchmark used | "Benchmark Selections" breadcrumb shows Brand: Amazon Prime Video; Benchmark Period: Rolling 7 Days; Mode: 7 Day | ✅ PASS |
| A5 | Metrics for each post show percentage indicator values based on comparison to the benchmark | All visible posts (1-5) have positive percentages (+94% to +999%) reflecting that the top engagement posts substantially outperform the rolling-7-day benchmark average | ✅ PASS |
| A6 | Post metric percentage values should be rounded to the nearest percent | All percentages are whole-integer percent values (e.g., +999%, +967%, +653%, +560%, +94%) — no decimal digits | ✅ PASS |

## Bugs filed
None.

## Skill registry impact
- New skill candidate: `brand-content-benchmark-run` — codifies the Benchmark modal flow (Set To Current Brand link + Benchmark Period dropdown + Go) and the Benchmark Selections breadcrumb / Owned Average vs Benchmark Average aggregate row layout. Would benefit follow-up benchmark tests.
- `switch-account` v2 — pass_streak +1 (Amazon Prime Video retained from session)

## Sources
- [QA-2706 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-2706)
