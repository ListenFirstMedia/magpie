# QA-19706 — Brand Content - Instagram Only: Insights - Current Date Range Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Instagram only · **Data set:** Instagram Only: Insights
**Verdict: PASS (1/1) — Paid Saves + Organic Saves = Saves on all 38 posts (Paid Saves renders "–" = no paid posts this week, Organic Saves equals Saves) and on the Sum row**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Instagram only, Data Set = Instagram Only: Insights | ✅ Posts (38); columns Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness |
| 4 | Table View; all 38 rows scraped | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Paid Saves + Organic Saves = Total Saves | 38/38 with Paid Saves "–" (no boosted posts in range → 0): rank 1: –+30,909 = 30,909 ✓; rank 2: 8,418 ✓; rank 3: 3,278 ✓. Sum row: Organic 126,800 = Saves 126,800, Paid "–" ✓ | ✅ PASS |

## Evidence
`.playwright-out/QA-19706/01-ig-insights-table.png`

## Known bugs checked
APPS-34343 (closed) not reproduced; APPS-62446 (Paid Saves en-dash on *paid* posts) not exercisable here — no paid posts in the current week (that bug is covered by QA-20526).

## Bugs filed
None. · **Cleanup:** none.
