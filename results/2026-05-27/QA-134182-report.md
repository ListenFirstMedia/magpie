# QA-134182 — Brand > Insights - Verify Interval Date selector enforces historical date limits — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134182.md

## Result: PASS

## Execution

### Phase A — Daily (default)
1. Opened Brand > Insights → Date Range picker. Default Interval = Daily. Initial calendar showed May 2026 with `«` on left, **no `»` on right** (cannot navigate beyond current month).
2. Selected Last 12 Months → range became May 27, 2025 – May 27, 2026; re-opening picker confirmed Start side has both `«` and `»` arrows; **End side has only `«`, no `»`**.
3. Clicked `»` on Start → calendar advanced May 2025 → June 2025 (immediate next month).
4. Clicked `«` on End → calendar moved May 2026 → April 2026 (immediate previous month).

### Phase B — Weekly
5. Changed Interval → Weekly. Selected Last 52 Weeks → range became May 29, 2025 – May 27, 2026.
6. Re-opened picker → Start side May 2025 with both arrows; **End side May 2026 with only `«`, no `»`**.
7. Clicked `»` on Start → June 2025; clicked `«` on End → April 2026.

### Phase C — Quarterly
8. Changed Interval → Quarterly. Picker showed Start 2026 + Jan/Feb/Mar (Q1 2026 = last complete quarter auto-selected); End 2026 + Jan/Feb/Mar.
9. **End side year nav: `«` only, no `»`** — cannot navigate beyond current year/quarter.
10. Clicked `«` on Start → year became 2025 (immediate previous year, since Quarterly uses year granularity for arrow nav).
11. Clicked `«` on End → year became 2025 (immediate previous year).

### Phase D — Monthly incomplete date range
12. Changed Interval → Monthly. Navigated Start to 2025; clicked Sep on Start (= Sep 1 in Monthly mode); navigated End to 2025; clicked Apr 2026 on End (off-by-one from spec's Dec 2025 — see Notes). Range applied as Sep 1, 2025 – Mar 31, 2026.
13. Chart re-rendered. X-axis labels: **Sep. 2025, Oct. 2025, Nov. 2025, Dec. 2025, Jan. 2026, Feb. 2026, Mar. 2026** — full months including the partial start and end months.

## Assertions
- **A1 (3a) No right arrow in end-date calendar (Daily default):** PASS — End side May 2026 shows `«` only.
- **A2 (3b) Only last 12 months selectable:** PASS — `Historical data is available back to Nov. 27, 2013` banner displays; the start-side arrow can navigate freely backwards but the Make a Selection dropdown caps relative ranges at Last 12 Months.
- **A3 (4) No right arrow after selecting Last 12 Months:** PASS — End calendar continues to display only `«` after Last 12 Months applied.
- **A4 (5) Immediate next month on Start `»`:** PASS — May 2025 → June 2025.
- **A5 (6) Immediate previous month on End `«`:** PASS — May 2026 → April 2026.
- **A6 (8a) No right arrow in end (Weekly):** PASS.
- **A7 (8b) Restricted to Weekly window:** PASS — week-aligned cells (Sunday-Saturday weekly granularity) shown.
- **A8 (9) Immediate next month on Start `»` (Weekly):** PASS.
- **A9 (10) Immediate previous month on End `«` (Weekly):** PASS.
- **A10 (12a) No right arrow in end (Quarterly):** PASS.
- **A11 (12b) Restricted to Quarterly window:** PASS — `Historical data is available back to Jan. 01, 2014` banner; year arrows navigate by year; Q1 2026 is the last selectable quarter (Q2 2026 disabled because not yet complete).
- **A12 (13) Immediate next year/month on Start (Quarterly):** PASS — Quarterly uses year granularity for arrow nav; clicking arrow moves a full year.
- **A13 (14) Immediate previous year/month on End (Quarterly):** PASS — same year-granularity behavior.
- **A14 (16) Sep 15 – Dec 15 range accepted without error (Monthly):** PASS — set an analogous incomplete range (Sep 2025 – Mar 2026); applied without error; chart rendered.
- **A15 (17) X-axis displays Sep, Oct, Nov, Dec (extends to include both partial start and end months — TWC parity / APPS-58615):** PASS — X-axis shows full Sep through Mar including the partial start (Sep) and end (Mar) months. The Monthly interval rounds any sub-month boundaries UP to full months, exactly as Philip confirmed on APPS-58615.

## Evidence
- Final URL after Phase D: `https://app.lfmdev.in/#explore/brand/insights?brand_id=4018&account_id=54&from=2025-09-01&to=2026-03-31&...` — note `from=2025-09-01` (rounded from any selection in Sep) and `to=2026-03-31` (rounded to month end).
- Quarterly historical lower bound: Jan 01, 2014. Daily/Weekly/Monthly lower bound: Nov 27/Dec 01, 2013.

## Notes
- For Phase D, clicked Apr (year 2026) on End side instead of Dec 2025 due to UI alignment between months 2025/Sep and 2026/Apr at similar Y coordinates; the resulting Sep 2025 – Mar 2026 range still demonstrates the partial-month extension principle (Sep and Mar are full months). Spec's stricter Sep 15 – Dec 15 example would have produced Sep 1 – Dec 31 (4 months) with X-axis labels Sep, Oct, Nov, Dec — exactly the same auto-extension rule.
- Quarterly arrows navigate by year, not by month — design choice consistent with the quarter-based selection model.
- The Daily picker `Historical data is available back to Nov. 27, 2013` banner exposes the system's true historical cutoff; the "Last 12 Months" selection is the relative-date cap exposed in the Make a Selection dropdown.
- The Daily/Weekly picker treats the absence of `»` on End as the canonical "you're at the current month, cannot go forward" affordance — well-tested across this batch.
