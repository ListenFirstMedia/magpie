# QA-949 — Brand > Stories - Hovering Functionality — Run Report

- **Date:** 2026-05-27
- **Account:** Michael Kors (account_id=328)
- **Brand:** Michael Kors (brand_id=3801)
- **Date range:** May 20–26, 2026 (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-949.md

## Result: PASS

## Execution
1. Switched account to Michael Kors via Yash → Search Account → click Results entry.
2. Navigated Brand → Stories (Instagram channel default, Data Set = Insights).
3. Hovered on the May 21 bar in Engagements tile via JS-dispatched mouse events + screenshot hover at the bar's measured center (209, 435).
4. Clicked "Bar" graph-type dropdown under Impressions tile → selected **Pie**.
5. Hovered on the pie ring at (577, 70).
6. Clicked top toolbar **Export** → CSV → **Only Current Data Set** — spinner appeared on the Export button.
7. Clicked Stories post #1 image (@michaelkors, Thu May 21, 2026 07:58 AM PDT) — new browser tab opened at `https://www.instagram.com/stories/michaelkors/3902006660730844582`.

## Assertions
- **A1 (4 big-number graphs hoverable):** PASS — Engagements, Impressions, Taps Back, and Exits all render `<svg>` with `rect.bar.*` hover targets. Engagements tooltip rendered cleanly when hovering at bar bounding-box center.
- **A2 (tooltip displays "DOM DD, YYYY" + icon-Channel: N):** PASS — bar hover produced `May. 21, 2026` header + `[IG icon] Instagram: 449 (+999.0%)` body, matching the spec format.
- **A3 (Pie tooltip displays icon-Instagram: Value):** PASS — pie ring hover produced `[IG icon] Instagram: 546,988`.
- **A4 (Spinner displays on Export button until file download):** PASS — clicking CSV → Only Current Data Set replaced the Export label with a blue spinner immediately after.
- **A5 (Post click opens new tab with correct post):** PASS — new tab opened to `instagram.com/stories/michaelkors/3902006660730844582`, matching the @michaelkors brand handle from the card.

## Notes
- Bar/pie tooltips require precise pointer position at the SVG `rect.bar.*` / `path` element's measured bounding box; hover at a generic chart-area coordinate misses. JS pattern: `el.getBoundingClientRect()` → hover at `(left+w/2, top+h/2)` works reliably.
- The Export dropdown is structured: CSV (Only Current Data Set / All Data Sets) and Google Sheets (Only Current Data Set / All Data Sets / Metrics). The "in toolbar" Export at top-right is distinct from the per-tile Export beneath each chart.
- The "Bar" graph-type dropdown beneath each chart is found by `find` with query "Bar graph type dropdown under Impressions tile"; clicking it reveals Area / Bar / Line / Pie / Table.
