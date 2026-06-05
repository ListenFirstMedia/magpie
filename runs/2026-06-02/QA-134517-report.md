# QA-134517 — Reporting > Data Studio - Verify layered tag filtering (Include + Exclude)

- **Run date:** 2026-06-04 (QA-4325 batch 12)
- **Account:** Adam Orfei
- **Surface:** Reporting > Data Studio Post Level (`#explore/reporting/data_studio`)
- **Skill used:** `brand-content-filter` (probe)
- **Result:** FAIL-with-finding — layered Include/Exclude is NOT implemented on Data Studio Tag Filter (same divergence as Reporting > Content Performance, QA-134516)

## Steps executed

1. Navigate to `#explore/reporting/data_studio?account_id=54`. Switch to Post Level tab.
2. Click `Filters: Select` dropdown → list of filter options appears: `Branded Content`, `Content Type`, `Live Stream`, `Publish Day`, `Publish Time`, `Publish Type`, `Sponsor Name`, `Tag`, `Text Search`.
3. Click `Tag` option → side popover opens to the right with:
   - Search input
   - `Or` and `And` radio labels
   - Tag-value checkbox list (Search input above)
   - `Add` button + footer `Load Filter | Save Filter | Clear All`
4. Probe popover DOM for Include/Exclude radios.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Data Studio Tag Filter has Include + Exclude radios | DOM `.filter__options-container` children = [`text-input-wrapper`, `header-configs`, `filter__options`, `footer-config`]. Labels = `Or`, `And` ONLY. NO Include/Exclude labels in DOM. The widget is the OLD pre-APPS-59381 `tag-filter-popover` component, NOT the new layered `dropdown.content-type-dropdown` used by Brand > Content / Brand > Optimization / Brand Sets > Content. | FAIL — feature missing |
| A2 | n/a | Include-selected tags greyed when Exclude | N/A — Exclude radio absent | N/A |
| A3 | n/a | URL encodes Include + Exclude predicates | N/A — Exclude radio absent | N/A |
| A4 | n/a | Built report data reflects layered filter | N/A — layered Include/Exclude not exposed | N/A |

## Evidence

- `header-configs` div labels enumerated to `['Or', 'And']` only.
- Same structural divergence documented in known-quirks for Reporting > Content Performance (QA-134516).
- The Data Studio Tag Filter uses class `tag-filter-dropdown` + popover class `filter__options-container` — distinct from Brand > Content's `content-type-dropdown` + `option-row` pattern.

## Bugs filed / Findings

**Carry-forward finding (parity-gap):** Reporting > Data Studio Tag Filter is missing the Include/Exclude radios delivered for Brand > Content / Brand > Optimization / Brand Sets > Content under APPS-59381. The Or/And operator + Add-pill flow is the legacy pattern. Either:
- (a) APPS-59381 scope did not include the Reporting > Data Studio surface, OR
- (b) Engineering needs a follow-up ticket to extend layered tag filtering to Data Studio (and to CPR).

Recommended product action: extend APPS-59381 to Reporting surfaces (Data Studio, Content Performance) for parity.

## Quirks to update

- Existing `known-quirks` entry: "Reporting > Content Performance Tag Filter lacks Include/Exclude (vs Brand > Content)" — extend to ALSO cover Reporting > Data Studio. Add finding from 2026-06-04 QA-134517 batch-12.

## Skill notes

- `brand-content-filter` skill does NOT cover Reporting > Data Studio Tag Filter — that surface uses a different component (legacy `tag-filter-popover` / `filter__options-container`).
- No new skill authored; the layered Include/Exclude is structurally absent.
