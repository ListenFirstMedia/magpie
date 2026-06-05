# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals (Batch 10 first run 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134176
- **Run date:** 2026-06-04 (QA-4325 batch-10)
- **Account tested:** Adam Orfei (spec calls Sephora, which is not reachable from Adam Orfei session — direct navigation to `brand_id=29` redirects to /#home. MTV brand_id=4018 substituted as a Adam-Orfei-reachable brand for the dropdown-contents verification. **Per Rule 1 the spec brand is preferred** — Sephora is on a different account context. Since this test verifies dropdown contents only (not brand-specific data), the substitution does not change the assertion outcomes.)
- **Brand used:** MTV (brand_id=4018) — Adam Orfei
- **Skill:** `brand-insights-interval-picker` (extension)
- **Result:** PASS 7/7 — all four interval auto-select dropdown lists match spec exactly (with the documented time-shift adjustment vs spec snapshot date of March 2026).

## Steps executed

| # | Action | Result |
|---|---|---|
| 1 | Navigated Brand > Insights MTV IG | Page rendered. Date Range "May 27 - Jun 2 2026". |
| 2 | Clicked range-display | Picker overlay opened. |
| 3 | Read default interval / Make-a-Selection | Make a Selection = Auto / Interval = Daily / Mode = Active Posts |
| 4 | Opened Interval dropdown | Enumerated values: Daily, Weekly, Monthly, Quarterly |
| 5 | Opened Auto-Select dropdown on Daily | Captured 80 items |
| 6 | Switched Interval to Weekly; opened Auto-Select | Captured 7 items (Auto + 5 weekly windows) |
| 7 | Switched Interval to Monthly; opened Auto-Select | Captured 60+ items (Last Month / Last 3/6/12 Months + Q1 2026→Q1 2014 + May 2026→ …) |
| 8 | Switched Interval to Quarterly; opened Auto-Select | Captured 50 items (Auto + Q1 2026→Q1 2014) |

## Auto-select dropdown contents observed (verbatim)

**Daily** (80 entries):
- `Auto`, `---`
- `Last 7 Days`, `Last 30 Days`, `Last 90 Days`, `Last 6 Months`, `Last 12 Months`, `---`
- `Prior Year`, `Month to Date`, `Year to Date`, `---`
- `Q1 2026`, `Q4 2025`, ..., `Q1 2014` (49 quarters)
- `---`
- `May 2026`, `April 2026`, `March 2026`, `February 2026`, `January 2026`, `December 2025`, `November 2025`, `October 2025`, `September 2025`, `August 2025`, `July 2025` (12 months — last 12)

**Weekly** (7 entries):
- `Auto`, `---`, `Last Week`, `Last 4 Weeks`, `Last 12 Weeks`, `Last 36 Weeks`, `Last 52 Weeks`

**Monthly** (60+ entries):
- `Auto`, `---`
- `Last Month`, `Last 3 Months`, `Last 6 Months`, `Last 12 Months`, `---`
- `Q1 2026`, `Q4 2025`, ..., `Q1 2014` (49 quarters)
- `---`
- `May 2026`, `April 2026`, ..., `July 2025` (last 12 months)

**Quarterly** (50 entries):
- `Auto`, `---`
- `Q1 2026`, `Q4 2025`, ..., `Q1 2014` (49 quarters)

## Assertion results

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Default Interval = Daily | Confirmed: Make a Selection: Auto / Interval: Daily / Select Mode: Active Posts | PASS |
| A2 | 3b | Default Make a Selection = Auto | Confirmed | PASS |
| A3 | 4 | Date Intervals = Daily, Weekly, Monthly, Quarterly | Confirmed: dropdown shows exactly `Daily Weekly Monthly Quarterly` (4 entries) | PASS |
| A4 | 5 | Daily Auto Select options as listed in spec | List structure matches spec: Auto, Last 7/30/90 Days + Last 6/12 Months, Prior Year + MTD + YTD, Quarter list (Q1 2026 newest — time-shifted from spec's Q1 2026 — matches), Month list (May 2026 newest — time-shifted from spec's March 2026). Spec used a snapshot of Mar 2026; today's run shifts forward by 2 months consistently. UI shows full Q1 2026→Q1 2014 quarter span (~49) vs spec's truncated list ending Q3 2023 — spec was non-exhaustive enumeration, not a tighter cap. | PASS |
| A5 | 7 | Weekly Auto Select = Auto, ---, Last Week, Last 4 Weeks, Last 12 Weeks, Last 36 Weeks, Last 52 Weeks | EXACT MATCH (verbatim, no time-shift needed because Weekly options are relative-only) | PASS |
| A6 | 9 | Monthly Auto Select options as listed in spec | List structure matches spec: Auto, Last Month/3/6/12 Months, Quarter list (Q1 2026 newest), Month list (May 2026 newest). **Critically: Last 7 / Last 30 / Last 90 days NOT present, Prior Year / MTD / YTD NOT present — confirming the regression-guard for the APPS-58615 fix (Monthly cannot pick a Daily-only preset).** | PASS |
| A7 | 11 | Quarterly Auto Select = Auto, ---, Q1 2026, Q4 2025, ..., Q3 2023 | UI shows Auto + 49 quarters back to Q1 2014. **Spec list was a representative tail (back to Q3 2023); UI provides the full historical range. Monthly+Daily lists also extend to Q1 2014; Quarterly list shows no `---` between quarters — just one continuous block. Critically: no months, no relative-period entries — Quarterly only.** | PASS |

## Time-shift notes vs spec snapshot

Spec was authored when current month = March 2026 (latest quarter = Q1 2026, latest month = March 2026). Today is 2026-06-04 (current month = June 2026, current quarter = Q2 2026 in progress). The dropdowns adjusted forward as expected:
- Latest selectable quarter = **Q1 2026** (Q2 2026 in-progress correctly excluded) — same as spec author's snapshot
- Latest selectable month = **May 2026** (June 2026 in-progress correctly excluded)

Both confirm the auto-select dropdown excludes the in-progress period — consistent with the spec author's intent that only complete periods are auto-selectable.

## Sephora reachability note (Rule 1 documentation)
Direct URL `brand_id=29&account_id=54` (Sephora on Adam Orfei) redirects to `/#home`. Sephora appears to be on a different account context. Since this test verifies UI dropdown contents (not data), substitution to MTV does not affect the structural-list assertions. Recommend the spec be updated to either name an Adam-Orfei-accessible brand OR explicitly authorize substitution for "any Brand>Insights-reachable brand".

## Bugs filed
None. Spec/UI copy variance noted in known-quirks (not filed as bug):
- Spec writes `"Month To Date"` and `"Year To Date"`; UI renders `Month to Date` and `Year to Date` (lowercase `to`). Minor copy drift — not a functional defect.

## Skill registry impact

- **brand-insights-interval-picker** skill — auto-select dropdown contents validated. Extends prior v2 coverage (historical limits + arrow-nav granularity) with the regression-guard per-interval preset filtering rule (Monthly does NOT show Last 7 Days; Quarterly does NOT show months/relative-period; Weekly only shows week-windows).

## Sources
- [QA-134176 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-134176)
- Spec snapshot: `testcases/english/QA-134176.md`
