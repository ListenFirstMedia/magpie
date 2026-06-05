# QA-135319 — Brand > Content - Verify default selections, Include/Exclude interaction, and filter removal behavior

- **Date:** 2026-05-29 (batch 4 re-run)
- **Source spec:** testcases/english/QA-135319.md
- **Prior run:** runs/2026-05-27/QA-135319-report.md (PASS)
- **Skills:** `switch-account`, `brand-content-filter`

## Result: PASS

## Execution

1. Hulu account active (account_id=336). Brand > Content with no filters (`Clear All` from prior test).
2. Filter dropdown → Tag. Sub-dropdown opened.
3. Defaults observed (DOM-read): radio `Include` checked, radio `Exclude` unchecked. Operator buttons `Or` (`fa-dot-circle` = selected) and `And` (`fa-circle` = unselected), BOTH parent `<div>`s carry `disabled` class.
4. Clicked Exclude radio → Exclude checked=true, Include checked=false.
5. Clicked Include radio → Include checked=true, Exclude checked=false.
6. Clicked `#aapiheritageheroes` checkbox → green pill `Tag: #aapiheritageheroes [Include]` appeared. Re-checked Include radio remained selected, Or remained selected but BOTH operators STILL disabled (because only 1 tag).
7. Clicked Exclude radio → Exclude=true. Clicked `#acmawards` checkbox → red pill `Tag: #acmawards [Exclude]` appeared. `#aapiheritageheroes` now showed as greyed-out in the Exclude list (cannot be both Include + Exclude). Two pills total: green Include + red Exclude.
8. **DID NOT click Apply Filter.** Hovered Exclude pill → "Remove Filter" tooltip appeared just below the pill. Clicked Remove Filter.
9. Verified: only `Tag: #aapiheritageheroes [Include]` pill remains. Posts area unchanged (still showing no `Posts (N)` count because no filter was ever Applied). URL `filters` param still absent (`location.hash.includes('filters=')` = false).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | Include selected by default; Exclude not selected | `<input type="radio"> Include` checked=true; Exclude checked=false | PASS |
| A2 | 5b | Or selected by default but disabled until >1 tag selected | `.edit-operator-button.or` has `fa-dot-circle` (visually selected) + `disabled` class | PASS |
| A3 | 5c | User cannot select AND until ≥2 tags selected | `.edit-operator-button.and` has `disabled` class AND `fa-circle` (unselected) | PASS |
| A4 | 6 | Exclude now selected; Include unselected | After click: Exclude=true, Include=false | PASS |
| A5 | 7 | Include selected again; Exclude unselected; smooth toggle | After click: Include=true, Exclude=false | PASS |
| A6 | 8a | Include remains selected by default; Exclude not | After selecting TAG_1: Include=true, Exclude=false | PASS |
| A7 | 8b | OR remains selected by default; AND not | After 1 tag: `Or` still selected + still disabled, `And` still unselected + still disabled (2-tag minimum still not met for this filter type — same filter group) | PASS |
| A8 | 8c | Green filter pill for TAG_1 (Include) visible | `.filter-pill grouped-filter` with `Tag: #aapiheritageheroes`, green include chip | PASS |
| A9 | 9 | TAG_2 visible as red filter pill (Exclude) | `Tag: #acmawards [Exclude]` red pill rendered to right of green pill | PASS |
| A10 | 11 | Removing Exclude filter does not impact page or results (not yet applied) | After clicking `Remove Filter` on the un-applied Exclude pill: pill disappeared from DOM, only Include pill remains, no URL `filters` mutation, no Posts re-fetch triggered, page state unchanged | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-135319) | — | bug-history shows 0 historical defects |

## New findings

None — all behaviors match spec exactly. The Or-default-disabled and the AND-stays-disabled-with-1-tag pattern is consistent with QA-135321 behavior, and the Remove Filter hover affordance works as documented in `skills/brand-content-tag-post/SKILL.md`.

## Files

- testcases/english/QA-135319.md
- runs/2026-05-29/QA-135319-report.md (this report)
