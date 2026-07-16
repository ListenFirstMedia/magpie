# QA-35084 — Brand Content > Facebook Reel data set - All Views

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Viacom (account_id=181), Brand: MTV (brand_id=4018), Reels Data Set, Facebook channel only
**Status:** ✅ PASS (4/4 assertions)

## Steps executed
1. Switched account to Viacom; MTV auto-selected as default brand, re-confirmed via typeahead exact match "MTV" — Rule 1 compliant.
2. Data Set dropdown → selected "Reels" under Cross-Channel Metrics. Channel row auto-narrowed to Instagram + Facebook (Reels-eligible channels).
3. Disabled Instagram channel-ghost, applied → Facebook only.
4. Default date range (current week) returned Posts (0) — no Facebook Reel data in that window. Broadened via Make a Selection → "Last 12 Months" to find data (spec doesn't pin a date, and this dataset needs a real Reel population to exercise the assertions).
5. Verified default Sort = Engagements.
6. Switched to Detail View — verified same aggregate metrics render.
7. Switched to Table View — verified column set.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 4) | Default sort is "Engagements" | Sort dropdown shows "Engagements" by default | ✅ PASS |
| A2 (step 5a) | Same metrics updated in the Detail view | Detail view for post 1 (Aug 10, 2025, Facebook, Reel) shows Engagements/Reactions/Comments/Shares/Reach/Plays etc., matching the grid/table figures | ✅ PASS |
| A3 (step 5b) | Aggregate table displays "Engagements" and "Follows" | Both present in the Sum/Average aggregate row (Sum Engagements 3,771,566; Sum Follows 54,766) | ✅ PASS |
| A4 (step 6) | Table View has columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Plays, Follows, Actions | All 15 listed columns present (verified via header text extraction) | ✅ PASS |

## Note
Table View has 9 additional columns beyond the spec's list (Reactions, Comments, Shares, Reach, Initial Plays, Reel Replays, Avg Time Watched (Minutes), Video Views Total Time (Minutes), Total Reel Interactions) — the spec's list reads as a minimum required set, not an exhaustive one, so this is not counted as a failure.

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation.
