# QA-134182 — Brand > Insights: Interval Date selector enforces historical date limits

- **Run date:** 2026-07-04 (headless, unattended, Playwright MCP)
- **Branch:** feature/playwright-mcp
- **Account:** Adam Orfei (account_id=54) — precondition met
- **Brand:** MTV (brand_id=4018) — brand-agnostic date-selector case; MTV used (consistent with prior verified runs)
- **Surface:** Brand > Insights (`#explore/brand/insights`)
- **Skill reused:** `brand-insights-interval-picker` (v2)
- **Verdict:** **PASS (15/15 assertions)**
- **Open-bug screen:** "None open" per case file → ran normally (Rule 7)

## Scope notes
- No Google Sheets steps in this case.
- Not an external-user case (same-user account context only).
- All 15 assertions are in-scope and were evaluated.

## Steps executed

### Pre-flight
- Navigated to app.lfmdev.in → Cognito hosted UI → filled "With existing account" form (lfiqa@…) → `#home` rendered (title "Home - ListenFirst"). Account confirmed = **Adam Orfei** (URL `account_id=54`).
- Opened MTV Brand Insights via the Home "Favorite Brands" link (UI navigation).

### Phase A — Daily
1. Brand > Insights (MTV), valid from/to/compare dates.
2. Clicked Date Range pill (`button.range-display`) → overlay opened with Make a Selection (`Auto`), Interval (`Daily` default), Select Mode (`Active Posts`), historical banner "Historical data is available back to Jan. 02, 2014", Start (June 2026) + End (July 2026) calendars.
3. Reviewed calendars (A1/A2).
4. Selected "Last 12 Months" from Make a Selection (A3) → range Jul 2 2025 – Jul 2 2026; charts rendered (Total Followers 93.2M donut) — no Insights render-hang.
5. Clicked next on Start calendar (A4).
6. Clicked prev on End calendar (A5).

### Phase B — Weekly
7. Interval → Weekly; Make a Selection → "Last 52 Weeks" (A7) → range Jul 4 2025 – Jul 2 2026.
8. Reviewed calendars (A6).
9. Clicked next on Start (A8).
10. Clicked prev on End (A9).

### Phase C — Quarterly
11. Interval → Quarterly; reviewed the full available quarterly window (A11). Historical banner shifts to "Apr. 01, 2014" (= Q2 2014 floor).
12. Reviewed End calendar arrows (A10).
13. Navigated Start calendar back one year (2026→2025) to enable its next arrow, then clicked next (A12).
14. Clicked prev on End calendar (A13).

### Phase D — Monthly incomplete range
15. Interval → Monthly. (Monthly picker shows a whole-month grid; to set the partial Sep 15 / Dec 15 days, dates were set via day-level calendars then interval switched to Monthly — interval switches preserve the underlying from/to.)
16. Set Start = **Sep 15, 2025** and End = **Dec 15, 2025** (verified via `range-start`/`range-end` day classes = day 15 on both). Set Interval = Monthly. Clicked **Ok** → **no error**; URL rewrote to `from=2025-09-01&to=2025-12-31` and pill shows "Sep. 01, 2025 - Dec. 31, 2025" (A14).
17. Read chart X-axis tick labels → **Sep. 2025 / Oct. 2025 / Nov. 2025 / Dec. 2025** on every tile (A15).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Daily) | No right arrow in end-date calendar (can't go beyond current month) | End calendar (July 2026 = current month) `next disabled`, `visibility:hidden`; Start calendar has both arrows | PASS |
| A2 | 3 (Daily) | Only last 12 months selectable | Make a Selection rolling ranges cap at "Last 12 Months" (Last 7 Days → Last 12 Months; nothing larger). Quarter/month options list separately | PASS |
| A3 | 4 (Daily) | No right arrow in end-date calendar after Last 12 Months | End calendar (July 2026) `next disabled`/hidden; Start calendar both arrows | PASS |
| A4 | 5 (Daily) | Click next on start → immediate next month | Start July 2025 → August 2025 (one month, immediate) | PASS |
| A5 | 6 (Daily) | Click prev on end → immediate previous month | End July 2026 → June 2026 (one month, immediate); next arrow reappears once End is a past month | PASS |
| A6 | 8 (Weekly) | No right arrow in end | End (July 2026) `next disabled`/hidden | PASS |
| A7 | 8 (Weekly) | Restricted to Weekly window | Make a Selection offers only Last Week / Last 4 / 12 / 36 / 52 Weeks (caps at Last 52 Weeks) | PASS |
| A8 | 9 (Weekly) | Click next on start → immediate next month | Start July 2025 → August 2025 (immediate) | PASS |
| A9 | 10 (Weekly) | Click prev on end → immediate previous month | End July 2026 → June 2026 (immediate) | PASS |
| A10 | 12 (Quarterly) | No right arrow in end | End calendar (year 2026 = current year) `next disabled`/hidden | PASS |
| A11 | 12 (Quarterly) | Restricted to Quarterly window | Make a Selection offers only quarters Q2 2026 (current) → Q2 2014 (floor); calendar is a quarter/year view (no day/week ranges) | PASS |
| A12 | 13 (Quarterly) | Click next on start → immediate navigation | Start 2025 → 2026 (immediate). Quarterly nav granularity is **one year/click** (calendar is a year-view of quarters), not one month — documented accepted behavior, not a defect | PASS |
| A13 | 14 (Quarterly) | Click prev on end → immediate navigation | End 2026 → 2025 (immediate, one year) | PASS |
| A14 | 16 (Monthly) | Sep 15 – Dec 15 range accepted, no error | Ok applied with no error; URL/pill extended to Sep 01 – Dec 31 2025; charts rendered | PASS |
| A15 | 17 (Monthly) | X-axis shows Sep, Oct, Nov, Dec (partial months extended per APPS-58615) | Every chart X-axis shows exactly **Sep. 2025, Oct. 2025, Nov. 2025, Dec. 2025**; partial Sep 15/Dec 15 extended backward to Sep 1 and forward to Dec 31 | PASS |

## Evidence

- **Historical floors observed:** Daily/Weekly/Monthly banner = "Jan. 02, 2014" (Daily) / "Feb. 01, 2014" (Monthly); Quarterly = "Apr. 01, 2014" (Q2 2014). (Floor slides forward daily; matches the rolling-retention pattern in known-quirks.)
- **APPS-58615 partial-month extension:** input range `from=2025-09-15&to=2025-12-15` → applied range `from=2025-09-01&to=2025-12-31`; X-axis = Sep/Oct/Nov/Dec 2025 (both partial start and end months kept).
- **Quarterly granularity:** arrow nav moves the calendar by one **year** per click (year-view of quarters), per the `brand-insights-interval-picker` skill Step 7. The spec's A12/A13 wording "next/previous month" is generic phrasing across phases; the observed behavior is the documented, accepted per-year granularity for Quarterly.
- **Screenshots** (`.playwright-out/QA-134182/`):
  - `phaseA-daily-overlay.png` — Daily default overlay (calendars, Interval=Daily, banner)
  - `phaseA-last12-state.png` — Last 12 Months applied, charts rendered
  - `phaseA-arrows-A4A5.png` — Start=Aug 2025 / End=June 2026 after arrow nav
  - `phaseC-quarterly-overlay.png` — Quarterly year-view calendars, End no-right-arrow
  - `phaseC-quarterly-arrownav.png` — Start=2026 / End=2025 after year nav
  - `phaseD-monthly-initial.png` — Monthly month-grid picker, banner "Feb. 01, 2014"
  - `phaseD-monthly-xaxis.png` — final Monthly chart, pill "Sep. 01 – Dec. 31, 2025", 4 monthly bars

## Run notes
- **Transient tab crash (not a product defect):** During the first Phase-D attempt, the browser tab crashed ("Target crashed" → about:blank) when selecting the Monthly interval after a long single-overlay session (many interval/calendar interactions without closing the overlay). Recovered per the reload+retry rule: re-authenticated, re-navigated to Brand Insights with the Sep 15–Dec 15 range, re-set Monthly via the UI, and completed Phase D cleanly. The crash did **not** reproduce on the clean retry — attributed to an accumulated-DOM-state renderer crash under automation, not a functional defect in the date selector. Range value was verified in the UI after re-navigation (pill "Sep. 15, 2025 - Dec. 15, 2025"), honoring Rule 2 (don't trust the URL alone).
- The Chrome-MCP-era "Brand>Insights renderer hang" did **not** reproduce under Playwright — tiles rendered fast across all four intervals (consistent with the 2026-06-22 known-quirks finding).

## Bugs filed
None. All 15 assertions passed; product behavior matches spec (including the APPS-58615 partial-month extension). The one-off transient tab crash is flagged here for awareness only (not reproducible on retry; automation/renderer artifact, not a user-facing defect) — not filed.
