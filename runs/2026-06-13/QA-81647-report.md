# QA-81647 — Reporting > Data Studio - Data Visualization — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Metric:** Total Followers · **report_id:** 296281
- **Skills:** data-studio-post-level-run
- **Result:** ✅ PASS — **upgrades prior 2026-06-05 NOT-VERIFIED** (DS metric-tree friction worked around via dispatched-event metric selection)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Visualization renders | Chart renders for the selected metric | Total Followers line chart, Legend `MTV [P]`, Y-axis 0–110M | ✅ |
| Chart-type selector | Line/Bar/Area/Pie options | Dropdown lists **Area / Bar / Line / Pie** | ✅ |
| Chart re-renders on type switch | Switching type updates the viz | Line → Bar: 7 `<svg rect>` bars (one per day Jun 5–11), chartType label "Bar" | ✅ |
| Mode + controls | Mode Brand/Metric toggle, Graph Metric dropdown, Graph Brands | All present and functional | ✅ |

## Notes
- DS metric-tree selection required dispatched `mousedown/mouseup/click` events on the metric name (bare ref click is removed on re-render) — documented friction, worked around this run.

## Bugs filed
_None._
