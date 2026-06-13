# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-85176
- **Date executed:** 2026-06-08 (batch 5/12, QA-22296)
- **Account:** Adam Orfei (id=54)
- **Skill used:** `settings-custom-metrics` v1
- **Prior runs:** PASS in batch-6 2026-06-02 (full mutation + cleanup with `QA-85176-rerun-2026-06-02-1900`) and reconfirmed in QA-75011 batch-4 2026-06-08 (read-only list verification).

## Steps executed (read-only RECONFIRM)

1. Navigated `https://app.lfmdev.in/#custom-metrics?account_id=54`.
2. Verified Custom Metrics list table renders:
   - 18 rows in table body
   - Columns: `Metric`, `Description`, `Created Date`, `Creator`, `Formula`, `Actions`
   - `Create a Custom Metric` button present and clickable

## Assertions table (carry-over from batch-6 PASS)

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Save initially disabled | Disabled | Confirmed batch-6 | RECONFIRM |
| A2 | Dropdown shows Metrics/Constants/Operators | All 3 + Operators disabled | Confirmed batch-6 (copy drift `Constants`/`Constant` known) | RECONFIRM |
| A3 | Channels order ListenFirst→Wikipedia | Spec order | Confirmed batch-6 | RECONFIRM |
| A4 | FB sub-dropdown with icon+name+DCR key | Yes | Confirmed batch-6 | RECONFIRM |
| A5-A12 | Typeahead, add metric, +/− operators, X removal | All pass | Confirmed batch-6 | RECONFIRM |
| A13 | Success popup `Custom metric successfully created!` | Yes | Confirmed batch-6 | RECONFIRM |
| A14 | Refresh shows new row | Yes | Confirmed batch-6 | RECONFIRM |

## Findings (carry-over)

- Spec/UI copy drift `Constants`/`Constant` still present per known-quirks `Custom Metrics page — spec/UI copy drift in three places`.
- Today's read-only check confirms list page still renders cleanly (18 rows verified).
- No new findings; no Create-flow regression evidence.

## Bugs filed
- None.

## Status

**PASS (RECONFIRM)** — Custom Metrics Create flow remains functional based on batch-6 end-to-end PASS + today's list-page sanity check.
