# QA-4325 Re-Run Batch 2 Log — 2026-06-04

| Ticket | Result | Notes |
|--------|--------|-------|
| QA-298 — Reporting TWC Graphs Hovering Functionality | PASS | Hulu, Default range May 27 - Jun 2, FB New Fans + Twitter New Followers. Tooltip format `Mon. DD, YYYY` / `Brand: value` confirmed for both FB and Twitter charts via JS-dispatch + native hover. story_id=154045. |
| QA-461 — Data QA Partnership Graph Values | PASS | Adam's Brand Set, Jan 3-4 2025, Public Data. Sponsored Posts big number 9 = stack sum 9 (6+3). Per-channel parity: FB Engagements 2,650, Twitter 555, Instagram 342K — all match single-channel big number = hover-tooltip sum. "Branded Content: Yes" filter doesn't exist on Partnerships tab; the tab is implicitly branded data only. |
| QA-529 — Facebook Content Mixed Authorization Impressions | PASS | SS22 NYFW Roll-Up brand (Michael Kors account), FB only Authorized, Oct 18 2024, Brand filter Tory Burch OR Michael Kors. Posts (3): MK Image + MK Video Reel = full numerics; Tory Burch Reel = endash + locks. CSV (`293898-956af330ec149d5eb04c80b2b20ad012.csv`) fetched end-to-end via CDN: Brand column = only Michael Kors + Tory Burch; Tory Burch row has empty `""` cells for Impressions/Organic/Paid/Reach/EUR; Reel-publish type included. All 8 assertions PASS. |
| QA-567 — Facebook Lifetime Private Data QA | PARTIAL | Dev-side: Lifetime + FB + Impressions data set loads correctly (89 posts, Sum 35.3M Impressions). Stage comparison not evaluable from this session (requires separate stage env). Flagged as manual cross-env test. |
| QA-569 — Facebook In Window Private Data QA | PARTIAL | Dev-side: In Window mode toggle works (via Date Range modal's Select Mode radio); URL `stats_attribution_window=in_window` applies; Posts (30) returned with Sum 7.82M Impressions (≠ Lifetime 35.3M, confirming windowing). Posts table tile rendered transient "failed to load" but aggregates rendered correctly. Stage comparison not evaluable. |

## Chrome state at batch end
- Active tab: 1804437980 on Hulu Brand>Content FB In Window Impressions (account_id=336, brand_id=5670).
- Account context: Hulu (last selected; batch 3 may need switch).
- Group: 1103135966.
- No hangs; clean session throughout.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-298-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-461-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-529-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-567-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-569-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/BATCH-2-LOG.md`
- Test case specs created: QA-298.md, QA-461.md, QA-529.md, QA-567.md, QA-569.md.

## Summary
- 3 PASS, 2 PARTIAL (dev↔stage cross-env tests — stage not accessible from magpie).
- No new bugs filed.
- No previously-open bugs to verify (all 5 tickets had 0 open bugs going in).
