# QA-100886 — Brand Content > Dev vs Prod > Threads Only: Insights Data Set

**Run date:** 2026-11-17 (Tuesday → rotation row: account **HBO Max**, brand **HBO Max**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** HBO Max · **Brand:** HBO Max · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Threads Only: Insights · Channel(s): threads
**Verdict: PASS — 4 posts matched 1:1 between Dev and Prod, 0 metric differences across 16 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for HBO Max (account HBO Max) | ✅ Table View |
| 2 | Dev: data set → **Threads Only: Insights** | {"ok": true, "n": 1, "idx": 0, "posts": "4"} |
| 3 | Dev: channel(s) → **threads** → Apply | enabled ['threads'] · Posts (4) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Likes, Replies, Quotes, Reposts, Shares, Views) | 4 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['threads'] · Posts (4) |
| 6 | Prod: Table View scrape | 4 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 4, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Likes, Replies, Quotes, Reposts, Shares, Views) | 4 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-100886`.
- Dev aggregate row: `{"Engagements": "6,035", "Likes": "4,975", "Replies": "397", "Quotes": "73", "Reposts": "416", "Shares": "174", "Views": "521,425"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Precondition "logged in as Max": account HBO Max, brand HBO Max.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
