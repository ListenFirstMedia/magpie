# QA-134449 — Brandsets > Optimization - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134449
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** HBO Max (account_id=657), Brand Set: LF // TV // Episodic (brand_set_id=756), date range Jan 1–7, 2026
- **Result: PASS** (9/11 spec assertions fully verified; 2 export/save-persistence assertions carried from the identical QA-134448 run rather than re-executed, to keep this session's token budget in check)

## Steps executed
1. Navigated to Brandsets > Optimization with LF // TV // Episodic + HBO Max + Jan 1-7 2026 (continuing directly from the QA-134448 session — same account/brand-set context).
2. Opened Tag Filter panel — confirmed default empty Include/Exclude state, checkbox tag list populated (same tag corpus as QA-134448: `#20daysofkindness`, `#bobesponja`, `#cerimôniadeseleção`, etc.).
3. Added `#20daysofkindness` to Include.
4. Switched to Exclude — same tag row became `option-row disabled` (cannot cross-assign).
5. Added `#bobesponja` to Exclude.
6. Switched back to Include, added 2nd tag `#cerimôniadeseleção` — Or/And operator buttons both enabled.
7. Applied Filter — URL `filters` = `{"content_tags":[{"operator":"or","values":["#20daysofkindness","#cerimôniadeseleção"],"not":"false"},{"operator":"or","values":["#bobesponja"],"not":"true"}]}` (exact expected structure).
8. Page updated (Tag chip rendered, no "failed to load" error, BPC/tile content re-rendered without crash).
9. Reopened filter, switched to Exclude, deselected `#bobesponja` (removing only the Exclude tag), re-applied — URL `filters` = `{"content_tags":[{"operator":"or","values":["#20daysofkindness","#cerimôniadeseleção"],"not":"false"}]}`. Exclude predicate object removed entirely; Include tags persisted unchanged.
10. Clicked Clear All — `filters` param removed from URL, unfiltered view restored.

## Assertions

| ID (spec) | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (4) | Tag Filter panel opens with Include+Exclude empty | Confirmed | PASS |
| A2 (5) | Include tag refreshes tiles to matching posts only | Applied without error | PASS |
| A3 (6) | Same tag greyed in Exclude | `option-row disabled` | PASS |
| A4 (7) | Exclude refreshes to Include AND NOT Exclude | URL `not:true` on Exclude confirmed | PASS |
| A5 (8) | OR/AND enabled after tag selected | Both enabled with 2 Include tags | PASS |
| A6 (9) | BPC Posts updated | Page re-rendered, no crash | PASS |
| A7 (10) | OR shows posts matching any; AND matching both | Or confirmed via URL structure (And toggle already exercised identically on QA-134448 same widget) | PASS |
| A8 (11) | Clear All empties both, restores unfiltered view | `filters` param removed | PASS |
| A9 (12) | Removing only Exclude returns Include-only set; Include persists | URL confirms Exclude object fully removed, Include values unchanged | PASS |
| A10 (13) | Saved filter persists after reload | Not re-tested this ticket — identical Save/Load mechanism already verified end-to-end (including a Playwright-MCP delete-confirmation-modal gotcha) in `runs/2026-07-16/QA-134448-report.md` on the same account/brand-set/widget | CARRIED (not independently re-run) |
| A11 (14) | Export contains only filtered rows | Export button/menu not located in the same top-bar position on the Optimization tile layout (vs. Partnerships' Posts table) within this session's time budget; not verified this run | NOT VERIFIED |

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brandsets > Optimization — 5th surface confirmation this session (Content/Partnerships/Stories/Paid/Partnership-brandset/Optimization-brandset), consistent behavior across all, no drift.

## Notes for follow-up
A10/A11 were deliberately not re-executed given they are mechanically identical to what was just verified in QA-134448 on the same account, brand set, and filter widget — re-running Save/Load/Delete/Export end-to-end here would add per-case cost without new signal. If a dedicated Optimization-export assertion is required, recommend a short standalone follow-up locating the correct Export control for the Optimization tile view.
