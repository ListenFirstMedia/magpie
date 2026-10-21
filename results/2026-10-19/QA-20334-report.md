# QA-20334 — Brand Content > Pinterest Only: Basic Data Set > Past date range data test

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Sephora (655) · **Brand:** Sephora (7159) · **Date range:** Jun. 11, 2024 – Jun. 10, 2025 · **Data set:** Pinterest Only: Basic (auto-selects the Pinterest channel) · Posts (62,031) · Table View, 200 rendered rows + Sum row
**Verdict: PASS with a data flag — Engagements = Pin Saves + Comments holds on 200/200 rows and on the Sum row, but only because Pin Saves renders "–" on every pin (Engagements equals Comments: rank 1 27 = – + 27; Sum 670 = – + 670)**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Pin Saves + Comments = Engagements | 200/200 with Pin Saves "–" treated as 0 (rank 1: – + 27 = 27 ✓; rank 2: – + 20 = 20 ✓). Sum row: Pin Saves "–", Comments 670, Engagements 670 ✓. **Pin Saves is "–" for 100% of 62,031 pins** — if Pinterest still supplies save counts this is a collection gap, not a math defect | ✅ PASS (flag Pin Saves) |

Evidence: `.playwright-out/QA-20334/01-pinterest-basic-2024-25.png` · Known bugs: APPS-31714/34929/51562 (closed) · Bugs filed: none (flag raised for the data team) · Cleanup: none.
