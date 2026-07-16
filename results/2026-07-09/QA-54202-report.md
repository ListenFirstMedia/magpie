# QA-54202 — Brand Listing Radaac Report with Filter options

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP) — read-only
- **Surface:** `radaac.lfmdev.in` · "Brand Listing (not full definition)" · Title Category = Automotive

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Radaac → "Brand Listing (not full definition)" → Title Category dropdown (51 options incl. Automotive) → selected **Automotive** → Submit → downloaded `brands_20260709-1506.tsv` (1,285 data rows).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Title Category dropdown lists active categories | 51 options incl. Automotive | PASS |
| A2 | Filename `brands_YYYYMMDD-HHMM.tsv` | `brands_20260709-1506.tsv` (HHMM = run time; case's "1032" was an example) | PASS |
| A3 | Columns: brand_id, brand_name, created_at, updated_at, tc_title, tc_display | exactly those 6 columns | PASS |
| A4 | Only selected category (Automotive) in tc_display/tc_title | tc_title = {AUTOMOTIVE}, tc_display = {Automotive} across all 1,285 rows | PASS |

## Evidence
- `.playwright-out/brands-20260709-1506.tsv`

## Bugs filed
None.
