# QA-134173 — Settings > Custom Metric - Info View (list page)

- **Run:** 2026-06-02 (batch 6 re-run, reported under 2026-05-29 dir per protocol)
- **Account:** Adam Orfei (account_id=54)
- **Result:** PASS (re-confirmed).

## Steps executed

1. Top nav → Settings → Custom Metrics. (Carry-over state from QA-85176 cleanup.)
2. Hovered Metric column without Info mode enabled → no tooltip rendered.
3. Clicked Info button (top-right next to Help Center). Button background turned blue (active). Lower-left tooltip appeared with header `Custom Metrics` and body `This table displays all custom metrics created on the account` (generic page-level tooltip when cursor not on any specific column).
4. Hovered each column header in turn:
   - **Metric** → `Metric / The name of your custom metric`
   - **Description** → `Description / The description of your custom metric`
   - **Created Date** → `Date Created / The date when your custom metric was created` (header is `Created Date` but tooltip says `Date Created` — copy drift documented in known-quirks)
   - **Creator** → `Creator / The user who created your custom metric`
   - **Formula** → `Formula / The formula that makes up your custom metric`
5. Clicked Info button again → button returned to neutral state. Hovered Description column → no tooltip appeared. Toggle-off verified.

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Info tooltip appears only after Info mode enabled | No tooltip on hover when Info off; persistent tooltip when Info on | Verified both states | PASS |
| A2 | Tooltip persists and dynamically updates on column hover (Metric, Description, Created Date, Creator, Formula) | 5 unique tooltip headers + bodies | All 5 verified above | PASS |
| A3 | Tooltip header + description match each column's purpose | Wording sensible for each column | All 5 wordings match column semantic | PASS (with Date Created drift noted) |
| A4 | Disabling Info mode dismisses the tooltip | Hover produces no tooltip after toggle off | Verified by hovering Description with Info off | PASS |

## Open-bug verdicts

None — bug-history.md shows zero open bugs for QA-134173.

## Known copy-drift items (re-confirmed)

- **`Created Date` (column header) vs `Date Created` (tooltip header)** — word-order swap still present. Worth a copy-sync ticket; not a functional defect. Already documented in known-quirks.md.

## Cleanup

Non-mutating. No cleanup required.

## Bugs filed

None.
