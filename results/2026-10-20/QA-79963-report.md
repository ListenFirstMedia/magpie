# QA-79963 — Brand > Content Vs Reporting > TWC Post Count Data QA

**Verdict: PASS** (headless unattended run, 2026-10-20, account Viacom / account_id=181, brand MTV)

## Setup
- Login: app.lfmdev.in programmatic email/password login with `config/.env` creds (landed on account 799), then switched to **Viacom** via the profile dropdown (`Results` entry) -> breadcrumb `ACCOUNT: VIACOM`, `account_id=181`.
- Date range (Brand > Content default, left untouched): **Oct 12 – Oct 18, 2026**, View = **Authorized data** (`perspective=extended`), Data Set = Public, Include Retweets unchecked.
- TWC date range: Absolute Dates, default range already **Oct 12 – Oct 18, 2026** (calendar `range-start`=12, `range-end`=18, confirmed in the built-report header `Time Window Comparison (Oct 12, 2026 - Oct 18, 2026)`), Interval = **Aggregate**.

## Steps executed
1. Hover Brand -> Content: landed on `#explore/brand/content?brand_id=4018&account_id=181` (MTV).
2. Brand dropdown -> typed "MTV" -> clicked exact **MTV** option (first result; `brand_id=4018`).
3. Channel = Facebook only (disabled Twitter/Instagram/TikTok/LinkedIn/Threads, verified `.channel-ghost.facebook.enabled` only) -> Apply. Facebook, all content types: Posts (14).
   - FB-only note: Filter -> **Publish Type -> Reel -> toggled Exclude** (pill `Publish Type: Reel`, Exclude, `content_post_class ... not:true` in URL).
4. Filter -> **Content Type**.
5. Selected **Video** -> **Apply Filter**.
6. Post count noted per channel (table below).
7. Hover Reporting -> **Time Window Comparison** (see Notes: no separate "Classic reporting" label exists in the current nav).
8. TWC builder (`app-reporting.lfmdev.in/#/time_window_comparison`).
9. Added **MTV** from `Results` typeahead (exact "MTV"), clicked the per-brand toggle to **Authorized Data** (`0-perspective-toggle` checked=true, screenshot 19).
10. **Absolute Dates** clicked, Interval = **Aggregate**.
11. Metrics selected (each `aria-checked=true`): Video Posts, Facebook Video Posts, Twitter Video Posts, Instagram Video Posts, TikTok Video Posts, YouTube Posts.
12. **Show Metrics Graphs** deselected (aria-checked=false); Show Metrics Tables left on.
13. Run Report -> story `#story/time_window_comparison/161411`.
14. Compared values.

"Repeat for Twitter / Instagram / TikTok / YouTube": Content counts were read per channel (Content Type = Video, Publish Type pill dropped — the Reel exclude is Facebook-only and the app removed that pill when switching channel). The TWC report was built **once** with all six metrics, which covers every channel's comparison in a single report (the repeat would rebuild the identical report).

## Brand > Content counts (Content Type = Video, Oct 12–18 2026, Authorized)
| Channel | Posts (N) | Evidence |
|---|---|---|
| Facebook (Reel excluded) | **5** | `.playwright-out/QA-79963/10-fb-video-posts.png` |
| Twitter | **9** | `11-twitter.png` |
| Instagram | **7** | `12-instagram.png` |
| TikTok | **12** | `12-tiktok.png` |
| YouTube | n/a — channel icon **disabled** for MTV (greyed in both Authorized and Public views; also with filters cleared; Public view = brand_id 10765, still no YouTube) | `13-youtube-disabled-hover.png`, `14-public-view-channels.png` |
| All channels (FB, TW, IG, LI, TT, Threads) | **33** | `15-all-channels-video.png` |

Cross-check: 5 + 9 + 7 + 12 = 33 (LinkedIn/Threads contribute 0 video posts).

## TWC report values (story 161411, MTV Authorized, Aggregate, Oct 12 – Oct 18 2026)
Video Posts **33** · Facebook Video Posts **5** · Twitter Video Posts **9** · Instagram Video Posts **7** · TikTok Video Posts **12** · YouTube Posts **0**
Evidence: `21-metrics-selected.png`, `24-twc-report-loaded.png` (+ DOM scrape of the six single-row `Brand | Value` tables).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A14-FB | 14 | Brand Content Facebook Video post count == TWC Facebook Video Posts | Content 5 == TWC 5 | PASS |
| A14-TW | 14 | Content Twitter == TWC Twitter Video Posts | 9 == 9 | PASS |
| A14-IG | 14 | Content Instagram == TWC Instagram Video Posts | 7 == 7 | PASS |
| A14-TT | 14 | Content TikTok == TWC TikTok Video Posts | 12 == 12 | PASS |
| A14-YT | 14 | Content YouTube == TWC YouTube Posts | Content: YouTube channel not available for MTV (disabled); TWC YouTube Posts = 0 — consistent (no YouTube content either side) | PASS (see note) |
| A14-ALL | 14 | Content all-channel Video count == TWC Video Posts | 33 == 33 | PASS |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `knowledge-base/bug-history.md` / `known-quirks.md`: no entries for QA-79963.
- During the run: a "Facebook Posts Insights Disruption" banner is shown on Brand > Content (insights-metric collection issue). It affects insight metrics, not post counts; Facebook post count matched TWC, so it did not interfere with the assertions. No known bug reproduced.

## Notes / deviations
- The current Reporting menu lists Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics directly; there is no separate "Classic reporting" item (spec wording is legacy). Clicked Time Window Comparison from the Reporting menu.
- The spec's step 11 list names five "Video Posts" metrics + "YouTube Posts"; the picker also has a `LinkedIn Video Posts` metric that the spec doesn't list — it was left unselected.
- YouTube: MTV has no enabled YouTube channel in Brand > Content, so the YouTube leg is only "no data on both sides"; flag for LFIQA if a YouTube-capable MTV feed is expected (test-data note, not a product bug).
- The Facebook Reel-exclude changed nothing numerically here (Content-Type=Video all-channel total 33 = 5+9+7+12 holds either way).
- Typing "Posts" accidentally landed in the competitive-set-name input (index 2) once; it was cleared (`inputValue()==''`) before building the report — no effect on the report.

## Bugs filed
None.
