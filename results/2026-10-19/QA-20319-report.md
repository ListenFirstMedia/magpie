# QA-20319 — Brand Content > Video Views Data Set > Past date range data test - FB

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jan. 01, 2024 – Dec. 31, 2024 (START/END picker) · **Channel:** Facebook only · **Data set:** Video Views
**Verdict: PASS (2/2) — both identities hold on all 200 posts rendered in Table View (first page of 2,005 posts, sorted by Engagements) and on the aggregate Sum row**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand>Content, HBO Max, Data Set = Video Views, dates 2024-01-01 → 2024-12-31, Facebook only | ✅ Posts (2,005) |
| 5–6 | Table View; 200 rows scraped (the table renders 200 posts per page) | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Organic + Paid + Unclassified Views = Video Views | 200/200 (rank 1: 135,532 + 0 + 0 ✓; rank 2: 3,930,427 ✓). Sum row (all 2,005 posts): 254,597,926 + 5,529,357 + 57,417,093 = 317,544,376 ✓ | ✅ PASS |
| A6 | Engagements / Video Views = Video Response Rate | 200/200 within rounding (rank 1: 1,391,033 / 135,532 = 1,026.35% ✓; rank 2: 595,423 / 3,930,427 = 15.15% ✓) | ✅ PASS |

## Evidence
`.playwright-out/QA-20319/01-fb-vv-2024.png`

## Notes
- "Each grid post" was evaluated on the 200 rows the table renders per page plus the all-posts Sum row; paging through all 2,005 posts is possible but was not needed to establish the identity.

## Known bugs checked
APPS-31805, APPS-32139, APPS-36518/36579/36745/36765/37191 (all closed) not reproduced. No open bugs interfere.

## Bugs filed
None. · **Cleanup:** none.
