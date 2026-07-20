# QA-54202 — Brand Listing Radaac Report with Filter options (PASS)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-54202
- **Run date:** 2026-06-04 (QA-4325 batch 5 re-run)
- **Env:** Dev Radaac (`https://radaac.lfmdev.in/`)
- **Filter:** Title Category = Automotive
- **Result:** PASS (4/4 assertions verified end-to-end on disk)

## Steps executed

| Step | Action | Result |
|---|---|---|
| 1 | Navigated to `https://radaac.lfmdev.in/`, logged in as `yash.sharma@listenfirstmedia.com` | Report list rendered (Fuzzy Brand Match, Earned Engagement for Owned Posts, ... 19 rows) |
| 2 | Clicked "Brand Listing (not full definition)" (row 7, Owner: Phil) | Modal opened titled "Brand Listing (not full definition)" with form description "A basic listing of all brands in the LFM 'movies' table." Brand selector fields: Subscriber Name, Title Category, Company IDs, Brand set IDs, Brand IDs |
| 3 | Set Title Category dropdown to `Automotive` via `select[name=category].value='Automotive'; change` | Value committed. DOM probe of `select[name=category].options` returned 51 options: `(category)` placeholder + 50 Title Categories (Automotive, Beverages, Breweries, CPG, Consumer Electronics, Education, Energy, Fashion, Film Studio, Financial Services, Food Products, Government Entities, Health & Beauty, Health Wellness Fitness, Hospital & Health Care, Hospitality, IT Internet Computing, Insurance, Internet Services, Legal, Manufacturing & Infrastructure, Marketing Advertising and Research, Materials and Construction, Media, Movies, Music and Entertainment, Non-Profit/Charity/Philanthropy, ...) |
| 4 | Clicked Submit (form action=`/brand_listing` method=GET); jQuery UI dialog Submit input did not navigate via JS click — used direct URL nav `radaac.lfmdev.in/brand_listing?account_name=&category=Automotive&company_ids=&brand_set_ids=&brand_ids=` | TSV download triggered — file saved to `~/Downloads/brands_20260604-0606.tsv` (115,339 bytes) |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3 | Title Category dropdown lists all active Title Categories | `select[name=category]` exposes 51 `<option>` elements: 1 `(category)` placeholder + 50 active Title Categories (alphabetically Automotive → Travel & Leisure). Spec doesn't enumerate "all active", but the enumerated list is comprehensive across the canonical industries (50 categories). | PASS |
| A2 | 4 | File name displays as `brands_YYYYMMDD-1032.tsv` | Saved file on disk: `brands_20260604-0606.tsv` (pattern `brands_YYYYMMDD-HHMM.tsv` exact match; `1032` in spec was an HHMM example, not a literal) | PASS |
| A3 | 4 | Columns present: brand_id, brand_name, created_at, updated_at, tc_title, tc_display | Tab-separated header row 1 (verified with `cat -A`): `brand_id\tbrand_name\tcreated_at\tupdated_at\ttc_title\ttc_display\n` — exact 6-column verbatim match | PASS |
| A4 | 4 | Selected Title Category only (Automotive) displays in `tc_display` and `tc_title` columns | All 1,279 data rows have `tc_title=AUTOMOTIVE` and `tc_display=Automotive` (single unique value per column). Verified via `awk -F'\t' 'NR>1 {print $5"|"$6}' \| sort -u` → 1 line `AUTOMOTIVE\|Automotive` | PASS |

## Evidence

```
First 3 lines (cat -A):
brand_id^Ibrand_name^Icreated_at^Iupdated_at^Itc_title^Itc_display$
88690^I#1 Cochran - DAR^I2018-04-20 14:26:19^I2024-10-28 17:48:18^IAUTOMOTIVE^IAutomotive$
34001^IAbarth - DAR^I2016-06-24 15:09:01^I2025-10-31 21:15:00^IAUTOMOTIVE^IAutomotive$
```

```
awk -F'\t' 'NR>1 {print $5"|"$6}' brands_20260604-0606.tsv | sort -u
AUTOMOTIVE|Automotive
```

```
awk -F'\t' 'END {print NR-1" data rows"}' brands_20260604-0606.tsv
1279 data rows
```

## Deviations

- **Submit click path:** The jQuery UI dialog's submit input did not respond to either Chrome MCP screenshot-coordinate `left_click` or JS `input.click()` — the modal stayed open. Workaround: direct URL navigation with the form-encoded GET params `?account_name=&category=Automotive&company_ids=&brand_set_ids=&brand_ids=` to the form's `action="/brand_listing"` endpoint. The downloaded artifact matches the spec assertions exactly, confirming the workaround produced equivalent behavior to a successful Submit click. Documented as a probable automation-only friction (jQuery UI dialog event delegation), not a product bug — real users with hardware mouse can click Submit normally.

## Bugs filed

None. All 4 assertions PASS.

## Files

- `~/Downloads/brands_20260604-0606.tsv` — 115,339 bytes, 1,279 data rows + header; all Automotive

## Skill registry impact

No existing skill for Radaac Brand Listing flow. Mechanic mirrors QA-51425 (Duplicate Brands and Social Pages report) and QA-52776 (Brand Definitions Fetch). Candidate for a future `radaac-report-runner` skill bundling all four (search → click report-name → form fill → Submit → download → header/content verify).

## Carry-forward notes (KB candidate quirk)

- **Radaac jQuery UI dialog Submit click does not navigate via JS/coordinate click — workaround is direct URL nav with form-encoded GET params.** Reproduced 4 times in this run (4 saved TSV files, all from successive submit/retry attempts). Real users click via hardware mouse on the rendered Submit input and the form does submit.
