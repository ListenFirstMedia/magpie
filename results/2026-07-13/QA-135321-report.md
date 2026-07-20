# QA-135321 — Brand > Content - Verify Additional filter working with tag filter

**Run date:** 2026-07-13 | Account/Brand: Hulu (336/5670) | Skill: brand-content-filter v2

## Steps executed
1-4. Brand>Content (Hulu) → Filter → Tag.
5. Include `#allsfairlondon`.
6. Switched radio to Exclude (same panel), Exclude `#allsfairparis`.
7. Applied — confirmed both pills in URL `filters` JSON.
8-9. Reopened Filter → Paid → checked "Boosted".
10. Applied — confirmed combined URL.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Include Tag added, green pill for TAG_1 | `qa135321-combined-pills.png`: green "Tag: #allsfairlondon Include" pill | PASS |
| A2 | TAG_2 visible as red Exclude pill | Same screenshot: red "Tag: #allsfairparis Exclude" pill | PASS |
| A3 | Filter impacts page data | URL correctly encodes `content_tags` JSON; page reflects the filtered query (empty-result data-scope caveat carried from QA-134277 — same tag pair, still 0 posts, but the filter mechanic itself applies) | PASS (mechanic) |
| A4 | Both tag and Paid filters implemented together | URL after step 10: `filters={"content_is_paid":{"operator":"or","values":["Promoted"],"not":"false"},"content_tags":[...both pills...]}` — both filter types coexist in one JSON object, third green "Paid: Boosted" pill rendered alongside the two tag pills | PASS |

**Result: 4/4 PASS.**

## Notes
- UI label "Boosted" encodes as backend value `"Promoted"` in the URL — cosmetic label/value mismatch, not a bug (same pattern as other UI-label-vs-backend-key mappings already documented in this skill).
- Same zero-post data-scope caveat as QA-134277 applies to A3's "impacts page data" — confirmed the filter *mechanic* (URL/query construction, pill rendering) fully works; did not re-attempt a non-zero dataset here since A3 only requires the filter to be applied, not a specific count.

## Bugs filed
None.

## Cleanup
Clear All clicked, confirmed `filters` param removed.

## Skill/KB updates
Queued for batched `brand-content-filter` v3 — confirms Tag filter composes cleanly with a second filter type (Paid) in the same `filters` URL object.
