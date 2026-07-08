---
name: radaac-report
version: 2
last_verified: 2026-07-03
last_passed_run: 2026-07-03
trust: untrusted
pass_streak: 3
preconditions: [lfm-credentials-available]
postconditions: [radaac-report-tsv-downloaded]
inputs: [report_name, account_name]
outputs: [tsv_path, tsv_header]
related_pages: ["https://radaac.lfmdev.in/"]
---

# Radaac — Raw Data Access Console reports (TSV download)

Radaac (`radaac.lfmdev.in`, "raw data access console") is a **separate app** from the LFM platform. It hosts operational reports (Not Configured, Duplicate Brands and Social Pages, Brand Definitions, etc.) that generate **direct TSV downloads**. Used by QA-43916, QA-51425, and other Radaac (Test Plan QA-19 "Raddac") cases.

## Login (separate OAuth client — no SSO from the LFM app)
Navigating to `https://radaac.lfmdev.in/` when only the LFM-app session exists **redirects to `auth.lfmdev.in/login`** with a different `client_id` (observed `6ep4l754u2dglosjdqggbt2mjr`). Same Cognito realm, so the configured test user works:
1. On the hosted sign-in, use the **"With existing account"** form — `input[name="username"]` (email) + `input[name="password"]`. (There's also a Corporate-email/SSO field `input[name="idpEmail"]` — do NOT use it.)
2. Fill `LFM_EMAIL` / `LFM_PASSWORD` from `config/.env` (currently `lfiqa@listenfirstmedia.com`). `browser_type`/`fill` works on these fields.
3. Click that form's **Sign in** (the button inside the password field's `<form>`; there are two "Sign in" buttons — pick the existing-account one). Redirects back to `radaac.lfmdev.in`.

## Run a report
1. The Radaac home is a DataTables list: columns ID / Report Name / Owner / Report defined date, with a **Search** box. Click the report's **Report Name** link (an `<a href="#">`), e.g. "Not Configured" (#14), "Duplicate Brands and Social Pages" (#16).
2. A **modal** opens with the report's parameters. For account-scoped reports it has an **Account Name `<select>`** (first option `(subscriber/account)`, then ~150 account names; option `value` == the account name, e.g. `Michael Kors`). Use `browser_select_option`.
   - ⚠ The page also has a DataTables **"Show N entries"** `<select>` (options 10/25/50/100) — ignore it; pick the select whose options include `(subscriber/account)` / the account names.
3. Click **Submit** → navigates to `/{report_slug}?account_name=<Name>` and the **TSV downloads** to the MCP `--output-dir` (`.playwright-out/`), synchronously (no email).

## Brand Definitions (Fetch / Patch / Apply) — the exclude-URL-Manager trio
These three reports form a round-trip and behave differently from the account/file-format reports above (used by QA-52776 "Exclude URL Manager"):
- **Fetch** (`/brand_definition_report`): parameter inputs are named text fields — `input[name=brand_ids]` (Brand IDs CSV), plus `company_ids` / `brandset_ids` / `compset_ids`. Enter the brand id(s), Submit → generates the brand-definition xlsx. Columns: `brand_id … last_reviewed` (~40, e.g. for brand 236 Family Guy).
- **Patch** (`/patch_brand_definition_report`) and **Apply** (`/apply_brand_definition_report`): each visible `<form>` has an `input[type=file]` (name `file`) + a **`input[name=include_url_mgrs]` "Include URL Managers" checkbox (default unchecked = the exclude path)**. Upload the prior xlsx (Fetch's for Patch; Patch's for Apply), Submit. Patch/Apply xlsx prepend a `record_type` column (value `INGESTED`) to the same brand-def columns.
- **File upload:** the file input is present but the MCP `browser_file_upload` needs modal state — **click the file input first** (opens the OS file chooser → "Modal state: File chooser"), *then* call `browser_file_upload`.
- **Patch = download-only transform (safe). Apply = MUTATION** — it commits the brand-definition changes to the real brand on Dev. Get explicit user approval before running Apply. (With an unedited patch it writes the brand's own values back = effective no-op, but still a write.)
- Assertion for all three: the **'url managers' column must NOT appear** in the xlsx (verify by unzipping → `xl/sharedStrings.xml`, grep for `url[_ ]manager`).

### ⚠ Brand Definition reports don't auto-download — capture via blob
Unlike the account/file-format reports (which download on Submit), Fetch/Patch/Apply render a **result page** with a `Download: /cache/YYYYMMDD<Report>_<hash>.xlsx` link. **Clicking that link navigates to the xlsx URL as a page — no MCP download event fires, nothing saves.** Reliable capture (in `browser_evaluate`):
```js
const r = await fetch('/cache/…_hash.xlsx', {credentials:'include'});
const blob = await r.blob();
const a = document.createElement('a'); a.href = URL.createObjectURL(blob);
a.download = '…_hash.xlsx'; document.body.appendChild(a); a.click();
```
This triggers the MCP download handler → file lands in `.playwright-out/`. (Do NOT hand-copy base64 out of `browser_evaluate` — it gets mangled/padding-broken.)

## Verify the TSV (on disk)
- Filename pattern: `YYYYMMDD<ReportName>_<hash>.<ext>`, e.g. server name `20260703NotConfigured_72519b.tsv` / `20260703DuplicateBrandSocialPages_8b0b04.csv`. **The server filename uses an underscore `_` before the hash (matches the case specs).** ⚠ The Playwright MCP **sanitizes `_`→`-` in the LOCAL saved path** (so `.playwright-out/` shows `...-72519b.tsv`) — that hyphen is a download-tool artifact, NOT app behavior. To read the true server filename, check the download **event** line ("Downloading file …_hash.ext"), not the on-disk name. Hash is per-generation.
- File-format reports (Duplicate Brands) have a **File Format `<select>`** with `tsv/csv/xls`; account reports (Not Configured) have the Account Name select instead. Some reports (Duplicate Brands) also show a **description popup** whose text is an assertion target.
- Read the header line and assert the column set/order. Not-Configured (TSV): `subscriber_id, subscriber_name, brand_id, brand_name, data_profile_dcs_uid, data_profile_channel_type, data_profile_source_type, data_profile_display_name, data_profile_url, authorized_accounts, total_authorized_accounts`. Duplicate Brands and Social Pages (CSV): `brand id, brand name, title category, channel, url, perspective` (no "duplicate" column; ~15k rows; excludes same-name pairs, includes cross-brand shared pages e.g. IG "007" Standard vs Extended).

## Failure signatures
| Signature | Interpretation | Action |
|---|---|---|
| radaac.lfmdev.in redirects to auth and stays there | Not logged into Radaac | Do the existing-account login above |
| Grabbed a 4-option select (10/25/50/100) | That's the DataTables length selector | Pick the select containing `(subscriber/account)` |
| No TSV in output-dir after Submit | Report still generating, or download blocked | Wait a few s; confirm URL changed to `/{report}?account_name=` |
| Brand Definition report: clicked Download link, no file saved | Link navigates to the xlsx URL as a page — MCP never captures it | Use the fetch→Blob→`<a download>` capture (above) instead of clicking the link |
| `browser_file_upload` errors "can only be used when there is related modal state" | File chooser not open | Click the `input[type=file]` first, then call `browser_file_upload` |

## Changelog
- **v2** (2026-07-03): Added the **Brand Definitions Fetch/Patch/Apply** trio from QA-52776 (Exclude URL Manager, PASS): named text inputs (`brand_ids`), `include_url_mgrs` checkbox (default unchecked = exclude), file-upload flow (click file input → chooser → `browser_file_upload`), `record_type` prepended column, Patch=transform / **Apply=mutation (needs approval)**. Documented the **blob-download workaround** — these reports render a `/cache/…xlsx` Download link that navigates-as-page instead of downloading; capture via `fetch(...,{credentials:'include'})`→Blob→programmatic `<a download>` click. +1 streak (QA-52776).
- **v1** (2026-07-02): Initial skill from QA-43916 (Not Configured → Michael Kors TSV, PASS) + QA-51425 (Duplicate Brands and Social Pages → CSV, PASS). Radaac separate-OAuth login + report list + report modal (Account-Name-select OR File-Format-select + description popup) + Submit → TSV/CSV download → on-disk verification. **Corrected:** server filenames use underscore `_` before the hash (matches specs); Playwright MCP sanitizes `_`→`-` in the local saved path (artifact) — read the download event for the true name. +2 streak (QA-43916, QA-51425).
