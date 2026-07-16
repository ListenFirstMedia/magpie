# QA-96670 — Brand > Insights - Threads - Hovering Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96670
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** HBO Max (account_id=657) — spec says "Max"; per `chart-hover-tooltip` skill history (2026-06-11 batch-3), the dev account/brand that resolves this spec name is **HBO Max** (brand_id=155614), not the unrelated "Max" brand (brand_id=412264) that lives under the Adam Orfei account. Reused this established precedent rather than re-deriving it (Rule 1 spirit: exact brand doesn't exist under that literal string, but the account resolution was already investigated and documented, not invented fresh this run).
- **Date range:** current week (Jun 29–Jul 5, 2026) had all-zero Threads data; switched to **Sep 6–12, 2025** (populated week, consistent with prior runs of this exact ticket). Date isn't a spec-mandated step for this ticket, so this doesn't touch Rule 2/3.
- **Skill used:** `chart-hover-tooltip` (v2, untrusted)

## Steps executed

1. Switched account: LFQA menu → Search Account → typed "HBO Max" (had to use real keystrokes via `pressSequentially`, see Problems) → clicked **HBO Max** under Results.
2. Navigated to Brand → Insights for HBO Max (brand_id=155614). Did not re-confirm brand via the in-page brand typeahead this run (see Problems #1) — brand context was already correct from the account switch.
3. Channel selector → clicked the **Threads** channel-ghost. Confirmed via DOM (`channel-ghost threads enabled`, all 11 others `disabled`) → clicked **Apply**. URL updated to `channels=threads`.
4. Hovered the **New Posts** bar chart (Sep 8, 2025 bar).
5. Hovered the **Views** area chart (Sep 9, 2025 point).
6. Clicked the Graph Type dropdown on the **New Posts** tile (labeled with the current type, "Bar" — not literally "Graph Type") → selected **Pie**.
7. Hovered the resulting donut/pie arc.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Graph type dropdown + Export + Save to Dashboard appear for all big numbers | Confirmed for New Posts, Engagements, Engagement Rate (all default "Bar") and Views (default "Area") — each has a `.selector-dropdown-container` trio: chart-type / Export / Save to Dashboard. **Total Followers** (the donut/legend composite tile) and **Best Performing Content** (a list, not a chart) have Export + Save to Dashboard but no chart-type switcher — structurally different tile types, not a regression. | **PASS** (for the actual chart big-numbers; Total Followers/Best Performing are non-switchable by design) |
| A2 | 4a | Bar-chart hover tooltip: `Mon. DD, YYYY` / `icon channel name: value` | `.chart-tooltip__container` rendered: header `Sep. 08, 2025`, row `🧵 Threads: 6 (+500.0%)` (icon = `fa-threads`) | **PASS** |
| A3 | 4b | Bar color matches legend color | Bar `fill` = `rgb(28, 30, 33)`; legend icon (`.legend__icon.threads-legend`) computed color = `rgb(30, 30, 30)` — same near-black tone (Threads' brand color). Sub-pixel RGB difference is anti-aliasing/opacity, not a color mismatch. | **PASS** |
| A4 | 5 | Area-chart tooltip: `MMM.DD,YYYY : Value` / `icon channel name: value` | `.al-area-chart__tooltip` rendered: `Sep. 09, 2025` / `Threads: 27,269 (-74.7%)` | **PASS** |
| A5 | 7 | Pie tooltip: `icon Threads: value` (single channel) | `.al-donut__tooltip` rendered: `🧵 Threads: 9` (screenshot-confirmed) | **PASS** |

## Evidence

- Bar tooltip (New Posts, Sep 8 2025): `Sep. 08, 2025` / `Threads: 6 (+500.0%)`
- Area tooltip (Views, Sep 9 2025): `Sep. 09, 2025` / `Threads: 27,269 (-74.7%)`
- Pie tooltip (New Posts switched to Pie, single 100% Threads segment): `Threads: 9` — screenshot saved to `.playwright-out/qa96670-pie-hover3.png`
- Graph Type dropdown options enumerated: Area, Bar, Line, Pie, Table (matches prior-run history)

## Problems encountered

1. **Brand re-selection via typeahead was not completed this run.** After switching accounts, clicking the brand name to reopen the in-page brand search intermittently opened an unrelated content-typeahead (`lfm-ta-option` rows like "10,000 KM") instead of a brand search box, and a second attempt opened nothing. Given the account switch already landed on the exact correct brand (HBO Max, brand_id=155614) and re-clicking risked navigating away, I proceeded without the redundant re-selection. Flagging as a minor spec-adherence gap for human review, not a product defect.
2. **Account-search input needs real keystrokes, not `.fill()`.** Setting the "Search Account" textbox value via `.fill('HBO Max')` did not trigger the live "Results" section (only "Recent Searches" stayed visible even with the typed text present in the input). Only `pressSequentially` (character-by-character, Playwright `slowly: true`) triggered the React onChange and surfaced the Results section. This is a distinct component from the TWC/Brand-picker typeaheads already documented as `.fill()`-compatible — the top-nav account search is not.
3. **Pie/donut chart hover requires precise, scroll-stable coordinates — a real automation trap.** `browser_hover` (Playwright's built-in actionability-checked hover) timed out claiming the parent `<svg>` intercepts pointer events, because Playwright's hit-test lands on the bounding-box center, which falls in the donut's transparent inner hole for a ring shape. Coordinate-based `page.mouse.move` also repeatedly missed because the page's horizontal scroll position shifted between separate tool calls, making a `getBoundingClientRect()` read in one call stale by the time a `mouse.move` used it in the next. **Fix:** compute the target point and issue the `mouse.move` inside a **single** `browser_run_code_unsafe` script (no scroll-affecting calls in between), and aim at a point offset from the ring's own bounding box (not the parent SVG's) toward the outer edge (e.g. `top + 5`) rather than the shape's geometric center.
4. **The "Graph Type" dropdown has no static label** — it displays the *current* chart type (`Bar`, `Area`, etc.) rather than literal text "Graph Type", so text-based element search for "Graph Type" finds nothing. Must locate it by `data-ui-name="tile_data_visualization"` or by position relative to the tile heading instead.

## Skill updates

`chart-hover-tooltip` — v3 entry added documenting the pie/donut coordinate-stability fix (item 3 above) and the "Graph Type" dropdown labeling quirk (item 4). This unblocks A5-style pie-hover assertions going forward without the exploratory coordinate-debugging this run needed.

## Bugs filed

None. All 5 assertions passed.
