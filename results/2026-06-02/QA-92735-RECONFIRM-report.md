# QA-92735 — Brand > Audience - LinkedIn - Basic View (RE-CONFIRM 2026-06-04 batch-6)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-92735
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only
- **Date range:** Jan 01 – Dec 31 2025
- **Perspective:** Authorized Data (right toggle — verified visually)

## Result: PASS (with APPS-58574 RE-REPRODUCED — matches batch-1 finding identically)

## Steps executed
1. Switched account Adam Orfei → UCLA via user dropdown account search ("UCLA" typed → Results section → "UCLA" clicked, NOT from Recent Searches).
2. Brand → Audience navigated via direct URL nav `?brand_id=127756&account_id=799&channels=linkedin&from=2025-01-01&to=2025-12-31`.
3. Page loaded with default Authorized perspective toggle (View toggle in right position).
4. DOM probe (`getBoundingClientRect()`) on the four `lfm-col-3` tiles in the first audience row.

## DOM evidence (re-confirm)

| Tile | top | left | width | grid class |
|---|---|---|---|---|
| Followers: Job Function | 327 | 187 | 295 | lfm-col-3 |
| Followers: Industry | 726 | 197 | 295 | lfm-col-3 |
| Followers: Seniority | 726 | 512 | 295 | lfm-col-3 |
| Followers: Staff Count Range | 726 | 827 | 295 | lfm-col-3 |

`top=327` (row 1) vs `top=726` (row 2) — gap of 399 px — confirms Job Function alone on row 1, the other three on row 2 below. Same pattern observed in batch-1 (`top=101 / top=500` set), absolute Y shifted due to different viewport scroll baseline but the topology (1+3 split across two rows) is identical.

Four lfm-col-3 = 4 × 295 = 1180 px which fits in the container width; they should align on a single row.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | LinkedIn Audience page loads with cards rendered | All audience tiles rendered (Job Function with Business Development 13%, Education 11%, etc. + Industry/Seniority/Staff Count Range/Followers By Country/Region tiles below) | PASS |
| A2 (probe) | 5 | First-row cards align on a single line | First row has only Job Function; other 3 col-3 cards pushed to row 2 | FAIL (APPS-58574 RE-REPRODUCED) |
| A3 | — | Tile titles + counts correct | Job Function tile populated correctly with same percentages as batch-1 | PASS |
| A4 | — | Layout visually correct (no overlap/truncation) | No overlap or truncation beyond the row-1 misalignment | PASS |

## Bug verdict
**APPS-58574 (Trivial, In Progress) — RE-REPRODUCED 2026-06-04 batch 6.** Layout drift unchanged from batch-1 (2026-06-02). Ticket still open; misalignment persists on UCLA Brand>Audience LinkedIn.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92735-RECONFIRM-report.md`

## Notes
- Account switch executed via user dropdown → typed `UCLA` → clicked `UCLA` from Results section (NOT Recent Searches) — `switch-account` skill v2 pattern.
- Same misalignment will be re-checked in the QA-94977 sibling run on the same page.
