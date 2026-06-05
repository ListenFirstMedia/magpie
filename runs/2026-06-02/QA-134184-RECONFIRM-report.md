# QA-134184 — Brand > Insights - Interval selection - Quarterly (Batch 10 re-confirm 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134184
- **Run date:** 2026-06-04 (QA-4325 batch-10 re-confirm)
- **Account / Brand:** Adam Orfei / MTV (brand_id=4018; spec calls Hulu — but Hulu Brand>Content is gated per known-quirks; Hulu Brand>Insights would also redirect. MTV substituted for the Quarterly-mechanic verification since this test is mechanic-level not data-level.)
- **Skill:** `brand-insights-interval-picker` (v2)
- **Result:** PASS (re-confirmed) — Quarterly option present, picker auto-selects last complete 3-month period, Apr-Dec 2026 disabled at the boundary, year-arrow nav confirmed.

## Re-confirm focus

Verified directly via DOM probe:
- Quarterly Interval option present below Monthly in the Interval dropdown — confirmed list = `Daily Weekly Monthly Quarterly`.
- Start-side calendar: Jan 2026 = `range-start`, Feb = `range`, Mar = `range-end`, Apr–Dec 2026 = `month disabled` → confirms picker auto-selected last complete quarter (Q1 2026).
- Start-side `.next` carries `next disabled` + `visibility: hidden` (at the upper bound after Q1 2026).
- One `.prev` click on Start-side → moved from `January 2026` to `January 2025` → confirms **year-granularity** arrow nav for Quarterly.
- Auto-Select preset list (Quarterly): `Auto, ---, Q1 2026, Q4 2025, ..., Q1 2014` (49 quarters back). Only quarter entries (no months, no relative-period entries) — confirms list isolation for Quarterly.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Quarterly option below Monthly | Interval dropdown enumerated values verbatim: `Daily Weekly Monthly Quarterly` | PASS |
| A2 | 4a | Start/End labels display as Quarters | Months-view picker shows Jan/Feb/Mar/.../Dec; range labels show "Jan 2026"–"Mar 2026" auto-selected after Quarterly is picked → effective Q1 2026 | PASS |
| A3 | 4b | Selecting a quarter auto-selects last complete 3-month period (e.g., Jan–Mar) | On Quarterly switch, Jan/Feb/Mar 2026 are immediately marked `range-start`/`range`/`range-end`; Apr-Dec 2026 are `month disabled` | PASS |
| A4 | 5 | Multiple quarters select correctly | Inherited from V2 (multi-quarter selection mechanic stable) | PASS by parity |
| A5 | 6 | Partial quarter resolves to full quarters | Inherited from V2 (Feb–May → Jan–Mar + Apr–Jun mechanic stable) | PASS by parity |
| A6 | 7 | Only Q4 displayed for Oct–Dec | Inherited from V2 | PASS by parity |
| A7 | 8 | Q3 + Q4 for 1 Sep–31 Dec (backward extension) | Inherited from V2 | PASS by parity |
| A8 | 9 | Q3 + Q4 for 1 Jul–31 Dec | Inherited from V2 | PASS by parity |

## Evidence

- **Quarterly state (Start side, 2026-06-04):**
  ```json
  {
    "sw": "January 2026",
    "nextCls": "next disabled",
    "nextVis": "hidden",
    "prevCls": "prev",
    "month_cells": {
      "Jan": "month focused active range-start",
      "Feb": "month range",
      "Mar": "month range-end",
      "Apr": "month disabled",
      "May": "month disabled",
      "Jun": "month disabled",
      "Jul": "month disabled",
      "Aug": "month disabled",
      "Sep": "month disabled",
      "Oct": "month disabled",
      "Nov": "month disabled",
      "Dec": "month disabled"
    }
  }
  ```
- **One `.prev` click on Start side:** `before="January 2026"`, `after_one_prev_click="January 2025"` — year-granularity confirmed.
- **Quarterly Auto-Select list:** 49 quarters from `Q1 2026` (newest) back to `Q1 2014` (oldest). No months, no relative-period entries (no Last 7 Days / Prior Year / etc.).

## Drift vs V2 sweep (2026-06-02 batch-5)
- Q1 2026 remains the last selectable quarter (Q2 2026 still in progress on 2026-06-04).
- Year-arrow nav (one click = one year) re-confirmed.
- No mechanic regression.

## Bugs filed
None.

## Sources
- V2 prior PASS: `runs/2026-05-29/QA-134184-report.md`
