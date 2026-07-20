# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand tried:** #1 Happy Family USA (383037)
- **Skills:** brand-insights-interval-picker
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang

## Steps
1. Brand > Insights (fresh tab). Header briefly responsive — `find` located the **Date Range button** ("Jun. 10, 2026 - Jun. 16, 2026") and the **Interval dropdown**.
2. Clicking the Date Range control to open the interval/Auto-Select picker → renderer hung (executeScript 45s timeout); page frozen.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Interval picker opens | Daily/Weekly/Monthly/Quarterly + Auto-Select per interval | Control present but **picker would not open — renderer froze on interaction** | ⛔ |

## Notes / automation learning
- The Insights **header controls are discoverable** (date range + interval refs found), but **any interaction triggers the renderer hang** (the tiles' render freezes the CDP pipeline). So even header-only cases on Insights are blocked under Chrome MCP this session.
- Auto-Select per-interval contents were **verified end-to-end in prior runs** (`brand-insights-interval-picker`: Daily/Weekly/Monthly/Quarterly enumerations, Monthly drops Last-7-Days/relative entries, Quarterly drops months). Re-verify manually.

## Bugs filed
_None new — Brand>Insights renderer-hang carry-forward._
