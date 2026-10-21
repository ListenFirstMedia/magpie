# QA-20277 — Brand Content > Dev vs Prod > YouTube Only: Insights & YouTube Only: Premium Data Set

**Run date:** 2026-10-20 (Tuesday → rotation row: account **Disney Ad Sales**, brand **Disney Channel**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Disney Ad Sales · **Brand:** Disney Channel · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: YouTube Only: Insights + YouTube Only: Premium · Channel(s): youtube
**Verdict: PASS — 10 posts matched 1:1 between Dev and Prod, 0 metric differences across 17 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Disney Channel (account Disney Ad Sales) | ✅ 10 posts in Table View |
| 2 | Dev: data set → **YouTube Only: Insights + YouTube Only: Premium** | ✅ |
| 3 | Dev: channel(s) → **youtube** → Apply | ✅ enabled ['youtube'] · Posts (10) |
| 4 | Dev: Table View scrape of every row (columns: Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes, Premium Views, Organic Premium Views, Paid Premium Views, Premium Watch Time (Minutes), Organic Premium Watch Time (Minutes), Paid Premium Watch Time (Minutes)) | ✅ 10 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 10 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 10 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 10, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes, Premium Views, Organic Premium Views, Paid Premium Views, Premium Watch Time (Minutes), Organic Premium Watch Time (Minutes), Paid Premium Watch Time (Minutes)) | 10 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Video Views | Organic Views | Paid Views | Unclassified Views | Video Duration | YouTube Watch Time (Minutes) | Organic Watch Time (Minutes) | Paid Watch Time (Minutes) | Avg View Duration (Minutes) | Shares | Dislikes | Premium Views | Organic Premium Views | Paid Premium Views | Premium Watch Time (Minutes) | Organic Premium Watch Time (Minutes) | Paid Premium Watch Time (Minutes) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 107,545 | – | – | 107,545 | 22m33s | – |  |  |  | – | – | – |  |  | – |  |  |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-20277`).

## Known bugs checked
- APPS-60871 (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)
- Both data sets compared (Insights: 11 columns, Premium: 7 columns), 10/10 videos identical on each. Organic/Paid views, watch time, shares, dislikes and all Premium metrics render '–' on BOTH environments for every video (APPS-60871 en-dash bug is linked) — parity holds, the en-dash itself is the open bug.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
