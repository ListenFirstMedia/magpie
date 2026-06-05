# QA-96818 — Reporting - Data Studio - Posts Level - Breakdown - Drag - function

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96818
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Michael Kors (Authorized perspective)
- **Priority:** Minor (P4)
- **Result:** ✅ **2/2 PASS — Drag reorder of breakdowns works; report columns reflect the new order after Go. Note: strict spec direction "drag Publish Type upward" was not literally possible because Publish Type was already at top of the breakdown list (insertion order = checkbox-click order in step 10). Demonstrated drag function bidirectionally by dragging Content Type upward to position 1 — both A1 (position updated) and A2 (report reflects change) verified.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Reporting → Data Studio | ✓ — URL `/#explore/reporting/data_studio` |
| 2 | (covered by step 1) | ✓ |
| 3 | Click Post Level | ✓ — Post Level tab active, Window Mode "Lifetime" default visible |
| 4 | Click Add a Brand textbox | ✓ |
| 5 | Typed `Michael Kors` → clicked exact-match `Michael Kors` from typeahead Results (Rule 1) | ✓ |
| 6 | View toggle clicked to Authorized | ✓ — toggle thumb moved right; Brand list shows Michael Kors Authorized |
| 7 | Interval dropdown → Aggregate | ✓ |
| 8 | Select Metrics modal → searched and ✓ checked Facebook Engagements, Twitter Engagements, Instagram Engagements (all 3 found under Engagements → Likes & Reactions / Replies / etc.). Closed modal. | ✓ — Post Level Metrics shows 3 metric rows |
| 9 | Clicked Add Breakdown dropdown | ✓ — opens with Publish Type and Content Type options |
| 10 | ✓ Publish Type, ✓ Content Type | ✓ — breakdown panel initial order: Publish Type (top), Content Type (bottom) — same order as checkbox clicks, NOT alphabetical |
| 11 | Click Go | ✓ — Report built (report_id=292570). Column order: `Metric, Brand, Publish Type, Content Type, Sum, Average` |
| 12 | Click Show Configuration | ✓ — left-side configuration panel revealed |
| 13 | Drag breakdown reorder. Spec says "drag Publish Type upward" but Publish Type was already at position 1 (top). Instead, demonstrated drag by dragging Content Type upward to position 1, which forces Publish Type down to position 2. | ✓ — breakdown panel now shows: Content Type (top), Publish Type (bottom) |
| 14 | Click Go | ✓ — New report (report_id=292572). Column order: `Metric, Brand, **Content Type**, **Publish Type**, Sum, Average` — breakdown columns reordered to match the new panel order |

## Initial report (before drag, report_id=292570)
Columns left-to-right: `Metric | Brand | Publish Type | Content Type | Sum | Average`

Sample rows:
- Facebook Engagements / Michael Kors / Original Post / Gallery → Sum 1,744 / Avg 249
- Facebook Engagements / Michael Kors / Original Post / Image → Sum 475 / Avg 68
- Facebook Engagements / Michael Kors / Original Post / Video → Sum 1,345 / Avg 192
- Facebook Engagements / Michael Kors / Reel / Video → Sum 0 / Avg 0
- Instagram Engagements / Michael Kors / Reel / Video → Sum 6,917 / Avg 988

## After drag + Go (report_id=292572)
Columns left-to-right: `Metric | Brand | **Content Type** | **Publish Type** | Sum | Average`

The same data rows now display with Content Type *first* and Publish Type *second* — breakdown column order matches the breakdown panel order.

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Position of 'Publish Type' is updated | After drag, Publish Type moved from position 1 (left) to position 2 (right) in both the configuration panel AND the rendered report. Position changed. | ✅ PASS |
| A2 | Report reflects the changes made | Re-running Go after the drag produced a new report (report_id=292572) with breakdown columns in the new order (Content Type before Publish Type). Each row still shows the same metric × brand × type combos, but the column position changed. | ✅ PASS |

## Note on spec interpretation
The spec wording "Click on the 'Publish Type' breakdown and drag it upward" assumes Publish Type is initially BELOW Content Type. In practice (this run), the breakdown panel ordered them by checkbox-click sequence (Publish Type was clicked first → position 1). To verify the drag function, I performed the equivalent test by dragging Content Type upward, which produces the same observable change: the column positions swap, demonstrating the drag function works. If the spec wording is taken strictly, the test reaches an unactionable state (Publish Type already at top, no room to "drag up"); the broader intent (verify drag-to-reorder) is fully exercised either way.

## Bugs filed
None.

## Skill registry impact
- `data-studio-post-level-run` v1 — pass_streak +1 (separate-day, exercised Aggregate interval + Authorized perspective + Add Breakdown checkbox + drag-to-reorder breakdowns + Go cycle)
- Recommend adding a `left_click_drag` pattern note: dragging within the breakdown configuration panel works with screenshot coordinates; tool may report slightly shifted y-coords due to DPR but the drop position is interpreted relative to the breakdown list.

## Sources
- [QA-96818 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-96818)
