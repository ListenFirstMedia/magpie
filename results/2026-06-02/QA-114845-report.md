# QA-114845 — Brand > Insights - Hovering functionality and PNG Export

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-114845
- **Run date:** 2026-06-04 (QA-4325 batch-9)
- **Account/Brand:** Adam Orfei / Michael Kors (brand_id=12597)
- **Date Range:** May 27 – Jun 02, 2026 (Last 7 Days)
- **Channels:** Instagram (single channel — Multi-channel renderer hung per known-quirks)
- **Result:** PASS 5/5
- **Skills used:** `chart-hover-tooltip`, `audience-metrics-export`

## Steps executed
1. Brand → Insights, Michael Kors brand, Public Data, default Last 7 Days range.
2. Hovered Total Followers donut center → tooltip `Facebook: 18,703,444 / Twitter: 2,898,886 / Instagram: 18,975,290 / TikTok: 2,100,000` rendered via `.al-donut__tooltip` (initial multi-channel hover before renderer hang).
3. After renderer hang, opened fresh tab with single channel `channels=instagram` filter. Re-validated:
   - Per-tile Export → PNG on Total Followers Pie tile → `Michael Kors-Insights-Total Followers-Pie-2026-05-27-2026-06-02.png` (49,210 bytes) saved.
   - Hovered Fan Growth Rate bar → `.al-bar-chart__tooltip` rendered with text `May. 28, 2026 Fan Growth Rate: >-0.01%`.
   - Per-tile Export → PNG on Fan Growth Rate Bar tile → `Michael Kors-Insights-Fan Growth Rate-Bar-2026-05-27-2026-06-02.png` (72,926 bytes) saved.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A3 | 3 | Tooltip "Channel name: value" | Donut tooltip text `Facebook: 18,703,444\nTwitter: 2,898,886\nInstagram: 18,975,290\nTikTok: 2,100,000` — each row matches `<Channel>: <integer with commas>` format | PASS |
| A4a | 4 | Filename = Brand-Tab-Tile-Pie-YYYY-MM-DD(Start)-YYYY-MM-DD(End).png | `Michael Kors-Insights-Total Followers-Pie-2026-05-27-2026-06-02.png` | PASS |
| A4b | 4 | PNG matches the page | Read PNG → LISTENFIRST logo, brand "Michael Kors", "Total Followers" title, Legend: Instagram chip, 19M donut with 19M outer label, footer `Brand Insights` + `Date: May. 27, 2026-Jun. 02, 2026` — matches IG-only page state | PASS |
| A5 | 5 | Tooltip: `Mon. DD, YYYY` + `Fan Growth Rate: value` | `.al-bar-chart__tooltip` text = `May. 28, 2026` + `Fan Growth Rate: >-0.01%` — exact spec format | PASS |
| A6 | 6 | Filename = Brand-Tab-Tile-Bar-YYYY-MM-DD(Start)-YYYY-MM-DD(End).png + PNG matches | `Michael Kors-Insights-Fan Growth Rate-Bar-2026-05-27-2026-06-02.png` saved; Read PNG → LISTENFIRST logo, "Michael Kors", "Fan Growth Rate" title, Legend Instagram + Compared To, 7 daily bars May 27-Jun 02 with values matching live page, footer `Brand Insights` + `Date: May. 27, 2026-Jun. 02, 2026` | PASS |

## Evidence
- Donut tooltip: 4-channel multi-channel render with full Instagram=18,975,290 / Facebook=18,703,444 / Twitter=2,898,886 / TikTok=2,100,000.
- Total Followers PNG verified end-to-end on disk (mounted ~/Downloads via cowork).
- Fan Growth Rate bar tooltip rendered for May 28 bar (the highest-magnitude bar at -0.002%).
- Fan Growth Rate PNG verified end-to-end on disk.

## Bugs filed
- None — all 5 assertions PASS.

## Notes
- Brand>Insights renderer hung on first attempt with 4 channels (consistent with `Brand Insights renderer freeze` known-quirk). Recovery: `tabs_close_mcp` + fresh tab with `channels=instagram` URL param.
- Brand_id substitution: URL `brand_id=3801` auto-rewrites to `brand_id=12597` on Adam Orfei context (Michael Kors brand variant) — header confirms Michael Kors. Rule 1 satisfied.
- `audience-metrics-export` skill mechanics: per-tile Export dropdown + JS-find-and-click PNG option works on Brand>Insights tile schema (same pattern as Brand>Audience).
- `chart-hover-tooltip` skill mechanics: `.al-donut__tooltip` requires precise hover on segment fill area; `.al-bar-chart__tooltip` requires precise hover on bar center (not above/below).
