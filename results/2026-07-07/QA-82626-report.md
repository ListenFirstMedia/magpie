# QA-82626 — Reporting > Data Studio - Short Link & URL loads

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-82626
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **Skills used:** `data-studio-post-level-run` (mechanics reused for Page Level too), plus ad-hoc exploration (no dedicated skill existed for this flow — candidate for a new `data-studio-short-link` skill)

## Steps executed

1. Reporting → Data Studio (Page Level, default).
2. **Cleared stale builder state** left over from earlier tickets this session (`Remove All` on both Brand and Metric tables — the Data Studio builder persists brand/metric selections across navigations within the same tab/account, which is a genuine automation gotcha, not a product bug).
3. Add a Brand: **Star Wars** (exact match) and **MTV** (exact match), toggled MTV's View to **Authorized**.
4. Select Metrics → **Facebook Total Fans** + **Twitter Total Followers** (Followers section).
5. Clicked **Go** → report built (report_id=301122).
6. Clicked the short-link (pin) icon (`.short-link-button`) → link `https://app.lfmdev.in/#s/9oQoyt4` appeared inline.
7. Opened the short link in a **new tab**.
8. Clicked **Show Configuration** (the "configuration button").
9. Removed **Twitter Total Followers** via its trash icon (`.fa-trash`, tabindex=0 — not a `<button>` wrapper on this Page-Level metrics table, unlike the `<button class="fa-trash">` documented for the post-level table in the skill's 2026-06-11 note).
10. Clicked **Go** again.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8a | Short link matches previously opened page URL | Short link `#s/9oQoyt4` resolved (in the new tab) to `https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54&report_id=301122` — the exact same report_id as the originally opened page | **PASS** |
| A2 | 8b | Same report displayed | Same brands (Star Wars, MTV), same 2 metrics, same data values rendered on the short-link-loaded page | **PASS** |
| A3 | 9a | Same applied configurations on new page | Brand rows + metric rows identical to the source report; Facebook Total Fans (Star Wars 32,398,163 / MTV 45,464,021) and Twitter Total Followers both present with matching Sum values | **PASS** |
| A4 | 9b | Go button disabled when no changes | `button[Go].disabled === true` immediately after opening the short link (before any edits) | **PASS** |
| A5 | 10a | Go button enabled after change | After deleting Twitter Total Followers, `button[Go].disabled === false` | **PASS** |
| A6 | 11 | New report generated with updated configuration | Clicking Go produced a **new** `report_id=301124` (different from 301122); resulting report shows only **Facebook Total Fans** (Twitter Total Followers correctly absent) for both brands | **PASS** |

## Evidence

- Short link: `https://app.lfmdev.in/#s/9oQoyt4` → resolved to `report_id=301122`.
- Post-delete, pre-Go state: Go button `disabled=false`; metric table showed only `Facebook Total Fans` row.
- Post-Go: URL `report_id=301124`; chart legend `Star Wars [P]` / `MTV`; table showed only the Facebook Total Fans metric row with daily values (e.g. MTV ≈45.46M across Jun 29–Jul 5, 2026).

## Problems encountered

1. **The Data Studio builder retains brand/metric selections across page navigations within the same session**, even after navigating away to entirely different tickets' flows and back. This meant the builder still had 2× MTV rows and 3 unrelated YouTube metrics left over from the QA-84084/QA-86318 runs earlier in this session. Had to explicitly click both **Remove All** links (Brand table + Metric table) before starting this ticket's exact configuration — otherwise the short-link/config-change assertions would have been contaminated by stale rows. Any future multi-ticket Data Studio run in one session should start with an explicit `Remove All` reset.
2. **Metric trash-icon markup differs between Page Level and Post Level.** The `data-studio-post-level-run` skill documents `<button class="fas fa-trash button--unset…">` for the *post-level* page-level-metrics table; on this *page-level* report's own metrics table, the trash is a bare `<i class="fas fa-trash" tabindex="0">` with no button wrapper — still clickable directly via a real Playwright click, no dispatch workaround needed, but the selector must be adapted per surface.
3. No skill previously existed for the short-link flow — authoring one now (see below).

## Skill updates

**New skill authored:** `skills/data-studio-short-link/SKILL.md` — documents the short-link button selector (`.short-link-button`), the inline link-display pattern, the Show Configuration → trash-icon → Go re-run flow, and the builder-state-persistence gotcha (Problem #1) as a precondition warning.

## Bugs filed

None. All 6 assertions passed cleanly.
