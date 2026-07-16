# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Major (P3)
- **Account/Brand:** Adam Orfei (account_id=54) · Insights Date Range picker. (Sephora brand_id=29 kept redirecting to Home; used **MTV** (4018) — the auto-select date presets are brand-independent.)

## Verdict: PASS

## Known bugs checked
No open linked bug.

## Note on time-shift
Spec dates were authored ~March 2026; run day is **2026-07-10** (Q3 2026 in progress). Per the case note, presets shift forward: latest complete quarter = **Q2 2026**, latest complete month = **June 2026**. Verified against the shifted expectation.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (3a) | Default Interval = Daily | Interval shows **Daily** | PASS |
| A2 (3b) | Default Make a Selection = Auto | shows **Auto** | PASS |
| A3 (4) | Intervals = Daily, Weekly, Monthly, Quarterly | dropdown = **Daily, Weekly, Monthly, Quarterly** | PASS |
| A4 (5) | Daily auto-select options | Auto / --- / Last 7 Days, Last 30 Days, Last 90 Days, Last 6 Months, Last 12 Months / --- / Prior Year, Month to Date, Year to Date / --- / **Q2 2026**, Q1 2026, Q4 2025 … / --- / **June 2026**, May 2026, … (with `---` separators) | PASS (time-shifted) |
| A5 (7) | Weekly auto-select options | **Auto, ---, Last Week, Last 4 Weeks, Last 12 Weeks, Last 36 Weeks, Last 52 Weeks** (exact) | PASS |
| A6 (9) | Monthly auto-select options | Auto / --- / Last Month, Last 3 Months, Last 6 Months, Last 12 Months / --- / Q2 2026, Q1 2026 … / --- / June 2026, May 2026 … | PASS (time-shifted) |
| A7 (11) | Quarterly auto-select options | **Auto, ---, Q2 2026, Q1 2026, Q4 2025, …** (quarters only — no Last/month presets) | PASS |

## Method notes
- Date Range button → picker with **Make a Selection** (Auto) + **Interval** (Daily) custom dropdowns. Both are `.selector`/`.lfm-dropdown-option` custom dropdowns needing a trusted click; the two dropdowns overlap spatially, so close one (click "Start Date") before opening the other to avoid pointer-interception.

## Evidence
- `QA-134176-datepicker.png` (Interval=Daily, Make a Selection=Auto), `QA-134176-interval.png` (Daily auto-select list w/ separators)

## Bugs filed
None.
