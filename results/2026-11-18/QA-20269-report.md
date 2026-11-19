# QA-20269 — Brand Content > Dev vs Prod >  Video Views Data Set > Facebook Channel

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Apple Services · **Brand:** Apple Music · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: Video Views · Channel(s): facebook
**Verdict: PASS — 3 posts matched 1:1 between Dev and Prod, 0 metric differences across 19 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Apple Music (account Apple Services) | ✅ Table View |
| 2 | Dev: data set → **Video Views** | {"ok": true, "n": 2, "idx": 0, "posts": "46"} |
| 3 | Dev: channel(s) → **facebook** → Apply | enabled ['facebook'] · Posts (3) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | 3 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['facebook'] · Posts (3) |
| 6 | Prod: Table View scrape | 3 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 3, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | 3 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-20269`.
- Dev aggregate row: `{"Engagements": "1,872", "Video Response Rate": "N/A", "Video Views": "23,505", "Organic Views": "23,505", "Paid Views": "0", "Unclassified Views": "0", "Viewers": "58,213", "Video Duration": "1m51s", "Watch Time (Minutes)": "–", "Video Views (with Cross-Posts)": "23,505"}`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Wednesday row: Apple Services / Apple Music.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
