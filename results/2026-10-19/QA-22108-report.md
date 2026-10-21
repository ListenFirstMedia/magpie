# QA-22108 — Brand Content > LFM vs Native > LinkedIn Channel - Past Date

**Run date:** 2026-10-19 · **Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no LinkedIn login)
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756, the account's default brand — exact spec name) · Date range Jan. 01, 2024 – Dec. 31, 2024 · Channel: LinkedIn only · Perspective: Authorized (default)
**Verdict: PASS (1/1, with a flagged ~10% drift) — native LinkedIn post readable logged-out; LFM Reactions 8,992 / Comments 213 vs native 9,918 reactions / 228 comments**

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Switch account HBO Max → UCLA (LFQA menu → Search Account → Results "UCLA") | ✅ account_id=799 |
| 1 | Hover Brand → Content | ✅ default brand "University of California, Los Angeles" |
| 2 | Date range Jan 01 2024 – Dec 31 2024 (START DATE / END DATE paired calendar → Ok) | ✅ `from=2024-01-01&to=2024-12-31` |
| 3 | LinkedIn channel only → Apply | ✅ `channels=linkedin`, **Posts (795)** (loaded first time, no Reload needed) |
| 4 | First post: Reactions, Comments | ✅ **Reactions 8,992 · Comments 213** (Shares 959, Engagements 10,164; Sep 23 2024 "UCLA has been ranked the nation's #1 public university…", urn:li:share:7244170903343796225) |
| 5 | Click the image on the first post | ✅ new tab → `https://www.linkedin.com/feed/update/urn:li:share:7244170903343796225/` |
| 6 | Read Likes, Comments on the native post | ✅ public post page rendered logged-out (header shows Sign in / Join now but no authwall redirect): **9,918** reactions, **228 Comments** (title "#1ucla \| UCLA \| 228 comments") |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 6) | LFM Reactions/Comments should not have big variation vs native | Reactions 8,992 vs 9,918 (native +926, **+10.3%**); Comments 213 vs 228 (+15, +7.0%). Native is HIGHER, consistent with the post continuing to accrue after LFM's stats-collection window for a 2-year-old post | ✅ PASS — **threshold not defined in spec; 10% flagged for a human call** |

## Evidence
- `.playwright-out/QA-22108/01-linkedin-posts-loaded.png` — LinkedIn-only 2024 grid, Posts (795)
- `.playwright-out/QA-22108/02-native-linkedin.png` — native post page with 9,918 reactions / 228 comments

## Known bugs checked
- LFMP-32113 (Open) "native data is lower than LFM" — does not reproduce here (native is higher).
- Automation note: LinkedIn served the public post page to the headless browser this run; LinkedIn is known to redirect automated/unauthenticated traffic to `/authwall` intermittently — treat as fragile for unattended runs.

## Bugs filed
None.

## Cleanup
None (read-only).
