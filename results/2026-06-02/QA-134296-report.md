# QA-134296 — Brandsets → Rankings - Data Last Updated: Timestamp

- **Date:** 2026-06-04 (QA-4325 batch 11)
- **Account:** Adam Orfei (account_id=54)
- **Brand Sets:** Adam's Brand Set (brand_set_id=1738), 1923 Talent (brand_set_id=11190)
- **Source spec:** Atlassian QA-134296 (verifies `Data Last Updated` timestamp remains consistently visible and correctly formatted across Brandsets modules, even after page refreshes and brand selection changes)
- **Skill:** none dedicated

## Result: PASS

`Data Last Updated` timestamp renders with identical format and identical value across Brand Sets sub-tabs, persists through F5 page-refresh, and persists across brand-set switches.

## Execution

1. Navigate to `#explore/competitive/rankings?brand_set_id=1738&account_id=54` (Adam's Brand Set).
2. Read top-right `Data Last Updated (PT): …` via zoomed screenshot.
3. Navigate to `#explore/competitive/content?brand_set_id=1738&account_id=54` — re-read header.
4. Press F5 on Brand Sets > Content; re-read header after reload.
5. Switch brand set to `brand_set_id=11190` (1923 Talent) on Rankings; re-read header.

## Assertions

| ID | Surface | Expected | Actual | Status |
|----|---------|----------|--------|--------|
| A1 | Brand Sets > Rankings (Adam's Brand Set) | `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT` | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A2 | Brand Sets > Content (Adam's Brand Set) | Same value, same format | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A3 | Brand Sets > Content after F5 refresh | Persists | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A4 | Brand Sets > Rankings (different brand set: 1923 Talent) | Same value (timestamp is account-wide, not brand-set-specific) | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A5 | Format conformance | `MM-DD-YYYY HH:MM AM/PM PT` after `(PT):` | Matches regex `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM|PM) PT` | PASS |
| A6 | Cross-app parity with Brand surfaces (QA-134271) | Same value as Brand surfaces | Brand Sets timestamp identical to Brand surfaces (`06-04-2026 05:06 AM PT`) | PASS |

## Evidence

- Header text captured via zoom on the upper-right region of each page:
  ```
  Data Last Updated (PT): 06-04-2026 05:06 AM PT
  ```
- Identical across all 4 capture points (Rankings AdamsBrandSet, Content AdamsBrandSet, Content post-F5, Rankings 1923 Talent).
- Cross-app: identical to the QA-134271 values observed on Brand>Insights / Audience / Content / Channels / Stories / Optimization (same session).

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134296) | — | bug-history shows no defects |

## New findings

None — Brand Sets timestamp behavior is identical to Brand surface behavior. Account-wide ETL freshness signal.

## Files

- `runs/2026-06-02/QA-134296-report.md` (this report)
