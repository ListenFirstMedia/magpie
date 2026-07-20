# QA-99380 — Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior (re-run 2026-06-04 batch-7)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-99380
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Adam Orfei (brand_id=3801) — top-of-list per default sort by responses_mixed desc
- **Date range:** May 27 – Jun 02 2026 (default 7D)
- **Post selected:** Michael Kors top post (sort key = lfm.content.responses_mixed desc)
- **Perspective:** `perspective=extended` (Authorized) per URL

## Result: PASS (5/5) — Daily Post Analysis Modal Graph displays correctly + behavior verified

## Steps executed
1. Brand Content page loaded for Adam Orfei brand (default date range 7D, Public data set, perspective=extended).
2. Posts table rendered with Posts(20) row count.
3. Clicked first `button.daily-analysis-button` in Posts table.
4. Daily Post Analysis modal opened (`.al-daily-post-analysis-modal`).
5. Verified modal header: `Date Range: May. 29, 2026 - Jun. 02, 2026 / Mode: In Window / Data Set: Public / Graph Metrics: 5 Metrics / Michael Kors`.
6. Verified Line graph SVG: 14 stroke paths + 25 circles + axis labels `May. 29 / May. 30 / May. 31 / Jun. 01 / Jun. 02` + Y axis 0–70K.
7. Verified Legend: Engagements / Reactions / Comments / Video Views / Video Response Rate.
8. Hovered over a data circle near `(1100, 500)` → tooltip rendered.
9. Switched chart type Line → Bar via `Line` dropdown (which exposed `Area / Bar / Line / Pie` options).
10. Verified Bar chart: 25 `<rect>` bars (5 days × 5 metrics), axis labels unchanged.
11. Verified Modal Table beneath graph: 5 metrics × (Sum + Average + 5 date columns).
12. Closed modal.

## Tooltip evidence

Hover at `(1100, 500)` (over Video Views circle on Jun. 01):
```
.chart-tooltip__header = "Jun. 01, 2026"
.chart-tooltip__row    = "Video Views: 6,341"
container = .al-area-chart__tooltip > .app-lib chart-tooltip
```

## Chart-type behavior

`Line` dropdown displays options: **Line / Area / Bar / Pie**. Switching to Bar:
- SVG `rect.recharts-rectangle` count goes from 0 → 25 (5 days × 5 metrics).
- Axis labels and metric legend persist.
- Tooltip mechanism continues to render `chart-tooltip__header + chart-tooltip__row`.

## Table content (below graph)

Modal also has a Table section beneath the chart with columns Metric / Sum / Average / May.29 / May.30 / May.31 / Jun.01 / Jun.02 and row examples:
- Engagements: 2,926 / 585 / 931 / 1,487 / 322 / 104 / 82
- Reactions: (begins of next row — content truncated by snippet)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Modal opens with Line/Graph view | `.al-daily-post-analysis-modal` rendered; default chart type = Line | PASS |
| A2 | Graph shows all in-range days with axis labels | 5 day labels + 0–70K Y axis ticks present | PASS |
| A3 | Hover tooltip displays values | `.chart-tooltip__header "Jun. 01, 2026"` + `.chart-tooltip__row "Video Views: 6,341"` | PASS |
| A4 | Switching chart type repopulates graph | Line → Bar: 25 rects rendered, axes persist | PASS |
| A5 | No unexpected endash | All 5 days populated for the post (no `–`) | PASS |

## DATA-12209 probe
Test brand = Michael Kors (top post), channel = Instagram (per top sort). Not TikTok. DATA-12209 specifically affects TikTok rows on May 16 2026 — out of range here. Probe N/A this run.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-99380-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-99380.md` (proxy spec)

## Notes
- The DPA modal contains both a Graph (Line/Area/Bar/Pie) and a Table beneath; QA-99380 covers Graph side, QA-99416 covers Table side (latter on Brand Sets surface).
- 5 metrics auto-overlaid in Line view; `1.5K range` between metrics fits Recharts y-domain logic.
- Reuses `chart-hover-tooltip` skill pattern.
