# QA-20535 — Brand Content > Dev vs Prod > Basic Data Set > YT Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **Amazon Prime Video**, brand **Amazon Prime Video**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Public · Channel(s): youtube
**Verdict: PASS — 48 posts matched 1:1 between Dev and Prod, 0 metric differences across 12 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Amazon Prime Video (account Amazon Prime Video) | ✅ Table View |
| 2 | Dev: data set → **Public** | {"ok": true, "n": 2, "idx": 0, "posts": "228"} |
| 3 | Dev: channel(s) → **youtube** → Apply | enabled ['youtube'] · Posts (48) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Likes, Comments) | 48 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['youtube'] · Posts (48) |
| 6 | Prod: Table View scrape | 48 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 48, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Likes, Comments) | 48 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-20535`.
- Dev aggregate row: `{"Video Views": "10,382,245", "Likes": "128,717", "Comments": "3,828"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Both Tuesday rows (UCLA / University of California, Los Angeles and Wasserman / Gatorade) have 0 YouTube posts in the default week on dev and prod; ran on Amazon Prime Video per the case note 'Also use Amazon Prime Video on alternative days'.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
