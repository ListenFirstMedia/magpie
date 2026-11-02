# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-27; account Viacom / account_id=181, brand MTV, Authorized data, Oct 19 – Oct 25 2026)

## Setup
- Login: app.lfmdev.in programmatic email/password login (`config/.env`; lands on account 336), then switched to **Viacom** via the profile dropdown `Search Account` -> real mouse click on the `.lfm-ta-option` -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181`.
- Brand > Content landed with default range **Oct 19 – Oct 25, 2026**, View = **Authorized data** (`perspective=extended`; toggle on the Authorized side in `01-content` screenshot), Data Set = Public, Include Retweets unchecked. Left untouched.
- TWC: Absolute Dates (tab clicked explicitly), Oct 19 – Oct 25, 2026 (calendars `range-start`=19 / `range-end`=25, both OCTOBER 2026; report header `Time Window Comparison (Oct 19, 2026 - Oct 25, 2026)`), Interval = **Aggregate**, MTV per-brand toggle clicked to **Authorized Data** (`0-perspective-toggle` false -> true).
- Infra note: the first navigation to app.lfmdev.in hung (60 s timeout, then the MCP browser stopped responding for ~1 h). After the tool aborted, the next `browser_navigate` worked normally; no product defect implied.

## Steps executed
1. Hover Brand -> Content: `#explore/brand/content?brand_id=4018&account_id=181`.
2. Clicked the brand chevron (`.brand-selector-name-container`) -> typed "MT" then "V" in `textarea[placeholder="Search for a Brand"]` -> clicked the exact **MTV** `.option-label` (`brand_id=4018`). `02-brand-dropdown.png`.
3. Channel = **Facebook only** (enabled `.channel-ghost` = facebook only; other channels clicked off after enabling Facebook) -> Apply.
   - Spec NOTE (FB only): Filter -> **Publish Type -> Reel** -> Apply Filter (`06-reel-applied`, `not:"false"`) -> flipped the Include/Exclude switch (`label[for="content_post_class_content_post_class_0"]`, checked = Exclude) -> Apply Filter again; URL carries `content_post_class ... values:["reel"], not:"true"` (`07-reel-excluded.png`).
4. Filter -> **Content Type**.
5. Selected **Video** -> **Apply Filter**. URL filters: `content_post_class not:true [reel]` + `content_types [Video] not:false`. Pills: `Publish Type: Reel` (Exclude), `Content Type: Video`.
6. Noted post count: Facebook **Posts (11)** (`08-fb-video-posts.png`).
   Repeat per spec for the other channels (Content Type = Video kept; each channel selected exclusively, Apply): Twitter **6**, Instagram **11**, TikTok **15**, YouTube **2** (`09-twitter`, `09-instagram`, `09-tiktok`, `09-youtube` screenshots). The Reel-exclude pill is Facebook-only; the app drops it when switching channel (URL filters then contain only `content_types=Video`).
7. Hover Reporting -> menu lists Home / Dashboards / Listening / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics — there is **no separate "Classic reporting" item** (legacy spec wording); went directly to Time Window Comparison.
8. TWC builder `app-reporting.lfmdev.in/#/time_window_comparison` (`20-twc-builder.png`).
9. Added **MTV** (exact option from typeahead Results, not MTV (Africa) etc.), clicked per-brand toggle to Authorized Data (`21`, `22` screenshots).
10. Absolute Dates, Interval = Aggregate (`23-twc-interval.png`).
11. Metrics selected (checked state verified): Cross-Channel Video Posts, Facebook Video Posts, Twitter Video Posts, Instagram Video Posts, TikTok Video Posts, YouTube Posts (`25-metrics-selected.png`; Content group reads 5/6 in the "Video Posts" search view — LinkedIn Video Posts deliberately unselected — plus YouTube Posts = true).
12. **Show Metrics Graphs** deselected (true -> false, `26-graphs-off.png`); Show Metrics Tables left on.
13. Run Report -> story `#story/time_window_comparison/161824`.
14. Compared values (below). One TWC report with all six metrics covers every channel's comparison.

## Brand > Content counts (Content Type = Video, Oct 19–25 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **11** | `08-fb-video-posts.png` |
| Twitter | **6** | `09-twitter.png` |
| Instagram | **11** | `09-instagram.png` |
| TikTok | **15** | `09-tiktok.png` |
| YouTube | **2** (app auto-switched Data Set to `youtube_only:_basic`) | `09-youtube.png` |

## TWC report values (story 161824, MTV Authorized, Aggregate, Oct 19 – Oct 25 2026)
Video Posts **45** · Facebook Video Posts **11** · Twitter Video Posts **6** · Instagram Video Posts **11** · TikTok Video Posts **15** · YouTube Posts **2**
Evidence: `27-twc-report.png` + DOM scrape of the six single-row `Brand | Value` tables (graphs not rendered, as expected with Show Metrics Graphs off). Internal check: 11 + 6 + 11 + 15 + 2 = 45 = TWC cross-channel Video Posts (LinkedIn/Threads contribute 0).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A14-FB | 14 | Content Facebook Video count == TWC Facebook Video Posts | Content 11 == TWC 11 | PASS |
| A14-TW | 14 | Content Twitter == TWC Twitter Video Posts | 6 == 6 | PASS |
| A14-IG | 14 | Content Instagram == TWC Instagram Video Posts | 11 == 11 | PASS |
| A14-TT | 14 | Content TikTok == TWC TikTok Video Posts | 15 == 15 | PASS |
| A14-YT | 14 | Content YouTube == TWC YouTube Posts | 2 == 2 | PASS |
| A14-ALL | 14 | Sum of per-channel Content counts == TWC Video Posts | 11+6+11+15+2 = 45 == 45 | PASS |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). Pre-fetched `bug-history.md` / `known-quirks.md` greps: no entries for QA-79963.
- During the run: orange "Facebook Data Collection Disruption 9/27" banner on Brand > Content (insight-metric collection). Does not affect post counts; Facebook count matched TWC, so no interference. No known bug reproduced.

## Notes / deviations
- Window differs from the 2026-10-26 run (Oct 18–24: FB 11 / TW 7 / IG 11 / TT 15 / YT 2 / total 46) because the app default week rolled forward; Twitter dropped 7 -> 6, total 46 -> 45, both sides consistent each time.
- Brand typeahead on Brand > Content: the brand `textarea` is `textarea[placeholder="Search for a Brand"]` and only becomes visible after clicking the name chevron (`.brand-selector-name-container`); the `Results` header text did not appear this time but the exact `MTV` `.option-label` rendered at the top of the list.
- Spec gives no explicit dates; used the Content default (Oct 19–25) on both sides; TWC absolute dates picked up the same range by default.
- Spec step 11 lists "Video Posts" (Cross-Channel) + 4 channel Video Posts + "YouTube Posts"; the picker also has LinkedIn Video Posts, not in the spec — left unselected.

## Bugs filed
None.
