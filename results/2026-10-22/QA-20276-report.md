# QA-20276 — Brand Content > Dev vs Prod > Instagram Only: Insigts

**Run date:** 2026-10-22 (Thursday → rotation row: account **FX Networks**, brand **FX Networks Composite**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** FX Networks · **Brand:** FX Networks Composite · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: Instagram Only: Insights · Channel(s): instagram
**Verdict: PASS — 43 posts matched 1:1 between Dev and Prod, 0 metric differences across 8 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for FX Networks Composite (account FX Networks) | ✅ 43 posts in Table View |
| 2 | Dev: data set → **Instagram Only: Insights** | ✅ |
| 3 | Dev: channel(s) → **instagram** → Apply | ✅ enabled ['instagram'] · Posts (43) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | ✅ 43 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 43 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 43 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 43, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 43 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-20276`).

## Known bugs checked
- None open.
- Thursday rotation brand 'FX Networks' does not exist on the FX Networks account; the only FX brand there is 'FX Networks Composite' (brand_id 62693), used on both environments. Dev default brand was the composite, prod default was 'It's Always Sunny in Philadelphia' — the brand picker aligned both. The page needs ~3 minutes to load on dev.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
