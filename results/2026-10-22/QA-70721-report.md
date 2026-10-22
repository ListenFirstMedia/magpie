# QA-70721 — Brand Content > Dev vs Prod > Instagram Only: Action Types - Data QA

**Run date:** 2026-10-22 (Thursday → rotation row: account **FX Networks**, brand **FX Networks Composite**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** FX Networks · **Brand:** FX Networks Composite · Date range: default week (Oct. 14, 2026 – Oct. 20, 2026 on both) · Data set: Instagram Only: Action Types · Channel(s): instagram
**Verdict: PASS — 43 posts matched 1:1 between Dev and Prod, 0 metric differences across 9 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for FX Networks Composite (account FX Networks) | ✅ 43 posts in Table View |
| 2 | Dev: data set → **Instagram Only: Action Types** | ✅ |
| 3 | Dev: channel(s) → **instagram** → Apply | ✅ enabled ['instagram'] · Posts (43) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Bio Link Clicks, Calls, Directions, Emails, Texts, Other Actions, Profile Visits, Follows) | ✅ 43 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 43 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 43 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 43, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Bio Link Clicks, Calls, Directions, Emails, Texts, Other Actions, Profile Visits, Follows) | 43 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-22/_devprod-results.json`, key `QA-70721`).

## Known bugs checked
- APPS-60871 (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)
- Spec brand 'FX Networks' not present; 'FX Networks Composite' used on both environments (see QA-20276).

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
