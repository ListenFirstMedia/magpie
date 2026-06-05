# QA-43914 — Facebook User Accounts Radaac Report (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-43914
- **Run date:** 2026-06-04 (QA-4325 batch-4)
- **Env:** dev (`radaac.lfmdev.in`)
- **Account/Token pairing used:** Hulu + `hariharan@drylogics.com [Token Identifier: hariharan@drylogics.com]` (token id=5001)
- **Result:** **PASS** — TSV downloaded to disk, header row + tab-separated columns verified.

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-43914.md`. Note: unlike QA-51425 (Duplicate Brands and Social Pages), the Facebook User Accounts report on Radaac does NOT expose a file_format dropdown — it always submits as TSV. See "New findings" below.

## Reused skills
None directly mapped. Pattern overlaps with the QA-51425 Radaac flow but file_format selection is absent on this report. No registry credit.

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Navigate to `radaac.lfmdev.in/` → Google SSO redirect → returned auth as yash.sharma@listenfirstmedia.com | PASS |
| 2 | Click Row 6 "Facebook User Accounts" (Owner: Adam, defined 2017-11-02) | PASS — popup opened |
| 3 | Read popup description | PASS — "Export list of Facebook Accounts a user has access to" |
| 4 | Inspect form: `Facebook User` group with 2 dropdowns: (subscriber/account) — 162 accounts; (Select a token:) — 53 tokens | PASS |
| 5 | Pick account = `Hulu` (Rule 1 exact match) | PASS |
| 6 | Pick token = `5001` (`hariharan@drylogics.com`) | PASS |
| 7 | Click Submit | PASS — redirected to `/facebook_user_accounts?account_name=Hulu&facebook_user_accounts=5001` |
| 8 | Page shows "File is Ready" + Download link `/cache/20260603FacebookUserAccounts_8c53d5.tsv` | PASS |
| 9 | Click Download link | PASS — file saved to `~/Downloads/20260603FacebookUserAccounts_8c53d5.tsv` (228 bytes) |
| 10 | Inspect file on disk | PASS — 1 line (header only), tab-separated (8 tabs, 0 commas), 9 columns |

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 2 | Row "Facebook User Accounts" present & clickable | Row 6 with title "Facebook User Accounts", owner Adam, date 2017-11-02 | PASS |
| A2 | 3 | Popup with description | "Export list of Facebook Accounts a user has access to" | PASS |
| A3 | 4 | File format dropdown lists tsv/csv/xls | **N/A — this report has NO file_format selector** (departure from QA-51425). Only `account_name` and `facebook_user_accounts` (token) selectors are exposed. | DEVIATION — see findings below |
| A4 | 7-8 | Submitting produces "File is Ready" with /cache link | Page shows "File is Ready" + `/cache/20260603FacebookUserAccounts_8c53d5.tsv` (always .tsv) + "Report: …" URL | PASS |
| A5 | 9 | Sensible filename pattern | `20260603FacebookUserAccounts_8c53d5.tsv` matches `YYYYMMDDReportName_HASH.tsv` pattern (date prefix + camelcase report name + 6-char hash + `.tsv`) | PASS |
| A6 | 10 | File separator integrity | First (header) line contains 8 tab characters and 0 commas. Genuine TSV. | PASS |
| A7 | 10 | Columns are FB-user / page / IG-business-account oriented | 9 columns: `User Email`, `ListenFirst Email`, `Facebook Page URL`, `Facebook Page Username`, `Facebook Page ID`, `Facebook Page Name`, `Can Access Instagram Business Account?`, `Instagram Business Account - Username`, `Instagram Business Account - Followers Count` | PASS |

## Bugs filed
None.

## New findings (non-blocking)

1. **Facebook User Accounts report has no file_format selector.** Unlike `Duplicate Brands and Social Pages` (QA-51425) which exposes a `<select name="file_format">` with tsv/csv/xlsx options, this report's submit form contains only `account_name` and `facebook_user_accounts` (token id). The download is always TSV. This is a per-report variance in Radaac — likely intentional, but worth noting in case product expectations call for a format choice.
2. **Token + account scoping returns zero data rows for unmatched pairings.** Picking Hulu + a token whose owner has no Hulu FB Pages returned just the header row (0 data rows, 228 bytes). This is expected behavior — the report enumerates pages the **token holder** has access to, scoped to the chosen LFM account. The token I picked has no Hulu-scoped FB Pages. Acceptable; documenting so future runs don't false-fail on empty result.

## Files
- `testcases/english/QA-43914.md` (spec)
- `runs/2026-06-02/QA-43914-report.md` (this report)
- `/Users/yashsharma/Downloads/20260603FacebookUserAccounts_8c53d5.tsv` (228 bytes — header-only TSV; verified end-to-end)
- Scratch copy: `outputs/qa-43914/20260603FacebookUserAccounts_8c53d5.tsv`
