# QA-19950 — Brand Content - CSV - All Data set - Impressions

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: University of California, Los Angeles (brand_id=127756)
**Status:** ✅ PASS

## Steps executed
1. Brand → Content, typed "University of California, Los Angeles", selected exact match from Results (brand_id=127756).
2. Set date range to a single day: 2024-12-25 (per spec's "Recent single date range").
3. Table View selected.
4. Data Set dropdown → **Impressions**.
5. Export → clicked the toolbar `content-export-btn` → "Export Select Data Sets" modal → **Impressions** checkbox pre-checked (matches active data set) → **Ok**.
6. Export was queued (async, unlike TWC's synchronous download) — no file appeared in `.playwright-out/` immediately.
7. Opened Recent Activity bell → found "Select Data Sets Export ... is now ready. Download file." notification → located its embedded `<a>` href (`https://analytics-cdn.lfmdev.in/302447-72037ca5e8ae5386f331c2f14ad5703f.csv`) — **note:** an earlier, stale notification from a prior unrelated export (MTV, Public data set) also matched a naive "Download file." text search; had to match the full notification sentence text exactly to get the right CDN URL.
8. Fetched the CSV via in-page `fetch(url, {credentials:'include'})` per Rule 6's documented pattern (email inbox not accessible from this automation context — CDN fetch is the established equivalent verification).

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 7 | Export includes: Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate | CSV header (after the `Data Set` preamble row) reads exactly: `...Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate` — all 8 spec columns present verbatim | ✅ PASS |
| 7 | Displayed metrics data matches the export | UI: Posts(8), Sum Engagements 471, Impressions/Reach columns all `–` (em-dash, data-freshness gap for this historical date). CSV: 8 rows, Engagements column `198+187+42+34+10+""+""+""=471` exact match; Impressions/Reach columns empty (consistent with the UI's em-dash) | ✅ PASS |

## Bugs filed

None — 471 was flagged by LFMP-31979 (Facebook/Pinterest thumbnail issue) as a probe target but this run's channel mix (Facebook/Twitter/Link/LinkedIn/Threads posts, no Pinterest) didn't surface a thumbnail to check; not re-probed this run.

## Cleanup

Not applicable — no mutation.
