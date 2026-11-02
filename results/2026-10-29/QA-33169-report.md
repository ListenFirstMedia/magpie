# QA-33169 — Brand Content - Video Views Data Set - Aggregate - Video Response Rate

**Verdict: BLOCKED — test-data gaps. The Thursday row 1 brand "Spotify News" does not exist on dev. On the fallback Thursday row (Sony Pictures Television), the Facebook leg has no Video Views at all.**
Assertions A6, A8, A10 and A12 are PASS (4 of 5), but only A10 (TikTok) was evaluable in the default week. A6, A8 and A12 were evaluated over a widened one-year range. A4 (Facebook) could not be evaluated.
**Run:** 2026-10-29 (Thursday), unattended headless, Playwright MCP
**Environment:** app.lfmdev.in, login lfiqa@listenfirstmedia.com

## Account / brand selection (Rule 1)
- The Description table lists Thursday as accounts Spotify, Sony Pictures, Ralph Lauren with brands Spotify News, Sony Pictures Television, Ralph Lauren. The case's Notes row says "Thu Spotify/Conde Nast", which does not match the table. I followed the Description table.
- **Row 1, Spotify / Spotify News: BLOCKED.**
  - I switched to the Spotify account via the profile menu → Search Account → `Results` row. The breadcrumb showed `ACCOUNT: SPOTIFY` (account_id=1030).
  - Brand > Content opened on "Star Wars" (not the spec brand). I opened the brand picker and typed the exact name "Spotify News". Polled 42 s with two nudges; the `.lfm-ta-option` list stayed empty. The `brands?q=Spotify News` request returned 200.
  - Typing "Spotify" returned about 120 options: `Spotify (Africa)` … `Spotify (Vietnam)`, `Spotify Cares`, `Spotify Design`, `Spotify Engineering`, `Spotify K-Pop`, `Spotify Live`, `Spotify Platform`, `Spotify Podcasts`, `Spotify Policy`, `Spotify Songwriting`, `Spotify Sub-Handles Roll-Up`, `Spotify Wrapped 2025`, `Spotify for Advertisers/Artists/Creators/Podcasters`, `Life at Spotify`, and others. The list is alphabetical and goes from "Spotify Live" to "Spotify Platform", so "Spotify News" is absent. Screenshots: `02-brand-typeahead-empty.png`, `03-brand-typeahead-spotify.png`.
  - Per Rule 1 I did not substitute a brand (no "Spotify Platform", "Spotify Podcasts" or similar).
- **Row 2, Sony Pictures / Sony Pictures Television: executed in full as the next listed Thursday row.**
  - This departs from the 10-20/26/27/28 precedent of running only the first row, because row 1 could not run at all.
  - Account switch via Search Account → `Results` row "Sony Pictures". Breadcrumb `ACCOUNT: SONY PICTURES` (account_id=51). Brand > Content opened already on "Sony Pictures Television" (brand_id=129863), the exact spec brand.
- **Row 3, Ralph Lauren / Ralph Lauren: not run.** Row 2 already covered the case, and the run is token-budgeted. It remains an option for covering A4 (see Bugs filed).

## Steps executed (Sony Pictures Television)
1. Hovered Brand in the top nav and clicked Content. It landed on `#explore/brand/content`.
2. The brand was already the spec brand. Data Set dropdown → "Video Views" (exact option). URL changed to `table_data_set=video_views`, `perspective=extended` (page default; the spec names no view). Screenshot `04-video-views-ds.png`.
3. Steps 3–12, one channel at a time in spec order (Facebook, Twitter, Instagram, TikTok, LinkedIn).
   - For each channel I clicked the target `.channel-ghost.<ch>` icon if it was off, clicked off every other enabled channel, and confirmed that `.channel-ghost.enabled` contained only the target. I then clicked Apply and checked the URL showed `channels=<ch>` only (Rule 2).
   - I opened Table View (`[title="Table View"]`) and read the aggregate row ("Sum Average" Rank cell) in both modes via the Sum ↔ Average toggle (`.aggregate-row-toggle-container label.toggle-switch-label`). The toggle was returned to Sum after each read.
   - Sum mode shows VRR "N/A"; Average mode shows the percentage.
4. **Pass 1, default range Oct 21 – Oct 27, 2026:**
   - Facebook: 1 post, Engagements 2, Video Views "–".
   - Twitter: Posts (0).
   - Instagram: 7 posts, Engagements 29,228, Video Views "–" on all.
   - TikTok: 10 posts, evaluable.
   - LinkedIn: Posts (0).
5. **Pass 2, widened range Oct 27, 2025 – Oct 26, 2026**, set through the START/END DATE picker (`.date-range-fields` showed "Oct 27, 2025 / Oct 26, 2026"), repeated for all five channels. The spec names no date range. The 10-28 run widened the range for the same reason.
   - The first attempt hit skeleton loading for more than 14 s on every channel. LinkedIn then rendered "Posts (45)" on the next poll, so this was slowness, not a failure.
   - I re-ran the loop with a poll of up to about 2 minutes for `Posts (N)` after each Apply. Every channel rendered within the step budget.

## Assertions
Formula 1 (Engagements / Video Views) was used wherever the Sum row had both values. It matched the displayed Average-row Video Response Rate to 2 decimals, so Formula 2 was not needed as the fallback. Formula 2 values are listed informationally.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A4 | 4 (Facebook only) | Sum Eng / Sum Video Views = Average-row Video Response Rate | Default week: 1 post, Eng 2, Video Views "–", VRR "–" (Average) / "N/A" (Sum). One year: 113 posts, Sum Eng 166,035, Video Views "–" on every row (0 of 113 have a value), Average VRR "–". There is no denominator, so the division is undefined and Formula 2 has no posts with a rate. | BLOCKED (test-data gap) |
| A6 | 6 (Twitter only) | same | Default week Posts (0). One year, 9 posts: Sum Eng 316, Video Views 9,331. 316 / 9,331 = 3.387%. Average row: Eng 35, Video Views 1,037, VRR **3.39%**. | PASS (one-year range) |
| A8 | 8 (Instagram only) | same | Default week: 7 posts with Video Views "–", not evaluable. One year, 218 posts: Sum Eng 1,320,390, Video Views 1,760,234. 1,320,390 / 1,760,234 = 75.012%. Average row: Eng 6,057, Video Views 8,074, VRR **75.01%**. | PASS (one-year range), see note |
| A10 | 10 (TikTok only) | same | Default week, 10 posts: Sum Eng 1,412, Video Views 24,240. 1,412 / 24,240 = 5.825%. Average row: Eng 141, Video Views 2,424, VRR **5.83%**. One year, 229 posts: Sum Eng 1,223,117, Video Views 25,421,269. 1,223,117 / 25,421,269 = 4.811%. Average row: Eng 5,341, Video Views 111,010, VRR **4.81%**. | PASS (both ranges) |
| A12 | 12 (LinkedIn only) | same | Default week Posts (0). One year, 45 posts: Sum Eng 2,922, Video Views 61,947. 2,922 / 61,947 = 4.717%. Average row: Eng 65, Video Views 1,377, VRR **4.72%**. | PASS (one-year range) |

## Evidence
- TikTok default week: per-post sums scraped from the 10 rows equal the Sum row exactly. Eng 457+262+214+209+76+74+44+31+28+17 = 1,412. Video Views 8,544+7,842+1,885+1,814+1,446+839+691+343+506+330 = 24,240. Formula 2, the mean of the 10 per-post rates, is 7.17%, which differs from the displayed 5.83% as expected for a mean of ratios vs a ratio of sums.
- One-year per-post sums: LinkedIn (45 of 45 rows) Eng 2,922 / Video Views 61,947 match the Sum row exactly. Twitter (9 of 9) Eng 316 / Video Views 9,331 match exactly. For TikTok and Instagram, Table View renders 200 rows per page of 229 and 218 posts. The 200 rendered rows sum to Eng 1,222,188 / Video Views 25,393,441 (TikTok) and Eng 1,319,467 / Video Views 1,732,114 (Instagram), slightly below the Sum rows, which cover the remaining 29 and 18 posts. This is consistent with the aggregate covering all posts.
- Formula 2 (mean of per-post rates over posts with a rate), informational only: LinkedIn 6.37% (45 posts), Twitter 8.68% (9), Instagram 5.12% (38 of the 200 rendered rows have Video Views), TikTok 6.76% (200 rendered rows).
- **Instagram observation (not a verdict change):** over one year only 38 of the 200 rendered rows have Video Views (the rest are non-video posts). The Sum Engagements covers all posts, including those with no Video Views. The aggregate VRR of 75.01% therefore divides all-post Engagements by video-only Views. It equals the displayed Average-row value, so the assertion as written holds, but the number is not a meaningful video response rate. A per-post mean for Instagram video posts is about 5.12%. Worth a product/QA look, but it does not violate the spec formula.
- The Average row's VRR is Sum Engagements / Sum Video Views, not the mean of per-post rates (for example, TikTok one-year: 5,341 / 111,010 = 4.81%).
- Facebook shows a "Facebook Data Collection Disruption 9/27" banner (last updated 28 days ago). That is consistent with Facebook having "–" on every Video Views value in the range. I did not match the case to a Jira bug, and this banner is the only data-collection signal on the page.
- Screenshots under `.playwright-out/QA-33169/` (the folder also holds files from earlier runs):
  - This run: `01-brand-search.png`, `02-brand-typeahead-empty.png`, `03-brand-typeahead-spotify.png`, `04-video-views-ds.png`.
  - Default-week channel reads: `05-facebook-a-sum.png`/`05-facebook-b-avg.png`, `06-twitter.png`, `07-instagram-a-sum.png`/`07-instagram-b-avg.png`, `08-tiktok-a-sum.png`/`08-tiktok-b-avg.png`, `08-linkedin.png`.
  - One-year reads: `09-<channel>-1y-a-sum.png`/`09-<channel>-1y-b-avg.png` for linkedin, facebook, twitter, instagram, tiktok.
  - The `09-<channel>-1y.png` files without a suffix, and `07-linkedin-1y.png`, are from the first one-year attempt, which caught the skeleton state. Other `0x-*`, `r0*`, `w0*` files are from earlier runs.
- Console errors (analytics/network noise, 30–100 per page) did not affect rendering or the values read.

## Known bugs checked
- The case file's "Open linked bugs" section says none are open, so the Rule 7 screen passed.
- The bug-history grep for QA-33169 (pre-fetched) returned nothing. A single known-quirks.md grep for "video response rate / VRR" matched nothing.
- known-quirks.md "Apple Music also has 0 LinkedIn posts (QA-33169 LinkedIn leg)" and the NBCU/Wednesday notes apply only to Wednesday and did not interact with this Thursday run.
- Known-quirks notes on dev Brand > Content render hangs and typeahead slowness were relevant. Both Pass 2 skeleton states and the slow brand typeahead were slowness. The Spotify News absence is not a slow typeahead: the "Spotify" query listed about 120 brands, none of them "Spotify News".
- No other known bug matched.

## Bugs filed
None (markdown-only; nothing auto-filed). Suggested follow-ups for the owner:
1. Add "Spotify News" to the Spotify account on dev, or correct the case's Thursday row. The Notes row ("Thu Spotify/Conde Nast") also disagrees with the Description table.
2. Facebook has no Video Views for Sony Pictures Television in a one-year range. Run step 3/4 on a Thursday row that has Facebook video data (for example Ralph Lauren), or add Facebook Video Views data for this brand.
3. Consider whether the Instagram aggregate VRR (all-post Engagements / video-only Views) is the intended definition.

## Notes for harvest
- Matching skill: `brand-content-grid-math` (REGISTRY grep found no pre-resolved match, so I used the one named in the case Notes). No deviation from its mechanics.
- New mechanics learned:
  - Brand typeahead on Brand > Content is `getByRole('textbox', {name:'Search for a Brand'})`, opened by clicking `.brand-selector-name-container`. A second click on the name closes the dropdown, so check for the textbox before clicking.
  - The brand picker shows only "Recent Searches" until the query matches. A name that does not exist shows no `Results` section even after 40 s, so an empty list after the poll means the brand does not exist, not that the typeahead is slow. Check with the broader query (for example "Spotify") before calling it.
  - Switching account leaves Brand > Content on a different brand (here "Star Wars"). The brand must be re-picked and checked via `.brand-selector-name`.
  - After a date-range change, Table View needs up to about 2 minutes to leave skeleton on dev. Poll for `Posts (N)` plus `table.lfm-table`, not a fixed wait.
- Skill and REGISTRY maintenance is deferred to harvest.sh as instructed.
