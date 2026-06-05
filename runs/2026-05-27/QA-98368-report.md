# QA-98368 — Brand Content - Threads - Post Type Hovering functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-98368
- **Run date:** 2026-05-27
- **Account:** HBO Max (account_id=657)
- **Brand:** HBO Max (brand_id=155614, Authorized perspective)
- **Channel:** Threads only
- **Date Range:** May 26 2025 – May 26 2026 (12M, expanded from default 7D because the 7D window had `Posts (0)` for Threads even with the channel-specific data set; 12M window has 538 posts)
- **Data Set:** Threads Only: Insights (auto-selected after the default `Public` set returned no Threads rows — same pattern as the Brand>Content data-set-selector quirk doc'd in `known-quirks.md`)
- **Priority:** Minor (P4)
- **Result:** ✅ **5/5 PASS**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → HBO Max via Yash account picker (typed "HBO Max", picked from Results) | ✓ |
| 1 | Hover Brand in top nav → click Content | ✓ — URL `/#explore/brand/content` |
| 2 | Top-nav search → typed `HBO Max` → clicked exact-match `HBO Max` from live Results (Rule 1) | ✓ — brand_id=155614 |
| 3 | Threads channel selected, all others off — confirmed via channel strip (Threads icon active, others dim) and URL `channels=threads` | ✓ |
| 3a | Switched Data Set from default `Public` → `Threads Only: Insights` because default returned 0 posts | ✓ — Posts went from 0 → 538 |
| 3b | Expanded date range from default 7D to 12M (2025-05-26 → 2026-05-26) to ensure a healthy post population for tooltip testing | ✓ |
| 4 | Clicked Layout: Table view (first icon in the Layout group) | ✓ — table renders Rank/Date/Channel/Brand/Type/Live/Publish Type/Paid/Sponsor/Collaborated/Text/Engagements/Likes/Replies/Quotes/Reposts/Shares/Views columns |
| 5 | Hovered over `Video` link in Type column, row 1 | ✓ — tooltip with X close button materialized; verified via JS that only `.embedded-post-tooltip` + its `.embedded-post-tooltip-body` are visible (single tooltip) |
| 5a | Hovered over `Video` link in Type column, row 2 | ✓ — tooltip moved to row 2; STILL only one tooltip widget in DOM (no second one stacked) |
| 5b | Clicked the `X` in the upper right of the tooltip | ✓ — tooltip closed |
| 6 | Clicked `Video` link in Type column, row 1 | ✓ — new tab opened: `https://www.threads.com/@hbomax/post/DTGD3H-jd5Y`, title "Busted. HeatedRivalry" — matches the row's Text preview ("Busted. HeatedRiv...") |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Post tooltip displays when hovering the Post type link in the Type column | Tooltip wrapper (`.embedded-post-tooltip`) appeared above row 1 within ~1s of hover, with an X close button visible | ✅ PASS |
| A2 | User can view only one tooltip | JS check showed exactly 1 `.embedded-post-tooltip` + 1 `.embedded-post-tooltip-body` (inner wrapper of the same tooltip), no stacked duplicates | ✅ PASS |
| A3 | The tooltip closes when clicking 'X' in the upper right (or elsewhere on the page) | After clicking the X, tooltip removed from DOM (screenshot confirms clean table state restored) | ✅ PASS |
| A4 | Hovering other post type link will not open additional tooltips | Hovering row 2's Type link relocated the existing tooltip to row 2 — DOM still has exactly 1 tooltip wrapper | ✅ PASS |
| A5 | Clicking the post type opens the correct channel post in a new tab and it matches the Post tooltip | Click on row 1 `Video` link opened `https://www.threads.com/@hbomax/post/DTGD3H-jd5Y` in a new tab. Page title "Busted. HeatedRivalry" matches row 1's Text preview ("Busted. HeatedRiv...") on the LF table. URL slug `@hbomax/post/DTGD3H-jd5Y` confirms this is HBO Max's actual Threads post for the engagement-leader entry. | ✅ PASS |

## Evidence captured
- Brand>Content URL (final): `https://app.lfmdev.in/#explore/brand/content?brand_id=155614&account_id=657&from=2025-05-26&to=2026-05-26&channels=threads&perspective=extended&stats_attribution_window=lifetime&table_data_set=threads_only%3A_insights&sort_key=threads.post.engagements_authorized&sort_order=desc`
- Threads post opened via click: `https://www.threads.com/@hbomax/post/DTGD3H-jd5Y`
- Row 1 metrics confirming this is a real Threads post: Engagements 5,901 / Likes 5,238 / Replies 79 / Quotes 22 / Reposts 237 / Shares 325 / Views 78,588

## Bugs filed
None.

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day Hulu → Adam Orfei → HBO Max chain stable)
- `brand-content-data-set-selector` v1 — pass_streak +1 (used to switch to `Threads Only: Insights` after default `Public` returned no posts — same pattern that fixed QA-929's Pinterest empty state)
- `brand-content-table-view` v1 — pass_streak +1 (Layout: first icon = Table View, used to expose the Type column for the tooltip test)

## Recommended follow-up
- Document a tooltip-component name: `embedded-post-tooltip` in `_shared/selectors.md` so future tests can target it consistently (this name appeared in `data-class` strings on the DOM element).

## Sources
- [QA-98368 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-98368)
