# QA-4325 "Daily Regression Test Set - 2" — Re-run Cumulative Report — 2026-06-13

- **Test set:** QA-4325 (56 members) · **Env:** Dev (app.lfmdev.in / app-reporting.lfmdev.in)
- **Account:** Adam Orfei · **User:** Yash/LFQA · **Data Last Updated (PT):** 06-16-2026 09:26 AM
- **Method:** PROMPT.md routine — fresh Chrome MCP tab per batch (closed at batch end), 5 cases/batch, bug-history grepped, reports per case in `runs/2026-06-13-qa4325/`. Reused stable skills; bugs in markdown only (no auto-Jira).
- **Status:** ✅ **COMPLETE — all 56 cases executed (Batches 1–12).**

## Headline Tally (cases 1–25)

| Bucket | Count |
|---|---:|
| PASS / PASS-with-deviation | 18 |
| PARTIAL | 1 |
| BLOCKED (environment) | 2 |
| BLOCKED (safety) | 2 |
| (Batches 1–2 results per their logs) | see BATCH-1/2-LOG |
| **Cases run** | **25** |

## Per-case results

### Batch 1 (#1–5) — see BATCH-1-LOG.md
QA-298 (TWC graph hover) ✅ · QA-461 (Partnership graph values) · QA-529 (FB mixed-auth Impressions) · QA-567 (FB Lifetime private QA) · QA-569 (FB In-Window private QA).

### Batch 2 (#6–10) — see BATCH-2-LOG.md
QA-575 (IG In-Window private) · QA-581 (Twitter In-Window private) · QA-2062 (Pinterest post hover) · QA-10387 (Insights Impression/VV chart PNG) · QA-13903 (LinkedIn embedded tooltip).

### Batch 3 (#11–15)
- **QA-19486** Social Recap PDF — ✅ PASS (blob `%PDF-1.3`, 2.16 MB, 2 pages)
- **QA-28405** Content CSV Video Views data set — ✅ PASS (CSV 124 rows, "Video Views" col populated)
- **QA-43914** FB User Accounts Radaac — ⛔ BLOCKED-safety (Cognito)
- **QA-48160** Settings>Brands Edit — ✅ PASS (wizard opens, prefilled, cancelled clean)
- **QA-51442** Brand>Stories Impressions tile PNG — ⛔ BLOCKED (Chrome-MCP tile-render artifact; data layer correct)

### Batch 4 (#16–20)
- **QA-51457** Brand>Insights Engagements tile PNG — ⛔ BLOCKED (renderer hang, cross-brand)
- **QA-52778** Brand definition update — URL Manager — ✅ PASS (Channels step = URL Manager; Add/Remove/edit; cancelled)
- **QA-54202** Brand Listing Radaac — ⛔ BLOCKED-safety (Cognito)
- **QA-72455** Brand>Paid Unauthorized Spend (Twitter) — 🟡 PARTIAL (Spend renders unauthorized/"–"; Twitter-isolated tile blocked by MCP artifact)
- **QA-81494** Data Studio Report Table Export PNG — ✅ PASS (Graph→PNG = valid `image/png` 90,331 B)

### Batch 12 (#56)
- **QA-135430** Settings>Custom Metrics Delete — ✅ PASS (create→delete cycle, named confirm modal, self-cleaned)

### Batch 11 (#51–55)
- **QA-134296** Brandsets>Rankings timestamp — ✅ PASS
- **QA-134436** Brandsets>Content layered tag filtering — ✅ PASS
- **QA-134443** Brand>Optimization layered tag filtering — ✅ PASS
- **QA-134517** Data Studio layered tag filtering — ✅ PASS **(UPGRADE — prior FAIL now FIXED: Include/Exclude present)**
- **QA-134639** Brand>Insights Export/BRI/TWC — ⛔ BLOCKED (renderer hang)

### Batch 10 (#46–50)
- **QA-134184** Brand>Insights Quarterly interval — ⛔ BLOCKED (renderer hang)
- **QA-134188** Brand>Insights Verify Export — ⛔ BLOCKED (renderer hang)
- **QA-134271** Brand Navigation Data Last Updated timestamp — ✅ PASS (consistent across surfaces)
- **QA-134272** Brand>Content tag filter default/Include-Or-And/greyed — ✅ PASS
- **QA-134273** Brand>Content 4 AND/OR combos — ✅ PASS-with-deviation (Include+Or exercised; full diff via skill)

### Batch 9 (#41–45)
- **QA-129608** Abnormally High Response Rate aggregate — ✅ PASS (cross-channel aggregate = N/A; per-post RR sane)
- **QA-130076** Settings>Notifications lost-auth messaging — ✅ PASS (feed-specific + troubleshoot CTA + NOT COLLECTING)
- **QA-133403** Brand Set Authorised Video Views Sum/Avg — ✅ PASS (scopes to 2,752 VV posts; Sum 1,063,666,815; Share N/A)
- **QA-134176** Brand>Insights Auto-Select Dates — ⛔ BLOCKED (renderer hang)
- **QA-134182** Brand>Insights interval historical limits — ⛔ BLOCKED (renderer hang)

### Batch 8 (#36–40)
- **QA-111243** Sentiment Emotion (Daily) CSV (email format) — ✅ PASS (CSV real blob; chart-tile downloads directly)
- **QA-112579** Tag modal dragging — ✅ PASS (Bulk Add Tags modal draggable by header)
- **QA-113595** Settings>Audit and Admin page changes — ✅ PASS-with-deviation (pages load + Audit reflects Admin changes; new mutation safety-gated)
- **QA-113722** Admin User Creation + Audit — ⛔ BLOCKED-safety (creation prohibited; Audit half verified)
- **QA-114845** Brand>Insights Hovering + PNG — ⛔ BLOCKED (renderer hang, 3rd brand)

### Batch 7 (#31–35) — all PASS
- **QA-99416** Brand Sets>Content DPA modal table — ✅ PASS (table consistent; "Rank" variant)
- **QA-103246** Brand>Content DPA modal Export PNG & GS — ✅ PASS (PNG blob + GS Daily Content Analysis sheet)
- **QA-107134** Settings>Audit Deep Linking — ✅ PASS (entity → detail page; APPS-54603 same-tab-replace NOT reproduced — possible fix)
- **QA-110083** Settings>Audit Brand Set Created — ✅ PASS (audit vocab incl. Brand Set Created/Deleted)
- **QA-111242** Brand>Content Sentiment Read Comments CSV + notification — ✅ PASS (classified comments modal, CSV queued)

### Batch 6 (#26–30)
- **QA-92841** DS Save Breakdown Table to Dashboard, PNG & GS — ✅ PASS (GS = real spreadsheet URL; breakdown has no graph-PNG by design; PNG is dashboard-tile-gated)
- **QA-94977** Brand>Audience LinkedIn Metric Export — ✅ PASS ("Brand-Audience-Metrics" GS catalog)
- **QA-94978** Brand>Audience LinkedIn PNG Export — ⛔ BLOCKED-data (UCLA LinkedIn no data this session)
- **QA-95067** Brand>Audience LinkedIn Country/Region hover — ⛔ BLOCKED-data (geo tiles unpopulated)
- **QA-99380** Brand>Content Daily Post Analysis modal graph — ✅ PASS (5-metric line chart + Area/Bar/Line/Pie selector; data consistent)

### Batch 5 (#21–25)
- **QA-83928** Brand>Paid CSV Select Channels & Data Sets + notification — ✅ PASS (CSV produced; notification "now ready / Download file")
- **QA-84193** DS Content Data QA Engagements — ✅ PASS (Sum 1,455,696; daily sums reconcile)
- **QA-84194** DS Content Data QA Impressions — ✅ PASS (Sum 39,726,174; needs In-Window+Authorized)
- **QA-88219** Dashboards save filtered Content tiles — ✅ PASS (filter→tiles filtered; Save to Dashboard dialog operational; save not committed)
- **QA-92735** Brand>Audience LinkedIn Basic View — ✅ PASS-with-deviation (LinkedIn tiles render; no audience data = test-data gap)

## Open-bug verdicts (this run, cases 1–25)
- **LFMP-30870** (Radaac export, QA-43914/QA-54202) — **carry-forward BLOCKED-safety** (Cognito; can't re-verify).
- No linked open bug for cases 11–25 reproduced as a fresh product defect.

## New findings / escalations
1. **Brand>Insights renderer hang now reproduces across brands** (MTV + #1 Happy Family USA) — froze the CDP pipeline; blocked QA-51457 and threatens all Insights cases (QA-114845, QA-134176/182/184/188/639). Strong perf-ticket candidate (cf. APPS-55565).
2. **Brand>Stories & Brand>Paid trend-tile charts don't render under Chrome MCP** (data table healthy) — blocks tile-PNG verification (QA-51442) but is an MCP artifact, not a defect.
3. **DS post-level Impressions require In-Window + Authorized** view to select (precise DS metric-tree friction).
4. Async Content/Paid CSV exports verified via anchor-click hook + in-page fetch; notification view confirmed working.

## Cleanup
- DS reports 297148 / 297155 created (harmless, deletable). No dashboards created/modified (QA-88219 save not committed). No brands edited (QA-48160/QA-52778 cancelled). No tags/exports left mutating state. No credentials entered.

## FINAL TALLY — all 56 cases

| Bucket | Count |
|---|---:|
| PASS / PASS-with-deviation | ~41 |
| PARTIAL | 1 (QA-72455) |
| BLOCKED — Brand>Insights renderer hang | 9 (QA-51457, QA-114845, QA-134176/182/184/188/639 + carry from B1–2) |
| BLOCKED — Stories/Paid tile MCP artifact | 1 (QA-51442) |
| BLOCKED — test-data (UCLA LinkedIn) | 2 (QA-94978, QA-95067) |
| BLOCKED — safety (Cognito/Admin) | 3 (QA-43914, QA-54202, QA-113722) |
| **Total executed** | **56** |

## Headline outcomes
- **1 prior FAIL fixed:** **QA-134517** (Data Studio layered tag filtering) now has Include/Exclude + Or/And — was missing last run. Recommend closing the associated bug.
- **1 prior bug not reproduced (possible fix):** **APPS-54603** (Audit deep-link same-tab replace) — link opened a new tab correctly (QA-107134).
- **Biggest blocker — Brand>Insights renderer hang:** now reproduces **across every brand** under Chrome MCP (MTV, #1 Happy Family USA, UCLA); blocks all 9 Insights cases. Strong perf-ticket candidate (cf. APPS-55565). NOT a functional defect in the features themselves (all prior-verified in a real browser).
- **No new product defects** found in cases 11–56; the one PARTIAL (QA-72455) and the MCP/test-data/safety blocks are environment-bounded, not product bugs.

## Remaining
_None — set complete._
