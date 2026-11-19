# QA-20279 — Brand Content > Dev vs Prod > Pinterest Only:  Basic Data Set

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Sephora**, brand **Sephora**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Sephora · **Brand:** Sephora · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: Pinterest Only: Basic · Channel(s): pinterest
**Verdict: BLOCKED — 0 posts on both Dev and Prod for this brand / data set / channel in the window**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Sephora (account Sephora) | ⚠️ Table View |
| 2 | Dev: data set → **Pinterest Only: Basic** | {"ok": true, "n": 1, "idx": 0, "posts": "0"} |
| 3 | Dev: channel(s) → **pinterest** → Apply | enabled ['pinterest'] · Posts (0) |
| 4 | Dev: Table View scrape of every row (columns: ) | 0 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['pinterest'] · Posts (0) |
| 6 | Prod: Table View scrape | 0 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 0, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics () | 0 matched posts; all compared columns identical on every matched post | ⛔ BLOCKED |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ⛔ BLOCKED |
| A3 | Aggregate (Sum) row identical | identical | ⛔ BLOCKED |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-20279`.
- Dev aggregate row: `null`

## Known bugs checked
- No open linked bug (Jira issue links checked on the run date).
- Wednesday row: Sephora / Sephora (the only Wednesday row; the case has no alternative-account note). Sephora has 0 Pinterest posts in the default week on both dev and prod, so there is nothing to compare. Nothing was created or substituted (Data Test read-only rule).

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
