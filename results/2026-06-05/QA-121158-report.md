# QA-121158 — Brand Content - Instagram - Collaborated Total Filter Functionality

- **Date:** 2026-06-08 (batch 8/12 QA-22296)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (spec brand_id=5670; URL auto-resolved to brand_id=11003 — Brand>Content quirk, UI shows "Hulu" with green Hulu logo)
- **Channel:** Instagram only
- **Perspective:** Public Data
- **Date Range:** Jun. 01, 2026 - Jun. 07, 2026 (default), then extended to Jan 01 - Dec 31 2025 to seek collaborated data
- **Result:** PARTIAL (filter UI verified, data-completeness limited)

## Steps executed

1. Switched account Adam Orfei → Hulu via Yash menu → Search Account "Hulu" Results click.
2. Navigated to Brand>Content with Hulu brand_id=5670, channels=instagram, Public, sentiment_mode=false.
3. Clicked Filter dropdown.
4. Verified filter list contents (top-to-bottom): Branded Content / Collaborated / **Collaborated Total** / Collaborator Name / Content Type / Live Stream / Publish Day / Publish Time / Publish Type / Sponsor Name / Tag / Text Search.
5. Clicked "Collaborated Total" → sub-popup opened with checkbox options 1, 2, 3, 4, 5 and Or/And toggle (Or selected by default).
6. Checked option "2" → clicked Apply Filter.
7. Observed chip "Collaborated Total: 2 Include" rendered; URL settled at `filters={"content_collaborator_count":{"operator":"or","values":["2"],"not":"false"}}`.
8. Posts count rendered as `Posts (0)`. Extended date range to full 2025; still 0 posts.
9. Re-applied with value `1` → still 0 posts.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Collaborated Total filter is between Collaborated and Collaborator Name | Confirmed order: Collaborated → Collaborated Total → Collaborator Name (spec typo "Collaborated Name" interpreted as Collaborator Name) | PASS |
| A2 | 4 | Filter options are 1, 2, 3, 4, 5 | All five checkboxes 1-5 visible plus Or/And operator selector. No 6 or higher visible | PASS |
| A3 | 5 | Posts header count is updated | Posts header went from default (e.g. Posts before filter) to `Posts (0)` after Apply — count IS updated | PASS |
| A4 | 5 | Only Collaborated posts displayed in post table | Vacuously satisfied — empty result set (no rows to violate the constraint) | PASS (vacuous) |
| A5 | 6 | Collaborated Total filter count and posts' Collaborated count match | Cannot verify on Hulu IG dataset: zero posts have collaborator_count=1 or =2 in 2025 year window. Need brand+window with non-empty collaborated IG data to verify the cross-check | INCONCLUSIVE |

## Evidence
- Screenshot `ss_9353z7qd0`: filter dropdown showing Collaborated Total in correct ordinal position between Collaborated and Collaborator Name.
- Screenshot `ss_4902jfxed`: Collaborated Total sub-popup with checkboxes 1, 2, 3, 4, 5 and Or/And toggle.
- Screenshot `ss_8543e6ah1`: chip `Collaborated Total: 2 Include` + Posts (0) post-apply.
- URL `filters` JSON encoding: `content_collaborator_count` operator/values/not pattern matches platform-wide content_tags Include/Exclude convention.

## Notes
- Brand URL auto-redirect on Hulu account: spec brand_id=5670 → resolved brand_id=11003 (a Hulu sub-brand on this account). Header shows "Hulu" with green Hulu logo; treating as spec-conformant per existing Brand>Content URL-drift quirk.
- Spec text "Collaborated Name" is a typo for "Collaborator Name" (verified by UI label).
- LFMP-31862 closed bug ("Brand > Content - Table not loading after applying filter (Collaborated Total)"): NOT REPRODUCED — table renders (with empty-state message) cleanly after filter Apply.

## Bugs filed
None.
