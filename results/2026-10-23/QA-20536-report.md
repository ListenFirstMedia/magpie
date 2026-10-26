# QA-20536 — Brand Content > Dev vs Prod > Basic Data Set > TikTok Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu · **Brand:** Hulu · Date range: default week (Oct. 15, 2026 – Oct. 21, 2026 on both) · Data set: (page default: Public) · Channel(s): tiktok
**Verdict: PASS — 43 posts matched 1:1 between Dev and Prod, 0 metric differences across 7 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Hulu (account Hulu) | ✅ 43 posts in Table View |
| 3 | Dev: channel(s) → **tiktok** → Apply | ✅ enabled ['tiktok'] · Posts (43) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | ✅ 43 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 43 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 43 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 43, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate) | 43 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Reactions | Comments | Shares | Response Rate | Video Views | Video Response Rate |
|---|---|---|---|---|---|---|
| 291,835 | 276,296 | 1,146 | 14,393 | N/A | 7,229,323 | N/A |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-23/_devprod-results.json`, key `QA-20536`).

## Known bugs checked
- None open.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
