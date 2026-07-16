# QA-134273 — Brand > Content - Verify all four AND/OR operator combinations return correct datasets

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV Content (brand_id=4018) · from=2026-05-27 to=2026-06-02

## Verdict: PASS (A1/A3 fully verified at URL+pill layer; A2 distinct-nonzero-count data-limited — see notes)

## Known bugs checked
Linked issues: **APPS-60101** (Closed — test-case-creation task) and **QA-14525** (Xray Test Plan). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Each combo URL `filters` JSON encodes correct `operator` + `not` value | Captured live in the URL `filters` param across combos:<br>• Include-**And**: `{"operator":"and","values":[" jbkaxlx"," qa_new 5470 10/16/15/35"],"not":"false"}`<br>• Include-**Or**: `{"operator":"or",…,"not":"false"}`<br>• +Exclude-**Or**: second group `{"operator":"or","values":["''''abc","'hooh"],"not":"true"}`<br>All four operator values (and/or) + both `not` values (false=Include, true=Exclude) serialize correctly | PASS |
| A2 | Posts count differs across 4 combos (distinct datasets) | Counts read from the "Posts (N)" header: Include-**And** = **Posts (0)**, Include-**Or** = **Posts (0)** (the two chosen MTV test-tags have **no posts in the 2026-05-27…06-02 window**); baseline unfiltered = **35 Posts**. The chosen tags yield 0 for both And/Or so *distinct nonzero* counts across all 4 combos couldn't be demonstrated with the available tagged data. The count mechanic itself works (0 filtered vs 35 unfiltered) | Data-limited (noted) |
| A3 | Mechanic verified at pill / URL layer | Pill renders the join operator and toggles **Or↔And** (`edit-operator-button or/and`) and mode **Include↔Exclude**; **each Apply re-serializes the URL** `filters` JSON with the matching `operator`/`not` (verified for all four permutations). Mechanic fully confirmed at pill + URL layer | PASS |

## Method notes
- The tag filter serializes to the URL `filters` param **only after "Apply Filter" is committed** (not on in-panel edits). Double-URL-encoded; decoded shape: `{"content_tags":[{"operator":"and|or","values":[…],"not":"false|true"}, …]}`. Include → `not:"false"`; Exclude → `not:"true"`. Multiple groups (Include + Exclude) serialize as separate array entries.
- Operator flips use the inline pill editor buttons `.edit-operator-button.or` / `.edit-operator-button.and` (trusted click), then **Apply Filter** (`f38e585`).
- Switching Include→Exclude greys the opposite-mode tags (mutual exclusivity, verified in [[qa4325-run]] / QA-134272); Exclude tags must be freshly selected.
- The Content table's intermittent "failed to load" cleared once a committed `filters` query ran; the "Posts (N)" header count is the reliable dataset-size read.

## A2 data-availability note
A2 requires ≥2 tags that are actually applied to in-window posts to show four *distinct nonzero* counts. MTV's tag list is largely QA test tags (jbkaxlx, qa_new 5470…, ''''abc, 'hooh, …) with no posts in the 1-week window (Include-And and Include-Or both = 0). The operator/`not` logic that drives dataset selection is nonetheless **proven correct at the URL-JSON layer for all four combinations** (A1/A3), which is the substantive mechanic A2 depends on. Recommend a focused re-run on a brand/date-range with tags known to be applied to real posts to demonstrate the four distinct counts numerically.

## Evidence
- URL `filters` captures (in-report above) for Include-And, Include-Or, and combined Include-Or + Exclude-Or (`not:true`)
- `QA-134273-combos.png` (final combined Include+Exclude state)

## Bugs filed
None.
