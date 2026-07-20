# QA-4325 Re-Run Batch 1 Log — 2026-06-02

| Ticket | Result | Open-bug verdict | Notes |
|--------|--------|------------------|-------|
| QA-13903 — Embedded Post Tooltip - LinkedIn | PASS | APPS-57985 NOT REPRODUCED | Switched to UCLA account (account_id=799) for LinkedIn-data brand; 1,415 posts; tooltip + thumbnails render correctly. |
| QA-92841 — DS Save Breakdown to Dashboard PNG+GS | PARTIAL | LFMP-31814 REPRODUCED (no fetching popup); LFMP-31936 NOT VERIFIED | DS Go ran without showing fetching popup; Save-to-Dashboard modal flow truncated. |
| QA-103246 — Daily Post Analysis Modal Export | PASS | DATA-12209 REPRODUCED on MTV TikTok May 16 2026 | All 6 metrics show endash `–` for May 16; PNG saved `MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png`; GS opened with spec filename pattern. |
| QA-111242 — Sentiment Read Comments IG | PASS | LFMP-31947 NOT REPRODUCED | efya_nocturnal IG comments modal displayed 11 Sample Comments; CSV export triggered; bug appears fixed. |
| QA-92735 — Brand Audience LinkedIn Basic View | PASS | APPS-58574 REPRODUCED | First-row Job Function card alone (left=10) while three other col-3 cards on row 2 (left=20/335/650). |

## Chrome state at batch end
- Active tab: 1804437976 on Brand Audience UCLA LinkedIn page (account_id=799, brand_id=127756).
- Account context: UCLA (last selected; needs Adam Orfei switch for batch 2).
- Group: 2004392023.
- No hangs; one mid-batch tab close+recreate due to extension freeze on Disney brand load.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-13903-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92841-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-111242-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92735-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/BATCH-1-LOG.md`
- Test case specs created: QA-13903.md, QA-92841.md, QA-103246.md, QA-111242.md, QA-92735.md (all proxy specs)
- Saved download: `~/Downloads/MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png`

## Summary
- 5 tickets re-executed.
- 3 open bugs REPRODUCED (DATA-12209, LFMP-31814, APPS-58574).
- 2 open bugs NOT REPRODUCED (APPS-57985, LFMP-31947) — likely fixed; recommend verification with eng before closing Jira.
- 1 open bug NOT VERIFIED (LFMP-31936) — couldn't reach the Authorized-perspective surface within the multi-step DS flow.
- No new bugs filed.
