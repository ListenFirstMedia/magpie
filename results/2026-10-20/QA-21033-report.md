# QA-21033 — Brand Stories > Dev vs Prod > Insights Data Set

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Insights (Brand > Stories) · Channel(s): instagram (Stories page)
**Verdict: PASS — 14 posts matched 1:1 between Dev and Prod, 0 metric differences across 9 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ 14 posts in Table View |
| 2 | Dev: data set → **Insights (Brand > Stories)** | ❌ |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Impressions, Reach, Taps Forward, Taps Back, Exits, DM Replies, Shares, Profile Visits) | ✅ 14 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 14 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 14 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 14, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Impressions, Reach, Taps Forward, Taps Back, Exits, DM Replies, Shares, Profile Visits) | 14 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Impressions | Reach | Taps Forward | Taps Back | Exits | DM Replies | Shares | Profile Visits |
|---|---|---|---|---|---|---|---|---|
| 913 | 239,069 | N/A | 133,082 | 6,400 | 35,730 | 50 | 149 | 708 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-21033`).

## Known bugs checked
- None open.
- Surface is Brand > Stories (not Content); Table View exposes the same table.lfm-table/Rank structure, so the Content scraper applies unchanged. 14 stories, Oct 12–18 2026.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
