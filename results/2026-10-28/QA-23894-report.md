# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Date:** 2026-10-28 (Wednesday) · **Mode:** unattended headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Verdict: PASS** (one noted Public-data-set observation, same as the 2026-10-26 / 2026-10-27 runs — see "Observations")

## Screening
- Case file "Open linked bugs": **None open** -> Rule 7 screen passed, case executed.
- Pre-fetched context: no QA-23894 entries in `knowledge-base/bug-history.md` or `known-quirks.md`.

## Setup actually used
- Login: Cognito "With existing account" (lfiqa). Landed on account 634; switched to **UCLA** via the profile menu (`input.account-typeahead-input`, real click on the exact `UCLA` option scoped to `.typeahead-options-list`) -> `account_id=799`, breadcrumb `ACCOUNT: UCLA`.
- **Brand (Rule 1):** typing `UCLA` in the brand typeahead lists many `UCLA ...` sub-brands (UCLA - Ambassadors Roll-Up, UCLA Alumni, UCLA Anderson, ... UCLA Updates, UCLA Volunteer Center) but **no brand named exactly "UCLA"**; "University of California, Los Angeles" appeared only under Recent Searches for that query (`03-brand-typeahead.png`). The UCLA account's primary brand is **University of California, Los Angeles** (brand_id 127756) — the same brand every prior UCLA data-test case used. I typed its name, confirmed a live typeahead Result (`03b-brand-typeahead-full.png`) and clicked the exact-name option (`brand_id=127756`) on both Insights and Content (`08-content-brand-typeahead.png`). No other brand substituted; this is the interpretation of "UCLA Brand".
- Perspective/View left at the app default (`perspective=extended`, "Authorized data"; Content `table_data_set=public`, `stats_attribution_window=lifetime`); the spec names no perspective.
- Date range: **Last 30 Days** = Sep. 27, 2026 – Oct. 26, 2026 (date pill -> "Make a Selection" dropdown -> Last 30 Days; `04-date-overlay.png`, `04c-make-selection.png`, `05-after-last30-select.png`). URL `from=2026-09-27&to=2026-10-26`. Brand Content inherited the same range on navigation.

## Steps executed
1. Brand > Insights opened via top nav (Brand -> Insights).
2. Brand University of California, Los Angeles selected from the typeahead; "Last 30 Days" chosen (Sep 27 – Oct 26, 2026).
3. Channel selector: clicked LinkedIn -> state `linkedin enabled`, all others `disabled`; Apply -> URL `channels=linkedin` (`06-insights-linkedin.png`).
4. Noted the **Best Performing Content (Lifetime)** (BPC) tile, Sort: Engagements, 5 posts (`07-insights-bpc.png`, `insights-bpc.json`). Insights tile shows `New Posts: 129 (+3%)`.
5. Navigated Brand > Content via top nav (brand_id and date range carried over; channels came back as the 6-channel default).
6. Brand University of California, Los Angeles re-selected from the typeahead on Content.
7. Disabled Facebook/Twitter/Instagram/TikTok/Threads by real clicks, left **LinkedIn only** (`linkedin enabled`, rest `disabled`), Apply -> `channels=linkedin`, `Posts (129)` (`09-content-linkedin.png`).
8. Switched to Table View (130 rows = 129 posts + Sum/Average row; `10-content-table.png`), matched each BPC post to its Content row by LinkedIn permalink URN and compared every shown field in page JS. Also checked the Video Views data set for the one differing field (`11-content-videoviews-ds.png`).

## BPC (Brand Insights) vs Brand Content — per post
| BPC # | Post (LinkedIn URN) | Date (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|---|
| 1 | ...7519833185157910528 | Sat Oct 24 11:52 AM | Image | 1,470 = 1,470 | 1,421 = 1,421 | 30 = 30 | 19 = 19 | n/a |
| 2 | ...7511501952472510464 | Thu Oct 01 12:07 PM | Image | 1,330 = 1,330 | 1,261 = 1,261 | 26 = 26 | 43 = 43 | n/a |
| 3 | ...7518336754203066368 | Tue Oct 20 08:46 AM | Image | 868 = 868 | 848 = 848 | 12 = 12 | 8 = 8 | n/a |
| 4 | ...7516169500598149120 | Wed Oct 14 09:14 AM | Video | 854 = 854 | 786 = 786 | 54 = 54 | 14 = 14 | BPC 11,118; Content Public DS "–"; Content **Video Views DS 11,118** |
| 5 | ...7520560053410603008 | Mon Oct 26 12:00 PM | Video | 737 = 737 | 705 = 705 | 11 = 11 | 21 = 21 | BPC 6,969; Content Public DS "–"; Content **Video Views DS 6,969** |

Content Table rank order (1–5 by Engagements) equals the BPC order; all 5 posts found by permalink; date/time and type identical. Content Sum row: Engagements 15,590 · Reactions 14,726 · Comments 329 · Shares 535 over **129 posts** = Insights `New Posts: 129`.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights, LinkedIn, Last 30 Days) matches Brand Content posts data | 5/5 BPC posts found in Content with identical rank, date, type, Engagements, Reactions, Shares, Comments. The only field not shown in Content's default (Public) data set is Video Views for the two video posts (BPC 11,118 and 6,969 vs "–"); Content's Video Views data set shows the identical 11,118 and 6,969 (Organic/Paid "–", Unclassified = total). Insights New Posts 129 = Content Posts (129). | **PASS** (note) |

## Observations (not a verdict-changer, not filed)
- On the default Brand Content **Public** data set both LinkedIn video posts (#4, #5) show Video Views "–" in Table View, while BPC shows 11,118 / 6,969. The same posts carry the identical figures in the **Video Views** data set (Video Views = Video Views with Cross-Posts = Unclassified Views). Treated as a data-set display difference (Public set carries no LinkedIn view counts); underlying figures match. If product expects the Public table to show LinkedIn Video Views, raise with product — flagged here, not filed.
- Lifetime-attribution BPC values drift slightly day to day (e.g. post …7511501952472510464 Engagements 1,331 on 10-26 vs 1,330 today), but Insights and Content agree with each other within the same session.
- Console reported many app errors (50+ on Content); none affected the rendered data or the comparison.
- Brand typeahead: the "UCLA" query returns no exact-name brand and only surfaces the primary brand under Recent Searches; the full name must be typed to get a live Result (no product impact on this case).

## Known bugs checked
- Case "Open linked bugs": none. `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-23894 entries (pre-fetched); one known-quirks grep for LinkedIn video/views/public data set found nothing that applies (only the Monday no-LinkedIn-posts note for other brands; UCLA had 129 posts).
- Related surface bugs from sibling LinkedIn/Twitter comparison cases (LFMP-31958, LFMP-32113) concern other channels/comparisons and were not exercised; nothing reproduced for LinkedIn.

## Bugs filed
None (markdown-only policy; nothing new filed).

## Evidence
`.playwright-out/QA-23894/`: 02-insights-landing, 03-brand-typeahead, 03b-brand-typeahead-full, 04-date-overlay, 04c-make-selection, 05-after-last30-select, 06-insights-linkedin, 07-insights-bpc, 08-content-brand-typeahead, 09-content-linkedin, 10-content-table, 11-content-videoviews-ds (.png); `insights-bpc.json`.
