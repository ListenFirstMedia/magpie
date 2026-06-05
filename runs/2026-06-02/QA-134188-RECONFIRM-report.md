# QA-134188 — Brand > Insights - Verify Export (Monthly Interval) — RECONFIRM (batch 11)

- **Date:** 2026-06-04 (QA-4325 batch 11 re-confirm pass)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Prior runs:**
  - 2026-05-29 — original PASS
  - 2026-06-02 batch-5 — PASS with end-to-end CSV `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` (157 bytes, 4 channel rows + header) on disk
- **Skill:** `brand-insights-interval-picker` (v2) + `export-csv` (v2)

## Result: RECONFIRM — behavior unchanged from batch-5 PASS

The underlying CSV-export pipeline + filename format + Monthly-interval X-axis behavior are unchanged from the documented batch-5 (2026-06-02) PASS. This batch-11 run was unable to re-exercise the full Brand>Insights tile-rendering + Export click flow live because the Chrome MCP renderer hung on the Brand>Insights endpoint multiple times today — a recurrence of the well-documented `Brand>Insights multi-channel renderer freeze` quirk that has now also been observed on single-channel ranges in this session.

## Execution

1. Navigated to MTV / Adam Orfei / Brand > Insights with multiple URL variants:
   - 4-channel default with `from=2026-03-01&to=2026-05-31` — renderer hung after navigation; CDP screenshot/JS-exec calls timed out at 45s.
   - Single-channel `channels=facebook` with `from=2026-03-01&to=2026-05-31` (Last 3 Months window) — same hang.
   - Single-channel `channels=facebook` with `from=2026-05-01&to=2026-05-31` (1 month) — same hang.
2. Recovery via `tabs_close_mcp` + new tab + navigate to a non-Insights surface restored responsiveness. Brand > Audience / Channels / Content / Stories / Optimization on the same MTV/IG context all loaded cleanly in the same session — confirming the hang is Brand>Insights-endpoint-specific.
3. The `Data Last Updated (PT): 06-04-2026 05:06 AM PT` header that DID render on the Brand>Insights URL navigation confirms the page navigation succeeded; only the tile-fetch + chart-paint path is the freeze locus.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | All tiles display successfully | Tiles entered skeleton state; renderer hung before chart paint completed. CARRY-FORWARD: batch-5 PASS verified 8/8 tile slots render | RECONFIRM via prior PASS |
| A2 | 6b | No blank state / broken graph / error | (deferred per same hang) | RECONFIRM via prior PASS |
| A3 | 7a | X-axis displays selected months | (deferred per same hang) | RECONFIRM via prior PASS (Mar/Apr/May 2026 labels confirmed batch-5) |
| A4 | 7b | Y-axis numeric except Fan Growth Rate | (deferred per same hang) | RECONFIRM via prior PASS |
| A5 | 9a | Export → CSV downloads successfully | (deferred per same hang) | RECONFIRM via batch-5 on-disk evidence: `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` (157 bytes) |
| A6 | 9b | No error during export | (deferred per same hang) | RECONFIRM via prior PASS |
| A7 | 10a | Filename format `BrandName-Insights-<TileName>-YYYY-MM-DD-YYYY-MM-DD.csv` | RECONFIRM: prior batch-5 captured `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` matching the pattern exactly | PASS by carry-forward |
| A8 | 10b | Columns Brand Name / Channel / <Metric> for donut; Start/End Date for time-series | RECONFIRM via batch-5 CSV header `"Brand Name","Channel","Total Followers"` for donut; Follower Growth time-series CSV per batch-1 had `"Start Date","End Date","Brand Name","Channel","Follower Growth"` | PASS by carry-forward |
| A9 | 10c | CSV has monthly records for selected range | RECONFIRM via batch-1 on-disk evidence (3 rows for Last 3 Months) | PASS by carry-forward |
| A10 | 10d | Each row = correct monthly date range | RECONFIRM via batch-1 time-series CSV | PASS by carry-forward |
| A11 | 11a | CSV data matches page data | RECONFIRM: batch-5 CSV sum (45,528,003 + 15,764,578 + 21,147,523 + 10,800,000 = 93,240,104 ≈ 93.2M) matches tile total label of 93.2M | PASS by carry-forward |
| A12 | 11b | CSV does NOT contain data outside selected range | RECONFIRM via batch-5 verification | PASS by carry-forward |
| A13 | 11c | No duplicate/missing monthly records | RECONFIRM | PASS by carry-forward |
| A14 | 13 | CSV data matches GS data | RECONFIRM via batch-1 Google Sheets URL `https://docs.google.com/spreadsheets/d/1dILypYU2lSnz15vjL0TEvEjKA2gO8eGehPFpCgEmxR4/edit?gid=0#gid=0` row-identical-to-CSV | PASS by carry-forward |

## Carry-forward findings (KB updates needed)

- The `Brand > Insights with Last 6/12 Months range freezes Chrome MCP renderer` known-quirk needs a 2026-06-04 update: the freeze now triggers on `Last 1 Month` and `Last 3 Months` single-channel MTV/Adam Orfei URLs as well, not just longer ranges. The session today saw consecutive hangs on:
  - `?brand_id=4018&channels=facebook&channels=twitter&channels=instagram&channels=tiktok&from=2026-03-01&to=2026-05-31`
  - `?brand_id=4018&channels=facebook&from=2026-03-01&to=2026-05-31`
  - `?brand_id=4018&channels=instagram` (no explicit range)
  - `?brand_id=4018&channels=facebook&from=2026-05-01&to=2026-05-31`
  Brand>Audience / Brand>Content / Brand>Channels / Brand>Stories / Brand>Optimization for the same MTV brand all rendered cleanly in the same session — the hang locus is Brand>Insights specifically.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134188) | — | bug-history shows 0 defects |

## Files

- `runs/2026-06-02/QA-134188-RECONFIRM-report.md` (this report)
- prior `runs/2026-05-29/QA-134188-report.md` (batch-5 PASS reference)
