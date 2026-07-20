# QA-18940 — Brand > Video - Favourites Functionality

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Disney Ad Sales (account_id=634)
**Brand:** Disney Channel (brand_id=3877)
**Status:** ✅ PASS

## Precondition note

Disney Channel was already present in "Your Favorite Brands" on this account at the start of this run (carried over from a prior session/run — same pattern as other documented persisted-state quirks). Reset to a clean unfavourited baseline first (verified `fal fa-heart` + "Add this brand to your favorites for quick access." tooltip) so the add/remove flow could be verified deterministically against the documented assertions.

Also note: on brand Video pages the Favourites (heart) button sits immediately next to the brand name/logo, separate from the brand-name text which opens the brand search dropdown — these are easy to conflate. An early click intended for the brand-search dropdown landed on the heart icon instead and briefly favourited "Star Wars" (the page's default brand); this was caught immediately (via the hover tooltip flipping to "Remove...") and reverted before continuing, so no stray mutation was left in place.

## Steps executed

1. Hovered Brand nav → clicked **Video** (`#explore/brand/video`).
2. Clicked the brand-name dropdown, typed "Disney Channel", selected the exact match → `brand_id=3877`.
3. Confirmed the Favourites (heart) button renders to the right of the brand name/dropdown.
4. Hovered the Favourites button.
5. Clicked the Favourites button.
6. Clicked **Home** in top nav.
7. Observed the BrandListing ("Your Favorite Brands") section.
8. Hovered Brand nav → clicked **Video** again (brand context carried Disney Channel).
9. Hovered the Favourites button.
10. Clicked the Favourites button.
11. Clicked **Home** in top nav.
12. Observed the BrandListing section.

## Assertions

| Step | Expected | Actual | Status |
|------|----------|--------|--------|
| 3 | Favourites button displays on the right side of the Brand dropdown | Heart-icon button rendered immediately right of "Disney Channel" name | ✅ PASS |
| 4 | Prompt displays "Add this brand to your favorites for quick access" | Tooltip text matched exactly (confirmed via screenshot) | ✅ PASS |
| 5 | Favourites button icon changes to `fas fa-heart` | `document.querySelector('i.fa-heart').className` → `"fas fa-heart"` | ✅ PASS |
| 7 | "Disney Channel" brand is added to the BrandListing table | Home → "Your Favorite Brands (1)" table showed the Disney Channel row (logo + link + channel icons) | ✅ PASS |
| 9 | Prompt displays "Remove this brand from your favorites" | Tooltip text matched exactly | ✅ PASS |
| 10 | Favourites button icon changes to `fal fa-heart` | `document.querySelector('i.fa-heart').className` → `"fal fa-heart"` | ✅ PASS |
| 12 | "Disney Channel" brand no longer displays in the BrandListing table | Home → "Your Favorite Brands" reverted to empty state ("Add a brand to your favorites for quick access.") | ✅ PASS |

## Finding

No product defect. Add/remove-favourite toggle behaves correctly end-to-end: icon class flips (`fal` ↔ `fas`), hover copy flips ("Add..." ↔ "Remove..."), and the Home "Your Favorite Brands" listing reflects the change immediately on next Home load, in both directions.

One environmental note worth flagging to LFIQA: the account's favourites list is **not test-isolated** — Disney Channel was already favourited on this account before this run started (likely left over from an earlier manual/automated session), same class of carried-over account state documented for Custom Data Sets elsewhere in `known-quirks.md`. Not a functional defect, but automation should always capture/reset the favourites baseline before asserting on this flow rather than assuming a clean state.

## Bugs filed

None.

## Cleanup

Net favourites state restored to the pre-run baseline (unfavourited) — no residual mutation on Disney Channel. The transient accidental Star Wars favourite (from a mis-clicked selector) was reverted immediately within the same steps and left no residual state either.
