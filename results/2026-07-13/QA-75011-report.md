# QA-75011 — Settings > Custom Metrics - Basic View

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS

## Steps executed
1. Navigated via Settings dropdown menu → Custom Metrics (direct URL nav to `#custom-metrics` alone did not fully route on first try — same SPA-route staleness quirk seen on QA-63603; menu-click navigation resolved it).
2. Observed the Basic View table.

## Assertions

| Expected | Actual | Status |
|----------|--------|--------|
| Custom Metrics Basic View renders with a metrics table | Confirmed. Columns: `Metric, Description, Created Date, Creator, Formula, Actions`. "Create a Custom Metric" button + "Search Custom Metrics" input present. Sample rows: "Automation - All Operators Metric" (formula visible: `facebook.page.total_post_comments_c + facebook.page.total_post_likes_c - lfm.cross_channel_shares.public_shares_v5 * 2 / 100`), "Cross-Channel Engagements", "Custom test" | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
