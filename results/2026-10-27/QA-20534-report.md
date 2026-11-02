# QA-20534 — Brand Content > Dev vs Prod > Public Data Set > Instagram Channel

**Run date:** 2026-10-27 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Date range: default week (Oct. 19, 2026 – Oct. 25, 2026 on both) · Data set: Public · Channel(s): instagram
**Verdict: PASS — 11 posts matched 1:1 between Dev and Prod, 0 metric differences across the compared columns (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate); aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → University of California, Los Angeles (account UCLA) | ✅ |
| 3 | Dev: data set → **Public** | ✅ |
| 4 | Dev: Instagram only → Apply | ✅ Posts (11) |
| 5 | Dev: Table View scrape of every row | ✅ 11 posts + aggregate row |
| 6–9 | Prod: same account / brand / data set / channel → Table View scrape | ✅ Posts (11), 11 posts + aggregate row |
| 10 | Join rows by post permalink and diff every shared column | ✅ matched 11, only-dev 0, only-prod 0, mismatches 0, aggregate diff none |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A10 | Dev post metrics (Engagements, Response Rate, Reactions, Comments, Shares) match Prod | 11 matched posts, all compared columns identical | ✅ PASS |

## Evidence
- `compareOnce` output: devPosts 11 / prodPosts 11 / matched 11 / onlyDev 0 / onlyProd 0 / mismatchCols {} / aggDiff [] (`results/2026-10-27/_devprod-results.json`). The Playwright context was recycled later in the session, so the per-column dump was not retained.

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only).
