# QA-20272 — Brand Content > Dev vs Prod > Engagements Breakdowns Data Set > Twitter Channel

**Run date:** 2026-11-17 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Nov. 09, 2026 - Nov. 15, 2026) · Data set: Engagements Breakdown · Channel(s): twitter
**Verdict: FAILED (open linked bug — policy) — APPS-62582 [Code Review] Brand > Content – Twitter Reactions in Engagements Breakdown Dataset Are Not Equal. Executed comparison for reference: PASS — 33 posts matched 1:1 between Dev and Prod, 0 metric differences across 21 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ Table View |
| 2 | Dev: data set → **Engagements Breakdown** | {"ok": true, "n": 1, "idx": 0, "posts": "33"} |
| 3 | Dev: channel(s) → **twitter** → Apply | enabled ['twitter'] · Posts (33) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares) | 33 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['twitter'] · Posts (33) |
| 6 | Prod: Table View scrape | 33 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 33, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares) | 33 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-17/_devprod-results.json`, key `QA-20272`.
- Dev aggregate row: `{"Engagements": "589", "Organic Engagements": "589", "Paid Engagements": "–", "Reactions": "498", "Organic Reactions": "498", "Paid Reactions": "–", "Comments": "13", "Organic Comments": "13", "Paid Comments": "–", "Shares": "78", "Organic Shares": "78", "Paid Shares": "–"}`

## Known bugs checked
- OPEN linked bug(s): APPS-62582 [Code Review] Brand > Content – Twitter Reactions in Engagements Breakdown Dataset Are Not Equal → case FAILED by the open-bug policy regardless of the comparison outcome.
- No deviations from the case.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
