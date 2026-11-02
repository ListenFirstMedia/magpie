# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-30; account Viacom / account_id=181, brand MTV (brand_id=4018), Authorized data, Oct 22 – Oct 28 2026)

## Setup
- Login: app.lfmdev.in programmatic email/password login (`config/.env`, "With existing account" form); first attempt succeeded. Landed on account_id=342 (LFQA default), then switched to **Viacom** via profile dropdown (`LFQA`) -> `Search Account` -> typed "Viacom" (Results header showed a single option "Viacom") -> real click on the exact `.lfm-ta-option` -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181` (`r6-01-account-search.png`, `r6-02-viacom.png`).
- Brand > Content landed with default range **Oct 22 – Oct 28, 2026**, View = **Authorized data** (dark indicator on the Authorized side, `r6-05-mtv-selected.png`), Data Set = Public, Include Retweets unchecked. Left untouched; the same range was used on the TWC side (spec gives no explicit dates).

## Steps executed
1. Hovered Brand in the top nav -> clicked **Content** (`#explore/brand/content`, `r6-03-brand-content.png`).
2. Clicked the brand chevron -> typed "MTV" in `textarea[placeholder="Search for a Brand"]` -> clicked the exact **MTV** option (list: MTV, MTV (Africa), (Argentina), (Asia), (Australia), (Brasil), (FB), (France), (Germany), (IG), (Israel), (Italy), (Japan), (Mexico)...; `r6-04-brand-dropdown.png`) -> `brand_id=4018`.
3. Channel = **Facebook only** (Twitter/Instagram/TikTok/LinkedIn/Threads clicked off; only `.channel-ghost.facebook.enabled` remained) -> **Apply** (URL `channels=facebook`, `r6-06-fb-only.png`).
   - Spec NOTE (Facebook only): Filter -> Publish Type -> **Reel** -> Apply Filter (`not:"false"`, `r6-09-reel-applied.png`) -> opened the pill, clicked the Include/Exclude toggle (`label[for="content_post_class_content_post_class_0"]`, checked false -> true; pill turned red "Exclude") -> Apply Filter; URL carries `content_post_class values:["reel"], not:"true"` (`r6-10-exclude-toggled.png`).
4. Filter dropdown -> **Content Type** (values Audio/Gallery/GIF/Image/Link/Text/Video, `r6-11-content-type-values.png`).
5. Selected **Video** -> **Apply Filter**. URL filters: `content_post_class not:true [reel]` + `content_types [Video] not:false`; pills `Publish Type: Reel (Exclude)`, `Content Type: Video (Include)`.
6. Noted post count: Facebook **Posts (9)** (`r6-12-fb-video-posts.png`; Sum Engagements 2,787 / Video Views 78,393).
   Repeated for the other channels, each selected exclusively, Content Type = Video retained, Apply, waited for skeletons to clear before reading the count:
   - Twitter **6** (`r6-13-twitter.png`; Sum Engagements 311 / Video Views 13,086 - distinct from Facebook, so not a stale read)
   - Instagram **8** (`r6-14-instagram.png`; Sum Engagements 33,173 / Video Views 1,194,932 - distinct)
   - TikTok **12** (`r6-15-tiktok.png`; Sum Engagements 46,908 - distinct)
   - YouTube **1** (`r6-16-youtube.png`; selecting YouTube auto-deselected all other channels and auto-switched Data Set to `youtube_only:_basic`; Sum Video Views 27,153 / Likes 556 / Comments 27)
   - The Reel-exclude pill is Facebook-only and is dropped when the channel changes (same as prior runs); Content Type = Video persisted on every channel.
7. Hovered Reporting -> menu lists Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics (`r6-20-reporting-menu.png`). There is **no separate "Classic reporting" item** (legacy wording in the spec); went directly to Time Window Comparison.
8. Opened the TWC builder (`app-reporting.lfmdev.in/#/time_window_comparison`, `r6-21-twc-builder.png`).
9. Added **MTV** via `Add Brand By Name` (typed "MTV", clicked the exact "MTV" entry, not MTV (Africa) etc.) and clicked the per-brand perspective toggle (`label[for="0-perspective-toggle"]`) from Public to **Authorized Data** (`checked` false -> true, `r6-22-twc-brand-authorized.png`).
10. Clicked **Absolute Dates**, then explicitly clicked day 22 in `.from-calendar` and day 28 in `.to-calendar` (OCTOBER 2026; `range-start`=22, `range-end`=28, `r6-24-twc-dates.png`), then set the Interval dropdown Days -> **Aggregate** (`r6-25-twc-aggregate.png`).
11. Selected metrics via Filter Metrics (`.al-data-selection__filter` input; `aria-checked` verified true): **Video Posts** (Cross-Channel), **Facebook Video Posts**, **Twitter Video Posts**, **Instagram Video Posts**, **TikTok Video Posts**, **YouTube Posts**. LinkedIn Video Posts (not in spec) left unchecked (`aria-checked=false`).
12. **Show Metrics Graphs** deselected (true -> false, `r6-27-options-graphs-off.png`); Show Metrics Tables left on.
13. **Run Report** -> story `#story/time_window_comparison/162046` in ~12 s (`r6-28-ready-to-run.png`).
14. Compared values (below).

## Brand > Content counts (Content Type = Video, Oct 22–28 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **9** | `r6-12-fb-video-posts.png` |
| Twitter | **6** | `r6-13-twitter.png` |
| Instagram | **8** | `r6-14-instagram.png` |
| TikTok | **12** | `r6-15-tiktok.png` |
| YouTube | **1** (Data Set auto -> `youtube_only:_basic`) | `r6-16-youtube.png` |

## TWC report values (story 162046, MTV Authorized, Aggregate, Oct 22 – Oct 28 2026)
Video Posts **36** · Facebook Video Posts **9** · Twitter Video Posts **6** · Instagram Video Posts **8** · YouTube Posts **1** · TikTok Video Posts **12**
Evidence: `r6-29-twc-report.png` (full-page, header "Time Window Comparison (Oct 22, 2026 - Oct 28, 2026)") + DOM scrape of the six single-row `Brand | Value` tables (0 chart SVGs, as expected with Show Metrics Graphs off). Internal check: 9 + 6 + 8 + 12 + 1 = 36 = TWC cross-channel Video Posts (LinkedIn/Threads contribute 0).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A14-FB | 14 | Content Facebook Video count == TWC Facebook Video Posts | Content 9 == TWC 9 | PASS |
| A14-TW | 14 | Content Twitter == TWC Twitter Video Posts | 6 == 6 | PASS |
| A14-IG | 14 | Content Instagram == TWC Instagram Video Posts | 8 == 8 | PASS |
| A14-TT | 14 | Content TikTok == TWC TikTok Video Posts | 12 == 12 | PASS |
| A14-YT | 14 | Content YouTube == TWC YouTube Posts | 1 == 1 | PASS |
| A14-ALL | 14 | Sum of per-channel Content counts == TWC Video Posts | 9+6+8+12+1 = 36 == 36 | PASS |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). Pre-fetched `bug-history.md` / `known-quirks.md` greps: no entries for QA-79963.
- During the run: orange "Facebook Data Collection Disruption 9/27" banner on Brand > Content (also visible on TWC pages). It did not affect post counts: Facebook count (9) matched TWC (9), so no interference. No known bug reproduced; no console-error-driven UI breakage observed (console errors present throughout the app but unrelated to the assertions).

## Notes / deviations
- Dev rendered fast this run: every channel grid cleared its skeletons within ~20 s of Apply; no reload/retry was needed and no "This table failed to load" tile appeared (contrast with the 2026-10-29 run).
- Counts differ from the 2026-10-29 run (Oct 21–27: FB 7 / TW 7 / IG 7 / TT 12 / YT 2 / total 35) because the app default week rolled forward one day (now Oct 22–28); both sides agree on every channel in this window.
- Self-corrected slip: while locating the Filter Metrics box on the TWC builder I briefly typed "Video Posts" into the "Name this Competitive Set" text box (wrong input). Nothing was saved (Save not clicked); the field was cleared and the metrics were selected via the correct `.al-data-selection__filter` input. No effect on the result.
- Clicking YouTube in the channel row auto-deselects the other channels (exclusive select for this channel), so the usual "enable new, disable previous" sequence was not needed for YouTube.
- Spec step 7 says "classic reporting"; the current nav has no such item (Time Window Comparison sits directly under Reporting).
- Spec step 11 lists "Video Posts" (Cross-Channel) + 4 channel Video Posts + "YouTube Posts"; the picker also has LinkedIn Video Posts, not in the spec - left unselected.

## Bugs filed
None.
