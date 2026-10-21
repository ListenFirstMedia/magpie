# QA-20276 — Brand Content > Dev vs Prod > Instagram Only: Insigts

**Run date:** 2026-10-20 (Tuesday → rotation row: account **Michael Kors**, brand **Michael Kors**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Michael Kors · **Brand:** Michael Kors · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Instagram Only: Insights · Channel(s): instagram
**Verdict: PASS — 13 posts matched 1:1 between Dev and Prod, 0 metric differences across 8 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Michael Kors (account Michael Kors) | ✅ 13 posts in Table View |
| 2 | Dev: data set → **Instagram Only: Insights** | ✅ |
| 3 | Dev: channel(s) → **instagram** → Apply | ✅ enabled ['instagram'] · Posts (13) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | ✅ 13 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 13 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 13 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 13, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 13 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Saves | Organic Saves | Paid Saves | Shares | Views | Private Likes | Effectiveness |
|---|---|---|---|---|---|---|---|
| 25,296 | 1,303 | 1,303 | – | 1,500 | 2,813,195 | 24,981 | N/A |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-20276`).

## Known bugs checked
- None open.
- Dev's default brand for the Michael Kors account is 'SS22 New York Fashion Week Roll-Up' (prod default is Michael Kors) — the brand picker was used on dev to select Michael Kors (brand_id 3801 on both). A first comparison against the wrong default brand (200 vs 13 posts) was discarded.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
