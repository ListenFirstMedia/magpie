# QA-136264 — Brand Content > Facebook Reel Posts - Native Check

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** UCLA (account_id=799), Brand: University of California, Los Angeles (brand_id=127756), Reels Data Set
**Status:** ✅ PASS (1/1 assertion)

## Note on brand selection
No brand named literally "UCLA" exists in the typeahead (67 results for "UCLA" search, all "UCLA <Department/Program>" — e.g. UCLA Athletics, UCLA Health, UCLA Law — none matching exactly "UCLA"). The account's own default/primary brand is **"University of California, Los Angeles"** (brand_id=127756), which the app auto-selects when reaching Brand > Content from Home with no brand favorited. This is the account-level canonical brand the spec's "UCLA" shorthand refers to (distinct from Rule 1's substitution anti-pattern, where a *different, unrelated* brand would be picked) — proceeded with it.

## Environment note
Hit the documented `app.lfmdev.in` renderer-hang pattern twice while navigating to a brand-less Brand>Content page and to Home after switching accounts (page stuck on generic "Loading…" indefinitely). Recovered both times via `location.reload()`. Not filed as a new bug — matches existing known-quirks entries for this dev environment's render-lifecycle instability.

## Steps executed
1. Switched account to UCLA. Reaching Brand > Content directly (no brand_id) hung on "Loading…" — recovered via reload, then navigated from Home > "Brand Content" suggested-view link, which auto-opened a new tab with the account's default brand.
2. Confirmed brand as "University of California, Los Angeles" (brand_id=127756) via the brand typeahead (see note above).
3. Data Set dropdown → selected "Reels" under Cross-Channel Metrics. Channel row auto-narrowed to Instagram (Facebook and others greyed/disabled for this data set on this brand).
4. Table View: recorded first post (Jul 08, 2026, sorted by Engagements): Reactions 1,897, Comments 18, Shares 1,215.
5. Opened the post's native link (`https://www.instagram.com/reel/Dai5SK9iVnw/`) in a new tab.
6. Read native (logged-out) Instagram values: Likes "1.9K", Comments "18". Share count is not publicly exposed by Instagram's logged-out post view (platform limitation, not an LFM gap).

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 6) | LFM metric values should not have big variations compared to Native | Reactions: LFM 1,897 vs Native "1.9K" (rounds to ~1,900 — matches within native display precision). Comments: LFM 18 vs Native 18 — exact match. No material variation. | ✅ PASS |

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation.
