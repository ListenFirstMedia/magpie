# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (5/5 assertions)
**Run:** 2026-10-20 (Tuesday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com
**Account / Brand:** UCLA (account_id=799) / University of California, Los Angeles (brand_id=127756)
**Date range (default):** Oct 12 – Oct 18, 2026, Lifetime mode, Authorized data view
**Data set:** Video Views (exact option, not "UCLA Video Views"; URL `table_data_set=video_views`)

## Account / brand selection
- The Description table lists Tuesday as accounts UCLA, Viacom, Wasserman with brands University of California, Los Angeles, MTV, Gatorade. The case's own Notes row says "Tue UCLA/Sony Pictures", which does not match the table. I ran the first Tuesday row, UCLA / University of California, Los Angeles, which both sources agree on. Viacom/MTV and Wasserman/Gatorade were not run.
- Login landed on account Hulu (336). I switched to UCLA via the LFQA menu → Search Account → `Results` row. The breadcrumb showed `Account: UCLA` and the URL showed `account_id=799`.
- Brand: Brand > Content opened already on "University of California, Los Angeles", which is the exact spec brand. No substitution was made (Rule 1).

## Steps executed
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content` (screenshot `01-content-landing.png`).
2. The brand was already University of California, Los Angeles. In the Data Set dropdown I picked "Video Views" (the exact label).
3. Channel isolation, repeated for each channel. I clicked the target channel icon first, then clicked the previously enabled icon to disable it. I confirmed through `.channel-ghost.<ch>.enabled` that only the target was enabled, clicked Apply, and checked the URL (`channels=<ch>` only). All five channels have no greyed-out state under this data set.
4. Table View (`[title="Table View"]`) was used for each channel. The aggregate row was read in both modes with the Sum ↔ Average toggle (`.aggregate-row-toggle-container label.toggle-switch-label`).
5. Channels were taken in the spec order: Facebook, Twitter, Instagram, TikTok, LinkedIn. Each showed Posts (7). The table's channel icon matched the enabled channel (twitter/instagram/tiktok/linkedin).

## Assertions
Formula 1 (Engagements / Video Views) was used. It matched on every channel, so Formula 2 was not needed as the fallback.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only) | Sum Eng / Sum Video Views = Average-row Video Response Rate | Sum row: Eng 2,010, VV 1,001. 2,010 / 1,001 = 200.80%. Average row: Eng 287, VV 143, VRR **200.80%** | PASS |
| A6 | 6 (Twitter only) | same | Sum row: Eng 213, VV 2,663. 213 / 2,663 = 7.998%. Average row: Eng 30, VV 380, VRR **8.00%** | PASS |
| A8 | 8 (Instagram only) | same | Sum row: Eng 5,817, VV 425,637. 5,817 / 425,637 = 1.367%. Average row: Eng 831, VV 60,805, VRR **1.37%** | PASS |
| A10 | 10 (TikTok only) | same | Sum row: Eng 755, VV 11,513. 755 / 11,513 = 6.558%. Average row: Eng 108, VV 1,645, VRR **6.56%** | PASS |
| A12 | 12 (LinkedIn only) | same | Sum row: Eng 1,250, VV 19,870. 1,250 / 19,870 = 6.291%. Average row: Eng 179, VV 2,839, VRR **6.29%** | PASS |

## Evidence
- The Sum row's VRR cell shows "N/A" and the Average row's shows the percentage. The app computes that percentage as Sum Engagements / Sum Video Views (for example Facebook 287 / 143 is about 2.007, close to the 200.80% shown). It is not the mean of per-post rates.
- Per-post cross-check of Formula 2 (mean of individual rates over posts that have one): Instagram 1.326%, TikTok 6.580%, LinkedIn 5.444%, Facebook 7.89% (1 post). These differ from the displayed Average VRR. This is informational only, because Formula 1 is the primary formula and it passes. Per-post Engagements and Video Views sums also equal the Sum row on Instagram, TikTok and LinkedIn.
- Facebook observation: only 1 of the 7 posts (rank 5: Eng 79, VRR 7.89%, VV 1,001) has video views. The other 6 show "–" for views and VRR, but their Engagements (1,931 in total) are included in the 2,010 Sum. The app-level VRR (200.80%) therefore divides non-video engagements by video views, which gives a number above 100%. It matches the spec's Formula 1 and the assertion passes. If the intent was video-only engagement, Formula 2 gives 7.89% for this channel.
- Facebook posts insights disruption banner was present on the page (known collection incident). It did not block any value in the table.
- Screenshots (under `.playwright-out/QA-33169/`): `01-content-landing.png`, `02-facebook-average.png`, `03-twitter-agg.png`, `04-instagram-agg.png`, `05-tiktok-agg.png`, `06-linkedin-agg.png`.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed.
- The bug-history and known-quirks greps for QA-33169 returned nothing.
- Nothing in the run matched a known bug. Console errors from the dev app (analytics/network noise) did not affect rendering or values.

## Bugs filed
None.

## Notes for harvest
- The Average/Sum toggle state persists across channel changes. I identified the mode by the VRR cell ("N/A" means Sum).
- Matching skill: `brand-content-grid-math` (Table View scrape, channel ordering, data-set-before-channel). Only the aggregate row was needed here.
- The case's Notes row (Tue UCLA/Sony Pictures) does not match its own Description table (Tue UCLA/Viacom/Wasserman), so the weekday-rotation note looks stale.
