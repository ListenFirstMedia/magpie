# QA-136263 — Brand Content > Facebook Video - Reel Posts Filtering (last 90 days)

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Hulu (account_id=336), Brand: Hulu (brand_id=5670), Facebook channel, Last 90 Days
**Status:** ✅ PASS (4/4 assertions)

## Steps executed
1. Brand → Content, Hulu already selected from prior case; Facebook-only channel already active.
2. Date Range → Make a Selection dropdown → "Last 90 Days" (Apr 14, 2026 – Jul 12, 2026).
3. Filter dropdown → selected both Content Type: Video AND Publish Type: Reel (layered, both Include/Or) → Apply Filter. URL: `filters={"content_types":{"operator":"or","values":["Video"],"not":"false"},"content_post_class":{"operator":"or","values":["reel"],"not":"false"}}`.
4. Switched to Detail View (`[title="Detail View"]`).
5. Toggled the Publish Type: Reel filter pill's Include/Exclude switch (`label[for="content_post_class_content_post_class_0"]`) to Exclude, then clicked Apply Filter again (per the now-documented two-step pattern — toggling the switch alone doesn't refresh data).
6. Switched to Table View to sample-verify the Publish Type column across the exclude-filtered set.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (6a) | Post count updates correctly after applying Content Type=Video + Publish Type=Reel | Posts (1) — down from the unfiltered ~hundreds | ✅ PASS |
| A2 (6b) | Only Facebook reel posts are displayed | The single matching post shows Type=Video badge + Publish Type=Reel, Channel=Facebook | ✅ PASS |
| A3 (7) | Only Reel posts displayed in Detail view | Detail view rendered the same 1 post with Type=Video / Publish Type=Reel visible in the detail fields | ✅ PASS |
| A4 (9) | Reel posts not displayed after excluding Publish Type: Reel | Posts (417) after exclude; sampled first 200 rows in Table View — 0/200 have `PublishType = Reel` (all `Original Post`) | ✅ PASS |

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation. Filters left in place at end of session (no cleanup required for view-only filter state).
