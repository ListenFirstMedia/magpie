# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (5/5 assertions)
**Run:** 2026-10-27 (Tuesday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com
**Account / Brand:** UCLA (account_id=799) / University of California, Los Angeles (brand_id=127756)
**Date range (default):** Oct 19 – Oct 25, 2026, Lifetime mode, Authorized data view (`perspective=extended`, left at the page default; the spec does not name a view)
**Data set:** Video Views (exact option; URL `table_data_set=video_views`)

## Account / brand selection
- The Description table lists Tuesday as accounts UCLA, Viacom, Wasserman with brands University of California, Los Angeles, MTV, Gatorade. The case's Notes row says "Tue UCLA/Sony Pictures", which does not match the table. I ran the first Tuesday row, UCLA / University of California, Los Angeles, which both sources agree on. Viacom/MTV and Wasserman/Gatorade were not run (same scope as the 2026-10-20 run).
- Login landed on account Hulu (336). I switched to UCLA via the LFQA menu → Search Account → `Results` row. The breadcrumb showed `ACCOUNT: UCLA` and the URL showed `account_id=799`.
- Brand: Brand > Content opened already on "University of California, Los Angeles", the exact spec brand. No substitution (Rule 1).

## Steps executed
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content` (`01-content-landing.png`).
2. The brand was already the spec brand. In the Data Set dropdown I picked "Video Views". The URL changed to `table_data_set=video_views`.
3. For each channel I clicked the target channel icon, then clicked off every other enabled icon (the default had Twitter, Instagram, Facebook, LinkedIn and TikTok on). I read `.channel-ghost.enabled` to confirm only the target was on, clicked Apply, and checked the URL (`channels=<ch>` only). No channel was greyed out under this data set.
4. Opened Table View (`[title="Table View"]`) and read the aggregate row (`Rank` cell "Sum Average") in both modes with the Sum ↔ Average toggle (`.aggregate-row-toggle-container label.toggle-switch-label`). Sum mode shows VRR "N/A"; Average mode shows the percentage.
5. Channels were taken in spec order: Facebook, Twitter, Instagram, TikTok, LinkedIn. The table's channel icon matched the enabled channel each time (fa-twitter, fa-instagram, fa-tiktok, fa-linkedin; Facebook verified through the URL and enabled ghost).

## Assertions
Formula 1 (Engagements / Video Views) was used. It matched on every channel, so Formula 2 was not needed as the fallback.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only, 8 posts) | Sum Eng / Sum Video Views = Average-row Video Response Rate | Sum row: Eng 2,326, VV 28,909. 2,326 / 28,909 = 8.046%. Average row: Eng 291, VV 3,614, VRR **8.05%** | PASS |
| A6 | 6 (Twitter only, 8 posts) | same | Sum row: Eng 463, VV 6,068. 463 / 6,068 = 7.630%. Average row: Eng 58, VV 759, VRR **7.63%** | PASS |
| A8 | 8 (Instagram only, 8 posts) | same | Sum row: Eng 12,057, VV 682,494. 12,057 / 682,494 = 1.767%. Average row: Eng 1,507, VV 85,312, VRR **1.77%** | PASS |
| A10 | 10 (TikTok only, 7 posts) | same | Sum row: Eng 1,283, VV 15,709. 1,283 / 15,709 = 8.167%. Average row: Eng 183, VV 2,244, VRR **8.17%** | PASS |
| A12 | 12 (LinkedIn only, 9 posts) | same | Sum row: Eng 1,922, VV 62,508. 1,922 / 62,508 = 3.075%. Average row: Eng 214, VV 6,945, VRR **3.07%** | PASS |

## Evidence
- The Average row's VRR is the Sum Engagements / Sum Video Views ratio (for example Facebook 291 / 3,614 = 8.05%), not the mean of per-post rates.
- Per-post sums of Engagements (all 5 channels) and Video Views (Facebook, Twitter) from the scraped rows equal the Sum row exactly. Example, Facebook: 851+844+274+114+71+63+57+52 = 2,326.
- Formula 2 cross-check (mean of per-post rates over posts with a rate), informational only since Formula 1 passes: Facebook 6.22%, Twitter 6.58%, Instagram 1.82%, TikTok 7.48%, LinkedIn 3.70%. These differ from the displayed Average VRR, as expected for a mean of ratios vs a ratio of sums.
- Every post on every channel had both Engagements and Video Views, so there were no "–" rows to exclude (unlike the Facebook run on 2026-10-20, where 6 of 7 posts had no views).
- LinkedIn had 9 posts in the default week on UCLA, so the Monday no-LinkedIn data gap in known-quirks does not apply to this account.
- Screenshots (under `.playwright-out/QA-33169/`): `01-content-landing.png`, `02-video-views-ds.png`/`02b-loaded.png`, `03-facebook-table-a.png`/`-b.png`, `04-twitter-a.png`/`-b.png`, `05-instagram-a.png`/`-b.png`, `06-tiktok-a.png`/`-b.png`, `07-linkedin-a.png`/`-b.png`. The `-a`/`-b` pair shows the two toggle modes for each channel.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed.
- The pre-fetched bug-history grep for QA-33169 returned nothing. The known-quirks match for QA-33169 concerns the Monday LinkedIn data gap, which does not apply to Tuesday/UCLA.
- Nothing in the run matched a known bug. Console errors from the dev app (analytics/network noise) did not affect rendering or values.

## Bugs filed
None.

## Notes for harvest
- The first `[title="Table View"]` click timed out because the data-set change left the page on "Loading" for about a minute. Waiting for `Posts (N)` first, then clicking Table View, worked with no reload.
- Table headers contain line breaks ("Video\nResponse\nRate"); normalize with `replace(/\s+/g,' ')` before keying columns.
- The Average/Sum toggle state persists across channel changes. I identified the mode by the VRR cell ("N/A" means Sum).
- Matching skill: `brand-content-grid-math`. REGISTRY and skill maintenance deferred to harvest.sh as instructed.
- The case's Notes weekday row (Tue UCLA/Sony Pictures) still does not match its Description table (Tue UCLA/Viacom/Wasserman).
