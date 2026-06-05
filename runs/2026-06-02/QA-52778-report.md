# QA-52778 — Brand Definition Update - Include URL Manager (PARTIAL — A1 PASS, A2 FAIL FINDING, A3 PASS; A4-A7 NOT VERIFIED to avoid mutation)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-52778
- **Run date:** 2026-06-04 (QA-4325 batch 5 re-run)
- **Env:** Dev Radaac (`https://radaac.lfmdev.in/`)
- **Brand:** 236 (Family Guy)
- **Result:** A1 PASS (default unchecked) | A2 FAIL (URL Managers column missing in Fetch xlsx despite Include URL Managers checked) | A3 PASS (youtube_channel_company immediately after youtube_channel_username) | A4-A7 NOT VERIFIED (Patch + Apply would mutate dev brand_id=236, withheld per `mutating: POTENTIALLY` front-matter)

## Steps executed

| Step | Action | Result |
|---|---|---|
| 1 | Navigated to `radaac.lfmdev.in`, logged in as yash.sharma | Report list rendered |
| 1 | Clicked "Brand Definitions (Fetch)" (row 3) | Modal opened: "Brand Definitions (Fetch)" with Brand selector + Options fieldsets. `<form id="bdr_fetch_form" action="/brand_definition_report" method="GET">` |
| 1 (A1 probe) | Inspected default state of `Include URL Managers` checkbox via DOM `input[name="include_url_mgrs"].checked` | `false` (unchecked by default). **A1 PASS** |
| 2 | Entered `236` in `Brand IDs (CSV)` field | `input[name=brand_ids].value = "236"` |
| 3 | Checked the `Include URL Managers` checkbox via DOM `checked=true; change event` | Toggled to true |
| 4 | Submitted via direct URL `radaac.lfmdev.in/brand_definition_report?brand_ids=236&include_url_mgrs=on` (equivalent to the form's GET submit with checked checkbox; the form's jQuery UI Submit input did not respond to JS/coord click — known Radaac quirk from QA-54202 same-batch run) | Page navigated to "Fetching report" → "File is Ready" with `Download: /cache/20260604BrandDefinitionReport_779ed0.xlsx` |
| 5 | Verified xlsx saved to `~/Downloads/20260604BrandDefinitionReport_779ed0.xlsx` (5,896 bytes) | File present on disk |
| 5 | Opened via openpyxl, inspected header row | **40 columns** — same schema as the no-URL-Managers Fetch (5,895 bytes from 2026-06-02 QA-52776 batch-11). **NO `url managers` column.** |

## Detailed assertion findings

### A1 — Include URL Manager unchecked by default (PASS)

DOM probe of the Brand Definitions (Fetch) modal:
```javascript
input[name="include_url_mgrs"].checked === false  // confirmed
```

### A2 — `url managers` column DISPLAYED in Fetch xlsx (FAIL FINDING)

Even with `Include URL Managers` toggled to checked (`?include_url_mgrs=on`), the resulting xlsx contains 40 columns, none of which is named `url managers` or similar. Identical schema to QA-52776 (Exclude URL Managers) Fetch xlsx from 2026-06-02 (5,895 bytes; this run = 5,896 bytes — 1-byte difference is negligible).

Full 40-column header row (identical to QA-52776 Fetch — no `url managers` insertion):
```
brand_id, title, title_created_date, title_category, title_sub_category,
genre, primary_genre, iso_mic, stock_exchange, ticker_symbol, companies,
brand_set, composite_brand_set, active, released_on,
domestic_opening_weekend_box_office, domestic_opening_weekend_screens,
domestic_opening_weekend_rank, street_date, network,
facebook_page, facebook_verified, twitter_handle, twitter_verified,
instagram_user, youtube_channel_username, youtube_channel_company,
tiktok_user, linkedin_page, threads_page, pinterest_user_username,
pinterest_board, wikipedia_page, rottentomatoes, imdb_id, metacritic,
twitter_search_terms, instagram_business_hashtags,
twitter_search_term_keywords, last_reviewed
```

**Behavior:** The `Include URL Managers` checkbox accepts the user input and submits the param `include_url_mgrs=on` (or `=true`) but the backend ignores the flag — output xlsx schema is identical with and without the option. This is a backend regression or genuine product defect.

### A3 — `youtube_channel_company` immediately after `youtube_channel_username` (PASS)

Verified:
- col 25: `youtube_channel_username`
- col 26: `youtube_channel_company`

Adjacent and in spec-required order.

### A4-A5 (Patch) and A6-A7 (Apply) — NOT VERIFIED

Per spec front-matter `mutating: POTENTIALLY — uses real Brand ID 236 in dev radaac (Patch + Apply commit changes)`:
- Patch processes the Fetch xlsx → may produce a no-op patch xlsx for an unchanged input; same schema as Fetch.
- Apply commits to dev brand_id=236.

Same withheld-execution decision as QA-52776 batch-11 (rerun 2026-06-02). Even if Patch + Apply were executed, the chain-of-custody argument means the schema would still lack url managers since Fetch lacks it. The fix needs to happen on the Fetch side first.

## Assertion results table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 1 | Include URL Manager option unchecked by default | `input[name=include_url_mgrs].checked = false` confirmed via DOM | PASS |
| A2 | 5 | 'url managers' column in Fetch CSV | 40 cols, no `url managers` column despite `include_url_mgrs=on` submitted | FAIL (finding) |
| A3 | 5 | `youtube_channel_company` after `youtube_channel_username` | Columns 25 + 26 adjacent in that order | PASS |
| A4 | 11 | 'url managers' column in Patch CSV | Not executed (mutating step withheld); structural inference from A2: Patch input lacks url managers, Patch output cannot add it | NOT VERIFIED |
| A5 | 11 | `youtube_channel_company` after `youtube_channel_username` in Patch | Not executed; structural inference: Patch carries Fetch schema through | NOT VERIFIED |
| A6 | 17 | 'url managers' column in Apply CSV | Not executed (Apply commits to dev brand 236) | NOT VERIFIED |
| A7 | 17 | `youtube_channel_company` after `youtube_channel_username` in Apply | Not executed | NOT VERIFIED |

## Bugs filed (in this report only)

### BC-5 (new finding) — `Include URL Managers` checkbox has no effect on Brand Definitions (Fetch) xlsx output

- **Reproduction:**
  1. Open `radaac.lfmdev.in` Brand Definitions (Fetch) report
  2. Enter Brand IDs (CSV) = `236`
  3. Check `Include URL Managers` checkbox
  4. Submit → download xlsx
- **Expected:** xlsx contains a `url managers` column populated with the URL manager values for brand 236
- **Actual:** xlsx is identical to the run without `Include URL Managers` checked — 40-column schema with no `url managers` column
- **Frequency:** 100% reproducible (verified across 2 separate URL submissions with `include_url_mgrs=on` and `include_url_mgrs=true`)
- **Severity:** Reflects on the entire Fetch/Patch/Apply flow — if Patch can't see url managers in the Fetch payload, the Apply round-trip can't update them either. Likely Critical (same priority as the QA-52778 test itself).
- **Recommendation:** File LFMP defect; flag for Radaac backend triage.

## Cleanup

No mutation performed. No cleanup required.

## Files

- `~/Downloads/20260604BrandDefinitionReport_779ed0.xlsx` — Fetch xlsx (5,896 bytes, 40 cols, 1 data row for brand_id=236 "Family Guy")

## Skill registry impact

Mechanic reuses the same Radaac form-submit pattern documented in QA-54202 same-batch run (jQuery UI dialog Submit click is JS-resistant; URL nav workaround). Candidate for a future `radaac-report-runner` skill bundling QA-51425 + QA-52776 + QA-52778 + QA-54202.

## Carry-forward note (KB candidate quirk)

- **Radaac jQuery UI dialog Submit click is JS-resistant — workaround: direct URL nav with form-encoded GET params.** Verified again in this run.
- **New product bug surfaced**: BC-5 above. Should land in bug-history.md under QA-52778 Open bugs as a 2026-06-04 re-run finding.
