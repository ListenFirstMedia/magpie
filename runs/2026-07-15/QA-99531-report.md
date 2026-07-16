# QA-99531 — Brand > Content - Threads - Hovering functionality on All Insights tile's

**Run date:** 2026-07-15
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54) · **Brand:** MTV (brand_id=4018, Rule 1 exact match)
**Channel:** Threads (multi-channel window; Threads isolated via legend/table columns, not a channel filter — see note)
**Window:** Mar 16, 2025 – Mar 22, 2025 (same window as the 2026-06-05/06-13 prior runs — confirmed to have Threads posts: 2 posts, 681 engagements)
**Data Set:** Public · **Result:** ✅ PASS

## Pre-test
- Re-read testcases/english/QA-99531.md (captured 2026-06-08): spec asks to hover the **Performance by Channel** and **Content Insights** tiles for Threads and verify hover values match chart/table data. Note: the 2026-06-13 prior-run report on this ticket actually exercised the *embedded-post-tooltip* flow (QA-923/926-style), which is a different assertion than what this ticket's saved spec describes — per Rule 5, re-read the ticket and executed the tile-hover flow the current spec text actually describes, not the prior report's flow.
- bug-history.md: no open/closed bug links for QA-99531.
- No existing skill covered Brand>Content's own Insights-dropdown tiles (`chart-hover-tooltip` only documents the separate Brand>Insights big-number-tile page) — authored `skills/brand-content-tile-hover/SKILL.md` (v1) from this run.

## Steps executed
1. Navigated to Brand > Content, MTV (`#explore/brand/content?brand_id=4018`), default multi-channel view, Mar 16–22 2025 window (carried over from URL state — contains Threads data per prior-run finding).
2. Opened the page-local **Insights** dropdown (next to Tag/Export) and checked **All Insights** (`#check-box_all-insights`) — this rendered `Performance by Channel` (3 tiles: New Posts, Engagements, Engagement Rate) above the Posts table.
3. Dismissed the statuspage.io "Twitter Impressions Outage" banner (cross-origin iframe overlapping the New Posts tile and silently swallowing hover events aimed at it) via Playwright's frame API (`page.frames()` → locate frame containing "Outage" → click its close button).
4. Hovered the Threads (`#1C1E21` black fill) arc on each of the 3 Performance-by-Channel tiles, scoped correctly via `.tile--channel-display` per tile (see skill for the ancestor-climb gotcha that initially cross-contaminated results between tiles).
5. Read each tile's shared multi-channel tooltip from `.chart-tooltip__container`.
6. Scrolled to **Content Insights → Performance by Type** (stacked bar chart by post type: Gallery/Video/Image/Text/Link) and hovered the Gallery bar (the only type with Threads posts).
7. Read the Content Insights tooltip the same way; also inspected **Performance by Tag** (no tags applied to any Threads post in this window — table shows `–` for Threads across the board, nothing to hover).
8. Cross-checked every tooltip value against its companion data table (`.al-table--performance-by-channel` for step 4/5; the Performance-by-Type rank table for step 6/7).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Hover Performance by Channel — New Posts tile | Tooltip renders with Threads value, matches table | Tooltip: `...Threads: 2` — table `Threads → New Posts → 2` | ✅ |
| A2 | Hover Performance by Channel — Engagements tile | Tooltip renders with Threads value, matches table | Tooltip: `...Threads: 681` — table `Threads → Engagements → 681` | ✅ |
| A3 | Hover Performance by Channel — Engagement Rate tile | Tooltip renders with Threads value, matches table | Tooltip: `...Threads: 1.81%` — table `Threads → Engagement Rate → 1.81%` | ✅ |
| A4 | Hover Content Insights — Performance by Type (Gallery bar) | Tooltip renders with Threads value, matches table | Tooltip: `Gallery / Facebook: 107,849 / Twitter: 76,337 / Instagram: 628,011 / TikTok: 1,260 / LinkedIn: 0 / Threads: 681` — table `Gallery → Threads → 681` | ✅ |
| A5 | Content Insights — Performance by Tag | Threads values (if any) match table | No tags applied to Threads posts this window (table shows `–` for Threads across all tag rows) — correctly empty, nothing to verify further | ✅ N/A (no data, not a gap) |

## Notable finding (documented, not filed as a bug)

Threads' Gallery-type engagement segment (681 of a 814,138-total bar) renders its stacked-bar
segment at **`height: 0`** — genuinely un-hoverable at the pixel level for that channel
specifically. This is expected proportional-stacking behavior, not a defect: the shared tooltip
(hovering anywhere on the visible bar) still surfaces the exact Threads value in its row, so the
assertion ("hover tooltip shows correct Threads value") is still satisfiable and was verified true.

## Bugs filed
None.

## Skill credit
- Authored `skills/brand-content-tile-hover/SKILL.md` (v1, untrusted, pass_streak 1) — new flow, no prior skill covered Brand>Content's own Insights tiles.
- Added row to `skills/REGISTRY.md`.

## Cleanup
Not applicable — read-only navigation and hover interactions, no mutation.
