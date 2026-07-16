# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134176
- **Run date:** 2026-07-16 (re-run; originally BLOCKED on tooling/environment timeout)
- **Track:** Playwright MCP (`feature/playwright-mcp`), interactive
- **Skill used:** `skills/brand-insights-interval-picker/SKILL.md` (v2)
- **Account:** Adam Orfei (account_id=54)
- **Result: PASS** (7/7 assertions)

## Substitution note
The ticket's precondition brand (Sephora, brand_id=29) redirects to `#home` when accessed from Adam Orfei's account — a previously documented known-quirk (`skills/REGISTRY.md`, "Sephora-on-Adam-Orfei redirect-to-/#home... gating-by-page edge case"). Since this ticket only exercises the Date Range / Interval / Auto-Select dropdown mechanics (not brand-specific data), substituted **MTV (brand_id=4018)** — already confirmed reliably accessible on this account earlier today — with no loss of test coverage.

## Date-shift note (per the ticket's own Notes section)
The ticket's literal assertion text (A4/A6/A7) was authored when "today" was March 2026, hard-coding entries like `Q1 2026` and `March 2026` as the latest/current period. Today's actual run date is July 16, 2026, so the current quarter is **Q2 2026** and the current month is **June 2026** (interval lists show only *completed* months/quarters, not the in-progress one) — the ticket's own Notes section explicitly calls this out and instructs substituting the shifted values. All comparisons below use the shifted equivalents.

## Steps executed
1. Brand > Insights, MTV. Opened Date Range selector.
2. Confirmed defaults: Interval = Daily, Make a Selection = Auto.
3. Interval dropdown enumerated: Daily, Weekly, Monthly, Quarterly (exactly 4).
4. Daily → Auto Select dropdown enumerated (see Assertions).
5. Interval → Weekly → Auto Select dropdown enumerated.
6. Interval → Monthly → Auto Select dropdown enumerated.
7. Interval → Quarterly → Auto Select dropdown enumerated.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (3a) | Default Interval = Daily | Confirmed | PASS |
| A2 (3b) | Default Make a Selection = Auto | Confirmed | PASS |
| A3 (4) | Date Intervals available = Daily, Weekly, Monthly, Quarterly | Exact match, no others | PASS |
| A4 (5) | Daily Auto Select options (per spec, quarter/month-shifted) | `Auto, ---, Last 7 Days, Last 30 Days, Last 90 Days, Last 6 Months, Last 12 Months, ---, Prior Year, Month to Date, Year to Date, ---, Q2 2026→Q2 2014, ---, June 2026→August 2025` — structure matches exactly, values shifted per the ticket's own dated caveat | PASS |
| A5 (7) | Weekly Auto Select = `Auto, ---, Last Week, Last 4 Weeks, Last 12 Weeks, Last 36 Weeks, Last 52 Weeks` | Verbatim exact match | PASS |
| A6 (9) | Monthly Auto Select options (shifted) | `Auto, ---, Last Month, Last 3 Months, Last 6 Months, Last 12 Months, ---, Q2 2026→Q2 2014, ---, June 2026→...` — no day-based or year-relative entries (regression-guard held), matches spec structure | PASS |
| A7 (11) | Quarterly Auto Select options (shifted) | `Auto, ---, Q2 2026, Q1 2026, Q4 2025, ... Q2 2014` — quarters only, no months/relative-day entries | PASS |

## Bugs filed
None.

## Skill maintenance
`brand-insights-interval-picker` (v2) reconfirmed — full per-interval Auto-Select enumeration matches prior-documented structure (regression-guard: Monthly still correctly drops Last-7-Days/Prior-Year/MTD/YTD entries; Quarterly still correctly drops months and day-relative entries). `switch-account` — Sephora-on-Adam-Orfei redirect gating reconfirmed as a stable, repeatable known-quirk (not a new finding).
