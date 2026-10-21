# QA-19698 — Brand Content - Impressions - Data Test - FB

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Facebook only · **Data set:** Impressions (`table_data_set=impressions`)
**Verdict: PASS (2/2) — identities hold on every post that has impressions data (13 of 30); 17 posts show "–" for all impression metrics (no impressions collected), which the identity cannot evaluate**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Data Set = Impressions, Facebook only | ✅ Posts (30). Columns: Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate (Reach columns N/A per the Nov-2025 Meta deprecation noted in the precondition) |
| 4–5 | Table View; all 30 rows scraped | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Impressions + Paid Impressions = Impressions | 13/13 evaluable posts match (rank 1: 4,761,429+0 = 4,761,429 ✓; rank 4: 478,905+105,084 = 583,989 ✓). 17 posts (ranks 3, 6, 7, …) render "–" in Impressions/Organic/Paid — no data to add. Sum row 8,690,567+105,084 = 8,795,651 ✓ | ✅ PASS (17 no-data posts noted) |
| A5 | Engagements / Impressions = Engagement Rate | 13/13 within rounding (43,333/4,761,429 = 0.91% ✓; 28,214/537,287 = 5.25% ✓; 23,926/583,989 = 4.10% ✓); the 17 no-data posts show "–" for Engagement Rate too (consistent) | ✅ PASS |

## Evidence
`.playwright-out/QA-19698/01-fb-impressions-table.png`

## Known bugs checked
DATA-9631/9652/9659, APPS-51730 (all closed) not reproduced. The platform shows a "Facebook Data Collection Disruption 9/27" banner — the 17 impression-less posts in the current week are plausibly that disruption, not a math defect; flag to data team if it persists.

## Bugs filed
None. · **Cleanup:** none.
