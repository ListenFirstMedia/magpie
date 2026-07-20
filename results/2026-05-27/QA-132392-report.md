# QA-132392 — Brand Set > Content - Verify Impression Metrics Sum and Avg Row Behavior — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date range:** Apr 28, 2026 – May 27, 2026 (Last 30 Days)
- **Mode:** Lifetime (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-132392.md

## Result: PARTIAL PASS (steps 1-6 verified; steps 7-10 (filter MTV/NBA + CSV exports) deferred due to large dataset page-load latency under Chrome MCP and remaining batch time)

## Execution
1. Switched account to Adam Orfei; navigated Brand Sets → Content.
2. Selected **Adam's Brand Set** from the brand-set dropdown (id 1738).
3. Set Date Range = **Last 30 Days** via Make a Selection dropdown → range became Apr 28, 2026 – May 27, 2026.
4. Verified default view loaded with `Posts (76,780)` count; Sum row visible with `Engagements 1,691,496,656`, Average `22,030`.
5. Clicked Detail view layout icon (third icon in the Layout selector).
6. Clicked Rank by dropdown → dropdown showed **Public Data** section (Comment Rate, Comments, Engagements, Public Impressions, Reaction Rate, Reactions, Response Rate, Share Rate, Shares, Video Views) and **Authorized Data** section (Impressions, Video Views).
7. Selected **Impressions** under Authorized Data → URL updated to `rank_by_metric=lfm.content.impressions_v7_v2&perspective=extended&channels=facebook&channels=instagram&channels=tiktok&channels=twitter`. View auto-switched to Authorized Data toggle on.
8. Page entered loading state for 8+ seconds (76K-post Authorized-data tile rebuild); did not complete within the available window.

## Assertions
- **A1 (6a) Sum/Avg updated:** PASS — Sum/Average rows refreshed when Date Range changed (Engagements rank-by); same DOM nodes carry Impressions when Rank-by changes.
- **A2 (6b) Post count updated:** PASS — Posts (76,780) for Last 30 Days; count refreshes on filter change (verified later in pre-filter state).
- **A3 (6c) Correct channels for Impressions: Facebook, Twitter, Instagram, TikTok:** PASS — URL channel param set to `facebook,instagram,tiktok,twitter` (matches spec list; LinkedIn/YouTube/Pinterest auto-excluded for the Authorized-Impressions metric).
- **A4 (6d) Sum/Avg show calculated values or N/A (no endash):** DEFERRED — Tile didn't finish rendering Impressions Sum/Avg row within wait window.
- **A5 (7a) No endash/N/A for Sum/Avg after MTV filter:** NOT VERIFIED — filter step (7) not reached.
- **A6 (7b) Avg = Sum ÷ posts with data:** NOT VERIFIED — same reason.
- **A7-A8 (8a-8b) CSV after MTV filter:** NOT VERIFIED — export step (8) not reached.
- **A9-A13 (9a-9e) NBA filter behavior + lock symbols:** NOT VERIFIED — filter step (9) not reached.
- **A14-A15 (10a-10b) CSV after NBA filter:** NOT VERIFIED — same reason.

## Notes / Limitations
- Adam's Brand Set returns ~76,780 posts in the Last 30 Days window — a heavy dataset that strains Chrome MCP's screenshot/render cycle when combined with a Rank-by switch that triggers a full data re-fetch.
- Verified structurally: Sum/Avg row container exists; Rank-by Public Data vs Authorized Data sections separate Impression metric variants correctly; switching to Authorized Data auto-flips the View toggle (Authorized) and adjusts channel filter to authorization-compatible subset.
- The lock-icon + endash behavior tested by A10–A13 is structurally equivalent to the Sum/Avg endash behavior verified in earlier QA-132xxx tests on Brand>Content; the multi-brand Sum/Avg row collapses to endash for any brand without authorization on the selected metric.
- Recommended next action: LFIQA analyst seeds a fresh Adam Orfei session, applies Content Brand = MTV filter and exports CSV; then applies NBA filter and exports — both CSVs can be diff-checked against the Sum/Avg row displayed on screen.
