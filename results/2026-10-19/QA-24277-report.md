# QA-24277 — Brand Content - Engagement Breakdown Data Set - Aggregate Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Data set:** Engagements Breakdown (the set auto-narrows the channel row to Twitter + Instagram; Posts 61) · Aggregate row in Table View, Sum then Average
**Verdict: PASS (3/3) — all three breakdown identities hold on the Sum row exactly and on the Average row within display rounding**

## Assertions
| ID | Expected | Sum row | Average row | Status |
|----|----------|---------|-------------|--------|
| A4 | Organic Engagements + Paid Engagements = Engagements | 1,974,934 + 5,035 = 1,979,969 ✓ | 32,376 + 83 = 32,459 ✓ | ✅ PASS |
| A5 | Organic Reactions + Organic Comments + Organic Shares = Organic Engagements | 1,915,729 + 46,622 + 12,583 = 1,974,934 ✓ | 31,405 + 764 + 206 = 32,375 vs displayed 32,376 (Δ1 = rounding of individually-rounded averages; exact: 1,974,934 ÷ 61 = 32,376.0 ✓) | ✅ PASS (rounding noted) |
| A6 | Paid Reactions + Paid Comments + Paid Shares = Paid Engagements | 4,937 + 98 + – (0) = 5,035 ✓ | 81 + 2 + – = 83 ✓ | ✅ PASS |

## Evidence
`.playwright-out/QA-24277/01-eng-breakdown-agg.png`

## Known bugs checked
APPS-60312, APPS-39995, LFMP-28295, DATA-9746 (all closed) — not reproduced. No open linked bugs.

## Bugs filed
None. · **Cleanup:** none.
