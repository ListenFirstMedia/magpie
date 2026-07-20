# QA-86318 — Reporting > Data Studio - Adding the Same Brand with Different Perspectives

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-86318
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **Skill used:** `data-studio-multi-perspective` (v1, untrusted) — this is the skill's origin ticket

## Steps executed

1. Reporting → Data Studio.
2. Add a Brand: typed and selected **Michael Kors** (exact match from typeahead options).
3. Typed and selected **MTV** (exact match, avoiding the ~70 `MTV (...)` variants in the dropdown).
4. Typed and selected **MTV** a second time — a second identical row appeared in the brand table.
5. Toggled the **second MTV row's** `.al-toggle__checkbox` (scoped to that `<tr>`, per the skill's documented hazard about the page-level Mode toggle using the same class) → confirmed `checked=true` (Authorized).
6. Select Metrics → expanded the **Engagements** section → clicked **Facebook Engagements** and **Twitter Engagements** — both appeared in the Page Level Metrics table.
7. Clicked **Go** → report generated (report_id=301107).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Allows adding a brand with different perspectives (Public + Authorized) | Two independent MTV rows created, each with its own Public/Authorized toggle; second toggle successfully flipped to Authorized (`checked=true`) without affecting the first row (Public) | **PASS** |
| A2 | 6a | Data displays for selected brands | Chart renders a Facebook Engagements line (MTV Authorized dataset, values up to 34,708); table shows Sum/Average/daily columns for Michael Kors and both MTV rows | **PASS** |
| A3 | 6b | MTV appears with both Public and Authorized in legend (`MTV [P]` and `MTV`) | Legend reads: `Michael Kors [P]` · `MTV [P]` · `MTV` — exactly the expected pattern (Public rows carry the `[P]` pill, the Authorized MTV row has none) | **PASS** |

## Evidence

Legend screenshot confirms three chips: `■ Michael Kors [P]`, `■ MTV [P]`, `■ MTV` (distinct colors: purple, orange, teal). Table rows: Michael Kors Sum 3,879 / Avg 554; MTV (one of the two rows) Sum 92,268 / Avg 13,181 with daily breakdown Jun 29–Jul 5, 2026.

## Problems encountered

1. **The typeahead option list doesn't always render on the very next `pressSequentially` call** — my first attempt to add "MTV" a second time found zero options matching exact text "MTV" (the ~70-variant dropdown hadn't finished re-rendering after the `fill('')` reset). A retry with a longer wait (800ms) succeeded. Skills relying on rapid repeated typeahead adds should build in a re-check-and-retry rather than assuming the first attempt always renders in time.
2. **The metric-tree checkbox rows aren't wrapped in `<li>` with a sibling native `<input type=checkbox>`** in the current build — DOM inspection for `li.leaf` / `input[type=checkbox]` near the "Facebook Engagements"/"Twitter Engagements" labels came up empty even after the metrics were visibly selected and correctly added to the Page Level Metrics table. A plain Playwright `.click()` on the label text worked regardless; only my post-hoc DOM-based checked-state verification failed, not the actual interaction. Future automation should verify via the **Page Level Metrics table** (`.al-table__row` containing the metric name), not by hunting for a checkbox input.
3. A ListenFirst status-alert iframe (`iframe[title="ListenFirst Status"]`) intercepted a click on **Select Metrics**, requiring the iframe to be hidden via `style.display='none'` before the click would land — this iframe has now blocked clicks in multiple tickets this session (QA-96670, QA-86318) and is worth a standing workaround in `_shared/selectors.md`.

## Skill updates

`data-studio-multi-perspective` — reusing as-is; no functional regression found. Both problems above are automation-only friction, folded into a v2 note in the skill file, plus a general note to add the status-iframe-hide workaround to shared selectors.

## Bugs filed

None. All 3 assertions passed.
