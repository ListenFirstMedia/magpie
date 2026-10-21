# QA-20329 — Brand Content > Instagram Only: Insights > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jan. 01, 2024 – Dec. 31, 2024 · **Channel:** Instagram only · **Data set:** Instagram Only: Insights
**Verdict: PASS (1/1) — Paid Saves + Organic Saves = Saves on all 200 rendered posts (of 2,300) and on the Sum row (2,152,593)**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Paid Saves + Organic Saves = Saves | 200/200 (rank 1: – + 19,972 = 19,972 ✓; rank 2: 14,392 ✓); Paid Saves "–" on every rendered post (top-200 by engagement are organic). Sum row Organic 2,152,593 = Saves 2,152,593 ✓ | ✅ PASS |

Evidence: `.playwright-out/QA-20329/01-ig-saves-2024.png` · Known bugs: APPS-62446 (Paid Saves en-dash on paid posts) not exercisable here — covered by QA-20526 · Bugs filed: none · Cleanup: none.
