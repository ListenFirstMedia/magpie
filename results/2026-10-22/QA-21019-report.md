# QA-21019 — Brand Content > Dev vs Prod >  Video Views Data Set > Youtube Channel

**Run date:** 2026-10-22 (Thursday → rotation row: account **Disney Ad Sales**, brand **Disney Channel**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Disney Ad Sales · **Brand:** Disney Channel · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: YouTube Only: Insights · Channel(s): youtube
**Verdict: PASS — 10 posts matched 1:1 between Dev and Prod, 0 metric differences across 11 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Disney Channel (account Disney Ad Sales) | ✅ 10 posts in Table View |
| 2 | Dev: data set → **YouTube Only: Insights** | ✅ |
| 3 | Dev: channel(s) → **youtube** → Apply | ✅ enabled ['youtube'] · Posts (10) |
| 4 | Dev: Table View scrape of every row (columns: Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | ✅ 10 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 10 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 10 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 10, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 10 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-21019`).

## Known bugs checked
- APPS-60871 (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)
- Thursday rotation: Disney Ad Sales / Disney Channel. YouTube is greyed under the generic Video Views set; YouTube Only: Insights used on both sides (as on 2026-10-20).

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
