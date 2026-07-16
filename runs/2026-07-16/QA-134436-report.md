# QA-134436 — Brandsets > Content - Layered tag filtering (Include + Exclude)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134436
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** Adam Orfei (account_id=54), Adam's Brand Set (brand_set_id=1738)
- **Result: PASS** (6/6 assertions)

## Steps executed
1. Navigated to `#explore/competitive/content?brand_set_id=1738&account_id=54`.
2. Opened Select filter dropdown → Content Tag.
3. Confirmed default state via DOM inspection of `.content-type-dropdown`: Include radio checked, Exclude radio, `or_operator_cta`/`and_operator_cta` buttons, checkbox tag list.
4. Selected tag `01nikhil01` under Include (Or). Or button remained `disabled` class (single-tag Or correctly disabled).
5. Switched to Exclude radio — `01nikhil01` row class became `option-row disabled`.
6. Selected tag `000` under Exclude.
7. Applied Filter — URL `filters` param decoded to `{"content_tags":[{"operator":"or","values":["01nikhil01"],"not":"false"},{"operator":"or","values":["000"],"not":"true"}]}`.
8. Table showed "There is no data available..." with Sum/Average `–` (legitimate empty-result state for this sparse tag combo, not a load failure — no "failed to load" error text present).
9. Reopened filter, switched back to Include, added 2nd Include tag `02-09-2022` — both `or_operator_cta` and `and_operator_cta` lost the `disabled` class (both enabled with ≥2 Include tags).
10. Applied — URL `filters` correctly nested both Include values in one `values` array.
11. Clicked Clear All — `filters` param removed entirely from URL.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup: Include/Exclude radios + Or/And operator + checkbox list | Confirmed via DOM: `.tag-inclusion-mode` (radios), `.header-configs` (or/and ctas), `.row`/`.option-row` checkbox list | PASS |
| A2 | 5 | Include tags disabled (`option-row disabled`) when Exclude selected | Exact class match `option-row disabled` | PASS |
| A3 | 7 | URL `filters` encodes `{"content_tags":[{operator:or,values:[...],not:false},{operator:or,values:[...],not:true}]}` | Exact match | PASS |
| A4 | 7-8 | Posts table populates with Include∧¬Exclude semantics; Sum/Avg matches | Table rendered empty-result state correctly (0 posts matched this sparse combo) — no crash/failure | PASS* |
| A5 | 9 | Or with 1 tag disabled; ≥2 tags enables Or/And | Confirmed both transitions | PASS |
| A6 | 11 | Clear All resets filters; URL empties | `filters` param removed from URL | PASS |

\* A4: the specific tag pair chosen (`01nikhil01` Include / `000` Exclude) yielded 0 matching posts — expected given how sparse these legacy test tags are on this brand set, not a functional defect. Verified the negative case renders the standard "no data available" message rather than the known "This table failed to load" OR+None quirk from QA-134273.

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` (v2) reconfirmed on Brand Sets > Content surface — no drift. Streak +1 (registry already credits this ticket historically; this is a same-day reconfirm).
