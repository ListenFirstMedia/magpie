# QA-22296 Batch 4/12 — 2026-06-05/06-08

Next 5 net-new tickets after batch 3 (QA-18940/22072/23991/24021/27292).

| QA | Spec | Verdict | Result | Report |
|----|------|---------|--------|--------|
| QA-43915 | Ads Account IDs Radaac Report | Cognito SSO → Modal description verbatim verified → Submit via direct URL nav (Radaac jQuery quirk) → "Fetching report" → page TITLE flips to "Failed to process." → reload cycles back to "Fetching report" indefinitely (~100s). File `20260608AdsAccountIds_bceac0.csv` never lands on disk. Reproduces historical LFMP-30870 ("Export failed to download"). | **FAIL — LFMP-30870 REPRODUCES** | `runs/2026-06-05/QA-43915-report.md` |
| QA-63603 | Settings > Tags > Content Tagged - Upload Tags | Tags page loaded; column "Content Tagged" present but no "Content Tagged Tab" and no Upload Tags affordance on this surface. Export dropdown surfaces only CSV + Google Sheets. Upload Tags actually lives on Brand>Content (per QA-27292). Spec/UI drift. | **PARTIAL — spec/UI drift** | `runs/2026-06-05/QA-63603-report.md` |
| QA-75011 | Settings > Custom Metrics - Basic View | Page renders with 18+ rows, 6 columns (Metric/Description/Created Date/Creator/Formula/Actions), `Create a Custom Metric` button visible. APPS-49018 closed bug NOT REPRODUCED. | PASS | `runs/2026-06-05/QA-75011-report.md` |
| QA-79157 | Mixpanel - API Metrics Publishing Analysis | Out-of-scope: Prod Mixpanel third-party dashboard, no automation path from magpie scope. | BLOCKED — out of scope | `runs/2026-06-05/QA-79157-report.md` |
| QA-81416 | Reporting > Data Studio - Report Table - CSV & Google Sheets Export | MTV / FB Total Fans 7-day report built (story_id=294839); CSV `MTV-Data-Studio-May-31-2026-Jun-06-2026.csv` (326B, 8 lines) saved + row-by-row verified vs UI; GS opens tab `1804438490` with title matching CSV filename + Google suffix. | PASS | `runs/2026-06-05/QA-81416-report.md` |

## Batch summary
- 2 PASS (QA-75011, QA-81416), 1 PARTIAL (QA-63603 spec drift), 1 FAIL (QA-43915 LFMP-30870 repro), 1 BLOCKED (QA-79157 out-of-scope).
- 1 historical bug reproduced: **LFMP-30870** (Radaac Ads Account IDs export failed to download). Closed status invalid — needs reopen.
- 1 new finding: **Spec/UI drift on QA-63603** — Upload Tags affordance is on Brand>Content, NOT Settings>Tags as the spec suggests.
- 2 end-to-end downloads verified on disk this batch (Data Studio CSV 326B; GS sheet captured via window.open hook + cross-tab title read).

## Skills used / streak bumps
- `export-csv` v2 → pass_streak 21 → 22 (DS Report Table CSV end-to-end on disk).
- `export-google-sheets` v2 → pass_streak 7 → 8 (DS Report Table GS export tab-title read).
- `settings-custom-metrics` v1 → pass_streak 7 → 8 (QA-75011 basic view re-verified).
- (carry-forward) Radaac flow extends `radaac jQuery UI dialog Submit` known-quirk; "Failed to process." page-title cycling is new evidence on LFMP-30870 regression.

## Notable Chrome MCP / session quirks observed this batch
- After Radaac Cognito session, `app.lfmdev.in` renderer hung for ~30s in the same tab — required `tabs_close_mcp` + fresh tab `1804438489` to recover. Documented as session quirk: Radaac auth + app.lfmdev.in cross-domain session causes app SPA to stall on first navigation; recovery is fresh-tab + nav.

## Chrome state for batch 5
- Active tabs in MCP group:
  - `1804438489` — `app.lfmdev.in/#explore/reporting/data_studio?...&report_id=294839` (DS post-export state; Export dropdown still possibly open).
  - `1804438490` — Google Sheets `MTV-Data-Studio-May-31-2026-Jun-06-2026 - Google Sheets` (opened via window.open hook).
- Account: Adam Orfei (account_id=54). Login confirmed.
- Notes for batch 5:
  - Close GS tab `1804438490` before batch 5 to keep MCP group lean.
  - If next batch starts with Radaac, expect Cognito SSO challenge again + the renderer-hang quirk after returning to app.lfmdev.in.
