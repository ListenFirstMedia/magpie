# QA-114840 — Settings > User - Export Functionality (External User)

- **Source:** Priority: Minor
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** External User (testing@drylogics.com) — Adam Orfei (account_id=54)

## Steps executed

1. (Continuing the external-user session from QA-113594) Settings (top nav, hover) → Users.
2. Clicked Export dropdown → CSV.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Export button present to left side of "Add a New User" button | Confirmed — Export button renders immediately left of "Add a New User" in the toolbar | PASS |
| A2 | 2 | Popup opens with options CSV and Google Sheets | Confirmed — dropdown shows exactly `CSV`, `Google Sheets` | PASS |
| A3 | 2 | Filename = `Account-Users-MM-DD-YYYY.csv` | Downloaded `Adam Orfei-Users-07-15-2026.csv` — matches pattern with Account substituted as "Adam Orfei" | PASS |
| A4 | 2 | Columns: First Name, Last Name, Email, Phone, Job Title, Last Active | CSV header row exactly `First Name,Last Name,Email,Phone,Job Title,Last Active` | PASS |
| A5 | 2 | No duplicate columns | Confirmed — 6 unique columns, no repeats | PASS |

## CSV sample (first 4 rows)

```
"First Name","Last Name","Email","Phone","Job Title","Last Active"
"testing","account","testing@drylogics.com","","","4 minutes"
"Ritik","Agarwal","ritik@listenfirstmedia.com","","","a month"
"Aman","Aswani","aman.a@listenfirstmedia.com","","","5 days"
```

Rule 6 satisfied via native Playwright `download` event — file verified on disk.

## Status: **PASS** (5/5 assertions)

## Cleanup
Non-mutating test — no cleanup required.
