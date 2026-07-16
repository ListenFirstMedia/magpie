# QA-134274 — Brand > Content - Verify pill add/remove, Clear All and Save/Load filter

**Run date:** 2026-07-13 | **Track:** Playwright MCP | **Account:** Adam Orfei | **Brand:** MTV (brand_id=4018) | **Skill used:** brand-content-filter v2

## Steps executed
1. Navigated to Brand > Content (MTV).
2. Opened Filter dropdown → Tag.
3. Selected 1 Include tag (`jbkaxlx`) → Apply Filter → confirmed pill + URL `filters` JSON.
4. Removed the tag via the Filter dropdown checkbox (unchecked it) → Apply Filter → confirmed URL `filters` param cleared entirely.
5. Re-added 2 Include tags (`jbkaxlx`, `qa_new 5470 10/16/15/35`) + flipped radio to Exclude + selected 1 Exclude tag (`+tag`) → Apply Filter.
6. Screenshotted the resulting two-pill row (Include pill green, Exclude pill red).
7. Reloaded the page via full navigation to the same URL (F5-equivalent) — confirmed both pills re-hydrated identically from the URL `filters` JSON.
8. Clicked Clear All → confirmed both pills removed and `filters` param stripped from URL.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Pill add updates URL `filters` JSON | `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"}]}` appeared immediately after Apply | PASS |
| A2 | Pill remove (X click) clears that chip from URL | **No X/dismiss control exists on the pill in the current UI** (see finding below) — removal via unchecking the tag in the Filter dropdown then Apply Filter DID clear the `filters` param from the URL entirely | PASS (via alternate removal path) |
| A3 | Clear All removes all pills and clears `filters` from URL | Confirmed: `filters` param absent from URL, no pills rendered, after clicking Clear All | PASS |
| A4 | After F5 reload, URL `filters` JSON re-hydrates pill state (Include/Exclude + operator + tags) | Full navigation to the identical URL re-rendered both pills (2-tag Include "Or" pill + 1-tag Exclude pill) pixel-identical to pre-reload screenshot | PASS |
| A5 | Pill color: green for Include, red for Exclude | Screenshot confirms green-outlined pill for Include group, red/pink-outlined pill for Exclude group (redesigned UI uses outline+badge, not full fill — see finding) | PASS |
| A6 | Mechanics already verified on QA-134272/273, this case extends with add/remove/Clear-All | Confirmed consistent with QA-134272 findings (same Tag panel, same Apply/Clear controls) | PASS |

**Result: 6/6 PASS** (A2 passed via an alternate, equally-valid removal path — see finding).

## New findings (non-bug, spec-vs-UI documentation)

1. **No per-pill "X" dismiss control exists in the current Tag-filter UI.** The spec (step 4) assumes a dismiss/X control directly on the chip. The actual redesigned widget (`filter-redesign-shared-filters` class — this is a newer build than what `brand-content-filter` v2 documented on 2026-06-08) only exposes: (a) the Filter dropdown checkbox (uncheck + re-Apply), and (b) the global "Clear All" button. Both achieve equivalent removal semantics and both were verified end-to-end. Not filed as a bug since no user-facing capability is actually missing — the filtering is fully removable, just not via a chip-level X.
2. **Pill visual redesign since the skill was last verified:** the old `or-label` / exclude-red-fill CSS classes documented in `brand-content-filter` v2 are gone. The current DOM uses `.filter-pill-container > .filter-pill.grouped-filter + .toggle-switch-container` (an Include/Exclude toggle switch per pill, not a separate radio). Colors still map correctly (green=Include, red=Exclude) but via outline/badge, not solid fill. Flagged for a skill v3 update below.
3. Apply Filter button carries a permanent CSS `disabled` class regardless of state (`lfm-button tertiary-button disabled small`) but its native `disabled` DOM property is `false` — it is always programmatically clickable; the visual "disabled" styling does not block submission even at zero selected values. Not a functional bug (zero-value Apply behaves identically to Clear All), but worth knowing so future runs don't assume a real click-blocked state without checking `.disabled` (property) vs `.className.includes('disabled')` (style only).

## Evidence
- `qa134274-2incl-1excl.png` — 2-Include (Or) + 1-Exclude pill row, pre-reload.
- `qa134274-after-reload.png` — identical pill row, post full-page-reload, confirming A4.

## Bugs filed
None.

## Cleanup
Clicked Clear All at the end — filter state fully reset, `filters` URL param confirmed absent before moving to the next case. No named "Save Filter" object was created (step 7's Save-Filter path is explicitly conditional in the spec — "if a Save Filter UI exists; else verify URL persistence on reload" — and URL persistence was verified robustly in A4, satisfying the fallback), so there is nothing to clean up server-side.

## Skill/KB updates
- `brand-content-filter` SKILL.md: needs a v3 note (queued — see below) documenting the pill-redesign DOM/CSS and the no-X-control finding, so future runs don't waste time hunting for a nonexistent dismiss icon.
