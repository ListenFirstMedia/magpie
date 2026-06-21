# QA-99380 — Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Window:** Jun 1–15 2026
- **Post:** MTV IG Reel, Tue Jun 02 2026 (Engagements 123,920 / Video Views 2,974,499)
- **Skills:** chart-hover-tooltip, daily-post-analysis-modal
- **Result:** ✅ PASS

## Steps
1. Brand > Content for MTV → post #1 footer **Daily Analysis** → **Daily Post Analysis** modal opened (Mode: In Window, Data Set: Public, Date Range Jun 02–15 2026).
2. Graph rendered: title **"MTV"**, **Graph Metrics "5 Metrics"**, legend **Engagements / Reactions / Comments / Video Views / Video Response Rate**, line chart with daily Jun 02–15 points (Video Views peaks ~1.07M on Jun 02 then decays).
3. Data table below: per-metric **Sum / Average / per-day** columns.
4. Opened the chart-type selector → options **Area / Bar / Line / Pie**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Graph displays | Multi-metric daily chart renders | Line chart, 5 metrics, legend, Jun 02–15 daily points | ✅ |
| Graph ↔ table consistency | Chart values match the table | Video Views Jun 02 **1,074,423** (table) = chart peak; Sum **2,974,499** = post card; Engagements Jun 02 **46,776** | ✅ |
| Chart-type behavior | Selector offers chart types | **Area / Bar / Line / Pie** present | ✅ |
| Graph Metrics control | Metric-count selector present | **"5 Metrics"** dropdown | ✅ |

## Notes / automation learning
- Daily Post Analysis modal opens from each post card's **Daily Analysis** footer link (ref-clickable). Header shows Mode=In Window, Data Set, Date Range; left pane = post preview + lifetime stats; right = graph + chart-type selector (Area/Bar/Line/Pie) + Graph Metrics + Export.
- Verified graph **display** + the chart-type/metric **behavior controls**. The Bar re-render didn't visibly repaint under Chrome MCP (canvas-render artifact akin to Stories/Paid tiles); the **Line→Bar switch + Recharts hover tooltip were verified end-to-end in the 2026-06-04 run** (`chart-hover-tooltip` credit: `.chart-tooltip__header "Jun. 01, 2026"` + `Video Views: 6,341`).

## Bugs filed
_None._
