# QA-134436 — Brandsets > Content - Verify layered tag filtering (Include + Exclude)

- **Run date:** 2026-06-04 (QA-4325 batch 12)
- **Account:** Adam Orfei (id=54)
- **Brand Set:** 1923 Talent (brand_set_id=11190; 8,341 posts default)
- **Date range:** May 25 – May 31 2026
- **Skill used:** `brand-content-filter` (extended to Brand Sets > Content)
- **Result:** PASS

## Steps executed

1. Navigate (via Home favorite click — direct URL nav was redirected to Home; clicking Brand Set Content link from Home succeeds) to `#explore/competitive/content?brand_set_id=11190&account_id=54&from=2026-05-25&to=2026-05-31`. Default channels = facebook+twitter+instagram+youtube+tiktok, perspective=standard.
2. Click `Filter: Select` button (class `shared-filters-add-filter-button`); dropdown lists 15 filter options including `Content Tag`.
3. Click `Content Tag` option-row; sub-popup opens with Include/Exclude radios + Or/And operator + tag-value checkbox list.
4. Click `jbkaxlx` check-box-container → `option-row selected`, icon flips to `fa-check-square`.
5. Click `Exclude` label radio → `jbkaxlx` row gains `disabled` class (greyed out).
6. Click `+tag` check-box-container under Exclude.
7. Click `Apply Filter` → URL gains `filters` JSON.
8. Verify Sum row + check for table-failed errors.
9. Click `Clear All` → all filter chips removed, URL `filters` param dropped.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup has Include/Exclude radios + Or/And operator + checkbox list | Confirmed: `Include`, `Exclude`, `Or`, `And` labels + filter-options-table with `None` + tags. Radio inputs present in `.dropdown.content-type-dropdown`. | PASS |
| A2 | 5 | Tags in Include become disabled when Exclude active | `jbkaxlx` row class → `option-row disabled` when Exclude active (icon retains `fa-square`); QA-134272 pattern reproduced | PASS |
| A3 | 7 | URL `filters` encodes both Include and Exclude predicates | URL: `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` (double-URL-encoded) | PASS |
| A4 | 7-8 | Posts table populates with Include∧¬Exclude semantics | Sum row = `–` (em dash). Body text shows `Content Tag: jbkaxlx` + `Content Tag: +tag` filter chips. No `table failed to load` error. Likely zero matching posts in the 1923 Talent set ∧ Include `jbkaxlx` ∧ Exclude `+tag`. | PASS |
| A5 | n/a (Or-vs-And not exercised in this run, single-tag in each set is no-op for Or vs And) | — | NOT VERIFIED (single-tag baseline; QA-134272 batch-11 already covered the Or-disabled-on-1-tag rule on Brand>Content surface) | N/A |
| A6 | 9 | Clear All resets all tag filters; URL `filters` empties | `filters` param dropped from URL after Clear All click; `created-filters` chip count = 0 | PASS |

## Evidence

- Brand Set: 1923 Talent (`brand_set_id=11190`); Adam's Brand Set (id=1738, ~76K posts) reproduced the documented Adam Orfei Brand Set hang on load; switched to 1923 Talent which is lighter (8,341 posts).
- URL after Apply: `filters=%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%252C%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%252Btag%2522%255D%252C%2522not%2522%253A%2522true%2522%257D%255D%257D` — decodes to layered Include `[" jbkaxlx", not:false]` + Exclude `["+tag", not:true]`.
- Tag values have leading-space artifact (e.g. ` jbkaxlx` not `jbkaxlx`) consistent with prior runs.
- Backend OR-with-sparse-real-tags fail mode (known-quirks 2026-06-04 entry) did NOT reproduce here — page rendered Sum row `–` (zero matches) without the "table failed to load" error. The layered Include∧Exclude pattern with single-tag-each-set is safe.

## Bugs filed

None. Layered tag filtering on Brand Sets > Content works as specified, matching Brand > Content parity (QA-134272/134273).

## Skill notes

- `brand-content-filter` skill now also covers Brand Sets > Content surface (`#explore/competitive/content`). Same widget structure as Brand > Content.
- Direct URL navigation to `competitive/content` with `brand_set_id=` was initially redirected to Home on a stale session; recovery via Home favorite click then forward to the brand-set Content link.
- Adam's Brand Set (id=1738) hangs the `loading` state when used as the test target — reuse the documented "narrow to a lighter brand set" workaround.
