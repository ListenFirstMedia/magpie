# QA-68228 — Brand > Stories - Engaged User Rate - Posts - Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Hulu**
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670, account default) · Surface: Brand > Stories · Channel: Instagram (only channel on Stories) · Date range: default week Oct. 12, 2026 – Oct. 18, 2026
**Verdict: PASS — 38/38 stories satisfy Engaged User Rate = Engagements ÷ Reach × 100 within ±0.01 pp of the 2-decimal display (0 failures, 0 skipped)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Brand → Stories | ✅ `#explore/brand/stories`, landed in "Data Visualization" (chart) mode → clicked **Data Visualization** to return to the story list: **Stories (38)** |
| 2 | Brand Hulu | ✅ account default (brand_id 5670) |
| 3 | Insights data set → Table View → scrape Engagements and Reach per story | ✅ 38 rows; aggregate Engagements 1,254, Impressions 298,213, Reach N/A, Taps Forward 212,024 |
| 4 | Data set → **Rates** → Table View → scrape Engaged User Rate per story | ✅ columns: Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate; rows joined to step 3 by Date + Text |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Engaged User Rate == Engagements / Reach × 100 for every story | 38/38 within ±0.01 pp. Samples: #1 157 / 22,084 → 0.711 vs **0.71%**; #2 103 / 7,195 → 1.432 vs **1.43%**; #8 56 / 13,753 → 0.407 vs **0.41%**; #37 2 / 286 → 0.699 vs **0.70%**; #38 0 / 5,336 → 0.000 vs **0.00%** | ✅ PASS |

## Evidence
- Per-story table (rank, engagements, reach, displayed rate, computed rate, ok) retained in the session result (`ctx._stories68228`, 38 rows, all `ok:true`).

## Known bugs checked
- None open on the case.

## Notes (mechanics for the skill)
- Brand > Stories may open in Data Visualization mode; the story list (and the Table View button) appears after clicking the "Data Visualization" toggle text. Table View is the same `table.lfm-table` with a `Rank` header as Brand > Content, so the grid-math scraper applies unchanged. Stories have no permalink column — join rows on Date + Text.

## Bugs filed
None.

## Cleanup
None (read-only).
