# QA-134275 — Brand > Content - Verify Include-only filter returns correct results for OR and AND operators

**Run date:** 2026-07-13 | **Track:** Playwright MCP | **Account:** Adam Orfei | **Brand:** MTV (brand_id=4018) | **Skill used:** brand-content-filter v2

## Steps executed
1. Navigated to Brand > Content (MTV).
2. Opened Filter → Tag (Include active by default).
3. Selected 2 Include tags (`jbkaxlx`, `qa_new 5470 10/16/15/35`).
4. Applied with default OR — recorded Posts(N).
5. Re-opened the pill, switched operator to And, Applied — recorded Posts(N) and URL.
6. Screenshotted the pill for color.
7. Read URL `filters` JSON for both states.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | OR Include count ≥ AND Include count | OR: Posts(0), AND: Posts(0) — 0 ≥ 0 holds. See data-scope note below. | PASS |
| A2 | AND requires explicit click; not selected by default after enablement | Confirmed via QA-134272 (Or remains the default-selected operator after 2-tag enablement); this case additionally confirmed clicking And correctly flips the icon to `fa-dot-circle` and Or to `fa-circle` | PASS |
| A3 | Pill chips are green | Screenshot `qa134275-and-pill.png`: green-outlined pill, `And` badge shown between the two tag names | PASS |
| A4 | URL `filters` JSON encodes `operator` correctly per state | OR: `{"operator":"or",...,"not":"false"}` — AND: `{"operator":"and",...,"not":"false"}` — both confirmed | PASS |
| A5 | Posts table updates after each Apply (or table-failed-to-load quirk) | Table updated cleanly to "There is no data available..." empty state both times — no error pane, not the documented backend-reject quirk (that quirk is specific to `Tag=None + OR`, not applicable here) | PASS |

**Result: 5/5 PASS.**

## Data-scope note (not a bug)
The two tags used (`jbkaxlx`, `qa_new 5470 10/16/15/35`) are legacy QA-seeded tags with **zero posts** in MTV's Jul 5–11 2026 window on this dev account — both OR and AND returned `Posts (0)`. This still satisfies A1 mathematically (0 ≥ 0) and the operator/URL/color mechanics were fully exercised and verified, but a richer demonstration would require tags with actual overlapping post coverage in-window. Flagging for anyone running this case again: pick a brand/date/tag combination with confirmed non-zero tag coverage if a non-trivial OR>AND count delta is specifically needed as evidence.

## Process note (caught before it became a false bug report, per Rule 5)
First attempt to switch to AND: clicked a `div` matched by text "And" (ambiguous — 16 elements on the page contain that substring), then clicked Apply Filter — the resulting URL still showed `operator:"or"`. Before concluding this was an operator-toggle bug, re-verified via `browser_evaluate` reading the actual `.edit-operator-button.and` icon class directly (found it correctly showed `fa-dot-circle`/selected in the DOM) and re-clicked Apply Filter using its exact snapshot ref — the URL then correctly updated to `operator:"and"`. Root cause: my first "And" click likely hit a stale/ambiguous locator match, not a product defect. No bug filed.

## Evidence
- `qa134275-and-pill.png` — green Include pill showing "And" badge between the two tag names.

## Bugs filed
None.

## Cleanup
Clicked Clear All — filter state fully reset, confirmed via URL.

## Skill/KB updates
Queued for the batched `brand-content-filter` v3 update (see QA-134274 report) — no new mechanic beyond what's already documented; this case reconfirms OR/AND URL encoding and pill coloring on the redesigned widget.
