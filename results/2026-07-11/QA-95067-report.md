# QA-95067 — Brand Audience > LinkedIn — Followers By Country & Followers By Region tile Hovering Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-95067
- **Run:** 2026-07-11 · unattended · headless · Playwright MCP (`feature/playwright-mcp`)
- **Env:** Dev (app.lfmdev.in) · **Account:** UCLA (account_id=799) · **User:** lfiqa (config/.env login)
- **Brand:** University of California, Los Angeles (brand_id=127756) · **Channel:** LinkedIn
- **Date range:** Jan 01 – Dec 31 2025 · **Perspective:** Authorized (`perspective=extended`, confirmed via URL after channel/perspective load)
- **Skills used:** chart-hover-tooltip (geo-map datamaps variant), view-perspective-toggle, switch-account (no switch needed — already on UCLA)

## Verdict: **PASS** (A1–A4 PASS; A5 layout probe captured — APPS-58574 reproduces but does not interfere)

This is an **improvement over the prior 2026-06-04 PARTIAL**: the Region tile hover now verifies. The prior run hovered the white **country-polygon** layer of the Region map and found no tooltip. The Region map's data is actually rendered as **`circle.datamaps-bubble` metro-area markers** overlaid on the (intentionally uncolored) world map — hovering a **bubble** surfaces the tooltip correctly. The earlier "Region-tile-data-gap" conclusion was a target-selection issue, not a product gap.

## Steps executed
1. Logged in (Cognito "With existing account", config/.env) → `#home` for account UCLA (account_id=799).
2. Brand menu confirmed default brand = UCLA (brand_id=127756); navigated to Brand > Audience, LinkedIn channel, 2025 full-year window, Authorized perspective (URL nav with required `from`/`to` per the Audience from/to quirk). URL settled to `…/brand/audience?brand_id=127756&account_id=799&from=2025-01-01&to=2025-12-31&channels=linkedin&perspective=extended`.
3. Located the **Followers By Country** tile — datamaps world map, 177 subunits, **98 colored** (fills from `rgb(252,229,229)` light to `rgb(177,0,0)` = US); legend 60-79% / 1-19% / 0.01-0.99% / 0%.
4. Hovered the US subunit (dispatched mouseover/mousemove on `path.datamaps-subunit.USA`; the polygon bbox-center is intercepted by Canada due to Alaska stretching the bbox — datamaps' own handler fires on the element regardless). Tooltip rendered.
5. Located the **Followers By Region** tile — same world map base (177 subunits, **0 colored**) with **155 `circle.datamaps-bubble` metro-area bubbles** on top (largest r=9 red at lat/long 33.87/-118.28 = Los Angeles).
6. Hovered the largest Region bubble → tooltip rendered.
7. Re-probed APPS-58574 by DOM-measuring the tile topology.

## Tooltip evidence

### A2 — Followers By Country hover
- Target `path.datamaps-subunit.USA`, `data-info = {"label":"Followers","share":66.27665…,"name":"United States","fillColor":"#B10000"}`.
- Tooltip container `.al-geo-map-tooltip__container` (also `.datamaps-hoverover`):
  - `.al-geo-map-tooltip__header` = **"United States"**
  - `.al-geo-map-tooltip__body` = **"Followers 66%"**
- Cross-reference: Geo Breakdown By Country table row 1 = **United States | 66%** ✓ (India 4%, Brazil 2%, China 2% follow).

### A4 — Followers By Region hover
- Target `circle.datamaps-bubble` (largest), `data-info = {"label":"Followers","share":38.42094…,"name":"Los Angeles Metropolitan Area","fillColor":"#B10000","fillKey":"most","radius":9,"latitude":33.8726016,"longitude":-118.2848067}`.
- Tooltip container `.al-geo-map-tooltip__container` = **"Los Angeles Metropolitan Area Followers 38%"** (header "Los Angeles Metropolitan Area", body "Followers 38%").
- Cross-reference: Geo Breakdown By Region table row 1 = **Los Angeles Metropolitan Area | 38%** ✓ (San Francisco Bay Area 9%, "Los Angeles, California, United States" 7%, New York City Metropolitan Area 3% follow).

## APPS-58574 layout probe (A5) — DOM-measured tile topology (page coords)
| Row | top (px) | Tiles (left / width) |
|-----|----------|----------------------|
| 1 | 328 | **Followers: Job Function** ALONE (left=10, w=295) |
| 2 | 728 | Industry (left=20) · Seniority (left=335) · Staff Count Range (left=650) — all w=295 |
| 3 | 1128 | Followers By Country (left=20, w=610) · Followers By Region (left=650, w=610) |
| 4 | 1597 | Geo Breakdown By Country (left=20) · Geo Breakdown By Region (left=650) |

Row 1 holds only the Job Function tile while three equal-width `lfm-col-3` tiles sit on row 2; four such tiles (4×295 = 1180) fit the ~1240 px container, so Job Function should share row 1. **APPS-58574 REPRODUCES** (unchanged topology vs. 2026-06-02/06-04/06-13 findings). Trivial, does not affect the hover assertions under test.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Followers By Country tile renders | World map colored per country share | 177 subunits, 98 colored (US `#B10000` deepest); legend 60-79%…0% | PASS |
| A2 | Hover country → tooltip with country + value | `<Country> Followers <share>` | `.al-geo-map-tooltip__container` "United States / Followers 66%" (data-info share 66.28%; matches Country breakdown 66%) | PASS |
| A3 | Followers By Region tile renders | World map | 177 subunit base + 155 `datamaps-bubble` metro markers (LA largest, r=9); legend 20-39%…0% | PASS |
| A4 | Hover region → tooltip with region + value | `<Region> Followers <share>` | `.al-geo-map-tooltip__container` "Los Angeles Metropolitan Area / Followers 38%" (data-info share 38.42%; matches Region breakdown 38%) — via **bubble** hover | PASS |
| A5 | APPS-58574 layout state captured | Misalignment topology recorded | Job Function alone on row 1; Industry/Seniority/Staff Count Range on row 2 → APPS-58574 reproduced | PASS (state captured) |

## Known bugs checked
- **knowledge-base/bug-history.md (grep QA-95067):** prior runs — 2026-06-04 PARTIAL (Country PASS / Region no-tooltip), 2026-06-13 BLOCKED-data (geo tiles unpopulated). Data availability fluctuates by window; the 2025 full-year window has data today.
- **APPS-58574 (Bug, Trivial, In Progress) — Brand Audience LinkedIn cards misaligned:** this case's own Probe (step 6 / A5). **REPRODUCED.** Trivial layout defect; does **not** interfere with the Country/Region hover assertions, so per the open-bug-interference rule the case runs and notes it (not auto-fail). Verdict unaffected.
- No other open linked bug touches the hover surface.

## Corrections to prior findings (for harvest)
- The 2026-06-04 "Region-tile-data-gap" note (Region map "visually blank, no tooltip because UCLA data is metro-area-level") is **superseded**: the Region map renders metro data as `circle.datamaps-bubble` overlays. Hover the **bubbles**, not the country polygons. `chart-hover-tooltip` should gain a datamaps geo-map note: subunit polygons AND bubble overlays both carry `data-info` + fire `.al-geo-map-tooltip__container`; hover via synthetic `mouseover`/`mousemove` on the element (polygon bbox-center can be intercepted by a neighbor, e.g. USA↔Canada via Alaska).

## Bugs filed
_None._ (APPS-58574 is a pre-existing open bug, re-probed and reproduced — reported here only, no Jira mutation.)

## Files
- Report: `runs/2026-07-11/QA-95067-report.md`
- Screenshots: `.playwright-out/QA-95067/01-audience-linkedin-full.png` (full page, both maps + tables), `.playwright-out/QA-95067/02-region-bubble-tooltip.png` (Region bubble hover state, LA bubble highlighted).
