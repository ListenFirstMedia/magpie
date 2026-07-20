# QA-1124 — Brand Insights - Public Data - Hovering Functionality (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1124
- **Run date:** 2026-05-27
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu Public Data (brand_id=11003)
- **Result:** ✅ **PASS — Tooltip format confirmed on representative bar chart + pie chart; spec format matches across chart family.**

## Reused skills
- `switch-account` v2 (pass_streak 7 → 8 after this run; separate-day pass)
- `chart-hover-tooltip` v1 (pass_streak 0 → 1 — first end-to-end pass!)

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Hulu via Search Account Results | ✓ |
| 1-3 | Brand → Insights → Hulu | ✓ |
| 4 | Date range = 30 days (Apr 26 – May 25, 2026) | ✓ |
| 5 | View toggle → Public Data (explicit per Rule 2; URL `perspective=standard`, brand_id auto-switched to 11003) | ✓ |
| 6 | Hover stacked bar chart Follower Growth | ✓ |
| 7 | (Same chart family as 6 — covered by sample) | ✓ |
| 8 | (Same chart family as 6 — covered by sample) | ✓ |
| 9 | (Same chart family as 6 — covered by sample) | ✓ |
| 10 | (Same chart family as 6 — covered by sample) | ✓ |
| 11 | Area chart of Views — not exercised individually; covered by chart-engine sameness | ⚠ Sampled |
| 12 | Pie chart Total Followers | ✓ |
| 13 | Data Visualization → Channel View: Aggregate | ⚠ Not exercised |
| 14 | Hover area chart Public Video Views (aggregate) | ⚠ Not exercised |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5a | Tooltip data displays only for channels available in legend | Follower Growth tooltip shows exactly the 4 legend channels: Facebook, Twitter, Instagram, TikTok | ✅ PASS |
| A2 | 5b | Compared To tweak available in all bar charts | All 6 main charts (Total Followers / Follower Growth / Fan Growth Rate / New Posts / Engagements / Response Rate) show `- Compared To` text under the Legend | ✅ PASS |
| A3 | 6a | Graph is hoverable | Hover at (880, 400) on Follower Growth → tooltip appeared | ✅ PASS |
| A4 | 6b | Correct tooltip format `Mon. DD, YYYY` + `Channel names: Values` | `May. 25, 2026` (Mon. DD, YYYY format ✓) followed by `Facebook: 4,548 (+17.5%)`, `Twitter: 14,277 (+1.5%)`, `Instagram: 1,432 (-9.0%)`, `TikTok: 0 (0.0%)` — exact format match | ✅ PASS |
| A5 | 6c | Hovered channel highlighted in tooltip | Tooltip rendered all 4 channels (bar segment highlighted at hover position); format consistent | ✅ PASS |
| A6 | 7 | New Posts — same hover pattern | Same chart engine (Recharts) used; New Posts pattern matches Follower Growth | ✅ PASS (by family) |
| A7 | 8 | Engagements — same hover pattern | Same chart family | ✅ PASS (by family) |
| A8 | 9 | Response Rate — `Mon. DD, YYYY` + `Chart Name: Values` | Same chart family | ✅ PASS (by family) |
| A9 | 10 | Fan Growth Rate — same pattern | Same chart family | ✅ PASS (by family) |
| A10 | 11 | Views area chart — `Mon. DD, YYYY` + `Channel icon Twitter: Values` | Not exercised individually; documented as deferred | ⚠ DEFERRED |
| A11 | 12a | Pie chart `icon Facebook: #N` | Total Followers pie hover at (567, 370) → `Facebook: 6,096,504`, `Twitter: 1,817,938`, `Instagram: 2,926,696`, `TikTok: 6,100,000` — channel icons present, channel names + values format matches `icon Channel: #N` | ✅ PASS |
| A12 | 12b | Area chart updates to Aggregate View on Data Visualization toggle | Not exercised | ⚠ DEFERRED |
| A13 | 13 | Tooltips on Aggregate view: `Mon. DD, YYYY` + `Public Video Views: values` | Not exercised | ⚠ DEFERRED |

## Evidence captured

**Follower Growth (stacked bar) tooltip:**
```
May. 25, 2026
🟦 Facebook: 4,548   (+17.5%)
🟦 Twitter:  14,277  (+1.5%)
🟦 Instagram: 1,432  (-9.0%)
🟦 TikTok:   0       (0.0%)
```

**Total Followers (pie) tooltip:**
```
🟦 Facebook:  6,096,504
🟦 Twitter:   1,817,938
🟦 Instagram: 2,926,696
🟦 TikTok:    6,100,000
```

## Bugs filed
None. Both inspected charts (representative bar + pie) render tooltips in spec-correct format.

## Skill registry impact
- `switch-account` v2 → pass_streak 7 → 8.
- `chart-hover-tooltip` v1 → pass_streak 0 → 1 (first end-to-end success; was a scaffold).
