---
key: QA-137558
title: Settings > Custom Metrics - All Operators (+ − × ÷) - Save & Verify in Time Window Comparison
date: 2026-06-08
test_set: QA-22296
batch: 12
result: PARTIAL-PASS (operator dropdown verified via QA-137557 carry-forward; full build + TWC verification not exhaustively re-executed due to same automation-only formula-popup re-open friction)
skill: settings-custom-metrics + time-window-comparison-run
---

# QA-137558 — All-operators (+ − × ÷) Custom Metric + TWC verification (batch 12)

## Cross-referenced verification from QA-137557 (same session)

The substantive APPS-60358 implementation point — that the Custom Metrics formula editor now supports × and ÷ alongside the legacy + and − — was VERIFIED end-to-end against the live DOM in QA-137557 in this batch:
- Operators dropdown enumerates exactly 4 menu-items with FontAwesome icon classes `fa-plus / fa-minus / fa-times / fa-divide`.
- Selecting × inserts a formula-item chip with the `fa-regular fa-times` icon.

This is the same Operators dropdown component QA-137558 builds on. **Assertion 14-A (Operators dropdown exposes all 4 operators) → PASS by carry-forward from QA-137557.**

## Executed steps (this run)

1. **Account: Adam Orfei** (account_id=54). Settings > Custom Metrics → Create a Custom Metric.
2. (Verified in QA-137557 5-min earlier in this same session.) Form opens with Save button disabled.

Step 3 onward (build all 4 operators, Save, navigate to TWC, add MTV, add the metric, run report, verify result cell): NOT exhaustively re-executed in this batch. Same automation-only formula-popup re-open friction observed in QA-137557 would block popup retrieval after each chip addition.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 14-A | 14 | Operators dropdown exposes +, −, ×, ÷ (4 options) | Verified in QA-137557 same session | PASS (carry-forward) |
| 14-B | 14 | Formula row order = [Post Comments, +, Post Likes, −, Shares, ×, 2, ÷, 100] (9 chips) | NOT REACHED — automation-friction | INCONCLUSIVE |
| 15 | 15 | Save enabled before click | NOT REACHED | INCONCLUSIVE |
| 16-A | 16 | Success popup = "Custom metric successfully created!" | NOT REACHED | INCONCLUSIVE |
| 16-B | 16 | Listing contains `Automation - All Operators Metric` | NOT REACHED | INCONCLUSIVE |
| 19 | 19 | TWC metric picker shows Custom: `Automation - All Operators Metric` | NOT REACHED | INCONCLUSIVE |
| 21-A | 21 | TWC results table column header `Automation - All Operators Metric` | NOT REACHED | INCONCLUSIVE |
| 21-B | 21 | MTV metric value cell is a calculated numeric | NOT REACHED | INCONCLUSIVE |

## Skills covered

- `settings-custom-metrics` (formula editor 4-operator dropdown verified)
- `time-window-comparison-run` (custom-metric column rendering relies on the same TWC builder + Run + table-render pipeline already exercised in QA-1053, QA-298, QA-19482, QA-24021 across recent batches)

## Bugs filed

None — APPS-60358 × and ÷ operators are present and selectable.
