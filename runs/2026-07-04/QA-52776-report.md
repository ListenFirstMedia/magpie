# QA-52776 — Brand Definition Update - Exclude URL Manager

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless), real Chrome, `app.lfmdev.in` + `radaac.lfmdev.in`
- **Login identity:** `lfiqa@listenfirstmedia.com` (config/.env, email/password Cognito path)
- **Component:** Radaac — Brand Definitions Fetch → Patch → Apply
- **Skill reused:** `radaac-report-runner` (v1)
- **Open-bug screen:** "None open" → ran normally (Rule 7 pass)
- **Verdict:** **PASS (3/3)** — `url managers` column absent from Fetch, Patch, and Apply xlsx.

## Preconditions
- Pre-flight: logged into `app.lfmdev.in`, `#home` rendered (title "Home - ListenFirst"). PASS.
- Navigated to `radaac.lfmdev.in`; Cognito/Google SSO carried over silently, report list (20 rows) rendered as `lfiqa@listenfirstmedia.com`.

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Search/select "Brand Definitions (Fetch)" | Dialog opened (jQuery-UI), action `GET /brand_definition_report` |
| 2 | Add "236" in Brand IDs (CSV) | `brand_ids=236` confirmed; Include URL Managers left UNCHECKED (spec = "Exclude") |
| 3 | Click Submit | Navigated to `/brand_definition_report?...&brand_ids=236` (no `include_url_mgrs` param) → "Fetching report" |
| 4 | Open/save downloaded xlsx | Cache race ("File not found") → waited + retried; download event fired → `.playwright-out/20260703BrandDefinitionReport-b10f16.xlsx` (server name `..._b10f16.xlsx`) |
| 5 | Radaac Home | Re-navigated to `radaac.lfmdev.in` |
| 6 | Search/select "Brand Definitions (Patch)" | Dialog opened, action `POST /patch_brand_definition_report` (multipart) |
| 7 | Choose file → upload saved Fetch xlsx | Uploaded `20260703BrandDefinitionReport-b10f16.xlsx` via file chooser (1 file attached); Include URL Managers UNCHECKED |
| 8 | Click Submit | Navigated to `/patch_brand_definition_report` → "Fetching report" |
| 9 | Open downloaded xlsx | Cache race → waited + retried → `.playwright-out/20260703PatchBrandDefinitionReport-0855a9.xlsx` |
| 10 | Radaac Home | Re-navigated |
| 11 | Search/select "Brand Definitions (Apply)" | Dialog opened, action `POST /apply_brand_definition_report` (multipart) — **mutating** step, authorized by task |
| 12 | Choose file → upload Patch xlsx | Uploaded `20260703PatchBrandDefinitionReport-0855a9.xlsx` (1 file attached); Include URL Managers UNCHECKED |
| 13 | Click Submit | Navigated to `/apply_brand_definition_report` → "Fetching report" (no 502 this run) |
| 14 | Open downloaded xlsx | Waited ~13s → "File is Ready" → download event fired → `.playwright-out/20260703ApplyBrandDefinitionReport-a15b1e.xlsx` |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | `url managers` column NOT in Fetch xlsx | Header = 40 cols (`brand_id`…`last_reviewed`); no `url*manager*` string anywhere in file | **PASS** |
| A2 | 9 | `url managers` column NOT in Patch xlsx | Header = `record_type` + 40 Fetch cols (41 total); no `url*manager*` string anywhere | **PASS** |
| A3 | 14 | `url managers` column NOT in Apply xlsx | Header = `record_type` + 40 Fetch cols (41 total); no `url*manager*` string anywhere | **PASS** |

## Evidence

- **Fetch xlsx** (`20260703BrandDefinitionReport-b10f16.xlsx`, 5896 B) header columns:
  `brand_id, title, title_created_date, title_category, title_sub_category, genre, primary_genre, iso_mic, stock_exchange, ticker_symbol, companies, brand_set, composite_brand_set, active, released_on, domestic_opening_weekend_box_office, domestic_opening_weekend_screens, domestic_opening_weekend_rank, street_date, network, facebook_page, facebook_verified, twitter_handle, twitter_verified, instagram_user, youtube_channel_username, youtube_channel_company, tiktok_user, linkedin_page, threads_page, pinterest_user_username, pinterest_board, wikipedia_page, rottentomatoes, imdb_id, metacritic, twitter_search_terms, instagram_business_hashtags, twitter_search_term_keywords, last_reviewed` — data row for brand 236 = "Family Guy". No `url_managers`.
- **Patch xlsx** (`20260703PatchBrandDefinitionReport-0855a9.xlsx`, 7326 B): same 40 columns prefixed by `record_type` (value `INGESTED`). No `url_managers`.
- **Apply xlsx** (`20260703ApplyBrandDefinitionReport-a15b1e.xlsx`, 7328 B): `record_type` + same 40 columns (`INGESTED`, 236, Family Guy). No `url_managers`.
- Verification method (Rule 6): each xlsx was downloaded to disk via a real Playwright `download` event, then parsed from the saved bytes (`xl/sharedStrings.xml`). A case-insensitive search for any string containing both "url" and "manager" returned empty in all three files — confirming absence beyond just the header row.

Screenshots/snapshots for each step under `.playwright-out/` (page-*.yml auto-captured per action; e.g. Fetch "File is Ready" `page-2026-07-03T23-10-13-118Z.yml`, Apply `page-2026-07-03T23-13-48-421Z.yml`).

## Notes / observed quirks (matched known-quirks 2026-06-28 entry)
- Radaac dialogs are pre-rendered as hidden jQuery-UI dialogs (one per report); must target the *visible* dialog. The skill's `input[name="brand_ids"]` global querySelector hit a hidden Fuzzy Brand Match dialog — scope to the visible `.ui-dialog`.
- Trusted `browser_click` on Submit works (GET for Fetch; multipart file upload for Patch/Apply). URL-GET workaround not needed.
- Cache-file race reproduced for Fetch and Patch ("File not found. Some reports require a bit more time.") — resolved with one wait + re-click each (well within the 5-min budget). Apply resolved after ~13s wait, first click.
- On-disk filenames slugify `_hash` → `-hash`; server-emitted names keep the underscore. Asserted against server names.
- Apply transient 502 (documented as one-off) did **not** reproduce this run — Apply succeeded on first Submit.

## Bugs filed
None. All three assertions pass; product behavior correct (URL Managers correctly excluded when the checkbox is unchecked across Fetch/Patch/Apply).
