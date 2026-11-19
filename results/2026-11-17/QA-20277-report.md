# QA-20277 — Brand Content > Dev vs Prod > YouTube Only: Insights & YouTube Only: Premium Data Set

**Run date:** 2026-11-17 (Tuesday → rotation row: account **Disney Ad Sales**, brand **Disney Channel**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Disney Ad Sales · **Brand:** Disney Channel · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: YouTube Only: Insights + YouTube Only: Premium · Channel(s): youtube
**Verdict: FAILED (open linked bug — policy) — APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets. Executed comparison for reference: PASS — 9 posts matched 1:1 between Dev and Prod, 0 metric differences across 20 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Disney Channel (account Disney Ad Sales) | ✅ Table View |
| 2 | Dev: data set → **YouTube Only: Insights + YouTube Only: Premium** | {"ok": true, "n": 1, "idx": 0, "posts": "9"} |
| 3 | Dev: channel(s) → **youtube** → Apply | enabled ['youtube'] · Posts (9) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 9 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['youtube'] · Posts (9) |
| 6 | Prod: Table View scrape | 9 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 9, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 9 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-20277`.
- Dev aggregate row: `{"Video Views": "74,533", "Organic Views": "–", "Paid Views": "–", "Unclassified Views": "74,533", "Video Duration": "48m20s", "YouTube Watch Time (Minutes)": "–", "Organic Watch Time (Minutes)": "–", "Paid Watch Time (Minutes)": "–", "Avg View Duration (Minutes)": "N/A", "Shares": "–", "Dislikes": "–"}`

## Known bugs checked
- OPEN linked bug(s): APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets → case FAILED by the open-bug policy regardless of the comparison outcome.
- Tuesday row: Disney Ad Sales / Disney Channel. The case covers two data sets; the report table shows YouTube Only: Insights. YouTube Only: Premium was compared separately with the same result: dev 9 / prod 9 posts, matched 9, column mismatches none, aggregate differences 0 (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Premium Views, Organic Premium Views, Paid Premium Views, Video Duration, Premium Watch Time (Minutes), Organic Premium Watch Time (Minutes), Paid Premium Watch Time (Minutes)). On prod the new QA user's default brand for this account is 'Monsters University'; Disney Channel was selected from the brand picker (brand_id 3877 on both).

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
