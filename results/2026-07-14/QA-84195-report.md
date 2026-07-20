# QA-84195 — Reporting > Data Studio - Brand > Content -- Data QA - Video Views

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS

## Steps executed

1. Reporting → Data Studio (`https://app.lfmdev.in/#explore/reporting/data_studio`).
2. Clicked **Post Level** toggle; set **Interval = Aggregate** (default was Days); Window Mode left at default **Lifetime**.
3. Add a Brand → typed "MTV" → clicked the exact-match **MTV** row (Rule 1).
4. Select Metrics → searched and checked: **Facebook Public Views**, **Instagram Public Video Views**, **Twitter Public Views**, **TikTok Video Views** (all under Video → Public Video Views).
5. Filters → Content Type → checked **Video** → confirmed pill "Content Type: Video (Include)".
6. Clicked **Go** → built report_id=302796. Default date range (7D preset) resolved to **Jul 06 2026 – Jul 12 2026**, Mode: Lifetime.
7. Opened a new tab → Brand (top nav) → Content.
8. Switched brand via the brand-name dropdown → typed "MTV" → clicked exact-match **MTV** (Rule 1) → brand_id=4018. Confirmed **View: Public Data** toggle was already left-positioned/bold (Public) — Data Set: Public. Confirmed page's own default date range matched DS: **Jul 06, 2026 – Jul 12, 2026**, Mode: Lifetime.
9. Channels → isolated to **Facebook only** (real trusted clicks on `.channel-ghost` icons, each followed by Apply — a JS `.click()` does not register per known quirk; real `browser_click` does). Read Sum row.
10. Channels → isolated to **Instagram only**. Read Sum row.
11. Channels → isolated to **Twitter only**. Read Sum row.
12. Channels → isolated to **TikTok only**. Read Sum row.

Note: after each Apply, the previously-active channel silently re-enabled itself in the URL (known quirk — "Brand > Content channel URL param merging on hash route") and had to be explicitly re-disabled before the next Apply; verified via `.channel-ghost` DOM class state each time, not just the URL.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A9 | Facebook Video Views parity | Brand>Content Facebook "Video Views" Sum == Data Studio "Facebook Public Views" Sum | DS: 133,546 · BC (Facebook only): 133,546 | ✅ PASS |
| A10 | Instagram Video Views parity | Brand>Content Instagram "Video Views" Sum == Data Studio "Instagram Public Video Views" Sum | DS: 3,314,942 · BC (Instagram only): 3,314,942 | ✅ PASS |
| A11 | Twitter Video Views parity | Brand>Content Twitter "Video Views" Sum == Data Studio "Twitter Public Views" Sum | DS: 99,705 · BC (Twitter only): 99,705 | ✅ PASS |
| A12 | TikTok Video Views parity | Brand>Content TikTok "Video Views" Sum == Data Studio "TikTok Video Views" Sum | DS: 342,863 · BC (TikTok only): 342,863 | ✅ PASS |

All four channel values matched exactly (0 delta), on the same brand (MTV), same Public perspective, and the same auto-resolved 7-day window (Jul 06–Jul 12, 2026, Lifetime mode) on both surfaces.

## Finding

No discrepancy. Data Studio's per-channel "Public Views"/"Video Views" metrics (Aggregate interval, Content Type: Video filter) are numerically identical to Brand>Content's per-channel "Video Views" column when isolated to the same single channel, brand, perspective, and date window. Note the platform-wide "Twitter Impressions Outage" banner shown in-app during this run did not affect the Twitter Video Views figure checked here.

## Bugs filed

None.

## Cleanup

Not applicable — read-only comparison, no mutation. DS report_id=302796 is harmless and can be left in place.
