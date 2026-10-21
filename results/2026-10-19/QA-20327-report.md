# QA-20327 — Brand Content > Facebook Only: Reactions Data Set > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jan. 01, 2024 – Dec. 31, 2024 · **Channel:** Facebook only · **Data set:** Facebook Only: Reactions
**Verdict: PASS (1/1) — Likes + Loves + Hahas + Wows + Sads + Angries + Others = Reactions on all 200 rendered posts (of 2,555) and on the Sum row**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Σ(7 reaction types) = Reactions | 200/200 (rank 1: 1,355,186 + 20,843 + 1,364 + 3,454 + 129 + 134 + 0 = 1,381,110 ✓; rank 2: 581,735 ✓). Sum row 8,637,624 + 998,664 + 349,163 + 27,164 + 69,509 + 3,016 + 0 = 10,085,140 ✓ | ✅ PASS |

Evidence: `.playwright-out/QA-20327/01-fb-reactions-2024.png` · Known bugs: none open · Bugs filed: none · Cleanup: none.
