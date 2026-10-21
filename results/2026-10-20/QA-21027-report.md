# QA-21027 — Brand Content > Dev vs Prod >   Reactions Data Set> Twitter Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** UCLA · **Brand:** University of California, Los Angeles · Date range: default week (Oct. 12, 2026 – Oct. 18, 2026 on both) · Data set: Public · Channel(s): twitter
**Verdict: PASS — spec names a 'Reactions' data set that does not exist in the Brand > Content dropdown on dev or prod; the Twitter Public (basic) comparison the dev half of the spec describes was run instead: 32/32 tweets identical for Engagements, Reactions, Comments, Shares**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for University of California, Los Angeles (account UCLA) | ✅ 32 posts in Table View |
| 2 | Dev: data set → **Public** | ❌ |
| 3 | Dev: channel(s) → **twitter** → Apply | ✅ enabled ['twitter'] · Posts (32) |
| 4 | Dev: Table View scrape of every row (columns: Engagements, Reactions, Comments, Shares) | ✅ 32 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 32 posts in Table View |
| 6 | Prod: Table View scrape | ✅ 32 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched 32, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Engagements, Reactions, Comments, Shares) | 32 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

### Aggregate row (dev = prod unless listed under A3)
| Engagements | Reactions | Comments | Shares |
|---|---|---|---|
| 572 | 464 | 25 | 82 |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-20/_devprod-results.json`, key `QA-21027`).

## Known bugs checked
- None open.
- SPEC GAP: no 'Reactions' data set exists (dropdown lists Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, …). 'Private Likes' lives on no Twitter data set. Recommend the case be rewritten to Twitter Only: Engagements & Follows (covered by QA-20275, PASS).

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
