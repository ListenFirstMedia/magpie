# QA-136357 — Brand Content > Impressions data set - Facebook Reel Reach Metrics Display - Data QA (15 Nov 2025 - 10 May 2026)

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** HBO Max (account_id=657), Brand: HBO Max (brand_id=155614), Data Set: Impressions, Facebook channel only, Publish Type: Reel filter, Nov 15 2025 – May 10 2026
**Status:** ✅ PASS (5/5 assertions)

## Steps executed
1. Switched account to HBO Max; brand auto-selected as exact-match "HBO Max" (brand_id=155614).
2. Enabled Facebook channel only (disabled Twitter/Instagram/LinkedIn/TikTok/Threads).
3. Set date range to Nov 15, 2025 – May 10, 2026 via calendar navigation.
4. Data Set dropdown → "Impressions" (Cross-Channel Metrics).
5. Filter → Publish Type → Reel → Apply Filter.
6. Switched to Table View; toggled the aggregate row's Sum/Average switch (`label[for="aggregate_row"]`) to read both states.

## Data recorded
Posts (4) — all within the spec's post-cutoff window (≥ 15 Nov 2025).

| Row | Reach | Organic Reach | Paid Reach |
|---|---|---|---|
| Sum | N/A | N/A | N/A |
| Average | – | – | – |
| Post 1 (Mar 12, 2026) | – | – | – |
| Post 2 (Mar 23, 2026) | – | – | – |
| Post 3 (Apr 07, 2026) | – | – | – |
| Post 4 (Apr 22, 2026) | – | – | – |

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (6a) | Page refreshes, post count updates on filter apply | Posts (4) rendered after filter apply | ✅ PASS |
| A2 (6b) | Only Facebook Reel posts displayed | All 4 posts show `PublishType = Reel`, Channel = Facebook | ✅ PASS |
| A3 (6c) | Each Reel post shows en-dash (–) for Reach, Organic Reach, Paid Reach | 4/4 posts show "–" for all three columns | ✅ PASS |
| A4 (6d) | Sum row displays N/A for Reach, Organic Reach, Paid Reach | Confirmed via table's Sum toggle state | ✅ PASS |
| A5 (6e) | Average row displays en-dash (–) for Reach, Organic Reach, Paid Reach | Confirmed via table's Average toggle state | ✅ PASS |

## Note
The on-screen summary widget above the grid layout visually renders "N/A" for both the Sum and Average lines at a glance — the actual distinction (Sum=N/A vs Average=en-dash per spec) only becomes visible by inspecting the Table View's aggregate row, which has a Sum/Average toggle switch (`label[for="aggregate_row"]`) rather than two separate static rows. Toggling it confirmed the spec's expected N/A-vs-en-dash distinction is correctly implemented — not a bug, just a subtlety in how to verify it.

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation.
