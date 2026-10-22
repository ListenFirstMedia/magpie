# QA-20274 — Brand Content > Dev vs Prod > Facebook Only: Reactions DataSet

**Run date:** 2026-10-22 (Thursday → rotation row: account **Amazon Prime Video**, brand **Amazon Prime Video**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: Facebook Only: Reactions · Channel(s): facebook
**Verdict: PASS — 77 posts matched 1:1 between Dev and Prod, 0 metric differences across 9 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Amazon Prime Video (account Amazon Prime Video) | ✅ 77 posts in Table View |
| 2 | Dev: data set → **Facebook Only: Reactions** | ✅ |
| 3 | Dev: channel(s) → **facebook** → Apply | ✅ enabled ['facebook'] · Posts (77) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Reactions, Likes, Loves, Hahas, Wows, Sads, Angries, Others) | ✅ 77 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 77 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 77 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 77, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Reactions, Likes, Loves, Hahas, Wows, Sads, Angries, Others) | 77 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-20274`).

## Known bugs checked
- None open.
- Spotify News not present; Amazon Prime Video alternative. Facebook rows joined on Date + Text.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
