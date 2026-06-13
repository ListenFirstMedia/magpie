# QA-19950 — Brand Content - CSV - All Data set - Impressions (re-run 2026-06-05 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19950
- **Account:** Adam Orfei (account_id=54)
- **Brand attempted:** Spec is University of California, Los Angeles. For the bug-probe (LFMP-31979 FB + Pinterest thumbnails), Michael Kors (brand_id=12597) and APV were also probed since the thumbnail bug is component-level not data-specific.
- **Page:** `#explore/brand/content` Facebook Table layout, Public perspective.

## Result: NOT VERIFIED — Brand>Content post table did not populate in this session window (Sentiment-mode lock); thumbnail probe blocked.

## Steps attempted

1. Navigated `#explore/brand/content?brand_id=12597&account_id=54&channels=facebook&from=2025-01-01&to=2025-12-31&perspective=standard&table_data_set=public&layout=table&sentiment_mode=false&sort_key=lfm.content.engagements&sort_order=desc`.
2. URL hash router rewrote `sort_key` to `lfm.content.responses` (a Sentiment-mode sort key); page rendered Sentiment Overview tiles (Classification / Emotion / Topics / Most Vocal) instead of the regular post table.
3. Cleared sessionStorage + filter localStorage keys; hard-reloaded the URL. Same Sentiment-tiles rendering.
4. No `Posts (N)` text in body; no `td img` or post-thumbnail elements. Cannot probe FB or Pinterest post images for missing/broken thumbnails.

## Findings

- Same session-wide blocker as QA-923 in this batch: Brand>Content surface on Adam Orfei (this session window 2026-06-05) consistently renders Sentiment Overview tiles instead of the standard post table, regardless of brand, channel, perspective, or `sentiment_mode=false` URL param.
- LFMP-31979 requires the standard Brand>Content Table View with at least one Facebook post (and optionally one Pinterest post) row visible, each with a thumbnail column — not reachable this session.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | CSV columns include Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate | Export not attempted — post table not surfaced | NOT VERIFIED |
| A2 | 7 | UI metric data matches Export | Not exercised | NOT VERIFIED |
| **B** | per-post | LFMP-31979 — FB and Pinterest post thumbnails render correctly | Post-table thumbnails not surfaced; image rendering not probable | **NOT VERIFIED** |

## Bug reproduction outcomes

- **LFMP-31979 (Major, Open)** — Thumbnail Issue for Facebook and Pinterest Posts: **NOT VERIFIED 2026-06-05.** Brand>Content surface stuck in Sentiment-mode tile rendering this session window — no post-table images surfaced for inspection.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-19950-report.md`

## Notes
- Carry-forward known-quirks candidate: **"Brand>Content session stuck in Sentiment-mode tile rendering"** (2026-06-05 batch-1 across QA-923 + QA-19950). Suggests the hash-router merges in cached Sentiment-mode state from a recent QA-6315 / Conversation page visit, locking subsequent Brand>Content visits into Sentiment Overview output. Likely needs full Chrome MCP tab close + new tab to reset, OR full app.lfmdev.in browser-session reset.
