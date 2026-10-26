# QA-21033 — Brand Stories > Dev vs Prod > Insights Data Set

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu · **Brand:** Hulu · Date range: default week (Oct. 15, 2026 – Oct. 21, 2026 on both) · Data set: Insights (Brand > Stories) · Channel(s): instagram (Stories page)
**Verdict: PASS — 29 posts matched 1:1 between Dev and Prod, 0 metric differences across 10 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Hulu (account Hulu) | ✅ 29 posts in Table View |
| 4 | Dev: Table View scrape of every row (columns: Author, Engagements, Impressions, Reach, Taps Forward, Taps Back, Exits, DM Replies, Shares, Profile Visits) | ✅ 29 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 29 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 29 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 29, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Author, Engagements, Impressions, Reach, Taps Forward, Taps Back, Exits, DM Replies, Shares, Profile Visits) | 29 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Author | Engagements | Impressions | Reach | Taps Forward | Taps Back | Exits | DM Replies | Shares | Profile Visits |
|---|---|---|---|---|---|---|---|---|---|
|  | 1,399 | 271,787 | N/A | 186,600 | 6,635 | 27,593 | 102 | 180 | 1,101 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-23/_devprod-results.json`, key `QA-21033`).

## Known bugs checked
- None open.
- Surface is Brand > Stories: 29 stories in the default week; Data Visualization toggle not needed (Table View already exposed).

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
