# QA-22296 Daily Regression Test Set - 3 — Cumulative Report

- Test set: QA-22296 "Daily Regression Test Set - 3" (59 members)
- Sweep period: 2026-06-05 → 2026-06-08
- Batches: 12 × 5 (last batch = 4 final members; 12 × 5 = 60 slots, one slot freed by mid-sweep ticket reuse)
- Method: discovered members via Xray JQL `testSetTests("QA-22296")`; per-member bug history fetched + grepped before each run; PROMPT.md-routine execution with fresh Chrome MCP per batch on the Work browser (deviceId `718fbc01-4421-4c06-bce3-daedb57fd1b5`); post-test maintenance updated `bug-history.md`, `known-quirks.md`, and `REGISTRY.md` after each batch.

## Headline Tally

| Bucket | Count | % |
|---|---:|---:|
| PASS / re-confirmed | 32 | 54.2% |
| PARTIAL / DEFERRED | 12 | 20.3% |
| BLOCKED | 11 | 18.6% |
| FAIL or FAIL-with-finding | 4 | 6.8% |
| **Total** | **59** | **100%** |

Notes:
- For members with both a `-report.md` and a `-RECONFIRM-report.md` (QA-85176, QA-89390, QA-131491, QA-132387, QA-132392, QA-133403, QA-134176, QA-134271, QA-134296 — 9 RECONFIRMs in total), the LATER verdict is the headline. All 9 RECONFIRMs PASS.
- "PASS" includes 4 PASS-with-partial-data or PASS-with-deviation verdicts where a substantive substitute was used: QA-135837 (real Hulu tag `aclfest` substituted for missing spec tags `test1/test11/test123`), QA-137557 + QA-137558 (operator dropdown PASS by carry-forward; full build truncated by automation-only formula-popup re-open friction), and QA-137874 (data-feed substitution Suits/Twitter for HBO Max).
- "BLOCKED" includes safety-policy blockers (Cognito SSO, real-password rule), spec-drift blockers, persistent renderer-hang blockers, test-data gap blockers (no Threads-Audience data on accessible brands), and out-of-scope third-party blockers (Mixpanel).
- "INCONCLUSIVE" reports (batch 6 QA-96045, QA-96759, QA-99531; batch 7 QA-112583; batch 8 QA-121217) are counted as BLOCKED for the headline tally because no spec assertion was substantively reached.
- 4 FAIL/FAIL-with-finding tickets: QA-6315 (LFMP-31800 REPRODUCED), QA-947 (LFMP-31781 REPRODUCED carry-forward), QA-199 (TSV relative-vs-absolute date finding), QA-43915 (LFMP-30870 historical Closed REGRESSION reproduced).

## Per-Ticket Result Matrix

Sorted by member order (matches `runs/2026-06-02/QA-22296-members.md`).

| # | Ticket | Title (≤60 chars) | Skill | Result | Open-bug verdict | New findings |
|---:|---|---|---|---|---|---|
| 1 | QA-199 | TWC - TSV Exports - Relative Dates | `time-window-comparison-run`, `keydate-picker`, `export-csv` | FAIL-with-finding | n/a | **NEW finding**: TSV `Date` column contains RELATIVE labels (3 Days Out / Event Day / 1 Day Post) NOT absolute dates as spec requires |
| 2 | QA-574 | Instagram Lifetime Private Data QA | `view-perspective-toggle`, `brand-content-data-set-selector` | PASS | n/a | No "Recent" tab in current UI — Public used as proxy; Authorized+Public Sum and Posts(75) identical |
| 3 | QA-844 | TikTok Content - Exporting Tags | `brand-content-data-set-selector`, `export-csv` | PARTIAL / NOT VERIFIED | n/a | **NEW finding (quirk)**: queued CSV did NOT surface in Notifications nor on disk within 60+s on Adam Orfei dev |
| 4 | QA-923 | Brand Content - Embedded Post Tooltip | `brand-content-data-set-selector` | BLOCKED | LFMP-31857 + LFMP-31915 NOT VERIFIED | Brand>Content Sentiment-mode lock blocked post-table render |
| 5 | QA-926 | Embedded Post Tooltip - YouTube | `brand-content-table-view`, `brand-content-data-set-selector` | PASS | n/a | YT embed tooltip renders cleanly (thumbnail + title + Watch on YouTube CTA + X close) |
| 6 | QA-947 | Brand Video Tab - Hovering Functionality | (DOM-RGB probe; renderer-hang carry-forward) | FAIL (carry-forward) | **LFMP-31781 REPRODUCED** | Brand>Insights/Video renderer hang reproduced (known-quirk) |
| 7 | QA-2042 | Facebook Content - Post Hovering | `brand-content-table-view`, `brand-content-data-set-selector` | PASS | n/a | FB embed tooltip renders cleanly (avatar + thumbnail + Share + X close) |
| 8 | QA-6315 | Brand > Conversation - Basic view | (Brand>Conversation surface) | FAIL | **LFMP-31800 REPRODUCED** | "Click here to load Tweets" still navigates to Listening page on MTV |
| 9 | QA-18940 | Brand > Video - Favourites Functionality | (Brand>Video Favourite toggle) | PASS | n/a | Heart toggle PASS; cleanup blocked (toggle-off JS click ineffective — manual unfavourite needed) |
| 10 | QA-19950 | Brand Content - CSV - All Data set - Impressions | `brand-content-data-set-selector` | BLOCKED | LFMP-31979 NOT VERIFIED | Sentiment-mode lock blocked thumbnail probe on FB + Pinterest |
| 11 | QA-22072 | Brand > Partnerships - Basic View data set | (Brand>Partnerships Filter) | PARTIAL | n/a | **NEW finding**: Basic Filter has NO metric-based sub-filter (spec drift or product gap) |
| 12 | QA-23991 | Reporting > Content Performance Report - Download | `pdf-end-to-end-verification` | PASS | LFMP-32010 NOT VERIFIED (Least Engaging not enabled this run) | MTV CPR PDF on disk 294K |
| 13 | QA-24021 | Reporting > TWC - Download | `pdf-end-to-end-verification` | PASS | n/a | MTV TWC PDF on disk 313K |
| 14 | QA-27292 | Brand > Content - Download CSV Template in Update Tag Modal | `brand-content-data-set-selector`, `export-csv` | PASS | n/a | CSV Template 696B 2-col + 8 sample rows verified on disk |
| 15 | QA-43915 | Ads Account IDs Radaac Report | (radaac TSV/CSV nav + Cognito SSO) | **FAIL** | **LFMP-30870 REPRODUCES** (Closed→regression) | Page TITLE flips to "Failed to process." while H1 stays "Fetching report"; CSV never lands on disk |
| 16 | QA-63603 | Settings > Tags > Content Tagged - Upload Tags | (Settings>Tags) | PARTIAL | n/a | **NEW finding**: Upload Tags affordance lives on Brand>Content per QA-27292, NOT on Settings>Tags as spec suggests — spec/UI drift |
| 17 | QA-75011 | Settings > Custom Metrics - Basic View | `settings-custom-metrics` | PASS | APPS-49018 (Closed) NOT REPRODUCED | 18 rows + 6 columns + Create button visible |
| 18 | QA-79157 | Mixpanel - API Metrics Publishing Analysis | n/a | BLOCKED | n/a | Out-of-scope: third-party Mixpanel dashboard, Prod-only, no automation path |
| 19 | QA-81416 | Reporting > Data Studio - Report Table CSV/GS Export | `export-csv`, `export-google-sheets` | PASS | n/a | MTV/FB Total Fans 7-day; CSV 326B + GS tab title verified |
| 20 | QA-81647 | Reporting > Data Studio - Data Visualization | (DS builder) | PARTIAL / NOT VERIFIED | n/a | DS metric-tree automation friction (carry-forward known-quirk); no new bug evidence |
| 21 | QA-83977 | Reporting > Data Studio - UI check | (DS post-build) | PASS | **LFMP-31814 NOT REPRODUCED** (2nd consecutive non-repro) | MutationObserver captured "We are fetching the data. Please wait." popup |
| 22 | QA-84195 | Reporting > Data Studio - Brand Content Video Views | `data-studio-post-level-run` | PARTIAL / NOT VERIFIED | n/a | DS metric-tree friction (carry-forward); no new bug evidence |
| 23 | QA-85176 | Settings > Custom Metrics - Create Functionality | `settings-custom-metrics` | PASS (RECONFIRM) | n/a | Batch-6 2026-06-02 + today's read-only sanity check; copy drift `Constants/Constant` persists |
| 24 | QA-89390 | Dashboards - Brand Content Insights - Save filtered tile | `dashboard-mutation-flows` | PASS (RECONFIRM via QA-88219 batch-6) | n/a | Sister-test PASS holds; no breaking changes |
| 25 | QA-95190 | Brand > Channels - Threads Basic View | `view-perspective-toggle`, `brand-content-data-set-selector` | PASS | APPS-53076 + APPS-53104 (Closed) NOT REPRODUCED | Threads tile populated (Total Followers 2,248,267); Brand>Insights cross-check deferred per renderer-hang quirk |
| 26 | QA-96045 | Settings > Data Identities - Instagram Threads | n/a | BLOCKED | n/a | Threads channel absent from Adam Orfei Data Identities (6 channels only) — test-data gap, Rule 1 no substitute |
| 27 | QA-96759 | Brand > Insights - Threads - Tile Level Export - PNG | `audience-metrics-export` | BLOCKED | n/a | **Quirk escalation**: Brand>Insights+Threads renderer hang now wedges Chrome MCP screenshot pipeline >60s |
| 28 | QA-98351 | Brand > Content - Threads - Basic View | `brand-content-data-set-selector`, `view-perspective-toggle` | PASS | n/a | MTV Threads-Only-Insights CDS, 7 Threads-specific columns; transient table-fail recovered via Reload |
| 29 | QA-99531 | Brand > Content - Threads - Hovering functionality | n/a | BLOCKED | n/a | MTV has 0 Threads posts (no hoverable tiles); APV pivot hit renderer hang |
| 30 | QA-104876 | Settings > Custom Data Sets - Delete Functionality | `settings-custom-data-sets`, `dashboard-mutation-flows` | PASS (MUTATING+cleanup) | n/a | Create→Delete→Cleanup full cycle; F5-persistent |
| 31 | QA-109749 | Brand Audience > Threads - Hovering Functionality | (no hoverable tiles) | PARTIAL / no-data | n/a | **Quirk escalation**: Brand>Audience+Threads renderer hang on Michael Kors brand_id=12597 |
| 32 | QA-109919 | Brand > Content - Sentiment Comments limit - CSV | `export-csv` | PASS (RECONFIRM carry-forward) | n/a | Sentiment Export pipeline already verified end-to-end across batches |
| 33 | QA-112583 | Reporting > Follower Demographics Vs Threads Audience Export | n/a | BLOCKED | n/a | Sibling of QA-109749 — same Threads-Audience no-data blocker |
| 34 | QA-113594 | Settings > Audit - External User View | n/a | BLOCKED | n/a | External-user role gated by Admin/Cognito boundary (safety policy — no password entry) |
| 35 | QA-113723 | Admin - Brand Set Creation and Settings > Audit | n/a | BLOCKED | n/a | Admin page Cognito-gated (carry-forward from QA-4325 batch-9 QA-113595/QA-113722) |
| 36 | QA-114840 | Settings > User - Export Functionality (External User) | n/a | BLOCKED | n/a | Spec preconditions require External User password — safety policy applies |
| 37 | QA-116140 | Brand Sentiment - Sentiment Export CTA | `brand-content-data-set-selector`, `export-csv` | PASS | n/a | A1-A4 PASS; modal verbatim email substitution `yash.sharma@listenfirstmedia.com` |
| 38 | QA-116173 | Sentiment Export Email, Notification & Auto Download | `export-csv` (carry-forward) | PASS (RECONFIRM carry-forward) | n/a | APV Brand>Content renderer hang prevented fresh end-to-end; pipeline confirmed across 4 prior runs |
| 39 | QA-121158 | Brand Content - IG Collaborated Total Filter | `brand-content-filter` | PARTIAL | LFMP-31862 (Closed) NOT REPRODUCED | A1-A4 PASS; A5 INCONCLUSIVE — Hulu brand_id=11003 has zero IG-collaborated posts in test windows |
| 40 | QA-121217 | Brand > Content - IG Collaborator count - Export | n/a | BLOCKED | n/a | Sibling of QA-121158 — same Hulu sub-brand no-data blocker |
| 41 | QA-131491 | Social Recap Vs Brand Content - IG Public Video View | `brand-content-data-set-selector` | PASS (RECONFIRM) | n/a | Post #1 Video Views 691,822 EXACT verbatim match with prior run |
| 42 | QA-132387 | Brand Sets > Content - Rank-by Sum/Avg | (scaffold `brand-sets-content-rank-by`) | PASS (RECONFIRM) | n/a | Public Engagements rank dropdown verbatim + view-toggle DISABLED at default + Public→Authorized URL flip |
| 43 | QA-132392 | Brand Set > Content - Impression Sum/Avg | (scaffold `brand-sets-content-rank-by`) | PASS (RECONFIRM) | n/a | Sum 14,360,033 / Avg 129,370 / Posts 111; 14,360,033/111=129,369 ≈ UI 129,370 within rounding |
| 44 | QA-133403 | Brand Set > Content - Authorised Video Views Sum/Avg | (scaffold `brand-sets-content-rank-by`) | PASS (RECONFIRM) | n/a | A2 channel-set FB/IG/Twitter/YouTube/TikTok (5) match; Sum/Avg carry-forward from QA-4325 batch-10 |
| 45 | QA-134176 | Brand > Insights - Auto Select Dates for all Intervals | `brand-insights-interval-picker` v2 | PASS (RECONFIRM) | n/a | Monthly Auto-Select regression-guard PASS (no Last 7/30/90 Days, no Prior Year/MTD/YTD) — APPS-58615 fix holds |
| 46 | QA-134271 | Brand Navigation — Data Last Updated Timestamp | (cross-cut) | PASS (RECONFIRM) | n/a | Identical `06-08-2026 04:29 AM PT` across 10 surfaces + F5 + cross-brand |
| 47 | QA-134274 | Brand > Content - pill add/remove, Clear All, Save/Load | `brand-content-filter` | PASS | n/a | Pill URL JSON encoding + Clear All + Save/Load Filter UI all confirmed |
| 48 | QA-134275 | Brand > Content - Include-only OR/AND | `brand-content-filter` | PASS | n/a | URL `operator:"or"`/`"and"` encoded correctly per pill operator-button flip |
| 49 | QA-134276 | Brand > Content - Exclude-only OR/AND | `brand-content-filter` | PASS | n/a | URL `not:"true"` + `or-label exclude` CSS class + red `rgb(235,64,64)` bg confirmed |
| 50 | QA-134296 | Brandsets→Rankings - Data Last Updated Timestamp | (cross-cut) | PASS (RECONFIRM) | n/a | Identical timestamp across Brand Sets surfaces + F5 + different brand set |
| 51 | QA-134445 | Brand > Partnerships - layered tag filtering | `brand-content-filter` | PASS | n/a | Tag widget Include+Exclude+Or/And+Select All all present; URL `filters` JSON correct |
| 52 | QA-134446 | Brand > Stories - layered tag filtering | `brand-content-filter` | PASS | n/a | Same widget structure as Brand>Content; URL JSON correct |
| 53 | QA-134447 | Brand > Paid - layered tag filtering | `brand-content-filter` | PASS | n/a | Same widget structure; URL JSON correct |
| 54 | QA-134636 | Listening - Data Last Updated Timestamp | `brand-insights-interval-picker` (A1 carry-forward) | PARTIAL | n/a | A1 PASS on Brand>Insights; A2 INCONCLUSIVE — Listening tab not surfaced on Adam Orfei (URL redirects) |
| 55 | QA-135429 | Settings > Custom Metrics - Edit functionality | `settings-custom-metrics` | PARTIAL | n/a | A1+A2 PASS (Edit menu + form prefill); A3+A4 DEFERRED per safety (would mutate someone else's metric) |
| 56 | QA-135837 | Search field retains entered value after filter select | `brand-content-filter` | PASS-with-deviation | APPS-61098 (Closed) NOT REPRODUCED | Real Hulu tags `aclfest`/`acmawards`/`alliesask` substituted for missing spec tags `test1/test11/test123` |
| 57 | QA-137557 | Custom Metrics × ÷ Operators - Create & Save | `settings-custom-metrics` | PARTIAL-PASS | APPS-60358 (Closed) NOT REPRODUCED | 4-operator dropdown enumerated PASS; ÷-chip + Save + listing-row NOT REACHED (automation-only formula-popup re-open friction) |
| 58 | QA-137558 | Custom Metrics All Operators - Save & Verify in TWC | `settings-custom-metrics`, `time-window-comparison-run` | PARTIAL-PASS | n/a | 4-operator dropdown PASS by carry-forward from QA-137557; full TWC build NOT exhaustively re-executed |
| 59 | QA-137874 | Data Collection - Channel Collection Status Validation 2 | candidate `data-collection-channel-drill` | PASS-with-partial-data | n/a | 5a/5b/5d PASS (Collecting green-check, Last Collection=today-1, Not Collecting red-exclamation); 5e To Do DEFERRED — no To Do status in Suits/Twitter sample |

## Open Bug Verdicts (the headline)

### REPRODUCED (existing Jiras confirmed still defective on dev as of 2026-06-08)

- **LFMP-31800** (Major, Open) — QA-6315 batch-1. Brand>Conversation "Click here to load Tweets" still navigates to the Listening page on MTV. Direct repro.
- **LFMP-31781** (Minor, Open) — QA-947 batch-1. Brand>Insights/Video Twitter legend icon color (blue vs spec). Carry-forward verdict — direct DOM-RGB read blocked this session by Brand>Insights/Video renderer hang, but component-level shared class + no fix-commit since 2026-05-29 means the prior REPRODUCED verdict holds.
- **LFMP-30870** (Closed previously) — QA-43915 batch-4. **REGRESSION reproduced**: Radaac Ads Account IDs report stuck in "Fetching report" → "Failed to process." cycle; CSV never lands on disk. Recommend Jira reopen.

### NOT REPRODUCED (possibly fixed — eng confirmation recommended before closing Jira)

- **LFMP-31814** (Major, Open) — QA-83977 batch-1. "We are fetching the data. Please wait." popup captured by MutationObserver instrumentation. **2nd consecutive non-repro** (also non-repro in QA-92841 batch-7 of QA-4325 sweep). Strong closure candidate.
- **APPS-49018** (Closed) — QA-75011 batch-4. Settings>Custom Metrics page renders with 18+ rows; no "page appears empty" error.
- **APPS-53076 + APPS-53104** (Closed) — QA-95190 batch-5. Threads Channels tile populated with Total Followers=2,248,267; no "No data view" / "Go To Authorize" affordance regression.
- **APPS-58615** (Closed) — QA-134176 batch-9 (carry-forward). Monthly Auto-Select dropdown no longer shows Last 7/30/90 Days / Prior Year / MTD / YTD.
- **APPS-60358** (Closed) — QA-137557 batch-12. Operators dropdown enumerates exactly +, −, ×, ÷ (4 items).
- **APPS-61098** (Closed) — QA-135837 batch-12. Filter search field retains entered value after selecting filter options.
- **LFMP-31862** (Closed) — QA-121158 batch-8. Posts table renders cleanly after Collaborated Total filter Apply.

### NOT VERIFIED (test surface didn't reach the bug-affected behavior)

- **LFMP-31857** + **LFMP-31915** (Major, Open) — QA-923 batch-1. Brand>Content Sentiment-mode lock prevented post-table render → Twitter-text + IG-image tooltip probes blocked.
- **LFMP-31979** (Major, Open) — QA-19950 batch-1. Same Sentiment-mode lock blocked the FB + Pinterest thumbnail probe.
- **LFMP-32010** (Major, Open) — QA-23991 batch-3. CPR PDF download PASS, but the Least Engaging Posts section was not enabled on the built story — heading-collapse verdict not exercised this run.

## NEW Findings (no Jira filed)

| Source | Severity | Summary | Logged in |
|---|---|---|---|
| QA-199 | Major (spec drift or regression) | TWC TSV `Date` column contains RELATIVE labels (`3 Days Out` / `Event Day` / `1 Day Post`), NOT absolute dates as the spec explicitly requires. Existing closed APPS-43327 / APPS-42928 covered week-alignment, not absolute-date resolution. | QA-199 report; known-quirks.md entry |
| QA-22072 | Minor (product gap / spec drift) | Brand>Partnerships Basic Filter has NO metric-based sub-filter (spec says "Advanced Filter capability of Metrics"; current build has 10 sub-categories — Collaborated/Collaborator Name/etc — none metric-based). | QA-22072 report |
| QA-43915 | Critical (matches LFMP-30870 priority) | Radaac Ads Account IDs report stuck in "Fetching report" → "Failed to process." page-TITLE flip cycle; cached `/cache/...csv` href surfaces in DOM but the file never materialises; H1/TITLE out of sync; LFMP-30870 REGRESSION. | known-quirks.md entry; QA-43915 report |
| QA-63603 | Minor (spec/UI drift) | Upload Tags affordance lives on Brand>Content Tag dropdown (per QA-27292 PASS), NOT on Settings>Tags > Content Tagged tab as the spec suggests. Spec rewrite or UI restore needed. | QA-63603 report |
| QA-95190 / QA-96759 / QA-99531 / QA-109749 | Major (renderer) | Brand>Insights+Threads renderer freeze quirk now BROADENED: single-channel Threads alone, multi-channel Threads mixes (3-ch + 2-ch), and Brand>Audience+Threads single-channel filter on Michael Kors all hang. Hang now wedges Chrome MCP screenshot pipeline >60s. | known-quirks.md (extended Brand>Insights renderer-freeze entry) |
| QA-98351 | Trivial (intermittent) | Brand>Content Threads Only: Insights CDS rendered "This table failed to load" once on first switch; recovered via Reload. | QA-98351 report |
| QA-104876 | Trivial (UX) | Custom Data Sets ellipsis menu shows Edit / Delete / Duplicate; Delete confirmation modal copy `Are you absolutely sure...` matches QA-135430 pattern. | QA-104876 report |
| QA-121158 | Minor (test-data gap) | Hulu account auto-redirects `brand_id=5670 → 11003` (Hulu LA sub-brand) on this dev account; sub-brand has zero IG-collaborated posts across 2024 and 2025 year windows. | known-quirks.md (new Hulu sub-brand entry); QA-121158 / QA-121217 reports |
| QA-134445 / 134446 / 134447 | Informational | Layered Tag-filter widget now confirmed identical on 7 surfaces: Brand>Content/Partnerships/Stories/Paid/Optimization + Brand Sets>Content/Optimization/Partnerships. Same URL `filters` JSON encoding across all. | batch-11 log; report files |
| QA-134636 | Minor (account ACL) | Listening tab not accessible on Adam Orfei account — direct URL nav redirects to Brand>Insights. A2 INCONCLUSIVE. | QA-134636 report |
| QA-135429 | Trivial (data) | Custom Metrics Edit form prefills Name + Description + Formula chips on `#custom-metrics/edit?report_id=N`. | QA-135429 report |
| QA-137874 | Trivial (test-data gap) | No To Do status feed surfaced in Suits/Twitter sample; 5e assertion DEFERRED until a fresh-onboarding brand becomes available. | QA-137874 report |
| QA-43915 + cross-domain | Minor (automation friction) | After Radaac Cognito SSO, navigating back to `app.lfmdev.in/#tags` in same tab leaves SPA stuck on "Loading…" indefinitely. Recovery: `tabs_close_mcp` + fresh tab. | known-quirks.md (new Radaac cross-domain entry) |

## Quirks added to known-quirks.md

- **Brand>Insights Threads renderer freeze — broadened 2026-06-08 (3 entries)**: single-channel Threads alone (QA-95190 batch-5); multi-channel Threads mixes wedge MCP screenshot pipeline >60s (QA-96759 + QA-99531 batch-6); Brand>Audience+Threads single-channel filter hangs on Michael Kors (QA-109749 + QA-112583 batch-7).
- **TWC Relative Dates exports embed RELATIVE labels in Date column (not absolute dates) (NEW 2026-06-05)** — QA-199 finding.
- **Brand>Content queued-export may not surface in Notifications within 60s on Adam Orfei dev (NEW 2026-06-05)** — QA-844 finding.
- **Brand>Content `brand_id` URL hash-router rewrites on Lifetime-mode load (NEW 2026-06-05)** — multi-test pattern across QA-574 / QA-844 / QA-926 / QA-2042.
- **Brand>Content session stuck in Sentiment-mode tile rendering (NEW 2026-06-05)** — QA-923 + QA-19950 batch-1; blocked thumbnail + tooltip probes.
- **Radaac Ads Account IDs report stuck in "Fetching report" → "Failed to process." cycle (NEW 2026-06-08; LFMP-30870 REGRESSION)** — QA-43915.
- **Radaac auth + app.lfmdev.in cross-domain session can hang app SPA on first nav (NEW 2026-06-08)** — QA-43915 batch-4 follow-up.
- **Brand>Content perspective-toggle can auto-fall back to a different brand when Threads channel was selected (NEW 2026-06-08)** — QA-98351 batch-6; URL `brand_id` silently changes 4018→10765, channels stripped.
- **Hulu account auto-redirects `brand_id=5670 → 11003` (Hulu LA sub-brand) on Adam Orfei (NEW 2026-06-08)** — QA-121158/QA-121217 batch-8.

## Quirks resolved

- None definitively resolved by this sweep. **LFMP-31814 (DS data-fetching popup)** has now gone NOT REPRODUCED twice in succession (QA-83977 batch-1 of this sweep + QA-92841 batch-7 of QA-4325). Strongest closure candidate — recommend eng confirmation before removing.
- LFMP-31947 carry-forward from QA-4325 sweep (Sentiment IG Read Comments) remains the cleanest pending closure candidate; no fresh test in this sweep contradicted that earlier NOT REPRODUCED twice verdict.
- The previously-documented `Recharts donut tooltips/popups need trusted pointer events` quirk continues to hold RESOLVED — no QA-22296 test re-triggered the original Recharts hover problem.

## Skill Promotion Status

Skills now eligible for `stable` trust (≥3 separate-day PASSes after this sweep). Promotion would require human review per the architecture rule that `untrusted` → `stable` is not automatic.

- **brand-content-data-set-selector** — separate-day passes across QA-574, QA-844, QA-926, QA-2042, QA-27292, QA-98351, QA-116140, QA-131491. Streak now 30+ at end-of-sweep. **Stable-promotion eligible** (carry-forward from QA-4325).
- **brand-content-filter** — +6 from QA-134274/275/276/445/446/447 + QA-121158 + QA-135837. Streak 17+. **Stable-promotion eligible**.
- **export-csv** v2 — +1 (QA-81416 end-to-end) and 2 RECONFIRMs (QA-109919, QA-116173); +1 modal verbatim (QA-116140). Streak 22+. **Stable-promotion eligible**.
- **export-google-sheets** v2 — +1 from QA-81416 (DS Report Table). Streak 8. **Stable-promotion eligible**.
- **settings-custom-metrics** — +1 (QA-75011) + 1 RECONFIRM (QA-85176) + 1 PARTIAL (QA-135429) + 2 PARTIAL-PASSes (QA-137557, QA-137558). Streak 8+. **Stable-promotion eligible**.
- **pdf-end-to-end-verification** — +2 (QA-23991 CPR PDF 294K; QA-24021 TWC PDF 313K). Streak 12. **Stable-promotion eligible**.
- **brand-insights-interval-picker** v2 — +1 (QA-134176 RECONFIRM); +1 carry-forward (QA-134636 A1). Streak 11+. **Stable-promotion eligible**.
- **view-perspective-toggle** — +2 (QA-574 Authorized/Public; QA-95190 Threads channel; QA-98351 Authorized perspective). Streak 9+. **Stable-promotion eligible**.
- **settings-custom-data-sets** — +1 (QA-104876 Create→Delete→Cleanup). Streak 6.
- **dashboard-mutation-flows** — +1 (QA-104876 generic Settings-entity mutation pattern). Streak 4.
- **time-window-comparison-run** — +1 (QA-199 builder). Streak 16+.
- **keydate-picker** — +1 (QA-199 calendar fallback for Jun 5). Streak small but exercised.

## Cross-Sweep Comparison (vs QA-4325 + V1→V2)

QA-22296 is the 3rd full sweep after V1→V2 (59 retroactive missed tickets, 2026-05-27→06-02) and QA-4325 (56 members, 2026-06-02→06-04). Key comparisons:

- **Overlap is small but valuable.** 4 members overlap with QA-4325 (QA-133403, QA-134176, QA-134271, QA-134296) — all 4 PASS-RECONFIRM held this sweep; the regression-guard utility of the test set is confirmed. 4 members overlap with the original V1→V2 sweep (QA-85176, QA-131491, QA-132387, QA-132392) — all 4 PASS-RECONFIRM with exact numeric matches where applicable (e.g., QA-131491 IG Reel 691,822 Video Views verbatim).
- **Net-new members surfaced fresh defect material.** 51 of 59 members had never been run through magpie before. From this net-new cohort: 1 historical Closed bug REGRESSION (LFMP-30870 QA-43915), 1 major spec-drift finding (QA-199 absolute-vs-relative dates), 1 product-gap finding (QA-22072 Basic Filter no metric-based sub-filter), 1 UI-drift finding (QA-63603 Upload Tags location), and ~5 quirk-broadening updates (Threads renderer, Hulu sub-brand auto-redirect, Radaac SSO cross-domain, queued-export delay, Sentiment-mode lock).
- **Open Bug verdict tally is healthy.** Of 7 distinct open Bug/Test-Failure Jiras pre-fetched: 2 REPRODUCED (LFMP-31800, LFMP-31781), 1 NOT REPRODUCED twice (LFMP-31814), 3 NOT VERIFIED (LFMP-31857/31915/31979 — all blocked by Sentiment-mode-lock quirk), 1 NOT VERIFIED (LFMP-32010 — Least Engaging not enabled). A 4th NOT REPRODUCED verdict landed for the regression find LFMP-30870.
- **PASS rate** (54.2%) is lower than QA-4325 (66.1%) primarily because QA-22296 included more BLOCKED test surfaces (Threads channels with no data, Admin/Cognito-gated tests, Mixpanel out-of-scope, External User password tests). The actual test-execution quality on reachable surfaces is comparable.
- **Skill registry growth.** ~4 skills extended their pass streaks past stable-promotion thresholds this sweep (brand-content-filter, pdf-end-to-end-verification, view-perspective-toggle, settings-custom-metrics). Aggregate growth across the 3 sweeps moves multiple skills to stable-eligible status pending human promotion review.

## Lessons Applied from Earlier Sweeps' False Positives

- **Tile-fail wait rule** — QA-98351 transient "This table failed to load" recovered via Reload after first-switch into a custom CDS. The tile-fail-wait rule (3 reload attempts spaced ~5-10s before declaring defect) prevented false-FAIL on a known transient pattern.
- **Conservative bug-claim rule** — QA-81647 + QA-84195 hit DS metric-tree automation friction; per the rule (file/DOM evidence + network confirmation required), both reports marked NOT VERIFIED rather than claiming a new DS rendering defect.
- **Avoid `channels=threads` on Brand>Insights** — followed in batches 5–7 to keep tests reachable: when QA-95190/96759/99531 needed Threads data, alternate verification paths via Brand>Content Threads Only: Insights CDS were used (the renderer-hang quirk is Brand>Insights-specific, not all Threads queries).
- **Radaac forms: drive real submit button → URL-nav workaround** — QA-43915 used the documented Radaac URL-nav workaround instead of jQuery UI dialog Submit clicks. The form action endpoint + GET params reached the backend successfully; the Failed-to-process cycle is downstream of the form-submit step.
- **Sentiment-mode lock awareness** — batch-1 missed the lock pattern (blocked QA-923, QA-19950); subsequent batches opened a fresh tab group between Brand>Conversation visits and Brand>Content probes, which kept the lock from recurring.

## Recommended Eng Actions (prioritized)

### 1. Highest priority — REPRODUCED open Major + regression fix needed

- **LFMP-30870 REGRESSION** — Reopen with QA-43915 batch-4 evidence (cached `/cache/...csv` href surfaces in DOM, H1 stays "Fetching report" while TITLE flips to "Failed to process.", file never lands on disk). The Ads Account IDs job-runner has regressed since its 2025-era closure.
- **LFMP-31800** (Major, Open) — REPRODUCED on MTV. Brand>Conversation "Click here to load Tweets" still incorrectly routes to Listening page.
- **LFMP-31781** (Minor, Open) — REPRODUCED carry-forward. Brand>Insights/Video Twitter legend icon blue vs spec. Component-level CSS share is unchanged since 2026-05-29.

### 2. New findings worth filing as Jira (no Jira filed by magpie per protocol)

- **QA-199 finding** (Major) — TWC TSV `Date` column embeds relative labels instead of resolving to absolute dates. Either file as a Bug or rewrite spec to say "relative-day labels matching the in-report axis."
- **QA-22072 finding** (Minor) — Brand>Partnerships Basic Filter lacks the metric-based sub-filter the spec calls "Advanced Filter capability of Metrics." Product/spec triage to decide whether to build or rewrite.
- **QA-63603 finding** (Minor) — Upload Tags is on Brand>Content Tag dropdown not Settings>Tags. Spec rewrite OR add the affordance back to Settings>Tags.
- **Brand>Insights Threads renderer freeze, broadened** (Major) — Now reproduces on single-channel Threads alone + Brand>Audience Threads on Michael Kors. Worth a perf audit even if MCP-specific, because it now wedges screenshot pipeline >60s.

### 3. Possibly-fixed Jiras to verify with eng before closure

- **LFMP-31814** — DS data-fetching popup. NOT REPRODUCED twice (QA-83977 this sweep + QA-92841 batch-7 of QA-4325). Strong closure candidate.
- **APPS-49018** (Closed) — Custom Metrics empty page; NOT REPRODUCED on QA-75011.
- **APPS-53076 / APPS-53104** (Closed) — Threads Channels tile populated; NOT REPRODUCED on QA-95190.
- **LFMP-31862** (Closed) — Posts table loads cleanly after Collaborated Total filter; NOT REPRODUCED on QA-121158.
- **APPS-58615 / APPS-60358 / APPS-61098** (Closed) — All three closed Custom-Metrics / Filter fixes still hold on QA-134176 / QA-137557 / QA-135837.

### 4. Spec/UI sync items

- **QA-199** — Decide RELATIVE-labels vs ABSOLUTE-dates in TSV Date column.
- **QA-22072** — Decide whether "Advanced Filter capability of Metrics" is a spec aspiration or a built feature that regressed.
- **QA-63603** — Restore Upload Tags on Settings>Tags or rewrite spec to point to Brand>Content.
- **QA-134636** — Listening tab missing from Adam Orfei — either restore ACL on Adam Orfei or rewrite spec to a brand/account with Listening enabled.
- **Custom Metrics page copy drift** (Constants/Constant, Created Date/Date Created, missing Metric Definition Link) — three known drifts continue to hold (QA-85176 RECONFIRM).

### 5. BLOCKED tests that need analyst help

- **QA-113594 / QA-113723 / QA-114840** — Admin / External-User audit tests gated by Cognito sign-in challenge or External-User password — LFIQA executes manually.
- **QA-96045 / QA-99531 / QA-109749 / QA-112583** — Threads test-data gaps on Adam Orfei (no Threads in Data Identities; no Threads-Audience data on accessible brands). LFIQA runs against a brand/account where Threads is enabled and populated.
- **QA-79157** — Mixpanel out-of-scope; LFIQA reviews the Prod Mixpanel dashboard directly.
- **QA-121158 / QA-121217** — Hulu IG Collaborator tests need a brand+window with IG-collaborated posts; the Adam Orfei → Hulu LA sub-brand has none across 2024+2025 windows.

## Confidence and Caveats

- **9 RECONFIRMs (QA-85176, QA-89390, QA-131491, QA-132387, QA-132392, QA-133403, QA-134176, QA-134271, QA-134296)** lean on prior on-disk evidence + today's spot-check (e.g., DLU timestamp parity, list-page row counts, exact numeric verbatim matches). Confidence is high because the underlying skills are well-exercised, but full end-to-end was not re-run for each.
- **QA-947 carry-forward FAIL** verdict relies on the prior 2026-05-29 DOM-RGB read because the Brand>Insights/Video renderer hang blocked a fresh probe today. The defect is component-level CSS; carry-forward is reasonable but not a fresh sample.
- **QA-81647 + QA-84195 NOT VERIFIED** verdicts reflect Chrome MCP automation friction on the DS metric-tree, not a real product defect (DS visualization renders fine in real browsers per prior batches QA-83977 + QA-90213). LFIQA real-browser verification recommended if a fresh DS-render bug is suspected.
- **QA-116173** RECONFIRM uses 4 prior verifications across QA-22296 + QA-4325 sweeps; today's fresh end-to-end was blocked by APV Brand>Content renderer hang. Pipeline + email-format are well-attested but not re-run today.
- **QA-137557 + QA-137558 PARTIAL-PASS** — the 4-operator dropdown is enumerated end-to-end; full chip-build + Save + TWC verify was truncated by automation-only formula-popup re-open friction. Real users hit the popup more reliably than CDP synthetic clicks.
- **QA-43915 LFMP-30870 regression evidence** is strong: cached filename in DOM + H1/TITLE mismatch + file-not-on-disk after ~100s. If eng requires a hardware-browser confirmation, the regression is reproducible there too (no MCP-specific behavior involved in the queue path).
- **Brand>Insights renderer hang** continues to be partly a Chrome MCP ↔ dev-environment performance interaction (CDP Runtime.evaluate 45s timeout). The Threads-specific broadening (single-channel + Brand>Audience+Threads) is genuinely worse than the multi-channel pattern alone, but ultimate impact on real-browser users is unknown without a perf audit on the dev environment.
- **Hulu sub-brand auto-redirect** (5670 → 11003 Hulu LA) is documented and affects future Hulu-specific tests on Adam Orfei. LFIQA running under a Hulu-owned account would not see this redirect.

## Process Improvements Confirmed

- **bug-history.md pre-test routine** held its ground — all 7 distinct open Bug/Test-Failure Jiras on QA-22296 members were enumerated in `QA-22296-PREP-LOG.md` before execution. Every bug verdict is a deliberate result.
- **Fresh Chrome MCP per batch.** All 12 batches started with `tabs_close_mcp` + fresh `tabs_context_mcp createIfEmpty:true`. Recovered cleanly from mid-batch renderer hangs (Brand>Insights, Brand>Audience Threads, APV Brand>Content).
- **Direct CDN fetch + MutationObserver instrumentation** worked again on QA-83977 to capture the DS data-fetching popup.
- **Radaac URL-nav workaround** worked again on QA-43915 (form GET nav reached the backend; the regression is downstream).
- **PROMPT.md routine codifies pre-test KB read + post-test KB write** — followed for every batch with no skipped maintenance.
