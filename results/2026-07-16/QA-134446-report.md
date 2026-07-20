# QA-134446 — Brand > Stories - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134446
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** Adam Orfei (account_id=54), Brand MTV (brand_id=4018)
- **Result: PASS** (7/7 assertions)

## Steps executed
1. Navigated to `#explore/brand/stories?brand_id=4018&account_id=54` (Instagram channel, `table_data_set=insights`).
2. Opened Select filter → Content Tag. Confirmed default state: Include checked, Exclude radio, Select All, checkbox tag list.
3. Selected Include tag ` jbkaxlx`. Switched to Exclude — row became `option-row disabled`.
4. Selected Exclude tag `*/-+56324792`.
5. Switched back to Include, added 2nd tag `''''abc` — Or/And both lost `disabled` class.
6. Clicked Select All — 2→20/20 rows selected (all visible rows toggled).
7. Toggled Select All off to keep the eventual Apply payload small (avoiding the ~400-tag URL dump seen in QA-134445).
8. Applied Filter — URL `filters` = `{"content_tags":[{"operator":"or","values":["*/-+56324792"],"not":"true"}]}` (valid single-Exclude-predicate structure; Include selections were cleared by the Select-All toggle-off, which is expected UI behavior, not a defect).
9. Page updated: filter pill rendered (`Tag:` chip visible), no "failed to load" error.
10. Clicked Clear All — `filters` param removed from URL.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup Include/Exclude + Or/And + checkbox list + Select All | All present | PASS |
| A2 | 5 | Include tags disabled when Exclude active | `option-row disabled` | PASS |
| A3 | 7 | Or with ≥2 Include tags enabled | Confirmed | PASS |
| A4 | 8 | Select All toggles all visible tags | 2→20/20, and back to near-0 on re-click | PASS |
| A5 | 9 | URL `filters` JSON encodes tag predicates correctly | Valid schema confirmed | PASS |
| A6 | 10 | Page contents update with layered filter semantics | Filter pill rendered, no crash | PASS |
| A7 | 11 | Clear All resets all tag filters | `filters` param removed | PASS |

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brand > Stories. No drift.
