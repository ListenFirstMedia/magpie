# QA-281 — TWC report for Relative dates with long intervals — Run Report

- **Date:** 2026-05-27
- **Account:** Disney Ad Sales
- **Story:** time_window_comparison/153796 — "Time Window Comparison (15 Weeks Out - 1 Week Out)"
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-281.md

## Result: PASS

## Execution

1. Logged into app.lfmdev.in on Disney Ad Sales (already active).
2. Reporting → Time Window Comparison.
3. Added 3 brands via React-aware typeahead: **Disney Channel** (Primary), **Disney Junior**, **Wells Fargo**.
4. Switched date-range tab to **Relative Dates**.
5. Clicked **Bulk Select Key Date** → switched to Calendar view → navigated calendar back 15 months (May 2026 → February 2025) → clicked Feb 1 → Ok. All 3 brands now show Key Date = **Feb 1, 2025**.
6. Changed Interval dropdown from Days → **Weeks**.
7. Filled Start = `15` Weeks **Before** Event; End = `01` Weeks **Before** Event (switched End direction from default After).
8. Selected metric **New Followers** (top-level aggregate) via controlled-check-box focus + Space dispatch.
9. Set Story Options via the same focus + Space pattern:
   - **Show Metrics Tables** (already on by default)
   - **Show Change**
   - **Show Share**
10. Clicked **Run Report** → "Choose the Ending Day of Weekly Intervals" modal opened, confirming Primary Brand Campaign Window: **15 Weeks Out through 1 Week Out (Oct 13, 2024 - Jan 25, 2025)**. Accepted default "Use the Weekday of Each Brand's Key Date" → Ok.
11. Report rendered: story 153796 titled "Time Window Comparison (15 Weeks Out - 1 Week Out)" with sub-label "Weeks aligned to Event". Cross-Channel section showed a 3-line New Followers chart spanning the 15-week interval, x-axis labels "15 Weeks Out" → "1 Week Out".
12. Export → **CSV** → file downloaded to ~/Downloads as `Disney Channel - Time Window Comparison - 15 Weeks Out - 1 Week Out_Weeks aligned to Event.csv` (3,176 bytes).

## Assertions

- **A1 (Exports match TWC report):** PASS — CSV columns (`Perspective, Brand, Date, New Followers, Change, Change %, Share`) reflect the on-screen report exactly:
  - 3 brands × 15 weekly intervals = 45 data rows
  - Brand ordering matches report screen (Disney Channel → Disney Junior → Wells Fargo)
  - Date column uses the same "X Weeks Out" / "1 Week Out" labels as the chart x-axis
  - Spot-check against chart for Disney Channel: 15 Weeks Out = 16,788 (chart ≈ 16K); 13 Weeks Out = 29,993 (chart spike ≈ 30K); 7 Weeks Out = 50,437 (chart peak ≈ 50K). All match.
  - Show Change → CSV `Change` and `Change %` columns populated (e.g. Disney Channel 14 Weeks Out: Change = 3,644 = +22%)
  - Show Share → CSV `Share` column populated (e.g. Disney Junior 10 Weeks Out: 86%)
  - Show Metrics Tables ON → CSV mirrors the on-screen metrics table content

## Evidence

CSV first 4 rows:
```
"Perspective","Brand","Date","New Followers","Change","Change %","Share"
"Public","Disney Channel","15 Weeks Out","16788","-14221","-46%","14%"
"Public","Disney Channel","14 Weeks Out","20432","3644","22%","17%"
"Public","Disney Channel","13 Weeks Out","29993","9561","47%","23%"
```

Story URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/153796`

## Notes

- 15-month rewind required for the Bulk Select Key Date calendar (May 2026 → Feb 2025). JS-driven `th.prev` click loop with 150 ms throttling was reliable, unlike screenshot-coord clicks which dropped clicks at higher cadence (see [[known-quirks]]).
- "End 1 week" in the spec was ambiguous; interpreted as `1 Week Before Event` (same direction as Start) to produce a 14-week analytical window from Oct 13, 2024 to Jan 25, 2025 — which matches the campaign-window banner shown in the weekday-confirmation modal.
- Story Option checkboxes share the `controlled-check-box` widget shape with the metric tree; native coordinate clicks didn't reliably toggle them, but `focus()` + Space `KeyboardEvent` dispatch did.
- Negative `New Followers` values for Wells Fargo in the CSV (e.g. `-46`, `-493`) reflect net follower loss across those weekly buckets and round-trip cleanly into the export — no en-dash placeholder needed.
