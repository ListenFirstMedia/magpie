# QA-329 — Historical Reports Load Correctly

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [historical-twc-story-load](../../skills/historical-twc-story-load/SKILL.md) — reused as-is
**Account:** Hulu (account_id=336, session carryover — exact match to spec precondition, no switch needed)
**Report:** `app-reporting.lfmdev.in/#story/time_window_comparison/119501` (historical report, brand "The Walking Dead" / AMC, Jan 1–7, 2023)

## Steps executed

1. Direct navigation to the historical story URL hung on "Loading..." indefinitely (console showed a transient `503` on `accounts.lfmdev.in/global_storage`). Recovered by navigating to Home first, then opening Time Window Comparison via the Reporting menu (priming the `app-reporting.lfmdev.in` subapp session), then re-navigating to the same story URL — loaded cleanly on the second attempt. Documenting as a new quirk below.
2. Reviewed the loaded report: header, brand/network info, 4 metric graphs, 4 metric tables.
3. Clicked "Change Settings" to open the settings dialog and inspect the underlying configuration (brand, date-range mode, metric selection, graph/table options).
4. Closed the dialog via Escape (no changes made/saved).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | Report fully loads without errors | Loaded successfully after the priming workaround; header "The Walking Dead — Time Window Comparison (Jan 1, 2023 - Jan 7, 2023)", Series/Network info, 4 graphs + 4 tables all rendered | PASS |
| A2 | 2 | Brand = The Walking Dead, Date range = Absolute Dates | Settings dialog: brand row "The Walking Dead" (radio checked); "Absolute Dates" button has `al-view-switcher__option--selected` class, "Relative Dates" does not | PASS |
| A3 | 2 | Fan Growth node: Facebook New Fans, Twitter New Followers, Instagram New Followers, YouTube New Subscribers selected | All 4 checkboxes read `checked` in the metric tree under Fan Growth (4/8); TikTok/Pinterest/LinkedIn/Threads New Followers unchecked | PASS |
| A4 | 2 | Show Metrics Graphs and Show Metrics Tables checked | Both checkboxes read `checked` in Graph Options | PASS |

**Result: PASS 4/4**

## Findings (not filed as bugs — documented for KB)

- **Direct navigation to a historical `#story/time_window_comparison/<id>` URL from a cold `app-reporting.lfmdev.in` session can hang on "Loading..." indefinitely**, correlating with a transient `503` on `accounts.lfmdev.in/global_storage` in the console. Navigating to `app.lfmdev.in/#home` first, then into the TWC builder via the Reporting menu (which primes the reporting subapp's session/global-storage), then re-navigating to the same story URL resolved it on the first retry. This matches the existing app-map quirk about SPA sub-apps needing menu-nav priming, but is a new specific trigger (historical story deep-link, not Data Studio). Added to `known-quirks.md`.

## Cleanup

None required — read-only test, Change Settings dialog closed without saving.

## Bugs filed

None.
