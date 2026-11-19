# QA-21027 — Brand Content > Dev vs Prod >   Reactions Data Set> Twitter Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Public · Channel(s): twitter
**Verdict: PASS — 33 posts matched 1:1 between Dev and Prod, 0 metric differences across 16 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ Table View |
| 2 | Dev: data set → **Public** | {"ok": true, "n": 2, "idx": 0, "posts": "33"} |
| 3 | Dev: channel(s) → **twitter** → Apply | enabled ['twitter'] · Posts (33) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 33 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['twitter'] · Posts (33) |
| 6 | Prod: Table View scrape | 33 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 33, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 33 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-21027`.
- Dev aggregate row: `{"Engagements": "589", "Reactions": "498", "Comments": "13", "Shares": "71", "Response Rate": "N/A", "Video Views": "2,901", "Video Response Rate": "N/A"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- The spec names a 'Reactions' data set that does not exist in the data set dropdown; the Twitter Public comparison the dev half of the spec describes (Engagements, Reactions, Comments, Shares) was run.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
