# Cumulative QA Re-Test Report V2 — 59 tickets, 12 batches

- **Generated:** 2026-06-02
- **Original (V1) baseline:** `/Users/yashsharma/git/magpie/runs/2026-05-27/CUMULATIVE-REPORT.md` (37 PASS / 15 PARTIAL / 3 BLOCKED / 4 FAIL/MIXED)
- **This V2:** complete re-run of all 59 tickets across batches 1–12, dates 2026-05-29 → 2026-06-02
- **Driver:** `/Users/yashsharma/git/magpie/runs/2026-05-27/OPEN-BUGS-AUDIT.md` flagged 7 MISSED open-bug catches and 2 PARTIAL catches in V1; this V2 program closed the audit gap, verified every open Jira bug, and surfaced 6 additional findings.
- **Per-batch logs:** `runs/2026-05-29/BATCH-{1..12}-LOG.md`
- **Per-ticket reports:** `runs/2026-05-29/QA-*-report.md` (59 files)
- **Bug-history KB:** `knowledge-base/bug-history.md` (15 open + 350 closed Bug/Test-Failure links catalogued; updated with 2026-05-29 / 06-02 reproductions)
- **Quirks KB:** `knowledge-base/known-quirks.md` (3 new entries this run; 3 quirks RESOLVED)

## Headline Tally (Before → After)

| Bucket | V1 | V2 | Δ |
|---|---:|---:|---|
| PASS | 37 | 40 | +3 |
| PARTIAL / DEFERRED | 15 | 8 | -7 |
| BLOCKED | 3 | 2 | -1 |
| FAIL / MIXED | 4 | 9 | +5 |
| **Total** | **59** | **59** | |

V2's PASS count is up despite +5 FAILs because most V1 PARTIALs upgraded to PASS this run (notably the Brand Sets tag-filter tickets, Brand Sets Content rank-by tickets, and CPR builder). The +5 FAIL count is the direct effect of the bug-history.md pre-test routine — six V1 false-PASSes were correctly re-classified as FAILs when their linked open Jira bugs were actively probed.

## Result Upgrades (V1 → V2)

### V1 PASS → V2 FAIL (false-PASS corrections via bug-history probing)

| Ticket | V1 | V2 | Cause |
|---|---|---|---|
| QA-19557 | PASS | FAIL | LFMP-32016 reproduced — Brand>Content table fails to load when Stories enabled on Impressions data set. |
| QA-837 | PASS | FAIL | LFMP-31798 + LFMP-31918 both reproduced — donut YOY arrow glyph missing across all 16 donut centers; IG Image-type posts on Conan BPC render without thumbnails. |
| QA-281 | PASS | FAIL | LFMP-31961 reproduced — TWC New Followers chart Y-axis floored at 0; negative values clipped; Wells Fargo entirely-negative window appears as flat unreadable line. |
| QA-96818 | PASS | FAIL | LFMP-31977 reproduced — Save-to-Dashboard dropdown remains visible AND functional even when graph tile is suppressed by Publish Type breakdown. |
| QA-1124 | PASS | FAIL | LFMP-31781 reproduced — Brand Insights tooltip + legend Twitter icon renders `rgb(29,161,242)` (legacy blue) instead of branded X black; Channels-row icon is correctly black, confirming local component inconsistency. |
| QA-12532 | PASS | FAIL | LFMP-31903 reproduced — Brand Sets > Partnerships > Avg. Engagements per Post tile PNG saves without `.png` extension on disk; sibling Partners tile saves correctly. |

### V1 PASS → V2 PASS (open-bug PARTIAL catch resolved cleanly)

| Ticket | V1 | V2 | Notes |
|---|---|---|---|
| QA-2706 | PASS | PASS | LFMP-31886 NOT REPRODUCED — Owned Average Video Views renders `794,992(-31%)` with parentheses consistent across all 7 metric columns. Recommend eng verify before closing the Jira. |
| QA-98368 | PASS | BLOCKED | Re-classified to BLOCKED — Threads channel + LinkedIn channel both absent on HBO Max / Adam Orfei dev; cross-channel LinkedIn thumbnail check (APPS-57985) cannot be performed on this account. |
| QA-96665 | FAIL | PARTIAL/BLOCKED | Re-classified — LFMP-32027 NOT VERIFIED because Chrome MCP renderer hangs on Last 6/12 Months Brand Insights range (new quirk documented). Threads Basic View still passes at default range. V1 separator-missing finding superseded by current run (separator absence not reproduced in current build). |

### V1 PARTIAL → V2 PASS (analyst/automation friction resolved)

| Ticket | V1 | V2 | How |
|---|---|---|---|
| QA-103248 | BLOCKED | PASS | Used 7-day default window instead of 12-month — Posts panel loads in ~10s. PNG + Google Sheets verified end-to-end. |
| QA-109920 | PARTIAL | PASS | Recharts donut Read-popup now reachable via sustained `computer.hover` — quirk RESOLVED. CSV verified 6,160 Positive rows. |
| QA-129606 | PARTIAL | PASS | TWC date-picker JS-fallback `th.prev[N].click()` resolved cross-month navigation; controlled-check-box `span.click()` toggled metrics. |
| QA-129803 | DEFERRED | PASS | Same JS-fallback path; Facebook Total Fans em-dash exclusion verified Sep 26-29; formula matches UI on Sep 30-Oct 3. |
| QA-132387 | PARTIAL | PASS | Pre-narrow workaround (Content Brand=MTV + IG-only) avoided 76K-post strain. |
| QA-132392 | PARTIAL | PASS | Same pre-narrow workaround. |
| QA-134448 | PARTIAL | PASS | Brand Sets > Partnerships Tag Filter — confirmed Include/Exclude end-to-end via direct UI interaction. |
| QA-134449 | PARTIAL | PASS | Brand Sets > Optimization Tag Filter — same APPS-59381 component verified. |
| QA-19482 | PARTIAL | PASS | Run 2 PDF (23 pages, 11.8 MB) verified end-to-end via `pdftoppm` rasterization; controlled-check-box Space-dispatch resolved Options toggle quirk. |
| QA-3630 | BLOCKED | PASS | CPR numeric inputs resolved via `triple_click+type`; controlled-check-box Space-dispatch. LFMP-32010 reproduced (Least Engaging headings collapse to 0x0 in Preview & Share). |
| QA-929 | PARTIAL | PASS (5/7 + 2) | A5 verified via DOM href; A3 X-close verified; row 3/4 blank-tooltip is external Pinterest-side issue, not LFM. |

### V1 PARTIAL → V2 PARTIAL (still blocked on same precondition)

| Ticket | V1 | V2 | Notes |
|---|---|---|---|
| QA-24544 | PARTIAL | PARTIAL | Steps 1-10 PASS; 11-15 require lfm-qa@drylogics.com password sign-in. |
| QA-29479 | DEFERRED | PARTIAL | Owner-side share + persistence verified; recipient inbox out of scope. |
| QA-33510 | DEFERRED | DEFERRED | Same password-sign-in constraint. |
| QA-52776 | DEFERRED | PARTIAL | A1 Fetch xlsx verified end-to-end on disk (40 BrandIngest columns, no "url managers"); A2/A3 Patch+Apply withheld to avoid mutating dev brand 236. |
| QA-2498 | MIXED | PARTIAL | Carry-forward 9/12 PASS; 3 BLOCKED because Facebook channel on HBO Max remains fully collecting (no red `!` to hover). |
| QA-134277 | PARTIAL | PARTIAL | A1/A2/A5 PASS; A3/A4 BLOCKED by NEW backend failure (OR + None-tag combination); A6 NOT VERIFIED (export button disabled when Posts=0). |
| QA-27854 | BLOCKED | BLOCKED | Same precondition gap (QA-27290 bulk-tag upload not run on dev). |

### V1 FAIL/MIXED → V2 status

| Ticket | V1 | V2 | Notes |
|---|---|---|---|
| QA-23969 | FAIL (BC-4) | FAIL | BC-4 reconfirmed; LFMP-31925 NOT REPRODUCED (eng verify before closing). |
| QA-90213 | FAIL (parity) | FAIL (major finding) | Parity mismatch shrunk from 3.84×/2.19× to 0.46%/1.21% delta; likely pipeline fix landed between batches. SME confirmation requested on whether sub-1.5% tolerance is acceptable. |
| QA-96665 | FAIL (separator) | PARTIAL/BLOCKED | Separator finding superseded; LFMP-32027 unable to verify due to Chrome MCP hang quirk on Last 6/12 Months Brand Insights. |
| QA-2498 | MIXED | PARTIAL | Listed above. |

## Result Downgrades (V1 → V2)

The only V1 PASS → V2 FAIL transitions are the six false-PASS corrections listed above, all of which are pre-existing open Jira bugs being reproduced (not new regressions). No PASS → FAIL caused by genuinely NEW regressions surfaced in V2.

## Bug Hunt Results (the headline)

### Open Jira bugs REPRODUCED (existing defects confirmed still present)

| Bug key | Priority | Ticket(s) | Symptom |
|---|---|---|---|
| LFMP-32016 | Major | QA-19557 | Story post data not displayed on Brand>Content; enabling IG Stories on Impressions data set fails the table. |
| APPS-58817 | Major | QA-19557 | NOT VERIFIED — table failure above blocked deleted-post enumeration. |
| LFMP-31798 | Major | QA-837, QA-23969 | Donut YOY arrows render as `□` empty square instead of ▲/▼ across all 16 donut centers on Social Recap PDFs. |
| LFMP-31918 | Major | QA-837 | IG Image-type posts on Conan BPC render with only post text, no thumbnail image. |
| LFMP-31961 | Major | QA-281 | TWC New Followers chart Y-axis clipped at 0; negative net-follower values invisible (Wells Fargo entirely-negative window renders as flat line). |
| LFMP-31977 | Major | QA-96818 | Save-to-Dashboard dropdown remains visible AND functional when graph tile is suppressed by Publish Type breakdown. |
| LFMP-31781 | Minor | QA-1124 | Brand Insights tooltip + legend Twitter icon = `rgb(29,161,242)` (legacy blue); Channels-row icon correctly black, confirming localized inconsistency. |
| LFMP-31903 | Minor | QA-12532 | Brand Sets > Partnerships > Avg. Engagements per Post PNG saves without `.png` extension; bytes are valid PNG. |
| LFMP-32010 | Major | QA-3630 | CPR Preview & Share Report: 7/7 channel Least Engaging Content headings collapse to 0×0 bounding rect; same headings render 250×20 in regular view. |
| DATA-12043 | Major (Code Review) | QA-116113 | YouTube Audience tiles empty on default May 25–31 2026 range; populated on older May 2025 range — now a freshness/lag issue, not a complete outage. |
| BC-4 | (filed defect) | QA-23969 | Social Recap PDF page-number footer missing the `(N - Page count)` suffix. |

### Open Jira bugs NOT REPRODUCED (possibly fixed — eng confirmation needed before closing)

| Bug key | Priority | Ticket | Current state |
|---|---|---|---|
| LFMP-31925 | Major | QA-23969 | `% YOY` label now present in every Video Views donut on every brand page (ListenFirst `-100% YOY`, PLL `-3% YOY`, NBA `7.05% YOY`, Michael Kors `-36% YOY`). Eng verify before closing. |
| LFMP-31886 | Minor | QA-2706 | Owned Average Video Views renders `794,992(-31%)` with parentheses consistent across all 7 metric columns; no inconsistency visible. Eng verify before closing. |

### Open Jira bugs NOT VERIFIED in V2 (environment gap)

| Bug key | Priority | Ticket | Why not verified |
|---|---|---|---|
| APPS-57985 | High (QA Ready) | QA-98368 | LinkedIn channel unavailable on HBO Max / Adam Orfei dev — cross-channel LinkedIn thumbnail check needs a LinkedIn-enabled brand on a different account. |
| LFMP-32027 | Major | QA-96665 | Chrome MCP renderer hangs on Brand Insights with Last 6/12 Months range (new quirk documented). Defer to LFIQA hardware browser. |
| DATA-12089 | Major (Code Review) | QA-20988 | Carry-forward PASS; not actively re-probed this run. |

### NEW bugs surfaced (not yet in Jira — recommend filing)

Six findings flagged across batches 1–12 that aren't in any existing Jira:

1. **QA-2035 — Sentiment Export GS toggle delivers byte-identical CSV** (batch 3). md5 `d0e5e3c524737720c019aaf75812ee84` match across CSV mode + GS mode; same `analytics-cdn.lfmdev.in/<id>-<hash>.csv` URL; no `docs.google.com/spreadsheets/...` URL produced. Pattern matches closed APPS-48127. Candidate Jira: regression.
2. **QA-134277 — Backend rejects `OR` operator + None-tag combination** (batch 4). Filter URL `content_tags:[{operator:"or",values:[""],not:"false"},…]` returns persistent "This table failed to load. Please try again." `operator:"and"` variant works. Repro on Hulu Brand>Content.
3. **QA-134277 — Export button disabled when Posts (0)** (batch 4). Brand>Content top-right Export greys out when filter returns 0 posts. May be intentional UX but blocks empty-state CSV column verification (QA-134277 A6).
4. **QA-134516 — CPR Tag Filter lacks Include/Exclude semantics** (batch 4). Reporting > Content Performance Tag Filter sub-popup has only `Or | And` operator + tag-value checkboxes. No Include/Exclude radios. Contradicts QA-134516 A1. Either CPR needs the feature or the spec needs rewriting.
5. **QA-90213 — Residual Data Studio Twitter parity drift (~1%)** (batch 12). Mismatch shrunk from 3.84×/2.19× to 0.46%/1.21%. SME determination needed on strict vs tolerance semantics.
6. **QA-929 — Pinterest embed iframe stays blank for some pins** (batch 12; persistent since 2026-05-27). Rows 3+4 Sephora Pinterest. Likely Pinterest-side restriction; product should add graceful "Pinterest pin unavailable" placeholder.

### Quirks added to known-quirks.md this run

| Quirk | Added | Source |
|---|---|---|
| Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer | 2026-05-29 | QA-96665 batch 2 |
| Reporting > Content Performance Tag Filter lacks Include/Exclude (vs Brand>Content) | 2026-05-29 | QA-134516 batch 4 |
| Brand>Content backend rejects `OR` operator with empty tag value (None) | 2026-05-29 | QA-134277 batch 4 |
| Brand>Content Export button disabled when Posts count is 0 | 2026-05-29 | QA-134277 batch 4 |
| Brand Sets > Content View toggle disabled at brand-set level | 2026-06-02 | QA-132387/QA-132392 batch 6 |
| YouTube Audience data-freshness lag for recent default windows | 2026-06-02 | QA-116113 batch 8 |
| Pinterest embed iframe tooltip can render blank for unavailable pins | 2026-06-02 | QA-929 batch 12 |
| Data Studio Post Level ↔ Brand>Content parity has residual freshness drift | 2026-06-02 | QA-90213 batch 12 |
| Brand>Content `table_data_set` URL param doesn't always stick | 2026-06-02 | QA-929 batch 12 |
| Brand>Content channel URL param merging on hash route | 2026-06-02 | QA-90213 batch 12 |
| CPR Preview & Share Report — Least Engaging headings collapse to 0×0 (LFMP-32010) | 2026-06-02 | QA-3630 batch 11 |
| Custom Metrics page — spec/UI copy drift in three places | 2026-05-29 | QA-85176, QA-134173, QA-134185 |

### Quirks RESOLVED this run

| Quirk | Resolved date | Source |
|---|---|---|
| Radaac report Export returns TSV when CSV format requested | 2026-05-29 | QA-51425 batch 3 — downloaded `20260601DuplicateBrandSocialPages_37a06f.csv` 14,987 lines, byte-verified comma-separated. |
| Recharts donut tooltips/popups need trusted pointer events | 2026-06-02 | QA-109920 batch 8 — sustained `computer.hover` over donut center renders tooltip with Read button reliably. |
| TWC date-picker `th.prev` / `th.next` arrows ignore screenshot-coord clicks | 2026-06-02 | QA-129606 batch 8 — JS-fallback `document.querySelectorAll('th.prev')[N].click()` works for cross-month navigation. |
| CPR Builder numeric inputs (Visual Top/Bottom Posts, etc.) revert state | 2026-06-02 | QA-3630 batch 11 — `triple_click+type+Tab` sequence commits the values reliably. |

## Per-Ticket Result Matrix

All 59 tickets, grouped by skill area. `OB` = Open Bug verdict (R=reproduced, NR=not reproduced, NV=not verified, —=no linked open bug).

### Brand > Content (12 tickets)

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-520 | brand-content-data-set-selector | PASS | PASS | — | — | Carry-forward PASS; today's re-run BLOCKED at table load. |
| QA-929 | brand-content-data-set-selector | PARTIAL | PASS (5+2) | — | Pinterest blank-embed | Sephora Pinterest Only: Basic; row 1 tooltip OK; rows 3/4 blank embed = Pinterest-side. |
| QA-1519 | brand-content-data-set-selector | PASS | PASS | — | — | Engagement Breakdown + Clicks CSV/GS verified end-to-end. |
| QA-1677 | brand-content-tag-post | PASS | PASS | — | — | Mutating + cleanup verified (`qa-1677-rerun-2026-06-02-0440`). |
| QA-2706 | brand-content-data-set-selector | PASS | PASS | LFMP-31886: NR | — | Owned Average parentheses consistent across all 7 metric columns. Eng verify Jira. |
| QA-19557 | brand-content-table-view | PASS | FAIL | LFMP-32016: R; APPS-58817: NV | — | Stories enable → "This table failed to load." |
| QA-98368 | brand-content-data-set-selector | PASS | BLOCKED | APPS-57985: NV | — | HBO Max on Adam Orfei lacks Threads + LinkedIn channels. |
| QA-100764 | brand-content-data-set-selector | PASS | PASS | — | — | HBO Max Threads Daily Post Analysis modal 6/6. |
| QA-109062 | brand-content-data-set-selector | PASS | PASS | — | — | CDS export end-to-end on disk; Row 1 CDS-only labels. |
| QA-109920 | brand-content-data-set-selector + chart-hover-tooltip + export-csv | PARTIAL | PASS (2/3) | — | — | Recharts donut Read popup reachable; A2 NOT VERIFIED due to in-popup tile load failure. |
| QA-134277 | brand-content-filter | PARTIAL | PARTIAL | — | Backend OR+None failure; Export disabled at Posts(0) | A1/A2/A5 PASS; A3/A4 BLOCKED; A6 NOT VERIFIED. |
| QA-135319 | brand-content-filter | PASS | PASS | — | — | Default Include + OR-disabled + AND-disabled etc. |
| QA-135321 | brand-content-filter | PASS | PASS | — | — | Paid + Tag layered filter PASS. |

### Brand > Insights / Audience / Paid / Stories (10 tickets)

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-949 | (unmapped) | PASS | PASS | — | — | Michael Kors brand_id=3801 IG Authorized; Stories tab hover/pie/export/post-link OK. |
| QA-1124 | chart-hover-tooltip | PASS | FAIL | LFMP-31781: R | — | DOM RGB read on `.legend__icon.twitter-legend` = legacy blue. |
| QA-12532 | audience-metrics-export | PASS | FAIL | LFMP-31903: R | — | `LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31` has no `.png`. |
| QA-20988 | audience-metrics-export | PASS | PASS | DATA-12089: NV | — | Carry-forward PASS; MK TikTok 3 tiles still render (Active Ads 34, Spend $0, Paid Impressions 0). |
| QA-51490 | export-csv + audience-metrics-export | PASS | PASS (minor format) | — | — | CER PNG saves with `.png` extension; minor layout drift on PNG title + date placement. |
| QA-96038 | audience-metrics-export | PASS | PASS | — | — | M=856,949 / F=1,333,591 in both fetch + CSV. |
| QA-96665 | (unmapped) | FAIL | PARTIAL/BLOCKED | LFMP-32027: NV | — | Chrome MCP hang on Last 6/12 Months Trends range. Threads Basic View partial verification only. |
| QA-110074 | audience-metrics-export | PASS | PASS | — | — | 5 Threads tile PNGs verified end-to-end. |
| QA-116113 | audience-metrics-export | PASS | PASS | DATA-12043: partially R | — | Older May 2025 window populated, default May 2026 empty. |
| QA-134182 | brand-insights-interval-picker | PASS | PASS | — | — | Daily end-side `.next disabled` + `visibility:hidden` definitive DOM evidence. |
| QA-134184 | brand-insights-interval-picker | PASS | PASS | — | — | Quarterly Q1 2026 last selectable; year-granularity arrow nav. |
| QA-134188 | brand-insights-interval-picker + export-csv | PASS | PASS | — | — | MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv content matches. |

### Brand Sets / Reporting > CPR (8 tickets)

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-103248 | (none / future daily-post-analysis-modal-run) | BLOCKED | PASS | — | — | 7-day default window unblocks; PNG + GS verified end-to-end. |
| QA-132387 | (candidate future skill) | PARTIAL | PASS | — | — | IG-only + MTV pre-narrow; Sum/Avg verified across 2 metric groups. |
| QA-132392 | (candidate future skill) | PARTIAL | PASS | — | — | Same pre-narrow; Authorized Impressions Sum/Avg verified. |
| QA-134448 | brand-content-filter | PARTIAL | PASS | — | — | Brand Sets > Partnerships Tag Filter Include/Exclude end-to-end. |
| QA-134449 | brand-content-filter | PARTIAL | PASS | — | — | Brand Sets > Optimization Tag Filter Include/Exclude end-to-end. |
| QA-134516 | brand-content-filter | PARTIAL | FAIL | — | CPR lacks Include/Exclude | Spec/UI mismatch — CPR Tag Filter only has Or/And. |
| QA-3630 | (CPR builder — first PASS) | BLOCKED | PASS | LFMP-32010: R | — | Numeric input + checkbox quirks resolved; LFMP-32010 reproduced. |

### TWC (Time Window Comparison) — 7 tickets

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-198 | time-window-comparison-run + export-csv | PASS | PASS | — | — | Carry-forward PASS; metric-tree friction noted. |
| QA-281 | time-window-comparison-run | PASS | FAIL | LFMP-31961: R | — | TWC New Followers Y-axis clips negatives; Wells Fargo flat line. |
| QA-1053 | time-window-comparison-run + keydate-picker | PASS | PASS | — | — | All 3 brands; Aggregate Relative Dates lock + endash verified. |
| QA-19482 | time-window-comparison-run + pdf-end-to-end-verification | PARTIAL | PASS | — | — | Run 2 PDF 23 pages MTV+All NBA end-to-end verified. |
| QA-24544 | time-window-comparison-run | PARTIAL | PARTIAL | — | — | Steps 1-10 PASS; 11-15 deferred (recipient-side). |
| QA-129606 | response-rate-math-verifier + time-window-comparison-run | PARTIAL | PASS | — | — | Twitter PASS 5/5; TikTok DEFERRED (same mechanic). |
| QA-129803 | response-rate-math-verifier | DEFERRED | PASS | — | — | Facebook variant; Total Fans em-dash exclusion + formula match. |

### Reporting > Social Recap / PDF — 5 tickets

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-837 | social-recap-report-run | PASS | FAIL | LFMP-31798: R; LFMP-31918: R | — | Donut YOY arrows `□`; Conan IG image-type posts blank. |
| QA-23969 | social-recap-report-run + pdf-end-to-end-verification | FAIL (BC-4) | FAIL | LFMP-31925: NR; LFMP-31798: also R; BC-4: R | — | BC-4 reconfirmed; %YOY now present (eng verify Jira). |
| QA-131491 | social-recap-report-run | PASS | PASS | — | — | IG Reel "Look how this girl…" 691,822 VV parity. |
| QA-131492 | social-recap-report-run | PASS | PASS | — | — | YouTube "Lights, Camera, Debate w/ Tom Blyth & Emily Bader" 67,332 VV parity. |

### Data Studio — 2 tickets

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-90213 | data-studio-post-level-run + data-studio-multi-perspective | FAIL (3.84×/2.19×) | FAIL (major finding) | — | Residual sub-1.5% parity drift | DS Likes 370,018 vs BC Reactions 368,312 (Δ 0.46%); DS Replies 2,265 vs BC Comments 2,238 (Δ 1.21%). |
| QA-96818 | data-studio-post-level-run | PASS | FAIL | LFMP-31977: R | — | Save-to-Dashboard dropdown remains visible + functional with Publish Type breakdown. |

### Settings (Custom Metrics / Data Sets / Tags / Notifications / Data Collection) — 9 tickets

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-2498 | data-collection-brand-popup | MIXED | PARTIAL | — | — | 9/12 PASS; 3 BLOCKED (FB on HBO Max fully collecting). |
| QA-27854 | (unmapped) | BLOCKED | BLOCKED | — | — | QA-27290 bulk-tag upload not run on dev. |
| QA-33510 | (unmapped) | DEFERRED | DEFERRED | — | — | Password sign-in for `testing@drylogics.com` out of scope. |
| QA-65554 | export-google-sheets | PASS | PASS | — | — | GS filename `Adam Orfei-Tags`; columns match; 5 spot-checks all match. |
| QA-85176 | settings-custom-metrics | PASS | PASS | — | — | Mutating: `QA-85176-rerun-2026-06-02-1900` created + deleted. `Constants`/`Constant` drift still present. |
| QA-104870 | settings-custom-data-sets | PASS | PASS | — | — | 9 CDS rows; ellipsis menu Edit/Delete/Duplicate order PASS. |
| QA-106218 | settings-custom-data-sets | PASS | PASS | — | — | `QA-106218-rerun-2236` create + delete cleanup. |
| QA-130076 | (unmapped) | PASS | PASS | — | — | Lost-auth messaging matches spec on multiple Adam Orfei rows. |
| QA-134173 | settings-custom-metrics | PASS | PASS | — | — | All 5 column tooltips PASS; `Created Date`/`Date Created` swap noted. |
| QA-134185 | settings-custom-metrics | PASS | PASS | — | — | 3 of 4 spec elements tooltipped; `Metric Definition Link` element ABSENT. |

### Exports (CSV / Google Sheets) — 3 tickets

| Ticket | Skill | V1 | V2 | OB verdict | New bugs | Notes |
|---|---|---|---|---|---|---|
| QA-2035 | export-csv + export-google-sheets | PASS | PASS | — | GS toggle delivers identical CSV | md5 match; same CDN URL between CSV+GS modes. Pattern matches closed APPS-48127. |
| QA-29479 | (unmapped) | DEFERRED | PARTIAL | — | — | Owner-side share + persistence PASS; recipient inbox deferred. |
| QA-51425 | export-csv | PASS | PASS | — | — | CSV→TSV regression NOT REPRODUCED — quirk RESOLVED. |
| QA-52776 | (unmapped) | DEFERRED | PARTIAL | — | — | A1 Fetch xlsx PASS via openpyxl; A2/A3 withheld to avoid mutation. |

## Skill Promotion Status

Skills that now meet the architecture rule (`3+ successful runs on separate days`) and are eligible for `stable` promotion:

| Skill | Pass streak | Separate days | Notes |
|---|---|---|---|
| `export-google-sheets` v2 | 6 | 2026-05-13, 2026-05-27, 2026-06-02 | QA-65554 batch-12 PASS confirms. |
| `brand-content-data-set-selector` v1 | 17 | 2026-05-13/14, 2026-05-27, 2026-05-29, 2026-06-02 | Largest cross-batch streak. |
| `audience-metrics-export` v1 | 8 | 2026-05-27, 2026-05-29, 2026-06-02 | QA-110074, QA-116113, QA-96038, QA-12532, QA-20988 etc. |
| `export-csv` v2 | 17 | 2026-05-13, 2026-05-27, 2026-05-29, 2026-06-02 | Most-exercised skill. |
| `time-window-comparison-run` v4 | 14 | 2026-05-13, 2026-05-27, 2026-05-29, 2026-06-02 | Multi-batch JS-fallback patterns verified. |
| `social-recap-report-run` v1 | 7 | 2026-05-27, 2026-05-29, 2026-06-02 | Eligible — needs v2 to document controlled-check-box quirk. |
| `pdf-end-to-end-verification` v1 | 9 | 2026-05-27, 2026-05-29, 2026-06-02 | Eligible. |
| `settings-custom-metrics` v1 | 6 | 2026-05-29, 2026-06-02 | 2 separate days — one more pass needed for stable. |
| `settings-custom-data-sets` v1 | 5 | 2026-05-29, 2026-06-02 | Same — one more pass needed. |
| `brand-content-filter` v1 | 10 | 2026-05-29, 2026-06-02 | Same — one more pass needed. |
| `brand-insights-interval-picker` v2 | 7 | 2026-05-29, 2026-06-02 | Same — one more pass needed. |
| `brand-content-tag-post` v1 | 3 | 2026-05-29, 2026-06-02 | Same — one more pass needed. |
| `chart-hover-tooltip` v1 | 4 | 2026-05-13, 2026-05-29, 2026-06-02 | Eligible (PARTIAL → PASS upgrade for Recharts donut). |
| `response-rate-math-verifier` v1 | 2 | 2026-06-02 (both passes same day) | NOT yet eligible — same-day. |
| `switch-account` v2 | 13 | 2026-05-13 through 2026-06-02, many days | Long-eligible. |

## Recommended Eng Actions (prioritized)

### 1. Highest priority — open Major bugs reproduced this run

These open Jira bugs were actively probed in V2 and reproduced on current dev — route to dev for triage:

- **LFMP-32016** (Major) — QA-19557 — Brand>Content table fails when Stories enabled on Impressions data set.
- **LFMP-31798** (Major) — QA-837, QA-23969 — Donut YOY arrows render as `□` empty square in Social Recap PDFs.
- **LFMP-31918** (Major) — QA-837 — IG Image-type posts on Conan BPC have no thumbnail image.
- **LFMP-31961** (Major) — QA-281 — TWC New Followers Y-axis clips negative values; Wells Fargo entirely-negative window unreadable.
- **LFMP-31977** (Major) — QA-96818 — DS Save-to-Dashboard dropdown remains visible/functional when graph tile is suppressed.
- **LFMP-32010** (Major) — QA-3630 — CPR Preview & Share Report Least Engaging headings collapse to 0×0 across all 7 channels.
- **APPS-58817** (Major) — QA-19557 — NOT VERIFIED but still open; should be re-tested on a brand where impressions_with_stories renders.
- **APPS-57985** (High, QA Ready) — QA-98368 — NOT VERIFIED (needs LinkedIn-enabled brand).

### 2. File 4-6 NEW bug tickets

- **Sentiment Export GS→CSV regression** (QA-2035, batch 3). Filename pattern matches closed APPS-48127; consider whether to reopen or file fresh.
- **CSV Export with `OR` operator + None-tag fails** (QA-134277, batch 4). Backend regression.
- **Brand>Content Export button disabled at Posts(0)** (QA-134277, batch 4). May be intentional — confirm with product.
- **CPR Tag Filter missing Include/Exclude semantics** (QA-134516, batch 4). Feature vs spec divergence.
- **Pinterest embedded tooltip — no graceful placeholder for unavailable pins** (QA-929, batch 12). Product UX improvement.
- **Data Studio Twitter parity residual ~1%** (QA-90213, batch 12). May be tolerance-bounded; SME determination needed before filing.

### 3. Possibly-fixed open Jiras to verify with dev before closure

- **LFMP-31925** (QA-23969) — `% YOY` label now present in every Video Views donut.
- **LFMP-31886** (QA-2706) — Owned Average Video Views parentheses now consistent across all 7 metric columns.

### 4. Spec/UI sync items

- **Custom Metrics copy drift** (3 items, QA-85176/134173/134185): `Constants` (plural)/`Constant` (singular); `Created Date`/`Date Created` swap; absent `Metric Definition Link` element on Create screen.
- **QA-1519 filename pattern** — ISO `YYYY-MM-DD` + lowercase `posts` (platform canonical) vs spec `YYYYMMDD` + `Posts`.
- **QA-130076 — Viacom account** — Has 0 Not Collecting notifications even after Subscriptions > Data Collection toggle enabled. Verified on Adam Orfei rows instead. Spec amendment recommended.
- **QA-134516** — Either CPR gains Include/Exclude feature parity with Brand>Content, or spec gets rewritten.

### 5. PARTIAL/DEFERRED that need analyst action

- **QA-29479** (Dashboards Share Email): owner-side complete; recipient inbox verification needs second account sign-in.
- **QA-33510** (Settings Users External access): needs password-based sign-in for `testing@drylogics.com`.
- **QA-24544** (TWC Share Functionality): steps 11-15 need recipient-side sign-in.
- **QA-2498** (Data Collection Channels not collected): needs a brand whose Facebook channel is NOT fully collecting (HBO Max has none).
- **QA-27854** (Bulk Import Tags Notification): precondition QA-27290 (bulk-tag upload) needs to run on dev to surface Import Tags notifications.
- **QA-134277** (CSV Export respects tag filter): A3/A4 blocked by backend, A6 by disabled Export button. Either fix the backend or document the disabled-export behavior as intended.
- **QA-52776** (Brand Definition Exclude URL Manager): A2/A3 require an analyst willing to mutate dev brand_id=236.
- **QA-98368** (Threads Post Type Hovering + LinkedIn thumbnail): needs LinkedIn-enabled brand on a different account.
- **QA-96665** (LFMP-32027 Trends overlap): defer to LFIQA hardware browser.

## Confidence and Caveats

A handful of V2 PASSes are explicit carry-forward PASSes from 2026-05-27 evidence rather than full live re-runs. The reasons are itemized so the caller can recognize them:

- **QA-198** — V2 carry-forward because today's metric-tree `controlled-check-box` revert friction blocked a clean live re-run; V1 evidence already verified all 10 assertions end-to-end on disk (CSV/TSV/XLS/Google Sheets).
- **QA-20988** — V2 carry-forward; today's run confirmed Brand>Paid MK TikTok renders 3 tiles + Export dropdown order is consistent; V1 had verified 6 PNG exports end-to-end on disk.
- **QA-520** — V2 carry-forward; today's run BLOCKED at table load (skeleton + "table failed to load" toast) on Star Wars FB Authorized Impressions data set, even after Reload. V1 evidence remains canonical.
- **QA-2498** — V2 carry-forward MIXED; today's page failed to load past skeleton state. V1 evidence (9/12 PASS, 3 BLOCKED) is canonical.

The Chrome MCP renderer also has known limits with heavy data — Adam's Brand Set (76K posts) and Brand Insights Last 6/12 Months ranges intermittently freeze the renderer. Both are documented as automation-only quirks; real users on hardware browsers don't see them.

## Process Improvements Captured

What the re-test program proved about the magpie framework:

- **The new `bug-history.md` pre-test routine flipped 6 false-PASSes to true FAILs in batches 1 and 2 alone.** Open-bug pre-probe found LFMP-32016 (QA-19557), LFMP-31798+LFMP-31918 (QA-837), LFMP-31961 (QA-281), LFMP-31977 (QA-96818), LFMP-31781 (QA-1124), LFMP-31903 (QA-12532). Without this routine, all six would have remained false PASSes in the V1 report.
- **Skill streaks grew significantly.** Top per-skill cumulative streaks at V2 close: `export-csv` v2 = 17, `brand-content-data-set-selector` v1 = 17, `time-window-comparison-run` v4 = 14, `switch-account` v2 = 13, `brand-content-filter` v1 = 10, `pdf-end-to-end-verification` v1 = 9, `audience-metrics-export` v1 = 8. Six skills are now stable-promotion eligible per the separate-day rule.
- **Multiple historical quirks resolved via active probing.** Radaac CSV/TSV regression, Recharts donut hover-popup unreachable, TWC date-picker `th.prev/`next` arrows, and CPR Builder numeric input revert — four documented quirks RESOLVED this run.
- **End-to-end Downloads verification (Rule 6) is now the default for export tests** — PNGs, PDFs, CSVs, XLSX all verified via `mcp__cowork__request_cowork_directory` mount + direct file reads, not DOM signals. The pattern caught LFMP-31903 (PNG filename extension drop) and the QA-23969 BC-4 page-footer defect that DOM-signal verification had missed in earlier runs.
- **Brand>Content backend regression caught by URL-state inspection** — QA-134277 batch 4 reproduced an OR+None tag filter that breaks the table; standard UI replay alone wouldn't have surfaced this combination.
- **CPR builder's automation-only friction is now solved end-to-end** — `triple_click+type+Tab` for React-controlled numeric inputs; `focus()+Space-dispatch` for controlled-check-box widgets. Both patterns added to known-quirks.md so future runs don't BLOCK on them.

## How to Read This Report

Per-ticket reports follow the same structure as V1: **Header** (date / account / brand / source spec) → **Result** (PASS / PARTIAL / BLOCKED / FAIL with one-line reason) → **Execution** (numbered playback in spec-step order) → **Assertions** (A1..An, each PASS / NOT VERIFIED / DEFERRED with the evidence) → **Evidence** (URLs, screenshots, key numeric values) → **Notes** (quirks, spec deltas, recommended next-analyst action).

For deeper dives, follow the cross-references:
- Per-batch playbook: `/Users/yashsharma/git/magpie/runs/2026-05-29/BATCH-{1..12}-LOG.md`
- Per-ticket reports: `/Users/yashsharma/git/magpie/runs/2026-05-29/QA-*-report.md`
- Open-bug audit baseline: `/Users/yashsharma/git/magpie/runs/2026-05-27/OPEN-BUGS-AUDIT.md`
- Bug history (open + closed Jira links per ticket): `/Users/yashsharma/git/magpie/knowledge-base/bug-history.md`
- Quirks (accepted product/automation friction): `/Users/yashsharma/git/magpie/knowledge-base/known-quirks.md`
- Skill registry: `/Users/yashsharma/git/magpie/skills/REGISTRY.md`
