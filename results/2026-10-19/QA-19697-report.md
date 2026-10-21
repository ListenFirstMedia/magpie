# QA-19697 — Brand Content - Engagements Breakdowns - Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Data set:** Engagements Breakdown · Channels: Twitter only (steps 4–7), then Instagram only (steps 8–11) · Table View, every row scraped
**Verdict: PASS (6/6) — all breakdown identities hold on every evaluable post for both channels**

## Twitter only (Posts 23)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Organic + Paid Engagements = Engagements | 23/23 (rank 1: 33,854 + – = 33,854 ✓; rank 2: 17,285 ✓) — no paid tweets, Paid = "–" | ✅ |
| A6 | Organic Reactions + Comments + Shares = Organic Engagements | 21/21 evaluable (rank 1: 26,496 + 931 + 6,427 = 33,854 ✓; rank 2: 14,974 + 198 + 2,113 = 17,285 ✓); 2 posts had an organic component "–" | ✅ |
| A7 | Paid Reactions + Comments + Shares = Paid Engagements | no paid tweets in range (all "–") — nothing to evaluate, consistent | ✅ (n/a) |

## Instagram only (Posts 38)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A9 | Organic + Paid Engagements = Engagements | 38/38 (rank 1: 703,949 + 5,035 = 708,984 ✓; rank 2: 112,441 + – ✓) | ✅ |
| A10 | Organic R + C + S = Organic Engagements | 38/38 (rank 1: 667,560 + 36,389 + – = 703,949 ✓; rank 2: 110,286 + 2,155 = 112,441 ✓) — Instagram has no Shares breakdown ("–") | ✅ |
| A11 | Paid R + C + S = Paid Engagements | 1/1 paid post (rank 1: 4,937 + 98 + – = 5,035 ✓); the other 37 are organic ("–") | ✅ |

## Evidence
`.playwright-out/QA-19697/01-tw-eng-breakdown.png`, `02-ig-eng-breakdown.png`

## Notes
- The Twitter table first rendered "This table failed to load" → Reload recovered it (dev slowness, not a defect).

## Known bugs checked
APPS-58817 (Open, deleted native posts still visible) does not affect the identities; DATA-12256/APPS-31198 (closed) not reproduced.

## Bugs filed
None. · **Cleanup:** none.
