# QA-20278 — Brand Content > Dev vs Prod > YouTube Only: Cards  Data Set

**Run date:** 2026-11-18 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context
**Account:** Apple Services · **Brand:** Apple Music · Date range: default week (Nov. 10, 2026 - Nov. 16, 2026) · Data set: YouTube Only: Cards · Channel(s): youtube
**Verdict: FAILED (open linked bug — policy) — APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets. Executed comparison for reference: PASS — 2 posts matched 1:1 between Dev and Prod, 0 metric differences across 17 compared columns; aggregate row identical**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for Apple Music (account Apple Services) | ✅ Table View |
| 2 | Dev: data set → **YouTube Only: Cards** | {"ok": true, "n": 1, "idx": 0, "posts": "2"} |
| 3 | Dev: channel(s) → **youtube** → Apply | enabled ['youtube'] · Posts (2) |
| 4 | Dev: Table View scrape of every row (columns: Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Video Duration, Card Impressions, Card Clicks, Card CTR, Teaser Impressions, Teaser Clicks, Teaser CTR) | 2 posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | enabled ['youtube'] · Posts (2) |
| 6 | Prod: Table View scrape | 2 posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | matched 2, only-dev 0, only-prod 0 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics (Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Video Views, Video Duration, Card Impressions, Card Clicks, Card CTR, Teaser Impressions, Teaser Clicks, Teaser CTR) | 2 matched posts; all compared columns identical on every matched post | ✅ PASS |
| A2 | Same post set on both environments | only-dev 0, only-prod 0 | ✅ PASS |
| A3 | Aggregate (Sum) row identical | identical | ✅ PASS |

## Evidence
- Scrape summary for both environments: `results/2026-11-18/_devprod-results.json`, key `QA-20278`.
- Dev aggregate row: `{"Video Views": "28,506", "Video Duration": "59m56s", "Card Impressions": "0", "Card Clicks": "0", "Card CTR": "N/A", "Teaser Impressions": "0", "Teaser Clicks": "0", "Teaser CTR": "N/A"}`

## Known bugs checked
- OPEN linked bug(s): APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets → case FAILED by the open-bug policy regardless of the comparison outcome.
- Wednesday row: Apple Services / Apple Music.

## Bugs filed
None.

## Cleanup
None (read-only on both environments — Data Test read-only rule).
