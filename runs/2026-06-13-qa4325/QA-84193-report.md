# QA-84193 — Data Studio - Brand > Content - Data QA - Engagements — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Report:** DS Post Level, report_id 297155
- **Brand:** MTV (Authorized view) · **Window:** 7D (Jun 9–15 2026), In-Window, Days
- **Skills:** data-studio-post-level-run
- **Result:** ✅ PASS

## Steps
1. Reporting → Data Studio → **Post Level**. Added MTV; **Select Metrics** → **Engagements** (aggregate). Window Mode **In-Window**, 7D.
2. **Go** → report 297155 rendered: Engagements line chart + post-level data table.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Engagements value present | Non-zero post-level Engagements for the window | **Sum 1,455,696**, Avg **207,957** | ✅ |
| Per-day values render | Daily breakdown Jun 9–15 | 39,094 / 84,433 / 351,828 / 270,412 / 206,988 / 286,332 / 216,609 | ✅ |
| Internal consistency (Data QA) | Sum = Σ daily; Avg = Sum/7 | Σ daily = **1,455,696** = Sum ✓; 1,455,696/7 = 207,957 = Avg ✓ | ✅ |

## Notes / automation learning
- DS Post-Level Engagements is a **public** metric → selectable in any view; aggregate added cleanly via the metric-tree checkbox.
- Data-QA validated by **internal arithmetic** (daily sum reconciles to Sum, and Average = Sum/interval-count) rather than cross-window match (Brand>Content default window is Jun 1–15 = different range).

## Bugs filed
_None._
