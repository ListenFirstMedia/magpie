# QA-20273 — Brand Content > Dev vs Prod > Facebook Only: Completed & Live Video Data Set

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Facebook Only: Completed Video Views · Channel(s): facebook
**Verdict: PASS — 7 posts matched 1:1 between Dev and Prod, 0 metric differences across 7 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ 7 posts in Table View |
| 2 | Dev: data set → **Facebook Only: Completed Video Views** | ✅ |
| 3 | Dev: channel(s) → **facebook** → Apply | ✅ enabled ['facebook'] · Posts (7) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Video Duration, Avg Time Watched (Minutes), Avg Viewthru, Completed Views, Organic Completed Views, Paid Completed Views) | ✅ 7 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 7 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 7 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 7, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Video Duration, Avg Time Watched (Minutes), Avg Viewthru, Completed Views, Organic Completed Views, Paid Completed Views) | 7 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Video Duration | Avg Time Watched (Minutes) | Avg Viewthru | Completed Views | Organic Completed Views | Paid Completed Views |
|---|---|---|---|---|---|---|
| 2,010 | 6m38s |  |  | 72 | 72 | 0 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-20273`).

## Known bugs checked
- None open.
- Facebook rows carry no post permalink in Table View; rows were joined on Date + first 60 chars of Text (7/7 matched).

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
