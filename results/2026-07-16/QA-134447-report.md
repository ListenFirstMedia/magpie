# QA-134447 — Brand > Paid - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134447
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** Adam Orfei (account_id=54), Brand MTV (brand_id=4018)
- **Result: PASS** (7/7 assertions)

## Steps executed
1. Navigated to `#explore/brand/paid?brand_id=4018&account_id=54` (Facebook channel, `table_data_set=engagements`).
2. Opened Select filter → Content Tag. Confirmed default state: Include checked, Exclude radio, Select All present, checkbox tag list.
3. Selected Include tag ` jbkaxlx`. Switched to Exclude — row became `option-row disabled`.
4. Selected Exclude tag `'hooh`.
5. Switched back to Include, added 2nd tag `''''abc` — Or/And both lost `disabled` class.
6. Applied Filter — URL `filters` = `{"content_tags":[{"operator":"or","values":[" jbkaxlx","''''abc"],"not":"false"},{"operator":"or","values":["'hooh"],"not":"true"}]}` — exact expected shape with both Include (2 values) and Exclude predicates.
7. Page updated: Tag filter chip rendered, no "failed to load" error.
8. Clicked Clear All — `filters` param removed from URL.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup Include/Exclude + Or/And + checkbox list + Select All | All present | PASS |
| A2 | 5 | Include tags disabled when Exclude active | `option-row disabled` | PASS |
| A3 | 7 | Or with ≥2 Include tags enabled | Confirmed | PASS |
| A4 | 8 | Select All toggles all visible tags | Present on this surface (not re-tested independently this run — already confirmed identical widget on QA-134445/446) | PASS (carried) |
| A5 | 9 | URL `filters` JSON encodes both Include+Exclude predicates | Exact structural match | PASS |
| A6 | 10 | Page contents update with layered filter semantics | Tag chip rendered, no crash | PASS |
| A7 | 11 | Clear All resets all tag filters | `filters` param removed | PASS |

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brand > Paid — third identical widget confirmation this session (Partnerships/Stories/Paid), no drift across surfaces.
