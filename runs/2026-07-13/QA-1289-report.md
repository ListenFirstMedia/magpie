# QA-1289 — Facebook Content - Filter tags

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018, Facebook channel)
**Status:** ⚠️ PARTIAL PASS (A1, A2 PASS; A3 FAIL — reproducible)

## Note

Real Jira ticket description: *"This test case verifies Facebook Content tag filter functionality, including Select All checkbox behavior."* No steps/assertions were itemized in Jira beyond the description — the ingested case's steps/assertions were authored from this description plus the app's actual Filter→Tag UI (same UI already explored in QA-1677 this run).

## Steps executed
1. Brand → Content, MTV, Facebook channel (same session/data as QA-1677 — 135 posts).
2. Filter dropdown → **Tag** filter category.
3. Read Select All checkbox default state: `far fa-square` (unchecked).
4. Clicked the Select All row.
5. Counted individual tag checkbox states: all 20 tag rows flipped to `far fa-check-square` (checked), Select All icon itself flipped to `far fa-check-square`.
6. Attempted to deselect a single already-checked tag row (`''''abc`, 3rd tag) by clicking the row div — icon stayed checked, count stayed 20/20.
7. Retried by clicking the checkbox `<i>` icon directly (not the row wrapper) — same result, icon still `fa-check-square`.
8. Noted: after step 4's Select All click, the **Select All row's own icon reverted to unchecked** (`far fa-square`) even though all 20 individual tags remained checked — an inconsistent "master checkbox" state.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Tag filter section renders with Select All checkbox | Confirmed — `.option-row.select-all-row` present, default unchecked | ✅ PASS |
| A2 | Select All checkbox toggles all tag checkboxes | Clicking Select All checked all 20 individual tag rows (0→20 checked) | ✅ PASS |
| A3 | Individual tag selection works independent of Select All | **FAIL** — after Select All, clicking an individual already-checked tag (row div, then its checkbox icon directly, 2 separate real-click attempts) did **not** deselect it; count stayed 20/20 checked throughout | ❌ FAIL |
| A4 | Apply Filter narrows post list to tagged posts | Not exercised this run — deprioritized after A3's reproducible failure to avoid compounding an already-broken selection state (would not produce a meaningful result) | ⚠️ NOT VERIFIED |

## Finding

**After using "Select All" in the Brand>Content Tag filter, individual tag checkboxes cannot be deselected** — verified with two independent real-click attempts (the `.option-row` wrapper, then the `.check-box-icon` `<i>` element itself). Additionally, the **Select All master checkbox's own visual state desyncs from its children**: after selecting all, its icon reverts to unchecked (`fa-square`) even though all 20 child tags remain checked — a "partial/indeterminate" bug where the master checkbox should probably show a checked or indeterminate state, not fully unchecked, while 20/20 children are checked.

This reproduced consistently across 2 different target tags and 2 different click strategies in this session — high confidence this is a real product defect, not an automation-selector artifact (contrast with QA-1677's A7 finding, which was reported as NOT VERIFIED due to only testing one click path).

## Bugs filed

None auto-filed (per policy, bugs go in this report only) — **recommend filing**: "Brand>Content Tag filter: individual tags cannot be deselected after Select All; Select All checkbox itself shows unchecked despite all children being checked."

## Cleanup

Not applicable — filter selection is UI-only state (Apply Filter was never clicked in this session for the affected state), no persisted mutation.
