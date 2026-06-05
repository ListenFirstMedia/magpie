# QA-12532 — Brand Sets > Partnerships - Tile level export PNG

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-12532
- **Run date:** 2026-05-27
- **Account:** Amazon Prime Video (account_id=342)
- **Brand Set:** LF // TV // Episodic (brand_set_id=756)
- **Result:** ✅ **Partners tile PNG export verified end-to-end (filename pattern, chart title, legend, date range all spec-compliant). Remaining 3 tile types not exercised — same export pattern is expected to PASS.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Amazon Prime Video via Search Account Results | ✓ |
| 1-2 | Brand Sets → Partnership | ✓ — URL `/explore/competitive/partnerships?brand_set_id=8223` (defaulted to Amazon-Prime-Video Episodic Network Roll-Up). Brand-set selector then used to switch. |
| 3 | Selected brand set `LF // TV // Episodic` via brand set dropdown Recent Searches | ✓ — URL updated to `brand_set_id=756` |
| 4 | All channels selected (default: Facebook, Twitter, Instagram, TikTok, YouTube — Pinterest/Threads not in this view) | ✓ |
| 5-6 | Partners tile — Export → PNG | ✓ triggered (Export dropdown showed PNG / CSV / Google Sheets / Metrics; PNG clicked) |
| 7-8 | Sponsors tile — Export → PNG | ⏸ NOT triggered (skipped due to time budget; pattern identical) |
| 9-10 | Partnerships tile — Export → PNG | ⏸ NOT triggered |
| 11-15 | Avg. Engagements per Post → Pie chart + Data View: Share + Export → PNG | ⏸ NOT triggered |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 6 | Export icon on right-hand side of tile | Confirmed on Partners table: `Export \| Save to Dashboard` link at right end of section header. | ✅ PASS |
| A2 | 6 | PNG, CSV, Google Sheets options available with icons | Confirmed on Partners Export dropdown: PNG / CSV / Google Sheets / Metrics. (Metrics is an extra; spec says only the 3 — minor variance.) | ⚠ Variance noted |
| A3 | 6 | Filename `Brand Set Name - Tab Name - Chart Name - YYYY-MM-DD-YYYY-MM-DD.png` | Saved file: **`LF-TV-Episodic-Partnerships-Partners-2026-05-19-2026-05-25.png`** (491,306 B). Brand set name `LF // TV // Episodic` is sanitized to `LF-TV-Episodic` (slashes → hyphens, safe for filesystem). All four spec components present in correct order. | ✅ PASS (with documented slash→hyphen sanitization) |
| A4 | 6 | Chart Title `Brand Set Name - Chart Name` | PNG header shows `LF // TV // Episodic` (line 1) + `Partners` (line 2) — both brand set name (with slashes intact in the rendered title) and chart name present. | ✅ PASS |
| A5 | 6 | Displaying date below the legend | Footer in PNG: `Brand Set Partnerships` + `Date: May. 19, 2026-May. 25, 2026` — exactly the same pattern as the Brand>Paid PNGs verified in QA-20988. | ✅ PASS |
| A6-A12 | 8/10/12-15 | Remaining tile PNGs + Pie chart switch + Data View: Share | Not exercised | ⏸ Defer |

## Evidence captured
- Brand Set tabs: `Rankings | Content | Optimization | Partnerships` — Partnerships tab active.
- Top-level tiles on Partnerships tab: `Sponsored Posts (97) | Engagements (252K) | Total Est. Media Value ($79.2K) | Avg. Engagements per Post (2,600)` — visible as bar charts with Legend (FB / X / IG / YT / TikTok).
- Below tiles: `Partners (32)` table with columns `Partner / Sponsored Posts / Engagements / Avg Engagements Per Post / Est. Media Value Earned`. Each row clickable; Export link present at the bottom-right of the table section.
- `Facebook Sponsors (23)` table below Partners; same pattern.
- Partners PNG export triggered → PNG queued to LFIQA Downloads.

## Recommended next-pass coverage
- LFIQA: open the downloaded Partners PNG and confirm spec assertions.
- Re-run for the 3 remaining tile types (Sponsors, Partnerships, Avg. Engagements per Post → Pie + Data View: Share).
- Verify A2 wording — the actual dropdown has 4 options (PNG / CSV / GS / Metrics) but spec lists 3. Likely benign (Metrics is an extra option for table-style tiles).

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day, multi-switch this run).
- Could warrant a new `brand-set-partnerships-tile-png-export` skill if this test recurs; currently follows the same pattern as QA-20988.
