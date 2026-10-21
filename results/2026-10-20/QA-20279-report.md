# QA-20279 — Brand Content > Dev vs Prod > Pinterest Only:  Basic Data Set

**Run date:** 2026-10-20 (Tuesday → rotation row: account **Ralph Lauren**, brand **Ralph Lauren**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Ralph Lauren · **Brand:** Ralph Lauren · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Pinterest Only: Basic · Channel(s): pinterest
**Verdict: PASS — 43 posts matched 1:1 between Dev and Prod, 0 metric differences across 3 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Ralph Lauren (account Ralph Lauren) | ✅ 43 posts in Table View |
| 2 | Dev: data set → **Pinterest Only: Basic** | ✅ |
| 3 | Dev: channel(s) → **pinterest** → Apply | ✅ enabled ['pinterest'] · Posts (43) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Pin Saves, Comments) | ✅ 43 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 43 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 43 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 43, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Pin Saves, Comments) | 43 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Pin Saves | Comments |
|---|---|---|
| 0 | – | 0 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-20279`).

## Known bugs checked
- None open.
- Dev's default brand for the Ralph Lauren account is 'Andrew Domink'; the brand picker selected Ralph Lauren (brand_id 7000) on both. Pin Saves is '–' and Engagements/Comments 0 on every pin on BOTH environments (same as QA-20334 finding on 2026-10-19) — parity holds.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
