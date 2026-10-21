# QA-19696 — Brand Content - Basic Data Set - Data Test

**Run date:** 2026-10-19 (Monday → rotation row: account **HBO Max**, brand **HBO Max**) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614, account default — exact name) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Facebook only · **Data set:** Public (Basic) · Perspective: Authorized (default)
**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 30 posts and on the Sum row**

## Steps
| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand → Content | ✅ |
| 2 | Brand HBO Max | ✅ |
| 3 | Facebook only → Apply | ✅ Posts (30) |
| 4 | Each post: Reactions + Comments + Shares (Table View, all 30 rows scraped) | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Reactions + Comments + Shares = Engagements | 30/30 (rank 1: 42,496+293+544 = 43,333 ✓; rank 2: 26,864+245+1,105 = 28,214 ✓; rank 3: 24,978+344+1,745 = 27,067 ✓). Sum row 181,567+2,935+6,813 = 191,315 ✓ | ✅ PASS |

## Evidence
`.playwright-out/QA-19696/01-fb-public-table.png`

## Known bugs checked
No open linked bugs (APPS-58172 is a JMeter-account task). A "Facebook Data Collection Disruption 9/27" platform banner is showing; it did not affect this identity.

## Bugs filed
None. · **Cleanup:** none.
