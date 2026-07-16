# QA-94977 — Brand > Audience - LinkedIn - Metric Export Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** UCLA (account_id=799) · University of California, Los Angeles (brand_id=127756) · LinkedIn channel · Jul 2–8, 2026

## Verdict: PASS (A5 reproduces known open bug — does not block the feature under test)

## Known bugs checked — tolerated (probe only)
- **APPS-58574** (Open / In Progress) — LinkedIn Audience cards misaligned. This is a **cosmetic layout** issue and does **not** interfere with the metric-export functionality that is the subject of this test (A1–A4). Per the refined open-bug rule → run + note. It is separately re-measured as the A5 probe (see below).

## Setup note
MTV (account 54) has **no** LinkedIn follower-demographic data (all tiles "no data"), so the data-bearing export was run on **UCLA** (account 799, LinkedIn-active) per the case's brand guidance. UCLA's Audience view hydrated correctly with a current date range (Jul 2–8, 2026).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Brand > Audience LinkedIn page loads with tiles | UCLA LinkedIn Audience loaded: Followers by Job Function / Industry / Seniority / Staff Count Range / Country / Region / Geo Breakdown — populated | PASS |
| A2 | Per-tile Export menu lists Metrics / CSV / GSheets | menu lists **PNG, CSV, Google Sheets, Metrics** | PASS |
| A3 | CSV export produces a saved file, reasonable filename | `University of California, Los Angeles-Audience-Followers Job Function-2026-07-02-2026-07-08.csv` downloaded | PASS |
| A4 | Saved file is a real CSV (header + data) | header `Date, Brand Name, Channel, Business Development Share, …` + data row `2026-07-08, University of California, Los Angeles, LinkedIn, 13.21%, 11.23%, 8.22%, 7.16%, …` — matches on-screen (Business Development 13%, Education 11%, Engineering 8%, Healthcare Services 7%) | PASS |
| A5 (probe) | APPS-58574 card alignment — reproduce or refute | **REPRODUCED** (see measurement) | Known open bug (noted) |

## A5 measurement (APPS-58574)
DOM geometry of the demographic tiles (all width 269px): "Followers: Job Function" sits **alone on its row**, while "Followers: Industry" (left 33), "Followers: Seniority" (left 348) and "Followers: Staff Count Range" (left 663) share the **next** row (top 361). That is the "1 card on the first row, 3 on the second row" pattern APPS-58574 reports (expected: 4 aligned on the first row). Consistent with the open bug → **REPRODUCED**.

## Evidence
- `.playwright-out/University-of-California-Los-Angeles-Audience-Followers-Job-Function-2026-07-02-2026-07-08.csv` (944 bytes; header + 1 data row)
- `QA-94977-ucla-linkedin.png`, `QA-94977-mtv-linkedin-audience.png` (MTV = no LinkedIn data)

## Bugs filed
None new — A5 covered by existing **APPS-58574**.

## View state note
Account left on UCLA (799); switch back to Adam Orfei (54) for subsequent cases (navigate to a `?account_id=54` URL).
