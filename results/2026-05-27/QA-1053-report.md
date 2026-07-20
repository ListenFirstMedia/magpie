# QA-1053 — TWC Aggregate - Relative dates - Lock icon and Endash — Run Report

- **Date:** 2026-05-27
- **Account:** Hulu
- **Story:** time_window_comparison/153797 — "Time Window Comparison (5 Days Out - Event Day)"
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-1053.md

## Result: PASS

## Execution

1. Switched account → **Hulu** via Yash → Search Account → click "Hulu" Results entry.
2. Reporting → Time Window Comparison.
3. Switched to **Relative Dates** tab.
4. Interval dropdown → **Aggregate**. Start input → typed `5` (5 Days Before Event); End default `0` Days After Event.
5. Added 3 brands via typeahead in spec order: **Hulu** (Primary), **Full Frontal with Samantha Bee**, **Snowfall**.
6. Bulk Select Key Date → Calendar view → navigated 28 months back (May 2026 → Jan 2024) → clicked Jan 1 → Ok. All 3 brands now show **Key Date = Jan 1, 2024**.
7. Clicked **Use Authorized Data** pill (label flipped to "Use Public Data" after, confirming the global default switched to Authorized Data where available).
8. Filter Metrics → typed "Comments" → toggled **Instagram Comments** via controlled-check-box focus + Space. Then cleared filter and toggled **TikTok Total Followers** the same way.
9. Clicked Run Report → story 153797 generated, titled "Time Window Comparison (5 Days Out - Event Day)".

## Assertions

- **A1 (Snowfall displays en-dash in TikTok Total Followers Graph and Table):** PASS — TikTok Total Followers table shows Snowfall row with `–` (en-dash) in the value column. Graph shows no bar for Snowfall (en-dash placeholder, no plotted bar).
- **A2 (Full Frontal with Samantha Bee and Snowfall display lock for Instagram Comments in Graph and Table):** PASS — 
  - Graph: Hulu plotted with bar (~1,265). Full Frontal with Samantha Bee shows orange 🔒 at x-axis position. Snowfall shows teal 🔒 at x-axis position.
  - Table: Hulu = 1,265; Full Frontal with Samantha Bee = 🔒; Snowfall = 🔒.
- **A3 (Data displays for Full Frontal with Samantha Bee and Hulu for TikTok Total Followers):** PASS —
  - Hulu: **5,500,000**
  - Full Frontal with Samantha Bee: **149,700**
  - (Snowfall: `–` per A1)

## Evidence

- Story URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/153797`
- Instagram Comments table (3 rows): Hulu = 1,265; FFwSB = 🔒; Snowfall = 🔒.
- TikTok Total Followers table: Hulu = 5,500,000; FFwSB = 149,700; Snowfall = `–`.

## Notes

- Aggregate interval collapses the 5-day window (Dec 27, 2023 → Jan 1, 2024) into a single bucket per brand per metric.
- The lock-icon placeholder reflects Hulu's account permissions: Instagram Comments for FFwSB / Snowfall require Authorized Data the Hulu account doesn't have access to (or those brands lack the channel altogether). The en-dash placeholder for Snowfall's TikTok Total Followers indicates the brand has no TikTok channel data at all.
- Filtering the metric tree with the Filter Metrics input (typing "Comments") was required to bring Instagram Comments into view; the default By-Category view buries it deep under Brand Engagement → Comments, and direct `li.leaf[title='Instagram Comments']` lookup returned no result until the filter was applied. New quirk worth recording in [[known-quirks]]: the metric tree lazily renders <li.leaf> nodes — items only exist in DOM after the user has scrolled/filtered to them.
- The View toggle for FFwSB and Snowfall stayed on Public Data because those brands lack Authorized Data; this matches the spec's expected behavior (toggle silently skips unauthorized brands when "Use Authorized Data" is clicked).
