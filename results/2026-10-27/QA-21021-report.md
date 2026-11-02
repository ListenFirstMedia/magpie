# QA-21021 — Brand Content > Dev vs Prod > Video Views Data Set > LinkedIn Channel

**Run date:** 2026-10-27 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Date range: default week (Oct. 19, 2026 – Oct. 25, 2026 on both) · Data set: Video Views · Channel(s): linkedin
**Verdict: PASS — 9 posts matched 1:1 between Dev and Prod, 0 metric differences across the compared columns (Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)); aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → University of California, Los Angeles → data set **Video Views** | ✅ |
| 4 | Dev: LinkedIn only → Apply | ✅ Posts (9) |
| 5 | Dev: Table View scrape | ✅ 9 posts + aggregate row |
| 6–10 | Prod: same selections → Table View scrape | ✅ Posts (9) |
| 11 | Join rows by post permalink and diff every shared column | ✅ matched 9, only-dev 0, only-prod 0, mismatches 0, aggregate diff none |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A11 | Dev post metrics match Prod | 9 matched posts, all compared columns identical | ✅ PASS |

## Evidence
- `compareOnce` output: devPosts 9 / prodPosts 9 / matched 9 / onlyDev 0 / onlyProd 0 / mismatchCols {} / aggDiff []. The Tuesday brand (UCLA) has LinkedIn posts, unlike yesterday's Monday brands.

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only).
