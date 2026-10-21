# QA-20330 — Brand Content > YouTube Only: Insights & YouTube Only: Premium Data Set > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jan. 01, 2024 – Dec. 31, 2024 · **Channel:** YouTube only · **Data sets:** YouTube Only: Insights, then YouTube Only: Premium · Table View, 200 rendered rows (of 1,750) + Sum row
**Verdict: PASS (4/4)**

| ID | Expected | Actual (200 rendered posts + Sum row) | Status |
|----|----------|------|--------|
| A4 | Organic + Paid Watch Time = YouTube Watch Time (Minutes) | 200/200 (rank 1: 40,369,761.73 + – ✓; rank 2: 5,532,051.48 + 16,677,433.18 = 22,209,484.66 ✓). Sum 318,217,676.20 + 58,426,292.24 = 376,643,968.44 ✓ | ✅ |
| A5 | Organic + Paid + Unclassified Views = Video Views | 200/200 (rank 1: 14,319,141 + – + 1,040 = 14,320,181 ✓; rank 2: 3,436,383 + 8,203,338 + 0 = 11,639,721 ✓). Sum 241,701,944 + 30,931,868 + 13,176,777 = 285,810,589 ✓ | ✅ |
| A7 | Organic + Paid Premium Views = Premium Views | 200/200 (rank 1: 2,396,366 + – ✓). Sum 34,148,989 + 0 ✓ | ✅ |
| A8 | Organic + Paid Premium Watch Time = Premium Watch Time | 200/200 (rank 1: 7,218,320.97 + – ✓). Sum 49,228,014.64 + 0.00 ✓ | ✅ |

Evidence: `.playwright-out/QA-20330/01-yt-insights-2024.png`, `02-yt-premium-2024.png` · Known bugs: APPS-60871 (Open, APV) does not reproduce on HBO Max — all YouTube insight columns populated · Bugs filed: none · Cleanup: none.
