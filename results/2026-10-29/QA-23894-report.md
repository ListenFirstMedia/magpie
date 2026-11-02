# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Date:** 2026-10-29 (Thursday) · **Mode:** unattended headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Verdict: PASS** (one noted Public-data-set observation, same as the 2026-10-26 / 27 / 28 runs — see "Observations")

## Screening
- Case file "Open linked bugs": **None open** -> Rule 7 screen passed, case executed.
- Pre-fetched context: no QA-23894 entries in `knowledge-base/bug-history.md` or `known-quirks.md`; no skill pre-resolved in REGISTRY. Used `brand-content-grid-math` (Table View DOM scrape) per the case notes, plus `switch-account`.

## Setup actually used
- Login: Cognito "With existing account" (lfiqa). Landed on account 657; switched to **UCLA** via the profile menu (`input.account-typeahead-input`, click on the exact `UCLA` option under `.typeahead-options-list`; the list offered `UCLA` and `UCLA Law`) -> `account_id=799`, breadcrumb `ACCOUNT: UCLA` (`02-account-typeahead.png`).
- **Brand (Rule 1):** the UCLA account's primary brand is **University of California, Los Angeles** (brand_id 127756) — the same brand every prior UCLA data-test run used for "UCLA Brand". I opened the brand selector on both Insights and Content, typed the full name into the "Search for a Brand" textarea, saw the live exact-name Result (`04-brand-typeahead.png`, `10-content-brand-typeahead.png`) and clicked it. No other brand substituted.
- Perspective left at the app default (`perspective=extended`, "Authorized data"; Content `table_data_set=public`, `stats_attribution_window=lifetime`); the spec names no perspective.
- Date range: **Last 30 Days** chosen via date pill -> "Make a Selection" dropdown -> Last 30 Days (`06-date-overlay.png`, `06b-make-selection.png`, `07-last30-selected.png`). Resolved to **Sep. 28, 2026 – Oct. 27, 2026** (URL `from=2026-09-28&to=2026-10-27`). Brand Content inherited the same range.

## Steps executed
1. Brand > Insights opened via top nav (Brand -> Insights).
2. Brand University of California, Los Angeles selected from typeahead; "Last 30 Days" chosen.
3. Channel selector: clicked LinkedIn with a real mouse click -> state `linkedin enabled`, all others `disabled` (`08c-channels-linkedin-only.png`); Apply -> URL `channels=linkedin`.
4. Noted the **Best Performing Content (Lifetime)** (BPC) tile, Sort: Engagements, 5 posts (`09-insights-bpc.png`). Insights shows `New Posts: 129 (+3%)`.
5. Navigated Brand > Content via top nav (brand/date range carried over; channels came back as the 6-channel default).
6. Brand University of California, Los Angeles re-selected from the typeahead on Content.
7. Disabled Facebook/Twitter/Instagram/TikTok/Threads by real clicks, left **LinkedIn only** (`11-content-channels.png`), Apply -> `channels=linkedin`, `Posts (129)` (`12-content-linkedin.png`).
8. Table View: first load showed "This table failed to load" (`13b-content-view.png`); clicked Reload once, table rendered (130 rows = 129 posts + Sum/Average row; `14-content-table-after-reload.png`). Compared each BPC post with its Content row (date/time, type, text, LinkedIn permalink URNs for Content rows, Engagements, Reactions, Comments, Shares). Also checked the Video Views data set for the one differing field (`15b-content-videoviews-ds.png`; it also needed one Reload click).

## BPC (Brand Insights) vs Brand Content — per post
| BPC # | Date (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|
| 1 | Sat Oct 24 11:52 AM | Image | 1,624 = 1,624 | 1,572 = 1,572 | 32 = 32 | 20 = 20 | n/a |
| 2 | Thu Oct 01 12:07 PM | Image | 1,331 = 1,331 | 1,262 = 1,262 | 26 = 26 | 43 = 43 | n/a |
| 3 | Mon Oct 26 12:00 PM | Video | 966 = 966 | 919 = 919 | 18 = 18 | 29 = 29 | BPC 8,790; Content Public DS "–"; Content **Video Views DS 8,790** |
| 4 | Tue Oct 20 08:46 AM | Image | 881 = 881 | 860 = 860 | 12 = 12 | 9 = 9 | n/a |
| 5 | Wed Oct 14 09:14 AM | Video | 855 = 855 | 787 = 787 | 54 = 54 | 14 = 14 | BPC 11,141; Content Public DS "–"; Content **Video Views DS 11,141** |

Content Table rank order (1–5 by Engagements) equals the BPC order; post text and type identical. Content Table rows 1–5 link to LinkedIn URNs 7519833185157910528, 7511501952472510464, 7520560053410603008, 7518336754203066368, 7516169500598149120 (the BPC tile exposes no LinkedIn hrefs, so BPC posts were matched on date/time + text + type + metrics). Content Sum row (Public DS): Engagements 15,455 · Reactions 14,609 · Comments 305 · Shares 541 over **129 posts** = Insights `New Posts: 129`.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights, LinkedIn, Last 30 Days) matches Brand Content posts data | 5/5 BPC posts found in Content with identical rank, date, type, Engagements, Reactions, Shares, Comments. The only field not shown in Content's default (Public) data set is Video Views for the two video posts (BPC 8,790 and 11,141 vs "–"); Content's Video Views data set shows the identical 8,790 and 11,141 (Organic/Paid "–", Unclassified = total, Video Views with Cross-Posts = same). Insights New Posts 129 = Content Posts (129). | **PASS** (note) |

## Observations (not a verdict-changer, not filed)
- On the default Brand Content **Public** data set both LinkedIn video posts (#3, #5) show Video Views "–" in Table View, while BPC shows 8,790 / 11,141. Same posts carry identical figures in the **Video Views** data set. Treated as a data-set display difference; underlying figures match. Same observation as the 2026-10-26 / 27 / 28 runs; raise with product only if Public is expected to show LinkedIn Video Views.
- Lifetime-attribution values drift slightly day to day (e.g. post …7519833185157910528 Engagements 1,470 on 10-28 vs 1,624 today), but Insights and Content agree with each other within the same session.
- Brand Content Table View and the Video Views data set each showed "This table failed to load" on first render; a single Reload click recovered both (no BLOCKED, no render-hang).
- Clicking an unselected channel on Insights when four channels were enabled made it the only enabled channel (exclusive select); clicking the four others afterwards re-enabled them. Final LinkedIn-only state was verified from `.channel-ghost` classes and the `channels=linkedin` URL.
- Console reported many app errors (50+ on Content); none affected the rendered data or the comparison.

## Known bugs checked
- Case "Open linked bugs": none. `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-23894 entries (pre-fetched).
- Related surface bugs from sibling LinkedIn/Twitter comparison cases (LFMP-31958, LFMP-32113, per the earlier run reports) concern other channels/comparisons and were not exercised; nothing reproduced for LinkedIn.

## Bugs filed
None (markdown-only policy; nothing new filed).

## Evidence
`.playwright-out/QA-23894/`: 02-account-typeahead, 03-insights-landing, 04-brand-typeahead, 05-after-brand, 06-date-overlay, 06b-make-selection, 07-last30-selected, 08c-channels-linkedin-only, 09-insights-bpc, 10-content-brand-typeahead, 11-content-channels, 12-content-linkedin, 13b-content-view, 14-content-table-after-reload, 15b-content-videoviews-ds (.png); `insights-bpc-links.json`, `content-table-top.json`.
