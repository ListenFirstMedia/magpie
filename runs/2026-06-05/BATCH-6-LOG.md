# QA-22296 Batch 6/12 — Run Log

**Date:** 2026-06-05 (execution on 2026-06-08)
**Tester:** Yash via magpie
**Browser:** Work Browser (Chrome MCP deviceId `718fbc01-4421-4c06-bce3-daedb57fd1b5`)
**Account:** Adam Orfei (account_id=54)
**Tickets:** QA-96045, QA-96759, QA-98351, QA-99531, QA-104876 (next 5 net-new members by ascending QA-ID)

## Per-ticket results

| QA-ID | Title | Result | Bugs filed | Notes |
|-------|-------|--------|------------|-------|
| QA-96045 | Settings > Data Identities - Instagram Threads | INCONCLUSIVE | None | Threads channel absent from Adam Orfei Data Identities (Channels(6) = FB/Twitter/IG/YouTube/TikTok/LinkedIn). Rule 1 — no substitute. |
| QA-96759 | Brand > Insights - Threads - Tile Level Export - PNG | INCONCLUSIVE | None | Brand>Insights+Threads renderer hang reproduced in all multi-channel combinations. Hang also wedges MCP screenshot pipeline. |
| QA-98351 | Brand > Content - Threads - Basic View | PASS | None | MTV+Threads+Authorized: Threads Only: Insights CDS variant works, 7 Threads-specific columns rendered, empty-state proper. One transient table-failed-to-load recovered via Reload. |
| QA-99531 | Brand > Content - Threads - Hovering functionality | INCONCLUSIVE | None | MTV has 0 Threads posts → no hoverable tiles. APV pivot hit Brand>Insights+Threads renderer hang. |
| QA-104876 | Settings > Custom Data Sets - Delete Functionality | PASS | None | Full mutation cycle on `QA-104876-test-1780915800`: Create→Delete→Cleanup. Confirmation modal copy matches QA-135430 pattern. F5-persistent. |

## Skills exercised

- `brand-content-data-set-selector` — Threads Only: Insights variant confirmed; sort_key `threads.post.engagements_authorized` URL pattern.
- `view-perspective-toggle` — Authorized perspective verified on Threads channel; new fall-back-brand-on-toggle quirk caught.
- `settings-custom-data-sets` — Create + Delete + Cleanup end-to-end on new test CDS.
- `dashboard-mutation-flows` — Generic Settings-entity mutation pattern reused.

## Skill registry bumps

- `settings-custom-data-sets` 5 → 6 (QA-104876)
- `dashboard-mutation-flows` 3 → 4 (QA-104876)
- `brand-content-data-set-selector` 29 → 30 (QA-98351)
- `view-perspective-toggle` 8 → 9 (QA-98351)

## Known-quirks updates

- **Brand>Insights+Threads renderer hang** — escalation note added: now confirmed across `channels=threads` alone, 3-channel (threads+IG+FB), and 2-channel (threads+twitter) mixes. Hang now wedges Chrome MCP screenshot pipeline for >60s.
- **NEW quirk** — `Brand>Content perspective-toggle can auto-fall back to a different brand when Threads channel was selected`. URL `brand_id` silently changes on toggle click; channels param stripped. Observed: MTV 4018 → 10765.

## Bug-history updates

- QA-96045/96759/98351/99531/104876 — "My latest run" sections updated for batch 6.

## Chrome browser state for batch 7

- Work Browser remains selected.
- Active tab: `1804438518` on `app.lfmdev.in/#custom-data-sets` (clean state after Delete + F5 refresh).
- No Sentiment-mode session lock today (only Brand>Content+Threads was visited; never reached Brand>Conversation).
- **Recommendation for batch 7:** close tab `1804438518` and create a fresh tab; avoid `channels=threads` in any URL for Brand>Insights tests until renderer hang resolved. For Threads tests, navigate to Brand>Content (not Insights) with `table_data_set=threads_only%3A_insights`.

## Batch 6 net-new test status

- 2 PASS (QA-98351, QA-104876)
- 3 INCONCLUSIVE (QA-96045 test-data gap, QA-96759 & QA-99531 renderer hang)
- 0 FAIL
- 0 new bugs filed (1 known quirk escalation + 1 new perspective-toggle fallback quirk)

## Cumulative test set progress

After batch 6: 30 of 59 tickets complete (51%). 29 remain across batches 7-12.

Already covered:
- B1: QA-6315, QA-83977, QA-923, QA-19950, QA-947
- B2: QA-199, QA-574, QA-844, QA-926, QA-2042
- B3: QA-18940, QA-22072, QA-23991, QA-24021, QA-27292
- B4: QA-43915, QA-63603, QA-75011, QA-79157, QA-81416
- B5: QA-81647, QA-84195, QA-85176, QA-89390, QA-95190
- B6: QA-96045, QA-96759, QA-98351, QA-99531, QA-104876
