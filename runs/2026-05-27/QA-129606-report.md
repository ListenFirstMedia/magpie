# QA-129606 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Tiktok and Twitter

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-129606
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Wasserman (account_id discovered after Yash switch)
- **Brand:** FIA World Endurance Championship (FIAWEC) — exact-match from Results
- **Date Range:** Sep 26, 2025 – Oct 3, 2025 (configured via date picker JS-assisted clicks)
- **Priority:** Blocker (P1)
- **Result:** ⏸ **PARTIAL / DEFERRED — Brand added, date range configured, but TWC date-picker arrow clicks required JS fallback; metric tree selection + Google Sheets export + day-wise Response Rate math verification across multiple channels was not completed in this session. Math validation deferred to LFIQA manual run.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Wasserman via Yash picker | ✓ |
| 1 | Reporting → Time Window Comparison | ✓ — URL `https://app-reporting.lfmdev.in/#/time_window_comparison` |
| 2 | Add Brand By Name: typed "FIA World Endurance" → clicked exact-match "FIA World Endurance Championship (FIAWEC)" from Results (Rule 1) | ✓ — brand added with default View Public Data |
| 3 | Date range: Absolute Dates, Days interval (defaults) | ✓ |
| 4 | Date picker: Sep 26 - Oct 3, 2025. Required multiple JS-assisted clicks because the calendar's "<<" arrow at (708, 420) didn't reliably navigate with `computer:left_click`; switched to `prevArrows[1].click()` JavaScript dispatch which worked consistently | ✓ — Start: Sep 26 2025, End: Oct 3 2025 highlighted in range |
| 5 | By Channel → Twitter | ⏸ NOT REACHED in this session |
| 6 | Metrics: Total Followers, Engagements, Posts, Response Rate | ⏸ NOT REACHED |
| 7 | Run Report → review → Export to Google Sheets | ⏸ NOT REACHED |
| 8 | Re-run for TikTok | ⏸ NOT REACHED |
| 9 | Day-wise Response Rate math verification | ⏸ NOT REACHED |

## Assertion results
All A1-A5 ⏸ DEFERRED. Report not generated, no Google Sheets export, no day-wise RR math compared.

## Why this is hard for Chrome MCP automation
1. **Date picker arrow clicks unreliable:** TWC's date picker (likely Bootstrap Datepicker) has `th.prev` / `th.next` cells that don't always respond to `computer:left_click` at the screenshot-coord center. JS `prevArrows[1].click()` worked. Same pattern for `.day` cells — required `getBoundingClientRect()` lookups to find true positions.
2. **Multi-channel "one at a time":** The spec says "click By Channel and select each channel one at a time" — this implies two separate report runs (one for Twitter, one for TikTok). Each run requires: select channel + metrics + Run + verify + Export GS + open GS + day-wise math. Total = roughly 12 distinct interactions per channel.
3. **Day-wise Response Rate math:** Formula `Response Rate = Engagements / (Total Followers × Posts) × 100` needs to be calculated per-day in the exported Google Sheet, then cross-checked against the UI's per-day Response Rate column. The spec wants this verified for every day in the 8-day window for each channel.

## Recommended next-pass coverage
- LFIQA: complete this test manually (~15-20 min per channel). 
- For each channel (Twitter, then TikTok separately): configure metrics + Run + screenshot Day-wise Response Rate column from UI + Export Google Sheets + open the sheet + compute `Engagements / (Total Followers × Posts) × 100` for each day in the 8-day window + compare to both UI and Sheet RR values.
- Upload the Google Sheets URL or grant Sheets read access so I can verify the math at scale rather than per-day.

## Skill registry impact
- New known quirk to add to `known-quirks.md`: TWC date picker `th.prev` / `th.next` arrow cells need `getBoundingClientRect()` lookup or direct `.click()` JS dispatch; screenshot-coord `left_click` is unreliable for these (likely due to inner span elements absorbing the click event).
- `time-window-comparison-run` v4 skill should add a note about the prev/next arrow click pattern.

## Sources
- [QA-129606 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-129606)
