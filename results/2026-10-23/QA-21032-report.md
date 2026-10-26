# QA-21032 — Brand Content > Dev vs Prod > Clicks Data Set > Twitter Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu · **Brand:** Hulu · Date range: default week (Oct. 15, 2026 – Oct. 21, 2026 on both) · Data set: Clicks (carried over from QA-21031) · Channel(s): twitter
**Verdict: PASS — 40 posts matched 1:1 between Dev and Prod, 0 metric differences across 6 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Hulu (account Hulu) | ✅ 40 posts in Table View |
| 3 | Dev: channel(s) → **twitter** → Apply | ✅ enabled ['twitter'] · Posts (40) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Link Clicks, Organic Clicks, Paid Clicks, Other Clicks, Photo Views) | ✅ 40 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 40 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 40 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 40, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Link Clicks, Organic Clicks, Paid Clicks, Other Clicks, Photo Views) | 40 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Link Clicks | Organic Clicks | Paid Clicks | Other Clicks | Photo Views |
|---|---|---|---|---|---|
| 8,569 | – | – | – | 800 | – |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-23/_devprod-results.json`, key `QA-21032`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
