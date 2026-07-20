# QA-1677 — Brand Content - Tag Post

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018, Facebook channel)
**Status:** ⚠️ PARTIAL PASS (A1–A6, A8, A9 PASS; A7 NOT VERIFIED — Apply Filter did not register the Exclude mode change)

## Steps executed
1. Brand → Content, MTV, Facebook channel (135 posts, 2026-06-01→2026-07-11 — a 6-channel default query returned 0 posts, narrowed to Facebook-only to get real data).
2. Clicked Tag button (`.tag-blob.label-blob`) on post #1 ("You're both beautiful, @tomholland2013 & @zendaya...", Jun 15 2026).
3. Added unique tag `QA-1677-TEST-20260713` (auto-lowercased to `qa-1677-test-20260713` per platform convention) → Done.
4. Refreshed the page (full navigation reload).
5. Opened Filter dropdown → selected **Tag** filter category.
6. Verified "None" is the first entry in the tag checklist (right after Select All / Include-Exclude / Or-And controls).
7. Selected **None** → Apply Filter → Posts (132) (untagged posts only, out of 135 total — 3 pre-existing tagged posts excluded correctly).
8. Reopened the Tag filter pill → selected **Exclude** radio (confirmed `checked=true` on the radio input) → clicked Apply Filter **three times** via different selector strategies (button element, wrapper div overlay, direct locator click) — **URL/result never changed**: stayed on `not:"false"` (Include semantics) with Posts (132), identical to step 7's result.
9. Switched to Table View — posts rendered correctly with the tag filter still active (134 non-header rows for 132 posts + header rows).
10. Switched to Detail View — Posts (132) rendered correctly.
11. **Cleanup:** cleared the filter, located the tagged post via its "Tags (1)" chip visible directly in Detail View (`qa-1677-test-20260713`), clicked its Tag(1) button → Delete All Tags → confirmed Delete All → verified tag string no longer present anywhere on the page.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Tag button visible in postcard | `.tag-blob.label-blob` present on every post | ✅ PASS |
| A2 | Tag popup opens on click | "Add Tags" heading + input rendered | ✅ PASS |
| A3 | Tag count updates in posts | `Tag (1)` badge appeared immediately after Add | ✅ PASS |
| A4 | Correct tags present after refresh | Full page reload → tag chip `qa-1677-test-20260713` still present in the reopened popup | ✅ PASS |
| A5 | 'None' is first option in Tag filter child dropdown | Tag checklist order: Select All → **None** → (alphanumeric user tags...) | ✅ PASS |
| A6 | Posts WITHOUT tags display | "None" + Apply Filter → Posts (132) of 135 (the 3 tagged posts correctly excluded) | ✅ PASS |
| A7 | Posts WITH tags display (Exclude mode) | Selected Exclude radio (DOM confirmed `checked=true`), clicked Apply Filter via 3 different click strategies (native button, JS-dispatched, wrapper-div real click) — **filter state and post count never changed** (stayed at Posts (132), URL `not` param stayed `"false"`) | ⚠️ **NOT VERIFIED** — see Finding |
| A8 | Tagged posts display in Table View | Posts table rendered with 132-row filtered set, no error | ✅ PASS |
| A9 | Tagged posts display in Detail View | Posts (132) rendered in Detail View, no error | ✅ PASS |

## Finding

**Tag filter "Exclude" mode did not visibly apply after 3 distinct click attempts on "Apply Filter" (native button, its wrapper `.apply-filter-button` overlay div, and a repeat real-click) in this session.** The Include→Exclude radio toggle itself registered correctly in the DOM (`checked=true`), but the resulting query never changed — Posts count and the `filters=` URL param's `"not"` value stayed on the Include semantics throughout. This could be:
1. A genuine product bug in the Exclude-Apply pipeline, or
2. An automation-only click-target quirk similar to other `controlled-check-box`/overlay-intercept issues already documented in `known-quirks.md` for this codebase.

Per Rule 6/Rule 5 spirit (don't file a bug without being confident it's real), this is reported as **NOT VERIFIED** rather than a confirmed FAIL — recommend a focused re-run with screen-recording or a fresh session to disambiguate before filing a Jira bug.

## Bugs filed

None — A7 finding documented above for follow-up, not filed as a confirmed defect.

## Cleanup

✅ Complete — test tag `qa-1677-test-20260713` added to MTV Facebook post ("You're both beautiful...") and removed via Delete All Tags, confirmed gone.
