# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-29; account Viacom / account_id=181, brand MTV (brand_id=4018), Authorized data, Oct 21 – Oct 27 2026)

## Setup
- Login: app.lfmdev.in programmatic email/password login (`config/.env`). The first submit failed with the Cognito `PreAuthentication ... Task timed out after 3.00 seconds` error (known transient); a second click of the existing-account **Sign in** button succeeded. Landed on account RALPH LAUREN, then switched to **Viacom** via profile dropdown -> `Search Account` -> typed "Viacom" -> real mouse click on the exact `.lfm-ta-option` "Viacom" -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181`.
- Brand > Content landed with default range **Oct 21 – Oct 27, 2026**, View = **Authorized data** (indicator on the Authorized side, `r5-01b-content-top.png`), Data Set = Public, Include Retweets unchecked. Left untouched; the same range was used on the TWC side.

## Steps executed
1. Hovered Brand in the top nav -> clicked **Content** (`#explore/brand/content?...account_id=181`, `r5-01-brand-content.png`).
2. Clicked the brand chevron -> typed "MTV" in `textarea[placeholder="Search for a Brand"]` -> clicked the exact **MTV** option (first in the list; the others were MTV (Africa), (Argentina), (Asia), (Australia), (Brasil), (FB), ... ) -> `brand_id=4018` (`r5-02-brand-dropdown.png`).
3. Channel = **Facebook only** (Twitter/Instagram/TikTok/LinkedIn/Threads clicked off; only `.channel-ghost.facebook.enabled` remained) -> **Apply** (URL `channels=facebook`, `r5-03-fb-filter-menu.png`).
   - Spec NOTE (Facebook only): Filter -> Publish Type -> **Reel** -> Apply Filter (`not:"false"`, `r5-05-reel-applied.png`) -> opened the pill and clicked the Include/Exclude toggle (`label[for="content_post_class_content_post_class_0"]`, checked=true; pill turned red "Exclude", `r5-07-exclude-toggled.png`) -> Apply Filter; URL carries `content_post_class values:["reel"], not:"true"`.
4. Filter dropdown -> **Content Type** (`r5-08-content-type-values.png`; values Audio/Gallery/GIF/Image/Link/Text/Video).
5. Selected **Video** -> **Apply Filter**. URL filters: `content_post_class not:true [reel]` + `content_types [Video] not:false`; pills `Publish Type: Reel (Exclude)`, `Content Type: Video (Include)`.
6. Noted post count: Facebook **Posts (7)** (`r5-09-fb-video-posts.png`, Sum Engagements 754).
   Repeated for the other channels, each selected exclusively (enable the new channel first, then disable the previous one), Content Type = Video retained, Apply, then waited for skeletons to clear before reading the count:
   - Twitter **7** (`r5-11-twitter.png`; Sum Engagements 392 / Video Views 16,611 - distinct from Facebook, so not a stale read)
   - Instagram **7** (`r5-12-instagram.png`; Sum Engagements 25,734 / Video Views 843,002 - distinct)
   - TikTok **12** (`r5-10-tiktok.png`; Sum Engagements 59,610 - distinct)
   - YouTube **2** (`r5-14-youtube.png`; selecting YouTube auto-switched Data Set to `youtube_only:_basic`; Sum 32,167 / 609 / 31)
   - The Reel-exclude pill is Facebook-only and is dropped when the channel changes (as in the prior runs).
7. Hovered Reporting -> the menu lists Home / Dashboards / Listening / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics (`r5-20-reporting-menu.png`). There is **no separate "Classic reporting" item** (legacy wording in the spec); went directly to Time Window Comparison.
8. Opened the TWC builder (`app-reporting.lfmdev.in/#/time_window_comparison`, `r5-21-twc-builder.png`).
9. Added **MTV** via `Add Brand By Name` (real keystrokes populated the typeahead; clicked the exact "MTV" option, not MTV (Africa) etc.; `r5-22`, `r5-23`) and clicked the per-brand perspective toggle (`label[for="0-perspective-toggle"]`) from Public to **Authorized Data** (`checked` false -> true, `r5-24-twc-authorized.png`).
10. Clicked **Absolute Dates** and explicitly clicked day 21 in `.from-calendar` and day 27 in `.to-calendar` (OCTOBER 2026; `range-start`=21, `range-end`=27, `r5-25-twc-dates.png`), then set the Interval dropdown Days -> **Aggregate** (`r5-26-twc-interval-aggregate.png`).
11. Selected metrics via Filter Metrics (checked state verified via `aria-checked`): **Video Posts** (Cross-Channel), **Facebook Video Posts**, **Twitter Video Posts**, **Instagram Video Posts**, **TikTok Video Posts**, **YouTube Posts**. LinkedIn Video Posts (not in spec) left unchecked (`aria-checked=false`).
12. **Show Metrics Graphs** deselected (true -> false, `r5-32-options-graphs-off.png`); Show Metrics Tables left on.
13. **Run Report** -> story `#story/time_window_comparison/161988` in ~8 s (header `Time Window Comparison (Oct 21, 2026 - Oct 27, 2026)`, `r5-33-ready-to-run.png`).
14. Compared values (below).

## Brand > Content counts (Content Type = Video, Oct 21–27 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **7** | `r5-09-fb-video-posts.png` |
| Twitter | **7** | `r5-11-twitter.png` |
| Instagram | **7** | `r5-12-instagram.png` |
| TikTok | **12** | `r5-10-tiktok.png` |
| YouTube | **2** (Data Set auto -> `youtube_only:_basic`) | `r5-14-youtube.png` |

## TWC report values (story 161988, MTV Authorized, Aggregate, Oct 21 – Oct 27 2026)
Video Posts **35** · Facebook Video Posts **7** · Twitter Video Posts **7** · Instagram Video Posts **7** · YouTube Posts **2** · TikTok Video Posts **12**
Evidence: `r5-40-twc-report.png` (full-page, header "Time Window Comparison (Oct 21, 2026 - Oct 27, 2026)") + DOM scrape of the six single-row `Brand | Value` tables (0 chart SVGs, as expected with Show Metrics Graphs off). Internal check: 7 + 7 + 7 + 12 + 2 = 35 = TWC cross-channel Video Posts (LinkedIn/Threads contribute 0).

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
- During the run: orange "Facebook Data Collection Disruption 9/27" banner on Brand > Content, and the Data Collection Status chip (4 red / 3 amber / 22 green). Neither affects post counts; the Facebook count matched TWC, so no interference. No known bug reproduced.

## Notes / deviations
- **Dev slowness (transient, not a case failure):** after Apply on Twitter and on Instagram the Posts grid stayed on skeletons for ~5 min (the 5-minute step budget). Per the budget I did one reload + retry for each; both rendered within ~1 min after the reload with the same URL/filters (Twitter 7, Instagram 7). TikTok needed the same reload (auto-reload after 100 s). Facebook and YouTube rendered first time. After the Twitter reload one secondary tile still showed "This table failed to load" (Reload link clicked once, tile failed again); the `Posts (7)` header and the Sum/Average rows were populated and stable, so the count was read from the header. No post count depended on that tile.
- First login attempt hit the Cognito PreAuthentication 3 s timeout (known infra flake); the retry worked.
- Window differs from the 2026-10-28 run (Oct 20–26: FB 7 / TW 7 / IG 7 / TT 12 / YT 2 / total 35) because the app default week rolled forward by one day; counts are identical to that run, and both sides agree on every channel.
- Spec gives no explicit dates; used the Content default (Oct 21–27) on both sides.
- Spec step 11 lists "Video Posts" (Cross-Channel) + 4 channel Video Posts + "YouTube Posts"; the picker also has LinkedIn Video Posts, not in the spec - left unselected.
- Spec step 7 says "classic reporting"; the current nav has no such item (Time Window Comparison sits directly under Reporting).

## Bugs filed
None.
