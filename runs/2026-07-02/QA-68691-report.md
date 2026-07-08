# QA-68691 — Brand > Stories - Engagements - CSV Export

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-68691 · Priority: Critical
- **Result:** **PASS** — all 4 in-scope assertions pass.
- **Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · **Channel:** Instagram

## Known bugs checked (pre-run)
- `bug-history.md`: no entries for QA-68691.
- Jira issue-links: QA-4467 (test plan), APPS-44296 "Instagram Story Engagements Metric" (**Closed** — feature under test), automation tasks APPS-46058/50523/56705 (Closed) + APPS-61009 (In Progress). **No open defects** → nothing expected to interfere. None observed during the run.

## Steps executed
1. Brand (top nav, hover) → **Stories**. Landed `#explore/brand/stories`, Michael Kors.
2. Brand = **Michael Kors** (account default brand_id=3801) — confirmed in the brand picker (Rule 1).
3. Date Range → **Jan 01, 2025 – Jan 04, 2025** set via the two-calendar picker (Start=Jan 1, End=Jan 4). URL `from=2025-01-01&to=2025-01-04` confirmed.
4. Engagements tile → **Graph type** dropdown (`.dropdown-name`, was "Bar") → **Line**. Control now reads "Line" (other 3 tiles still "Bar").
5. Engagements tile → **Export** dropdown (options: PNG / CSV / Google Sheets) → **CSV**. Synchronous download.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Tile chart updates on Line selection | Engagements tile graph-type = **Line**; chart re-rendered (see `01-engagements-line-chart.png`) | ✅ PASS |
| A2 | Filename `Brand - Tab - Tile - YYYY-MM-DD(Start)-YYYY-MM-DD(End).csv` | **`Michael Kors-Stories-Engagements-2025-01-01-2025-01-04.csv`** (verified on disk) | ✅ PASS |
| A3 | Columns: Date, Brand Name, Channel, Engagements | Header = `"Date","Brand Name","Channel","Engagements"` | ✅ PASS |
| A4 | CSV data matches tile data | CSV: 2025-01-01=1170, 01-02/03/04 empty → Σ 1,170; tile heading "Engagements: 1,170" and table Sum = 1,170 (Stories(2), both on Jan 1) | ✅ PASS |

## Evidence
- CSV on disk: `.playwright-out/Michael Kors-Stories-Engagements-2025-01-01-2025-01-04.csv` (226 B, 4 data rows).
  ```
  "Date","Brand Name","Channel","Engagements"
  "2025-01-04","Michael Kors","Instagram",""
  "2025-01-03","Michael Kors","Instagram",""
  "2025-01-02","Michael Kors","Instagram",""
  "2025-01-01","Michael Kors","Instagram","1170"
  ```
- Screenshot: `.playwright-out/QA-68691/01-engagements-line-chart.png`

## Notes / findings (for skills/KB)
- **Brand > Stories date-range picker = TWO independent calendars** ("Start Date" = from, "End Date" = to). Range mode: click start day, then the END day in the *second/End* calendar (navigate it separately). Clicking a second day in the Start calendar RESETS the from-date (caused a wrong from=Jan-04/to=Dec-31 on first attempt). Zoom out via the month-header → month grid → prev-year arrow → month → day.
- **switch-account (headed):** the LFQA menu opens on **hover** (click toggles it shut); set the Search Account input via React setter (`.fill()` hits "not visible"); the clickable Results row is `.lfm-ta-option` (not the `.account-name` leaf or the list container).
- **Stories tile Export is SYNCHRONOUS** — CSV downloads straight to `--output-dir` (no queue/notification bell). Graph-type + Export controls are `.dropdown-name` spans; options are `.list-item`.

## Bugs filed
None.
