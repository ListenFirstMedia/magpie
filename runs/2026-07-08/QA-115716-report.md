# QA-115716 — Brand > Insights - Fan Growth Rate - Export CSV

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [brand-insights-interval-picker](../../skills/brand-insights-interval-picker/SKILL.md) (page-nav pattern) + [audience-metrics-export](../../skills/audience-metrics-export/SKILL.md) (tile Export dropdown pattern) — no new skill needed, both applied as-is
**Account:** Hulu (account_id=336), brand = Hulu (brand_id=5670)
**Precondition match:** Spec says "logged in as Hulu" — session was already active as Hulu (exact match, no switch needed).
**Date range (as-loaded default):** Jun. 30, 2026 - Jul. 06, 2026 (Compared To: Jun. 23 - Jun. 29, 2026), View = Authorized Data (toggle indicator confirmed right-side via screenshot per Rule 2 — spec does not mandate a specific perspective for this case).

## Steps executed

1. Navigated to Brand > Insights via the Hulu favorite-brand link from Home (exact "Hulu" text, Rule 1 respected).
2. Reviewed the Fan Growth Rate tile in its default state.
3. Clicked the tile's chart-type dropdown (already showing "Bar") to open it — confirmed full option list — then explicitly clicked "Bar" to perform the spec's step.
4. Clicked the tile's Export dropdown → confirmed options PNG / CSV / Google Sheets / Metrics → clicked CSV.
5. Playwright captured a real `download` event; file saved to `.playwright-out/Hulu-Insights-Fan-Growth-Rate-2026-06-30-2026-07-06.csv` and read from disk (Rule 6 compliant — actual saved file, not a DOM/network proxy).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Big-number header format `Fan Growth Rate: -0.03% (->999%)` | Header read `Fan Growth Rate: 0.71% (-13%)` — same `<Label>: <value>% (<change>%)` template, illustrative numbers in spec, format matches | PASS |
| A2 | 3b | Legend = Facebook, Twitter, Instagram, TikTok / `- Compared To` | Legend text exactly `Facebook, Twitter, Instagram, TikTok` + `- Compared To` sub-line | PASS |
| A3 | 3c | X axis = dates, Y axis = values | X axis: Jun. 30 → Jul. 06 (daily); Y axis: 0% → 0.14% in 0.01% steps | PASS |
| A4 | 4 | Tile updated to Bar | Chart-type dropdown read "Bar" before and after explicit re-selection; bar chart rendered throughout | PASS |
| A5 | 5a | Filename = `Brand-Tab-Tile-YYYY-MM-DD(Start)-YYYY-MM-DD(End).csv` | Downloaded file: `Hulu-Insights-Fan Growth Rate-2026-06-30-2026-07-06.csv` (saved to disk as `Hulu-Insights-Fan-Growth-Rate-2026-06-30-2026-07-06.csv`, spaces slugified by the OS/Playwright save path, not the app) — matches pattern exactly | PASS |
| A6 | 5b | Headers: Date, Brand Name, Channel, Fan Growth Rate | Row 1 (BOM-prefixed): `"Date","Brand Name","Channel","Fan Growth Rate"` | PASS |
| A7 | 5c | Fan Growth Rate values in decimal format | All 7 data rows carry raw decimals, e.g. `0.00100506130522347` — no `%` suffix | PASS |

**Result: PASS 7/7**

## Evidence

- Screenshot: `.playwright-out/qa115716-01-insights-loaded.png` (tile default state, header/legend/axes)
- Screenshot: `.playwright-out/qa115716-02-chart-type-dropdown.png` (chart-type dropdown open: Area/Bar/Line/Pie/Table, Bar highlighted)
- Screenshot: `.playwright-out/qa115716-03-export-dropdown.png` (Export dropdown open: PNG/CSV/Google Sheets/Metrics)
- Downloaded file (verified on disk, Rule 6): `.playwright-out/Hulu-Insights-Fan-Growth-Rate-2026-06-30-2026-07-06.csv`
  ```
  "Date","Brand Name","Channel","Fan Growth Rate"
  "2026-07-06","Hulu","Cross-Channel","0.00100506130522347"
  "2026-07-05","Hulu","Cross-Channel","0.00103067976313808"
  "2026-07-04","Hulu","Cross-Channel","0.0012592051053802499"
  "2026-07-03","Hulu","Cross-Channel","0.00108725222941308"
  "2026-07-02","Hulu","Cross-Channel","0.0009878740326354379"
  "2026-07-01","Hulu","Cross-Channel","0.000750703876043094"
  "2026-06-30","Hulu","Cross-Channel","0.000997575719731368"
  ```

## Findings (not filed as bugs — documented for KB)

- **Channel column in the CSV is aggregated (`Cross-Channel`), not per-channel**, even though the on-tile legend breaks Fan Growth Rate down by Facebook/Twitter/Instagram/TikTok. The spec assertion only requires the `Channel` header/column to exist (which it does), so this is not a spec violation — but it's a UI/export granularity mismatch worth flagging for product awareness. Not filed as a bug per Rule 5 (spec doesn't assert per-channel rows).

## Cleanup

None required — read-only test, no mutating steps.

## Bugs filed

None.
