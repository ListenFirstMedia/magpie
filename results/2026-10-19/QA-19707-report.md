# QA-19707 — Brand Content - YouTube Only: Insights & YouTube Only: Premium Dataset - Current Date Range Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** YouTube only · **Data sets:** YouTube Only: Insights, then YouTube Only: Premium
**Verdict: PASS (3/3) — all three watch-time / premium identities hold on the 10 videos that carry insight data; 3 of 13 videos show "–" on every insight column**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, YouTube only, Data Set = YouTube Only: Insights | ✅ Posts (13); columns Video Views, Organic/Paid/Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time, Paid Watch Time, Avg View Duration, Shares, Dislikes |
| 4 | Table View; Organic + Paid Watch Time per video | ✅ |
| 5 | Data Set = YouTube Only: Premium | ✅ Posts (13); columns Premium Views, Organic/Paid Premium Views, Premium Watch Time (Minutes), Organic/Paid Premium Watch Time |
| 6–7 | Organic + Paid Premium Views; Organic + Paid Premium Watch Time | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Watch Time + Paid Watch Time = YouTube Watch Time (Minutes) | 10/10 evaluable (rank 1: 361,336.64 + 7,187,136.83 = 7,548,473.47 ✓; rank 2: 76,848.02 + – = 76,848.02 ✓; rank 4: 25,463.95 ✓). Paid is "–" on non-promoted videos (treated as 0). 3 videos (ranks 3, 5, 11) "–" everywhere. Sum row 538,534.46 + 7,187,136.83 = 7,725,671.29 vs 7,725,671.28 (±0.01 rounding) ✓ | ✅ PASS |
| A6 | Organic Premium Views + Paid Premium Views = Premium Views | 10/10 (rank 1: 42,065 + 0 = 42,065 ✓; rank 2: 12,685 ✓; rank 3: 11,364 ✓); ranks 11–13 "–". Sum row 96,712 + 0 = 96,712 ✓ | ✅ PASS |
| A7 | Organic Premium Watch Time + Paid Premium Watch Time = Premium Watch Time (Minutes) | 10/10 (rank 1: 62,164.77 + 0.00 = 62,164.77 ✓; rank 2: 10,355.58 ✓; rank 3: 3,201.25 ✓). Sum row 98,477.71 + 0.00 = 98,477.71 ✓ | ✅ PASS |

## Evidence
`.playwright-out/QA-19707/01-yt-insights-table.png`, `.playwright-out/QA-19707/02-yt-premium-table.png`

## Known bugs checked
- APPS-60871 (Open, en-dash for YouTube Insights/Premium metrics on **Amazon Prime Video**) — does **not** reproduce on HBO Max: Watch Time, Premium Views and Premium Watch Time are populated. The 3 fully-dashed videos are the normal "no insight yet" case, not the bug pattern (which dashes *all* posts).
- LFMP-29835 (closed) not reproduced.

## Bugs filed
None. · **Cleanup:** none.
