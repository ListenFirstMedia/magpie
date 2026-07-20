# QA-126530 — TWC - Cohort/Competitive Average Display as a Line in Time Window Comparison Report

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [time-window-comparison-run](../../skills/time-window-comparison-run/SKILL.md) v6 (Cohort/Competitor Average overlay-line section)
**Account:** Adam Orfei · **Brands:** MTV, Star Wars, HBO Max · **Reports:** story/time_window_comparison/155740 (Cohort only), 155742 (Cohort + Competitor)

## Steps executed

1. Reporting → Time Window Comparison.
2. Added brands MTV, Star Wars, HBO Max (each picked from the Results section of the typeahead, exact-text match).
3. Absolute Dates (default), Interval switched Days → Aggregate.
4. Selected metrics: Facebook New Fans, Twitter New Followers, Instagram Total Followers (By Category view, all 3 visible without further tree expansion).
5. Options → checked "Show Cohort Average".
6. Run Report → story 155740.
7. Change Settings → checked "Show Competitor Average" (Cohort Average left checked, matching the ticket's step 7-8 which builds on the same settings rather than removing Cohort).
8. Run Report → story 155742.
9. Inspected chart SVG DOM for line vs bar rendering, and hovered both average labels to capture tooltips.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | after 6 | Cohort Average displayed as a LINE across the chart, NOT a separate bar | DOM confirms `<line class="... average-line average-line-Cohort Average_-2">` with solid stroke (`stroke-dasharray: none`); zero `<rect>` elements tagged for Cohort Average | PASS |
| A2 | after 6 | Hovering "Cohort Average" label shows a tooltip with the value | `.chart-tooltip__container` renders "Cohort Average: 11,859" on hover (Facebook New Fans chart) | PASS |
| A3 | after 8 | Competitor Average displayed as a DOTTED LINE | DOM confirms `<line class="... average-line average-line-Competitor Average_-1">` with `stroke-dasharray: "4px 2px"` (dashed/dotted) vs Cohort's solid line — both present simultaneously and visually distinguishable | PASS |
| A4 | after 8 | Hovering "Competitor Average" label shows a tooltip with the value | `.chart-tooltip__container` renders "Competitor Average: 25,231" on hover | PASS |

**Result: PASS 4/4**

## Evidence

- Cohort Average values by metric: Facebook New Fans 11,859 · Twitter New Followers 29,142 · Instagram Total Followers 14,356,829.
- Competitor Average value (Facebook New Fans chart): 25,231.
- Line classes confirmed via `browser_evaluate`: `average-line-Cohort Average_-2` (solid, `stroke-dasharray: none`) and `average-line-Competitor Average_-1` (dashed, `stroke-dasharray: 4px 2px`), both `stroke: #6d6e70`.

## Problems / deviations

- `browser_take_screenshot` timed out twice (5s) mid-flow ("waiting for fonts to load..."). Not blocking — all assertions were verified via DOM/accessibility-tree evidence instead of a visual screenshot. Automation-only friction, not a product issue; didn't retry further since DOM evidence was already conclusive.
- No other issues. Aggregate-interval bar chart + overlay lines rendered cleanly for all 3 brands across all 3 metrics.

## Skill maintenance

- `time-window-comparison-run` pass_streak +1 — the documented "Cohort Average / Competitor Average as overlay lines" section (added 2026-05-13 from this same ticket) is reconfirmed accurate with zero drift on the Playwright track.

## Bugs filed

None.
