# QA-298 — Reporting - TWC Graphs - Hovering Functionality

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Account:** Hulu (switched from Adam Orfei via TWC account-switcher → Search Account → Results "Hulu")
- **Brand:** Hulu (exact typeahead Results match, Rule 1)
- **Report:** `app-reporting.lfmdev.in/#story/time_window_comparison/155893`
- **Date range:** Jul 3, 2026 – Jul 9, 2026 (default Absolute Dates range)
- **Perspective:** Public Data (default; spec does not specify)
- **Skills used:** `time-window-comparison-run` (v6), `chart-hover-tooltip` (v3)
- **Verdict: PASS**

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Click Reporting in Top Nav | Navigated to TWC builder (`#/time_window_comparison`); builder pane fully mounted (Add Brands, metric tree, Run Report) — the 2026-07-10 TWC render-hang quirk did NOT reproduce |
| 2 | Select 'Time Window Comparison' | On TWC builder, header `Account: Hulu \| Reporting > Time Window Comparison` |
| 3 | Type and select 'Hulu' brand | Typed "Hulu"; live `Results` list surfaced; clicked the exact bare `Hulu` `.al-typeahead__option`; brand row added with `View: Public Data \| Authorized Data` toggle (default Public) |
| 4 | Select absolute dates | Absolute Dates tab selected by default; default range Jul 3–9, 2026 (last-7-day window) |
| 5 | Select Facebook New Fans and Twitter New Followers | Trusted clicks on both `.controlled-check-box` — `aria-checked=true` for both; category counter `Audience & Growth ( 2 / 36 )` |
| 6 | Run Report and review report | Clicked Run Report → story 155893 built in <8s; two line-chart tiles rendered (Facebook New Fans, Twitter New Followers), 7 `circle.data-circle.hulu-0` per tile |
| 7 | Hover over the 'Facebook New Fans' graph data | Trusted `browser_hover` over FNF data circles → tooltip rendered natively |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | Hover 'Facebook New Fans' graph data point | Tooltip displays `Mon. DD, YYYY` line + `Brand name (Hulu): value` line | Point 1 (Jul 04): header `Jul. 04, 2026` + row `Hulu: 7,302`. Point 2 (Jul 07): header `Jul. 07, 2026` + row `Hulu: 3,956`. Both match the two-line format exactly (`.chart-tooltip__header` = `Mon. DD, YYYY`, `.chart-tooltip__row` = `Hulu: <value>`) | **PASS** |

## Evidence

- Tooltip DOM (point 1): `.chart-tooltip` → `.chart-tooltip__header` = `Jul. 04, 2026`, `.chart-tooltip__row` = `Hulu: 7,302` (label `Hulu`, value `7,302`).
- Tooltip DOM (point 2): `Jul. 07, 2026` / `Hulu: 3,956`.
- Screenshots: `.playwright-out/QA-298/fnf-tooltip-jul04.png`, `.playwright-out/QA-298/fnf-tooltip-jul07.png`.
- Chart is a **line chart** (`circle.data-circle` + path), 0 `rect.bar` — see note below.
- Tooltip triggered by trusted `browser_hover` alone; no synthetic mouse-event dispatch required (consistent with the Playwright chart-hover-tooltip findings).

## Notes / findings (non-blocking)

- **Spec wording drift:** the assertion says "bar chart column", but the FNF metric renders as a **line chart** (data-circles + line path) under the default Days interval. The tooltip format is identical to the spec's expectation and hover behaves correctly on the line + dot. Same observation as the 2026-06-04 run; the "bar chart" wording predates the line-chart redesign. Not a product bug.
- **Tooltip selector this run:** `.chart-tooltip` (`app-lib chart-tooltip`, with `.chart-tooltip__header` / `.chart-tooltip__row`). The 2026-06-04 run recorded the tooltip at `.al-area-chart__tooltip`; this run the visible tooltip is the shared `.chart-tooltip` component. Format is unchanged (`Mon. DD, YYYY` + `Hulu: value`). Minor selector detail, not a regression.

## Known bugs checked

- **Case's own linked bugs:** QA-298 has **0 open** linked bugs (bug-history.md §QA-298 → "Open bugs (0) None"). Rule 7 open-bug screen: PASSED.
- **bug-history grep (QA-298):** closed history is dominated by Classic Reporting / TWC page-load / Run-Report failures (APPS-53697 "stuck on View now", APPS-43922 "run report not working", etc.), all Closed. Watched for the "page stuck on View now" symptom — did **not** reproduce (story built in <8s).
- APPS-50810 (Mixpanel "Undefined" for Page Refreshed event, Trivial/Open) appears elsewhere in bug-history, is **not** linked to QA-298, and would not touch the hover-tooltip assertion regardless.

## Bugs filed

None.
