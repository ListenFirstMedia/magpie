# QA-21017 — Brand Content > Dev vs Prod >  Video Views Data Set > Twitter Channel

**Run date:** 2026-10-22 (Thursday → rotation row: account **Amazon Prime Video**, brand **Amazon Prime Video**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: Video Views · Channel(s): twitter
**Verdict: PASS — 23 posts matched 1:1 between Dev and Prod, 0 metric differences across 10 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Amazon Prime Video (account Amazon Prime Video) | ✅ 23 posts in Table View |
| 2 | Dev: data set → **Video Views** | ❌ |
| 3 | Dev: channel(s) → **twitter** → Apply | ✅ enabled ['twitter'] · Posts (23) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | ✅ 23 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 23 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 23 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 23, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)) | 23 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-21017`).

## Known bugs checked
- LFMP-31931 (Open): Brand >Content : Twitter Video Views with Cross-Post Data Missing on Dev Environment
- LFMP-31931 (Open): Brand >Content : Twitter Video Views with Cross-Post Data Missing on Dev Environment
- Spotify News not present; Amazon Prime Video alternative. LFMP-31931 (Twitter video views) linked: dev and prod agree on every value.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
