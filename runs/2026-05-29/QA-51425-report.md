# QA-51425 — Duplicate Brands and Social Pages Report on Radaac — Re-Run Report

- **Date:** 2026-05-29 (batch 3 re-run; calendar shows 2026-06-02; Radaac header shows "Data for: Friday, May 29, 2026")
- **Source spec:** testcases/english/QA-51425.md
- **Prior run:** runs/2026-05-27/QA-51425-report.md (FLAGGED CSV→TSV regression)

## Result: PASS — CSV→TSV regression NOT REPRODUCED (likely fixed)

## Execution

1. Navigated to `https://radaac.lfmdev.in/` → Google SSO redirect to ListenFirst auth → returned authenticated as yash.sharma@listenfirstmedia.com.
2. Search for / click row 16 "Duplicate Brands and Social Pages". Popup opened with the spec's exact description text.
3. Clicked File format dropdown. Options: `tsv` (default), `csv`, `xls`.
4. Selected `csv` via the `select` element's value mutation + `change` event dispatch (the React/jQuery select required programmatic value-set, then re-submit).
5. Clicked Submit. Page redirected to `https://radaac.lfmdev.in/duplicate_brand_social_pages?file_format=csv` showing "File is Ready" + download link `/cache/20260601DuplicateBrandSocialPages_37a06f.csv` and Report URL `?file_format=csv`.
6. Clicked the download link. File saved to `~/Downloads/20260601DuplicateBrandSocialPages_37a06f.csv`, 1,123,115 bytes, 14,987 lines.

### Note on the first attempt (TSV submitted instead)

On the FIRST attempt I set the select to `csv` via JS BEFORE the dialog was correctly identified — the first select on the page was a different one (data table page-size). The first submit went out as `file_format=tsv` (default) — see URL `…?file_format=tsv` in console. This was OPERATOR error, NOT a product bug. Re-ran with proper dialog-scoped select. The second attempt submitted with `file_format=csv` correctly, and the downloaded file is genuine CSV.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Popup with exact description text | "The report will pull a list of all brands in the platform that have one of the same social pages associated to multiple brands (Facebook, Twitter, Instagram). This pull should exclude brands with the same name (public and extended)." — matches spec exactly | PASS |
| A2 | 5 | CSV file downloaded after a few seconds | Saved `~/Downloads/20260601DuplicateBrandSocialPages_37a06f.csv` (1,123,115 bytes) | PASS |
| A3 | 5 | Filename `YYYYMMDDDuplicateBrandSocialPages_caacfb.csv` | `20260601DuplicateBrandSocialPages_37a06f.csv` (matches pattern; hash differs run-to-run) | PASS |
| A4 | 5 | Columns: Brand ID, Brand Name, Title Category, Channel, Url, Perspective | Row 1: `brand id,brand name,title category,channel,url,perspective` (6 columns, lowercased) | PASS |
| A5 | 5 | Duplicate column should NOT display | No `duplicate` column present; only the 6 expected columns | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs) | — | bug-history shows 2 historical closed defects |
| **CSV→TSV regression (known-quirk)** | **NOT REPRODUCED — likely fixed** | This is the major outcome of this re-run. The 2026-05-27 run downloaded a file with `.csv` extension whose payload was actually tab-separated. On 2026-05-29 (this run), the downloaded `.csv` file contains genuine comma-separated content. Verified via byte inspection: first line `brand id,brand name,title category,channel,url,perspective` — commas, no tabs. AWK on tab delimiter returns 1 field per row, confirming no tab separators. The cache key bug appears resolved. |

Historical closed patterns:
- **APPS-53077 (Closed) — 502 Gateway Error**: No 502; report ready in <8 seconds.
- **APPS-47752 (Closed) — Export failed to download**: Download succeeded cleanly.

## New findings

None. All 5 assertions pass, AND the CSV/TSV regression flagged in the 2026-05-27 cycle is no longer present.

## Recommendation

- Update `knowledge-base/known-quirks.md` entry "Radaac report Export returns TSV when CSV format requested" to add a "Resolved 2026-05-29" footer. The quirk should be removed from active status but retained for historical reference (in case it regresses).

## Files
- testcases/english/QA-51425.md (spec)
- runs/2026-05-29/QA-51425-report.md (this report)
- /Users/yashsharma/Downloads/20260601DuplicateBrandSocialPages_37a06f.csv (the verified CSV — 14,987 lines, comma-separated, 6 columns)
