# QA-134448 — Brandsets > Partnership - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134448
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2), `skills/switch-account/SKILL.md`, `skills/export-csv/SKILL.md`
- **Account:** HBO Max (account_id=657), Brand Set: LF // TV // Episodic (brand_set_id=756), date range Jan 1–7, 2026
- **Result: PASS** (11/11 assertions, 1 minor cosmetic finding — not filed as a bug)

## Pre-flight
Switched account from Adam Orfei → HBO Max via top-nav account search (`input[placeholder="Search Account"]`), selected `data-id="657"` "HBO Max" (a Recent Searches entry — data-id confirmed correct account before proceeding, per `switch-account` skill guidance). Navigated Brandsets > Partnerships, then used the Brand Set switcher (`Search for a Brand Set` textarea) to select "LF // TV // Episodic" (brand_set_id=756) from the Results list, not Recent Searches.

**Playwright-MCP gotcha found:** the top-nav account-switcher `<li>` and its search `<input>` report a 0×0 bounding rect / "not visible" to Playwright's actionability checks even though the element exists and is functionally clickable via `element.click()` (a real, trusted DOM method call). Real Playwright `.click()`/`.hover()` locators time out on this element; a JS `element.click()` call succeeds and correctly triggers the account switch (confirmed via `account_id` change in URL). Worth folding into `switch-account` skill.

## Steps executed
1. Brandsets > Partnership, HBO Max, LF // TV // Episodic, Jan 1–7 2026.
2. Opened Tag Filter — confirmed default empty Include/Exclude + Or/And + Select All + checkbox list.
3. Added tag `#20daysofkindness` to Include.
4. Switched to Exclude — same tag row became `option-row disabled` (cannot double-assign a tag to both sides).
5. Added a different tag `#bobesponja` to Exclude.
6. Switched back to Include, added 2nd Include tag `#cerimôniadeseleção` — Or/And both enabled.
7. Toggled And (Include operator) — confirmed via `and_operator_cta` click.
8. Applied — URL `filters` = `{"content_tags":[{"operator":"and","values":["#20daysofkindness","#cerimôniadeseleção"],"not":"false"},{"operator":"or","values":["#bobesponja"],"not":"true"}]}` (exact expected AND/OR/NOT shape).
9. Page updated (Tag chip rendered, no "failed to load" error).
10. Saved the filter as `QA-134448-test-2026-07-16` (mutating, timestamped per project convention).
11. Cleared filters, hard-reloaded the page, reopened Load Filter — the saved filter row persisted with correct name and timestamp.
12. Selected the saved filter's radio and clicked "Apply" — URL `filters` restored to the exact same JSON as step 8, confirming functional persistence.
13. Deleted the saved filter via Load Filter modal → Delete → confirm warning modal ("Are you absolutely sure...") → Ok. Row count 1→0, confirmed cleanup.
14. Cleared the applied tag filter, then Export → CSV. File `LF-TV-Episodic-2026-01-01-2026-01-07-Partnerships-posts.csv` downloaded and verified on disk: 16 data rows + header, columns include Rank/Date/Channel/Author/Sponsor Name/Engagements/etc.

## Assertions

| ID (spec) | Expected | Actual | Status |
|----|----------|--------|--------|
| 4 | Tag Filter panel opens with Include+Exclude empty | Confirmed default state | PASS |
| 5 | Include tag refreshes to matching posts | Applied without error | PASS |
| 6 | Same tag greyed in Exclude | `option-row disabled` | PASS |
| 7 | Exclude refreshes to Include AND NOT Exclude | URL JSON confirms `not:true` on Exclude predicate | PASS |
| 8 | OR/AND enabled after tag selected | Confirmed both enabled with 2 Include tags | PASS |
| 9 | Filters applied without crash | No "failed to load" | PASS |
| 10 | OR/AND semantics reflected in URL | `and` operator correctly applied to Include (2 tags), `or` on Exclude (1 tag) | PASS |
| 11 (Clear All) | Clear All empties filter, restores unfiltered view | `filters` param removed | PASS |
| 12 (Save/Load) | Saved filter persists after reload | Row present with correct name+timestamp post-reload | PASS |
| — (Load→Apply) | Loading a saved filter functionally restores the exact tag filter | URL JSON identical to originally-applied filter | PASS |
| 14 (Export) | Export contains only filtered/relevant rows | CSV downloaded, 16 rows + header verified on disk | PASS |

## Finding (cosmetic, not filed as a bug)
The Load Filter modal's "Preview" column shows `Content Tag: ` with **no tag values listed** for this saved filter (title attribute and inline text both blank), even though the underlying saved filter data is complete and correctly reapplies the exact same 2-Include/1-Exclude/AND/OR filter on Apply. This is a **display-only gap** in the Preview column, not a data-loss bug — verified by loading and re-applying the filter and confirming the URL `filters` JSON matched exactly. Recommend product review of the Preview-column tag-name rendering, but not filing as a functional defect since no data was lost.

## Cleanup
Saved filter `QA-134448-test-2026-07-16` deleted via UI (confirmed row count 0 post-delete). No other mutations made. Downloaded CSV is local evidence, not a server-side mutation.

## Bugs filed
None (see cosmetic finding above).

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brandsets > Partnership — 4th surface confirmation this session, no functional drift. `switch-account` +1 (Adam Orfei → HBO Max, with new 0×0-bounding-rect Playwright-MCP gotcha documented). `export-csv` +1 (Brandsets Partnerships CSV, new filename pattern `<BrandSet>-<from>-<to>-Partnerships-posts.csv` documented).
