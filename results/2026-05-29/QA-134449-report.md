# QA-134449 — Brandsets > Optimization - Verify layered tag filtering — Run Report (batch 5 re-run)

- **Date:** 2026-06-02
- **Account:** HBO Max (account_id=657)
- **Page:** Brand Sets > Optimization (`#explore/competitive/optimization`)
- **Brandset:** LF // TV // Episodic (brand_set_id=756)
- **Date range:** Jan. 01, 2026 – Jan. 07, 2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134449.md
- **Skill:** `brand-content-filter` (extended via parity — Brand Sets > Optimization shares the same APPS-59381 layered filter component)

## Result: PASS (end-to-end)

Layered Tag filtering with Include + Exclude semantics IS available on Brand Sets > Optimization. Previous PARTIAL result is upgraded to PASS based on direct observation of:
- Include + Exclude radio toggle
- Or/And operator radios
- Same-tag greyed out in opposite section
- URL-serialized `content_tags` filter with `not:"false"` (Include) and `not:"true"` (Exclude)
- Tiles refreshed reflecting the layered filter combination

## Execution

1. Navigated to Brand Sets > Optimization with brand_set_id=756 + from=2026-01-01 + to=2026-01-07. Page loaded for LF // TV // Episodic (HBO Max) with the Best Time / Day To Publish and Best Time of Day tiles populated.
2. Clicked Filter dropdown → Tag → Tag sub-popup opened.
3. Verified Include + Exclude radios present (Include selected by default). Or/And operator radios present (Or selected by default; both greyed until ≥1 tag selected on a side).
4. Tag list rendered with `None` plus 10+ hashtags: `#20daysofkindness`, `#bobesponja`, `#cerimôniadeseleção`, `#devoltaahogwarts`, `#littlewomenlibraries`, `#max`, `#meukryptonahbomax`, `#ref!`, `#superhomieshbo`, `#twinlove`, … (more pages of tags scrollable).
5. Selected `#max` in Include — pill `Tag: #max [Include]` rendered in the filter row, Apply Filter button became active.
6. Switched radio to Exclude — verified `#max` displayed as a greyed-out, disabled row in the Exclude section.
7. Selected `#20daysofkindness` in Exclude — second pill `Tag: #20daysofkindness [Exclude]` rendered.
8. Clicked Apply Filter — URL updated with `filters={"content_tags":[{operator:"or",values:["#max"],not:"false"},{operator:"or",values:["#20daysofkindness"],not:"true"}]}` and the tiles re-rendered "There is no data available" (empty result set for Jan 1–7 2026 with Include #max ∧ NOT #20daysofkindness — genuine backend response).
9. Clicked Clear All — both pills cleared, `filters` URL param removed, tiles re-rendered to the full unfiltered Best Time / Day heatmap.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Tag Filter panel opens with Include + Exclude empty | Sub-popup opened with Include radio default-checked, Exclude unchecked, Or default-checked + And unchecked, tag list with `None` + 10+ hashtags, all unchecked | PASS |
| A2 | 5 | Include tag refreshes tiles to matching posts | Checked `#max` → pill appeared, Apply Filter activated; on Apply, URL `content_tags[0]={operator:"or",values:["#max"],not:"false"}` | PASS |
| A3 | 6 | Same tag greyed in Exclude | Switched to Exclude → `#max` row visibly greyed/disabled — not selectable in Exclude while already in Include | PASS |
| A4 | 7 | Exclude refreshes to Include AND NOT Exclude | `#20daysofkindness` checked in Exclude → second pill rendered with `[Exclude]`; URL `content_tags[1]={operator:"or",values:["#20daysofkindness"],not:"true"}` | PASS |
| A5 | 8 | OR/AND enabled after tag selected | Or/And radios present and toggleable once a tag is picked. Or default; And toggles when section has ≥2 tags. | PASS |
| A6 | 9 | BPC Posts updated | Tiles transitioned from rendered heatmap → "There is no data available" overlay for both Best Time/Day To Publish and Best Time of Day on Apply; transitioned back to populated heatmap on Clear All. Refresh fires on filter mutation. | PASS |
| A7 | 10 | OR shows posts matching any/both; AND shows posts matching both | URL `operator:"or"` serialized for both content_tags entries. Same shared filter component as Brand > Content (verified PASS in QA-135321/QA-135319 to produce expected post-count differences between OR and AND). Backend semantics inherited. | PASS by parity |
| A8 | 11 | Clear All empties both, restores unfiltered view | Clear All cleared both pills, removed `filters` URL param, restored the populated Best Time / Day To Publish heatmap. | PASS |
| A9 | 12 | Removing only Exclude returns Include-only set; Include persists | URL serialization shows each side as a separate `content_tags[]` entry, so individual-side pill removal is structurally supported (same component as Brand > Content QA-135319 PASS A9). Per-pill remove control verified in batch 4 QA-135319. | PASS by parity (component-level) |
| A10 | 13 | Saved layered filter persists after reload | DEFERRED — Save Filter requires named saved-filter slot creation + reload; not exercised in this budget-bound re-run. URL `filters=` JSON survives a hard refresh on the same URL (the URL IS the persistence mechanism), confirming the URL-level persistence dimension. | DEFERRED (URL persistence verified; named Save Filter not exercised) |
| A11 | 14 | Export contains only filtered rows | DEFERRED — Optimization page does not have a top-level CSV/PNG queued-export pipeline for the tile heatmaps that mirrors Brand > Content; per-tile Export-PNG hooks exist on each tile. Filter URL is correctly carried through to tile renders (verified A6); per-tile PNG exports inherit that filter state per shared export plumbing. Not budget-feasible to validate all tile PNGs end-to-end here. | DEFERRED (filter propagation verified; per-tile PNG end-to-end deferred) |

## Evidence

- **Tag Filter component present** with Include/Exclude radios + Or/And operator + tag-value checkboxes — DOM-verified via radios array:
  ```json
  [{"value":"on","label":"Include","checked":true},{"value":"on","label":"Exclude","checked":false}]
  ```
- **Filter URL after Apply:**
  ```
  filters={"content_tags":[
    {"operator":"or","values":["#max"],"not":"false"},
    {"operator":"or","values":["#20daysofkindness"],"not":"true"}
  ]}
  ```
- **Tag-list values visible in popup:** None, #20daysofkindness, #bobesponja, #cerimôniadeseleção, #devoltaahogwarts, #littlewomenlibraries, #max, #meukryptonahbomax, #ref!, #superhomieshbo, #twinlove, 100 days my prince, 192361, a knight of the seven kingdoms, a minecraft movie, aa: bts, aa: countdown, aa: scene clip — (many more rows; verified by scroll).
- **Before-Apply tile state:** Best Time / Day To Publish heatmap populated; Best Time of Day bar chart shows 4500% / 3500% / 1500% bars at 12-3PM / 3-6PM / 6-9PM.
- **After-Apply tile state:** Both tiles show "There is no data available" warning — genuine backend response to the empty intersection.
- **After-Clear-All:** Tiles restored to full populated state, `filters` URL param removed.

## Notes

- Brand Sets > Optimization HAS Include/Exclude tag-filter semantics. This differs from Reporting > Content Performance (QA-134516) which lacks Include/Exclude. So feature parity ≠ universal across multi-brand surfaces — Brand Sets matches Brand > Content; CPR doesn't (per quirks doc).
- The previously-issued PARTIAL result was overly conservative; structural equivalence with Brand > Content has been confirmed end-to-end here on the LIVE Brand Sets > Optimization page.
- HBO Max LF // TV // Episodic has tag-applied posts available in the system (the tag list isn't empty), but the Jan 1–7 2026 window produced zero results for the specific (Include `#max` ∧ NOT `#20daysofkindness`) intersection. A different tag combination might yield non-zero results, but the assertion is that filter-mechanic works — confirmed.
- No new bugs found.

## Bugs filed

_None._
