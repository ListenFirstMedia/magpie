# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: BLOCKED — test-data gap at steps 11/12 (Apple Music has no LinkedIn content on dev).**
Assertions A4, A6, A8 and A10 are PASS (4/4 evaluable). A12 (LinkedIn) could not be evaluated.
**Run:** 2026-10-28 (Wednesday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com
**Account / Brand:** Apple Services (account_id=409) / Apple Music (brand_id=31783)
**Date range (default, unchanged for steps 1–10):** Oct 20 – Oct 26, 2026, Lifetime mode, `perspective=extended` (page default; the spec names no view)
**Data set:** Video Views (exact option; URL `table_data_set=video_views`)

## Account / brand selection
- The Description table lists Wednesday as accounts Apple Services, NBCU EnterPrises with brands Apple Music, CNBC, NBC News. The case's Notes row says "Wed Apple Services/Wasserman", which does not match the table. Both sources agree on Apple Services, so I ran the first Wednesday row, Apple Services / Apple Music. This follows the 2026-10-20/26/27 precedent of running only the first row of the day.
- Not run: NBCU EnterPrises / CNBC / NBC News. known-quirks.md records that "NBCU EnterPrises" is not in the lfiqa account list on dev, and CNBC is reachable only as a public brand without a Video Views data set. I did not re-test this.
- Login landed on the home page. I switched to Apple Services via the account menu → Search Account → `Results` row. The breadcrumb showed `ACCOUNT: APPLE SERVICES` and the URL showed `account_id=409`.
- Brand: Brand > Content opened already on "Apple Music", the exact spec brand. No substitution (Rule 1).

## Steps executed
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content`.
2. The brand was already the spec brand. In the Data Set dropdown I picked "Video Views". The URL changed to `table_data_set=video_views` (`02-video-views-ds.png`).
3. Steps 3–12, one channel at a time in spec order (Facebook, Twitter, Instagram, TikTok, LinkedIn). For each channel I clicked the target channel icon, clicked off every other enabled channel (the default had Twitter, Instagram, Facebook, LinkedIn and TikTok on), confirmed `.channel-ghost.enabled` contained only the target, and clicked Apply. I checked the URL showed `channels=<ch>` only (Rule 2).
4. Opened Table View (`[title="Table View"]`) and read the aggregate row (`Rank` cell "Sum Average") in both modes via the Sum ↔ Average toggle (`.aggregate-row-toggle-container label.toggle-switch-label`). Sum mode shows VRR "N/A"; Average mode shows the percentage.
5. LinkedIn: the grid showed Posts (0) and "There is no data available". I widened the range to Sep 27 – Oct 26, 2026, then to Oct 27, 2025 – Oct 26, 2026, then switched the data set to Public over the one-year range. All three still showed 0 posts.

## Assertions
Formula 1 (Engagements / Video Views) was used. It matched on all four evaluable channels, so Formula 2 was not needed as the fallback.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only, 5 posts) | Sum Eng / Sum Video Views = Average-row Video Response Rate | Sum row: Eng 26,305, VV 522,749. 26,305 / 522,749 = 5.032%. Average row: Eng 5,261, VV 104,550, VRR **5.03%** | PASS |
| A6 | 6 (Twitter only, 3 posts) | same | Sum row: Eng 61,478, VV 5,774,627. 61,478 / 5,774,627 = 1.065%. Average row: Eng 20,493, VV 1,924,876, VRR **1.06%** | PASS |
| A8 | 8 (Instagram only, 15 posts) | same | Sum row: Eng 1,160,003, VV 25,964,191. 1,160,003 / 25,964,191 = 4.468%. Average row: Eng 77,334, VV 1,730,946, VRR **4.47%** | PASS |
| A10 | 10 (TikTok only, 20 posts) | same | Sum row: Eng 229,285, VV 1,851,970. 229,285 / 1,851,970 = 12.381%. Average row: Eng 11,464, VV 92,599, VRR **12.38%** | PASS |
| A12 | 12 (LinkedIn only) | same | LinkedIn enabled alone and applied, but Posts (0) and "There is no data available" for the default week, for Sep 27 – Oct 26, 2026, and for Oct 27, 2025 – Oct 26, 2026 under Video Views. The Public data set over the same year also showed 0 posts. No aggregate row exists to evaluate. | BLOCKED (test-data gap) |

## Evidence
- The Average row's VRR is the Sum Engagements / Sum Video Views ratio, not the mean of per-post rates. Example: Instagram 77,334 / 1,730,946 = 4.47%.
- Per-post sums scraped from the rows equal the Sum row exactly: Facebook Eng 26,305 / VV 522,749 (5 of 5 posts), Twitter Eng 61,478 / VV 5,774,627 (3 of 3), Instagram Eng 1,160,003 / VV 25,964,191 (15 of 15), TikTok Eng 229,285 (20 of 20).
- TikTok: 3 of the 20 posts show "–" for Video Views. The Sum row VV 1,851,970 equals the sum of the 17 posts that have it. The Sum-row ratio still matches the displayed VRR to 2 decimals, so the assertion holds.
- Formula 2 cross-check (mean of per-post rates over posts with a rate), informational only since Formula 1 passes: Facebook 5.08%, Twitter 3.62%, Instagram 4.09%, TikTok 5.73% (17 posts). These differ from the displayed Average VRR, as expected for a mean of ratios vs a ratio of sums.
- The Twitter table rows did not expose a `fa-twitter` icon class, so the Twitter channel was verified through the URL (`channels=twitter`) and the enabled ghost only. Facebook, Instagram and TikTok rows showed `fa-facebook-square`, `fa-instagram`, `fa-tiktok`.
- Screenshots under `.playwright-out/QA-33169/`: `02-video-views-ds.png`; per channel `0x-facebook-a.png`/`-b.png`, `0x-twitter-a.png`/`-b.png`, `0x-instagram-a.png`/`-b.png`, `0x-tiktok-a.png`/`-b.png` (the `-a`/`-b` pair shows the two toggle modes, `-a` Sum, `-b` Average); `0x-linkedin.png`, `07-linkedin-30d.png`, `07-linkedin-1y.png`, `07-linkedin-public-1y.png`.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed.
- The bug-history grep for QA-33169 returned nothing. known-quirks.md lists "Apple Music also has 0 LinkedIn posts (QA-21021, QA-33169 LinkedIn leg)". This run confirms it: no Apple Music LinkedIn content over a full year, under both Video Views and Public. It is a test-data gap, not a rendering failure, and I did not match it to a Jira bug.
- Nothing else in the run matched a known bug. Dev console errors (analytics/network noise) did not affect rendering or values.

## Bugs filed
None (markdown-only; nothing auto-filed). Suggested follow-up for the owner: either seed LinkedIn content for Apple Music on dev, or run step 11/12 on another Wednesday row that has LinkedIn data, so A12 can be evaluated.

## Notes for harvest
- Matching skill: `brand-content-grid-math` (no deviation from its mechanics). REGISTRY and skill maintenance deferred to harvest.sh as instructed.
- Table headers contain line breaks ("Video\nResponse\nRate"); normalize with `replace(/\s+/g,' ')` before keying columns.
- The Average/Sum toggle was clicked twice per channel and left in Sum mode, so each channel started in Sum mode. Identify the mode by the VRR cell ("N/A" means Sum).
- The case's Notes weekday row (Wed Apple Services/Wasserman) still does not match its Description table (Wed Apple Services/NBCU EnterPrises).
