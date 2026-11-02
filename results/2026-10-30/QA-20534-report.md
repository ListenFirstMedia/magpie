# QA-20534 — Brand Content > Dev vs Prod > Public Data Set > Instagram Channel

**Run date:** 2026-10-30 (Friday → rotation row 1: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Date range: default week (Oct. 22, 2026 – Oct. 28, 2026 on both) · Data set: Public · Channel(s): instagram
**Verdict: PASS — 59 posts matched 1:1 between Dev and Prod, 0 metric differences across the compared columns (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate); aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Hulu (account Hulu) | ✅ |
| 3 | Dev: data set → **Public** | ✅ |
| 4 | Dev: Instagram only → Apply | ✅ Posts (59) |
| 5 | Dev: Table View scrape of every row | ✅ 59 posts + aggregate row |
| 6–9 | Prod: same account / brand / data set / channel → Table View scrape | ✅ Posts (59), 59 posts + aggregate row |
| 10 | Join rows by post permalink and diff every shared column | ✅ matched 59, only-dev 0, only-prod 0, mismatches 0, aggregate diff none |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A10 | Dev post metrics (Engagements, Response Rate, Reactions, Comments, Shares) match Prod | 59 matched posts, all compared columns identical | ✅ PASS |

## Evidence
- `compareOnce` output: devPosts 59 / prodPosts 59 / matched 59 / onlyDev 0 / onlyProd 0 / mismatchCols {} / aggDiff [] (`results/2026-10-30/_devprod-results.json`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only).
