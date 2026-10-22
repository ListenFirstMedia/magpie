# QA-144819 — Settings > Brands - Channel and Data Collection Status Dev vs Prod Parity (APPS-61918)

**Run date:** 2026-10-22 (Thursday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev + prod tabs, both switched to **Adam Orfei**
**Account:** Adam Orfei (account_id=54) · Surface: Settings > Brands (`#brands`)
**Verdict: PASS — page 1 of Settings > Brands (50 brands) identical on Dev and Prod for Channels and Data Collection Status; both environments paginate to 122 pages**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Settings → Brands, scrape 50 rows (brand, channel icon classes, status badge counts) | ✅ e.g. "#1 Happy Family USA" X/YouTube/Wikipedia/IMDb/Metacritic, status 2 warnings / 4 ok; "007 Franchise" 2 / 17 |
| 4–6 | Prod: same | ✅ 50 rows |
| 7 | Compare brand by brand | ✅ 50/50 matched, 0 differences; pager "Page: 1 2 3 4 5 6 … 122" on both |
| 8 | Feed-level Data Collection check | ⏭️ not repeated today (verified 2026-10-20 for 007 Franchise: feed statuses identical and consistent with the Brands row) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7a–c | Channels, Data Collection Status and brand count match | page 1 identical, same page count | ✅ PASS (page-1 sample) |
| A8 | Brands status agrees with Data Collection feed status | verified 2026-10-20, not re-run | ✅ (carried) |

## Evidence
- Session result `ctx._brands2`.

## Known bugs checked
- None open; APPS-62439 referenced in the precondition did not surface.

## Notes
- "007 Franchise" status moved from 3/16 (20 Oct) to 2/17 (22 Oct) on both environments — a feed recovered; parity holds.

## Bugs filed
None.

## Cleanup
None (read-only).
