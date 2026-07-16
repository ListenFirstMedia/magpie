# QA-134517 — Reporting > Data Studio - Verify layered tag filtering (Include + Exclude)

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major · related story APPS-59381 (layered tag filtering)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV · Reporting > Data Studio (`#explore/reporting/data_studio`) · Post Level
- **Ref:** parity with QA-134443 (Optimization) / QA-134273 (Content); QA-134516 (CPR) known to LACK Include/Exclude

## Verdict: PASS — Data Studio SUPPORTS full layered Include/Exclude tag filtering (A1–A3 verified; A4 report-run blocked by the known-undrivable DS metric tree)

## Known bugs checked
Linked APPS-60101 (Closed test-case task), QA-77007 (test plan). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | DS Tag Filter has Include + Exclude radios | **YES** — Post Level → Filter "Select" (`.tag-filter-dropdown`) → **Tag** opens a sub-panel with **Include + Exclude** radios + **Or/And** operators + **Select All/None** + full tag checkbox list (nikhil, 000, blcfk_qa_3437, enl_qa_3389_1…). Data Studio does **not** have the CPR divergence gap | PASS |
| A2 | Include-selected tags greyed when Exclude active | selected "nikhil" in Include, switched to **Exclude** → nikhil's row becomes `filter__option__row--disabled` (pointer-events:none) while other tags stay `filter__option__row` (enabled). Mutual exclusivity confirmed | PASS |
| A3 | Filter state encodes Include + Exclude tag predicates | after adding Include=nikhil and Exclude=000, the applied filter shows **two pills: "Tag: nikhil" (Include) + "Tag: 000" (Exclude)** — both predicates captured in the DS filter state | PASS |
| A4 | Built report data reflects layered tag filter | **Blocked** — running the report requires **Select Metrics** (the DS metric tree), which is the known-undrivable component (see QA-84194 / QA-92841). The layered filter is confirmed **applied** (both pills present), but observing filtered report data end-to-end was not achievable via automation due to the metric-tree blocker | Blocked (metric tree) |

## Divergence finding (the case's core question)
The V2 sweep flagged that Reporting > **Content Performance** Tag Filter lacks Include/Exclude (only Or/And + checkboxes). **Data Studio does NOT share that gap** — it exposes the full Include/Exclude + Or/And layered pattern (A1), with mutual-exclusivity greying (A2) and both-predicate filter state (A3), matching Brand > Content / Optimization / Brand Sets. No known-quirks parity gap for Data Studio.

## Method notes
- DS Tag Filter path: Post Level → add brand (MTV via "Search for a Brand" typeahead) → filter section "Filter: Select" (`.tag-filter-dropdown`) → **Tag**.
- DS tag rows use `.filter__option__row` / `.filter__option__label` (not `.option-row` as on Brand surfaces); disabled state = `filter__option__row--disabled` + pointer-events:none.
- A4's end-to-end data check is gated on the DS metric-tree (Select Metrics), which has been undrivable in prior DS cases; not re-attempted per effort discipline.

## Bugs filed
None.
