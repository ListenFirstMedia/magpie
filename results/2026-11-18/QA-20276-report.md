# QA-20276 — Brand Content > Dev vs Prod > Instagram Only: Insigts

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Viacom**, brand **MTV**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Viacom · **Brand:** MTV · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: Instagram Only: Insights · Channel(s): instagram
**Verdict: PASS — 39 posts matched 1:1 between Dev and Prod, 0 metric differences across 17 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for MTV (account Viacom) | ✅ Table View |
| 2 | Dev: data set → **Instagram Only: Insights** | {"ok": true, "n": 1, "idx": 0, "posts": "39"} |
| 3 | Dev: channel(s) → **instagram** → Apply | enabled ['instagram'] · Posts (39) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 39 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['instagram'] · Posts (39) |
| 6 | Prod: Table View scrape | 39 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 39, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness) | 39 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-20276`.
- Dev aggregate row: `{"Engagements": "707,473", "Saves": "17,844", "Organic Saves": "17,844", "Paid Saves": "–", "Shares": "17,719", "Views": "18,816,348", "Private Likes": "703,787", "Effectiveness": "N/A"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Wednesday row: Viacom / MTV.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
