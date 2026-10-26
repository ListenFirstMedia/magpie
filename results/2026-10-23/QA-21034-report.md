# QA-21034 — Brand Stories > Dev vs Prod > Rates Data Set

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu · **Brand:** Hulu · Date range: default week (Oct. 15, 2026 – Oct. 21, 2026 on both) · Data set: Rates · Channel(s): instagram (Stories page)
**Verdict: PASS — 29 posts matched 1:1 between Dev and Prod, 0 metric differences across 8 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Hulu (account Hulu) | ✅ 29 posts in Table View |
| 2 | Dev: data set → **Rates** | ✅ |
| 4 | Dev: Table View scrape of every row (columns: Author, Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate) | ✅ 29 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 29 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 29 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 29, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Author, Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate) | 29 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Author | Engagements | Engaged User Rate | Taps Forward Rate | Taps Back Rate | Exits Rate | Completion Rate | DM Rate |
|---|---|---|---|---|---|---|---|
|  | 1,399 | N/A | N/A | N/A | N/A | N/A | N/A |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-23/_devprod-results.json`, key `QA-21034`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
