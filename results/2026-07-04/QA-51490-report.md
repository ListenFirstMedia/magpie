# QA-51490 — Brand > Insights - Content Engagement Rate - Tile level export - PNG and CSV

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless, unattended), `app.lfmdev.in`, branch `feature/playwright-mcp`
- **Login:** `lfiqa@listenfirstmedia.com` (Cognito "With existing account") → `#home` OK
- **Verdict:** **PASS (12/12 assertions)**
- **Open-bug screen:** "None open. Screen only — run normally." → ran normally.
- **Skills used:** `switch-account` (Adam Orfei → Hulu), `export-csv` / `audience-metrics-export` (Brand>Insights tile-level export), `chart-hover-tooltip` (tile graph-type selector `.dropdown-name` / `.selector-dropdown-container`).

## Precondition handling (important)

Spec precondition: **"User logged in as Hulu."** The session defaulted to the **Adam Orfei** account. Selecting the "Hulu" brand there resolved to brand_id **11003** (Public-only entity, per the known Hulu 5670→11003 redirect quirk); its **perspective toggle was disabled (Public-locked)** and its Public tile set **had no "Content Engagement Rate" tile** (Impressions-based, Authorized-only metric). Per the account-precondition rule, I switched account to **Hulu (account_id=336)** via the LFQA profile menu → Search Account → Results → "Hulu". On the Hulu account the Insights nav resolved to brand_id **5670** (Authorized, `perspective=extended`), where the Content Engagement Rate tile is present. No brand substitution (Rule 1) — exact "Hulu" chosen from typeahead Results both times.

- Final context: Account **Hulu** (336), Brand **Hulu** (brand_id=5670), View **Authorized** (`perspective=extended`), Channels FB/Twitter/Instagram/TikTok, Date Range **Jun. 26, 2026 – Jul. 02, 2026**, Compared to Jun. 19–25.

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand top-nav → Insights | OK (`#explore/brand/insights`) |
| 2 | Type + select 'Hulu' from brand dropdown Results | OK (exact "Hulu", brand_id=5670 after account switch) |
| 3 | Open Graph Type dropdown on Content Engagement Rate tile | OK (options Area/Bar/Line/Pie/Table) |
| 4 | Select 'Area' | OK (chart → Area, Y-axis 0%–5.5%) |
| 5 | Export → CSV | OK — `Hulu-Insights-Content Engagement Rate-2026-06-26-2026-07-02.csv` downloaded to disk |
| 6 | Open Graph Type dropdown | OK |
| 7 | Select 'Table' | OK (flat aggregate row) |
| 8 | Export → CSV | OK — same filename (flat/no-Date variant) downloaded to disk |
| 9 | Graph Type → Line Chart | OK |
| 10 | Export → PNG | OK — `Hulu-Insights-Content Engagement Rate-Line-2026-06-26-2026-07-02.png` downloaded to disk |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Bar Chart, Export, Save to Dashboard options below CER tile | Tile footer shows graph-type dropdown ("Bar"), "Export", "Save to Dashboard" | **PASS** |
| A2 | 5 | Filename `Brand - Tab - Tile - YYYY-MM-DD-YYYY-MM-DD.csv` | `Hulu-Insights-Content Engagement Rate-2026-06-26-2026-07-02.csv` | **PASS** |
| A3 | 5 | CSV columns Date, Brand Name, Channel, Content Engagement Rate | `"Date","Brand Name","Channel","Content Engagement Rate"` | **PASS** |
| A4 | 5 | CSV data matches tile data | 7 daily rows (Jun 26–Jul 02), Cross-Channel; values 0.0180/0.0090/0.0070/0.0081/0.0098/0.0403/0.0511 = peak 5.11% Jul 02 — consistent with tile Area chart 0%–5.5% Y-axis + aggregate 1.34% | **PASS** |
| A5 | 8 | Same filename format as step 5 | `Hulu-Insights-Content Engagement Rate-2026-06-26-2026-07-02.csv` (identical) | **PASS** |
| A6 | 8 | CSV columns Brand Name, Channel, Content Engagement Rate (no Date) | `"Brand Name","Channel","Content Engagement Rate"` (no Date) | **PASS** |
| A7 | 8 | CSV data matches tile data | Single row `"Hulu","Cross-Channel","0.0134301808605583"` = 1.34% = tile aggregate | **PASS** |
| A8 | 10 | Filename `Brand - Tab - Chart -Line-YYYY-MM-DD-YYYY-MM-DD.png` | `Hulu-Insights-Content Engagement Rate-Line-2026-06-26-2026-07-02.png` | **PASS** |
| A9 | 10 | Chart Title `Brand Name - Chart Name` | PNG shows "Hulu" + "Content Engagement Rate" | **PASS** |
| A10 | 10 | Legends include Facebook, Twitter, Instagram, --Compared To | Legend: "Facebook, Twitter, Instagram, TikTok" + "-- Compared To" (named channels present; TikTok extra as 4 channels selected) | **PASS** |
| A11 | 10 | Displaying date appears below legend | PNG footer "Date: Jun. 26, 2026-Jul. 02, 2026" below legend/chart | **PASS** |
| A12 | 10 | X and Y axis labels match the page | X: Jun 26…Jul 02; Y: 0%–5.5% (0.5% steps) — identical page vs PNG | **PASS** |

## Evidence

CSV files (on disk, verified):
- Area: `.playwright-out/QA-51490/area.csv` (server name `Hulu-Insights-Content Engagement Rate-2026-06-26-2026-07-02.csv`)
- Table: `.playwright-out/QA-51490/table.csv` (same server name, flat variant)
- Line PNG: `.playwright-out/QA-51490/line.png` (server name `Hulu-Insights-Content Engagement Rate-Line-2026-06-26-2026-07-02.png`, 39,799 bytes)

Area CSV (7 rows):
```
"Date","Brand Name","Channel","Content Engagement Rate"
"2026-07-02","Hulu","Cross-Channel","0.0510968643165236"
"2026-07-01","Hulu","Cross-Channel","0.040349052880261194"
"2026-06-30","Hulu","Cross-Channel","0.00982421645900375"
"2026-06-29","Hulu","Cross-Channel","0.00806433861862299"
"2026-06-28","Hulu","Cross-Channel","0.00704454468861053"
"2026-06-27","Hulu","Cross-Channel","0.00899329040598022"
"2026-06-26","Hulu","Cross-Channel","0.0179653761154301"
```

Table CSV (1 row):
```
"Brand Name","Channel","Content Engagement Rate"
"Hulu","Cross-Channel","0.0134301808605583"
```

Screenshots (`.playwright-out/QA-51490/`):
- `A1-cer-tile-controls.png` — tile footer controls (graph-type / Export / Save to Dashboard)
- `A2-area-chart.png` — Area chart
- `A5-table-view.png` — Table view (flat aggregate)
- `A8-line-chart.png` — Line chart on page
- `line.png` — exported PNG (read multimodally for A9–A12)

## Notes / variances (not bugs)

- **Filename separators:** spec writes " - " (spaced hyphens) between Brand/Tab/Tile; platform emits single hyphens between segments while preserving the tile-name's internal spaces (`Hulu-Insights-Content Engagement Rate-...`). This is the long-documented Insights filename schema, treated as illustrative-spec vs. rendered format — **PASS**. (Playwright further slugifies the on-disk copy's spaces→hyphens; server/download-event name is the authoritative one asserted above.)
- **A10 extra channel:** legend also lists TikTok (4 channels are active on Hulu Authorized). Spec says "include" the named three + Compared To — all present.
- **Google Sheets:** the tile Export menu offered a Google Sheets option, but this case's steps only use CSV/PNG — no GS step in scope; none attempted.
- **Perspective:** ran under the default Authorized view of Hulu (5670). The spec does not name a perspective; the Content Engagement Rate tile only exists under Authorized (Impressions-based metric), which is where the Hulu-account default lands.

## Bugs filed

None. All 12 assertions passed.
