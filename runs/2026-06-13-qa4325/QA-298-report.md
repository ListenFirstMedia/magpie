# QA-298 — Reporting - TWC Graphs - Hovering Functionality — 2026-06-13

- **Env:** Dev (app-reporting.lfmdev.in) · **Account:** Hulu · **User:** Yash · **Data Last Updated (PT):** 06-16-2026 09:26 AM
- **Story:** 154786 — Hulu / Facebook New Fans + Twitter New Followers / Absolute Dates Jun 9–15 2026
- **Skills:** time-window-comparison-run, chart-hover-tooltip
- **Result:** ✅ PASS — consistent with prior (2026-06-04)

## Steps
1. Reporting → TWC; added **Hulu** (Rule 1, Results pick via ref-click — see note); Absolute Dates (default Jun 9–15).
2. Selected **Facebook New Fans** + **Twitter New Followers** (Fan Growth).
3. Run Report → story 154786; FB New Fans line chart + Twitter New Followers line chart rendered.
4. Hovered the Facebook New Fans graph data point.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Step 7 tooltip format | `Mon. DD, YYYY` + `Brand (Hulu): value` | Hover on FB New Fans → tooltip **"Jun. 13, 2026 / Hulu: 965"** | ✅ |

## Notes / automation learning
- **Brand typeahead requires a ref-based focus click** in this session: coordinate clicks + the React value-setter left the field unfocused (no Results dropdown). Using `find` → `left_click ref` on the "Search for a Brand" textbox focuses it, then typing renders Results normally. (Fold into time-window-comparison-run / brand-picker skill.)
- Chart is a line (Days interval) not bars, but the tooltip format assertion holds regardless.

## Bugs filed
_None._
