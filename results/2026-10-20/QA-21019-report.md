# QA-21019 — Brand Content > Dev vs Prod >  Video Views Data Set > Youtube Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: YouTube Only: Insights · Channel(s): youtube
**Verdict: PASS — 2 posts matched 1:1 between Dev and Prod, 0 metric differences across 11 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ 2 posts in Table View |
| 2 | Dev: data set → **YouTube Only: Insights** | ✅ |
| 3 | Dev: channel(s) → **youtube** → Apply | ✅ enabled ['youtube'] · Posts (2) |
| 4 | Dev: Table View scrape of every row (columns: Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | ✅ 2 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 2 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 2 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 2, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 2 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Video Views | Organic Views | Paid Views | Unclassified Views | Video Duration | YouTube Watch Time (Minutes) | Organic Watch Time (Minutes) | Paid Watch Time (Minutes) | Avg View Duration (Minutes) | Shares | Dislikes |
|---|---|---|---|---|---|---|---|---|---|---|
| 930 | 814 | – | 116 | 2m25s | 149.55 | 149.55 | – | N/A | 3 | 1 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-21019`).

## Known bugs checked
- APPS-60871 (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)
- YouTube is greyed out under the generic Video Views data set on both environments (first attempt compared tiktok-vs-twitter by mistake and was discarded); the YouTube Only: Insights data set, named in the spec's dev step, was used on both sides.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
