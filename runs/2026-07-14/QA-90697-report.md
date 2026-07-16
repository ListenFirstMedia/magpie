# QA-90697 — Brand Content > All Insights - Facebook Reel Aggregate Data QA

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Hulu (account_id=336), Brand: Hulu (brand_id=5670), Facebook channel, Data Set: Public
**Status:** ✅ PASS (4/4 assertions)

## Steps executed
1. Switched account to Hulu via profile dropdown → Search Account → Results.
2. Brand → Content. Typed 'Hulu' in the brand typeahead, selected the exact-match `Hulu` result (brand_id=5670) — Rule 1 compliant.
3. Set date range Apr 09, 2025 – Apr 15, 2025 (calendar navigation, 15 months back from default).
4. Channels: disabled Twitter/Instagram/LinkedIn/TikTok/Threads channel-ghosts (real clicks), leaving Facebook only; clicked Apply.
5. Data Set dropdown → explicitly selected "Public" under Cross-Channel Metrics (matches default, clicked through for spec compliance).
6. Filter → Publish Type → Reel → Apply Filter (Include, default). Recorded Reel-Included aggregate.
7. Toggled the filter pill's Include/Exclude switch (`label[for="content_post_class_content_post_class_0"]`) to Exclude, clicked Apply Filter again (toggling the switch alone did not re-trigger the data fetch — Apply Filter had to be clicked a second time). Recorded Reel-Excluded aggregate.
8. Clicked "Clear All" to remove the filter entirely, restoring the full post set.
9. Opened Insights ▾ → checked "All Insights" to render the full insight-tile grid (New Posts, Engagements, Engagement Rate, Reactions, Comments, Shares, Impressions, Video Views).

## Data recorded

| State | Posts | Engagements | Reactions | Comments | Shares |
|---|---|---|---|---|---|
| Reel — Include | 20 | 668,711 | 614,741 | 19,076 | 34,894 |
| Reel — Exclude | 9 | 14,942 | 13,922 | 208 | 812 |
| **Sum (Include+Exclude)** | **29** | **683,653** | **628,663** | **19,284** | **35,706** |
| Unfiltered table Sum row (after Clear All) | 29 | 683,653 | 628,663 | 19,284 | 35,706 |
| All Insights tiles Sum | New Posts: 29 | 683,653 | 628,663 | 19,284 | 35,706 |

Additional All Insights tile values: Impressions Sum = 42,988,443. Engagement Rate tile Sum/Average = 1.59%.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Engagement Rate content insights tile shows the Engagement Rate value for Facebook Reels | Tile renders `1.59%` for Facebook (Sum and Average both show the same rate, as expected for a ratio metric) | ✅ PASS |
| A2 | Sum of posts (Reel-included + Reel-excluded) equals the New Post tile count | 20 + 9 = 29; New Posts tile Sum = 29; unfiltered table also shows Posts (29) | ✅ PASS |
| A3 | Sum of each metric aggregate (Reel-included + Reel-excluded) equals the insights tile aggregate value | Engagements 668,711+14,942=683,653; Reactions 614,741+13,922=628,663; Comments 19,076+208=19,284; Shares 34,894+812=35,706 — all four exactly match both the unfiltered table Sum row AND the All Insights tile Sum values | ✅ PASS |
| A4 | Division of Engagements/Impressions*100 equals the Engagement Rate | 683,653 / 42,988,443 × 100 = 1.5903% ≈ 1.59% — exact match to the displayed Engagement Rate tile value | ✅ PASS |

## Bugs filed
None. No discrepancies found — all aggregate math reconciled exactly across the Reel-include/exclude split, the unfiltered table, and the All Insights tile grid.

## Cleanup
None — read-only verification. Filter was cleared via "Clear All" as part of the test flow itself (no lingering mutation).

## Note
Toggling a filter pill's Include/Exclude switch (`toggle-switch-checkbox` inside `.filter-pill-container`) updates the pill's visual state and the `not` value staged for the next apply, but does **not** by itself re-trigger the backend query — a second click on the (still-enabled) "Apply Filter" button is required to actually refresh the post list/aggregates. Worth folding into `skills/brand-content-filter/SKILL.md`'s Include/Exclude documentation.
