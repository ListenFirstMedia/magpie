# QA-20277 — Brand Content > Dev vs Prod > YouTube Only: Insights & YouTube Only: Premium Data Set

**Run date:** 2026-10-22 (Thursday → rotation row: account **Amazon Prime Video**, brand **Amazon Prime Video**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: YouTube Only: Insights + YouTube Only: Premium · Channel(s): youtube
**Verdict: PASS — 51 posts matched 1:1 between Dev and Prod, 0 metric differences across 17 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Amazon Prime Video (account Amazon Prime Video) | ✅ 51 posts in Table View |
| 2 | Dev: data set → **YouTube Only: Insights + YouTube Only: Premium** | ✅ |
| 3 | Dev: channel(s) → **youtube** → Apply | ✅ enabled ['youtube'] · Posts (51) |
| 4 | Dev: Table View scrape of every row (columns: Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes, Premium Views, Organic Premium Views, Paid Premium Views, Premium Watch Time (Minutes), Organic Premium Watch Time (Minutes), Paid Premium Watch Time (Minutes)) | ✅ 51 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 51 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 51 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 51, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes, Premium Views, Organic Premium Views, Paid Premium Views, Premium Watch Time (Minutes), Organic Premium Watch Time (Minutes), Paid Premium Watch Time (Minutes)) | 51 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-20277`).

## Known bugs checked
- APPS-60871 (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)
- Thursday rotation names account Viacom / brand Viacom: the Viacom brand (brand_id 6725) has 0 YouTube posts in the week on BOTH environments (consistent, nothing to compare), so the case ran on the alternative account Amazon Prime Video (51 videos). Both data sets compared (Insights 11 columns, Premium 6 columns), 51/51 identical on each.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
