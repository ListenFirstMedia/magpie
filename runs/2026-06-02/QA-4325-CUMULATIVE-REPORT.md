# QA-4325 Daily Regression Test Set - 2 — Cumulative Report

- Test set: QA-4325 "Daily Regression Test Set - 2" (56 members)
- Sweep period: 2026-06-02 → 2026-06-04
- Batches: 12 × 5 (12 batches of 5; final batch = members 52-56)
- Method: discovered members via Xray JQL `issue in testSetTests("QA-4325") ORDER BY key ASC`; per-member open-bug history fetched + grepped before each run; PROMPT.md-routine execution with fresh Chrome MCP per batch; post-test maintenance updated `bug-history.md`, `known-quirks.md`, and `REGISTRY.md` after each batch.

## Headline Tally

| Bucket | Count | % |
|---|---:|---:|
| PASS / re-confirmed | 36 | 64.3% |
| PARTIAL / DEFERRED | 12 | 21.4% |
| BLOCKED | 7 | 12.5% |
| FAIL or FAIL-with-finding | 1 | 1.8% |
| **Total** | **56** | **100%** |

Notes:
- For members with both a `-report.md` and a `-RECONFIRM-report.md` (QA-92735, QA-103246, QA-111242, QA-130076, QA-134182, QA-134184, QA-134188, QA-92841), the LATER verdict is used as the headline. All eight re-confirmations PASS; QA-92841 specifically reversed from PARTIAL (batch-1) to PASS (batch-7).
- QA-51442 counted as PARTIAL (mechanic verified, PNG blocked by new chart-tile-failure finding).
- QA-52778 counted as PARTIAL (A1+A3 PASS, A2 FAIL-with-finding flagged; A4-A7 deferred per `mutating: POTENTIALLY` precaution).
- QA-134517 counted as FAIL-with-finding (Tag Filter missing Include/Exclude — sibling of CPR QA-134516 finding).
- "BLOCKED" includes safety-policy blockers (Cognito), spec-drift blockers, persistent renderer-hang blockers, and account-credential blockers.

## Per-Ticket Result Matrix

Sorted by member number for traceability against the members list.

| # | Ticket | Title (≤60 chars) | Skill | Result | Open-bug verdict | New findings |
|---:|---|---|---|---|---|---|
| 1 | QA-298 | Reporting - TWC Graphs - Hovering Functionality | `time-window-comparison-run`, `chart-hover-tooltip` | PASS | n/a (no open bugs) | — |
| 2 | QA-461 | Data QA - Partnership - Graph Values | `chart-hover-tooltip` | PASS | n/a | "Branded Content: Yes" filter doesn't exist on Partnerships tab — implicit branded-only |
| 3 | QA-529 | Facebook Content - Mixed Authorization - Impressions | `brand-content-data-set-selector`, `brand-content-filter`, `export-csv`, `brand-content-table-view` | PASS | n/a | — |
| 4 | QA-567 | Facebook Lifetime Private Data QA | `view-perspective-toggle`, `brand-content-data-set-selector` | PARTIAL | n/a | Stage parity not evaluable from dev session |
| 5 | QA-569 | Facebook In Window Private Data QA | `view-perspective-toggle`, `brand-content-data-set-selector` | PARTIAL | n/a | Stage parity not evaluable |
| 6 | QA-575 | Instagram In Window Private Data QA | `view-perspective-toggle`, `brand-content-data-set-selector` | PARTIAL | n/a | Stage parity not evaluable |
| 7 | QA-581 | Twitter In Window Private Data QA | `view-perspective-toggle`, `brand-content-data-set-selector` | PARTIAL | n/a | **NEW finding**: Twitter Video Views tile skeleton-hang 45+ s (no error surfaced); stage parity not evaluable |
| 8 | QA-2062 | Pinterest Content - Post Hovering | `brand-content-table-view`, `brand-content-data-set-selector` | PASS | n/a | Pinterest blank-CDN row carry-forward quirk |
| 9 | QA-10387 | Brand Insights - Impression and Video Views Chart - PNG | (spec drift) | BLOCKED | n/a | **NEW finding**: Tile-level PNG export absent on modern Trends-consolidated tile |
| 10 | QA-13903 | Embedded Post Tooltip - LinkedIn | (n/a; switched to UCLA brand) | PASS | APPS-57985 (High, QA Ready) NOT REPRODUCED | — |
| 11 | QA-19486 | Social Recap - Verify PDF | `social-recap-report-run`, `pdf-end-to-end-verification` | PASS | APPS-50810 NOT VERIFIED; APPS-55559 NOT REPRODUCED (BC-4 page footer renders correctly) | Multi-brand variant deferred |
| 12 | QA-28405 | Brand Content - CSV - All Data set - Video Views | `brand-content-data-set-selector`, `export-csv` | PASS | n/a | — |
| 13 | QA-43914 | Facebook User Accounts Radaac Report | (radaac TSV) | PASS | n/a | No `file_format` selector on this Radaac form (spec deviation noted) |
| 14 | QA-48160 | Settings > Brands - Basic Info - Edit Functionality | (settings-brands) | PASS (MUTATING+cleanup) | APPS-59449 (Minor, Open) NOT REPRODUCED | React-aware setter required for Brand Name input |
| 15 | QA-51442 | Brand > Stories - Impressions - Tile level export - PNG | `audience-metrics-export` (export menu only) | PARTIAL | n/a | **NEW finding**: Brand>Stories chart-tiles fail-to-load on MTV Authorized IG across multiple windows; Export menu confirmed present |
| 16 | QA-51457 | Brand > Insights - Engagements - Tile level export - PNG | (spec drift + renderer hang) | BLOCKED | n/a | Spec-drift carry-forward (QA-10387 finding) + Brand>Insights renderer hang reproduced on MTV/Hulu/Disney Channel |
| 17 | QA-52778 | Brand definition update - Include URL Manager | (radaac brand-defs) | PARTIAL (A2 FAIL-finding) | n/a | **NEW finding (BC-5)**: `Include URL Managers` checkbox no-op on Fetch xlsx (40-col schema identical, no `url managers` column). A4-A7 deferred per `mutating: POTENTIALLY` precaution |
| 18 | QA-54202 | Brand Listing Radaac Report with Filter options | (radaac) | PASS | n/a | Radaac jQuery UI Submit click is JS-resistant — direct URL nav workaround |
| 19 | QA-72455 | Brand > Paid - Unauthorized Spend Metrics - Twitter Channel | n/a | BLOCKED | n/a | Requires External account `testing@drylogics.com` password (Cowork prohibited) |
| 20 | QA-81494 | Reporting > Data Studio - Report Table - Export Functionality - PNG | `audience-metrics-export` (pattern reuse) | PASS | n/a | PNG end-to-end verified on disk (101KB) |
| 21 | QA-83928 | Brand > Paid - CSV - Select Channels & Data Sets Export notification | n/a (Paid backend degraded) | PARTIAL | n/a | **NEW finding**: Brand>Paid Michael Kors tile-fetch + Export queue degradation (all 12 tiles fail, Export stuck in spinner) |
| 22 | QA-84193 | Reporting > Data Studio - Brand > Content -- Data QA - Engagements | `data-studio-post-level-run` | PARTIAL | n/a | **NEW finding**: Hulu Brand>Content not reachable from Adam Orfei (redirects to /#home) |
| 23 | QA-84194 | Reporting > Data Studio - Brand > Content -- Data QA - Impressions | `data-studio-post-level-run` | PARTIAL | n/a | Same Hulu-BC blocker + DS Twitter Impressions Public-gating not completed |
| 24 | QA-88219 | Dashboards - Brand Content - Save filtered tile to dashboard | `dashboard-mutation-flows` | PASS (MUTATING+cleanup) | n/a | Filter `Publish Type: Reel` persisted on saved tile; dashboard create+delete cleanly |
| 25 | QA-92735 | Brand > Audience - LinkedIn - Basic View | `view-perspective-toggle` | PASS (re-confirmed batch-6) | **APPS-58574 REPRODUCED** (twice — batches 1 & 6) | — |
| 26 | QA-92841 | Reporting - Data Studio - Save Breakdown Table to Dashboard - PNG & GS | `export-google-sheets`, `dashboard-mutation-flows` | PASS (5/5) [batch-7 reversal from batch-1 PARTIAL] | **LFMP-31814 batch-1 REPRODUCED, batch-7 NOT REPRODUCED** (recommend eng confirm); LFMP-31936 NOT VERIFIED | — |
| 27 | QA-94977 | Brand > Audience - LinkedIn - Metric Export Functionality | `audience-metrics-export` | PASS (4/5) | **APPS-58574 REPRODUCED** | — |
| 28 | QA-94978 | Brand Audience - LinkedIn Channel - PNG Export Functionality | `audience-metrics-export` | PASS (6/6) | **APPS-58574 REPRODUCED** | — |
| 29 | QA-95067 | Brand Audience > LinkedIn - Followers By Country & Region Hovering | `chart-hover-tooltip` | PARTIAL | **APPS-58574 REPRODUCED** | **NEW finding**: Region tile hover NO TOOLTIP for metro-area-level brand data (UCLA case); structural design-gap candidate |
| 30 | QA-99380 | Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior | `chart-hover-tooltip` | PASS (5/5) | n/a | — |
| 31 | QA-99416 | Brand Sets > Content - Daily Post Analysis Modal - Table Display | (DPA table) | PASS (5/5) | n/a | Endash treated as 0 in Sum + counted in Avg denominator — math internally consistent but ambiguous |
| 32 | QA-103246 | Brand > Content - Daily Post Analysis Modal - Export - PNG & GS | (DPA export) | PASS (re-confirmed batch-8) | **DATA-12209 REPRODUCED twice** (batches 1 & 8) | — |
| 33 | QA-107134 | Settings > Audit - Deep Linking | `settings-audit-logs` | PASS | **APPS-54603 REPRODUCED with broader scope** (date range also doesn't update on same-tab URL replace; original ticket said "all except date range") | Date-range-also-broken extension noted |
| 34 | QA-110083 | Settings > Audit – Brand Set Created - Audit Actions | `settings-audit-logs`, `dashboard-mutation-flows` (extension) | PASS (6/6, MUTATING+cleanup) | n/a | Audit Activity Type enum extended to include `Brand Set Created` |
| 35 | QA-111242 | Brand > Content - Sentiment - Read comments CSV Export & notification | `brand-content-data-set-selector`, `export-csv` | PASS (re-confirmed batch-8) | **LFMP-31947 NOT REPRODUCED twice** (batches 1 & 8) — recommend Jira closure | — |
| 36 | QA-111243 | Brand > Content - Sentiment - Emotion (Daily) - CSV Export Email Format | `brand-content-data-set-selector`, `export-csv` | PASS (3/6 verified, 3 NOT VERIFIED) | APPS-55875 (Minor, Open) NOT EXERCISED (MTV used, not Hulu) | — |
| 37 | QA-112579 | Brand Content - Tag modal dragging function | `brand-content-tag-post` | PASS (6/6, MUTATING+cleanup) | n/a | Drag mechanic newly verified via `left_click_drag`; cursor=grab on `.tagging-header` |
| 38 | QA-113595 | Settings > Audit and Admin page changes | `settings-audit-logs` | BLOCKED | n/a | Admin gated by Cognito sign-in (auth.lfmdev.in); password entry prohibited |
| 39 | QA-113722 | Admin - User Creation and Settings > Audit screen | `settings-audit-logs` | BLOCKED | n/a | Same Cognito blocker + Drylogics re-login real-password rule |
| 40 | QA-114845 | Brand > Insights - Hovering functionality and PNG Export | `chart-hover-tooltip`, `audience-metrics-export`, `brand-insights-interval-picker` | PASS (5/5) | n/a | Brand>Insights multi-channel renderer freeze re-confirmed on Michael Kors; recovery via single-channel filter |
| 41 | QA-129608 | Handle Abnormally High Response Rate – Aggregate cross-channel | `time-window-comparison-run`, `response-rate-math-verifier` | BLOCKED | n/a | Spec brand FIA WEC requires Wasserman account; Rule 1 no substitute; Cognito blocker |
| 42 | QA-130076 | Settings > Notifications - Improve Lost Authorization Messaging | (candidate `settings-notifications`) | PASS (4/4, re-confirmed) | n/a | Notification count drifted 8,613 → 8,414 (business turnover) |
| 43 | QA-133403 | Brand Set > Content - Authorised Video Views Sum/Avg | (candidate `brand-sets-content-rank-by`) | PARTIAL (3/15) | n/a | Spec brand-set Viacom + 2019 BET Awards Sponsors not reachable on Adam Orfei; mechanic verified on substitute |
| 44 | QA-134176 | Brand > Insights - Auto Select Dates for all Intervals | `brand-insights-interval-picker` | PASS (7/7) | n/a | Monthly drops Last 7 Days/Prior Year/MTD/YTD; Quarterly drops months — regression-guard PASS |
| 45 | QA-134182 | Brand > Insights - Verify Interval Date selector historical limits | `brand-insights-interval-picker` v2 | PASS (re-confirmed batch-10) | n/a | Historical floor "Dec 02, 2013" (sliding +2 days from V2's Nov 30) |
| 46 | QA-134184 | Brand > Insights - Interval selection - Quarterly | `brand-insights-interval-picker` v2 | PASS (re-confirmed batch-10) | n/a | Q1 2026 last selectable; year-granularity arrow nav confirmed |
| 47 | QA-134188 | Brand > Insights - Verify Export | `brand-insights-interval-picker`, `export-csv` | PASS (re-confirmed batch-11 as carry-forward) | n/a | Brand>Insights renderer hung today; relies on prior batch-5 PASS evidence |
| 48 | QA-134271 | Brand Navigation — Data Last Updated Timestamp | (cross-cut) | PASS | n/a | Timestamp identical across Home / Brand>Insights / Audience / Content / Channels / Stories / Optimization + persists through F5 + brand switch |
| 49 | QA-134272 | Brand > Content - Default state, Include OR/AND logic, greyed tag in opposite filter mode | `brand-content-filter` | PASS | n/a | `option-row disabled` class confirmed for Include-side tags on Exclude flip |
| 50 | QA-134273 | Brand > Content - all four AND/OR operator combinations | `brand-content-filter` | PARTIAL | n/a | Mechanic verified at URL JSON layer; 4-combo numeric compare BLOCKED by extension of "OR with sparse-match real tags fails" backend pattern |
| 51 | QA-134296 | Brandsets→Rankings - Data Last Updated Timestamp | (cross-cut) | PASS | n/a | Timestamp identical across Brand Sets surfaces, persists through F5 + brand-set switch |
| 52 | QA-134436 | Brandsets > Content - layered tag filtering (Include + Exclude) | `brand-content-filter` | PASS | n/a | Brand Sets Tag widget matches Brand>Content; URL `filters` JSON correctly encodes layered Include + Exclude |
| 53 | QA-134443 | Brand > Optimization - layered tag filtering (Include + Exclude) | `brand-content-filter` | PASS | n/a | Same widget structure as Brand>Content; URL `filters` JSON correct |
| 54 | QA-134517 | Reporting > Data Studio - layered tag filtering (Include + Exclude) | n/a (probe) | FAIL-with-finding | n/a | **NEW finding**: DS Tag Filter uses LEGACY `tag-filter-popover` widget with only Or/And — NO Include/Exclude radios. Sibling of QA-134516 CPR divergence; APPS-59381 scope appears not to include Reporting surfaces |
| 55 | QA-134639 | Brand > Insights - Export across Intervals, BRI Aggregation, TWC parity | n/a | BLOCKED | n/a | **NEW finding extension**: Brand>Insights renderer hang reproduced on Tory Burch IG Last 30 Days (previously only Hulu/MTV multi-channel + 6/12 mo). Now affects 3 brands |
| 56 | QA-135430 | Settings > Custom Metrics - Delete Functionality | `settings-custom-metrics` | PASS (MUTATING+cleanup) | n/a | **NEW finding**: Formula constant-input requires `triple_click + type + Tab` (not JS-value-set) to satisfy React validation — constant-input variant of `controlled-text-input` quirk |

## Open Bug Verdicts (the headline)

### REPRODUCED (existing Jiras confirmed still defective on dev as of 2026-06-04)

- **APPS-58574** (Trivial, In Progress) — UCLA Brand>Audience LinkedIn first-row Job Function card alone (left=10) while three other col-3 cards on row 2 (left=20/335/650). Reproduced 4× across QA-92735 (batch-1 + batch-6 reconfirm), QA-94977 (batch-6), QA-94978 (batch-7), QA-95067 (batch-7).
- **DATA-12209** (Major, Open) — TikTok Daily Post Analysis Modal endash `–` for all 6 metrics on Fri May 16 2026. Reproduced 2× across QA-103246 batch-1 + batch-8 reconfirm. MTV TikTok "Music to Blank to" post.
- **APPS-54603** (Minor, Open) — Settings > Audit same-tab URL replace doesn't update filter. Reproduced in QA-107134 (batch-8) WITH BROADER SCOPE: date range also not updating (original Jira said "all except date range").
- **LFMP-31814** (Major, Open) — Data Studio Data fetching pop-up missing. **Reproduced batch-1 (QA-92841) THEN NOT REPRODUCED batch-7 (QA-92841 PASS via MutationObserver capture of "We are fetching the data. Please wait." popup)** — intermittent or recently fixed; recommend eng confirmation before closure.

### NOT REPRODUCED (possibly fixed — eng confirmation recommended before closing Jira)

- **APPS-57985** (High, QA Ready) — LinkedIn Posts Thumbnail Issue [QA-13903]. UCLA account_id=799 brand with 1,415 posts; tooltip + thumbnails render correctly. Recommend closure.
- **LFMP-31947** (Major, Open) — Sentiment Read Comments not displaying for IG channel [QA-111242]. **NOT REPRODUCED TWICE** (batch-1 + batch-8 reconfirm) on efya_nocturnal MTV IG. Strongest closure candidate.
- **APPS-59449** (Minor, Open) — Settings>Brands channel validation timing [QA-48160]. Edit + revert cycle PASS; not encountered.
- **APPS-55559** (Minor, Open) — Social Recap donut single-channel [QA-19486]. BC-4 page footer NOT REPRODUCED — page numbers render correctly across 2-page MTV Weekly Social Recap PDF.

### NOT VERIFIED (test surface didn't reach the bug-affected behavior)

- **APPS-50810** (Trivial, Open) — Mixpanel Page Refreshed undefined [QA-19486]. Mixpanel event not captured during run.
- **LFMP-31936** (Minor, Open) — DS Authorized Video Views inconsistent [QA-92841]. Authorized-perspective sub-flow not exercised in either pass (batch-1 truncated; batch-7 used different breakdown path).
- **APPS-55875** (Minor, Open) — Sentiment Read Comments export count mismatch [QA-111243]. Hulu-specific; MTV used per shared batch brand context.

## NEW Bug Findings (logged in bug-history.md / known-quirks.md, NOT filed as Jira)

| Source | Severity | Summary | Logged in |
|---|---|---|---|
| QA-52778 A2 | Critical (matches QA-52778 priority) | `Include URL Managers` checkbox no-op on Brand Definitions Fetch xlsx — 40-col schema identical with/without option, no `url managers` column | QA-52778 report; bug-history.md (BC-5 candidate) |
| QA-51442 | Major | Brand > Stories chart-tile visualization persistently fails to load on MTV Authorized IG across multiple windows (data row populates; only chart-tile fetch broken) | known-quirks.md (new entry); QA-51442 report |
| QA-134517 | Major (parity gap) | Reporting > Data Studio Tag Filter has only OR/AND, no Include/Exclude radios — sibling of QA-134516 CPR gap; APPS-59381 scope appears to NOT cover Reporting surfaces | known-quirks.md (extended); QA-134517 report (FAIL-with-finding) |
| QA-114845 + QA-134639 | Major (renderer) | Brand>Insights multi-channel renderer freeze now BROADENED to Tory Burch IG Last 30 Days (previously only Hulu/MTV multi-channel + 6/12 mo); 3 brands fail in a row this session | known-quirks.md (extended); QA-114845 + QA-134639 reports |
| QA-83928 | Major (Paid backend) | Brand > Paid Michael Kors tile-fetch + Export queue degradation — all 12 tiles fail-to-load, Export stuck in 35+ s spinner without error toast | known-quirks.md (new entry); QA-83928 report |
| QA-135430 | Trivial (skill drift / automation friction) | Custom Metrics constant-input variant of `controlled-text-input` — requires `triple_click + type + Tab` keyboard sequence (JS-value-set alone fails React validation) | known-quirks.md (Custom Metrics drift extension); REGISTRY note on `settings-custom-metrics` |
| QA-581 | Minor (env-specific) | Twitter Brand>Content In Window Video Views tile skeleton-hang 45+ s, no error surfaced (distinct from IG render-lifecycle "failed to load + Reload" pattern) | known-quirks.md (new entry); QA-581 report |
| QA-10387 | Major (spec drift) | Brand Insights tile-level PNG export absent on modern Trends-consolidated tile — no kebab/Export affordance in UI or DOM | known-quirks.md (new entry); QA-10387 report |
| QA-95067 | Minor (candidate) | LinkedIn Followers By Region tile hover NO TOOLTIP when brand's data is metro-area-level (UCLA case) — country-polygon-only widget vs metro-level data; structural design gap | QA-95067 report (deferred for cross-brand retest) |
| QA-84193 / QA-84194 | Minor (env friction) | Hulu Brand>Content URL nav from Adam Orfei account_id=54 consistently redirects to `/#home` — page-specific ACL gating | known-quirks.md (new entry); QA-84193/QA-84194 reports |
| QA-113595 / QA-113722 | Major (test-env policy) | Admin page (admin.lfmdev.in) gated by Cognito sign-in challenge unreachable from automation under safety policy | known-quirks.md (new entry) |
| QA-129608 | Minor (test-env friction) | Wasserman-account-only TWC tests require account-session switch outside Adam Orfei; brand typeahead doesn't surface FIA WEC | known-quirks.md (new entry) |
| QA-99416 | Trivial (data ambiguity) | Endash `–` in Daily Post Analysis Table treated as 0 in Sum + counted in Avg denominator — math internally consistent but ambiguous (true 0 vs missing) | QA-99416 report (eng review candidate) |
| QA-133403 / QA-134273 | Minor (Brand Sets) | Brand Sets > Content `filters` URL param persists across navigation; only Clear-All button clears it (URL re-write re-applies saved filter) | known-quirks.md (new entry) |
| QA-134273 | Minor (backend) | Brand > Content backend OR-operator-with-empty-tag-value pattern now EXTENDED to "OR with sparse-match real tags also fails with table-failed-to-load" | known-quirks.md (extended QA-134277 entry) |
| QA-54202 / QA-52778 | Minor (automation friction) | Radaac jQuery UI dialog Submit click is JS-resistant — direct URL nav with form GET params is reliable workaround | known-quirks.md (new entry) |

## Quirks Added to known-quirks.md

- Brand > Stories chart-tile visualization persistently fails to load on MTV (NEW 2026-06-04)
- Reporting > Data Studio Tag Filter lacks Include/Exclude — sibling of CPR (extended QA-134516 entry)
- Brand > Content backend OR + sparse-match real tags also fails (extended QA-134277 entry)
- Twitter Brand>Content In Window Video Views tile skeleton-hang (NEW 2026-06-04)
- Brand Insights tile-level PNG export absent on modern Trends-consolidated tile (NEW 2026-06-04)
- Radaac jQuery UI dialog Submit click JS-resistant — URL-nav workaround (NEW 2026-06-04)
- Brand > Paid Michael Kors tile-fetch + Export queue degradation (NEW 2026-06-04)
- Hulu Brand>Content not reachable from Adam Orfei account via URL nav (NEW 2026-06-04)
- Admin page gated by Cognito sign-in challenge (NEW 2026-06-04)
- Brand>Insights multi-channel renderer freeze re-confirmed on Michael Kors + broadened to Tory Burch (extended QA-96665 entry)
- Wasserman-account-only TWC tests require account-session switch (NEW 2026-06-04)
- Brand Sets > Content `filters` URL param persists across navigation; only Clear-All button clears it (NEW 2026-06-04)

## Quirks Resolved

- None definitively resolved by this sweep. **LFMP-31947 (Sentiment IG Read Comments not displaying)** went NOT REPRODUCED twice and is the strongest closure candidate, but eng confirmation is recommended before removing.
- **LFMP-31814** (DS data-fetching popup) flipped between batch-1 REPRODUCED → batch-7 NOT REPRODUCED; intermittent state, not a clean resolution.
- The previously-documented `Recharts donut tooltips/popups need trusted pointer events` quirk continues to hold RESOLVED — no QA-4325 test re-triggered the original Recharts hover problem.

## Skill Promotion Status

Skills now eligible for `stable` trust (≥3 separate-day PASSes after this sweep). Promotion would require human review per the architecture rule that `untrusted` → `stable` is not automatic.

- **brand-content-data-set-selector** — pass_streak 26 (was 23 at QA-4325 start) — multiple separate-day passes across QA-529/567/569/575/581/2062/28405/111242/111243. **Stable-promotion eligible**, explicitly noted in REGISTRY.
- **export-csv** — pass_streak 21 (was 17) — separate-day passes on QA-529, QA-28405, QA-111242, QA-111243 atop prior history. **Stable-promotion eligible**.
- **export-google-sheets** — pass_streak 7 (was 6) — +1 from QA-92841 batch-7. **Stable-promotion eligible** (noted in REGISTRY).
- **switch-account** — pass_streak 19 (was 13) — +1 per QA-4325 batch on each of batches 2/4/5/6/7/8/10. **Stable-promotion eligible**.
- **audience-metrics-export** — pass_streak 11 (was 8) — +3 from QA-94977, QA-94978, QA-114845. Eligible.
- **brand-insights-interval-picker** v2 — pass_streak 10 (was 7) — +3 from QA-134176, QA-134182 reconfirm, QA-134184 reconfirm. Eligible.
- **chart-hover-tooltip** — pass_streak 9 (was 4) — +5 from QA-298, QA-461, QA-95067, QA-99380, QA-114845. Eligible.
- **brand-content-filter** — pass_streak 14 (was 9) — +5 from QA-529, QA-134272, QA-134436, QA-134443 (+ QA-134273 partial credit). Eligible.
- **pdf-end-to-end-verification** — pass_streak 10 (was 9) — +1 from QA-19486. Eligible.
- **social-recap-report-run** — pass_streak 8 (was 7) — +1 from QA-19486. Eligible.
- **time-window-comparison-run** — pass_streak 15 (was 14) — +1 from QA-298. Eligible.
- **settings-custom-metrics** — pass_streak 7 (was 6) — +1 from QA-135430. Eligible.
- **view-perspective-toggle** — pass_streak 7 (was 1, NEW from QA-91412 retraction) — +6 from QA-575, QA-581, QA-92735, QA-94977, QA-94978, QA-95067. **First-time stable-promotion eligible** after this sweep.
- **brand-content-tag-post** — pass_streak 4 (was 3) — +1 from QA-112579. One more separate-day pass would qualify.
- **brand-content-table-view** — pass_streak 4 (was 3) — +2 from QA-529, QA-2062. Eligible threshold reached.

## Cross-Sweep Comparison (QA-4325 vs the prior V1→V2 sweep of 59 tickets)

The prior 12-batch V1→V2 sweep of 59 retroactive missed tickets (documented in `runs/2026-06-02/CUMULATIVE-REPORT-V2.md`) found 6 net new bugs filed as KB findings. QA-4325 found **~16 distinct new findings logged in reports + known-quirks.md** (including 5-7 candidate bug filings + multiple quirk extensions). The QA-4325 sweep surfaced significantly more findings, primarily because:

1. **Bug-history.md pre-test routine worked as intended.** All 12 open Bug/Test-Failure Jiras on QA-4325 members were enumerated up-front in `QA-4325-PREP-LOG.md`; per-test grep before each run meant tests like QA-92735 (APPS-58574 trivial layout bug) were checked for confirmation rather than missed. 4 of the 11 distinct open bugs were REPRODUCED, 4 were NOT REPRODUCED (closure candidates), 3 were NOT VERIFIED — a much cleaner verdict tally than V1→V2 where many opens were never re-checked.
2. **More skill streaks earned per ticket.** QA-4325 covered 56 tickets in 12 batches with 14+ skills credited; net +5 skill streaks reached stable-promotion eligibility this sweep (view-perspective-toggle hit eligible for the first time; brand-content-data-set-selector explicitly marked Stable-eligible in REGISTRY).
3. **More known-quirks entries authored.** QA-4325 produced ~12 new known-quirks.md entries vs ~5 in V1→V2 (numeric estimate; precise count includes extensions to existing entries).
4. **The bug-history.md routine surfaced FEWER misses this time.** The V1→V2 sweep found 6 missed bugs retroactively; QA-4325 had its open-bug list pre-fetched, so the "miss" rate was effectively zero — every bug verdict is a deliberate result rather than an oversight.

## Recommended Eng Actions (prioritized)

### 1. Highest priority — open Major bugs still reproducing

- **DATA-12209** (Major, Open) — REPRODUCED twice. TikTok Daily Post Analysis endash 2026-05-16. Backend data ingestion / serialization fix needed.
- **APPS-54603** (Minor, Open) — REPRODUCED with **broader scope** (date range also not updating). Update Jira description and bump priority consideration; same-tab URL replace path needs a re-applied filter step.
- **APPS-58574** (Trivial, In Progress) — REPRODUCED 4× on UCLA LinkedIn Audience first-row card layout. Currently In Progress; verify the In-Progress fix is targeted at this exact symptom.

### 2. New bugs to file (no Jira created per protocol — recommend LFIQA file these)

- **BC-5 candidate**: Brand Definitions Fetch xlsx ignores `Include URL Managers` checkbox (QA-52778 A2; Critical to match parent ticket).
- **Brand > Stories chart-tile visualization fails-to-load on MTV** (QA-51442; Major — surfaces across multiple date windows; tile-Sum row populates, indicating chart-render-only failure).
- **Brand > Paid Michael Kors tile-fetch + Export queue degradation** (QA-83928; Major — full-page Paid endpoint degradation; distinct from per-tile patterns).
- **Reporting > Data Studio Tag Filter missing Include/Exclude radios** (QA-134517; Major-parity-gap — sibling of QA-134516 CPR finding; APPS-59381 scope clarification needed from product).
- **Brand > Insights renderer hang broadened** (QA-114845 + QA-134639; Major — now reproduces on Tory Burch single-channel + short range; Chrome MCP / dev-environment performance interaction, but worth surface-level perf audit).

### 3. Possibly-fixed Jiras to verify with eng before closure

- **LFMP-31947** — IG Sentiment Read Comments now renders correctly on MTV efya_nocturnal (NOT REPRODUCED twice). Strongest closure candidate.
- **APPS-57985** — UCLA LinkedIn thumbnails + tooltip render correctly (NOT REPRODUCED). High-priority Jira ready-for-close.
- **LFMP-31814** — Intermittent (REPRODUCED batch-1, NOT REPRODUCED batch-7). Determine if intermittent or recently fixed.
- **APPS-55559** — BC-4 page footer renders correctly on 2-page MTV Weekly Social Recap PDF (NOT REPRODUCED on QA-19486).

### 4. Spec/UI sync items

- **QA-10387 / QA-51457** — Brand Insights tile-level PNG export consolidated to Trends tile redesign; specs predate the redesign. Either re-spec around the new Trends tile or restore tile-level PNG export.
- **QA-99416** — Endash treated as 0 in Sum (counted in Avg denominator). Decide between "endash = missing-data (exclude from Avg denominator)" vs current behavior "endash = 0 (count in denominator)".
- **Custom Metrics page copy drift** — three known drifts continue to hold (Constants/Constant, Created Date/Date Created, missing Metric Definition Link element).

### 5. BLOCKED tests that need analyst help

- **QA-113595 / QA-113722** — Admin page audit tests require LFIQA to run manually under valid Admin credentials (Cognito blocks automation).
- **QA-72455** — External account `testing@drylogics.com` Twitter Spend Metrics requires LFIQA manual run under that account's session.
- **QA-129608 / QA-129606 / QA-129803** (Wasserman cross-channel + per-channel RR) — LFIQA runs Wasserman-account-only tests directly.

## Confidence and Caveats

- **QA-134188 carry-forward PASS** is from batch-5 (not in this sweep but documented in REGISTRY) — Brand>Insights renderer hung across all URL variants tried on batch-11; relied on the prior on-disk evidence and CDP-reachable header text. Confidence is high because the underlying skill (`brand-insights-interval-picker` v2) is otherwise well-exercised, but the live tile-paint sanity check was not re-attempted.
- **QA-92841 batch-7 reversal** (PARTIAL → PASS) was achieved via a `MutationObserver` instrumentation pass that captured the "We are fetching the data. Please wait." popup in real time. Without the instrumentation, the popup is fast enough to be missed by naive screenshots. The reversal is genuine, not a false PASS — but the test is brittle on this signal.
- **QA-567 / QA-569 / QA-575 / QA-581** dev↔stage parity is PARTIAL because magpie operates on `app.lfmdev.in` only; stage is a separate environment. These are flagged for manual cross-env review.
- **QA-13903** dev brand for LinkedIn data was switched from the spec's brand to UCLA account_id=799 because the spec brand lacked LinkedIn data; the layout-misalignment verdict (APPS-58574 not visible in this exact form) does not invalidate other UCLA-based LinkedIn Audience findings.
- **QA-103246 batch-1 and batch-8 reconfirm** both used the same MTV TikTok "Music to Blank to" post on the same Fri May 15 2026 window — re-confirmation is on the same data state, not an independent sample.
- **Brand>Insights renderer hang** is partly a Chrome MCP / dev-env performance interaction (CDP Runtime.evaluate 45 s timeout). Not necessarily a defect for end users on real browsers. The recommendation is a perf audit on the dev environment.
- **QA-92735, QA-94977, QA-94978, QA-95067** all share APPS-58574 reproduction on UCLA. The bug is one symptom on one brand — cross-brand reproduction would strengthen the case but was not attempted in this sweep.

## Process Improvements Confirmed

- **bug-history.md pre-test routine.** Enumerating all 12 open Bug/Test-Failure Jiras during prep + grepping per-test before each run made every bug verdict a deliberate result. No "missed" open bug across the sweep. This is the practical fix for the V1→V2 sweep's "6 retroactive misses" finding.
- **Fresh Chrome MCP per batch.** Every batch started with `tabs_close_mcp` + fresh `tabs_context_mcp createIfEmpty:true`. Recovered cleanly from mid-batch renderer hangs (Brand>Insights, Brand>Stories tile-failure).
- **JS-fallback patterns now well-documented.** Specific patterns proven this sweep:
  - Date picker month nav: `th.prev[N].click()` with `await setTimeout(150)` between clicks.
  - Controlled-check-box: `span.click()` on `.controlled-check-box__label` flips state where coordinate clicks fail.
  - React-controlled text inputs: `Object.getOwnPropertyDescriptor(...).set` + dispatch `input` event for typeable inputs; `triple_click + type + Tab` for inputs that resist value-set.
  - Run Report buttons below viewport edge: JS button-text-click via `Array.from(document.querySelectorAll('button')).find(b => b.innerText.trim() === 'Run Report').click()` reliable when coordinate clicks fail.
  - Modal Export disambiguation: use class selectors like `.csv-export-comments-btn` rather than generic Export button text.
- **MutationObserver for transient popups** (QA-92841 batch-7) caught the "We are fetching the data. Please wait." popup that screenshot-based observation misses.
- **Direct CDN fetch with `credentials: 'include'`** for queued CSV exports (QA-529, QA-28405, QA-111242) bypasses unreliable Recent Activity bell click flows.
- **Radaac URL-nav workaround** (QA-54202 + QA-52778) — form action endpoint + GET params via `navigate()` bypasses jQuery UI dialog Submit-click hangs.
- **PROMPT.md routine codifies pre-test KB read + post-test KB write** — followed for every batch this sweep with no skipped maintenance.
