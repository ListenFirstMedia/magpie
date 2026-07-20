# QA-134182 — Brand > Insights - Verify Interval Date selector enforces historical date limits — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** brand-insights-interval-picker
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang (shared with QA-134176)

## Steps
1. Same Insights session as QA-134176. The date/interval selector could not be opened — renderer froze on interaction (45s timeout).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Historical date limit enforced | End-side `»` disabled at current period; historical floor (~Dec 2013) | Picker unreachable — renderer hang | ⛔ |

## Notes / automation learning
- Blocked by the same Brand>Insights renderer hang (4th brand/surface confirmation this run: MTV, #1 Happy Family, UCLA earlier).
- Historical-limit enforcement was **verified in prior runs** (`brand-insights-interval-picker`: Daily end-side `.next disabled` + `visibility:hidden` at June 2026 cap; historical floor sliding ~Dec 2013; Quarterly Q1 2026 last selectable). Re-verify manually.

## Bugs filed
_None new — Brand>Insights renderer-hang carry-forward._
