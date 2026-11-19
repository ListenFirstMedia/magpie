# QA-21020 — Brand Content > Dev vs Prod >  Video Views Data Set > TikTok Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Video Views · Channel(s): tiktok
**Verdict: PASS — 6 posts matched 1:1 between Dev and Prod, 0 metric differences across 19 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ Table View |
| 2 | Dev: data set → **Video Views** | {"ok": true, "n": 2, "idx": 0, "posts": "7"} |
| 3 | Dev: channel(s) → **tiktok** → Apply | enabled ['tiktok'] · Posts (6) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | 6 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['tiktok'] · Posts (6) |
| 6 | Prod: Table View scrape | 6 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 6, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | 6 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-21020`.
- Dev aggregate row: `{"Engagements": "818", "Video Response Rate": "N/A", "Video Views": "9,970", "Organic Views": "–", "Paid Views": "–", "Unclassified Views": "9,970", "Viewers": "–", "Video Duration": "5m24s", "Watch Time (Minutes)": "–", "Video Views (with Cross-Posts)": "9,970"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- No deviations from the case.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
