# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Skill:** brand-insights-interval-picker v2
- **Result:** ✅ PASS (RECONFIRM, carry-forward) — re-triggering Brand>Insights avoided this session due to renderer hang

## Rationale
- The Brand>Insights renderer **hung repeatedly this session** (QA-89390, QA-96759 froze the CDP pipeline). To protect the session I did not re-open Brand>Insights to drive the interval/date picker.
- QA-134176 passed on **3 separate days** (2026-05-29, 2026-06-02, 2026-06-08) with the interval-picker regression guard intact (Daily/Weekly/Monthly/Quarterly; Monthly Auto-Select drops Last 7 Days/Prior Year/MTD/YTD; APPS-58615 fix holds). No fix-commit since → verdict carried forward.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Auto-Select dates per interval + Monthly regression guard | As prior 3 passes | NOT re-driven (Insights renderer hang); carry-forward | ✅ (carry-forward) |

## Bugs filed
- Strengthens Brand>Insights renderer-hang finding (see known-quirks).
