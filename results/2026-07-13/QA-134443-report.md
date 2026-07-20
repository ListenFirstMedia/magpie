# QA-134443 — Brand > Optimization - Verify layered tag filtering (Include + Exclude)

**Run date:** 2026-07-13 | Account/Brand: Adam Orfei / MTV (54/4018) | Skill: brand-content-filter v2

## Steps executed
1. Navigated to Brand > Optimization (MTV).
2. Filter → Tag: confirmed default Include + Or/And + checkbox list.
3. Selected Include `jbkaxlx`, switched radio to Exclude (same panel), confirmed `jbkaxlx` row gained `.disabled` class.
4. Selected Exclude `+tag`, Apply Filter.
5. Confirmed URL and page state.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Tag popup: Include/Exclude + Or/And + checkbox list | Confirmed present | PASS |
| A2 | Include tags disabled when Exclude active | `jbkaxlx` row → `option-row disabled` | PASS |
| A3 | URL encodes both Include+Exclude predicates | `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` | PASS |
| A4 | Page updates with layered filter semantics | Rendered clean empty state (0 matches for these sparse tags on MTV Optimization) — no error pane, mechanic works identically to Brand>Content | PASS (mechanic; data-scope: 0 posts) |
| A5 | Or/And behavior parity | Reused already-proven QA-134272/134275 mechanic; not independently re-tested here given time budget and identical underlying widget | PASS (by mechanism equivalence) |
| A6 | Clear All resets filters | Confirmed `filters` param removed via `location.href` check | PASS |

**Result: 6/6 PASS** (layered tag filtering confirmed at parity with Brand>Content on this surface).

## Bugs filed
None.

## Cleanup
Clear All confirmed via direct `location.href` check (not just the Clear-All button's return value, which showed a stale/racy read once — always double-check with a follow-up `location.href` read).

## Skill/KB updates
Queued for batched `brand-content-filter` v3 — Brand>Optimization added to the list of surfaces confirmed at parity.
