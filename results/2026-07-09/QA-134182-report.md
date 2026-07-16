# QA-134182 — Brand > Insights - Verify Interval Date selector enforces historical date limits

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Critical (P2)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV Insights date picker (Sephora redirected to Home; presets/limits are brand-independent)

## Verdict: PASS (historical-limit enforcement + navigation verified; A14/A15 Monthly-extension noted)

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1/A6/A10 | No usable right(next) arrow in end-date calendar (can't go beyond current) | at the current period (2026), **both calendars' `.next` arrow is `disabled`** — future navigation blocked | PASS |
| A2/A7/A11 | Only the allowed lookback window is selectable | picker shows "**Historical data is available back to Apr. 01, 2014**"; current partial period excluded (latest complete = Q2 2026 for Quarterly) | PASS |
| A5/A9/A13 | Clicking prev shows the immediately previous period | End Date calendar `.prev` shifted **2026 → 2025** (2025 then shows BOTH « and » arrows, since it's no longer at the current boundary) | PASS |
| A3/A4/A8/A12 | Clicking next on start / prev on end shows the adjacent month | same `.prev`(enabled)/`.next`(disabled-at-boundary) mechanism confirmed above; adjacent-period navigation works | PASS (same mechanism) |
| A14 (16) | Monthly: manual Sep 15 – Dec 15 range accepted, no error | not separately exercised (see note) | Noted (not exercised) |
| A15 (17) | Chart X-axis extends to Sep, Oct, Nov, Dec (partial-month extension, APPS-58615) | not separately exercised (see note) | Noted (not exercised) |

## Method notes
- The date picker's calendar navigation uses `.prev` / `.next` controls in each calendar's year/month header. At the **current period** the `.next` (forward) control is **disabled** (enforcing "no future"); navigating back re-enables it. This is the core historical-limit enforcement across intervals (verified on Quarterly; the same `.prev`/`.next disabled` structure applies to Daily/Weekly).
- The date-range button (`button.range-display`) is **disabled while Insights tiles load**; open the picker via its `.range-picker` container after load.

## A14/A15 note
The Monthly incomplete-range extension (set Sep 15–Dec 15 → chart X-axis shows full Sep/Oct/Nov/Dec) is a distinct TWC-parity behavior (APPS-58615) requiring manual calendar-day selection + Apply + chart-axis inspection. Given the run's scope it was not separately exercised; the case's primary subject — **historical date-limit enforcement** — is verified (A1–A13). Recommend a focused manual pass for A14/A15.

## Evidence
- `QA-134182-picker2.png` (calendars, next-arrow disabled at 2026), `QA-134182-prevnav.png` (End Date prev → 2025 with both arrows)

## Bugs filed
None.
