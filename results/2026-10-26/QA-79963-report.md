# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-26; account Viacom / account_id=181, brand MTV, Authorized data, Oct 18 – Oct 24 2026)

## Setup
- Login: app.lfmdev.in programmatic email/password login (`config/.env`), then switched to **Viacom** via the profile dropdown `Results` entry -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181`.
- Brand > Content landed with default range **Oct 18 – Oct 24, 2026** (`from=2026-10-18&to=2026-10-24`), View = **Authorized data** (`perspective=extended`, toggle confirmed on the Authorized side in screenshot), Data Set = Public, Include Retweets unchecked. Left untouched.
- TWC: Absolute Dates, Oct 18 – Oct 24, 2026 (calendar `range-start`=18 / `range-end`=24, both OCTOBER 2026; report header `Time Window Comparison (Oct 18, 2026 - Oct 24, 2026)`), Interval = **Aggregate**, MTV per-brand toggle clicked to **Authorized Data** (`0-perspective-toggle` false -> true).

## Steps executed
1. Hover Brand -> Content: `#explore/brand/content?brand_id=4018&account_id=181`.
2. Brand dropdown -> typed "MTV" -> first attempt showed only `Recent Searches` (no live Results); retyped slower ("MT" then "V"), Results list rendered (MTV, MTV (Africa), MTV (Argentina) ...) -> clicked the exact **MTV** `.option-label` (`brand_id=4018`). `02b-brand-dropdown.png`.
3. Channel = **Facebook only** (verified `.channel-ghost.enabled` = facebook only) -> Apply. Posts (32) pre-filter.
   - Spec NOTE (FB only): Filter -> **Publish Type -> Reel** -> Apply Filter -> pill toggle flipped to **Exclude** (`content_post_class ... not:"true"` in URL) -> Apply Filter. Posts stayed (32) → no Reel posts in range. `04`–`06` screenshots.
4. Filter -> **Content Type**.
5. Selected **Video** -> **Apply Filter**. Pills: `Publish Type: Reel` (Exclude), `Content Type: Video`.
6. Noted post count: Facebook **Posts (11)** (`10-fb-video-posts.png`).
   Repeat per spec for other channels (Content Type = Video kept; each channel selected exclusively, Apply): Twitter **7**, Instagram **11**, TikTok **15**, YouTube **2** (`11-twitter`, `12-instagram`, `12-tiktok`, `13-youtube` screenshots). The Reel-exclude pill is Facebook-only and is dropped by the app when switching channel.
7. Hover Reporting -> Reporting menu lists Home / Dashboards / Listening / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics — there is **no separate "Classic reporting" item** (legacy spec wording); went directly to Time Window Comparison.
8. TWC builder `app-reporting.lfmdev.in/#/time_window_comparison`.
9. Added **MTV** (exact option from typeahead), clicked per-brand toggle to Authorized Data (`20-twc-brand-added.png`).
10. Absolute Dates, Interval = Aggregate, dates Oct 18 – Oct 24 2026 to match the Content range (`21-twc-dates.png`).
11. Metrics selected (all `aria-checked=true`): Cross-Channel › Video Posts, Facebook › Video Posts, Twitter › Video Posts, Instagram › Video Posts, TikTok › Video Posts, YouTube › Posts (`22-metrics-selected.png`).
12. **Show Metrics Graphs** deselected (true -> false); Show Metrics Tables left on.
13. Run Report -> story `#story/time_window_comparison/161742`.
14. Compared values (below). The TWC report was built once with all six metrics, which covers every channel's comparison (repeating would rebuild the identical report).

## Brand > Content counts (Content Type = Video, Oct 18–24 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **11** | `10-fb-video-posts.png` |
| Twitter | **7** | `11-twitter.png` |
| Instagram | **11** | `12-instagram.png` |
| TikTok | **15** | `12-tiktok.png` |
| YouTube | **2** (Sum Video Views 28,256; posts Oct 22 & Oct 21; app auto-switched Data Set to "YouTube Only: Basic") | `13-youtube.png` |

## TWC report values (story 161742, MTV Authorized, Aggregate, Oct 18 – Oct 24 2026)
Video Posts **46** · Facebook Video Posts **11** · Twitter Video Posts **7** · Instagram Video Posts **11** · TikTok Video Posts **15** · YouTube Posts **2**
Evidence: `24-twc-report-loaded.png` + DOM scrape of the six single-row `Brand | Value` tables. Internal check: 11 + 7 + 11 + 15 + 2 = 46 = TWC cross-channel Video Posts (LinkedIn/Threads contribute 0 / were not selected for Content).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A14-FB | 14 | Content Facebook Video count == TWC Facebook Video Posts | Content 11 == TWC 11 | PASS |
| A14-TW | 14 | Content Twitter == TWC Twitter Video Posts | 7 == 7 | PASS |
| A14-IG | 14 | Content Instagram == TWC Instagram Video Posts | 11 == 11 | PASS |
| A14-TT | 14 | Content TikTok == TWC TikTok Video Posts | 15 == 15 | PASS |
| A14-YT | 14 | Content YouTube == TWC YouTube Posts | 2 == 2 | PASS |
| A14-ALL | 14 | Sum of per-channel Content counts == TWC Video Posts | 11+7+11+15+2 = 46 == 46 | PASS |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `bug-history.md` / `known-quirks.md`: no entries for QA-79963.
- During the run: orange "Facebook Data Collection Disruption 9/27" banner shown on Brand > Content (insight-metric collection). It does not affect post counts; Facebook count matched TWC, so no interference. No known bug reproduced.

## Notes / deviations
- **Correction to the 2026-10-20 report:** that run recorded YouTube as "channel icon disabled for MTV / TWC YouTube Posts = 0". This run shows the `.channel-ghost.youtube` `disabled` class simply means *not currently selected*; clicking it enables YouTube and MTV has **2** YouTube video posts in this range, matching TWC. The earlier "no YouTube" conclusion was a misread of the class.
- Brand typeahead on Brand > Content showed only `Recent Searches` on the first attempt (known flaky live search); retyping in two chunks surfaced `Results`. Option lives in `.option-label` (not `.lfm-ta-option`) here.
- Publish Type Include/Exclude switch is `label[for="content_post_class_content_post_class_0"]` (`input.toggle-switch-checkbox`; checked = Exclude); clicking the pill text does nothing. Re-click Apply Filter after toggling.
- Date range: spec gives no explicit dates; used the Content default (Oct 18–24) on both sides so the counts are comparable.
- Spec step 11 lists "Video Posts" (Cross-Channel) + 4 channel Video Posts + "YouTube Posts"; the picker also has LinkedIn/Threads video metrics not in the spec — left unselected.

## Bugs filed
None.
