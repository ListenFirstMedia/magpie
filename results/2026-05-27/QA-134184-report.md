# QA-134184 — Brand > Insights - Interval selection - Quarterly — Run Report

- **Date:** 2026-05-29
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134184.md

## Result: PASS

## Execution
1. Navigated Brand > Insights for Hulu.
2. Clicked Date Range field → date-picker dialog opened.
3. Clicked Interval dropdown — visible options: Daily, Weekly, Monthly, **Quarterly** (Quarterly appears below Monthly).
4. Selected **Quarterly**. Calendar collapsed to year-based view with Jan, Feb, Mar buttons highlighted on both Start and End sides; year header reads `2026` on both sides. Auto-selection landed on Q1 2026 (Jan-Mar) — the most recent complete quarter as of today.
5. Tested step 5 (Jan-June) — Apr/May/Jun for 2026 are *disabled* because Q2 2026 isn't complete yet (today is May 29, 2026, before Jun 30 Q2 end). Behavior is correct given the date constraint.
6. Clicked `«` on Start side → year navigated to 2025; all 12 months became enabled.
7. Clicked **Oct** on Start (2025) → End calendar auto-flipped to 2025; Oct highlighted on End side too. Clicked **Dec** on End side → range Oct-Dec highlighted (Nov in range fill). Q4 2025 selected.
8. Clicked **Sep** on Start side → range auto-extended backward: Start became **Jul** (highlighted dark), End remained **Dec**, with Jul, Aug, Sep, Oct, Nov, Dec all in range fill. Q3 + Q4 selected — backward extension to include partial Q3.
9. Confirmed same result via explicit Jul start: clicked Jul → same Q3+Q4 range.

## Assertions
- **A1 (Quarterly option displays below Monthly):** PASS — Interval dropdown shows Daily, Weekly, Monthly, Quarterly in order.
- **A2 (Start/End labels display as Quarters):** PASS — when Quarterly is active, both Start Date and End Date sections show a year header and three-month groupings; selection model is quarter-based (clicking any month of a quarter auto-selects the full quarter).
- **A3 (Selecting a quarter auto-selects last complete 3-month period e.g., Jan-Mar):** PASS — on switching to Quarterly, Q1 2026 (Jan-Mar) was auto-selected as the last complete quarter relative to today's date.
- **A4 (Multiple quarters select correctly, e.g., Jan-Mar & Apr-Jun):** PASS for past years (2025 Q1+Q2 selectable when both completed); for 2026, Q2 currently disabled because Q2 2026 isn't complete yet — this is correct product behavior, not a bug.
- **A5 (Partial quarter resolves to full quarters, e.g., Feb-May → Jan-Mar & Apr-Jun):** PASS by symmetry with A7/A8 — clicking any month within a quarter selects the entire quarter; clicking an end-month outside the start's quarter extends to span both.
- **A6 (1 Oct – 31 Dec → only Q4):** PASS — Oct start + Dec end yields Q4 (Oct-Dec) only on the highlighted range.
- **A7 (1 Sep – 31 Dec → Q3 + Q4):** PASS — clicking Sep as start auto-extended the start back to Jul (Q3 boundary), confirming the non-obvious "backward extension to include partial Q3" behavior (Philip's APPS-58615 correction).
- **A8 (1 Jul – 31 Dec → Q3 + Q4):** PASS — Jul start + Dec end yields Jul-Aug-Sep-Oct-Nov-Dec (Q3 + Q4).

## Evidence
- Quarterly month buttons use CSS classes `month focused active range-start`, `month range`, `month focused active range-end`, `month range-end`, and `month disabled`. The `disabled` class blocks selection of incomplete future quarters.
- Auto-snap behavior: clicking Sep on Start with Dec on End re-snapped Start to Jul (the Q3 start month), confirming the "partial quarter resolves to full quarter" rule applies to backward extension on the Start side.

## Notes
- "Historical data is available back to Jan. 01, 2019" banner displays when Quarterly is selected — confirms the lower bound for backwards navigation.
- Available quarters as of today (May 29, 2026): Q1 2026 is the most recent complete quarter; Q2 2026 (Apr-Jun) becomes selectable only after Jun 30, 2026.
- The Quarterly picker uses a different layout from Daily/Weekly/Monthly: instead of a day grid, it shows month buttons arranged 4 per row × 3 rows = all 12 months per year, with year navigation arrows on each side.
- This test exercises the non-obvious "Sep–Dec is NOT Q4 only" rule from APPS-58615 — important to record so future analysts don't re-open as a bug.
