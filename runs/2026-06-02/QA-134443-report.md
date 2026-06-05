# QA-134443 — Brand > Optimization - Verify layered tag filtering (Include + Exclude)

- **Run date:** 2026-06-04 (QA-4325 batch 12)
- **Account:** Adam Orfei
- **Brand:** MTV (brand_id=4018)
- **Channels:** facebook+instagram+tiktok+twitter+youtube (default all 5; perspective=extended)
- **Date range:** May 25 – May 31 2026
- **Skill used:** `brand-content-filter` (extended to Brand > Optimization)
- **Result:** PASS

## Steps

1. Navigate `#explore/brand/optimization?brand_id=4018&account_id=54&from=...`.
2. Click `Filter: Select`; dropdown lists 11 filter options including `Tag`.
3. Click `Tag` option-row; sub-popup opens with Include/Exclude + Or/And + tag-value checkboxes.
4. Select `jbkaxlx` under Include.
5. Switch to Exclude — verify Include-selected tag greys out.
6. Select `+tag` under Exclude.
7. Click Apply Filter.
8. Verify URL `filters` JSON.
9. Click Clear All.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup Include/Exclude/Or/And/checkbox list | All present (`hasIncludeExclude=true`, `hasOrAnd=true`) | PASS |
| A2 | 5 | Include-selected tag becomes disabled in Exclude mode | `jbkaxlx` class → `option-row disabled` | PASS |
| A3 | 8 | URL `filters` JSON encodes both Include and Exclude tag predicates | URL: `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` (double-URL-encoded) | PASS |
| A4 | 7 | Page contents update with layered filter | "Analyzing up to 1,000 posts" — page accepted filter; no table-failed-to-load error reproduced. | PASS |
| A5 | n/a | Or with multiple Include tags enabled | NOT EXERCISED in this run; behavior reproduced upstream in QA-134272 batch-11 | N/A |
| A6 | 9 | Clear All resets filters | `filters` URL param dropped; chips count=0; `created-filters` no `Content Tag:` | PASS |

## Evidence

- Brand>Optimization Filter sub-popup is the SAME widget as Brand>Content / Brand Sets>Content layered tag filter.
- Backend OR-with-sparse-real-tags fail mode (QA-134273 carry-forward) did NOT reproduce here either.

## Bugs filed

None. Brand > Optimization layered tag filtering matches the Brand > Content / Brand Sets > Content parity.

## Skill notes

- `brand-content-filter` skill now also covers Brand > Optimization surface. Same `.shared-filters-add-filter-button` → option-row `Tag` → `.dropdown.content-type-dropdown` popup widget structure.
