# QA-81647 — Reporting > Data Studio - Data Visualization

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV
**Status:** ✅ PASS

## Steps executed
1. Reused the Data Studio report from QA-81416 (MTV, Posts metric group, 7-day window, report_id 302483).
2. Confirmed the default chart renders as an SVG (1214×320) with 58 marks (path/line/gridline elements) — real data-driven chart, not empty/placeholder.
3. Located the chart-type dropdown (`.selector-dropdown-container`, default "Line") — clicking the outer container's text alone did not open it; the inner `.selector-dropdown` chevron element is the actual toggle target (`is-closed` → `is-open` class flip confirmed).
4. Options rendered in a `.dropdown-list` portal: **Area, Bar, Line**.
5. Selected **Bar** → dropdown label updated to "Bar" → chart re-rendered with 7 `rect`-based bar marks (one per day, matching the 7-day window).

## Assertions

| Expected | Actual | Status |
|----------|--------|--------|
| Chart renders with real data | Confirmed — Line chart with 58 SVG marks on initial load | ✅ PASS |
| Chart type switching works (Line → Bar) | Confirmed — switched to Bar, 7 bar rects rendered, dropdown label updated | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
