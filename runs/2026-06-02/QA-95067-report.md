# QA-95067 — Brand Audience > LinkedIn - Followers By Country & Followers By Region tile Hovering Functionality (re-run 2026-06-04 batch-7)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-95067
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn
- **Date range:** Jan 01 – Dec 31 2025
- **Perspective:** Authorized

## Result: PARTIAL — Country tile hover PASSES (tooltip with country + share); Region tile hover NO TOOLTIP for any tested region; APPS-58574 still observed

## Steps executed
1. Navigated to UCLA Brand Audience LinkedIn (continued from QA-94978 session).
2. Verified Followers By Country tile renders world map (177 SVG paths, datamaps subunit class scheme `datamaps-subunit XXX`).
3. Verified Followers By Region tile renders world map (177 paths but all paths `fill: rgb(255, 255, 255)` — Region tile shows metro-area data via Geo Breakdown table; map subunit polygons don't match metropolitan area boundaries).
4. Hovered over country polygon on Followers By Country tile.
5. Hovered over multiple coordinates on Followers By Region tile.
6. APPS-58574 re-probed via DOM topology.

## Tooltip evidence

### Followers By Country — TOOLTIP RENDERS
`computer.hover` at `(400, 150)` (near Canada) and at `(300, 100)` (near Russia / N-America):
```
.al-geo-map-tooltip__container .textContent = "CanadaFollowers1%"
.al-geo-map-tooltip__header = "Canada"
.al-geo-map-tooltip__body = "Followers1%"
.al-geo-map-tooltip__icon canada-legend
```
DOM nesting: `datamaps-hoverover > al-geo-map-tooltip__container > al-geo-map-tooltip__header + al-geo-map-tooltip__body > al-geo-map-tooltip__label + al-geo-map-tooltip__value`.

Country tile cross-reference with Geo Breakdown By Country table (which is the data table underneath):
- US: 66% (visible in screenshot as deepest red)
- India: 4%
- Brazil: 2%
- China: 2%
- UK: 2%
- Canada: 1% — matches hover tooltip `Canada Followers 1%`

### Followers By Region — NO TOOLTIP RENDERS
`computer.hover` at multiple coords inside Region tile SVG region: `(950, 200)`, `(1100, 200)`, `(1132, 233)`, `(1131, 145)`, `(900, 80)`, `(895, 105)` — `.al-geo-map-tooltip__container` / `.datamaps-hoverover` selectors return zero visible elements.

The Region map subunit paths all have `fill: rgb(255, 255, 255)` (white). UCLA's region data is metro-area-level (LA Metro 38%, SF Bay Area 9%, etc.) which doesn't map to the country-polygon-based datamap. There are no metro-area polygons in the world map widget being used. The Region tile renders a visually-blank world map that doesn't surface any per-region tooltip for UCLA.

The Geo Breakdown By Region table beneath the map does correctly list region shares.

## APPS-58574 layout probe

Re-confirmed: First-row Job Function tile alone, second row Industry/Seniority/Staff Count Range, third row Country/Region. Consistent with batch-1, batch-6, and QA-94978 findings.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Country tile renders | World map with 177 SVG paths colored per country share | Confirmed; US/India/Brazil etc shaded per Geo Breakdown By Country data | PASS |
| A2 | Country hover shows tooltip | Tooltip with country + share | Canada hover → `.al-geo-map-tooltip__container` "Canada Followers 1%" | PASS |
| A3 | Region tile renders | World map | Renders, but all polygon paths `fill: rgb(255, 255, 255)` (no per-polygon color since data is metro-area, not country-level) | PASS (renders) |
| A4 | Region hover shows tooltip | Tooltip with region + share | NO tooltip rendered for any tested coord | FAIL |
| A5 | APPS-58574 layout | Misalignment | Reproduced | FAIL (APPS-58574 reproduces) |

## Bug verdicts

- **APPS-58574 (Trivial, In Progress) — REPRODUCED** in same misalignment topology as prior batches.
- **NEW FINDING (Region tile hover)**: For brand UCLA, Followers By Region tile renders but `hover` produces no tooltip — Region map polygon scheme is country-level while UCLA's data is metropolitan-area-level. This is likely a structural design gap: either the Region map should render at finer (metro/state) granularity OR the hover should fall back to country-level. Not a new visual defect on top of APPS-58574, but worth surfacing for product review. Caveat: may be brand-data-specific; a brand with country-level region data may render the Region tooltip correctly. Recommend retest on a brand with country-distributed region data.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-95067-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-95067.md` (proxy spec)
- Screenshot captured (in chat) confirming Country map colored + Region map mostly white.

## Notes
- The hover-tooltip class scheme `.al-geo-map-tooltip__container` / `.datamaps-hoverover` is shared by both maps; only the Country map populates it for UCLA.
- Reuses `chart-hover-tooltip` skill pattern + `switch-account` v2.
