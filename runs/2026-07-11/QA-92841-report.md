# QA-92841 — Reporting > Data Studio — Save Breakdown Table to Dashboard — PNG & Google Sheets Exports

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Environment:** app.lfmdev.in, programmatic login as `lfiqa@listenfirstmedia.com`
- **Account / Brand:** Adam Orfei (account_id=54) / **MTV** (Rule 1 exact typeahead Results match)
- **Report built:** Data Studio → Page Level, **Authorized Video Views** group (rollup + Facebook Page Video Views + Instagram Video Views + LinkedIn Video Views), 30D (Jun 11 – Jul 10 2026), MTV View=**Authorized** → report_id **302173**
- **Dashboard (mutating):** created `QA-92841-TEST-20260711-1611` (id 6423), saved the DS tile, then **deleted** (cleanup verified — Dashboards 34→33, dashboard absent)
- **Verdict:** **PASS** (in-scope A2/A3/A5 pass; A1 inconclusive/known-bug probe; A4 Google Sheets out of scope)

## Steps executed
1. Logged in; switched UCLA → **Adam Orfei** via LFQA menu (React-setter into `.account-typeahead-input`, clicked the **Results** `.lfm-ta-option`). Breadcrumb `Account: Adam Orfei`, account_id=54.
2. Reporting → Data Studio (menu nav). Page Level.
3. Added brand **MTV** (exact typeahead option; DOM-tagged + trusted click). Set MTV **View toggle → Authorized** (row-scoped `.al-toggle__checkbox` input click; label-text click was inert).
4. Select Metrics → searched "Video Views" → selected the **Authorized Video Views** group: `Video Views` (rollup), `Facebook Page Video Views`, `Instagram Video Views`, `LinkedIn Video Views` (`.controlled-check-box` trusted clicks). Set date range **30D**.
5. Clicked **Go** → report_id 302173. Probed for the data-fetching popup (A1).
6. Report rendered: chart (Video Views line, MTV legend) + full data table (4 metric rows × Sum/Average/30 daily columns).
7. **Save to Dashboard** → **Create Dashboard** → named `QA-92841-TEST-20260711-1611` (React InputEvent setter) → **Ok**. Counter → `Save to Dashboard (1)`.
8. Navigated to Dashboards → opened the new dashboard (id 6423). Tile `Video Views` rendered — header `MTV (Reporting: Data Studio) Page Level`.
9. Tile **Export → PNG** — saved on disk. Tile **Export → CSV** (in scope) — saved on disk, to confirm the tile's preserved config.
10. Cleanup: Dashboard Menu → Delete on the test row → confirm modal (`Are you absolutely sure you want to delete your "QA-92841-TEST-20260711-1611" dashboard?`) → Ok. Verified gone.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Run | Data-fetching pop-up visible during Run (probe LFMP-31814) | Immediately after Go, inline loading indicators shown (`data-studio__graph--loading` + `tile-loading-placeholder`); **no distinct blocking "data fetching" modal popup captured**. Sub-second timing — cannot rule out a flashed modal. Loading feedback present. | INCONCLUSIVE (see LFMP-31814 note) |
| A2 | Save | Tile saves to dashboard with breakdown applied | Tile saved (`Save to Dashboard (1)`); new dashboard created; tile renders `Video Views` with **MTV** brand + **Authorized** View preserved. CSV confirms `View=Authorized`; daily Video Views **exactly match** the source report. | PASS |
| A3 | Export PNG | PNG filename pattern present; image renders the breakdown | Server name `MTV-Dashboard-Page-Video Views-Line-2026-07-04-2026-07-10.png` (on-disk slugified). Image renders a valid chart: title "Video Views", legend MTV, line Jul 04–10, footer "Reporting Data Studio / Date: Jul. 04, 2026 - Jul. 10, 2026". Tile is a **graph tile** (viz = Line/Area/Bar/Pie, no Table) → PNG renders the chart, not a literal table. | PASS (chart, not table — tile-type note) |
| A4 | Export Google Sheets | GS file opens & matches | **SKIPPED — out of scope** (Google 2FA). GS option present in tile Export menu; not exercised. | SKIPPED (GS out of scope) |
| A5 | Authorized Video Views | Column consistent, lock vs endash (probe LFMP-31936) | In the DS report table, Authorized Video Views rendered **consistently**: numeric where data exists, en-dash `–` for no-data days (FB Jun 17 + Jul 09/10; LinkedIn all days, Sum/Avg 0). **No lock icons anywhere.** CSV View=Authorized confirms perspective. | PASS |

## Evidence
- Report breakdown table (Authorized, 30D), verbatim Sum:
  - Video Views (rollup): **76,591,291** (Avg 2,553,043)
  - Facebook Page Video Views: **7,094,707** (Avg 236,490); en-dash Jun 17, Jul 09, Jul 10
  - Instagram Video Views: **53,099,710** (Avg 1,769,990)
  - LinkedIn Video Views: **0** (Avg 0); all daily cells en-dash
- Dashboard tile CSV (`MTV-Dashboard-Page-Video Views-Data-Studio-Jul-04-2026-Jul-10-2026.csv`): columns `Brand,View,Date,Video Views`; **View=Authorized**; Jul 04–10 = 2,547,072 / 2,309,304 / 1,849,632 / 1,999,432 / 1,254,849 / 2,412,524 / 1,757,223 — **exact match** to the source report's last 7 Video Views daily cells (tile↔source data parity).
- PNG export rendered & read on disk (`MTV-Dashboard-Page-Video-Views-Line-2026-07-04-2026-07-10.png`).
- Screenshots: `.playwright-out/QA-92841/01-after-go-loading.png`, `02-report-rendered.png`, `03-dashboard-tile.png`.
- **Dashboard date-range note (not a defect):** the saved tile re-scopes to the dashboard's global range (7D, Jul 04–10), not the DS report's 30D — expected dashboard behavior.

## Known bugs checked
Bug-history.md grep (QA-92841) + case Probes section:
- **LFMP-31814 (Major, Open)** — "DS Data fetching pop-up not displayed." A1 probe: no distinct fetching modal was captured; only inline loading placeholders were seen. Consistent with the open bug, but timing-sensitive (sub-second) so **not conclusively reproduced**. Prior run 2026-06-04 recorded NOT REPRODUCED. Attributed to the known open bug; does **not** fail this case.
- **LFMP-31936 (Minor, Open)** — "Authorized Video Views inconsistency (lock vs endash)." A5 probe: Authorized Video Views rendered **consistently** (numbers / en-dash, no lock icons). **NOT reproduced** this run.

No new bug found. Both probes map to existing open bugs; neither interferes with the substantive assertions (A2/A3/A5 PASS).

## Bugs filed
None. (Reports are markdown-only; no Jira tickets created.)

## Cleanup
Test dashboard `QA-92841-TEST-20260711-1611` (id 6423) deleted; Dashboards count 34→33; dashboard absent from list. No orphan. (A stray favorite-star toggle during navigation was on the same dashboard and is gone with the delete.)
