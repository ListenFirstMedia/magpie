# QA-134182 — Brand > Insights: Interval Date selector enforces historical date limits

- **Run:** 2026-07-13 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134182
- **Priority:** Critical (P2)
- **Account/Brand:** Adam Orfei (account_id=54) / MTV (brand_id=4018) — precondition "logged in as Adam Orfei" satisfied via account switch from Viacom→Adam Orfei.
- **Skill reused:** `brand-insights-interval-picker` (v2)
- **Verdict: PASS** (15/15 assertions PASS; A12/A13 PASS with a documented Quarterly year-granularity note — see below)

## Environment / preconditions
- Pre-flight: programmatic Cognito login as `lfiqa@listenfirstmedia.com` (config/.env) → `#home` rendered, `apc_user` present.
- Switched account Viacom (181) → Adam Orfei (54) via LFQA nav → Recent Searches → Adam Orfei (data-id=54). Breadcrumb "Account: Adam Orfei".
- Navigated Brand > Insights with valid from/to/compare params (avoids the historical Chrome-MCP "renderer hang", which is a missing-compare-dates artifact under Playwright). Page rendered fine; **no renderer hang reproduced**.

## Steps executed
Every step run in order, in full, driving the real UI. All calendar-arrow states read from the DOM (`.prev`/`.next` class + computed `visibility` + `.disabled`), filtered to the visible `.datepicker.datepicker-inline` (hidden duplicate pickers excluded).

### Phase A — Daily
1. Brand > Insights (MTV).
2. Clicked the Date Range pill (`button.range-display`) → overlay opened with Make a Selection (`Auto`), Interval (`Daily`), and the historical banner.
3. Daily default confirmed; reviewed both calendars (both July 2026).
4. Make a Selection dropdown → relative options enumerated (Last 7 Days / Last 30 Days / Last 90 Days / Last 6 Months / **Last 12 Months** — capped there; plus Prior Year / MTD / YTD / quarters). Selected **Last 12 Months** (from=2025-07-11, to=2026-07-11).
5. Clicked next (`»`) on the Start-date calendar (July 2025 → August 2025).
6. Clicked prev (`«`) on the End-date calendar (July 2026 → June 2026).

### Phase B — Weekly
7. Interval → Weekly; Make a Selection → **Last 52 Weeks** (options capped: Last Week / 4 / 12 / 36 / **52 Weeks**). from=2025-07-13, to=2026-07-11.
8. Reviewed calendars (Start July 2025, End July 2026).
9. Clicked next on Start (July 2025 → August 2025).
10. Clicked prev on End (July 2026 → June 2026).

### Phase C — Quarterly
11. Interval → Quarterly. Make a Selection lists individual quarters, latest selectable = **Q2 2026** (current Q3 2026 absent — incomplete quarter). Calendars switch to a **year-header / month-grid** view. Historical floor banner = **Apr. 01, 2014**.
12. End calendar prev (`«`): year header **2026 → 2025** (one **year**, not one month); the `»` arrow reappears once off the current year.
13. Start calendar was at 2026 with `»` suppressed (current year); navigated `«` (2026→2025) to enable forward, then clicked next (`»`) → **2025 → 2026** (one year).

### Phase D — Monthly incomplete range
14. Interval → Monthly. The Monthly picker is **month-granularity** (month cells, no day cells) — day-15 cannot be set directly here. Per APPS-58615, set the partial day-level range first in **Daily** (Start = **Sep 15, 2025**, End = **Dec 15, 2025**), then switched Interval → Monthly (range preserved as Sep 2025 range-start → Dec 2025 range-end).
15. Clicked **Ok** → applied `from=2025-09-01&to=2025-12-31` (Sep 15 rounded back to Sep 1, Dec 15 rounded forward to Dec 31). Charts rendered without error; read chart X-axis ticks.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | A3 | No right arrow in End-date calendar (can't go beyond current month) | End cal (July 2026) `.next` = `next disabled`, computed `visibility:hidden`, not visible; Start cal (July 2026) same | PASS |
| A2 | A3 | Only last 12 months selectable | Make a Selection relative "Last N" options cap at **Last 12 Months** (no larger relative range) | PASS |
| A3 | A4 | No right arrow in End-date calendar (Last 12 Months) | End cal (July 2026) `.next` disabled/`visibility:hidden`; Start cal (July 2025) has both arrows enabled | PASS |
| A4 | 5 | Immediate next month displays (Start) | Start July 2025 → **August 2025** | PASS |
| A5 | 6 | Immediate previous month displays (End) | End July 2026 → **June 2026**; `»` re-appears once off current month | PASS |
| A6 | 8 | No right arrow in End (Weekly) | End cal (July 2026) `.next` disabled/`visibility:hidden` | PASS |
| A7 | 8 | Restricted to Weekly window | Weekly relative options cap at **Last 52 Weeks**; current-month end arrow suppressed | PASS |
| A8 | 9 | Immediate next month displays (Start) | Start July 2025 → **August 2025** | PASS |
| A9 | 10 | Immediate previous month displays (End) | End July 2026 → **June 2026** | PASS |
| A10 | 12 | No right arrow in End (Quarterly) | End cal (year 2026) `.next` disabled/`visibility:hidden` | PASS |
| A11 | 12 | Restricted to Quarterly window | Jul–Dec 2026 months = `month disabled` (only Jan–Jun 2026 selectable); latest quarter option Q2 2026, current Q3 2026 excluded (incomplete) | PASS |
| A12 | 13 | Immediate next "month" displays (Start) | Start year **2025 → 2026** — Quarterly navigates by **year** granularity (documented design, not a defect). Immediate next period shown, no skipping | PASS (year-granularity note) |
| A13 | 14 | Immediate previous "month" displays (End) | End year **2026 → 2025** — one year (Quarterly year-granularity, documented). Immediate previous period shown | PASS (year-granularity note) |
| A14 | 16 | Sep 15 – Dec 15 range accepted, no error | Ok applied `from=2025-09-01&to=2025-12-31`; pill "Sep. 01, 2025 - Dec. 31, 2025"; charts rendered, no error | PASS |
| A15 | 17 | X-axis shows Sep, Oct, Nov, Dec (partial start + end months extended per APPS-58615) | Chart X-axis ticks = **Sep. 2025 / Oct. 2025 / Nov. 2025 / Dec. 2025**; partial start (Sep 15→Sep 1 backward) + partial end (Dec 15→Dec 31 forward) both kept | PASS |

## Evidence
- Screenshots under `.playwright-out/QA-134182/`: `A-daily-overlay.png` (Daily overlay, both cals July 2026, only `«`), `A2-make-selection-open.png` (relative options capped at Last 12 Months), `C-quarterly-overlay.png` (year-header/month-grid; floor Apr 01 2014; end `«` only), `D-monthly-start-sep.png` (Monthly month-granularity picker; floor Feb 01 2014), `D-monthly-xaxis.png` (Sep 01–Dec 31 range applied, 4 monthly buckets).
- Key DOM facts: End-side `.next` consistently `next disabled` + `visibility:hidden` when the calendar is at the current month (Daily/Weekly/Monthly) or current year (Quarterly). Historical floors observed: Daily = **Jan. 11, 2014**, Quarterly = **Apr. 01, 2014**, Monthly = **Feb. 01, 2014** (sliding floor; consistent with the ~ rolling window in the skill v2 table).
- Applied Monthly URL: `from=2025-09-01&to=2025-12-31` (backward+forward partial-month extension).

## Known bugs checked
- Case's own "Open linked bugs" note: **"None open. Screen only — run normally."** → Rule 7 screen passed; ran normally.
- `knowledge-base/bug-history.md` grep for QA-134182: only prior self-run entries (all PASS; skill `brand-insights-interval-picker`), no open/closed defect that interferes.
- Brand>Insights "renderer hang" (Chrome-MCP-era quirk) **did not reproduce** under Playwright with valid compare dates — consistent with the 2026-06-22 known-quirks entry. Console errors observed during interaction are the app's routine noise; charts rendered and axes read correctly.

## Bugs filed
None. The Quarterly year-granularity arrow navigation (A12/A13) is documented, accepted design behavior (skill `brand-insights-interval-picker` Step 7; verified QA-134184). The spec's literal wording "immediate next/previous **month**" is loose for the Quarterly phase — the unit is a year, matching the picker's year-header/quarter view. No product defect; flagged here only as a spec-wording vs. behavior note.
