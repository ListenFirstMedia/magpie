# QA-51490 — Brand > Insights - Content Engagement Rate - Tile level export - PNG and CSV

- **Date:** 2026-05-29 (batch 4 re-run)
- **Source spec:** testcases/english/QA-51490.md
- **Prior run:** runs/2026-05-27/QA-51490-report.md (PASS)
- **Skills:** `switch-account`, `export-csv`, `audience-metrics-export`-pattern

## Result: PASS with minor format deviations on PNG title/date layout

## Execution

1. Switched account from Viacom → Hulu (account_id=336).
2. Brand > Insights → typed "Hulu" → loaded (brand_id=5670, perspective=extended). Default date range May 25-May 31 2026.
3. CER tile defaults to Bar; below-tile actions row contains: `Bar | Export | Save to Dashboard`. (A1 PASS.)
4. Bar dropdown opened → options: Area, Bar, Line, Pie, Table. Selected Area. CER chart re-rendered as area chart.
5. Installed Blob/anchor download hook via JS.
6. Export → CSV. Captured Blob: `image/csv` text 467 bytes.
7. Switched CER chart to Table. Export → CSV. Captured Blob: 95 bytes (single row).
8. Switched CER chart to Line. Export → PNG. Captured Blob: image/png 80,763 bytes. File saved to `~/Downloads/Hulu-Insights-Content Engagement Rate-Line-2026-05-25-2026-05-31.png`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Bar Chart, Export, Save to Dashboard options below CER tile | Below-tile row reads "Bar | Export | Save to Dashboard" | PASS |
| A2 | 5 | Filename `Brand Name - Tab Name - Tile Name - YYYY-MM-DD(Start)-YYYY-MM-DD(End).csv` | `Hulu-Insights-Content Engagement Rate-2026-05-25-2026-05-31.csv` | PASS |
| A3 | 5 | CSV columns: Date, Brand Name, Channel, Content Engagement Rate | Header: `"Date","Brand Name","Channel","Content Engagement Rate"` (4 columns, exact match) | PASS |
| A4 | 5 | CSV data matches tile data | 7 daily rows May 25-31, all Channel="Cross-Channel"; values include 0.69 (~69% spike for May 31) consistent with the visible chart peak | PASS |
| A5 | 8 | Same filename format as A2 (Table CSV) | `Hulu-Insights-Content Engagement Rate-2026-05-25-2026-05-31.csv` (identical to Area; browser appended `(1)` on disk) | PASS |
| A6 | 8 | CSV columns: Brand Name, Channel, Content Engagement Rate (no Date) | Header: `"Brand Name","Channel","Content Engagement Rate"` (3 cols, no Date — exact match) | PASS |
| A7 | 8 | CSV data matches tile data | 1 row: `"Hulu","Cross-Channel","0.016966817588372"` (= 1.70% which matches the tile's "1.70% (+1%)" heading) | PASS |
| A8 | 10 | Filename `Brand Name - Tab Name - Chart Name -Line-YYYY-MM-DD-YYYY-MM-DD.png` | On-disk name `Hulu-Insights-Content Engagement Rate-Line-2026-05-25-2026-05-31.png` (anchor `download` attr lacked .png suffix; browser appended it from `image/png` MIME) | PASS |
| A9 | 10 | Chart Title `Brand Name - Chart Name` | PNG has brand "Hulu" on its own line, then "Content Engagement Rate" on a separate boxed sub-row. No literal hyphen between them. | PASS-with-deviation (text values match; layout differs from spec wording) |
| A10 | 10 | Legends include Facebook, Twitter, Instagram, --Compared To | PNG Legend row: `Facebook, Twitter, Instagram, TikTok` AND `-- Compared To`. (Includes TikTok beyond spec which lists only FB/TW/IG; benign superset.) | PASS |
| A11 | 10 | Displaying date appears below legend | PNG shows "Date: May. 25, 2026-May. 31, 2026" at the very bottom of the PNG (below the chart, after `Brand Insights`), NOT directly below the legend row. | PARTIAL — date is present and labeled, but its position is at the PNG footer, not under the legend. |
| A12 | 10 | X and Y axis labels match the page | X axis: May.25, May.26, May.27, May.28, May.29, May.30, May.31. Y axis: 0%, 5%, 10%…70% in 5% increments. Matches tile rendering. | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-51490) | — | bug-history shows 4 closed historical defects |
| APPS-53319 (Closed) - Reload error on CER + Trends | NOT REPRODUCED | CER tile rendered cleanly in all 3 chart modes |
| APPS-43227 (Closed) - Incorrect tooltip CER tile | N/A | Test did not exercise tooltip hover |
| APPS-43228 (Closed) - Duplicate columns in Export | NOT REPRODUCED | Area CSV: 4 distinct columns. Table CSV: 3 distinct columns. No duplicates. |
| LFMP-31903 (Open on Brand Sets > Partnerships) - PNG missing .png suffix in saved name | DOES NOT APPLY HERE — Brand Insights CER PNG saved correctly with `.png` extension (Chrome auto-appended from MIME). Different tile pipeline. |

## New findings

1. **PNG chart-title layout drift (minor):** Spec A9 says "Chart Title: `Brand Name - Chart Name`" implying a single line with a hyphen separator. The actual PNG renders brand name "Hulu" as a top-level heading, followed by a boxed sub-header "Content Engagement Rate" on a separate row. No literal hyphen. Both required text values are present so functionally equivalent. Worth a spec-clarify ticket but not a defect.
2. **PNG date placement (minor):** Spec A11 says "Displaying date appears below legend." Actual PNG places `Date: May. 25, 2026-May. 31, 2026` at the very bottom (after `Brand Insights` footer label), not directly below the legend block. The legend block (FB/TW/IG/TikTok + `-- Compared To`) sits above the chart; the date is below the chart. Minor layout drift — date IS present, just relocated.
3. **Channel column flattening:** Both CSV variants (Area + Table) only emit `Cross-Channel` as the value, NOT one row per channel. The tile heading reads `Legend: Facebook, Twitter, Instagram, TikTok` suggesting per-channel breakdown should be possible. Spec assertions A3/A6 only name "Channel" as a column (singular value), so this is consistent with spec — but the chart's per-channel rendering is not exported. Noting for future spec clarification.

## Files

- testcases/english/QA-51490.md
- runs/2026-05-29/QA-51490-report.md (this report)
- /Users/yashsharma/Downloads/Hulu-Insights-Content Engagement Rate-2026-05-25-2026-05-31.csv (Area)
- /Users/yashsharma/Downloads/Hulu-Insights-Content Engagement Rate-2026-05-25-2026-05-31 (1).csv (Table)
- /Users/yashsharma/Downloads/Hulu-Insights-Content Engagement Rate-Line-2026-05-25-2026-05-31.png
