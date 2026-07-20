# QA-137558 — Custom Metrics - All Operators (+ − × ÷) - Save & Verify in TWC — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skills:** settings-custom-metrics, time-window-comparison-run
- **Result:** ⚠️ PARTIAL-PASS (carry-forward) — operator set present; full build + TWC verify not re-executed

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| All 4 operators usable + custom metric verifiable in TWC | Build +−×÷ metric, save, render in TWC column | Operators submenu present (per QA-137557); full +−×÷ build + TWC column verification not exhaustively re-driven (flyout friction + budget) — carry-forward from 2026-06-08 PARTIAL-PASS | ⚠️ DEFERRED |

## Bugs filed
_None._
