# QA-43915 — Ads Account IDs Radaac Report

- **Date:** 2026-06-08 (batch 4/12 of QA-22296)
- **Source spec:** Jira QA-43915 (title + 1-line description only)
- **Skill mapped:** none yet — Radaac flow extends `radaac-report-runner` pattern (still not authored as skill; see known-quirk Radaac jQuery UI dialog Submit JS-resistant)
- **Bug history (Closed):** LFMP-30870 (Radaac - Ads Account IDs - The Export failed to download), APPS-53077 (502 Gateway Error on Dev Radaac)

## Result: FAIL — backend stuck in "Fetching report" → "Failed to process." cycle (REPRODUCES LFMP-30870)

## Execution
1. Login confirmed at `app.lfmdev.in` (Adam Orfei account_id=54).
2. Navigated to `radaac.lfmdev.in/` — Cognito sign-in via Google SSO → returned authenticated as yash.sharma@listenfirstmedia.com.
3. Confirmed the Ads Account IDs report row exists (row 10, owner=Kara, defined 2018-08-26).
4. Clicked row → modal opens with title "Ads Account IDs" and description "Retrieves Facebook, Twitter and Tiktok Ads account IDs for Ad accounts we have authentication for."
5. Modal form action = `https://radaac.lfmdev.in/ads_account_ids`, method=GET. Inputs verified: `subscriber_name` (select), `pda` (select), `file_format` (select; default `tsv`), `column_headers` (checkbox=on default), `cache` (checkbox=on default).
6. Submitted via direct URL navigation (per known-quirk for Radaac jQuery UI dialog Submit JS-resistance):
   `https://radaac.lfmdev.in/ads_account_ids?subscriber_name=&pda=&file_format=csv&column_headers=on&cache=on`
7. Page rendered with H1 "Fetching report" + visible download link `/cache/20260608AdsAccountIds_bceac0.csv` (cached filename surfaced immediately).
8. Clicked the download link → page navigated to `/cache/20260608AdsAccountIds_bceac0.csv` showing body text "File not found. Some reports require a bit more time."
9. Waited 30s → reload of `/ads_account_ids?...` page. Page transitioned from "Fetching report" → page TITLE flipped to "Failed to process."
10. Re-reload — page cycled back to H1 "Fetching report" but title kept jumping to "Failed to process." across reload events.
11. Waited additional 40s + 30s = ~100s total. File never materialized at `/cache/20260608AdsAccountIds_bceac0.csv`. ~/Downloads has no `20260608AdsAccountIds*.csv` after the multi-minute wait window.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Modal opens with description text | Description text matches verbatim | PASS |
| A2 | 4 | Filter inputs present | subscriber_name, pda, file_format (default tsv), column_headers, cache — all 5 form inputs present | PASS |
| A3 | 6-11 | Download link produces a saved file | Download link surfaces `/cache/20260608AdsAccountIds_bceac0.csv` but the file never materialises; clicking returns "File not found. Some reports require a bit more time." and reloads cycle to "Failed to process." page title | **FAIL** |
| A4 | 11 | CSV content well-formed | Not reachable — no file delivered | NOT VERIFIED |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| LFMP-30870 (Closed) — Radaac - Ads Account IDs - The Export failed to download | **REPRODUCES** | Same failure mode. The cached filename is reported in the page DOM but the binary never lands on disk. Page title oscillates between "Fetching report" and "Failed to process." over ~100s, indicating a backend job-runner failure for this specific report. The 2018-vintage Closed status of LFMP-30870 suggests an old fix that has regressed. |
| APPS-53077 (Closed) — 502 Gateway Error | NOT REPRODUCED | Page reaches `/ads_account_ids` and renders normally; no 502. |

## New findings

- Page title flips to "Failed to process." after the "Fetching report" timeout window, then reloading the page resets H1 back to "Fetching report" and re-cycles. The browser tab title and the H1 are out of sync — H1 stays on "Fetching report" while the OG title is set to "Failed to process." inside `<head>`. This is a UI defect-shaped artifact of the underlying backend job failure.
- The cached filename appears in the DOM (`/cache/20260608AdsAccountIds_bceac0.csv`) before the report finishes producing — likely the job-scheduler stamps the eventual filename ahead of execution, so a click during the lag returns "File not found" rather than a queued/loading state.

## Files
- `/Users/yashsharma/git/magpie/testcases/english/QA-43915.md` (inferred spec)
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-43915-report.md` (this report)

## Bugs filed
- None new (LFMP-30870 reproduces — should be re-opened by triage if this matches their original repro).
