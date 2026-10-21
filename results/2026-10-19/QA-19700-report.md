# QA-19700 — Brand Content - Video Views Dataset - Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Facebook only · **Data set:** Video Views
**Verdict: PASS (2/2) — identities hold on all 12 posts that carry video-view data; 17 posts show "–" for every view metric (no data), consistent with the Impressions case**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Data Set = Video Views, Facebook only | ✅ Posts (29) |
| 4–5 | Table View; all 29 rows scraped (Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, …) | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Views + Paid Views = Video Views | 12/12 evaluable posts (rank 1: 1,661,627+0 = 1,661,627 ✓; rank 4: 204,798+51,565 = 256,363 ✓); Unclassified Views = 0 on all; 17 posts show "–" across all view metrics. Sum row 3,059,411+51,565 = 3,110,976 ✓ | ✅ PASS (17 no-data posts noted) |
| A5 | Engagements / Video Views = Video Response Rate | 12/12 within rounding (43,333/1,661,627 = 2.61% ✓; 28,214/221,142 = 12.76% ✓; 23,926/256,363 = 9.33% ✓) | ✅ PASS |

## Evidence
`.playwright-out/QA-19700/01-fb-videoviews-table.png`

## Known bugs checked
APPS-31805, APPS-36518/36579/36745/36765/37191 (all closed) not reproduced. The 17 no-data posts coincide with the "Facebook Data Collection Disruption 9/27" banner.

## Bugs filed
None. · **Cleanup:** none.
