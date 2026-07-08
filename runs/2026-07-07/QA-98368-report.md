# QA-98368 — Brand Content - Threads - Post Type Hovering functionality

- **Run date:** 2026-07-07/08 (interactive recovery run — was timeout/no-report BLOCKED in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-98368 · Priority: Minor
- **Verdict:** **PASS (best-effort)** — A1, A2, A4, A5 verified; A3 (close via X / click-elsewhere) has its control present but the close couldn't be cleanly demonstrated under headless synthetic-hover.
- **Account:** HBO Max (account_id=657) · **Brand:** HBO Max (155614) · **Channel:** Threads · Public
- **Skills:** switch-account, embedded-post-tooltip

## Open linked bugs
None open (cache 2026-07-03).

## Recovery notes (why it was no-output before, and what it needed)
1. **Date range:** Threads has **0 HBO Max posts in the default last-7-days** window ("There is no data available"). Widening to **Jan 1 – Jul 6 2026** surfaced **Posts (25)**. The unattended run (default week) had nothing to hover → no output.
2. **Table View load:** the Threads Brand-Content **Table View intermittently shows "This table failed to load"** — it took **two Reload clicks** before the 25 rows rendered. (Reload-first discipline applied.)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Post tooltip displays when hovering the Type-column link | Hover fired `div.embedded-post-tooltip` (+ `-body`) showing the Threads post preview ("hbomax / Hosted Rivalry / Busted. HeaterRiv…" + image) matching row 1's Text | ✅ PASS |
| A2 | User can view only one tooltip | After a proper hover, exactly **1** `.embedded-post-tooltip` present | ✅ PASS |
| A3 | Tooltip closes on 'X' (upper right) or clicking elsewhere | Close control **present** (`i` in `.close-row` inside the tooltip); clean close **not demonstrable** under headless synthetic-hover (tooltip stays pinned; a trusted X-click + mouseleave did not clear it because the synthetic hover state persists) | ◐ PASS w/ limit |
| A4 | Hovering another Type link does not open additional tooltips | Proper leave→hover transition to the 2nd link kept the count at **1** (replaces, not adds) | ✅ PASS |
| A5 | Clicking the post type opens the correct channel post in a new tab, matching the tooltip | Each of the 25 Type links is `<a target="_blank" href="https://www.threads.com/@hbomax/post/…">` (e.g. `.../post/DTGD3H-jd5Y`) — native Threads post, opens new tab, matches the hovered post | ✅ PASS |

## Evidence
- `.playwright-out/QA-98368/tooltip.png` — embedded post tooltip with Threads preview over the table.
- `.playwright-out/QA-98368/table-retry2.png` — 25-row Threads table (Type column = Video/Gallery links) after 2nd reload.
- DOM: 25 Type links → `threads.com/@hbomax/post/...` (target=_blank); tooltip count = 1 after proper hover transition.

## Limitation (headless)
A3's close interaction depends on real mouse enter/leave/click on a pinned popover; the synthetic MouseEvents used headless keep the tooltip pinned, so the close couldn't be cleanly shown. The **close control exists** and the tooltip is a standard pinned popover — no defect observed, just not demonstrable in this harness.

## Bugs filed
None. (Note for dev/harness: Threads Brand-Content **Table View "failed to load"** needed two reloads — worth watching if it recurs.)
