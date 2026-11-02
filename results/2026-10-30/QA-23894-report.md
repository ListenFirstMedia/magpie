# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Date:** 2026-10-30 (Friday) · **Mode:** unattended headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Verdict: PASS** (one noted Public-data-set observation, same as the 2026-10-26 to 10-29 runs — see "Observations")

## Screening
- Case file "Open linked bugs": **None open** -> Rule 7 screen passed, case executed.
- Pre-fetched context: no QA-23894 entries in `knowledge-base/bug-history.md` or `known-quirks.md`; no skill pre-resolved. Used `brand-content-grid-math` (Table View DOM scrape, per the case notes) and `switch-account`.

## Setup actually used
- Login: Cognito "With existing account" (lfiqa). Landed on account 54 (Adam Orfei); switched to **UCLA** via the profile menu (`Search Account` textbox, typed `UCLA`, clicked the exact `UCLA` entry under `.typeahead-options-list`; list offered `UCLA` and `UCLA Law`) -> `account_id=799`, breadcrumb `ACCOUNT: UCLA` (`04-account-ucla.png`).
- **Brand (Rule 1):** the UCLA account's brand is **University of California, Los Angeles** (brand_id 127756), the same brand all prior UCLA data-test runs used for "UCLA Brand". On both Insights and Content I opened the brand selector, typed the full name into "Search for a Brand", saw the live Results (`University of California, Los Angeles` and `... Police`) and clicked the exact-name entry (`07-brand-typeahead.png`, `12-content-brand-typeahead.png`). No substitute brand.
- Perspective left at the app default (`perspective=extended`, "Authorized data"); the spec names none. Content `table_data_set=public`, `stats_attribution_window=lifetime`.
- Date range: **Last 30 Days** chosen via date pill -> "Make a Selection" dropdown -> Last 30 Days (`08-date-overlay.png`, `09-last30-selected.png`). Resolved to **Sep. 29, 2026 – Oct. 28, 2026** (URL `from=2026-09-29&to=2026-10-28`). Brand Content inherited the same range.

## Steps executed
1. Brand > Insights opened via top nav (Brand -> Insights).
2. Brand University of California, Los Angeles selected from typeahead; "Last 30 Days" chosen.
3. Channel selector: real click on LinkedIn -> `.channel-ghost` states: `linkedin enabled`, all 11 others `disabled`; Apply -> URL `channels=linkedin`.
4. Noted the **Best Performing Content (Lifetime)** tile, Sort: Engagements, 5 posts (`10-insights-bpc.png`, `insights-bpc-2026-10-30.json`).
5. Navigated Brand > Content via top nav (brand/range carried over; channels reverted to the 6-channel default).
6. Brand University of California, Los Angeles re-selected from the typeahead on Content.
7. Disabled Facebook/Twitter/Instagram/TikTok/Threads by real clicks, left **LinkedIn only** (state verified from `.channel-ghost` classes), Apply -> `channels=linkedin`, `Posts (129)`.
8. Table View: rendered on first load this time (no Reload needed), 130 rows = 129 posts + Sum/Average row (`13-content-table-linkedin.png`). Compared each BPC post with its Content row (date/time, type, text, Engagements, Reactions, Comments, Shares). Also checked the Video Views data set for the one differing field (`14-content-videoviews-ds.png`, rendered without a Reload).

## BPC (Brand Insights) vs Brand Content — per post
| BPC # | Date (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|
| 1 | Sat Oct 24 11:52 AM | Image | 1,778 = 1,778 | 1,722 = 1,722 | 34 = 34 | 22 = 22 | n/a |
| 2 | Thu Oct 01 12:07 PM | Image | 1,331 = 1,331 | 1,262 = 1,262 | 26 = 26 | 43 = 43 | n/a |
| 3 | Mon Oct 26 12:00 PM | Video | 1,064 = 1,064 | 1,009 = 1,009 | 22 = 22 | 33 = 33 | BPC 9,646; Content Public DS "–"; Content **Video Views DS 9,646** |
| 4 | Tue Oct 20 08:46 AM | Image | 883 = 883 | 862 = 862 | 12 = 12 | 9 = 9 | n/a |
| 5 | Wed Oct 14 09:14 AM | Video | 855 = 855 | 787 = 787 | 54 = 54 | 14 = 14 | BPC 11,148; Content Public DS "–"; Content **Video Views DS 11,148** |

Content Table rank order (1–5 by Engagements) equals the BPC order; post text and type are identical. Content Sum row (Public DS): Engagements 15,787 · Reactions 14,924 · Comments 309 · Shares 554 over **129 posts**. In the Video Views DS, Organic/Paid Views are "–", Unclassified Views = Video Views = Video Views (with Cross-Posts) for these posts (30 video posts, Sum 150,126).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights, LinkedIn, Last 30 Days) matches Brand Content posts data | 5/5 BPC posts found in Content with identical rank, date, type, text, Engagements, Reactions, Shares, Comments. The only field not shown in Content's default (Public) data set is Video Views for the two video posts (BPC 9,646 and 11,148 vs "–"); Content's Video Views data set shows the identical 9,646 and 11,148. | **PASS** (note) |

## Observations (not a verdict-changer, not filed)
- On the default Brand Content **Public** data set both LinkedIn video posts (#3, #5) show Video Views "–" in Table View, while BPC shows 9,646 / 11,148. The same posts carry identical figures in the **Video Views** data set. Treated as a data-set display difference; underlying figures match. Same observation as the 2026-10-26 to 10-29 runs; raise with product only if Public is expected to show LinkedIn Video Views.
- Lifetime-attribution values drift slightly day to day (e.g. post #1 Engagements 1,624 on 10-29 vs 1,778 today; the range shifted by a day), but Insights and Content agree with each other within the same session.
- Brand Content Table View and the Video Views data set both rendered on first load today (no "This table failed to load"); no Reload was needed.
- On Insights, clicking LinkedIn while four channels were enabled made it the only enabled channel (exclusive select); final LinkedIn-only state verified from `.channel-ghost` classes and the `channels=linkedin` URL.
- Insights `New Posts` was not re-read this run; the Content `Posts (129)` count was the one checked.
- Console reported many app errors (50+ on Content); none affected the rendered data or the comparison.

## Known bugs checked
- Case "Open linked bugs": none. `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-23894 entries (pre-fetched).
- Related LinkedIn/Twitter comparison bugs noted in earlier run reports concern other channels/comparisons; nothing reproduced for LinkedIn.

## Bugs filed
None (markdown-only policy; nothing new filed).

## Evidence
`.playwright-out/QA-23894/`: 01-home, 04-account-ucla, 05-insights-landing, 06-brand-click, 07-brand-typeahead, 08-date-overlay, 09-last30-selected, 10-insights-bpc, 11-content-brand-open, 12-content-brand-typeahead, 13-content-table-linkedin, 14-content-videoviews-ds (.png); `insights-bpc-2026-10-30.json`.
