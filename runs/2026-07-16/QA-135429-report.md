# QA-135429 — Settings > Custom Metrics — Edit functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-135429
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/settings-custom-metrics/SKILL.md` (v3)
- **Account:** Adam Orfei (account_id=54)
- **Result: PASS** (4/4 assertions) — MUTATING, cleanup performed

## Steps executed
1. Navigated to Settings > Custom Metrics (`#custom-metrics`).
2. Picked the sandbox metric "Custom test" (description "test", formula `Comments + Engagements + New Posts`) — clicked its row's ellipsis Actions button (row-scoped, per skill's row-verification workaround) → Edit.
3. Landed on `#custom-metrics/edit?report_id=7` — confirmed Name (`Custom test`), Description (`test`), and formula chips (`Comments`, `Engagements`, `New Posts`) all prefilled correctly via DOM read of the labeled input elements.
4. Modified Description to `test - edited 2026-07-16`.
5. Clicked Save — success popup "Custom metric successfully updated!" → Ok.
6. Returned to list — row for "Custom test" showed the updated description.
7. Pressed F5 — reloaded list still showed the updated description (persisted server-side).
8. **Cleanup:** re-opened Edit for the same metric, reverted Description back to the original `test`, saved again (2nd "successfully updated!" confirmed) — restoring the shared sandbox metric to its pre-test state.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Edit option present on ellipsis menu | Confirmed (`EditDelete` menu) | PASS |
| A2 | 3 | Edit form prefilled with current metric values | Name/Description/Formula all correctly prefilled | PASS |
| A3 | 5-6 | Save updates row | List row description updated to new value | PASS |
| A4 | 7 | Edit persists across refresh | F5 reload — updated description still shown | PASS |

## Cleanup
Reverted "Custom test" metric's description back to `test` (its original value) via a second Edit→Save cycle. No net change to the shared account's Custom Metrics list beyond this test run's transient edit.

## Bugs filed
None.

## Skill maintenance
`settings-custom-metrics` (v3) reconfirmed — Edit flow (originally credited from QA-135429 per registry history) re-verified clean, no drift. Row-scoped ellipsis-click workaround (`row.querySelector('button')` rather than a blind ellipsis selector) held up correctly.
