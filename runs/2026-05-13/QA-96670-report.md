# QA-96670 — Brand > Insights - Threads - Hovering Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96670
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** HBO Max (account_id 657)
- **Brand:** HBO Max (brand_id 155614)
- **Channel:** Threads only
- **Result:** ⚠ **A1 PARTIAL, A2-A5 INCONCLUSIVE (no Threads data + hover hard to automate)**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3) | Graph type dropdown + Export + Save to Dashboard appear for all big numbers | All visible tiles (Total Followers, New Posts, Engagements) show `Bar ▼ | Export ▼ | Save to Dashboard ▼` controls at bottom (Total Followers has just Export + Save to Dashboard because donut). Structural assertion satisfied. | ✅ |
| A2 (4a) | Bar-chart tooltip: `Mon. DD, YYYY` / `icon channel name: value` | Not verifiable — HBO Max has 0 Threads data for May 11-17, 2026 (all bars are flat at 0). No bar to hover over. | ⏸ Inconclusive (no data) |
| A3 (4b) | Bar color matches legend color | Legend shows ■ Threads (black). Bars rendering 0 — color cannot be assessed at 0 height. | ⏸ Inconclusive (no data) |
| A4 (5) | Area-chart tooltip: `MMM.DD,YYYY : Value` / `icon channel name: value` | Same issue — no data points to hover. | ⏸ Inconclusive (no data) |
| A5 (7) | Pie tooltip: `Channel icon Threads: value` | Not exercised. | ⏸ |

## Why most assertions are inconclusive

1. **HBO Max has no Threads activity in May 11-17, 2026** — all metrics report 0 (–). Without data points, hover tooltips don't render anything to verify. The assertion structure is correct but the data state doesn't expose it.
2. **Hover testing is inherently hard via Chrome MCP** — `hover` requires precise pixel coordinates that match a chart-element. With 0 data, the targets don't exist.
3. **A5 (pie tooltip)** requires changing Graph Type to Pie first — feasible but contingent on having data.

## Next-iteration recommendations

- Switch to a brand/account combination where Threads has activity (any brand with ≥1 Thread post in the date range). Then re-test with the same steps.
- Consider widening the date range to capture historical Thread activity if Threads is sparse on HBO Max.
- Use a JS-based approach: dispatch `mousemove` events on chart paths with computed coordinates from the SVG. Requires per-chart-type adapter.

## Bugs filed
None — inability to verify is a data/data-availability issue, not a product defect.
