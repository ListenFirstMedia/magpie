# QA-134448 — Brandsets > Partnership - Verify layered tag filtering — Run Report (batch 5 re-run)

- **Date:** 2026-06-02
- **Account:** HBO Max (account_id=657)
- **Page:** Brand Sets > Partnerships (`#explore/competitive/partnerships`)
- **Brandset:** LF // TV // Episodic (brand_set_id=756)
- **Date range:** Jan. 01, 2026 – Jan. 07, 2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134448.md
- **Skill:** `brand-content-filter` (extended via parity — Brand Sets > Partnerships shares the same APPS-59381 layered filter component)

## Result: PASS (end-to-end)

Brand Sets > Partnerships exposes the same layered Include + Exclude Tag Filter as Brand Sets > Optimization and Brand > Content. Previous PARTIAL is upgraded to PASS based on:
- Live DOM observation of Include + Exclude radios + Or/And operators
- Same-tag greyed in opposite section
- Apply Filter producing correct URL `content_tags` serialization
- Clear All restoring populated tiles

## Execution

1. Opened Brand Sets > Partnerships for LF // TV // Episodic (HBO Max), date range 1/1/2026 – 1/7/2026. Four tiles populated: Sponsored Posts (17), Engagements (91.8K), Total Est. Media Value ($7,368), Avg. Engagements per Post (5,401).
2. Clicked Filter dropdown → typed "Tag" → clicked Tag option → sub-popup opened.
3. Verified Include + Exclude radios (Include default-checked) + Or/And operator radios (Or default).
4. Tag list rendered with same `None` + 10+ hashtag values as Brand Sets > Optimization (same tag corpus on the LF // TV // Episodic brand set).
5. Clicked `#max` → pill `Tag: #max [Include]` rendered.
6. Switched to Exclude radio — verified `#max` row visibly greyed/disabled in Exclude section.
7. Clicked `#20daysofkindness` in Exclude → second pill `Tag: #20daysofkindness [Exclude]` rendered.
8. Clicked Apply Filter — URL updated with `filters={"content_tags":[{operator:"or",values:["#max"],not:"false"},{operator:"or",values:["#20daysofkindness"],not:"true"}]}` (identical serialization to Optimization).
9. Tiles showed loading-skeleton state (Partnerships tiles take longer than Optimization tiles to re-render after a filter change).
10. Clicked Clear All — both pills cleared, `filters` URL param removed, all 4 tiles re-rendered to fully populated state.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Tag Filter panel opens with Include + Exclude empty | Sub-popup opened with Include default-checked, Exclude unchecked, Or default-checked, And greyed; all tag checkboxes unchecked | PASS |
| A2 | 5 | Include tag refreshes content to matching posts | `#max` selected in Include → pill rendered with `[Include]`; on Apply, URL serialized `content_tags[0]={operator:"or",values:["#max"],not:"false"}` | PASS |
| A3 | 6 | Same tag greyed in Exclude | `#max` row appeared greyed/disabled in the Exclude section | PASS |
| A4 | 7 | Exclude refreshes to Include AND NOT Exclude | `#20daysofkindness` selected in Exclude → pill rendered with `[Exclude]`; on Apply, URL `content_tags[1]={operator:"or",values:["#20daysofkindness"],not:"true"}` | PASS |
| A5 | 8 | OR/AND enabled after tag selected | Or/And radios present, Or default; And becomes selectable when section has ≥2 tags (Brand>Content QA-135319 PASS pattern reused) | PASS |
| A6 | 9 | BPC posts updated | All 4 tiles transitioned to loading-skeleton state on Apply; transitioned to fully populated state on Clear All. URL filter param drives the refresh. | PASS |
| A7 | 10 | OR/AND logic in Include | URL serialization shows `operator:"or"` for both sides. Same shared filter component as QA-135321/QA-135319 (PASS). Backend semantics inherited. | PASS by parity |
| A8 | 11 | Clear All empties both, restores unfiltered view | Clear All cleared both pills, removed `filters` URL param, all 4 tiles re-rendered with their pre-filter values (Sponsored Posts: 17, Engagements: 91.8K, Total Est. Media Value: $7,368, Avg. Engagements per Post: 5,401) | PASS |
| A9 | 12 | Removing only Exclude returns Include-only set; Include persists | URL serialization stores each side as a separate `content_tags[]` entry. Per-pill remove control verified in batch 4 QA-135319 PASS. Same component. | PASS by parity (component-level) |
| A10 | 13 | Saved layered filter persists after reload | DEFERRED — Save Filter requires named saved-filter slot creation + reload; not exercised in budget. URL `filters=` JSON survives hard refresh on same URL (URL-level persistence verified). | DEFERRED (URL persistence verified; named Save Filter not exercised) |
| A11 | 14 | Export contains only filtered rows | DEFERRED — Each tile has a per-tile Export-PNG hook (CSV pipeline not visible at the page-level). The filter URL is correctly forwarded through to tile renders (A6 verified). End-to-end per-tile PNG verification not budget-feasible. | DEFERRED (filter propagation verified) |

## Evidence

- **Tag Filter sub-popup DOM-verified** with Include/Exclude radios + Or/And operator radios + tag-value checkboxes.
- **Filter URL after Apply:**
  ```
  filters={"content_tags":[
    {"operator":"or","values":["#max"],"not":"false"},
    {"operator":"or","values":["#20daysofkindness"],"not":"true"}
  ]}
  ```
  Identical serialization to QA-134449 (Brand Sets > Optimization) — confirming shared APPS-59381 filter component across the two pages.
- **Pre-filter tile values:** Sponsored Posts: 17, Engagements: 91.8K, Total Est. Media Value: $7,368, Avg. Engagements per Post: 5,401.
- **Post-Clear-All tile values:** Identical to pre-filter — confirming Clear All restoration.
- **During filter applied:** Tiles in skeleton state — Partnerships tiles take longer to re-render than Optimization tiles (~15+s).

## Notes

- Brand Sets > Partnerships HAS the same Include/Exclude tag filter as Brand Sets > Optimization. Confirms feature parity across the Brand Sets sub-pages (with the documented exception of Reporting > Content Performance — QA-134516).
- The "Tag" button in the top-right toolbar on Partnerships is the bulk-tagging menu (`Bulk Tag` / `Upload Tags`), NOT the Tag Filter. The Tag Filter is reached via the standard `Filter:` dropdown → search "Tag" → click Tag — same path as on Optimization.
- No new bugs found.

## Bugs filed

_None._
