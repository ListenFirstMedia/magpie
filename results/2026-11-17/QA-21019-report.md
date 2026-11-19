# QA-21019 — Brand Content > Dev vs Prod >  Video Views Data Set > Youtube Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **Amazon Prime Video**, brand **Amazon Prime Video**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: YouTube Only: Insights · Channel(s): youtube
**Verdict: FAILED (open linked bug — policy) — APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets. Executed comparison for reference: PASS — 48 posts matched 1:1 between Dev and Prod, 0 metric differences across 20 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Amazon Prime Video (account Amazon Prime Video) | ✅ Table View |
| 2 | Dev: data set → **YouTube Only: Insights** | {"ok": true, "n": 1, "idx": 0, "posts": "48"} |
| 3 | Dev: channel(s) → **youtube** → Apply | enabled ['youtube'] · Posts (48) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 48 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['youtube'] · Posts (48) |
| 6 | Prod: Table View scrape | 48 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 48, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Organic Views, Paid Views, Unclassified Views, Video Duration, YouTube Watch Time (Minutes), Organic Watch Time (Minutes), Paid Watch Time (Minutes), Avg View Duration (Minutes), Shares, Dislikes) | 48 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-21019`.
- Dev aggregate row: `{"Video Views": "10,382,245", "Organic Views": "–", "Paid Views": "–", "Unclassified Views": "10,382,245", "Video Duration": "1h51m46s", "YouTube Watch Time (Minutes)": "–", "Organic Watch Time (Minutes)": "–", "Paid Watch Time (Minutes)": "–", "Avg View Duration (Minutes)": "N/A", "Shares": "–", "Dislikes": "–"}`

## Known bugs checked
- OPEN linked bug(s): APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets → case FAILED by the open-bug policy regardless of the comparison outcome.
- Both Tuesday rows (UCLA / University of California, Los Angeles and Wasserman / Gatorade) have 0 YouTube posts in the default week on dev and prod; ran on Amazon Prime Video per the case note 'Also use Amazon Prime Video on alternative days'. YouTube is greyed out under the generic Video Views data set, so the YouTube video-view metrics were compared under 'YouTube Only: Insights', as in earlier runs.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
