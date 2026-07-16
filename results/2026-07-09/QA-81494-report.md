# QA-81494 — Reporting > Data Studio - Report Table - Export Functionality - PNG

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei · Reporting > Data Studio · Days interval · Food Network + Disney Channel · Jul 2–8 2026
- **Metrics:** Fan Growth Rate + Facebook Engagements + YouTube Engagements · report_id=301815

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug. (Note: the QA-90213 "Data Studio Go never renders" blocker did **not** recur — Go rendered the report normally.)

## Flow
Data Studio → Days (default) → added Food Network + Disney Channel → Select Metrics → **Fan Growth Rate** (Followers), **Facebook Engagements** + **YouTube Engagements** (per-channel, under the expanded Engagements node) → Go → report rendered → set **Graph Metric = Fan Growth Rate** → Export → PNG.

## PNG verified (`Food Network-Data-Studio-Fan Growth Rate-Line-2026-07-02-2026-07-08.png`)
LISTENFIRST logo top-left; "Fan Growth Rate" header; Legend Food Network (purple, P) + Disney Channel (orange, P); 2-line Line chart matching the on-screen graph; X-axis Jul. 02–08; Y-axis rate (0.00%); footer "Reporting Data Studio" + "Date: Jul. 02, 2026 - Jul. 08, 2026".

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | `Food Network-Data-Studio-Fan Growth Rate-Line-YYYY-MM-DD-YYYY-MM-DD.png` | `Food Network-Data-Studio-Fan Growth Rate-Line-2026-07-02-2026-07-08.png` | PASS |
| A2 | Report matches the PNG | line chart + 2 brands match | PASS |
| A3 | LISTENFIRST header w/ logo top-left | present | PASS |
| A4 | Header = 'Fan Growth Rate' | present | PASS |
| A5 | Legend: Food Network + Disney Channel | both present | PASS |
| A6 | 'Reporting Data Studio' + Date Range under | footer present | PASS |
| A7 | Dates on X-axis | Jul. 02–08 | PASS |
| A8 | Rate values on Y-axis | 0.00% rate axis | PASS |

## Findings / variances (harness)
- **Metric picker:** case metrics all exist but require tree interaction — the check control is a FontAwesome glyph (`i.controlled-check-box__icon.fa-square` → `fa-check-square`), NOT a native checkbox (no `input[type=checkbox]`); per-channel "Facebook Engagements"/"YouTube Engagements" appear only when the Engagements node is expanded (search "Engagements"). "Fan Growth Rate" is the exact cross-channel metric (search "Growth Rate").
- **Default graph metric:** after Go, the graph defaulted to **Facebook Engagements**, not the first-selected Fan Growth Rate. Switched the **Graph Metric** dropdown to Fan Growth Rate to match A1/A4. Minor default-selection variance, not a defect.
- **Export dropdown** needs a trusted `browser_click` (synthetic dispatch didn't open the PNG/CSV/Google-Sheets menu).

## Evidence
- `.playwright-out/Food-Network-Data-Studio-Fan-Growth-Rate-Line-2026-07-02-2026-07-08.png`
- `.playwright-out/QA-81494-graph.png`

## Bugs filed
None.
