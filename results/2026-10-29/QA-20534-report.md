# QA-20534 — Brand Content > Dev vs Prod > Public Data Set > Instagram Channel

**Run date:** 2026-10-29 (Thursday → rotation row 2: account **Sony Pictures**, brand **Sony Pictures Television**; row 1 brand "Spotify News" does not exist on the Spotify account)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Sony Pictures (account_id=51) · **Brand:** Sony Pictures Television (brand_id=129863) · Date range: default week (Oct. 21, 2026 – Oct. 27, 2026 on both) · Data set: Public · Channel(s): instagram
**Verdict: PASS — 8 posts matched 1:1 between Dev and Prod, 0 metric differences across the compared columns (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate); aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Sony Pictures Television (account Sony Pictures) | ✅ |
| 3 | Dev: data set → **Public** | ✅ |
| 4 | Dev: Instagram only → Apply | ✅ Posts (8) |
| 5 | Dev: Table View scrape of every row | ✅ 8 posts + aggregate row |
| 6–9 | Prod: same account / brand / data set / channel → Table View scrape | ✅ Posts (8), 8 posts + aggregate row |
| 10 | Join rows by post permalink and diff every shared column | ✅ matched 8, only-dev 0, only-prod 0, mismatches 0, aggregate diff none |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A10 | Dev post metrics (Engagements, Response Rate, Reactions, Comments, Shares) match Prod | 8 matched posts, all compared columns identical | ✅ PASS |

## Evidence
- `compareOnce` output: devPosts 8 / prodPosts 8 / matched 8 / onlyDev 0 / onlyProd 0 / mismatchCols {} / aggDiff [] (`results/2026-10-29/_devprod-results.json`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only).
