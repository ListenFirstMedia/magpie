# QA-83835 — Reporting > Data Studio - Historical limit

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-83835
- **Run date:** 2026-07-10
- **Env:** dev (`app.lfmdev.in`), Playwright MCP
- **Account:** Adam Orfei (account_id 54)
- **Brand:** MTV
- **Metric:** Facebook Total Fans (Followers > Total Followers)
- **Result:** ✅ **3/3 PASS**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3) | End date auto-adjusts based on start date, max 365 days | Start set to Apr 15, 2025 → right calendar jumped Jul 2026 → Apr 2026, end auto-set to **Apr 15, 2026** (start + 365) | ✅ |
| A2 (4) | Start date auto-adjusts based on end date, max 365 days | End set to May 20, 2026 → left calendar jumped Apr 2025 → May 2025, start auto-set to **May 20, 2025** (end − 365) | ✅ |
| A3 (10) | Data displays for selected range | Report `report_id=302117` rendered: "Facebook Total Fans" line chart, MTV Authorized, x-axis May 20, 2025 → May 20, 2026 (table headers confirmed both ends), Sum 16,525,547,297 / Avg 45,151,769, values ~44.3–45.2M flat trend | ✅ |

## Proof — A1 (start drives end)

Navigated the visible `.from-calendar` back to April 2025 (15 months back) via repeated `.prev` clicks (filtered to the offsetParent-visible instance per the known duplicate-hidden-datepicker quirk), then clicked day 15. The `.to-calendar` immediately advanced from July 2026 to April 2026 with April 15, 2026 highlighted as the new end — exactly 365 days after the new start.

## Proof — A2 (end drives start)

With start = Apr 15, 2025 / end = Apr 15, 2026 committed, navigated `.to-calendar` forward one month (May 2026) and clicked day 20. The `.from-calendar` advanced from April 2025 to May 2025 with May 20, 2025 highlighted as the new start — exactly 365 days before the new end.

## Proof — A3

Committed range (May 20, 2025 → May 20, 2026) via the real "Ok" button (`getByRole('button', {name:'Ok', exact:true})` — two other same-text "Ok" buttons exist for the hidden compare-range widget and were not visible/clickable). Added brand MTV (exact match, Rule 1), explicitly clicked the Public/Authorized toggle's inner `label.label` element (the outer text label alone does not fire the handler — same quirk as the 2026-06-11 run), confirmed toggle handle moved right via screenshot, selected Followers → Total Followers → Facebook Total Fans via the metric search box, clicked Go. Report `report_id=302117` rendered a Line chart with table column headers spanning May. 20, 2025 through May. 20, 2026 (365 days), Sum 16,525,547,297 / Average 45,151,769.

## Playwright-MCP notes (reconfirming known-quirks.md entries)

- Duplicate hidden `.from-calendar`/`.to-calendar` instances still present — filtered by `offsetParent !== null` before every prev/next click and day click. Acting on the unfiltered `querySelector` match silently no-ops (would look like "custom range ignored").
- Rapid back-to-back `.click()` calls on the prev-chevron inside a tight loop drop clicks (only ~2 of 10 registered) — needed a 150ms delay between clicks in the evaluate loop for all clicks to land.
- The real "Ok" commit button for the primary date-range picker is `getByRole('button', {name:'Ok', exact:true})`; a `.refresh-date-range` class match resolves to a different, non-visible element (belongs to the hidden compare-range widget) and times out.
- Public/Authorized toggle: clicking the outer `.al-toggle__label--right` text ("Authorized") does NOT toggle the checkbox; must click `.al-toggle__switch label.label`.

## Skill use

Reused `data-studio-historical-limit` skill (v1, pass_streak 1 → 2) end-to-end, no changes needed to the documented pattern. Reused `data-studio-post-level-run` skill primitives for brand/metric/toggle/Go.

## Bugs filed

None.
