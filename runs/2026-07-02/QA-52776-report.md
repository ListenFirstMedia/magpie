# QA-52776 — Brand Definition Update - Exclude URL Manager

- **Run date:** 2026-07-03 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-52776 · Priority: Critical
- **Result:** **PASS** — the 'url managers' column is absent from all three report xlsx files (Fetch, Patch, Apply) for brand 236.
- **App:** Dev Radaac (`radaac.lfmdev.in`) · **Brand:** 236 (Family Guy) · **Report options:** "Include URL Managers" left **unchecked** on Patch and Apply (exclude path).
- **Skills:** radaac-report (v1)

## Linked bug scan
No **open** linked bugs — [[open-bug-auto-fail]] N/A. All linked defects are Closed: the recurring "Radaac – Brand Definitions (Fetch) – Export failed to download" (APPS-49038, APPS-50449, APPS-53699, APPS-55527), APPS-53077 "502 Gateway Error on Dev Radaac", and APPS-42854 (QA task). None reproduced this run — Fetch/Patch/Apply all generated and downloaded cleanly.

## Steps executed
1. Radaac → **Brand Definitions (Fetch)**. ✅
2. **Brand IDs (CSV)** = `236`. ✅
3. **Submit** → report generated; "File is Ready". ✅
4. Downloaded Fetch xlsx (`20260703BrandDefinitionReport_a40a30.xlsx`) — this is the "saved file" for step 5–8. ✅
5. Radaac Home. ✅
6. **Brand Definitions (Patch)** (Include URL Managers unchecked). ✅
7. Uploaded the Fetch xlsx via Choose file. ✅
8. **Submit** → Patch xlsx generated. ✅
9. Downloaded Patch xlsx (`20260703PatchBrandDefinitionReport_99a10e.xlsx`). ✅
10. Radaac Home. ✅
11. **Brand Definitions (Apply)** (Include URL Managers unchecked). ✅
12. Uploaded the Patch xlsx via Choose file. ✅
13. **Submit** → Apply committed to brand 236 and generated the Apply xlsx (**mutation — user-approved before running**; patch had no manual edits, so it wrote brand 236's own values back = effective no-op round-trip on Dev). ✅
14. Downloaded Apply xlsx (`20260703ApplyBrandDefinitionReport_e2aa63.xlsx`). ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 (Fetch xlsx) | 'url managers' column not displayed | 40 columns `brand_id`…`last_reviewed`; no `url_manager(s)` anywhere | ✅ PASS |
| A9 (Patch xlsx) | 'url managers' column not displayed | `record_type` + same 40 brand-def columns; no `url_manager(s)` | ✅ PASS |
| A14 (Apply xlsx) | 'url managers' column not displayed | `record_type` + same 40 brand-def columns (brand 236, Family Guy, record_type `INGESTED`); no `url_manager(s)` | ✅ PASS |

## Evidence (verified on disk, xlsx unzipped → xl/sharedStrings.xml)
- `.playwright-out/20260703BrandDefinitionReport-a40a30.xlsx` (Fetch; server name uses `_`, Playwright saves `-`).
- `.playwright-out/20260703PatchBrandDefinitionReport-99a10e.xlsx` (Patch).
- `.playwright-out/20260703ApplyBrandDefinitionReport-e2aa63.xlsx` (Apply).
- Column set (all three): brand_id, title, title_created_date, title_category, title_sub_category, genre, primary_genre, iso_mic, stock_exchange, ticker_symbol, companies, brand_set, composite_brand_set, active, released_on, domestic_opening_weekend_box_office, domestic_opening_weekend_screens, domestic_opening_weekend_rank, street_date, network, facebook_page, facebook_verified, twitter_handle, twitter_verified, instagram_user, youtube_channel_username, youtube_channel_company, tiktok_user, linkedin_page, threads_page, pinterest_user_username, pinterest_board, wikipedia_page, rottentomatoes, imdb_id, metacritic, twitter_search_terms, instagram_business_hashtags, twitter_search_term_keywords, last_reviewed. Patch/Apply prepend `record_type`. **No `url managers` / `url_managers` column in any file.**

## Notes / findings
- **Include URL Managers checkbox** (`input[name=include_url_mgrs]`, default unchecked) on both Patch and Apply forms is the toggle under test — leaving it unchecked (the "Exclude URL Manager" path) correctly omits the column.
- **Download quirk (Brand Definition reports):** unlike other Radaac reports that auto-download on Submit, these render a result page with a `Download: /cache/…xlsx` link. Clicking the link **navigates to the xlsx URL as a page** (no MCP download event fired). Reliable capture: `fetch(cacheUrl,{credentials:'include'})` → Blob → programmatic `<a download>` click, which triggers the MCP download handler and saves to `.playwright-out/`. (Server filenames use `_`; Playwright sanitizes `_`→`-` locally — consistent with other Radaac reports.)
- **Patch = transform (download-only); Apply = mutation** that commits to brand 236. A14 requires running Apply; user approved before it ran.

## Bugs filed
None. All three assertions passed.
