# QA-22298 Daily Regression — Combined Overall Report (all 66)

- **Runs overlaid (latest wins):** 2026-07-04 unattended (66) → 2026-07-07 interactive recovery (7) → 2026-07-08 unattended recovery (10).
- **Status source:** each run's summary.json (authoritative parse); reason text from the case report. Open-bug status baked from Jira 2026-07-03.

## Final tally (66)

**PASS 40 · FAIL 15 · BLOCKED 9 · SKIPPED 2 · UNKNOWN 0**

## Root-cause buckets

| Bucket | Count |
|---|---|
| Assertions passed | 40 |
| Open-bug auto-fail | 15 |
| Blocked | 9 |
| Out-of-scope precondition | 2 |

## Per-case detail (grouped by final status)

### PASS (40)

| Case | Title | Run | Open bugs | Why |
|---|---|---|---|---|
| QA-198 | TWC Exports - Absolute dates | 07-04 | none | PASS (9/9 in-scope assertions; A10 Google Sheets skipped — out of scope) |
| QA-520 | Facebook Content -  Table Data Set - | 07-04 | none | PASS (4/4 assertions) |
| QA-949 | Brand > Stories - Hovering Functiona | 07-07 | none | PASS — all 5 assertions verified (including A5, which was deferred in the earlier interactive pass). |
| QA-1053 | TWC Aggregate - Relative dates - Loc | 07-07 | none | PASS — all 3 assertions verified after a fresh re-run (first attempt hit a transient "tile failed to load" on Instagram Comments; rebuilding |
| QA-1124 | --- | 07-04 | none | PASS (13/13 assertions) |
| QA-1519 | --- | 07-04 | none | PASS (all in-scope assertions A1/A2/A6/A7 pass). A3/A4/A5/A8 skipped — emailed-CSV + Google Sheets out of scope on the Playwright track. |
| QA-2035 | Brand Sentiment - CSV & GS | 07-04 | none | PASS (in-scope A1–A5 PASS; A6 format-only with documented PST-suffix spec drift; A7/Google Sheets out of scope — skipped) |
| QA-2498 | --- | 07-04 | none | PASS 12/12 (documented spec-vs-UI variances on A1, A3, A4, A8, A10, A12 — none are product bugs). |
| QA-19482 | --- | 07-07 | none | PASS (best-effort; headless limitation noted) — both report runs' Preview & Share print-previews render all sections, no empty pages, and no |
| QA-24544 | Reporting > TWC - Share Functionalit | 07-04 | none | PASS — all in-scope evaluable assertions pass (A1, A5). |
| QA-27854 | Bulk Import Tags Notification | 07-04 | none | PASS (4/4 in-scope assertions). A1/A2 verified in-app. A3/A4 email templates verified via Gmail MCP (operator-mailbox caveat — format verifi |
| QA-27856 | Notification Modal - Import Tags Not | 07-04 | none | PASS (in-scope A1 + A2). Steps 3–4 / A3–A4 SKIPPED — Bulk Tagging email is a Gmail/Google-auth surface, out of scope (see Scope note). |
| QA-28799 | --- | 07-04 | none | PASS — all in-scope assertions (A1–A8) pass. A9/A10 (Dev Mixpanel) are OUT OF SCOPE (third-party system, separate auth — treated like Google |
| QA-43916 | Not Configured Radaac Report | 07-04 | none | PASS (3/3 in-scope assertions) |
| QA-51425 | Duplicate Brands and Social Pages Re | 07-04 | none | PASS (5/5 in-scope assertions) |
| QA-51490 | Brand > Insights - Content Engagemen | 07-04 | none | PASS (12/12 assertions) |
| QA-52776 | --- | 07-04 | none | PASS (3/3) — `url managers` column absent from Fetch, Patch, and Apply xlsx. |
| QA-65554 | --- | 07-04 | none | PASS (in-scope) — Google Sheets assertions skipped (out of scope) |
| QA-85176 | Settings > Custom Metrics - Custom M | 07-04 | none | PASS — 14/14 assertions |
| QA-96038 | Brand > Audience - Instagram - Follo | 07-07 | none | PASS (best-effort; CSV-download not captured headless) — the captured Gender Breakdown network fetch values are confirmed and the tile rende |
| QA-98368 | Brand Content - Threads - Post Type  | 07-07 | none | PASS (best-effort) — A1, A2, A4, A5 verified; A3 (close via X / click-elsewhere) has its control present but the close couldn't be cleanly d |
| QA-103248 | Brand Sets > Content - Daily Post An | 07-04 | none | PASS — all in-scope assertions (A1–A4, A8) pass. A5–A7 (Google Sheets) skipped as out of scope (Google 2FA — see `config/env.md`); noted, no |
| QA-104870 | Settings > Custom Data Sets - Basic  | 07-04 | none | PASS — 12/13 assertions PASS, 1 N/A (A5, no blank-table state on this account). |
| QA-106218 | Settings > Custom Data Sets - Create | 07-04 | none | Assertions passed |
| QA-109920 | Brand > Content - Sentiment Comments | 07-04 | none | PASS (3/3) |
| QA-110074 | Brand > Audience - Threads - Tile Le | 07-04 | none | PASS (5/5 tiles exported and verified on disk; all assertions met) |
| QA-129606 | Handle Abnormally High Response Rate | 07-08 | none | Assertions passed |
| QA-129803 | Handle Abnormally High Response Rate | 07-04 | none | PASS (5/5 in-scope). GS steps skipped (out of scope). |
| QA-131492 | Social Recap Vs Brand > Content - Yo | 07-08 | none | PASS (2/2 assertions) |
| QA-132387 | Brand Sets > Content - Verify Sum an | 07-08 | none | PASS (16/16 in-scope assertions) with 3 findings flagged for eng/product (see Bugs filed). GS steps out of scope (skipped). |
| QA-132392 | Brand Set > Content - Verify Impress | 07-08 | none | Assertions passed |
| QA-134173 | Settings > Custom Metric - Info View | 07-04 | none | PASS — all in-scope assertions pass. No Google Sheets / external-user steps in this case. |
| QA-134182 | Brand > Insights - Verify Interval D | 07-04 | none | PASS (15/15 assertions) |
| QA-134184 | Brand > Insights - Interval selectio | 07-04 | none | PASS (8/8 assertions) |
| QA-134185 | Settings > Custom Metric Creation -  | 07-04 | none | PASS (with the spec's `Metric Definition Link` element N/A — documented spec/UI drift, not a bug) |
| QA-134188 | Brand > Insights - Verify Export (Mo | 07-04 | none | PASS (13/13 in-scope assertions). A14 (Google Sheets) SKIPPED — out of scope (Google 2FA). |
| QA-134516 | Reporting > Content Performance - Ve | 07-08 | none | PASS — layered Include+Exclude tag filtering now exists and works end-to-end on CPR (with data-availability + export-format notes below). |
| QA-134594 | Brand > Video > Instagram > Public D | 07-04 | none | PASS (11 assertions PASS, 1 N/A — see 5c) |
| QA-135319 | Brand > Content - Verify default sel | 07-04 | none | PASS (10/10) |
| QA-139187 | Settings > Custom Metrics - Parenthe | 07-08 | none | PASS (A3, A5, A7, A8 all pass) |

### FAIL (15)

| Case | Title | Run | Open bugs | Why |
|---|---|---|---|---|
| QA-281 | TWC report for Relative dates with l | 07-04 | **LFMP-31961(Open)** | FAILED (blocked by open bug) |
| QA-837 | Social Recap: Report - Multiple bran | 07-04 | **LFMP-31798(Open),LFMP-31918(Open)** | FAILED (blocked by open bug) |
| QA-929 | --- | 07-04 | **LFMP-31979(Open)** | FAILED (blocked by open bug) |
| QA-1677 | --- | 07-04 | **LFMP-32155(Open)** | FAILED (blocked by open bug) |
| QA-2706 | Brand > Content - Benchmark - Author | 07-04 | **LFMP-31886(Open)** | FAILED (blocked by open bug) |
| QA-3630 | Reporting > Content Performance Repo | 07-04 | **LFMP-32010(Open)** | FAILED (blocked by open bug) |
| QA-12532 | Brand Sets > Partnerships - Sponsors | 07-04 | **LFMP-31903(Open),LFMP-32116(Open)** | FAILED (blocked by open bug) |
| QA-19557 | Brand Content - Impressions Data Set | 07-04 | **APPS-58817(Open),LFMP-32016(Open)** | Open-bug auto-fail |
| QA-20988 | Brand > Paid - Tile Level Export Fun | 07-04 | **DATA-12089(Code Review)** | FAILED (blocked by open bug) |
| QA-23969 | --- | 07-04 | **LFMP-31925(Open)** | FAILED (blocked by open bug) |
| QA-96665 | Brand Insights - Threads - Basic Vie | 07-04 | **LFMP-32027(Open)** | FAILED (blocked by open bug) |
| QA-116113 | Youtube Audience Tile level export P | 07-04 | **DATA-12043(Code Review)** | FAILED (blocked by open bug) |
| QA-131491 | Social Recap Vs Brand > Content - IG | 07-04 | **DATA-12223(QA Ready)** | FAILED (blocked by open bug) |
| QA-135321 | Brand > Content - Verify Additional  | 07-04 | **LFMP-32155(Open)** | FAILED (blocked by open bug) |
| QA-138031 | Data Collection - Channel Collection | 07-04 | **APPS-61562(QA Ready)** | FAILED (blocked by open bug) |

### BLOCKED (9)

| Case | Title | Run | Open bugs | Why |
|---|---|---|---|---|
| QA-457 | TWC Rate Data QA | 07-04 | none | BLOCKED — stage environment not reachable in this harness |
| QA-90213 | --- | 07-07 | none | BLOCKED — Data Studio (Post Level) "Go" does not generate the report, so the DS Sum can't be captured and A1/A2 parity cannot be evaluated.  |
| QA-96818 | Reporting - Data Studio - Posts Leve | 07-04 | **LFMP-31977(Open)** | Blocked |
| QA-100764 | Brand > Content - Daily Post Analysi | 07-04 | none | BLOCKED — test-data gap: Max has no Threads channel on Brand > Content (step 3 unperformable) |
| QA-109062 | Settings > Custom Data Sets support  | 07-07 | none | BLOCKED — the prerequisite Custom Data Set "Custom Data Sets Test" (created by QA-106218) is not present on the Adam Orfei account, so the c |
| QA-130076 | Settings > Notifications - Improve L | 07-08 | none | BLOCKED — test-data gap (no lost-authorization / NOT COLLECTING notification exists on Viacom). Not a product bug. Assertions A1–A4 are Not  |
| QA-134277 | Brand > Content - Verify CSV Export  | 07-08 | none | BLOCKED — test-data / unmet precondition (no tagged posts in window) |
| QA-134448 | Brandsets > Partnership - Verify lay | 07-08 | none | Blocked |
| QA-134449 | Brandsets > Optimization - Verify la | 07-08 | none | BLOCKED — test-data gap (precondition unmet). |

### SKIPPED (2)

| Case | Title | Run | Open bugs | Why |
|---|---|---|---|---|
| QA-29479 | Dashboards - Share Dashboard via Ema | 07-04 | none | SKIPPED — external-user precondition (deferred) |
| QA-33510 | --- | 07-04 | none | SKIPPED — external-user precondition (deferred) |
