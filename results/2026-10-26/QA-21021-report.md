# QA-21021 — Brand Content > Dev vs Prod >  Video Views Data Set > LinkedIn Channel

**Run date:** 2026-10-26 (Monday → rotation row: account **HBO Max → Amazon Prime Video → Condé Nast**, brand **HBO Max → Amazon Prime Video → Vogue - US**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** HBO Max → Amazon Prime Video → Condé Nast · **Brand:** HBO Max → Amazon Prime Video → Vogue - US · Date range: default week (Oct. 18, 2026 – Oct. 24, 2026 on both) · Data set: Video Views · Channel(s): linkedin
**Verdict: BLOCKED — No LinkedIn posts in the default week (Oct 18–24 2026) for any Monday-rotation brand on dev or prod: HBO Max Posts (0), Amazon Prime Video Posts (0), Vogue - US (Condé Nast) Posts (0)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Dev: Brand > Content for HBO Max → Amazon Prime Video → Vogue - US (account HBO Max → Amazon Prime Video → Condé Nast) | ✅ None posts in Table View |
| 2 | Dev: data set → **Video Views** | ✅ |
| 3 | Dev: channel(s) → **linkedin** → Apply | ✅ enabled ['linkedin'] · Posts (0) |
| 4 | Dev: Table View scrape of every row (columns: ) | ✅ None posts + aggregate row |
| 5 | Prod: same brand / data set / channel(s) | ✅ None posts in Table View |
| 6 | Prod: Table View scrape | ✅ None posts + aggregate row |
| 7 | Join rows by post permalink and diff every shared column | ✅ matched None, only-dev None, only-prod None |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Dev post metrics match Prod post metrics | Not evaluable: No LinkedIn posts in the default week (Oct 18–24 2026) for any Monday-rotation brand on dev or prod: HBO Max Posts (0), Amazon Prime Video Posts (0), Vogue - US (Condé Nast) Posts (0) | ⛔ BLOCKED |

## Evidence
- Scrape JSON for both environments retained in the session result dump (`results/2026-10-26/_devprod-results.json`, key `QA-21021`).

## Known bugs checked
- None open.
- All three Monday brands show LinkedIn → Posts (0) "There is no data available" on BOTH environments (the Condé Nast account is spelled with an accent; the brand is listed as "Vogue - US"). LinkedIn collection itself is fine: UCLA has 32 LinkedIn posts this week. Supplementary parity check on UCLA / University of California, Los Angeles, Video Views data set, LinkedIn: 9 posts matched 1:1 Dev vs Prod, 0 differences across 19 columns (aggregate Video Views 57,271, Viewers 55,919, Watch Time 11,954.71 min). Test-data gap on the rotation brands, not a Dev/Prod mismatch.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
