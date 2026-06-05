# QA-134185 — Settings > Custom Metric Creation - Info View (Create page)

- **Run:** 2026-06-02 (batch 6 re-run, reported under 2026-05-29 dir per protocol)
- **Account:** Adam Orfei (account_id=54)
- **Result:** PASS (re-confirmed). Metric Definition Link element still ABSENT (per spec drift).

## Steps executed

1. Settings → Custom Metrics → Create a Custom Metric. URL `/#custom-metrics/create`. Form: Name, Description, Configure your metric formula. NO `Metric Definition Link` element present.
2. Hovered Name field without Info mode enabled → no tooltip rendered.
3. Clicked Info button → button background turned blue (active). Generic tooltip in lower-left: `Create Custom Metrics / This screen allows you to create your custom metrics`.
4. Hovered each input in turn:
   - **Name** → `Name / Enter a name for your custom metric`
   - **Description** → `Description / Enter a description for your custom metric`
   - **Formula** (Configure your metric formula field) → `Formula / Enter a formula for your custom metric`
5. Confirmed via JS DOM scan that no element with substring "definition" exists on the Create page.
6. Clicked Info button again → button returned to neutral state. Hovered Name field → no tooltip. Toggle-off verified.

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Info mode initially shows generic tooltip when no field hovered | Page-level tooltip with `Create Custom Metrics` header | Verified | PASS |
| A2a | Hovering Name in Info mode updates tooltip | `Name` tooltip | Verified — `Name / Enter a name for your custom metric` | PASS |
| A2b | Hovering Description in Info mode updates tooltip | `Description` tooltip | Verified — `Description / Enter a description for your custom metric` | PASS |
| A2c | Hovering Formula in Info mode updates tooltip | `Formula` tooltip | Verified — `Formula / Enter a formula for your custom metric` | PASS |
| A2d | Hovering Metric Definition Link in Info mode updates tooltip | (spec element) | Element does NOT exist on current build — JS DOM scan returns 0 hits | N/A (spec drift) |
| A3 | Without Info mode, no persistent tooltip | Hover produces nothing | Verified twice (pre-toggle and post-toggle-off) | PASS |
| A4 | Clicking Info button toggles Info mode on/off | Button state + tooltip behavior toggle | Verified — button background blue when active, neutral when off; tooltip rendered/not-rendered consistently | PASS |

## Open-bug verdicts

None — bug-history.md shows zero open bugs for QA-134185.

## Known copy-drift items (re-confirmed)

- **`Metric Definition Link` element ABSENT on Create page.** Spec step "Hover Name, Description, Formula, Metric Definition Link" cannot be fully exercised because the 4th element doesn't exist in the current build. Either the spec is stale (element was removed/never added) or the element needs to be re-added. Per spec drift note in known-quirks.md — documented since 2026-05-29.

## Cleanup

Non-mutating. No cleanup required.

## Bugs filed

None.
