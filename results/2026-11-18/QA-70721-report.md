# QA-70721 — Brand Content > Dev vs Prod > Instagram Only: Action Types - Data QA

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Apple Services · **Brand:** Apple Music · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: Instagram Only: Action Types · Channel(s): instagram
**Verdict: FAILED (open linked bug — policy) — APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets. Executed comparison for reference: PASS — 23 posts matched 1:1 between Dev and Prod, 0 metric differences across 18 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Apple Music (account Apple Services) | ✅ Table View |
| 2 | Dev: data set → **Instagram Only: Action Types** | {"ok": true, "n": 1, "idx": 0, "posts": "23"} |
| 3 | Dev: channel(s) → **instagram** → Apply | enabled ['instagram'] · Posts (23) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Bio Link Clicks, Calls, Directions, Emails, Texts, Other Actions, Profile Visits, Follows) | 23 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['instagram'] · Posts (23) |
| 6 | Prod: Table View scrape | 23 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 23, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Bio Link Clicks, Calls, Directions, Emails, Texts, Other Actions, Profile Visits, Follows) | 23 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-70721`.
- Dev aggregate row: `{"Engagements": "752,048", "Bio Link Clicks": "9", "Calls": "–", "Directions": "–", "Emails": "–", "Texts": "–", "Other Actions": "–", "Profile Visits": "3,142", "Follows": "284"}`

## Known bugs checked
- OPEN linked bug(s): APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets → case FAILED by the open-bug policy regardless of the comparison outcome.
- Wednesday row: Apple Services / Apple Music.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
