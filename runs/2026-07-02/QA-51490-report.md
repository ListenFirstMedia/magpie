# QA-51490 — Brand > Insights - Content Engagement Rate - Tile level export - PNG and CSV

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-51490 · Priority: Trivial
- **Result:** **PASS** — all three tile exports (Area CSV, Table CSV, Line PNG) verified. One minor date-placement note on the PNG.
- **Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · **Tile:** Content Engagement Rate (1.21%, -27%)
- **Skills:** chart-hover-tooltip (tile graph-type selector), audience-metrics-export (tile export pattern)

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A. (APPS-53319 "CER + Trends tiles Reload error" is Closed; not reproduced — tile loaded fine.)

## Steps + assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A2 | Graph-type / Export / Save to Dashboard controls below the CER tile | Present (used them: `.tile-level-data-viz-buttton-container` graph-type + Export dropdowns) | ✅ PASS |
| A5 filename (Area→CSV) | `Brand - Tab - Tile - <start>-<end>.csv` | `Hulu-Insights-Content Engagement Rate-2026-06-25-2026-07-01.csv` | ✅ PASS |
| A5 columns | Date, Brand Name, Channel, Content Engagement Rate | `"Date","Brand Name","Channel","Content Engagement Rate"` (6 daily rows) | ✅ PASS |
| A5 matches tile | CSV data matches tile | Jul-01 row = 0.04035 (≈4.03%), consistent with the tile/line-chart | ✅ PASS |
| A8 filename (Table→CSV) | same pattern | same filename (Table export) | ✅ PASS |
| A8 columns | Brand Name, Channel, Content Engagement Rate (no Date) | `"Brand Name","Channel","Content Engagement Rate"` → `"Hulu","Cross-Channel","0.0121160870118128"` | ✅ PASS |
| A8 matches tile | CSV data matches tile | 0.012116 = **1.21%** = the tile's headline CER | ✅ PASS |
| A10 filename (Line→PNG) | `Brand - Tab - Chart - Line - <start>-<end>.png` | `Hulu-Insights-Content Engagement Rate-Line-2026-06-25-2026-07-01.png` | ✅ PASS |
| A10 chart title | Brand Name - Chart Name | PNG shows "Hulu" + "Content Engagement Rate" | ✅ PASS |
| A10 legends | Facebook, Twitter, Instagram, + "-- Compared To" | Legend: "Facebook, Twitter, Instagram, TikTok" + "-- Compared To" (TikTok also present — Hulu has 4 channels) | ✅ PASS |
| A10 axes | X/Y labels match page | Y-axis 0%–4.5% (CER); X-axis Jun 25 → Jul 01; line peaks ~4% at Jul 01 (matches Area CSV) | ✅ PASS |
| A10 date below legend | Displaying date below the legend | Date **"Jun. 25, 2026-Jul. 01, 2026"** is present but rendered at the **bottom** (under the chart/"Brand Insights" footer), not directly below the legend | ◐ PASS w/ note |

## Evidence
- `.playwright-out/Hulu-Insights-Content-Engagement-Rate-2026-06-25-2026-07-01.csv` (Table CSV, last written; Area CSV had the same filename and was overwritten — both headers captured in this report).
- `.playwright-out/Hulu-Insights-Content-Engagement-Rate-Line-2026-06-25-2026-07-01.png` (Line chart export — title, legend, axes verified visually).

## Notes / findings
- **Area and Table CSV share the same filename** (`Hulu-Insights-Content Engagement Rate-<dates>.csv`) — only the columns differ (Area has Date; Table omits it). Under Playwright the second download overwrote the first locally; both were verified in sequence.
- **PNG date placement:** the displaying date sits at the bottom of the export (below the chart/footer), whereas the spec says "below the legend". Cosmetic; date value is correct. Flag for spec/dev confirmation.
- Tile-level CSV/PNG exports are **direct downloads** to `.playwright-out/` (not emailed) — distinct from Brand>Content page-level CSV (emailed).

## Bugs filed
None. All assertions passed (PNG date-placement nuance noted).
