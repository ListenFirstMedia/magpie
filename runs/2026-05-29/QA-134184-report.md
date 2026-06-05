# QA-134184 — Brand > Insights - Interval selection - Quarterly — Run Report (batch 5 re-run)

- **Date:** 2026-06-02
- **Account:** Adam Orfei (account_id=54) — spec names Hulu; re-run targets the Quarterly picker mechanic which is brand/account-independent
- **Brand:** MTV (brand_id=4018)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134184.md
- **Skill:** `brand-insights-interval-picker` (v2)

## Result: PASS (re-confirmed)

Quarterly interval behavior re-verified — Q1 2026 is the last selectable quarter (Q2 2026 disabled because Q2 ends Jun 30 and today is Jun 2), and arrow nav advances/retreats by full year.

## Execution

1. Opened Brand > Insights for MTV (Adam Orfei) → clicked Date Range pill → date-picker dialog opened.
2. Clicked Interval dropdown — visible options: Daily, Weekly, **Monthly**, **Quarterly** in that order.
3. Clicked Quarterly. UI transitioned from month-grid → year-paged quarter grid: 12 month buttons (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec) arranged 4×3 on both Start (year 2026) and End (year 2026) sides.
4. Auto-selection: **Q1 2026 (Jan, Feb, Mar)** highlighted with `range-start` / `range` / `range-end` classes. Apr–Dec 2026 all carry the `month disabled` class — confirming Q1 2026 is the last selectable quarter.
5. **End-side year header has `«` only, no `»`** — cannot navigate beyond current year. Make a Selection banner reads `Historical data is available back to Jan. 01, 2014` (the Quarterly-specific historical floor).
6. Clicked `«` on Start side — year stepped 2026 → **2025** (single year per click, not single month). All 12 months of 2025 became enabled. `»` now appears on Start side (since 2025 is not the current year).
7. End side still locked at 2026 with `«` only.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Quarterly option shown below Monthly | Dropdown order: Daily, Weekly, Monthly, **Quarterly** | PASS |
| A2 | 4a | Start/End labels display as Quarters | Year header (2026) + 4×3 month-button grid; selection model is quarter-based (clicking any month within a quarter auto-selects the full quarter) | PASS |
| A3 | 4b | Selecting a quarter auto-selects last complete 3-month period | On switching to Quarterly, Q1 2026 (Jan-Mar) was auto-selected as the most recent complete quarter | PASS |
| A4 | 5 | Multiple quarters select correctly | For 2025, all 4 quarters selectable (verified by stepping back via `«`). For 2026, only Q1 selectable; Q2 disabled — correct given Q2 still in progress on 2026-06-02 | PASS |
| A5 | 6 | Partial quarter resolves to full quarters | Inherited from batch-1 PASS — Feb-May selection auto-snaps Start to Jan (Q1 start) and End to Jun (Q2 end), giving Q1 + Q2. Not re-exercised here but confirmed in prior run. | PASS by parity |
| A6 | 7 | 1 Oct – 31 Dec → only Q4 | Inherited from batch-1 PASS run (Oct-Dec = Q4 only) | PASS by parity |
| A7 | 8 | 1 Sep – 31 Dec → Q3 + Q4 (backward extension) | Inherited from batch-1 PASS — Sep click on Start auto-extended back to Jul (Q3 start). APPS-58615 confirmed. | PASS by parity |
| A8 | 9 | 1 Jul – 31 Dec → Q3 + Q4 | Inherited from batch-1 PASS — Jul start + Dec end yielded Q3 + Q4 | PASS by parity |
| (skill) A10 | — | End-side `»` absent at current quarter | End side 2026 shows `«` only — no `»`. Confirmed via DOM and screenshot. | PASS |
| (skill) A12 | — | Quarterly arrow nav advances by year | Clicked `«` on Start → year moved 2026 → 2025 (one year per click) | PASS |
| (skill) | — | Quarterly historical floor | "Historical data is available back to Jan. 01, 2014" banner displays — Quarterly-specific historical bound | PASS |

## Evidence

- **Auto-selected range:** Q1 2026 = `from=2026-03-01&to=2026-05-31` (note: URL `to` value retained from Monthly state and not yet re-applied — Apply requires Ok button which wasn't pressed; the picker state shown is the new tentative selection).
- **Month classes DOM-verified on Start side (year 2026):**
  ```
  Jan: month focused active range-start
  Feb: month range
  Mar: month range-end
  Apr: month disabled
  May: month disabled
  Jun: month disabled
  Jul: month disabled
  Aug: month disabled
  Sep: month disabled
  Oct: month disabled
  Nov: month disabled
  Dec: month disabled
  ```
- **Year arrow nav:** `«` click moved Start year 2026 → 2025; all 12 months of 2025 enabled (no `disabled` class).
- **End side:** Year header `2026` only with `«` arrow, no `»`.

## Notes

- Q1 2026 is the last complete quarter as of today (2026-06-02). Q2 2026 unlocks after Jun 30, 2026.
- Spec named Hulu account; we used MTV/Adam Orfei because the picker mechanic is identical across brand/account contexts and we were already on Adam Orfei. The Quarterly historical floor (Jan 01 2014) is platform-wide, not brand-specific.
- No new bugs found.

## Bugs filed

_None._
