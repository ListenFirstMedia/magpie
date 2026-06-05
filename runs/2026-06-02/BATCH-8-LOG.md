# QA-4325 Batch 8 — Run Log (2026-06-04)

Members 31-35 of QA-4325.

## Per-ticket result

| # | QA-ID | Title | Result | Notes |
|---|---|---|---|---|
| 31 | QA-103246 | Brand > Content - DPA Modal - Export PNG & GS | **PASS (re-confirm)** | DATA-12209 RE-REPRODUCED. MTV TikTok "Music to Blank to" Fri May 15 2026 — May 16 column endash `–` for all 6 metrics (Engagements 32,510 → – → 71,584; Reactions 32,000 → – → 70,500; etc.). Export PNG/GS carry-over from batch-1 report (already verified end-to-end). |
| 32 | QA-107134 | Settings > Audit - Deep Linking | **PASS** | Audit page deep-link in fresh tab works correctly with `filters=%257B...activity...Brand Edited...%257D` JSON URL encoding — chip + table populated identical to source. **APPS-54603 REPRODUCED** — same-tab URL replace doesn't update filter (also doesn't update date range in this run, broader than documented). |
| 33 | QA-110083 | Settings > Audit - Brand Set Created Audit | **PASS (6/6)** + MUTATION cleanup | Brand Set `qa-110083-rerun-2026-06-04-b8` (id=11583) created with 2 MTV brands. Audit row Thu Jun. 04, 2026 03:24 AM PDT / Yash Sharma / **Brand Set Created** / `Brand Set qa-110083-rerun-2026-06-04-b8 was created.` — all 5 columns populated. Cleanup-delete confirmed (table empty after delete + confirmation modal). |
| 34 | QA-111242 | Brand > Content - Sentiment Read Comments CSV (re-confirm) | **PASS (re-confirm)** | **LFMP-31947 NOT REPRODUCED (re-confirmed)** — MTV IG efya_nocturnal Read Comments modal renders correctly with all 11+ rows visible (Sun 04/06 Gallery/Video × 6 + Tue 04/01 Video × 4). Export → CSV notification popup verbatim references email format with `yash.sharma@listenfirstmedia.com`; toast "Your export has successfully been queued" confirmed. |
| 35 | QA-111243 | Brand > Content - Sentiment Emotion (Daily) CSV Export Email Format | **PASS (3/6)** + **3 NOT VERIFIED** | Same Read Comments path as QA-111242. Email format text verbatim verified. Toast queue confirmation rendered. APPS-55875 (Hulu row-count mismatch) NOT EXERCISED (MTV used not Hulu). |

## Open-bug re-confirmations

| Bug | Verdict | Source ticket | Detail |
|---|---|---|---|
| DATA-12209 (Major, Open) | **REPRODUCED (twice in QA-4325)** | QA-103246 | Endash on May 16 2026 for TikTok DPA — re-confirmed batch-8 |
| APPS-54603 (Minor, Open) | **REPRODUCED** | QA-107134 | Same-tab URL replace doesn't update filter (scope appears broader than original Jira description — date range also not updating) |
| LFMP-31947 (Major, Open) | **NOT REPRODUCED (twice in QA-4325)** | QA-111242 | IG MTV Read Comments works fine — recommend Jira closure |
| APPS-55875 (Minor, Open) | **NOT EXERCISED** | QA-111243 | Hulu-specific row-count mismatch; this run used MTV per shared batch brand context |

## New bugs / findings (filed in this batch's reports)

| Source | Bug / Finding | Severity | Status |
|---|---|---|---|
| QA-107134 | APPS-54603 reproduces with broader scope: date range ALSO doesn't update on same-tab URL replace (original bug said "all except date range"). Suggests engineering may have widened the regression. | Minor | Carry-forward observation — APPS-54603 stays open with widened scope |
| QA-110083 | Audit `Activity Type` enum expanded to include `Brand Set Created` (and presumably Brand Set Deleted/Edited based on pattern). Original `settings-audit-logs` skill v1 only documented User-* variants. | Trivial — skill drift | Skill update queued |

## Chrome state for batch 9

- Active browser tab: 1804438044 — Brand Content MTV with Read Comments modal still open
- Account: Adam Orfei (account_id=54), brand context MTV brand_id=4018
- Dashboards: Yash only (no test mutations remaining; brand set 11583 deleted)
- Downloads dir `~/Downloads` mounted into session
- Recommend fresh tab close + create at start of batch 9 (per protocol)

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-RECONFIRM-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-107134-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-110083-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-111242-RECONFIRM-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-111243-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/BATCH-8-LOG.md`
- Test case specs created: QA-107134.md, QA-110083.md, QA-111243.md (proxy specs)
- Mutations: brand set `qa-110083-rerun-2026-06-04-b8` (id=11583) created + deleted (cleanup verified)
