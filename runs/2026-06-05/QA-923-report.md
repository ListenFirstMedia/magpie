# QA-923 — Brand Content - Embedded Post Tooltip (re-run 2026-06-05 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-923
- **Account:** Adam Orfei (account_id=54)
- **Brand attempted:** Amazon Prime Video (brand_id=25864) per spec; URL repeatedly rewrote to brand_id=25894 (a sibling variant). Michael Kors (brand_id=12597) also probed as substitute for tooltip-component testing.
- **Page:** `#explore/brand/content` Twitter-only Table layout, Public perspective, May 2026 window.

## Result: NOT VERIFIED — Brand>Content post table did not render rows on either brand in this session window. LFMP-31857 + LFMP-31915 probes blocked.

## Steps attempted

1. Navigated `#explore/brand/content?brand_id=25864&account_id=54&channels=twitter&layout=table&from=2026-05-01&to=2026-05-31&perspective=standard&table_data_set=public&sentiment_mode=false`.
2. URL rewritten on load to `brand_id=25894&sort_key=lfm.content.responses_mixed`. Page rendered as Sentiment Overview tiles (Classification / Emotion / Topics / Most Vocal headers) with no Posts row (no `Posts (N)` text in body).
3. Retried with date window 2025-05-01 to 2025-05-31. Same Sentiment-tiles rendering.
4. Switched to Michael Kors (brand_id=12597) which is known-good on Adam Orfei. Same Sentiment-mode tiles rendered. URL still set `sort_key=lfm.content.responses` (a Sentiment-mode sort key) even though `sentiment_mode=false` was URL-set.
5. Probed `tbody tr` — 43 rows present but they are date-picker cells (`td.day data-date="1780185600000"`), not post-table rows. The actual post table did not populate.

## Findings

- The Brand>Content page on Adam Orfei (this session) consistently rendered the Sentiment Overview tiles instead of the standard post-table view, regardless of `sentiment_mode=false` URL param. This pattern affected both Amazon Prime Video (variant brand_id=25894) and Michael Kors (brand_id=12597).
- LFMP-31857 (Twitter post text having link) requires the Brand>Content Twitter Table View with at least one Twitter post row visible — not reachable this session.
- LFMP-31915 (Instagram Image Posts Tooltip Is Empty) requires the Brand>Content IG Table View with at least one IG image post row visible — not reachable this session.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Embedded tooltip opens on Type hover | Post table did not populate; no Type cells to hover | NOT VERIFIED |
| A2 | 3 | Only one tooltip visible | Not exercised | NOT VERIFIED |
| A3 | 3 | Click X closes tooltip | Not exercised | NOT VERIFIED |
| A4 | All | Hovering other type links opens additional tooltips | Not exercised | NOT VERIFIED |
| A5 | All | Clicking type opens correct channel post in new tab | Not exercised | NOT VERIFIED |
| A6 | All | Post image, text match tooltip | Not exercised | NOT VERIFIED |
| A7 | TikTok | Embedded tooltip does NOT open for TikTok | Not exercised | NOT VERIFIED |
| **B1** | Twitter | LFMP-31857 — Twitter post text having link | Twitter posts not surfaced | **NOT VERIFIED** |
| **B2** | IG image | LFMP-31915 — IG Image Posts Tooltip empty | IG posts not surfaced | **NOT VERIFIED** |

## Bug reproduction outcomes

- **LFMP-31857 (Major, Open)** — Brand Content - Twitter post text having link: **NOT VERIFIED 2026-06-05.** Brand>Content post table did not populate to expose Twitter posts for hover probing.
- **LFMP-31915 (Major, Open)** — Brand > Content > Instagram Image Posts Tooltip Is Empty: **NOT VERIFIED 2026-06-05.** Same blocker as above.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-923-report.md`

## Notes (known-quirks candidate)
- New finding: Brand>Content page on Adam Orfei (this session window 2026-06-05) renders Sentiment Overview tiles instead of regular post table even when `sentiment_mode=false` is explicitly URL-set. Multiple brand_id values tested (25864→rewritten to 25894, 12597 Michael Kors). Hash router appears to lock into a Sentiment-view state despite the URL param. Likely a per-brand or per-session state caching issue. Recommend retry on a different session or after `sessionStorage.clear()`.
- Per Rule 1: APV spec brand was rewritten to a variant by the hash router; per Rule 6 the post-tooltip checks cannot be claimed REPRODUCED or NOT REPRODUCED without seeing the actual post tooltip render.
- The downstream tickets (QA-19950 FB/Pinterest, QA-947 Brand Video Hulu) may benefit from a clean session — note carry-forward in batch log.
