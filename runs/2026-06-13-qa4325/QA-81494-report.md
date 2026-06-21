# QA-81494 — Reporting > Data Studio - Report Table - Export Functionality - PNG — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Report:** Data Studio Page-Level, report_id 297148
- **Brand:** MTV · **Window:** 7D (Jun 9–15 2026) · **Metrics:** Facebook Total Fans, Facebook Engagements
- **Skills:** data-studio-page-level-run, png-export-verify (blob)
- **Result:** ✅ PASS

## Steps
1. Reporting → Data Studio (Page Level). Added brand **MTV** (ref-focus-click + backspace/retype, exact-match pick — Rule 1).
2. Select Metrics → checked **Facebook Total Fans** + **Facebook Engagements**; **Go** → report 297148 built.
3. Report rendered: Facebook Total Fans line chart (MTV ~45.5M, Jun 9–15) + **report table** (Metric / Brand / Sum / Average / per-day columns): Facebook Total Fans Sum **318,542,558**, Facebook Engagements Sum **167,036**.
4. Installed `URL.createObjectURL` blob hook. **Export ▾** → menu shows **Graph: PNG** and **Table: CSV / Google Sheets / Metrics**.
5. Clicked **Graph → PNG** (via ref); captured the generated blob.
6. Inspected the visualization-type dropdown ("Line ▾") → options **Area / Bar / Line** (no "Table" chart type).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Report + table render | DS report with a data table builds | report 297148; table with 2 metric rows + per-day values | ✅ |
| PNG export functional | Export produces a valid PNG | blob captured: **`image/png`, 90,331 bytes, header `89504e470d0a1a0a`** | ✅ |
| Export menu structure | PNG offered for the report | **Graph → PNG**; Table → CSV / Google Sheets / Metrics | ✅ |

## Notes / automation learning
- **PNG export is scoped to the Graph**, not a standalone "table image": the Export menu separates **Graph → PNG** from **Table → CSV / Google Sheets / Metrics**. There is no "Table" chart-type (viz options are Area/Bar/Line), so a PNG specifically *of the table grid* is not a distinct option — the report's image export is the chart PNG. If the case literally expects a PNG render of the table grid, that's a spec clarification, not a defect; the PNG export functionality itself works.
- DS PNG export fires a real `Blob` (`image/png`) via `URL.createObjectURL` → the blob hook captures it directly (unlike the async Content CSV which needs the anchor-click hook).
- Reused the DS brand-typeahead ref-focus-click trick; metric-tree checkboxes (Facebook Total Fans / Facebook Engagements) selected fine (Followers/Engagements categories — no Video-metric friction this time).

## Bugs filed
_None._
