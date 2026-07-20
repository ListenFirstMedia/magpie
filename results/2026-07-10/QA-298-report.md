# QA-298 — Reporting - TWC Graphs - Hovering Functionality

- **Run date:** 2026-07-10
- **Track:** Playwright MCP (headless, unattended), `feature/playwright-mcp`
- **Account:** Hulu (account_id=336) — switched from Disney Ad Sales via LFQA menu → Search Account → Results "Hulu"
- **Verdict:** **PASS** (1/1 in-scope assertion)
- **Report built:** `https://app-reporting.lfmdev.in/#story/time_window_comparison/155869`
- **Skills used:** `time-window-comparison-run` (v6), `chart-hover-tooltip` (v3), `switch-account` (v2)
- **Open-linked-bug screen (Rule 7):** case file has no "## Open linked bugs" section → screen passes; ran the case.

## Preconditions
- User logged in as Hulu. Pre-flight login as `lfiqa@listenfirstmedia.com` succeeded (`#home`, "Home - ListenFirst").
- Account switched to **Hulu** and confirmed via header "Account: Hulu" before building the report.

## Steps executed

| # | Step | Action taken | Result |
|---|------|--------------|--------|
| 1 | Click Reporting in Top Nav | Hovered "Reporting" dropdown in top nav | Dropdown opened |
| 2 | Select 'Time Window Comparison' | Clicked the TWC link | Navigated to `app-reporting.lfmdev.in/#/time_window_comparison`; builder pane mounted fully (no mount-failure quirk this run) |
| 3 | Type and select 'Hulu' brand | Typed "Hulu" in Add Brand By Name; dropdown listed 65 options; picked the **exact** literal "Hulu" from Results (Rule 1) | Brand row "Hulu | View: Public Data / Authorized Data" added |
| 4 | Select absolute dates | Absolute Dates tab selected by default; kept default range | Range **Jul 2, 2026 – Jul 8, 2026** (last-7-days; shifts daily) |
| 5 | Select Facebook New Fans and Twitter New Followers | Explicit trusted clicks on both `.controlled-check-box__label`s under Audience & Growth → Fan Growth | Both `aria-checked=true`; Run Report enabled |
| 6 | Run Report and review report | Clicked Run Report | Story `155869` rendered — header "Hulu / Type: TV Network / Manufacturer: Hulu", "Time Window Comparison (Jul 2, 2026 - Jul 8, 2026)"; Facebook New Fans + Twitter New Followers graphs and data tables all rendered |
| 7 | Hover over the 'Facebook New Fans' graph data | Hovered the Jul 04 data point (`circle.data-circle`, index 2, chart peak) | Tooltip rendered — see Assertion 7 |

### Report data (Facebook New Fans table, for value cross-check)
Jul 02=4,283 · Jul 03=4,655 · **Jul 04=7,302** · Jul 05=4,020 · Jul 06=3,420 · Jul 07=3,956 · Jul 08=3,865

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 7 | Hovering the 'Facebook New Fans' graph displays: line 1 `Mon. DD, YYYY`; line 2 `Brand name (Hulu): value` | Tooltip `.chart-tooltip`: header `Jul. 04, 2026` (`Mon. DD, YYYY`); row `Hulu: 7,302` (`<Brand>: <value>`). Value **7,302** matches the Jul 04 table cell. | **PASS** |

### Evidence
- Tooltip DOM (`.chart-tooltip`):
  - `.chart-tooltip__header` = `Jul. 04, 2026`
  - `.chart-tooltip__row` = `Hulu: 7,302` (`.chart-tooltip__label` = "Hulu", `.chart-tooltip__value` = "7,302")
- Screenshots (under `.playwright-out/QA-298/`):
  - `step3-brand-typeahead.png` — brand search state
  - `step5-builder-ready.png` — builder with both metrics selected, Run Report enabled
  - `step6-report-rendered.png` — full report (graphs + tables)
  - `step7-fb-hover-tooltip.png` — **tooltip on the Facebook New Fans graph at Jul 04 showing "Jul. 04, 2026 / Hulu: 7,302"**

## Notes / spec-vs-UI variances (not bugs)
- **Spec says "bar chart column"; the actual TWC graph for these Audience & Growth metrics renders as a LINE chart** (data points = `circle.data-circle`). This is the established product behavior for TWC time-series graphs — the assertion is about tooltip *content/format*, which passes exactly. Consistent with the prior QA-298 run (2026-06-04). Not a defect; no bug filed.
- **Tooltip selector is `.chart-tooltip`** (header `.chart-tooltip__header`, row `.chart-tooltip__row`) on the current build — a refinement of the older `chart-hover-tooltip` note that recorded `.al-area-chart__tooltip` for TWC. `browser_hover` on the `circle.data-circle` is a trusted hover and renders the tooltip natively (no synthetic-event dispatch needed).
- **Brand typeahead:** plain `pressSequentially` did not open the dropdown this run; the React value-setter + `input` event dispatch reliably populated it. Then picked the exact "Hulu" from `.al-typeahead__option` (Rule 1).

## Scope
- **Google Sheets:** not part of this case — no GS steps. Nothing skipped for scope.
- All 7 spec steps executed in order via real UI interaction.

## Bugs filed
None. Product behavior is correct; the only spec-vs-UI difference (graph type wording) is cosmetic and does not affect the tooltip assertion.
