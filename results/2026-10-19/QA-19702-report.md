# QA-19702 — Brand Content - Facebook Only: Completed & Live Video DataSet - Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Facebook only · **Data set:** Facebook Only: Completed Video Views (the dropdown label for the spec's "Completed & Live Video" set)
**Verdict: PASS (1/1) — Organic Completed Views + Paid Completed Views = Completed Views on all 12 posts with data; 17 posts carry "–" (no video-insight data)**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Data Set = Facebook Only: Completed Video Views | ✅ Posts (29); columns Engagements, Video Duration, Avg Time Watched, Avg Viewthru, Completed Views, Organic Completed Views, Paid Completed Views |
| 4 | Table View; all 29 rows scraped | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Completed Views + Paid Completed Views = Completed Views | 12/12 evaluable (rank 1: 1,245,297+0 = 1,245,297 ✓; rank 4: 50,903+6,059 = 56,962 ✓); 17 posts "–" on all three columns. Sum row 1,695,101+6,059 = 1,701,160 ✓ | ✅ PASS (17 no-data posts noted) |

## Evidence
`.playwright-out/QA-19702/01-fb-completed-table.png`

## Known bugs checked
No open linked bugs. Same 17 no-data Facebook posts as QA-19698/19700 (data-collection disruption banner).

## Bugs filed
None. · **Cleanup:** none.
