# QA-20533 — Brand Content > Dev vs Prod > Public Data Set > Twitter Channel

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Apple Services · **Brand:** Apple Music · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: Public · Channel(s): twitter
**Verdict: PASS — 4 posts matched 1:1 between Dev and Prod, 0 metric differences across 16 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Apple Music (account Apple Services) | ✅ Table View |
| 2 | Dev: data set → **Public** | {"ok": true, "n": 2, "idx": 0, "posts": "55"} |
| 3 | Dev: channel(s) → **twitter** → Apply | enabled ['twitter'] · Posts (4) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 4 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['twitter'] · Posts (4) |
| 6 | Prod: Table View scrape | 4 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 4, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 4 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-20533`.
- Dev aggregate row: `{"Engagements": "4,256", "Reactions": "3,125", "Comments": "56", "Shares": "3,356", "Response Rate": "N/A", "Video Views": "45,756", "Video Response Rate": "N/A"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Wednesday row: Apple Services / Apple Music.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
