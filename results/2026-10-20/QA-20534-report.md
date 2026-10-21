# QA-20534 — Brand Content > Dev vs Prod > Public Data Set > Instagram Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Public · Channel(s): instagram
**Verdict: PASS — 13 posts matched 1:1 between Dev and Prod, 0 metric differences across 7 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ 13 posts in Table View |
| 2 | Dev: data set → **Public** | ✅ |
| 3 | Dev: channel(s) → **instagram** → Apply | ✅ enabled ['instagram'] · Posts (13) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | ✅ 13 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 13 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 13 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 13, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 13 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Reactions | Comments | Shares | Response Rate | Video Views | Video Response Rate |
|---|---|---|---|---|---|---|
| 10,641 | 10,486 | 155 | – | N/A | 415,383 | N/A |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-20534`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
