# QA-10387 — Brand Insights - Impression and Video Views Chart - PNG

**Run date:** 2026-06-04 (QA-4325 batch-3 re-run)
**Account:** Adam Orfei (account_id=54)
**Brand:** MTV (brand_id=4018, picked via Brand Insights default for the account)
**Environment:** dev (`app.lfmdev.in`)
**Result:** **BLOCKED — spec drift suspected**

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-10387.md` — Brand Insights tile-level Impressions and Video Views PNG export.

## What I tried
1. Started on Hulu account but Brand>Insights consistently caused Chrome MCP renderer freeze (matches known-quirk "Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer"). Switched to Adam Orfei → MTV with default Last 7 Days for lighter load.
2. Reached Brand>Insights for MTV (May 27 – Jun 2 2026, Authorized View, FB+Twitter+IG+TikTok channels).
3. Scrolled to the Trends tile (the modern consolidated chart with Bar Chart selector + Line Chart selector).
4. Looked for tile-level export menus on Trends (kebab / Download / Export icons).

## Finding — chart-tile PNG export not present on current Brand Insights build
- Trends tile does NOT have a tile-level export kebab / Download / PNG icon.
- Scrolled top + bottom of tile — no export affordance.
- DOM scan: no `[title*="Export"]`, no `[aria-label*="export"]`, no `[class*="kebab"]` inside the tile's containing element.
- Bar Chart dropdown (which would select "Impressions" / "Video Views") did not open on coordinate click — appears to be a custom lfm-dropdown that needs JS interaction. Even if opened, no export entry visible per the visible UI.
- The spec wording "Brand Insights - Impression and Video Views **Chart** - **PNG**" likely predates the Brand Insights redesign that consolidated standalone Impression and Video Views chart tiles into the Trends tile. PNG export on chart tiles appears to have been removed or moved elsewhere on the page.

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | step 3-4 | Tile-level export menu present with PNG option | No tile-level export menu found on Trends tile | NOT VERIFIED (spec drift / UI redesign) |
| A2 | step 7 | PNG renders chart content | N/A — no export reachable | NOT VERIFIED |
| A3 | step 8 | PNG numbers match on-screen data | N/A | NOT VERIFIED |
| A4 | step 8 | No render errors / blank canvases | N/A | NOT VERIFIED |

## Bugs filed
_None — flagging as spec drift, not a product defect. UI may have intentionally consolidated tile-level exports into a single page-level export. LFIQA should confirm whether tile-level PNG export was a deliberate removal or accidental regression._

## New findings (non-blocking)
- Brand Insights tile-level PNG export appears absent from the modern Trends-consolidated tile. Spec QA-10387 needs review.
- Hulu Brand Insights causes Chrome MCP renderer hang even on Last 7 Days range — extending the known-quirk: Brand Insights with private-data channels on Hulu has elevated CDP timeout risk vs lighter brands.

## Recommended product/spec action
- Confirm with product whether tile-level PNG export was intentionally removed.
- Update QA-10387 spec to reflect current export affordances (page-level vs tile-level).
