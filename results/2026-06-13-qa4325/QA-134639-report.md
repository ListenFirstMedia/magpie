# QA-134639 — Brand > Insights - Verify Export across Intervals, BRI Aggregation, and TWC Parity — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** brand-insights-interval-picker, export-csv, time-window-comparison-run
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang

## Summary
Brand>Insights is unrenderable under Chrome MCP this entire session — the renderer freezes on tile render across every brand (MTV, #1 Happy Family USA, UCLA) and even header interactions trigger the 45s CDP freeze (QA-51457, QA-114845, QA-134176, QA-134182, QA-134184, QA-134188). Export-across-intervals + BRI aggregation + TWC parity all require the rendered Insights surface and cannot be exercised.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Export across intervals | Insights export per interval | Insights unreachable — renderer hang | ⛔ |
| BRI aggregation | Brand Reputation Index aggregate correctness | Unreachable | ⛔ |
| TWC parity | Insights value parity vs Time Window Comparison | Unreachable | ⛔ |

## Notes
- The **TWC** half is independently exercisable (TWC builder works — see `time-window-comparison-run`, QA-298 PASS this set), but the **Insights** side needed for parity comparison is blocked.
- Recommend manual / real-browser verification for all Brand>Insights cases this set.

## Bugs filed
_None new — Brand>Insights renderer-hang carry-forward (strong perf-ticket candidate, cf. APPS-55565)._
