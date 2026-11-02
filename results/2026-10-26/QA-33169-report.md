# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: BLOCKED — test-data gap at steps 11/12 (HBO Max has no LinkedIn content on dev).**
Assertions A4, A6, A8 and A10 are PASS (4/4 evaluable). A12 (LinkedIn) could not be evaluated.
**Run:** 2026-10-26 (Monday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com
**Account / Brand:** HBO Max (account_id=657) / HBO Max (brand_id=155614)
**Date range (default, not changed for steps 1–10):** Oct 18 – Oct 24, 2026, Lifetime mode, `perspective=extended`
**Data set:** Video Views (exact option; URL `table_data_set=video_views`)

## Account / brand selection
- The Description table lists Monday as accounts HBO Max, Amazon Prime Video, Conde Nast with brands HBO Max, Amazon Prime Video, Vogue-US. The case's Notes row for Monday says "HBO Max/Viacom", which does not match the table. Both sources agree on HBO Max, so I ran the first Monday row (HBO Max / HBO Max). Amazon Prime Video and Conde Nast/Vogue-US were not run. This follows the 2026-10-20 precedent of running only the first row of the day.
- Login landed on `#home`. I switched account through the LFQA menu → Search Account → `Results` row. The header showed `ACCOUNT: HBO MAX` and the URL showed `account_id=657`.
- Brand > Content opened already on "HBO Max", which is the exact spec brand. No substitution was made (Rule 1).

## Steps executed
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content` (`01-content-landing.png`).
2. The brand was already HBO Max. In the Data Set dropdown I picked "Video Views" (`02-video-views-ds.png`). The URL changed to `table_data_set=video_views`.
3. Steps 3–12, one channel at a time in spec order (Facebook, Twitter, Instagram, TikTok, LinkedIn). For each channel I explicitly clicked the target channel icon, disabled the other enabled channels (Threads was on by default), confirmed `.channel-ghost.enabled` contained only the target channel, and clicked Apply. I checked the URL showed `channels=<ch>` only (Rule 2). I then opened Table View (`[title="Table View"]`) and read the aggregate row in Sum mode and in Average mode with the Sum/Average toggle. The data set stayed Video Views throughout.
4. Twitter: the first attempt timed out looking for the Table View button, a transient timing problem. A second attempt, after the page had settled, worked. No data was lost.
5. LinkedIn: the table never rendered because the grid shows "There is no data available" and Posts (0). I extended the date range to Sep 25 – Oct 24, 2026 and then to Oct 25, 2025 – Oct 24, 2026, and both still showed 0 posts. I then switched the data set to Public over the one-year range and got 0 posts again. HBO Max has no LinkedIn content on dev at all. The spec names no date range, so the extended ranges did not violate it. They were only used to look for data.

## Assertions
Formula 1 (Engagements / Video Views) was used for every evaluable channel. It matched on each one, so the Formula 2 fallback was not needed. I compared the Sum row (Engagements ÷ Video Views) to the Average row's Video Response Rate (VRR). The Sum row shows VRR "N/A".

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only) | Sum Eng / Sum VV = Average-row VRR | Sum row: Eng 1,447,347, VV 20,247,128. 1,447,347 / 20,247,128 = 7.148%. Average row: Eng 60,306, VV 843,630, VRR **7.15%** | PASS |
| A6 | 6 (Twitter only) | same | Sum row: Eng 3,065, VV 154,227. 3,065 / 154,227 = 1.987%. Average row: Eng 307, VV 15,423, VRR **1.99%** | PASS |
| A8 | 8 (Instagram only) | same | Sum row: Eng 992,012, VV 26,638,615. 992,012 / 26,638,615 = 3.724%. Average row: Eng 28,343, VV 761,103, VRR **3.72%** | PASS |
| A10 | 10 (TikTok only) | same | Sum row: Eng 1,060,950, VV 46,411,992. 1,060,950 / 46,411,992 = 2.286%. Average row: Eng 8,420, VV 368,349, VRR **2.29%** | PASS |
| A12 | 12 (LinkedIn only) | same | LinkedIn enabled alone and applied, but Posts (0) and "There is no data available" for the default week, for Sep 25 – Oct 24, and for Oct 25, 2025 – Oct 24, 2026 under Video Views. Public data set over the same year also showed 0 posts. No aggregate row exists to evaluate. | BLOCKED (test-data gap) |

## Evidence
- The posts counts were Facebook 24, Twitter 10, Instagram 35, TikTok 126. Facebook also reported an overall Posts (24) after Apply.
- Per-post sums cross-check the Sum row on every evaluable channel. Facebook: 1,447,347 / 20,247,128, with 24 of 24 posts having views. Twitter: 3,065 / 154,227, with 10 of 10. Instagram: 992,012 / 26,638,615, with 34 of 35 posts having views. TikTok: 1,060,950 / 46,411,992, with 59 of 126 posts having views.
- Average-row Eng and VV equal the Sum row divided by the post count. For example, Facebook is 1,447,347 / 24 = 60,306 and 20,247,128 / 24 = 843,630.
- As in the 2026-10-20 run, the app's displayed Average VRR is Sum Engagements / Sum Video Views and not the mean of per-post rates. Informational Formula 2 values (mean of per-post VRRs) are Facebook 2.406% (24 posts), Twitter 3.661% (10), Instagram 3.598% (34), TikTok 3.679% (58). They differ from the displayed averages, but Formula 1 passes and is the primary formula, so this does not affect the verdicts.
- Screenshots under `.playwright-out/QA-33169/`: `01-content-landing.png`, `02-video-views-ds.png`, `03-facebook-table.png`, `03b-facebook-avg.png`, `04-twitter-state.png`, `04-twitter.png`, `05-instagram.png`, `06-tiktok.png`, `07-linkedin-state.png`, `07-linkedin-30d.png`, `07-linkedin-1y.png`, `07-linkedin-public-1y.png`.
- The browser console showed many dev-app errors throughout. I did not inspect them individually, and they did not stop any table from rendering or change any value.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed and the case ran.
- The pre-fetched bug-history and known-quirks greps for QA-33169 returned nothing.
- The `brand-content-grid-math` skill records "HBO Max LinkedIn has 0 posts in the default week" from 2026-10-19. This run shows the gap is not week-specific, because there is no HBO Max LinkedIn content over a full year on dev, under both Video Views and Public. I did not match this to a Jira bug.

## Bugs filed
None (markdown-only; nothing auto-filed). Suggested follow-up for the owner: either run the case on another Monday row that has LinkedIn data (Amazon Prime Video, or Conde Nast / Vogue-US) or fix the HBO Max LinkedIn test data on dev, so step 11/12 can be evaluated.

## Notes for harvest
- Matching skill: `brand-content-grid-math` (Table View scrape, data-set-before-channel ordering, Sum/Average toggle). Used with the shared `devprod-helpers.js` for login, account switch, channels and scrape.
- The Sum/Average toggle state persists across channel changes. Identify the mode from the VRR cell: "N/A" means Sum.
- The case Notes row ("Mon HBO Max/Viacom") disagrees with the Description table (Mon HBO Max/Amazon Prime Video/Conde Nast), so the weekday-rotation note looks stale.
- Facebook now has all 24 posts with video views for HBO Max, unlike the UCLA run where most Facebook posts had "–".
