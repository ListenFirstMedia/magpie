# QA-100886 — Brand Content > Dev vs Prod > Threads Only: Insights Data Set

**Run date:** 2026-10-22 (Thursday → rotation row: account **HBO Max**, brand **HBO Max**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** HBO Max · **Brand:** HBO Max · Date range: Jun 01, 2025 – Jun 07, 2025 · Data set: Threads Only: Insights · Channel(s): threads
**Verdict: PASS — 21 posts matched 1:1 between Dev and Prod, 0 metric differences across 7 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for HBO Max (account HBO Max) | ✅ 21 posts in Table View |
| 2 | Dev: data set → **Threads Only: Insights** | ✅ |
| 3 | Dev: channel(s) → **threads** → Apply | ✅ enabled ['threads'] · Posts (21) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Likes, Replies, Quotes, Reposts, Shares, Views) | ✅ 21 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 21 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 21 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 21, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Likes, Replies, Quotes, Reposts, Shares, Views) | 21 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-100886`).

## Known bugs checked
- None open.
- Same Jun 2025 window as QA-100881.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
