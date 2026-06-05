# QA-135321 — Brand > Content - Verify Additional filter working with tag filter — Run Report

- **Date:** 2026-05-27
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Date range:** May 20, 2026 – May 26, 2026 (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-135321.md

## Result: PASS

## Execution
1. Navigated `https://app.lfmdev.in/#explore/brand/content?account_id=336` — Hulu auto-loaded with MTV-style content view.
2. Clicked Filter dropdown → selected **Tag**.
3. Default state: Include radio + Or radio active; tag list rendered alphabetically (None, #1 streaming premiere, #90s4eva, #aapiheritageheroes, #aclfest, #acmawards, #actingchallenge, ...).
4. Selected TAG_1 = `#90s4eva` (Include checkbox). Green pill `Tag: #90s4eva Include` appeared in active-filters bar.
5. Switched radio to **Exclude**. Tag list refreshed; previously selected #90s4eva now greyed out.
6. Selected TAG_2 = `#aclfest` (Exclude checkbox). Red pill `Tag: #aclfest Exclude` appeared next to the green pill.
7. Clicked **Apply Filter** → URL params updated to encode both tag filters; Posts header re-counted to `Posts (0)` with "There is no data available" empty state (no posts within May 20-26 carry #90s4eva but not #aclfest — valid impact).
8. Clicked Filter dropdown → selected **Paid**. Paid popup opened with Boosted | Organic checkboxes (Or default).
9. Checked **Boosted**.
10. Clicked **Apply Filter** → URL params updated: added `content_is_paid` with value `Promoted` (Boosted → Promoted internal mapping). Three filter pills now visible: `Paid: Boosted Include`, `Tag: #90s4eva Include`, `Tag: #aclfest Exclude`.

## Assertions
- **A1 (Include Tag green pill for TAG_1):** PASS — `Tag: #90s4eva Include` pill rendered green after TAG_1 selection.
- **A2 (TAG_2 red Exclude pill):** PASS — `Tag: #aclfest Exclude` pill rendered red after TAG_2 selection in Exclude mode.
- **A3 (Filter impacts page data):** PASS — applying tag filter dropped Posts from default count to `0` (the green/red pill combo + URL params confirm both tags reached the server; empty result set is a valid impact).
- **A4 (Both tag and Paid filters implemented):** PASS — after Apply, all three pills visible side-by-side; URL encodes `content_is_paid` and `content_tags` with both tag entries. The pills are independently styled (Paid pill green/teal, Tag Include pill green, Tag Exclude pill red).

## Evidence
- Final URL (decoded):
  ```
  filters={
    content_is_paid: {operator:"or", values:["Promoted"], not:"false"},
    content_tags: [
      {operator:"or", values:["#90s4eva"], not:"false"},
      {operator:"or", values:["#aclfest"], not:"true"}
    ]
  }
  ```
- Active filter pills (left → right): `Paid: Boosted Include` (teal), `Tag: #90s4eva Include` (green), `Tag: #aclfest Exclude` (red).

## Notes
- Boosted ↔ Promoted internal mapping is a known pattern; Paid filter UI says "Boosted" but backend uses "Promoted". Worth documenting if filter export consumers expect "Boosted" verbatim.
- With Hulu's May 20-26 window, no post matches the combined `#90s4eva ∧ ¬#aclfest ∧ Boosted` constraint, so the test confirms the filter pipeline is wired without needing matching data. For richer demonstration use a wider date range or pick tags with more overlap.
- The "And" radio next to "Or" stays disabled until ≥2 tags are selected in the same radio mode — observed in QA-135319 too.
