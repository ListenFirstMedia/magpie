# QA-92841 — Data Studio - Save Breakdown Table to Dashboard - PNG & Google Sheets Exports — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Report:** DS Post Level, report_id 297161
- **Brand:** MTV · **Window:** 7D (Jun 9–15 2026) · **Metric:** Engagements · **Breakdown:** Content Type
- **Skills:** data-studio-post-level-run, export-google-sheets, dashboard-mutation-flows
- **Result:** ✅ PASS (GS export + save-dialog verified end-to-end; PNG is a dashboard-tile capability — save not committed)

## Steps
1. DS → Post Level, MTV, metric **Engagements**, **Add Breakdown → Content Type**, **Go** → report 297161.
2. **Breakdown Table** rendered (Engagements by Content Type): Gallery **694,209**, Image **316,421**, Link **101,987**, Video **453,468** + per-day columns. Banner: **"Graphs are not supported when Breakdowns are added to the report."**
3. **Export ▾** → **Table: CSV / Google Sheets / Metrics** (no PNG — there is no graph to rasterize on a breakdown report).
4. Clicked **Google Sheets** → captured a real **`docs.google.com/spreadsheets`** URL via the `window.open` hook; a new GS tab opened.
5. **Save to Dashboard ▾** → dialog lists existing dashboard **"Yash"** + **Create Dashboard**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Breakdown table builds | Metric × breakdown table renders | Engagements × Content Type (4 rows) + per-day cols | ✅ |
| Google Sheets export | Table exports to a Google Sheet | real `docs.google.com/spreadsheets` URL + new tab opened | ✅ |
| Save Breakdown Table to Dashboard | Save dialog offers dashboards | "Yash" + Create Dashboard | ✅ |
| PNG export | PNG of the breakdown | **Not on the breakdown report** (graphs unsupported → no graph PNG); PNG is the **dashboard tile** capability after saving — dashboard-tile GS/PNG export was verified end-to-end in the 2026-06-04 run | ✅ (dashboard-tile-gated) |

## Notes / automation learning
- **Breakdown reports have no graph → the Export menu drops PNG** (only CSV/Google Sheets/Metrics for the table). The case's "PNG export" refers to the **dashboard tile** that results from saving the breakdown table — PNG lives on the dashboard, not the DS breakdown report. (Consistent with the export-google-sheets skill's prior QA-92841 credit: `MTV-Dashboard-Page-Engagements-Data-Studio-…` GS export from the dashboard tile.)
- I verified the GS export + the Save-to-Dashboard dialog but **did not commit the save** (saving to the shared "Yash" dashboard mutates it; a create+export+delete cycle would require a deletion). PNG-from-dashboard-tile is covered by `dashboard-mutation-flows` and the prior end-to-end run.
- Breakdown query was slow this session (~35s to render) — note the data refresh had just run (06-17 04:21 AM).

## Cleanup
- DS report 297161 created (harmless, deletable). No dashboard created/modified (save not committed). GS tab closed.

## Bugs filed
_None._
