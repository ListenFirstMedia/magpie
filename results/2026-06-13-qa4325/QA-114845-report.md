# QA-114845 — Brand > Insights - Hovering functionality and PNG Export — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand tried:** UCLA (127756)
- **Skills:** chart-hover-tooltip, audience-metrics-export
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang

## Steps
1. Opened Brand > Insights for **UCLA** in a fresh tab. The page shell loaded (Insights tab, Channels, Data Visualization dropdown), but once the **insight tiles began rendering the renderer froze** — screenshot/JS/tab-close all timed out (>45s CDP).
2. Recovery: created a fresh tab; abandoned the frozen Insights tab.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Insights tiles render | Donut/Bar tiles (e.g., Total Followers, Fan Growth Rate) | Renderer hung during tile render | ⛔ |
| Hover tooltips | Recharts donut/bar hover tooltips | Not reachable | ⛔ |
| Tile PNG export | Valid PNG per tile | Not reachable | ⛔ |

## Notes / automation learning
- **Brand>Insights renderer hang is reproducing across every brand this session** (MTV, #1 Happy Family USA in QA-51457; UCLA here). The page shell paints, then the chart/BRI tiles freeze the CDP pipeline. Recovery = abandon the tab. Strong perf-ticket candidate (cf. APPS-55565).
- The hovering + tile-PNG functionality itself was **verified end-to-end in the 2026-06-04 run** (`chart-hover-tooltip` + `audience-metrics-export`: Michael Kors Total Followers donut hover `Facebook: 18,703,444 / …`, Fan Growth Rate bar hover; Pie 49KB / Bar 73KB PNGs). Only the render-dependent capture is blocked now.
- Recommend manual / real-browser verification for all Brand>Insights cases this set.

## Bugs filed
_None new — carry-forward Brand>Insights renderer-hang perf concern._
