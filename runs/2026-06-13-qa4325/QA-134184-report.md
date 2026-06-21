# QA-134184 — Brand > Insights - Interval selection - Quarterly — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** brand-insights-interval-picker
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang

## Summary
Brand>Insights is unrenderable under Chrome MCP this session — the renderer freezes on tile render across every brand tried (MTV, #1 Happy Family USA, UCLA), and even header/interval-picker interactions trigger the 45s CDP freeze (see QA-51457, QA-114845, QA-134176, QA-134182). The Quarterly interval selection cannot be exercised.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Quarterly interval | Quarterly selectable; Q1 2026 last selectable; year-granularity nav | Picker unreachable — renderer hang | ⛔ |

## Notes
- **Prior-verified** (`brand-insights-interval-picker`): Quarterly Q1 2026 last selectable; `.prev` year-granularity Jan 2026 → Jan 2025; Monthly/Quarterly Auto-Select regression guards. Re-verify manually.

## Bugs filed
_None new — Brand>Insights renderer-hang carry-forward._
