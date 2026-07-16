# QA-43914 — Facebook User Accounts Radaac Report

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, branch `feature/playwright-mcp`)
- **Surface:** Radaac (`radaac.lfmdev.in`), report ID 6 "Facebook User Accounts"
- **Skill used:** `radaac-report` (v2, untrusted) + `radaac-report-runner` (v1, untrusted)
- **Config exercised:** account `Hulu`, token `tech.ops@listenfirstmedia.com [Token Identifier: philip.cutler@listenfirstmedia.com]` (resolved id `5084`)
- **Verdict:** **PASS (with documented deviation — report is TSV-only; the case's csv-format assertions are spec drift, not a product defect)**

---

## Steps executed

1. Navigated to `https://radaac.lfmdev.in/` → redirected to Cognito hosted UI (`auth.lfmdev.in/login`, client_id `6ep4l754u2dglosjdqggbt2mjr`). Logged in via the **"With existing account"** form (`lfiqa@listenfirstmedia.com`). Returned to Radaac home (DataTables list, 20 report rows).
2. Located report row **ID 6 "Facebook User Accounts"** (Owner Adam, defined 2017-11-02). Present and clickable.
3. Clicked the row → jQuery-UI **modal** opened, title "Facebook User Accounts", description paragraph **"Export list of Facebook Accounts a user has access to"**.
4. **File-format selection:** the modal exposes **NO file-format dropdown**. Its only inputs are an **Account Name `<select>`** (`(subscriber/account)` + ~150 accounts) and a **Token `<select>`** (`Select a token:` + tokens). Selected account `Hulu` and token `philip.cutler@listenfirstmedia.com`. (csv could not be chosen — no such control exists for this report.)
5. Clicked **Submit** → navigated to `/facebook_user_accounts?account_name=Hulu&facebook_user_accounts=5084`. Page rendered H1 "Fetching report" with a **`Download: /cache/20260711FacebookUserAccounts_fc63a8.tsv`** link + Report echo URL.
6. Clicked the download link → Playwright `download` event fired: server filename **`20260711FacebookUserAccounts_fc63a8.tsv`**, saved locally to `.playwright-out/20260711FacebookUserAccounts-fc63a8.tsv` (MCP slugifies `_`→`-` in the local path — download-tool artifact; the download **event** carries the true `_` name). Copied to `.playwright-out/QA-43914/`.
7. Inspected the file on disk (`wc`, tab/comma sniff, header parse).

---

## Evidence

**Server filename:** `20260711FacebookUserAccounts_fc63a8.tsv`
= date `20260711` + report `FacebookUserAccounts` + `_` + hash `fc63a8` + `.tsv`

**On-disk file:** `.playwright-out/QA-43914/20260711FacebookUserAccounts-fc63a8.tsv`
- Size: **228 bytes**
- Rows: **header only, 0 data rows** (token 5084 has 0 Hulu-scoped FB pages — same as the 2026-06-04 QA-4325 batch-4 run with a different token; expected, not a defect)
- Separator sniff: **8 tab chars, 0 comma chars** in the header → genuine **tab-separated**
- Header (9 columns), verbatim:
  1. `User Email`
  2. `ListenFirst Email`
  3. `Facebook Page URL`
  4. `Facebook Page Username`
  5. `Facebook Page ID`
  6. `Facebook Page Name`
  7. `Can Access Instagram Business Account?`
  8. `Instagram Business Account - Username`
  9. `Instagram Business Account - Followers Count`

Column set matches the prior verified run (2026-06-04) exactly — no schema drift.

**Screenshots/snapshots:** Playwright session snapshots under `.playwright-out/` (login form, report list, modal, "Fetching report" result page). Download artifact under `.playwright-out/QA-43914/`.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Report row "Facebook User Accounts" present + clickable | Row ID 6 present, link clickable, opened modal | PASS |
| A2 | 3 | Popup shows a description of the report | Modal shows "Export list of Facebook Accounts a user has access to" | PASS |
| A3 | 4 | File-format dropdown lists `tsv`, `csv`, `xls` | **No file-format dropdown exists** for this report; inputs are Account + Token selects only. Report is TSV-only. | **DEVIATION** (spec drift — not a product bug) |
| A4 | 5 | Submitting with `csv` → "File is Ready" page w/ `/cache/<file>.csv` link | csv not selectable; Submit produced a valid result page + `/cache/20260711FacebookUserAccounts_fc63a8.**tsv**` link | **PASS (mechanic)** / DEVIATION (`.tsv` not `.csv`) |
| A5 | 6 | Sensible filename: date prefix + report name + hash suffix + ext | `20260711FacebookUserAccounts_fc63a8.tsv` — exactly that pattern | PASS |
| A6 | 7 | File is genuine comma-separated (not tab regression) | File is tab-separated **by design** (this report has no csv option); 8 tabs / 0 commas | **N/A / DEVIATION** (report is natively TSV; the QA-51425 CSV→TSV regression concern does not apply here) |
| A7 | 7 | Columns consistent with a Facebook User Accounts report | 9 columns (User Email / ListenFirst Email / FB Page URL / Username / Page ID / Page Name / Can Access IG Business Account? / IG Username / IG Followers Count) | PASS |

**In-scope assertions (A1, A2, A5, A7) all PASS.** A3/A4/A6 are all attributable to a single fact — **this report is TSV-only and offers no csv file-format control** — which is a **spec-drift assumption in the case file** (likely templated from the Duplicate Brands report QA-51425, which *does* expose tsv/csv/xls), not a product defect.

---

## Known bugs checked

- **Case's "Open linked bugs":** the local case file lists no open-bug section; `knowledge-base/bug-history.md` QA-43914 entry = **Open bugs (0)**. Screening passed → case run normally (Rule 7).
- **bug-history.md QA-43914** documents the exact deviation seen here: "This report does NOT expose a file_format dropdown (unlike QA-51425 Duplicate Brands which has tsv/csv/xls options). Submit always produces a `.tsv`." → **reproduced, matches prior finding, not a bug.**
- **CSV→TSV regression (QA-51425, RESOLVED 2026-05-29):** not applicable — Facebook User Accounts never offered a csv path. No regression signal.
- **LFMP-30870 (Ads Account IDs Fetching→Failed cycle):** different report; not exercised. Facebook User Accounts produced its `/cache/` file cleanly with no Fetching/Failed cycling.
- **Radaac jQuery-UI Submit JS-resistance (Chrome-MCP era):** did NOT reproduce under Playwright — trusted `browser_click` on Submit navigated normally (consistent with 2026-06-28 known-quirks note). No URL-GET workaround needed.

---

## Bugs filed

None. The A3/A4/A6 deviations are a **case-file spec-drift assumption** (report described as having a tsv/csv/xls dropdown; the actual Facebook User Accounts report is TSV-only). Product behavior is correct and consistent with the 2026-06-04 verified run. Recommend the case file be corrected to reflect TSV-only output (drop the "choose csv" step and the csv-specific assertions), but per framework rules no Jira ticket is auto-created.
