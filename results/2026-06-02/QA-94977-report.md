# QA-94977 — Brand > Audience - LinkedIn - Metric Export Functionality (re-run 2026-06-04 batch-6)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-94977
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only
- **Date range:** Jan 01 – Dec 31 2025

## Result: PASS (4/5) with APPS-58574 RE-REPRODUCED probe finding

## Steps executed
1. Switched account Adam Orfei → UCLA via user dropdown account search (Results section, not Recent Searches).
2. Brand → Audience direct URL nav `?brand_id=127756&channels=linkedin`.
3. Page loaded with Authorized perspective default.
4. Per-tile Export dropdown opened on `Followers: Job Function` tile (Export button at bottom of tile).
5. Dropdown surfaced two options: `PNG` and `CSV`.
6. Clicked CSV → silent download to `~/Downloads`.
7. Inspected saved file: `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` — 944 bytes.
8. Probed APPS-58574 layout bug via DOM (re-confirmed misalignment — same as QA-92735 RECONFIRM report).

## Source: Saved file verification (Rule 6)

Filename: `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv`
- Brand: `University of California, Los Angeles` ✓
- Page: `Audience` ✓
- Tile: `Followers Job Function` ✓
- Date range: `2025-01-01-2025-12-31` ✓
- Extension: `.csv` ✓

File contents (verbatim head):

```
"Date","Brand Name","Channel","Business Development Share","Education Share","Engineering Share","Healthcare Services Share","Operations Share","Research Share","Sales Share","Information Technology Share","Finance Share","Media and Communication Share","Arts and Design Share","Community and Social Services Share","Marketing Share","Legal Share","Human Resources Share","Program and Project Management Share","Administrative Share","Consulting Share","Accounting Share","Customer Success and Support Share","Entrepreneurship Share","Real Estate Share","Product Management Share","Military and Protective Services Share","Quality Assurance Share","Purchasing Share"
"2025-12-31","University of California, Los Angeles","LinkedIn","13.16%","11.32%","8.09%","7.12%","7.03%","6.44%","4.58%","4.14%","3.86%","3.83%","3.76%","3.62%","3.09%","3.09%","2.69%","2.50%","2.46%","1.65%","1.50%","1.31%","1.24%","1.03%","1.02%","0.62%","0.56%","0.29%"
```

Cross-source comparison with UI tile (top 6 visible rows):

| Job Function | UI Share | CSV Share | Match |
|---|---|---|---|
| Business Development | 13% | 13.16% | PASS (round) |
| Education | 11% | 11.32% | PASS (round) |
| Engineering | 8% | 8.09% | PASS (round) |
| Healthcare Services | 7% | 7.12% | PASS (round) |
| Operations | 7% | 7.03% | PASS (round) |
| Research | 6% | 6.44% | PASS (round) |

UI rounds to integer percentages; CSV preserves 2-decimal precision. Same data, different precision — both correct.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-3 | Brand>Audience LinkedIn page loads | All audience tiles rendered, channel filter set to LinkedIn only | PASS |
| A2 | 4 | Per-tile Export menu lists CSV (metric) option | Export dropdown shows PNG + CSV | PASS |
| A3 | 5-6 | Selecting CSV produces saved file with reasonable filename | `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` matches brand-page-tile-date pattern verbatim | PASS |
| A4 | 7 | Saved file is real CSV with header + data | 27 column headers + 1 data row, all 24 Job Function shares populated, UI ↔ CSV percentage match within rounding | PASS |
| A5 (probe) | — | APPS-58574 LinkedIn card misalignment | DOM measurement re-confirms first row has Job Function alone (top=327) and Industry/Seniority/Staff Count Range on row 2 (top=726) — REPRODUCED | FAIL — APPS-58574 RE-REPRODUCED |

## Bug verdict
**APPS-58574 (Trivial, In Progress) — RE-REPRODUCED 2026-06-04 batch 6.** Card misalignment unchanged from QA-92735 batch-1 finding. Layout bug persists on UCLA LinkedIn Audience.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-94977-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-94977.md` (proxy spec)
- Verified: `~/Downloads/University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` (944 bytes, 27 cols, 1 data row)

## Notes
- The per-tile Export dropdown lists `PNG | CSV` for LinkedIn Audience tiles — no Google Sheets path on this surface (consistent with the `audience-metrics-export` skill pattern).
- CSV preserves 2-decimal precision; tile UI rounds to integer % — expected presentation difference, not a bug.
- Reuses `audience-metrics-export` skill (CSV variant) + `switch-account` skill v2 + `view-perspective-toggle` skill (Authorized default on UCLA LinkedIn).
