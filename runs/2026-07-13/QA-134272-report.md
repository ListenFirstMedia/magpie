# QA-134272 — Brand > Content - Verify default state, Include OR/AND logic and same tag greyed out in opposite filter mode

**Run date:** 2026-07-13
**Skill used:** `brand-content-filter` (v2, reused as-is, no changes needed)
**Account/Brand:** Adam Orfei (account_id=54) → MTV (brand_id=4018), IG+all channels, Jul 05–11 2026, Lifetime mode
**Status: PASS (10/10 assertions)**

## Steps executed
1. Navigated to Brand > Content (MTV auto-selected, matches precondition "brand with at least 2 tags").
2. Opened Filter dropdown → clicked "Tag" filter type.
3. Probed default sub-panel state via DOM before any interaction.
4. Clicked 1st tag (`jbkaxlx`).
5. Clicked 2nd tag (`qa_new 5470 10/16/15/35`).
6. Flipped radio to Exclude.
7. Verified the two Include-selected tags are now greyed/disabled in the tag list.
8. Clicked Apply Filter to confirm URL `filters` JSON encoding.
9. Clear All to reset state for the next case.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Include selected by default; Exclude not | `input[type=radio]` pair: Include checked=true, Exclude checked=false | PASS |
| A2 | 3 | Or selected by default but disabled until ≥2 tags | `.edit-operator-button.or.disabled` with inner `<i class="far fa-dot-circle">` (filled/selected icon) confirmed | PASS |
| A3 | 3 | And not selected, disabled | `.edit-operator-button.and.disabled` with inner `<i class="far fa-circle">` (empty/unselected icon) | PASS |
| A4 | 4 | After 1 tag added, Or/And still disabled | Both buttons retained `.disabled` class after clicking `jbkaxlx` | PASS |
| A5 | 4 | Pill renders for selected tag | Live preview pill `Tag: ( jbkaxlx)` rendered in `.filter-pill-container` immediately on selection (before Apply Filter click) — confirmed present in DOM | PASS |
| A6 | 5 | After 2nd tag, Or/And enabled | Both buttons lost `.disabled` class after clicking 2nd tag | PASS |
| A7 | 5 | Or still visually selected by default after enablement | `.edit-operator-button.or` (no `.disabled`) still shows `fa-dot-circle` (selected) | PASS |
| A8 | 6 | Switching to Exclude: Include=false, Exclude=true | Radio state confirmed via DOM read after click | PASS |
| A9 | 7 | Tags in Include greyed in Exclude (mutual-exclusivity) | Both `jbkaxlx` and `qa_new 5470...` rows gained `.option-row.disabled` class; screenshot confirms visually greyed text, unclickable | PASS |
| A10 | — | Pill encodes operator + tags in URL `filters` JSON | `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"," qa_new 5470 10/16/15/35"],"not":"false"}]}` — `not:"false"` correctly reflects that these 2 tags remain **Include** tags (flipping the radio to Exclude only changes what NEW tags would be added to, it does not retroactively move already-selected tags) | PASS |

## Evidence
- Screenshot: `runs/2026-07-13/qa134272-step4.png` (1 tag selected, Or/And disabled, panel visible)
- Screenshot: `runs/2026-07-13/qa134272-step7-exclude-greyed.png` (Exclude selected, both Include tags visibly greyed with lighter text)
- Screenshot: `runs/2026-07-13/qa134272-after-apply.png` (applied pill: green background, "Tag: jbkaxlx Or qa_new 5470... Include" toggle, URL `filters` JSON confirmed)
- Posts(0) after Apply — genuine zero-overlap for these two sparse legacy QA tags in the Jul05–11 2026 window (not the documented "table failed to load" backend-reject quirk; page rendered a normal "There is no data available" empty state, not an error pane).

## Note (potential false-positive caught, per Rule 5)
Initially the Apply-Filter URL `not:"false"` after selecting Exclude looked like a bug (expected `not:"true"`). Re-reading the QA-134272 spec (step 6 says "Flip to Exclude radio" only to test the greyed-out mutual-exclusivity in step 7 — there is no step instructing to re-apply the 2 tags as Exclude). The 2 tags were added while Include was active; flipping the radio afterward only changes the mode for *new* selections, consistent with A9's mutual-exclusivity check. Confirmed this is expected behavior, not a bug.

## Bugs filed
None.

## Cleanup
Clicked Clear All — filter state reset, URL `filters` param removed, confirmed via snapshot before proceeding to next case.
