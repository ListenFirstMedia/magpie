# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Date:** 2026-10-27 (Tuesday) · **Mode:** unattended headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Verdict: PASS** (one noted Public-data-set observation, same as the 2026-10-26 run; see "Observations")

## Screening
- Case file "Open linked bugs": **None open** -> Rule 7 screen passed, case executed.
- `results/open-bugs-2026-10-27.json` has no QA-23894 entry.

## Setup actually used
- Login: Cognito "With existing account" (lfiqa). Landed on account Viacom (181); switched to **UCLA** via the profile menu (`input.account-typeahead-input`, real click on the exact `UCLA` option) -> `account_id=799`, breadcrumb `ACCOUNT: UCLA`.
- **Brand (Rule 1):** typing `UCLA` in the brand typeahead lists many `UCLA ...` sub-brands (UCLA - Ambassadors Roll-Up, UCLA Alumni, UCLA Anderson, ...) but **no brand named exactly "UCLA"** (`02-brand-typeahead.png`). The UCLA account's primary brand is **University of California, Los Angeles** (brand_id 127756). This is how the project's other UCLA cases map the account (e.g. QA-20268/20269 tables, `brand-content-native-post-check` skill). I selected it by exact-name click from the typeahead (`03-typeahead-ucb.png`) on both Insights and Content. No other brand was substituted; this is the interpretation of "UCLA Brand", same as the 2026-10-26 run.
- Perspective left at the app default (`perspective=extended`, Authorized); the spec names none. Content `table_data_set=public`, `stats_attribution_window=lifetime`.
- Date range: **Last 30 Days** = Sep. 26, 2026 - Oct. 25, 2026 (picked via date pill -> "Make a Selection" -> Last 30 Days; `04c-make-selection.png`, `05-after-last30-select.png`). URL `from=2026-09-26&to=2026-10-25`. Brand Content inherited the same range.

## Steps executed
1. Brand > Insights opened via top nav (Brand -> Insights).
2. Brand University of California, Los Angeles selected from the typeahead; "Last 30 Days" chosen (Sep 26 - Oct 25, 2026).
3. Channel selector: only LinkedIn enabled (all other ghosts `disabled`), Apply -> URL `channels=linkedin` (`06-insights-linkedin-bpc.png`).
4. Noted the **Best Performing Content (Lifetime)** tile, Sort: Engagements, 5 posts. Insights tile also shows `New Posts: 127`.
5. Navigated Brand > Content via top nav.
6. Brand University of California, Los Angeles re-selected from the typeahead (the global search routes to Insights with the brand set, so Content was re-opened from the nav; brand_id 127756 and date range held).
7. Disabled Facebook/Twitter/Instagram/TikTok/Threads, left **LinkedIn only**, Apply -> `channels=linkedin`, `Posts (127)` (`08-content-linkedin.png`).
8. Switched to Table View (128 rows = 127 posts + Sum/Average row; `09-content-table.png`), matched each BPC post to its Content row by LinkedIn permalink URN and compared every shown field. Also checked the Video Views data set for the one differing field (`10-content-videoviews-ds.png`).

## BPC (Brand Insights) vs Brand Content - per post
| BPC # | Post (LinkedIn URN) | Date (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|---|
| 1 | ...7511501952472510464 | Thu Oct 01 12:07 PM | Image | 1,331 = 1,331 | 1,262 = 1,262 | 26 = 26 | 43 = 43 | n/a |
| 2 | ...7519833185157910528 | Sat Oct 24 11:52 AM | Image | 1,270 = 1,270 | 1,229 = 1,229 | 22 = 22 | 19 = 19 | n/a |
| 3 | ...7518336754203066368 | Tue Oct 20 08:46 AM | Image | 870 = 870 | 848 = 848 | 14 = 14 | 8 = 8 | n/a |
| 4 | ...7516169500598149120 | Wed Oct 14 09:14 AM | Video | 851 = 851 | 784 = 784 | 53 = 53 | 14 = 14 | BPC 11,084; Content Public DS "-"; Content **Video Views DS 11,084** |
| 5 | ...7512540048236576769 | Sun Oct 04 08:52 AM | Gallery | 673 = 673 | 653 = 653 | 13 = 13 | 7 = 7 | n/a |

Content Table rank order (1-5 by Engagements) equals the BPC order; every post found by permalink; post text, date/time and type identical. Content Sum row: Engagements 14,951 · Reactions 14,083 · Comments 325 · Shares 543 over **127 posts** = Insights `New Posts: 127`.
Day-over-day note: lifetime counters moved since 2026-10-26 (e.g. post #2 882 -> 1,270 engagements, post #4 views 11,072 -> 11,084). Both surfaces moved together in this run.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights, LinkedIn, Last 30 Days) matches Brand Content posts data | 5/5 BPC posts found in Content with identical rank, date, type, Engagements, Reactions, Shares, Comments. The only field not shown in Content's default (Public) data set is the video post's Video Views (BPC 11,084 vs "-"); Content's Video Views data set shows the identical 11,084. Insights New Posts 127 = Content Posts (127). | **PASS** (note) |

## Observations (not a verdict-changer, not filed)
- On the default Brand Content **Public** data set the LinkedIn video post (#4) shows Video Views "-" in Table View (and Sum row "-"), while BPC shows 11,084. The **Video Views** data set carries 11,084 for the same post (Video Views 11,084; Unclassified Views 11,084; Organic/Paid "-"; Viewers 10,728; Watch Time 2,335.84 min). Treated as a data-set display difference; the underlying figure matches. Same observation as 2026-10-26. If product expects the Public table to show LinkedIn Video Views, raise with product. Flagged, not filed.
- Console reported many app errors (30-60 per page); none affected the rendered data or the comparison.
- Facebook Data Collection Disruption banner (9/27) was present; not relevant to LinkedIn.

## Known bugs checked
- Case "Open linked bugs": none. `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-23894 entries (pre-fetched). `results/open-bugs-2026-10-27.json`: no entry for this case. No known bug reproduced or interfered.

## Bugs filed
None (markdown-only policy; nothing new filed).

## Evidence
`.playwright-out/QA-23894/`: 01-insights-landing, 02-brand-typeahead, 03-typeahead-ucb, 04-date-overlay, 04b-date-overlay, 04c-make-selection, 05-after-last30-select, 06-insights-linkedin-bpc, 07-content-landing, 08-content-linkedin, 09-content-table, 10-content-videoviews-ds (.png).
