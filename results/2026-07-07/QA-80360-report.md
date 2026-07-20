# QA-80360 — Reporting > Data Studio - Adding Page-Level Metrics Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-80360
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Michael Kors
- **Skills used:** `data-studio-post-level-run` (mechanics reused for the Page Level builder), `view-perspective-toggle` (Rule 2 discipline for the perspective check)

## Steps executed

1. Reporting → Data Studio (Page Level).
2. **Cleared stale builder state** (`Remove All` × 2) left over from QA-82626 earlier this session — same precondition gotcha documented in the new `data-studio-short-link` skill.
3. Add a Brand: typed and selected **Michael Kors** (exact match).
4. Inspected `.al-toggle__checkbox` for the Michael Kors row: `checked=false` (Public) before any action — clicked it, confirmed `checked=true` (Authorized) afterward (Rule 2: verified via DOM, not assumed).
5. Select Metrics → clicked the **New Video Posts** `<h4>` subheader under the **Posts** category (not the search box — searching "New Video Posts" as free text returns zero leaf results since it's a category header, not itself a metric).
6. Tree expanded to reveal: Video Posts, Facebook Video Posts, Twitter Video Posts, Instagram Video Posts, YouTube Posts, TikTok Video Posts, LinkedIn Video Posts. Checked **Facebook Video Posts**, **Twitter Video Posts**, **Instagram Video Posts**, **YouTube Posts**.
7. Closed the metric picker via `.metrics__tree-modal__close` ("X").
8. Clicked the trash icon on the **Twitter Video Posts** row in the Page Level Metrics configuration table.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Perspective is Authorized | `.al-toggle__checkbox` for the Michael Kors row read `checked=true` after the click (verified via DOM inspection per Rule 2, not just a visual guess) | **PASS** |
| A2 | 6 | Selected metrics shown under Metric column in config with trash icon | All 4 metrics (Facebook/Twitter/Instagram Video Posts, YouTube Posts) appeared as `.al-table__row` entries, each with a `.fa-trash` icon present | **PASS** |
| A3 | 7 | Selected metrics display with channel icon, metric name, trash icon in Page-Level Metrics section | Confirmed each row has a channel icon (`img`/`.channel-icon`) + metric name text + trash icon, all 4 present after closing the picker | **PASS** |
| A4 | 8 | Metric removed from Page-Level Metrics section | After clicking Twitter Video Posts' trash icon, the Page Level Metrics table shows exactly 3 rows: Facebook Video Posts, Instagram Video Posts, YouTube Posts — Twitter Video Posts gone | **PASS** |

## Evidence

Page Level Metrics table before delete: `["Facebook Video Posts", "Twitter Video Posts", "Instagram Video Posts", "YouTube Posts"]` (all 4 rows confirmed with `hasTrash: true, hasIcon: true`).
After delete: `["Facebook Video Posts", "Instagram Video Posts", "YouTube Posts"]`.

## Problems encountered

1. **"New Video Posts" is a category subheader, not a searchable leaf metric** — typing it into the "Search for a Metric" box returns zero results (the search only matches leaf metric names). The correct action is clicking the `<h4>` category label directly, which expands the tree to reveal its channel-specific children. This matches the spec's literal wording ("click the subheader") but is worth flagging since a naive automation approach (search-then-click, which worked for every other metric in this session) silently fails here.
2. **Duplicate hidden DOM nodes for "YouTube Posts"** — two elements share the same `for="lfm.activity_score.youtube_post_delta_checkbox"` label, one hidden (`not visible`) and one interactable. Had to target `nth(1)` after the first attempt timed out on the hidden copy. Consistent with the broader pattern (seen earlier this session with duplicate hidden datepicker tables) of this app rendering multiple copies of certain widgets and only one being the "live" one.
3. Builder-state persistence (same as QA-82626) required another explicit `Remove All` reset at the start.

## Skill updates

`data-studio-short-link`'s existing precondition-warning note already covers Problem #3. Adding the category-subheader-vs-search-leaf distinction (Problem #1) and the duplicate-hidden-YouTube-Posts-node quirk (Problem #2) as a short addendum to `data-studio-post-level-run`'s Playwright notes, since both builders share the same metric-tree component.

## Bugs filed

None. All 4 assertions passed.
