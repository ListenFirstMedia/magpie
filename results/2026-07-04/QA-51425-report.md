# QA-51425 — Duplicate Brands and Social Pages Report on Radaac

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless, unattended), real Chrome, `radaac.lfmdev.in`
- **Identity:** lfiqa@listenfirstmedia.com (config/.env)
- **Skill used:** radaac-report-runner
- **Verdict:** **PASS (5/5 in-scope assertions)**
- **Open-bug screen:** None open (per case file, as of 2026-07-03) → ran normally.

## Pre-flight
- Logged in via Cognito "With existing account" form → `app.lfmdev.in/#home` rendered (title "Home - ListenFirst"). OK.
- Navigated to `radaac.lfmdev.in/` — SSO carried, report list rendered (20 rows).

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Search for report 'Duplicate Brands and Social Pages' | Filtered to 1 row (ID 16) |
| 2 | Click 'Duplicate Brands and Social Pages' | jQuery-UI modal opened with description + File format dropdown |
| 3 | Click File Format dropdown in Options field | Dropdown (tsv/csv/xls) engaged |
| 4 | Click CSV | Visible dialog's `file_format` select value = `csv` (verified via DOM) |
| 5 | Click Submit | Trusted click navigated to `duplicate_brand_social_pages?file_format=csv`; "Fetching report" → "File is Ready"; download fired automatically after ~4s |

Note: under Playwright the modal Submit responds to a trusted `browser_click` (no URL-GET workaround needed) — consistent with the 2026-06-28 known-quirk.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Popup message: "The report will pull a list of all brands in the platform that have one of the same social pages associated to multiple brands (Facebook, Twitter, Instagram). This pull should exclude brands with the same name (public and extended)" | Modal `<p>` matches verbatim (with trailing period) | **PASS** |
| A2 | 5 | CSV file downloaded after a few seconds | Playwright `download` event fired ~4s after Submit; saved to disk | **PASS** |
| A3 | 5 | Filename `YYYYMMDDDuplicateBrandSocialPages_caacfb.csv` | Server-emitted name `20260703DuplicateBrandSocialPages_8b0b04.csv` — matches format `YYYYMMDD`+`DuplicateBrandSocialPages`+`_<6-char hash>`+`.csv` (hash differs, as expected) | **PASS** |
| A4 | 5 | Columns: Brand ID, Brand Name, Title Category, Channel, Url, Perspective | Header `brand id,brand name,title category,channel,url,perspective` — same 6 columns in order (lowercased, documented for this report); all 15,198 data rows have exactly 6 fields | **PASS** |
| A5 | 5 | Duplicate column should NOT display | No "duplicate" column in header | **PASS** |

## Evidence
- **Server-emitted filename:** `20260703DuplicateBrandSocialPages_8b0b04.csv`
- **On-disk file:** `.playwright-out/20260703DuplicateBrandSocialPages-8b0b04.csv` (underscore→hyphen slugified by Playwright, as documented; assert against server name)
- **Delimiter:** genuinely comma-separated — `grep -c $'\t'` = 0 (no CSV→TSV regression)
- **Row count:** 15,199 lines (1 header + 15,198 data rows)
- **Proper CSV parse (python `csv`):** field-count distribution `{6: 15198}` — every data row has exactly 6 columns. (Naive comma-split over-counted 349 rows because brand-name/title values contain quoted commas, e.g. `"WPVI-TV (ABC 6 - Philadelphia, Pennsylvania)"` — expected CSV quoting, not a schema issue.)
- **Header (verbatim):** `brand id,brand name,title category,channel,url,perspective`
- **Sample rows:**
  - `101834,James Bond 007 - DAR,Movies,instagram,007,Standard`
  - `95175,No Time to Die,Movies,instagram,007,Extended`
  - `16581,007 Franchise,Movies,instagram,007,Extended`
- **Screenshots:** `.playwright-out/QA-51425/01-modal.png` (modal + description), `.playwright-out/QA-51425/02-file-ready.png` (File is Ready)

## Bugs filed
None. All in-scope assertions passed. (No Google Sheets steps in this case — nothing skipped.)
