# QA-92735 — Brand > Audience - LinkedIn - Basic View (re-run 2026-06-02 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-92735
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only
- **Date range:** Jan 01 – Dec 31 2025

## Result: PASS (with reproduced layout bug)

## Steps executed

1. Switched account Adam Orfei → UCLA via user dropdown account search.
2. Brand → Audience auto-loaded "University of California, Los Angeles" brand (default LinkedIn audience surface).
3. URL set `channels=linkedin` only. Channels row visible: Facebook | X | Instagram | YouTube | LinkedIn (blue) | Threads. (No TikTok/Pinterest for this brand.)
4. Page loaded with default Authorized perspective toggle.
5. Inspected first row of audience cards. Used DOM analysis to verify tile positions.
6. Compared first row layout (Followers: Job Function) vs. second row layout (Industry, Seniority, Staff Count Range).

## Bug reproduction outcomes

### APPS-58574 (Bug, Trivial, In Progress) — Brand Audience LinkedIn cards misaligned, first row separated into two lines (UCLA brand)
**Verdict: REPRODUCED**

DOM-measured tile positions on UCLA LinkedIn Audience:

| Tile | top | left | width | col class |
|------|-----|------|-------|-----------|
| Followers: Job Function | 101 | 10 | 295 | lfm-col-3 |
| Followers: Industry | 500 | 20 | 295 | lfm-col-3 |
| Followers: Seniority | 500 | 335 | 295 | lfm-col-3 |
| Followers: Staff Count Range | 500 | 650 | 295 | lfm-col-3 |

The first `lfm-col-3` card (Followers: Job Function) sits alone on row 1 (top=101) at left=10, while the other three `lfm-col-3` cards sit together on row 2 (top=500) at left=20, 335, 650. All four are the same width (295) and same `lfm-col-3` grid class.

Expected: 4 × `lfm-col-3` = 4 × 295 = 1180 px which fits in the 1240 px container. They should all sit on a single row.

Observed: Row 1 has only 1 card with leftmost offset of 10 (vs. 20 on row 2). The card got pushed to its own row.

This is the exact APPS-58574 misalignment.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | LinkedIn Audience page loads with cards rendered | All 9 tiles rendered (Job Function, Industry, Seniority, Staff Count Range, Followers By Country, Followers By Region, Followers: Geo Breakdown By Country, Followers: Geo Breakdown By Region + toolbar) | PASS |
| A2 (probe) | 5 | First-row cards align on a single line | First row has only Job Function; other 3 col-3 cards pushed to row 2 | FAIL (APPS-58574 REPRODUCED) |
| A3 | — | Tile titles + counts correct | Job Function tile shows Business Development 13%, Education 11%, Engineering 8%, Healthcare Services 7%, Operations 7%, Research 6% — populated correctly | PASS |
| A4 | — | Layout visually correct (no overlap/truncation) | No overlap or truncation observed beyond the row-1 misalignment | PASS |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92735-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-92735.md` (proxy spec)

## Notes
- Tested on UCLA (account_id=799) since Adam Orfei dev doesn't have brands with LinkedIn data — the spec brand (UCLA) is available only under the UCLA account. Switched accounts per Rule 1's "wrong account" exception.
- Same misalignment likely affects QA-94977, QA-94978, QA-95067 (sibling LinkedIn audience tests in the same QA-4325 set).
- "Trivial" priority in Jira is appropriate — functionally everything works; only first-row visual alignment is off.
