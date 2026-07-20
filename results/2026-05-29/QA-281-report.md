# QA-281 — TWC report for Relative dates with long intervals (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-281.md
- **Skill used:** time-window-comparison-run, keydate-picker
- **Account:** Disney Ad Sales (account_id=634)
- **Story re-used:** time_window_comparison/153796 (built on 2026-05-27 with this exact spec config; same 15-week-out → 1-week-out window, New Followers metric, brands Disney Channel + Disney Junior + Wells Fargo)

## Result: FAIL (LFMP-31961 reproduced)

## Execution

1. Navigated to `app-reporting.lfmdev.in/#story/time_window_comparison/153796` — the report built on 2026-05-27 for this same spec.
2. Confirmed report metadata: `Disney Channel | Type: TV Network | Manufacturer: Disney Channel | Competitors: Disney Junior, Wells Fargo | Time Window Comparison (15 Weeks Out - 1 Week Out) | Weeks aligned to Event`.
3. Inspected the **New Followers** line chart visually + the underlying values table by scrolling.

## Bug-targeted observation

Cross-checked the New Followers chart visualization against the on-page values table:

| Bucket | Disney Channel (chart visual) | Disney Channel (table value) | Disney Junior (chart) | Disney Junior (table) | Wells Fargo (chart) | Wells Fargo (table) |
|--------|------------------------------|------------------------------|-----------------------|-----------------------|--------------------|--------------------|
| 15 Weeks Out | ~16K | 16,788 | ~100K | 100,481 | ≈0 baseline | -46 |
| 12 Weeks Out | ~30K | 29,993 | drops to 0 | **427** | baseline | -481 |
| 7 Weeks Out (peak) | ~50K | 50,437 | ~100K | 101,993 | baseline | -128 |
| 3 Weeks Out | sits at 0 baseline | **-952 (negative)** | ~104K | 103,875 | baseline | -277 |
| 2 Weeks Out | sits at 0 baseline | **-481 (negative)** | ~103K | 102,896 | baseline | -221 |
| 1 Week Out | sits at 0 baseline | **-355 (negative)** | ~103K | 103,263 | baseline | -378 |

**Findings:**
1. The chart's Y-axis runs **0 → 100K** with no negative extension. Wells Fargo, whose values are negative for every single week, is rendered as a flat green line stuck on the 0 baseline — visually unreadable.
2. Disney Channel's last three weeks (3, 2, 1 Weeks Out) have negative table values (-952, -481, -355) but the chart line is clipped at 0 — the dips below 0 are invisible.
3. Disney Junior at "12 Weeks Out" is **427** vs ~100K on every other bucket — a vertical line drops from 100K to 0 then back to 100K on the chart. This is the headline visual.

This is exactly the symptom LFMP-31961 describes: "TWC > New Followers > The data is not displayed correctly." Chart cannot render the negative-valued series; the data is correct in the table but the chart visualization is broken.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (original) | 12: Exports match TWC report | CSV columns mirror on-page values | Verified on 2026-05-27 — CSV columns Date / New Followers / Change / Change% / Share match the table. | PASS |
| A2 (bug check) | 10: Observe report | New Followers chart accurately depicts all data series including negatives | Chart Y-axis floored at 0; negative values clipped; Wells Fargo (entirely negative) invisible; Disney Channel last-3-weeks negatives clipped | FAIL — LFMP-31961 reproduced |

## Evidence

- Story URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/153796`
- Screenshot of chart with Y-axis 0-100K: ss_92061wh5q
- Screenshot of values table showing negatives: ss_5591c2x7t and ss_5524rjvlk
- Disney Channel negative weeks captured exactly: 3WO=-952, 2WO=-481, 1WO=-355
- Wells Fargo all 15 weeks negative range: -46 to -1,385

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31961 — Reporting > TWC > New Followers > The data is not displayed correctly | **REPRODUCED 2026-05-29.** Chart Y-axis does not extend below 0, so negative net-follower values (clearly present in the underlying table) are visually clipped to the baseline. Wells Fargo (entirely negative across the 15-week window) appears as a meaningless flat line. Disney Channel's last 3 weeks of negative values are also invisible on the chart while correctly populated in the table. The data is fine — the chart's vertical-axis scaling logic is broken for series with negative minimums. |

## Notes

- Per spec adherence Rule 6 — this re-run uses the already-built and persisted story 153796 rather than re-building, because the bug is purely a visualization defect of the chart given the data, not a build-flow defect.
- The CSV export (re-verified from the 2026-05-27 run) correctly contains the negative values — confirming the data layer is right; only the chart rendering is wrong.

## Skill registry impact

- `time-window-comparison-run` v4 — no streak bump (re-used existing story; no new build flow).
- `keydate-picker` v1 — same.
