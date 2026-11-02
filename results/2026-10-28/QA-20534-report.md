# QA-20534 — Brand Content > Dev vs Prod > Public Data Set > Instagram Channel

**Run date:** 2026-10-28 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Apple Services (account_id=409) · **Brand:** Apple Music (brand_id=31783) · Date range: default week (Oct. 20, 2026 – Oct. 26, 2026 on both) · Data set: Public · Channel(s): instagram
**Verdict: PASS — 23 posts matched 1:1 between Dev and Prod, 0 metric differences across the compared columns (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate); aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Apple Music (account Apple Services) | ✅ |
| 3 | Dev: data set → **Public** | ✅ |
| 4 | Dev: Instagram only → Apply | ✅ Posts (23) |
| 5 | Dev: Table View scrape of every row | ✅ 23 posts + aggregate row |
| 6–9 | Prod: same account / brand / data set / channel → Table View scrape | ✅ Posts (23), 23 posts + aggregate row |
| 10 | Join rows by post permalink and diff every shared column | ✅ matched 23, only-dev 0, only-prod 0, mismatches 0, aggregate diff none |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A10 | Dev post metrics (Engagements, Response Rate, Reactions, Comments, Shares) match Prod | 23 matched posts, all compared columns identical | ✅ PASS |

## Evidence
- `compareOnce` output: devPosts 23 / prodPosts 23 / matched 23 / onlyDev 0 / onlyProd 0 / mismatchCols {} / aggDiff [] (`results/2026-10-28/_devprod-results.json`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only).
