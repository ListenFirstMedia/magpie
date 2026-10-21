---
name: brand-paid-vs-twc
version: 1
last_verified: 2026-10-20
last_passed_run: 2026-10-20
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in, account-set]
postconditions: [paid-big-numbers-vs-twc-evaluated]
inputs: [account_name, brand_name, channel, from_date, to_date, metric_pairs]
outputs: [exact big-number values, TWC aggregate values, per-metric match]
related_pages: ["/#explore/brand/paid", "app-reporting /#/time_window_comparison"]
---

# Brand > Paid big numbers vs Time Window Comparison (QA-32750 / 32751 / 32752, QA-20984 table pairing)

Read the Paid page's big numbers exactly and reproduce them with a TWC Aggregate report over the same absolute window. Verified 2026-10-20 on Michael Kors (Facebook, Instagram): 10/10 metrics equal to the cent.

## Mechanics — Brand > Paid
1. Hover `.navigation-menus .navigation-menu-header-label` "Brand" → click the **visible** `a.navigation-menu-link` "Paid" (`#explore/brand/paid?brand_id=…&channels=…&table_data_set=engagements`). Channel ghosts: facebook, twitter, instagram, youtube, tiktok (single channel active by default).
2. Brand picker and date picker are the Content ones (`.brand-selector`, START/END picker via `setDates`).
3. **Big numbers are exact in `.tile .count[title]`** — the tile heading is "<Metric>: <abbrev>(±x%)" and `title` holds the full value ("57,772,177", "$464,710.85", "2.42%"). Tiles seen: Active Ads, Paid Impressions, Spend, Clicks (+CTR), Paid Actions (+Paid Action Rate), 95% Completed Video Views. Twitter adds Engagements / Retweets. No hover needed.
4. Data Set dropdown (visible `.lfm-dropdown-select-box`: Engagements / Video Play / Reach …) changes the Ads table columns; Table View (`[title="Table View"]`) exposes the aggregate row for the QA-20984 big-number ↔ table pairing.

## Mechanics — TWC (headless, see time-window-comparison-run v7)
5. Reporting → visible submenu link "Time Window Comparison" (`app-reporting.lfmdev.in/#/time_window_comparison`). Move the mouse to the page centre after navigation so the hover menu closes.
6. Brand: React value-setter + `InputEvent` on `input.al-typeahead__text-input`, click `.al-typeahead__option` with the exact name. Perspective: `label[for="0-perspective-toggle"]` (force click) until `#0-perspective-toggle` is checked.
7. **The competitive-set dropdown stays open after adding a brand and intercepts clicks**: click the "Select a Date Range" heading to close it. Interval = the `.lfm-dropdown-select-box` whose text is "Days" → option "Aggregate".
8. Dates: `.from-calendar` / `.to-calendar` `td.day:not(.old):not(.new)`; for past months click `th.prev` until `.datepicker-switch` reads the target month (Jan 2025 from Oct 2026 = 21 clicks per calendar).
9. By Channel → `#filter-metrics-search-bar` ("Ad", then "Paid Actions"); leaf paths resolved through ancestor `<details><summary>`: `Facebook › Paid › Ad Clicks | Ad Impressions | Ad 95% Completed Views | Ad Spend | Paid Actions`, `Instagram › Paid › …` (same five), `Twitter › Paid › Ad Clicks | Ad Engagements | Ad Impressions | Ad Retweets | Ad Spend | Ad Replies | Ad URL Clicks | Ad Units`, `TikTok › Paid › Ad Impressions`. Click the label at its bounding-box centre; verify `aria-checked`.
10. Uncheck "Show Metrics Graphs" (`.controlled-check-box__label`), Run Report → `#story/time_window_comparison/<id>`; one `table` per metric: header `Brand | <Channel> <Metric>`, one row with the full value (currency keeps cents).
11. **Never force-click near the top of the page** — a forced click on the metric filter once landed on the "Home" nav item and discarded the builder.

## Judging
- Exact equality per metric pair (Paid Impressions ↔ Ad Impressions, Spend ↔ Ad Spend, Clicks ↔ Ad Clicks, Paid Actions ↔ Paid Actions, 95% Completed Video Views ↔ Ad 95% Completed Views, Engagements ↔ Ad Engagements, Retweets ↔ Ad Retweets).

## Changelog
- **v1** (2026-10-20): initial from QA-32750 and QA-32751 (PASS).
