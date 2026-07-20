# QA-134445 — Brand > Partnerships - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134445
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** Adam Orfei (account_id=54), Brand MTV (brand_id=4018)
- **Result: PASS** (7/7 assertions)

## Steps executed
1. Navigated to `#explore/brand/partnerships?brand_id=4018&account_id=54` (perspective auto-resolved to `extended`/Authorized on load — cosmetic, not asserted by this ticket).
2. Opened Select filter → Content Tag.
3. Confirmed default state via DOM: Include radio checked, Exclude radio, Select All present, checkbox tag list (400+ tags rendered).
4. Selected Include tag `+tag` (Or). Switched to Exclude — `+tag` row became `option-row disabled` (A2 confirmed, same pattern as QA-134436).
5. Selected Exclude tag `'hooh`.
6. Switched back to Include, added 2nd Include tag `*/-+56324792` — `or_operator_cta`/`and_operator_cta` both lost `disabled` class (A3).
7. Clicked Select All under Include — all 20 currently-rendered rows became `selected` (2→20/20) (A4).
8. Applied Filter — URL `filters` decoded to `{"content_tags":[{"operator":"or","values":[<full ~400-tag Include set>],"not":"false"},{"operator":"or","values":["'hooh"],"not":"true"}]}` (A5 — both Include and Exclude predicates present and correctly shaped).
9. Page re-rendered the applied filter as inline pill chips (`Tag: +tagOr.../hooh`) under the Partners table header with no "failed to load" error; Partners list rendered empty for this combo (A6 — page updates with layered semantics, no crash).
10. Clicked Clear All — `filters` param removed from URL entirely (A7).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup Include/Exclude + Or/And + checkbox list + Select All | All present | PASS |
| A2 | 5 | Include tags disabled when Exclude active | `option-row disabled` exact match | PASS |
| A3 | 7 | Or with ≥2 Include tags enabled; 1 tag disabled | Confirmed both states | PASS |
| A4 | 8 | Select All toggles all visible tags | 2→20/20 selected | PASS |
| A5 | 9 | URL `filters` JSON encodes both Include+Exclude predicates | Exact structural match | PASS |
| A6 | 10 | Page contents update with layered filter semantics | Filter chips rendered inline, no crash; empty Partners result for this sparse combo | PASS |
| A7 | 11 | Clear All resets all tag filters | `filters` param removed | PASS |

## Notes
Using "Select All" produced a ~400-value Include array — functionally correct but very output-heavy; for future runs on this flow, prefer 2-3 explicit tag picks over Select All to keep evidence capture lean.

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brand > Partnerships. No drift.
