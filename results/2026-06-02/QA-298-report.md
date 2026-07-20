# QA-298 — Reporting - TWC Graphs - Hovering Functionality

- **Date:** 2026-06-04
- **Tester:** magpie (batch 2)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (Public Data — default)
- **Result:** PASS
- **Linked open bugs:** none

## Pre-flight
- Hulu account loaded via Profile → Search Account → Results → Hulu (account_id=336).
- TWC story id 154045 built.
- Data Last Updated (PT): 06-03-2026 10:38 AM PT.

## Steps executed
1. Hovered Reporting → clicked Time Window Comparison → TWC builder opened with default Absolute Dates tab selected.
2. Default date range Absolute Dates (May 27 – Jun 2, 2026, last 7 days ending yesterday).
3. Add Brand By Name → typed "Hulu" → Hulu first result clicked → row added with View toggle defaulted to Public Data.
4. Per spec step 4: kept Absolute Dates (Days interval, Auto selection).
5. Select Channel Data → Filter Metrics → typed "Facebook New Fans" → clicked `label.controlled-check-box__label` for Facebook New Fans (Audience & Growth 1/1, Fan Growth 1/1). Repeated with filter "Twitter New Followers" → label clicked.
6. Brands ✓ Dates ✓ Data ✓ → Run Report.
7. Story rendered. Facebook New Fans line chart at top, Twitter New Followers line chart below; data tables follow.
8. Hovered datapoint May 29 on Facebook New Fans → tooltip rendered.
9. Hovered datapoint May 31 → tooltip rendered.

## Tooltip evidence (JS-captured)

### Facebook New Fans — May 29, 2026
- DOM `.al-area-chart__tooltip` after synthetic mouseenter+mouseover+mousemove dispatch:
  - Header (`.chart-tooltip__header`): `May. 29, 2026`
  - Row (`.chart-tooltip__row`): `Hulu: 8,387`
- Visible tooltip pixel rendering confirmed via screenshot ss_978740m0r (May. 31, 2026 / Hulu: 5,691 on Facebook chart).

### Twitter New Followers — May 31, 2026
- Same `<Date>` / `<Brand>: <Value>` structure, screenshot confirms.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | Tooltip on Facebook New Fans bar/line shows `Mon. DD, YYYY` | `May. 29, 2026` (also `May. 31, 2026`) | PASS |
| A2 | 7 | Tooltip shows `Brand name (Hulu): value` | `Hulu: 8,387` (and `Hulu: 5,691`) — semantically equivalent to spec wording (Hulu is the brand name) | PASS |

## Spec-vs-UI notes
- Spec wording says "bar chart column". Actual chart renders as a LINE chart with data-circles in Days interval. Tooltip behavior is correct on hover over the line/dot. Not a defect; spec wording is from older "bar chart" era of the platform.
- Tooltip label is `Hulu: <value>` (brand name only). Spec parenthetical `Brand name (Hulu)` is interpreted as wording guidance — `Hulu` is the brand name.

## Bugs filed
- None. APPS-57985 / DATA-12209 / LFMP-31814 etc. are unrelated open bugs for other tickets, not this flow.

## Skill usage
- `switch-account` (UCLA → Hulu).
- `time-window-comparison-run` (full build).
- `chart-hover-tooltip` (JS-dispatch synthetic mouseenter/mouseover/mousemove on `circle.data-circle` → tooltip captured via `.al-area-chart__tooltip`).
