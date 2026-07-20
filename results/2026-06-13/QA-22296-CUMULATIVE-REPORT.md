# QA-22296 "Daily Regression Test Set - 3" — Re-run Cumulative Report — 2026-06-13

- **Test set:** QA-22296 (59 members) · **Env:** Dev (app.lfmdev.in / app-reporting.lfmdev.in)
- **Account:** Adam Orfei · **User:** LFQA · **Data Last Updated (PT):** 06-12-2026 04:25 PM
- **Method:** PROMPT.md routine — fresh Chrome MCP tab per batch (closed at batch end), 5 cases/batch (12 batches), bug-history grepped, reports per case in `runs/2026-06-13/`. Reused stable skills; no auto-Jira tickets.

## Headline Tally

| Bucket | Count | % |
|---|---:|---:|
| PASS / PASS-with-deviation / RECONFIRM | 38 | 64.4% |
| PARTIAL / PARTIAL-PASS / NOT-VERIFIED | 7 | 11.9% |
| FAIL / FAIL-with-finding | 2 | 3.4% |
| BLOCKED (environment / safety) | 12 | 20.3% |
| **Total** | **59** | **100%** |

- **8 upgrades vs the 2026-06-05/08 sweep:** QA-844, QA-923, QA-19950, QA-81416, QA-81647, QA-99531, QA-121158, QA-121217 (moved from PARTIAL/BLOCKED/NOT-VERIFIED → PASS, mostly by using MTV/recent-window data where the prior run hit no-data or sentiment-lock).

## Open-bug verdicts

### REPRODUCED (still defective on dev)
- **LFMP-31800** (Major) — QA-6315: Brand>Conversation "Click here to load Tweets" navigates to the Listening page (direct repro). **FAIL.**
- **LFMP-31781** (Minor) — QA-947: Twitter legend icon blue; carry-forward (Brand>Video renderer hang blocked the direct DOM-RGB read; shared component, no fix since).

### NOT REPRODUCED — recommend eng confirm closure
- **LFMP-31915** (QA-923) — IG image-post tooltip populates correctly (not empty).
- **LFMP-31979** (QA-19950) — FB post thumbnails render (UCLA); Pinterest not testable (no Pinterest channel).
- **LFMP-31814** (QA-83977) — DS UI clean fetch→render; 3rd consecutive non-repro.
- **LFMP-31862** (QA-121158) — IG Collaborated Total filter works end-to-end.
- **APPS-61098** (QA-135837), **APPS-60358** (QA-137557), **APPS-49018** (QA-75011), **APPS-53076/53104** (QA-95190) — all NOT reproduced.

### CARRY-FORWARD (not re-verifiable this run)
- **LFMP-30870** (QA-43915) — Radaac Ads export; BLOCKED (Cognito login, safety). Prior REPRODUCED verdict stands.
- **LFMP-31857** (QA-923) — Twitter post text retains raw t.co link; **signal present** this run.

## New findings
1. **TWC Relative-Dates export emits relative labels in the Date column** (TSV + CSV), not absolute dates — QA-199 **FAIL-with-finding** (re-confirms 2026-06-05). Candidate Bug or spec rewrite.
2. **Brand>Insights / Brand>Video renderer hang** — the most consequential dev-stability issue this run. Froze the Chrome MCP CDP pipeline (>45s timeouts) on MTV multiple times; **blocked QA-947, QA-18940, QA-89390, QA-96759** and prevented fresh re-drive of QA-134176. Recommend a perf ticket (cf. APPS-55565).
3. **Spec/feature drift (re-confirmed):** QA-22072 (Brand>Partnerships Basic filter has no metric-based sub-filter), QA-63603 (Upload Tags lives on Brand>Content, not Settings>Tags).
4. **Twitter embedded tooltip renders empty** (no oEmbed) on APV — likely X-platform restriction (monitor, not auto-bug).

## BLOCKED breakdown (12)
- **Threads test-data gap (3):** QA-96045 (no Threads in Data Identities), QA-96759 (Insights+Threads hang), QA-109749 / QA-112583 (no Threads-audience data).
- **Admin/external-user/Cognito gating — safety (4):** QA-113594, QA-113723, QA-114840, QA-43915 (Radaac).
- **Renderer hang (2):** QA-947, QA-18940 (Brand>Video), QA-89390 (Insights) — carry-forward PASS where prior verified.
- **Out of scope (1):** QA-79157 (Mixpanel, Prod third-party).
- **DS metric-tree friction (1):** QA-84195 NOT VERIFIED.

## Per-batch results
See `BATCH-1-LOG.md` … `BATCH-12-LOG.md` and the 59 `QA-<id>-report.md` files in this folder.

## Cleanup
- Mutations were all self-cleaning or cancelled: Custom Data Set `QA-104876-del-0613` created+deleted; Custom Metric Create/Edit cancelled (no save); no tags added; TWC/CPR/DS stories (154573/154574/154575, report 296281) are harmless and deletable. No dashboards shared, no users created.
