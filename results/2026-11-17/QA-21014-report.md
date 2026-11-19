# QA-21014 — Brand Content > Dev vs Prod > Engagements Breakdowns Data Set > Instagram Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Engagements Breakdown · Channel(s): instagram
**Verdict: PASS — 9 posts matched 1:1 between Dev and Prod, 0 metric differences across 21 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ Table View |
| 2 | Dev: data set → **Engagements Breakdown** | {"ok": true, "n": 2, "idx": 0, "posts": "33"} |
| 3 | Dev: channel(s) → **instagram** → Apply | enabled ['instagram'] · Posts (9) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares) | 9 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['instagram'] · Posts (9) |
| 6 | Prod: Table View scrape | 9 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 9, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares) | 9 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-21014`.
- Dev aggregate row: `{"Engagements": "12,756", "Organic Engagements": "12,756", "Paid Engagements": "–", "Reactions": "12,614", "Organic Reactions": "12,614", "Paid Reactions": "–", "Comments": "142", "Organic Comments": "142", "Paid Comments": "–", "Shares": "–", "Organic Shares": "–", "Paid Shares": "–"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- No deviations from the case.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
