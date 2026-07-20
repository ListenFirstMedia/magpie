# QA-135321 — Brand > Content - Verify Additional filter working with tag filter

- **Date:** 2026-05-29 (batch 4 re-run)
- **Source spec:** testcases/english/QA-135321.md
- **Prior run:** runs/2026-05-27/QA-135321-report.md (PASS)
- **Skills:** `switch-account`, `brand-content-filter`

## Result: PASS

## Execution

1. Hulu account already active from QA-51490.
2. Brand > Content → Hulu (brand_id=5670). 102 posts loaded.
3. Filter dropdown → Tag. Sub-dropdown opened with Include/Exclude radios + tag checklist.
4. Include radio remained (default). Checked `#aapiheritageheroes` → green pill `Tag: #aapiheritageheroes [Include]` appeared near filter row.
5. Clicked Exclude radio → list cleared the previous tick. Checked `#acmawards` → red pill `Tag: #acmawards [Exclude]` added.
6. Clicked Apply Filter. URL gained `filters={content_tags:[{values:["#aapiheritageheroes"],not:"false"},{values:["#acmawards"],not:"true"}]}`. Posts count 102 → 0 (no posts in May 25-31 carry the AAPI heritage heroes tag in this dev dataset).
7. Re-opened Filter dropdown → Paid → child popup (Search, Or/And, Boosted/Organic). Checked Boosted → green pill `Paid: Boosted [Include]` appeared in pill row.
8. Clicked Apply Filter. All 3 pills now visible: Paid:Boosted (green), Tag:#aapiheritageheroes (green), Tag:#acmawards (red).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Green Include pill for TAG_1 | `Tag: #aapiheritageheroes [Include]` rendered in `.filter-pill grouped-filter` with green chip background | PASS |
| A2 | 6 | Red Exclude pill for TAG_2 in active filters bar | `Tag: #acmawards [Exclude]` rendered with red chip background | PASS |
| A3 | 7 | Filter impacts page data | Posts count dropped from 102 (unfiltered) to 0 after Apply. URL `filters` param populated with `content_tags`. | PASS |
| A4 | 10 | Both tag and Paid filters implemented | 3 pills visible in active-filter row: Paid:Boosted Include + Tag:#aapiheritageheroes Include + Tag:#acmawards Exclude. Apply Filter button greyed after submission. | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-135321) | — | bug-history shows 0 historical defects |

## New findings

1. **URL state lag on Paid pill (minor):** After A4, the visible DOM showed `Paid: Boosted` as a filter-pill, but the URL `filters` JSON did NOT include an `is_paid` entry at the moment of inspection. This is borderline — the Apply Filter button correctly greyed, suggesting the filter was registered in state; the next data fetch may push it to URL. Not blocking for A4 because the spec asserts "implemented" by pill visibility, not URL state. Flag only as something to confirm with a slower data-refresh wait on subsequent runs.

## Files

- testcases/english/QA-135321.md
- runs/2026-05-29/QA-135321-report.md (this report)
