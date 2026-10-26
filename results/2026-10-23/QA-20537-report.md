# QA-20537 — Brand Content > Dev vs Prod > Basic Data Set > LinkedIn Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu → Ralph Lauren**, brand **Hulu → Ralph Lauren**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Hulu → Ralph Lauren · **Brand:** Hulu → Ralph Lauren · Date range: default week (Oct. 15, 2026 – Oct. 21, 2026 on both) · Data set: Public · Channel(s): linkedin
**Verdict: BLOCKED — No LinkedIn posts in the default week (Oct 15–21 2026) for either Friday brand: Hulu Posts (0) on dev and prod; Ralph Lauren Posts (0) on prod (dev brand pages hung on "Loading")**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Hulu → Ralph Lauren (account Hulu → Ralph Lauren) | ✅ None posts in Table View |
| 2 | Dev: data set → **Public** | ❌ |
| 3 | Dev: channel(s) → **linkedin** → Apply | ✅ enabled None · Posts (None) |
| 4 | Dev: Table View scrape of every row (columns: ) | ✅ None posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ 0 posts in Table View |
| 6 | Prod: Table View scrape | ✅ None posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched None, only-dev None, only-prod None |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics | Not evaluable: No LinkedIn posts in the default week (Oct 15–21 2026) for either Friday brand: Hulu Posts (0) on dev and prod; Ralph Lauren Posts (0) on prod (dev brand pages hung on "Loading") | ⛔ BLOCKED |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-23/_devprod-results.json`, key `QA-20537`).

## Known bugs checked
- None open.
- Hulu: LinkedIn → Posts (0) "There is no data available" on BOTH environments. Ralph Lauren: prod LinkedIn → Posts (0) as well; dev Ralph Lauren Content/Insights never finished loading (2 reloads + UI re-navigation, ~6 min). Test-data gap, not a Dev/Prod mismatch.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
