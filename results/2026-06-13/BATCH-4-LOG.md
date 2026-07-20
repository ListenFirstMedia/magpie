# QA-22296 Re-run — Batch 4/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-63603, QA-75011, QA-79157, QA-81416, QA-81647 (order 16–20)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-63603 | Settings > Tags - Upload Tags | ⚠️ PARTIAL | Upload Tags affordance absent on Settings>Tags (lives on Brand>Content); Content Tagged present. Re-confirms drift |
| QA-75011 | Settings > Custom Metrics - Basic View | ✅ PASS | 6 cols (Metric/Description/Created Date/Creator/Formula/Actions) + Create button + many rows; APPS-49018 not reproduced |
| QA-79157 | Mixpanel - API Metrics | 🚫 BLOCKED | Out of scope (third-party Prod Mixpanel) |
| QA-81416 | DS Report Table - CSV & GS Export | ✅ PASS | report 296281; CSV row-by-row matches UI (Total Followers MTV 7-day); GS opens docs.google.com sheet |
| QA-81647 | DS - Data Visualization | ✅ PASS | **Upgrades prior NOT-VERIFIED** — chart renders, Area/Bar/Line/Pie selector, Line→Bar re-render (7 bars), Mode toggle |

## Headline
- 3 PASS (incl. QA-81647 upgrade), 1 PARTIAL (spec drift), 1 BLOCKED (out-of-scope). No new product bugs.
- DS metric-tree friction worked around via dispatched mouse events on metric name (bare ref click removed on re-render) — reusable learning.

## Cleanup
- DS report 296281 created (harmless). No mutations.
