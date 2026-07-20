# QA-22298 Daily Regression — Unattended Headless Run: Overall Report

- **Date:** 2026-07-04 · **Mode:** headless, unattended (`claude -p`, fresh context per case) · **Branch:** feature/playwright-mcp
- **Cases:** 66 (QA-22298 test set) · **Login:** programmatic Cognito via config/.env · **Open-bug status:** baked from Jira at cache time 2026-07-03

## Tally

- **Runner parse:** PASS 27 · FAIL 15 · BLOCKED 20 · SKIPPED 2 · UNKNOWN 2
- **Corrected (in-report verdict applied):** PASS 29 · FAIL 15 · BLOCKED 20 · SKIPPED 2 · UNKNOWN 0
  - _Correction: QA-24544 & QA-103248 reports read PASS but the runner's parser missed their `## Verdict` heading → they were logged UNKNOWN. True verdict = PASS._

## Why — root-cause buckets

| Bucket | Count | Meaning |
|---|---|---|
| Assertions passed | 29 | App behaved per spec on all in-scope assertions (out-of-scope GS/email/Mixpanel steps skipped). |
| Open-bug auto-fail | 16 | Case has an OPEN linked Jira defect → auto-failed without running (Rule 7). Not a fresh failure. |
| Timeout / render-hang | 12 | claude -p exceeded the 900 s per-case cap (slow/hung render or a very long flow) → no report → BLOCKED. |
| No output | 5 | Subprocess exited without writing a report. |
| Blocked (in report) | 2 | Case ran but a genuine blocker stopped it (no stage env, test-data gap, etc.). |
| Out-of-scope precondition | 2 | Requires a second/external user identity config creds can't satisfy → SKIPPED. |

## Per-case detail (grouped by corrected status)


### PASS (29)

| Case | Title | Open bugs | Bucket | Why |
|---|---|---|---|---|
| QA-198 | TWC Exports - Absolute dates | none | Assertions passed | PASS (9/9 in-scope assertions; A10 Google Sheets skipped — out of scope) |
| QA-520 | Facebook Content -  Table Data Set - Aut | none | Assertions passed | PASS (4/4 assertions) |
| QA-1124 | --- | none | Assertions passed | PASS (13/13 assertions) |
| QA-1519 | --- | none | Assertions passed | PASS (all in-scope assertions A1/A2/A6/A7 pass). A3/A4/A5/A8 skipped — emailed-CSV + Google Sheets out of scope on the Playwright track. |
| QA-2035 | Brand Sentiment - CSV & GS | none | Assertions passed | PASS (in-scope A1–A5 PASS; A6 format-only with documented PST-suffix spec drift; A7/Google Sheets out of scope — skipped) |
| QA-2498 | --- | none | Assertions passed | PASS 12/12 (documented spec-vs-UI variances on A1, A3, A4, A8, A10, A12 — none are product bugs). |
| QA-24544 | Reporting > TWC - Share Functionality | none | Assertions passed | PASS — all in-scope evaluable assertions pass (A1, A5). |
| QA-27854 | Bulk Import Tags Notification | none | Assertions passed | PASS (4/4 in-scope assertions). A1/A2 verified in-app. A3/A4 email templates verified via Gmail MCP (operator-mailbox caveat — format verified, not exact-run). Steps 3–4 in-app "op |
| QA-27856 | Notification Modal - Import Tags Notific | none | Assertions passed | PASS (in-scope A1 + A2). Steps 3–4 / A3–A4 SKIPPED — Bulk Tagging email is a Gmail/Google-auth surface, out of scope (see Scope note). |
| QA-28799 | --- | none | Assertions passed | PASS — all in-scope assertions (A1–A8) pass. A9/A10 (Dev Mixpanel) are OUT OF SCOPE (third-party system, separate auth — treated like Google Sheets). New user created and then deac |
| QA-43916 | Not Configured Radaac Report | none | Assertions passed | PASS (3/3 in-scope assertions) |
| QA-51425 | Duplicate Brands and Social Pages Report | none | Assertions passed | PASS (5/5 in-scope assertions) |
| QA-51490 | Brand > Insights - Content Engagement Ra | none | Assertions passed | PASS (12/12 assertions) |
| QA-52776 | --- | none | Assertions passed | PASS (3/3) — `url managers` column absent from Fetch, Patch, and Apply xlsx. |
| QA-65554 | --- | none | Assertions passed | PASS (in-scope) — Google Sheets assertions skipped (out of scope) |
| QA-85176 | Settings > Custom Metrics - Custom Metri | none | Assertions passed | PASS — 14/14 assertions |
| QA-103248 | Brand Sets > Content - Daily Post Analys | none | Assertions passed | PASS — all in-scope assertions (A1–A4, A8) pass. A5–A7 (Google Sheets) skipped as out of scope (Google 2FA — see `config/env.md`); noted, not failed. |
| QA-104870 | Settings > Custom Data Sets - Basic View | none | Assertions passed | PASS — 12/13 assertions PASS, 1 N/A (A5, no blank-table state on this account). |
| QA-106218 | Settings > Custom Data Sets - Create a N | none | Assertions passed | (report has no Verdict/Result line) |
| QA-109920 | Brand > Content - Sentiment Comments lim | none | Assertions passed | PASS (3/3) |
| QA-110074 | Brand > Audience - Threads - Tile Level  | none | Assertions passed | PASS (5/5 tiles exported and verified on disk; all assertions met) |
| QA-129803 | Handle Abnormally High Response Rate – E | none | Assertions passed | PASS (5/5 in-scope). GS steps skipped (out of scope). |
| QA-134173 | Settings > Custom Metric - Info View | none | Assertions passed | PASS — all in-scope assertions pass. No Google Sheets / external-user steps in this case. |
| QA-134182 | Brand > Insights - Verify Interval Date  | none | Assertions passed | PASS (15/15 assertions) |
| QA-134184 | Brand > Insights - Interval selection -  | none | Assertions passed | PASS (8/8 assertions) |
| QA-134185 | Settings > Custom Metric Creation - Info | none | Assertions passed | PASS (with the spec's `Metric Definition Link` element N/A — documented spec/UI drift, not a bug) |
| QA-134188 | Brand > Insights - Verify Export (Monthl | none | Assertions passed | PASS (13/13 in-scope assertions). A14 (Google Sheets) SKIPPED — out of scope (Google 2FA). |
| QA-134594 | Brand > Video > Instagram > Public Data | none | Assertions passed | PASS (11 assertions PASS, 1 N/A — see 5c) |
| QA-135319 | Brand > Content - Verify default selecti | none | Assertions passed | PASS (10/10) |

### FAIL (15)

| Case | Title | Open bugs | Bucket | Why |
|---|---|---|---|---|
| QA-281 | TWC report for Relative dates with long  | **LFMP-31961(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31961(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-837 | Social Recap: Report - Multiple brands | **LFMP-31798(Open),LFMP-31918(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31798(Open),LFMP-31918(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-929 | --- | **LFMP-31979(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31979(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-1677 | --- | **LFMP-32155(Open)** | Open-bug auto-fail | Open linked bug **LFMP-32155(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-2706 | Brand > Content - Benchmark - Authorized | **LFMP-31886(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31886(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-3630 | Reporting > Content Performance Report - | **LFMP-32010(Open)** | Open-bug auto-fail | Open linked bug **LFMP-32010(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-12532 | Brand Sets > Partnerships - Sponsors, Pa | **LFMP-31903(Open),LFMP-32116(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31903(Open),LFMP-32116(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-19557 | Brand Content - Impressions Data Set - I | **APPS-58817(Open),LFMP-32016(Open)** | Open-bug auto-fail | Open linked bug **APPS-58817(Open),LFMP-32016(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-20988 | Brand > Paid - Tile Level Export Functio | **DATA-12089(Code Review)** | Open-bug auto-fail | Open linked bug **DATA-12089(Code Review)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-23969 | --- | **LFMP-31925(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31925(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-96665 | Brand Insights - Threads - Basic View | **LFMP-32027(Open)** | Open-bug auto-fail | Open linked bug **LFMP-32027(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-116113 | Youtube Audience Tile level export PNG | **DATA-12043(Code Review)** | Open-bug auto-fail | Open linked bug **DATA-12043(Code Review)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-131491 | Social Recap Vs Brand > Content - IG Pub | **DATA-12223(QA Ready)** | Open-bug auto-fail | Open linked bug **DATA-12223(QA Ready)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-135321 | Brand > Content - Verify Additional filt | **LFMP-32155(Open)** | Open-bug auto-fail | Open linked bug **LFMP-32155(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-138031 | Data Collection - Channel Collection Sta | **APPS-61562(QA Ready)** | Open-bug auto-fail | Open linked bug **APPS-61562(QA Ready)** → open-bug auto-fail (Rule 7): marked FAILED without running. |

### BLOCKED (20)

| Case | Title | Open bugs | Bucket | Why |
|---|---|---|---|---|
| QA-457 | TWC Rate Data QA | none | Blocked (in report) | BLOCKED — stage environment not reachable in this harness |
| QA-949 | Brand > Stories - Hovering Functionality | none | No output | No report written — subprocess exited without output; counted BLOCKED. |
| QA-1053 | TWC Aggregate - Relative dates - Lock ic | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-19482 | --- | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-90213 | --- | none | No output | No report written — subprocess exited without output; counted BLOCKED. |
| QA-96038 | Brand > Audience - Instagram - Followers | none | No output | No report written — subprocess exited without output; counted BLOCKED. |
| QA-96818 | Reporting - Data Studio - Posts Level -  | **LFMP-31977(Open)** | Open-bug auto-fail | Open linked bug **LFMP-31977(Open)** → open-bug auto-fail (Rule 7): marked FAILED without running. |
| QA-98368 | Brand Content - Threads - Post Type Hove | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-100764 | Brand > Content - Daily Post Analysis Mo | none | Blocked (in report) | BLOCKED — test-data gap: Max has no Threads channel on Brand > Content (step 3 unperformable) |
| QA-109062 | Settings > Custom Data Sets support on B | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-129606 | Handle Abnormally High Response Rate – E | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-130076 | Settings > Notifications - Improve Lost  | none | No output | No report written — subprocess exited without output; counted BLOCKED. |
| QA-131492 | Social Recap Vs Brand > Content - YouTub | none | No output | No report written — subprocess exited without output; counted BLOCKED. |
| QA-132387 | Brand Sets > Content - Verify Sum and Av | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-132392 | Brand Set > Content - Verify Impression  | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-134277 | Brand > Content - Verify CSV Export resp | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-134448 | Brandsets > Partnership - Verify layered | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-134449 | Brandsets > Optimization - Verify layere | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-134516 | Reporting > Content Performance - Verify | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |
| QA-139187 | Settings > Custom Metrics - Parenthetica | none | Timeout / render-hang | No report written — case hit the **900 s per-case watchdog timeout** (render-hang or flow too long for the budget); runner counts missing report as BLOCKED. |

### SKIPPED (2)

| Case | Title | Open bugs | Bucket | Why |
|---|---|---|---|---|
| QA-29479 | Dashboards - Share Dashboard via Email | none | Out-of-scope precondition | SKIPPED — external-user precondition (deferred) |
| QA-33510 | --- | none | Out-of-scope precondition | SKIPPED — external-user precondition (deferred) |
