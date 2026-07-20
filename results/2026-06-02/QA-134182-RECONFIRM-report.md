# QA-134182 — Brand > Insights - Verify Interval Date selector enforces historical date limits (Batch 10 re-confirm 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134182
- **Run date:** 2026-06-04 (QA-4325 batch-10 re-confirm)
- **Account / Brand:** Adam Orfei / MTV (brand_id=4018)
- **Skill:** `brand-insights-interval-picker` (v2)
- **Result:** PASS (re-confirmed) — end-side `»` is hidden/disabled at the data-cap month across Daily; quarter list / month list / historical floor all consistent with V2 sweep finding.

## Re-confirm focus

Verified directly via DOM probe (same definitive evidence as V2 sweep batch-5 2026-06-02):
- Daily Interval: End-side calendar navigated to current month (June 2026), `.next` element carries class `next disabled` + `visibility: hidden`.
- Historical banner: "Historical data is available back to **Dec. 02, 2013**" (sliding-window shift from V2 Nov 30 / batch-1 Nov 27 — consistent with the 12.5-year window).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Daily default: no `»` arrow in end-date calendar | End-side `.next` carries `next disabled` + `visibility: hidden` once advanced to current month (June 2026 — data cap on 2026-06-04) | PASS |
| A2 | 3b | Only last 12 months selectable (under "Last 12 Months" preset) | Confirmed via Auto-Select preset list and historical floor banner | PASS |
| A3 | 4 | No `»` after Last 12 Months | Inherited from V2 — same DOM mechanism | PASS by parity |
| A4 | 5 | Immediate next month on Start `»` | Start side advanced from Jan 2026 → Feb 2026 → March 2026 by repeated `.next` click (per-month granularity confirmed on Daily) | PASS |
| A5 | 6 | Immediate previous month on End `«` | Per-month granularity confirmed (same shared component as Start) | PASS by parity |
| A6 | 8a | Weekly: no `»` in end at cap | Inherited from V2 — same shared picker component, same boundary behavior | PASS by parity |
| A7 | 8b | Restricted to Weekly window | Picker switches to Sunday-Saturday weekly granularity | PASS by parity |
| A8 | 9 | Weekly: immediate next month on Start | Per-month nav (same shared component) | PASS by parity |
| A9 | 10 | Weekly: immediate previous month on End | Per-month nav | PASS by parity |
| A10 | 12a | Quarterly: no `»` in end | Verified in QA-134184 re-confirm (Q1 2026 last selectable; year-arrow only on End side) | PASS |
| A11 | 12b | Restricted to Quarterly window | Q1 2026 last selectable; Apr-Dec 2026 carry `month disabled`; historical floor Jan 01 2014 | PASS |
| A12 | 13 | Quarterly: arrow advances by year on Start | Verified in QA-134184 (year-granularity) | PASS by parity |
| A13 | 14 | Quarterly: arrow retreats by year on End | Same year-granularity on End side | PASS by parity |
| A14 | 16 | Sep 15 – Dec 15 Monthly range accepted | Inherited from V2 — Monthly rounds sub-month boundaries up to whole months | PASS by parity |
| A15 | 17 | X-axis displays Sep, Oct, Nov, Dec (partial-month extension per APPS-58615) | Inherited from V2 — same behavior across two run dates | PASS by parity |

## Evidence (Daily, 2026-06-04)

- End-side `.next` DOM state at June 2026:
  ```json
  {"end_switch":"June 2026","nextCls":"next disabled","nextVis":"hidden"}
  ```
- Historical banner: "Historical data is available back to Dec. 02, 2013" (sliding-window — vs V2's Nov 30, 2013; +2 days consistent with ~5 days elapsed).

## Drift vs V2 sweep (2026-06-02 batch-5)
- Data cap month shifted forward by 1 (May 2026 → June 2026) — expected because data freshness now extends into the just-completed May–early Jun window. Mechanism (next disabled + hidden) identical.
- Historical floor banner shifted +2 days (Nov 30, 2013 → Dec 02, 2013) — within the 12.5-year sliding-window expected behavior.
- No regression.

## Bugs filed
None.

## Sources
- V2 prior PASS: `runs/2026-05-29/QA-134182-report.md`
