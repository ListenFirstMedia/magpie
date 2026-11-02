# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: BLOCKED — test-data gap on the LinkedIn leg (A12). A4, A6, A8 and A10 are PASS (4 of 5).**
Hulu has no LinkedIn posts on dev, even over a one-year range, so Engagements / Video Views cannot be read for step 12.
**Run:** 2026-10-30 (Friday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com

## Account / brand selection (Rule 1)
- The Description table lists Friday as accounts Hulu, Robinhood, PlayOn! Sports with brand "Hulu" (the second brand cell is blank). The Notes row says "Fri Hulu/Ralph Lauren", which does not match the table. I followed the Description table.
- Switched to the Hulu account via the profile menu → Search Account → `Results` row. Breadcrumb `ACCOUNT: HULU` (account_id=336).
- Brand > Content opened already on brand "Hulu" (brand_id=5670), read from `.brand-selector-name`. This is the exact spec brand, so no substitution.
- The Robinhood and PlayOn! Sports accounts have no brand named in the table, so I did not run them (Rule 1: no invented brand).

## Steps executed
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content`.
2. Brand was already Hulu. Data Set dropdown → "Video Views" (exact option). URL changed to `table_data_set=video_views`. `perspective=extended` is the page default (the spec names no view). Screenshot `f02-video-views-ds.png`.
3. Steps 3–12, one channel at a time in spec order (Facebook, Twitter, Instagram, TikTok, LinkedIn), default range Oct 22 – Oct 28, 2026.
   - For each channel I clicked the target `.channel-ghost.<ch>` icon if it was off and clicked off every other enabled channel. I confirmed `.channel-ghost.enabled` held only the target, clicked Apply, and checked the URL showed `channels=<ch>` only (Rule 2).
   - I opened Table View (`[title="Table View"]`) and read the aggregate row (Rank cell "Sum Average") in both modes via the Sum ↔ Average toggle (`.aggregate-row-toggle-container label.toggle-switch-label`). The toggle was returned to Sum after each read.
   - Sum mode shows VRR "N/A"; Average mode shows the percentage.
4. LinkedIn had Posts (0) in the default week. I widened the range through the START/END DATE picker to Oct 29, 2025 – Oct 28, 2026. A further attempt to go back to Jan 1, 2024 landed on Oct 28, 2025 – Oct 27, 2026, so the picker did not go further back. Both ranges showed "Posts (0) · There is no data available."

## Assertions
Formula 1 (Engagements / Video Views) was used for every leg where the Sum row had both values. It matched the Average-row Video Response Rate to 2 decimals, so Formula 2 was not needed as the fallback. Formula 2 (mean of the displayed per-post rates) is listed informationally.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only) | Sum Engagements / Sum Video Views = Average-row Video Response Rate | 50 posts. Sum Eng 104,357, Video Views 3,157,737. 104,357 / 3,157,737 = 3.305%. Average row: Eng 2,087, Video Views 63,155, VRR **3.30%**. | PASS |
| A6 | 6 (Twitter only) | same | 29 posts. Sum Eng 2,468, Video Views 262,849. 2,468 / 262,849 = 0.939%. Average row: Eng 85, Video Views 9,064, VRR **0.94%**. | PASS |
| A8 | 8 (Instagram only) | same | 43 posts. Sum Eng 482,911, Video Views 15,477,110. 482,911 / 15,477,110 = 3.120%. Average row: Eng 11,230, Video Views 359,933, VRR **3.12%**. | PASS |
| A10 | 10 (TikTok only) | same | 48 posts. Sum Eng 279,323, Video Views 14,518,051. 279,323 / 14,518,051 = 1.924%. Average row: Eng 5,819, Video Views 302,459, VRR **1.92%**. | PASS |
| A12 | 12 (LinkedIn only) | same | Default week: Posts (0). One-year range Oct 29, 2025 – Oct 28, 2026 and Oct 28, 2025 – Oct 27, 2026: Posts (0), "There is no data available." No Table View and no aggregate row, so there is nothing to divide. | BLOCKED (test-data gap) |

## Evidence
- Per-post sums scraped from Table View equal the Sum row exactly on all four evaluable channels (every post rendered, none truncated):
  - Facebook (50 rows): Eng 104,357 / Video Views 3,157,737.
  - Twitter (29 rows): Eng 2,468 / Video Views 262,849.
  - Instagram (43 rows): Eng 482,911 / Video Views 15,477,110.
  - TikTok (48 rows): Eng 279,323 / Video Views 14,518,051.
- The Average row's VRR equals Sum Engagements / Sum Video Views (a ratio of sums), not the mean of the per-post rates. Formula 2 values (mean of per-post VRR over posts with a rate), informational only: Facebook 1.80% (48 posts), Twitter 2.43% (27), Instagram 2.71% (41), TikTok 4.18% (48). Because the displayed aggregate matches Formula 1, the assertion holds as written.
- Video Views is populated on 48/50 Facebook, 27/29 Twitter, 41/43 Instagram and 48/48 TikTok rows. The Facebook "Data Collection Disruption 9/27" banner is shown but did not blank the Video Views in this week.
- The LinkedIn empty state was judged from a screenshot, not from the DOM alone: the page shows "Posts (0)" and "There is no data available. Please select a different brand, brand set, or date range." with no loading skeleton. It is not a render hang.
- Screenshots under `.playwright-out/QA-33169/` (the folder also holds files from earlier runs):
  - `f01-content-landing.png`, `f02-video-views-ds.png`.
  - Per-channel reads: `f05-facebook.png`, `f06-twitter.png`, `f07-instagram.png`, `f08-tiktok.png`, `f09-linkedin.png`.
  - LinkedIn widened ranges: `f10-linkedin-1y-posts.png`, `f11-linkedin-2024-posts.png`.
- Console errors (analytics/network noise, 34–60 per page) did not affect rendering or the values read.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed.
- The pre-fetched bug-history grep for QA-33169 returned nothing.
- known-quirks.md (one grep, "hulu" + "linkedin") matched line 943: LinkedIn has no posts for either Friday brand (Hulu and Ralph Lauren) on dev and prod, so any LinkedIn-only step on the Friday rotation is a test-data gap. This matches what I saw for A12, so I attributed it to that known gap and did not retry.
- No other known bug matched.

## Bugs filed
None (markdown-only; nothing auto-filed). Suggested follow-ups for the owner:
1. Add LinkedIn posts for the Hulu brand on dev, or give the Friday row a brand that has LinkedIn data, so step 12 / A12 can be evaluated.
2. The case Notes row ("Fri Hulu/Ralph Lauren") disagrees with the Description table (Friday brand: Hulu, second cell blank). Ralph Lauren is also a Thursday brand in the table.

## Notes for harvest
- Matching skill: `brand-content-grid-math` (REGISTRY grep pre-resolved none, so I used the one named in the case Notes). No deviation from its mechanics.
- Mechanics confirmed: `devprod-helpers.js` works dev-only. Load it with `ctx._creds` cleared so it does not open a prod tab, set `ctx._creds`, then call `m.login(page, 'https://app.lfmdev.in')` on the single page. `browser_run_code_unsafe` has no `require` or dynamic `import`, so credentials have to be passed in through `ctx._creds` by the caller.
- `m.setDates` clamps the START DATE to about one year before the END DATE: asking for 2024-01-01 landed on 2025-10-28.
- Skill and REGISTRY maintenance is deferred to harvest.sh as instructed.
