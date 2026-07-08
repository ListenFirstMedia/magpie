# QA-1124 — Brand Insights - Public Data - Hovering Functionality

- **Run date:** 2026-07-04 (headless, unattended, Playwright MCP track)
- **Source:** testcases/english/QA-1124.md · https://listenfirstmedia.atlassian.net/browse/QA-1124
- **Account:** Hulu (account_id=336) · **Brand:** Hulu · **Component:** Brand Explorer > Insights
- **Perspective:** Public Data (toggled explicitly; brand entity swapped 5670→11003, perspective=standard — expected, per view-perspective-toggle skill)
- **Date range:** Last 30 Days (Jun. 03, 2026 – Jul. 02, 2026); Compared to May 04 – Jun 02, 2026
- **Open-bug screen (Rule 7):** "None open" → ran normally.
- **Verdict:** **PASS (13/13 assertions)**
- **Skills used:** chart-hover-tooltip (v3), view-perspective-toggle (v2), brand-insights-interval-picker (date preset)

## Pre-flight
Programmatic email/password login as lfiqa@listenfirstmedia.com → oauth_callback → `#home` (title "Home - ListenFirst") rendered. Account resolved to Hulu (account_id=336) with valid from/to/compare params. PASS.

## Steps executed
1. Hovered Brand top-nav (opens on hover) → clicked **Insights** (`#explore/brand/insights?brand_id=5670`). ✓
2. Opened brand selector chevron → typed "Hulu" in "Search for a Brand". ✓
3. Selected the exact-match **Hulu** option (`.lfm-ta-option`, Rule 1). Brand confirmed brand_id=5670. ✓
4. Date Range picker → "Make a Selection" → **Last 30 Days**; range display = "Jun. 03, 2026 - Jul. 02, 2026". ✓
5. Clicked the **View perspective toggle** (`label[for="perspective"]`, Rule 2) from Authorized (checked=true) → **Public Data** (checked=false); confirmed via DOM probe + screenshot. Reviewed all bar graphs. ✓
6. Hovered **Follower Growth** stacked bar (Twitter Jun 16). ✓
7. Hovered **New Posts** stacked bar (TikTok Jun 17). ✓
8. Hovered **Engagements** stacked bar (TikTok Jun 17). ✓
9. Hovered **Response Rate** bar (Jun 18). ✓
10. Hovered **Fan Growth Rate** bar (Jun 20). ✓
11. Hovered **Views** area chart datapoint (Twitter Jun 18). ✓
12. Hovered **Total Followers** pie/donut (Facebook arc; dispatched mouseover/mousemove on arc path — pointer-interception workaround). ✓
13. Data Visualization dropdown → **Channel View: Aggregate**; charts collapsed to a single aggregate series (Engagements bars 120→30, PVV circles 120→30). ✓
14. Hovered **Public Video Views** area chart datapoint (Jun 18, aggregate). ✓

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | In every graph, tooltip data displays only for channels available in legend | Multi-channel tooltips show exactly Facebook/Twitter/Instagram/TikTok = legend chips; Views tooltip = Twitter only (Public Views is Twitter-only); rate charts show metric name; donut shows all 4 legend channels | PASS |
| A2 | 5b | "Compared to" tweak available in all bar charts | Global "Compared to: May 04 – Jun 02, 2026" control present; every bar tile legend carries a "- Compared To" entry + compare reference markers on bars | PASS |
| A3 | 6a | Chart is hoverable | Follower Growth bar rendered tooltip on hover | PASS |
| A4 | 6b | Tooltip = `Mon. DD, YYYY` + `Channel names: Values`; hovered channel highlighted | `Jun. 16, 2026` · Facebook: 1,272 (-16.3%) · Twitter: 18,035 (-2.7%) · Instagram: 1,341 (+8.1%) · TikTok: 0 (0.0%); hovered Twitter row had class `chart-tooltip__row--selected` (highlighted) | PASS |
| A5 | 7 | Hovered channel highlighted in tooltip | New Posts `Jun. 17, 2026`; FB 8 / Twitter 6 / IG 9 / TikTok 9; hovered **TikTok** row `--selected` | PASS |
| A6 | 8 | Hovered channel highlighted in tooltip | Engagements `Jun. 17, 2026`; FB 18,043 / Twitter 8,648 / IG 230,284 / TikTok 141,605; hovered **TikTok** row `--selected` | PASS |
| A7 | 9 | Tooltip = `Mon. DD, YYYY` + `Chart Name: Values` | Response Rate: `Jun. 18, 2026` + `Response Rate: 0.31%` | PASS |
| A8 | 10 | Tooltip = `Mon. DD, YYYY` + `Chart Name: Values` | Fan Growth Rate: `Jun. 20, 2026` + `Fan Growth Rate: 0.68%` | PASS |
| A9 | 11 | Tooltip = `Mon. DD, YYYY` + `Channel icon Twitter: Values` | Views: `Jun. 18, 2026` + `Twitter: 271,682 (-75.7%)` with Twitter icon (`fab fa-square-x-twitter`) | PASS |
| A10 | 12a | Tooltip outlined as `icon Facebook: #N` | Total Followers donut (`.al-donut__tooltip`): `Facebook: 6,209,733` (icon `fab fa-facebook-square`) / Twitter: 2,452,406 / Instagram: 2,994,803 / TikTok: 6,200,000 — each with channel icon | PASS |
| A11 | 12b | Area chart updated to Aggregate View | After Channel View: Aggregate, bar tiles collapsed 4-channel→single series (Engagements 120→30 bars) and area tiles single series (Public Video Views 120→30 circles, `data-circle lfm`) | PASS |
| A12 | 13 | Tooltips in correct format `Mon. DD, YYYY` + chart-name-prefixed value lines | Aggregate Engagements: `Jun. 24, 2026` + `Engagements: 482,536` (single chart-name-prefixed line) | PASS |
| A13 | 14 | Tooltip = `Mon. DD, YYYY` + `Public Video Views: values` | `Jun. 18, 2026` + `Public Video Views: 9,355,961` | PASS |

## Evidence (screenshots under .playwright-out/QA-1124/)
- `step5-public-toggle.png` — Public Data active (toggle left), 30-day range, all 8 tiles rendered
- `step6-follower-growth-tooltip.png` — Follower Growth per-channel tooltip, Twitter highlighted
- `step11-views-tooltip.png` — Views area tooltip, Twitter-only
- `step12-total-followers-donut.png` — Total Followers donut tooltip with per-channel icons
- `step14-aggregate-pvv-tooltip.png` — Aggregate view; Public Video Views single-series tooltip
- `step2-brand-dropdown.png`, `step4-datepicker.png` — brand-select + date-range setup

## Notes
- Twitter icon rendered as `fab fa-square-x-twitter` (X logo) across all tooltips — no blue-Twitter-icon issue (historical LFMP-31781 not reproduced; consistent with skill's recent runs).
- Perspective toggle swapping brand_id 5670→11003 on flip to Public is documented expected behavior, not a defect.
- No Google Sheets or export/download steps in this case (nothing out-of-scope skipped).

## Bugs filed
None. All assertions passed; no new defects observed.
