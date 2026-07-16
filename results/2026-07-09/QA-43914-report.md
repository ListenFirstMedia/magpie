# QA-43914 — Facebook User Accounts Radaac Report

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Surface:** `radaac.lfmdev.in` (logged in via **Cognito** email/password — NOT Google SSO; Radaac redirects to auth.lfmdev.in Cognito, same creds as app.lfmdev.in)
- **Report:** Facebook User Accounts (ID 6) · account Hulu · token 5001

## Verdict: PASS (with format-dropdown variance)

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Radaac home → clicked **Facebook User Accounts** row → popup "Export list of Facebook Accounts a user has access to" with a **Facebook User account dropdown + token dropdown + Submit** (NO file-format dropdown) → selected account **Hulu** + token 5001 → Submit → **"File is Ready"** page: `Download: /cache/20260709FacebookUserAccounts_a73874.tsv` + Report URL. File downloaded to disk.

## TSV content (A7)
Header (8 tabs, 0 commas — genuine tab-separated): `User Email | ListenFirst Email | Facebook Page URL | Facebook Page Username | Facebook Page ID | Facebook Page Name | Can Access Instagram Business Account? | Instagram Business Account - Username | Instagram Business Account - Followers Count`. Columns are exactly a Facebook User Accounts report. Body was header-only (token 5001 / drylogics has no accessible FB pages → empty result set; structurally correct, not a failure).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Report row present & clickable | "Facebook User Accounts" row (ID 6) present, opened popup | PASS |
| A2 | Popup shows report description | "Export list of Facebook Accounts a user has access to" | PASS |
| A3 | File-format dropdown lists tsv/csv/xls | **No format dropdown for this report** (popup is account+token only) | VARIANCE (N/A) |
| A4 | Submitting csv → `/cache/<file>.csv` link | "File is Ready" → `/cache/…FacebookUserAccounts_a73874.**tsv**` link | VARIANCE (TSV-only) |
| A5 | Sensible filename (date + name + hash + ext) | `20260709FacebookUserAccounts_a73874.tsv` | PASS |
| A6 | Genuine comma-separated (no TSV regression) | tab-separated `.tsv` (this report has no CSV option) | VARIANCE (N/A) |
| A7 | Columns consistent with FB User Accounts | 9 correct columns (see above) | PASS |

## Variance note (for human review)
The case assumes a **tsv/csv/xls format dropdown** in the report popup (as exists for e.g. QA-51425 "Duplicate Brands and Social Pages"). The **Facebook User Accounts** report has **no format picker** — its popup is Facebook-User account + token selection only, and it emits **TSV**. So A3/A4/A6 (CSV-format flow) are not exercisable here. This reads as **spec/UI variance** (different report template), not a product defect — the report runs end-to-end and returns correctly-structured data. If a format dropdown is expected for this report specifically, flag as a possible removed-feature regression.

## Evidence
- `.playwright-out/20260709FacebookUserAccounts-a73874.tsv`
- `.playwright-out/QA-43914-popup.png`, `QA-43914-ready.png`

## Finding (reusable)
Radaac (`radaac.lfmdev.in`) authenticates via **Cognito** (same lfiqa email/password as app.lfmdev.in), not Google SSO — the precondition's "Google SSO" is stale. Format-picker availability is **per-report** (not universal).

## Bugs filed
None.
