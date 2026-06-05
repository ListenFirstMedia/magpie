# QA-96665 — Brand Insights - Threads - Basic View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96665
- **Run date:** 2026-05-27
- **Account:** HBO Max (account_id=657)
- **Brand:** HBO Max / Max (brand_id=155614 for Authorized "extended" perspective; brand_id=155611 for Public "standard" perspective — distinct entities)
- **Channel:** Threads only
- **Date Range:** May 26 2025 – May 25 2026 (expanded from default 7D to 12M because Threads in dev has very sparse activity in 7D — needed enough posts to verify BPC)
- **Priority:** Blocker (P1)
- **Result:** ⚠ **8/9 PASS / 1 FAIL — A1: Threads is positioned next to LinkedIn but with NO visible separator between them. DOM has only ONE `chan-separator` (between TikTok and YouTube); LinkedIn and Threads are adjacent siblings with no separator element in between. This is a UI bug against the Blocker-priority spec.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Already on HBO Max account (from QA-98368 run) | ✓ |
| 1 | Hover Brand → click Insights | ✓ — URL `/#explore/brand/insights` |
| 2 | Top-nav search → typed `HBO Max` → picked exact-match `HBO Max` from live Results (Rule 1) | ✓ — brand_id=155614 |
| 3 | Confirmed Threads-only channel via URL `channels=threads` | ✓ — channel strip shows Threads icon active, others dim |
| 4 | Clicked View toggle to switch from Authorized Data → Public Data | ✓ — URL `perspective` flipped from `extended` to `standard`, brand_id auto-switched from 155614 → 155611 (Public entity) |

## Channel strip composition (Authorized perspective, step 3)
Order observed: `FB | X | IG | TikTok` **`[chan-separator]`** `YT | LinkedIn | Threads | Pinterest | Wikipedia | RT | IMDb | Spotify` + Apply

DOM tree confirmed via JS (`*` indicates icon, `||` indicates `chan-separator` element):
```
chan-icon-wrapper >
  channel-ghost > * channel-icon (FB)
  channel-ghost > * channel-icon (X)
  channel-ghost > * channel-icon (IG)
  channel-ghost > * channel-icon (TikTok)
  || chan-separator ||
  channel-ghost > * channel-icon (YT)
  channel-ghost > * channel-icon (LinkedIn)
  channel-ghost > * channel-icon (Threads)
  channel-ghost > * channel-icon (Pinterest)
  channel-ghost > * channel-icon (Wikipedia)
  channel-ghost > * channel-icon (RT)
  channel-ghost > * channel-icon (IMDb)
  channel-ghost > * channel-icon (Spotify)
```

LinkedIn and Threads are adjacent. **No `chan-separator` exists between them**, even though the Blocker-priority spec assertion A1 explicitly says they should be separated.

## Channel strip composition (Public perspective, step 4)
`FB | X | IG | TikTok` **`[chan-separator]`** `YT | Pinterest | Wikipedia | RT | IMDb | Spotify` + Apply

LinkedIn AND Threads both absent → confirms Threads not available in Public perspective (A9 PASS).

## Tiles observed (Authorized perspective)

**Row 1 — Big Number Tiles:**
- Total Followers: 1.05M (+10%) ✓
- Follower Growth: 75.8K (+>999%) ✓
- Fan Growth Rate: 7.79% (+>999%) ✓

**Row 2 — Big Number Tiles:**
- New Posts: 538 (-30%) ✓
- Engagements: 235K (-18%) ✓

**Row 3 — Big Number Tiles:**
- Engagement Rate: 1.77% (+47%) ✓
- Views: 13.3M (-44%) ✓

**Row 4 — Best Performing Content (Lifetime):**
- Sort: Engagements (default — confirmed visible label, posts ordered by Engagements desc)
- 5 posts visible (ranks 1-5): hbomax × 5 Threads posts
  - 1: Sun Jan 04 2026 08:00 AM PST
  - 2: Fri Dec 12 2025 09:02 AM PST
  - 3: Sat Dec 13 2025 03:05 PM PST
  - 4: Sun Sep 14 2025 05:27 PM PDT
  - 5: Tue May 27 2025 07:12 PM PDT
- Sort dropdown menu options (in order observed): Engagements, Likes, Replies, Reposts, Quotes, Shares, Views — 7 metrics, matching spec exactly

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Threads channel icon appears in Single channel selection, positioned next to LinkedIn channel, **with a separator in between** | Threads IS next to LinkedIn (right side), but NO `chan-separator` element exists between LinkedIn and Threads. Only one separator in the entire channel strip — after position 4 (TikTok), before position 5 (YouTube). | ❌ FAIL |
| A2 | First row tiles: Total Followers, Follower Growth, Fan Growth Rate | All three present in row 1 | ✅ PASS |
| A3 | Second row tiles: New Posts, Engagements | Both present in row 2 | ✅ PASS |
| A4 | Third row tiles: Engagement Rate, Views | Both present in row 3 | ✅ PASS |
| A5 | BPC tile in fourth row | "Best Performing Content (Lifetime)" tile rendered below the metric chart rows | ✅ PASS |
| A6 | BPC posts/sort-by dropdown shows: Engagements, Likes, Replies, Reposts, Quotes, Shares, Views | Sort dropdown contained all 7 metrics in the listed order | ✅ PASS |
| A7 | BPC contains 5 posts | 5 hbomax Threads posts visible (ranks 1-5) | ✅ PASS |
| A8 | BPC default sort by Engagements | Sort dropdown label reads "Engagements" by default; posts in desc Engagements order | ✅ PASS |
| A9 | Threads channel not available when perspective = Public | Channel strip in Public perspective omits LinkedIn AND Threads; URL `channels=` only contains facebook/twitter/instagram/tiktok; tabs row drops Stories/Audience/Paid (which require Threads in some cases) | ✅ PASS |

## Bugs filed (recommended)

**BUG (Blocker per spec priority):** Channel strip on Brand > Insights is missing a `chan-separator` between LinkedIn (position 6) and Threads (position 7). Spec QA-96665 A1 requires a separator between these two channels. The only separator currently in the DOM is between TikTok (position 4) and YouTube (position 5).
- Steps to reproduce: Brand > Insights → any brand with both LinkedIn and Threads enabled (e.g., HBO Max brand_id=155614) → inspect Channels strip → see LinkedIn and Threads as direct siblings with no `chan-separator` element between them.
- Expected: A `chan-separator` element between the LinkedIn and Threads icons.
- Actual: No separator; icons rendered adjacent.

## Skill registry impact
- `view-perspective-toggle` v1 — pass_streak +1 (separate-day verification: Authorized → Public toggle changes brand_id, channel availability, and tab row simultaneously; URL params confirm)
- Could promote `view-perspective-toggle` from `untrusted` if this reaches its 3rd separate-day pass — it has 1 today, needs to check past usage.

## Sources
- [QA-96665 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-96665)
