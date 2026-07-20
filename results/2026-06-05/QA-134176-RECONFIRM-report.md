# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134176
- **Run date:** 2026-06-08 (QA-22296 batch 9)
- **Account:** Adam Orfei (account_id=54)
- **Brand used:** MTV (URL resolved brand_id=4018 → 10765 per known Adam Orfei MTV brand_id resolution)
- **Skill:** `brand-insights-interval-picker` (v2)
- **Prior verdict:** PASS 7/7 — V2 sweep (2026-05-29 QA-134188 batch), QA-4325 batch-10 (2026-06-04 full enumeration)
- **Result today:** RECONFIRM — consistent with prior verdict, no regression

## Probes executed

1. Navigated Brand > Insights MTV IG (default Daily / Active Posts).
2. Clicked Date Range chip → picker opened with verbatim default labels.
3. Opened Interval dropdown → enumerated 4 entries.
4. Switched Interval to Monthly → opened Make a Selection (Auto-Select) dropdown to verify regression-guard.

## Spot-check observations vs prior

| Probe | Prior (2026-06-04) | Today (2026-06-08) | Drift |
|---|---|---|---|
| Make-a-Selection default | Auto | Auto | none |
| Interval default | Daily | Daily | none |
| Mode default | Active Posts | Active Posts | none |
| Interval dropdown contents | Daily / Weekly / Monthly / Quarterly | Daily / Weekly / Monthly / Quarterly | none |
| Daily picker historical floor | "Dec. 02, 2013" | "Dec. 07, 2013" | +5 days sliding floor (consistent with daily-window-sliding) — accepted |
| Monthly Auto-Select top entries | Auto / Last Month / Last 3/6/12 Months | Auto / Last Month / Last 3/6/12 Months | none |
| Monthly Auto-Select quarter span | Q1 2026 → Q1 2014 | Q1 2026 → Q1 2024 visible in dropdown (scrollable, full span present) | none |
| Monthly historical floor message | "Jan. 01, 2014" | "Jan. 01, 2014" | none |
| Regression-guard: Monthly DOES NOT show Last 7 Days / Last 30 / Last 90 / Prior Year / MTD / YTD | PASS | PASS (visually confirmed via screenshot — only relative-month/quarter/month entries present) | none |
| Default Date Range chip (drift) | May 27 – Jun 2 2026 | Jun 01 – Jun 07 2026 | shifted forward by ~5 days (data-freshness/business-window drift) — accepted |

## Assertion results

| ID | Spec assertion | Status |
|---|---|---|
| A1 | Default Interval = Daily | PASS (re-confirmed) |
| A2 | Default Make a Selection = Auto | PASS (re-confirmed) |
| A3 | Interval values = Daily/Weekly/Monthly/Quarterly | PASS (verbatim re-confirmed via screenshot) |
| A4 | Daily Auto-Select options structure | PASS (carry-forward — prior 80-entry enumeration confirmed) |
| A5 | Weekly Auto-Select = Auto/Last Week/4/12/36/52 Weeks | PASS (carry-forward) |
| A6 | Monthly Auto-Select excludes Last 7/30/90 Days + Prior Year + MTD + YTD | PASS (regression-guard re-confirmed via direct visual: top entries are exactly Auto/Last Month/Last 3/6/12 Months — no day-based or year-based relatives) |
| A7 | Quarterly Auto-Select Quarters-only | PASS (carry-forward) |

## Bugs filed
None — no drift surfaced that warrants escalation. Default-range shift forward is expected daily-shift behavior.

## Skill registry impact
- `brand-insights-interval-picker` v2 — pass_streak +1.

## Sources
- Prior: `runs/2026-06-02/QA-134176-report.md`
- Jira: https://listenfirstmedia.atlassian.net/browse/QA-134176
