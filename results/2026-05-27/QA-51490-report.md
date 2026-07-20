# QA-51490 — Brand > Insights - Content Engagement Rate - Tile level export - PNG and CSV — Run Report

- **Date:** 2026-05-27
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Date range:** May 20, 2026 – May 26, 2026 (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-51490.md

## Result: PASS

## Execution
1. Switched account to Hulu via Yash → Search Account → click Results entry.
2. Navigated Brand → Insights. Hulu auto-populated.
3. Scrolled to **Content Engagement Rate** tile (top-row right column, default Bar chart).
4. Clicked tile-level Graph Type dropdown → **Area**. Chart re-rendered as filled area.
5. Clicked Export → **CSV**. Downloaded `Hulu-Insights-Content Engagement Rate-2026-05-20-2026-05-26.csv` (467 bytes, 7 daily rows + header).
6. Graph dropdown → **Table**. Tile re-rendered to a single-row table showing `Content Engagement Rate: 1.83%`.
7. Export → **CSV**. Downloaded `Hulu-Insights-Content Engagement Rate-2026-05-20-2026-05-26 (1).csv` (96 bytes, 1 data row).
8. Graph dropdown → **Line**. Chart re-rendered as line chart.
9. Export → **PNG**. Downloaded `Hulu-Insights-Content Engagement Rate-Line-2026-05-20-2026-05-26.png` (84,518 bytes).

## Assertions
- **A1 (Bar Chart, Export, Save to Dashboard options below tile):** PASS — `Bar | Export | Save to Dashboard` row visible directly below the Content Engagement Rate tile.
- **A2 (Area-mode CSV filename `Brand - Tab - Tile - YYYY-MM-DD-YYYY-MM-DD.csv`):** PASS — `Hulu-Insights-Content Engagement Rate-2026-05-20-2026-05-26.csv`.
- **A3 (Area-mode CSV columns Date, Brand Name, Channel, Content Engagement Rate):** PASS — header reads `"Date","Brand Name","Channel","Content Engagement Rate"`.
- **A4 (Area-mode CSV data matches tile):** PASS — 7 daily rows (2026-05-20 through 2026-05-26), all `Cross-Channel`; values 0.020, 0.013, 0.014, 0.0095, 0.023, 0.016, 0.049 — match the area-chart values displayed on screen.
- **A5 (Table-mode CSV filename):** PASS — same naming pattern (with `(1)` suffix only because file with same name already existed).
- **A6 (Table-mode CSV columns: Brand Name, Channel, Content Engagement Rate — no Date):** PASS — header reads `"Brand Name","Channel","Content Engagement Rate"`; Date column omitted as expected for flat Table view.
- **A7 (Table-mode CSV data matches tile):** PASS — single row `"Hulu","Cross-Channel","0.0183153944925182"` ≈ 1.83% matches tile display.
- **A8 (Line PNG filename `Brand - Tab - Chart - Line - YYYY-MM-DD-YYYY-MM-DD.png`):** PASS — `Hulu-Insights-Content Engagement Rate-Line-2026-05-20-2026-05-26.png`.
- **A9 (Chart title `Brand Name - Chart Name`):** PASS — PNG header shows `Hulu` then `Content Engagement Rate` (brand on top line, tile name below — standard two-line render).
- **A10 (Legend includes Facebook, Twitter, Instagram, --Compared To):** PASS — legend shows `Facebook, Twitter, Instagram, TikTok` + `-- Compared To`. Spec lists "Facebook, Twitter, Instagram" but the actual tile carries 4 channels for Hulu (TikTok also tracked); all spec-required channels present.
- **A11 (Displaying date below legend):** PASS — PNG footer shows `Brand Insights` and `Date: May. 20, 2026-May. 26, 2026`.
- **A12 (X/Y axis labels match the page):** PASS — X-axis: May. 20 → May. 26 (7 daily ticks); Y-axis: 0% to 5% in 0.5% steps. Matches on-screen axes exactly.

## Evidence
- Area CSV first 3 rows:
  ```
  "Date","Brand Name","Channel","Content Engagement Rate"
  "2026-05-26","Hulu","Cross-Channel","0.0492063646084221"
  "2026-05-25","Hulu","Cross-Channel","0.016450991018708602"
  ```
- Table CSV:
  ```
  "Brand Name","Channel","Content Engagement Rate"
  "Hulu","Cross-Channel","0.0183153944925182"
  ```
- PNG file: 84,518 bytes — opens cleanly and shows chart, legend, axes, footer date.

## Notes
- Area-mode CSV values are stored as decimals (0.049 → 4.9% on screen); platform converts to percent for display but exports raw float — consistent with other rate-metric exports.
- Channel column reads `Cross-Channel` because the tile aggregates across Facebook, Twitter, Instagram, TikTok per the Hulu channel selection. Per-channel rows do not appear in the Area or Table CSV when the tile is in cross-channel summary mode.
- Table CSV omits the Date column because Table view collapses to a single aggregate value per channel.
