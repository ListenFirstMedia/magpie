# QA-94978 — Brand Audience - LinkedIn Channel - PNG Export Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** UCLA (account_id=799) · University of California, Los Angeles (brand_id=127756) · LinkedIn channel · Jul 2–8, 2026

## Verdict: PASS

## Known bugs checked
No open linked bug on this case. (APPS-58574 card-misalignment is a sibling probe from QA-94977 — cosmetic, does not block PNG export.)

## Setup note
Ran on **UCLA** (LinkedIn-active with data); MTV has no LinkedIn follower data. Same view used for the CSV sibling QA-94977.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Per-tile Export dropdown exposes PNG | export menu = PNG, CSV, Google Sheets, Metrics | PASS |
| A2 | PNG downloads to disk | `University of California, Los Angeles-Audience-Followers Job Function-2026-07-02-2026-07-08.png` (182,763 bytes) | PASS |
| A3 | Filename `<Brand>-Audience-<tile>-<start>-<end>.png` | matches exactly | PASS |
| A4 | PNG content matches the visible tile | PNG shows LISTENFIRST header, "University of California, Los Angeles", "Followers: Job Function", Job Function/Share table (Business Development 13%, Education 11%, Engineering 8%, … Purchasing 0.30%) matching on-screen + the QA-94977 CSV; footer "Brand Audience — Date: Jul. 02, 2026 - Jul. 08, 2026" | PASS |
| A5 | APPS-58574 layout may be observed, doesn't block PNG | not blocking (export succeeded); misalignment reproduced separately in QA-94977 | PASS (noted) |

## Evidence
- `.playwright-out/University-of-California-Los-Angeles-Audience-Followers-Job-Function-2026-07-02-2026-07-08.png`

## Bugs filed
None.

## View state note
Account left on UCLA (799); switch back to Adam Orfei (54) for subsequent cases.
