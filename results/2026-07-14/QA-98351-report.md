# QA-98351 — Brand > Content - Threads - Basic View

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Brand:** MTV (brand_id=4018)
**Status:** ✅ PASS

## Steps executed

1. Navigated to Brand > Content (`#explore/brand/content?brand_id=4018`).
2. Applied a Threads-only channel filter via the channel-icon toggles (disabled Facebook/Twitter/Instagram/TikTok/LinkedIn, left only Threads enabled — confirmed via `.channel-ghost` class check — then clicked Apply). Direct `channels=threads` URL param alone expanded to all default channels, consistent with the documented URL-expansion quirk; the icon-toggle + Apply approach was required to get a true Threads-only filter.
3. On the default 7-day window (Jul 07–13, 2026) with the generic "Public" data set, Posts showed **(0)** — reproduces the documented "generic data set returns Posts (0) for niche channels" quirk.
4. Switched the **Data Set** selector from "Public" to **"Threads Only: Insights"** (channel-specific data set).
5. Still 0 posts in the narrow default week — widened the date range to the full 2025 calendar year to distinguish "no data in this window" from "feature broken."
6. Confirmed page renders and populates cleanly with real data.

## Assertions

| Assertion | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Page renders without crash | No error boundary / blank page | Renders cleanly at every step (0-post and 132-post states alike); brief skeleton-loader state on the full-year query resolved to real content within ~15s (heavy year-long dataset, not a hang) | ✅ PASS |
| Insights tiles render for Threads | Threads-specific tiles/metrics appear | Brand>Content's tile equivalent — the Sum/Average summary row — populated with real Threads metrics: Engagements (Sum 78,664 / Avg 596), Likes (74,421 / 564), Replies (510 / 4), Quotes (241 / 2), Reposts (3,009 / 23), Shares (483 / ...). No SVG/canvas chart tiles exist on this page (confirmed via DOM query, 0 svg/canvas elements) — Brand>Content uses a table-based summary row rather than chart tiles, unlike Insights/Video pages | ✅ PASS |
| Posts table is populated | Post rows appear for Threads | **Posts (132)** — real MTV Threads posts rendered with dates, thumbnails, and per-post engagement stats, once switched to the channel-specific data set over a full-year window | ✅ PASS |
| Data-set selector is operative | Selector changes the active data set and affects results | Successfully switched Public → "Threads Only: Insights"; URL `table_data_set` param updated (`public` → `threads_only%3A_insights`) and column set changed to Threads-specific fields (Likes/Replies/Quotes/Reposts vs. generic Reactions/Comments) | ✅ PASS |

## Finding

No product defect. Brand>Content Threads Basic View works correctly end-to-end once the channel-specific data set is selected — confirms the existing `known-quirks.md` guidance (generic "Public" data set undercounts niche-channel posts; the channel-specific data set unlocks the full corpus) applies to Threads on Brand>Content just as documented for Pinterest.

**Data-availability note (not a defect):** MTV had **zero** Threads posts in the test's implied default window (the current 7-day range, Jul 07–13, 2026) — Posts (0) is factually correct for that narrow window, not a bug. The full 2025 calendar year showed 132 real posts, confirming the channel/brand/data-set combination genuinely has content; automation for this ticket should use a wider historical window (or a known-active week) rather than the current default week, since MTV's Threads posting cadence doesn't guarantee posts in any arbitrary current 7-day window.

## Bugs filed

None.

## Cleanup

Not applicable — read-only navigation and filter changes, no mutation.
