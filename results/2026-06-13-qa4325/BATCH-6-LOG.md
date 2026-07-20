# QA-4325 — Batch 6 Log — 2026-06-13 (data now 06-17 04:21 AM)

Cases #26–30 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 26 | QA-92841 | DS — Save Breakdown Table to Dashboard, PNG & GS | ✅ PASS | Breakdown (Engagements × Content Type) rendered; GS export = real `docs.google.com/spreadsheets` URL; Save-to-Dashboard dialog (Yash + Create). Breakdown reports have no graph→PNG ("graphs unsupported with breakdowns"); PNG is the dashboard-tile capability (prior-verified). Save not committed |
| 27 | QA-94977 | Brand>Audience LinkedIn — Metric Export | ✅ PASS | UCLA (127756); Export → Metrics opened **"Brand-Audience-Metrics"** Google Sheet (catalog doesn't need tile data) |
| 28 | QA-94978 | Brand>Audience LinkedIn — PNG Export | ⛔ BLOCKED-data | UCLA LinkedIn demographic tiles "no data" (Public+Authorized, 2 windows); can't capture meaningful tile PNG. Prior 2026-06-04 6-tile PNG sweep verified |
| 29 | QA-95067 | Brand>Audience LinkedIn — Country/Region hover | ⛔ BLOCKED-data | Geo tiles not populated (same UCLA LinkedIn data gap). Prior run verified "Canada 1%" hover |
| 30 | QA-99380 | Brand>Content — Daily Post Analysis Modal graph | ✅ PASS | MTV post DPA modal: 5-metric line chart, legend, daily Jun 2–15, table consistent (VV Sum 2,974,499); chart-type selector Area/Bar/Line/Pie + Graph Metrics |

**Batch tally:** 3 PASS · 0 FAIL · 2 BLOCKED-data.

**Environment events:**
- **UCLA LinkedIn audience data is absent** in this dev environment this session (was present 2026-06-04) — blocks QA-94978/95067; QA-94977 (Metrics catalog) unaffected.
- DS breakdown query slow (~35s) — data refresh had just run (06-17 04:21 AM).
- Breakdown report Export = CSV/GS/Metrics (no PNG by design); GS opens real spreadsheet. Audience Metrics export = "Brand-Audience-Metrics" GS.
- No Brand>Insights surfaces touched → no renderer hang this batch.
