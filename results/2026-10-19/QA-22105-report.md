# QA-22105 — Brand Content > LFM vs Native > Twitter Channel - Past Date

**Run date:** 2026-10-19 (Monday → rotation row: account **HBO Max**, brand **HBO Max**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`)
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614) · Date range Jan. 01, 2024 – Dec. 31, 2024 · Channel: Twitter only · Perspective: Authorized (default)
**Verdict: BLOCKED — step 5/6: native X/Twitter post returns HTTP 403 to the automated browser (bot wall), so native values cannot be read**

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login as lfiqa, switch account Adam Orfei → HBO Max via LFQA menu → Search Account → Results | ✅ (Home hung on "Loading…" ~90 s first — dev API slow, recovered by itself; account search Results only appeared after re-typing a character) |
| 1 | Hover Brand → Content | ✅ landed on Brand>Content, default brand HBO Max |
| 2 | Brand HBO Max; date range Jan 01 2024 – Dec 31 2024 via START DATE / END DATE paired calendar → Ok | ✅ URL `from=2024-01-01&to=2024-12-31` |
| 3 | Twitter channel only (disabled FB/IG/TikTok/LinkedIn/Threads) → Apply | ✅ `channels=twitter`; first load showed "This table failed to load" → **Reload** → Posts (709) |
| 4 | First post (sorted by Engagements): Reactions / Shares / Comments | ✅ **Reactions 35,825 · Comments 761 · Shares 15,253** (Engagements 51,840; post Aug 04 2024 "I saved her. A sneak peek of Season 2 of #TheLastOfUs…", status 1820256602642960572) |
| 5 | Click the image on the first post (`.image-card .image-link`) | ✅ new tab opened to x.com |
| 6 | Read Likes / Retweets / Quote Tweets from native post | 🚫 **x.com → HTTP 403 "Access to x.com was denied"**. Retried direct `x.com/streamonmax/status/…` and `twitter.com/89090040/status/…` → `ERR_HTTP_RESPONSE_CODE_FAILURE` (403) both times |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 6) | LFM values not far from native Likes/Retweets/Quote Tweets | Native page unreadable (403 bot wall) | 🚫 BLOCKED |

## Evidence
- `.playwright-out/QA-22105/05-twitter-posts-loaded.png` — Twitter-only 2024 grid, Posts (709)
- `.playwright-out/QA-22105/06-native-x-403.png` — x.com 403 page in the new tab
- `.playwright-out/QA-22105/04-twitter-only-loading.png` — the "table failed to load / Reload" tile before recovery

## Known bugs checked
- LFMP-32113 (Open) "native data is lower than LFM" — not evaluable (native not readable).
- Not a product defect: X serves 403 to unauthenticated automated browsers; a logged-in X session (or a different fetch path, e.g. X syndication/oEmbed) would be needed.

## Bugs filed
None.

## Cleanup
None (read-only).

## Retry — 2026-10-20 (second session)
Direct navigation to `https://x.com/streamonmax/status/1820256602642960572` in a fresh tab → `net::ERR_HTTP_RESPONSE_CODE_FAILURE` (HTTP 403) again. Evidence: `.playwright-out/QA-22105/07-native-x-retry.png`. Verdict unchanged: **BLOCKED** — X serves 403 to the unauthenticated automated browser; needs a logged-in X session or a non-browser data path.
