# QA-20276 — Brand Content > Dev vs Prod > Instagram Only: Insigts

**Run date:** 2026-11-17 (Tuesday → rotation row: account **Michael Kors**, brand **Michael Kors**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Michael Kors · **Brand:** Michael Kors · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Instagram Only: Insights · Channel(s): instagram
**Verdict: PASS — 11 posts matched 1:1 between Dev and Prod, 0 metric differences across 17 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Michael Kors (account Michael Kors) | ✅ Table View |
| 2 | Dev: data set → **Instagram Only: Insights** | {"ok": true, "n": 1, "idx": 0, "posts": "11"} |
| 3 | Dev: channel(s) → **instagram** → Apply | enabled ['instagram'] · Posts (11) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 11 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['instagram'] · Posts (11) |
| 6 | Prod: Table View scrape | 11 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 11, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 11 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-20276`.
- Dev aggregate row: `{"Engagements": "25,223", "Saves": "1,532", "Organic Saves": "1,532", "Paid Saves": "–", "Shares": "2,415", "Views": "1,832,946", "Private Likes": "24,760", "Effectiveness": "N/A"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Tuesday row: Michael Kors / Michael Kors.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
