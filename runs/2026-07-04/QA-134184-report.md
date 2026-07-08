# QA-134184 — Brand > Insights - Interval selection - Quarterly

- **Run date:** 2026-07-04
- **Verdict:** **PASS (8/8 assertions)**
- **Environment:** Playwright MCP (headless), real Chrome, `app.lfmdev.in`
- **Account:** Hulu (account_id=336) — per precondition "User logged in as Hulu"
- **Brand:** Hulu (brand_id=5670) — Brand > Insights default brand
- **Skill used:** `brand-insights-interval-picker` (v2)
- **Open-bug screen (Rule 7):** case file lists "None open" → ran normally.

## Preconditions met
- Logged in programmatically as `lfiqa@listenfirstmedia.com` (config/.env), reached `#home`.
- Switched account Adam Orfei → **Hulu** via LFQA menu → Search Account → clicked the "Hulu" `.lfm-ta-option` (exact-match result). Breadcrumb confirmed "Account: Hulu".
- Navigated Brand top nav → Insights (brand_id=5670). Page rendered "Brand Insights".

## Steps executed
1. Clicked Brand top nav (hover) → 2. Selected Insights → Brand>Insights loaded for Hulu.
3. Opened Date Range overlay → clicked the **Interval** dropdown.
4. Selected **Quarterly**; observed default auto-selection.
5. Selected two quarters (Start=Jan, End=Jun 2026) → Ok.
6. Selected a partial quarter range (Start=Feb, End=May 2026) → Ok.
7. Navigated pickers back to 2025; selected Oct→Dec (1 Oct – 31 Dec) → Ok.
8. Selected Sep→Dec 2025 (1 Sep – 31 Dec) → Ok.
9. Selected Jul→Dec 2025 (1 Jul – 31 Dec) → Ok.

All picker interactions were real clicks on `.month` / `.lfm-dropdown-option` / nav-arrow elements (tagged via `data-spk`), and each date resolution was confirmed against the resulting URL `from`/`to` params and the chart X-axis quarter buckets (`Q<n> <year>` `svg text`). No download/export claims made (Rule 6 n/a — no export in this case).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Quarterly option shown below Monthly | Interval dropdown opened with options in order: Daily (selected) / Weekly / Monthly / **Quarterly** — Quarterly is last, directly below Monthly. No `Aggregate`/`Yearly` extras. | **PASS** |
| A2 | 4a | Start/End date labels display as Quarters | On selecting Quarterly the two calendars switched from day-grids to **month grids with quarter-granular selection** — clicking any month highlights its whole 3-month quarter block (`range-start`/`range`/`range-end`). Historical floor banner also shifted from `Jan. 02, 2019` (Daily) to `Apr. 01, 2019` (quarter-aligned). | **PASS** |
| A3 | 4b | Selecting a quarter auto-selects last complete 3-month period | Default auto-selection = **Apr–Jun 2026 (Q2)** — the last complete quarter as of 2026-07-04 (Q3 Jul–Sep incomplete; Jul selectable, Aug–Dec disabled). Classes: Apr=`range-start`, May=`range`, Jun=`range-end`. (Spec "e.g. Jan–Mar" was illustrative.) | **PASS** |
| A4 | 5 | Multiple quarters select correctly (Jan–Mar & Apr–Jun) | Start=Jan, End=Jun → Jan..Jun all highlighted (Q1+Q2). Ok resolved to URL `from=2026-01-01&to=2026-06-30`. | **PASS** |
| A5 | 6 | Partial quarter resolves to full quarters (Feb–May → Jan–Mar & Apr–Jun) | Clicking Feb snapped range-start back to **Jan**; clicking May kept range-end at **Jun**. Selection = Jan..Jun. Ok resolved to `from=2026-01-01&to=2026-06-30` (full Q1+Q2). | **PASS** |
| A6 | 7 | Only Q4 (Oct–Dec) displayed for 1 Oct–31 Dec | Start=Oct, End=Dec 2025 → only Oct/Nov/Dec highlighted. URL `from=2025-10-01&to=2025-12-31`. Quarterly chart X-axis rendered a single bucket **`Q4 2025`**. | **PASS** |
| A7 | 8 | Q3 & Q4 displayed for 1 Sep–31 Dec (range extends backward to include partial Q3) | Clicking Sep (partial Q3) **snapped range-start back to Jul** (full Q3); End=Dec. URL resolved to `from=2025-07-01&to=2025-12-31`. Chart X-axis showed **`Q3 2025` + `Q4 2025`** — NOT just Q4. Confirms the non-obvious backward-extension (APPS-58615, Philip's correction of Suhail's Sep–Dec=Q4 assumption). | **PASS** |
| A8 | 9 | Q3 & Q4 displayed for 1 Jul–31 Dec | Start=Jul, End=Dec 2025 → Jul..Dec highlighted. URL `from=2025-07-01&to=2025-12-31`. Chart X-axis showed **`Q3 2025` + `Q4 2025`**. | **PASS** |

## Evidence
- URL resolutions captured live at each Ok:
  - A4: `from=2026-01-01&to=2026-06-30`
  - A5: `from=2026-01-01&to=2026-06-30` (from Feb–May input)
  - A6: `from=2025-10-01&to=2025-12-31`
  - A7: `from=2025-07-01&to=2025-12-31` (from Sep–Dec input)
  - A8: `from=2025-07-01&to=2025-12-31`
- Chart X-axis quarter buckets (from `svg text`): A6 → `[Q4 2025]`; A7 → `[Q3 2025, Q4 2025]`; A8 → `[Q3 2025, Q4 2025]`.
- Interval dropdown DOM order: `[Daily(selected), Daily, Weekly, Monthly, Quarterly]`.
- Historical floor: Daily = `Jan. 02, 2019`; Quarterly = `Apr. 01, 2019`.
- Arrow-nav granularity: `»`/`«` moved the picker **by one year** per click under Quarterly (year-header `.datepicker-switch` 2026→2025). `»` (next) was `disabled` at the current year 2026 — historical-limit guard intact.

### Screenshots (`.playwright-out/QA-134184/`)
- `01-overlay-open.png` — date overlay, Interval=Daily default, floor Jan 02 2019
- `02-interval-dropdown.png` — Interval dropdown open (Daily/Weekly/Monthly/Quarterly)
- `03-quarterly-selected.png` — Quarterly active, default Q2 (Apr–Jun) auto-selected, floor Apr 01 2019
- `04-two-quarters-jan-jun.png` — Jan→Jun (Q1+Q2) selection
- `05-partial-feb-may-resolves.png` — Feb–May snapped to Jan→Jun full quarters
- `06-q4-oct-dec.png` / `06b-q4-chart-rendered.png` — Q4-only picker + `Q4 2025` chart bucket
- `07-sep-dec-extends-q3q4.png` / `07b-q3q4-chart-rendered.png` — Sep→Dec extended to Jul (Q3+Q4) + chart
- `08-jul-dec-q3q4.png` / `08b-jul-dec-chart-rendered.png` — Jul→Dec (Q3+Q4) + chart

## Notes
- Several Insights big-number tiles ("Total Followers", "Impressions", "Video Views", "Fan Growth Rate") showed "This tile failed to load" / authorization prompts. These are **out of scope** for this case (which tests only the date-range/interval picker) and did not affect any assertion — the Quarterly-aggregated Trend chart and its X-axis buckets rendered correctly throughout.
- Spec A3 example "Jan–Mar" is illustrative; actual auto-select is the **last complete quarter** relative to run date (Q2 2026 on 2026-07-04). Not a defect.
- Google Sheets: n/a (no GS step in this case).

## Bugs filed
None. All 8 assertions passed; product behavior matches spec (including the non-obvious APPS-58615 backward-extension rule for partial-quarter start months).
