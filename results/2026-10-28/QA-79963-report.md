# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-28; account Viacom / account_id=181, brand MTV (brand_id=4018), Authorized data, Oct 20 – Oct 26 2026)

## Setup
- Login: app.lfmdev.in programmatic email/password login (`config/.env`; landed on account 657 HBO Max), then switched to **Viacom** via profile dropdown -> `Search Account` -> typed "Viacom" -> clicked the `.account-name` "Viacom" under `Results` -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181`.
- Account search was slow on dev: the first two attempts produced no Results (the app's own `accounts?q=Viacom` request hung ~140 s and then returned 401 in the console log; the typeahead stayed empty). After one page reload + a clean re-type the Results list rendered with exactly one item ("Viacom"). Infra flakiness, not a case failure.
- Brand > Content landed with default range **Oct 20 – Oct 26, 2026**, View = **Authorized data** (indicator on the Authorized side, `r4-03-mtv-selected.png`), Data Set = Public, Include Retweets unchecked. Left untouched; same range used on the TWC side.

## Steps executed
1. Hovered Brand in the top nav -> clicked **Content** (`#explore/brand/content?...account_id=181`).
2. Clicked the brand chevron -> typed "MTV" in `textarea[placeholder="Search for a Brand"]` -> clicked the exact **MTV** option (first in list; the others were MTV (Africa), (Argentina), (Asia), ... ) -> `brand_id=4018` (`r4-02-brand-dropdown.png`).
3. Channel = **Facebook only** (Twitter/Instagram/TikTok/LinkedIn/Threads clicked off while Facebook stayed enabled; `.channel-ghost.facebook.enabled` only) -> **Apply** (URL `channels=facebook`).
   - Spec NOTE (Facebook only): Filter -> Publish Type -> **Reel** -> Apply Filter (`not:"false"`, `r4-06-reel-applied.png`) -> opened the pill and flipped Include->**Exclude** (`label[for="content_post_class_content_post_class_0"]`, checked=true, `r4-07-reel-exclude-toggled.png`) -> Apply Filter; URL carries `content_post_class values:["reel"], not:"true"`.
4. Filter dropdown -> **Content Type** (`r4-08-content-type-values.png`).
5. Selected **Video** -> **Apply Filter**. URL filters: `content_post_class not:true [reel]` + `content_types [Video] not:false`; pills `Publish Type: Reel` (Exclude), `Content Type: Video`.
6. Noted post count: Facebook **Posts (7)** (`r4-09-fb-video-posts.png`).
   Repeated for the other channels, each selected exclusively, Content Type = Video retained, Apply, then waited for skeletons to clear before reading the count: Twitter **7** (`r4-11-twitter.png`, Twitter tiles, Sum Engagements 420), Instagram **7** (`r4-12-instagram.png`, Instagram tiles, Sum Engagements 24,218 - distinct data, so not a stale read), TikTok **12** (`r4-10-tiktok.png`; pill + URL `channels=tiktok` + Video filter confirmed), YouTube **2** (`r4-14-youtube.png`; app auto-switched Data Set to `youtube_only:_basic`, selecting YouTube auto-deselected Instagram). The Reel-exclude pill is Facebook-only and is dropped when the channel changes.
7. Hovered Reporting -> the menu lists Home / Dashboards / Listening / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics. There is **no separate "Classic reporting" item** (legacy wording in the spec); went directly to Time Window Comparison.
8. Opened TWC builder (`app-reporting.lfmdev.in/#/time_window_comparison`, `r4-20-twc-builder.png`).
9. Added **MTV** via `Add Brand By Name` (exact option from the typeahead, not MTV (Africa) etc.; `r4-21`, `r4-22`) and clicked the per-brand perspective toggle to **Authorized Data** (`0-perspective-toggle` false -> true, `r4-23-twc-authorized.png`).
10. Clicked **Absolute Dates** (calendars `range-start`=20, `range-end`=26, OCTOBER 2026) and set Interval dropdown Days -> **Aggregate** (`r4-26-twc-interval-aggregate.png`).
11. Selected metrics (checked state verified via `aria-checked`): **Video Posts** (Cross-Channel), **Facebook Video Posts**, **Twitter Video Posts**, **Instagram Video Posts**, **TikTok Video Posts**, **YouTube Posts** (`r4-33-ready-to-run.png`). LinkedIn Video Posts (not in spec) left unselected.
12. **Show Metrics Graphs** deselected (true -> false); Show Metrics Tables left on.
13. **Run Report** -> story `#story/time_window_comparison/161905` (header `Time Window Comparison (Oct 20, 2026 - Oct 26, 2026)`).
14. Compared values (below).

## Brand > Content counts (Content Type = Video, Oct 20–26 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **7** | `r4-09-fb-video-posts.png` |
| Twitter | **7** | `r4-11-twitter.png` |
| Instagram | **7** | `r4-12-instagram.png` |
| TikTok | **12** | `r4-10-tiktok.png` |
| YouTube | **2** (Data Set auto -> `youtube_only:_basic`) | `r4-14-youtube.png` |

## TWC report values (story 161905, MTV Authorized, Aggregate, Oct 20 – Oct 26 2026)
Video Posts **35** · Facebook Video Posts **7** · Twitter Video Posts **7** · Instagram Video Posts **7** · YouTube Posts **2** · TikTok Video Posts **12**
Evidence: `r4-40-twc-report.png` + DOM scrape of the six single-row `Brand | Value` tables (graphs not rendered, as expected with Show Metrics Graphs off). Internal check: 7 + 7 + 7 + 12 + 2 = 35 = TWC cross-channel Video Posts (LinkedIn/Threads contribute 0).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A14-FB | 14 | Content Facebook Video count == TWC Facebook Video Posts | Content 7 == TWC 7 | PASS |
| A14-TW | 14 | Content Twitter == TWC Twitter Video Posts | 7 == 7 | PASS |
| A14-IG | 14 | Content Instagram == TWC Instagram Video Posts | 7 == 7 | PASS |
| A14-TT | 14 | Content TikTok == TWC TikTok Video Posts | 12 == 12 | PASS |
| A14-YT | 14 | Content YouTube == TWC YouTube Posts | 2 == 2 | PASS |
| A14-ALL | 14 | Sum of per-channel Content counts == TWC Video Posts | 7+7+7+12+2 = 35 == 35 | PASS |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). Pre-fetched `bug-history.md` / `known-quirks.md` greps: no entries for QA-79963.
- During the run: orange "Facebook Data Collection Disruption 9/27" banner on Brand > Content (insight-metric collection). Does not affect post counts; the Facebook count matched TWC, so no interference. No known bug reproduced.

## Notes / deviations
- **Stale count pitfall (my first channel loop, discarded):** an initial batch loop read `Posts (N)` before the grid had re-rendered and also dropped the Video pill / missed the YouTube click, giving Twitter/Instagram readings that were really the previous channel's "7". Those readings were discarded and every channel was re-run one at a time, waiting for skeletons to clear and confirming the pill, URL `channels=`, and tile icons/Sum row. TikTok (12) and YouTube (2) were read in a state that was verified (pill + URL) and differ from the prior channel, so they are not stale.
- **TWC builder reset on the first Run Report click:** the first click on Run Report left the page on the builder with all fields cleared (no brand, interval back to Days, metrics unchecked, graphs back on) and no story URL. Treated as transient; the entire TWC setup was redone from scratch (steps 9-13, all verified) and the second Run Report produced story 161905 within ~5 s. The first attempt's outcome is unknown (a story may or may not have been created); no values from it were used.
- Window differs from the 2026-10-27 run (Oct 19–25: FB 11 / TW 6 / IG 11 / TT 15 / YT 2 / total 45) because the app default week rolled forward; counts moved (FB 11 -> 7, TW 6 -> 7, IG 11 -> 7, TT 15 -> 12), but both sides agree on every channel in each run.
- Spec gives no explicit dates; used the Content default (Oct 20–26) on both sides.
- Spec step 11 lists "Video Posts" (Cross-Channel) + 4 channel Video Posts + "YouTube Posts"; the picker also has LinkedIn Video Posts, not in the spec — left unselected.

## Bugs filed
None.
