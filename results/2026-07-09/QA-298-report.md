# QA-298 — Reporting - TWC Graphs - Hovering Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Hulu (account_id=336)
- **Perspective:** Public Data (default; spec doesn't specify)
- **Story:** https://app-reporting.lfmdev.in/#story/time_window_comparison/155797

## Verdict: PASS

## Known bugs checked
Jira issue-links reviewed: APPS-5243, APPS-12284, APPS-14801, LFMP-24679/24710, APPS-27326/27018/27528/28318, LFMP-26247, APPS-31860/35116/35923/37192/37148/43922/49242/53697/53474, LFMP-30688 — **all Closed/Done**. No open linked bug → not auto-failed. bug-history.md note confirms the chart is a **line chart** (Recharts), not the "bar chart column" of the (pre-redesign) spec wording; tooltip behavior is the tested surface.

## Steps executed
1. Hover Reporting → click Time Window Comparison → builder at `/#/time_window_comparison`, header `Account: Hulu | Reporting > Time Window Comparison`.
2. Added brand **Hulu** (bare "Hulu" from Results section).
3. Absolute Dates (default), Interval Days, range **Jul 1–7, 2026** (default last-7-ending-yesterday).
4. Selected **Facebook New Fans** and **Twitter New Followers** (Audience & Growth counter → 1/… each channel).
5. Run Report → story 155797 built; line chart + table per metric.
6. Hovered the Facebook New Fans peak data point (`circle.data-circle.hulu-0`, cx=432).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| 7 | Hovering the Facebook New Fans point shows `Mon. DD, YYYY` + `Brand (Hulu): value` | Tooltip rendered `Jul. 04, 2026` + `Hulu: 7,302` | PASS |

## Evidence
- Tooltip DOM (`.chart-tooltip`): `Jul. 04, 2026Hulu: 7,302`.

## Notes / skill drift
- Tooltip selector is now **`.chart-tooltip`** (older chart-hover-tooltip note cited `.al-area-chart__tooltip` for the TWC line chart). `browser_hover` (trusted) triggered it natively — no synthetic mouse events needed. Minor doc drift; not a failure.

## Bugs filed
None.
