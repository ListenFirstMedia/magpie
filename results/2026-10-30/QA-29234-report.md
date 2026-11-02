# QA-29234 — Brand Content > Video Views Data Set > Past date range data test - (Twitter/Instagram)

**Verdict: PASS** (Hulu / Hulu, the only brand the Friday row names). All four assertions held on every post that has video-view data. Two posts have a "–" total and were treated as no data. The Robinhood and PlayOn! Sports rotation entries have no brand in the spec, so they were not run (see "Rotation legs not run").

- Run: 2026-10-30 (Friday), unattended headless (Playwright MCP), dev `app.lfmdev.in`, user `lfiqa@listenfirstmedia.com` (Cognito "With existing account").
- Weekday row (Description table, authoritative): Friday = Accounts **Hulu / Robinhood / PlayOn! Sports**, Brands **Hulu / (blank) / (blank)**. The case `## Notes` weekday line ("Fri Hulu/Ralph Lauren") disagrees with the table; the table was used, as in the 10-27/28/29 runs. The "Amazon Prime Video on alternative days" note has no Friday row, so it was not run.
- Skill: `brand-content-grid-math` (Table View DOM scrape via `_shared/playwright-helpers/devprod-helpers.js`). Open-bug screen (Rule 7): case says "None open", so it ran normally.

| Leg | Account | Brand | Result |
|---|---|---|---|
| 1 | Hulu (account_id 336) | Hulu (brand_id 5670) | PASS |
| 2 | Robinhood | none named in spec | NOT RUN (spec gap, no substitute per Rule 1) |
| 3 | PlayOn! Sports | none named in spec | NOT RUN (spec gap, no substitute per Rule 1) |

## Steps executed (leg 1)
1. Logged in. Account menu > Search Account > typed `Hulu` > clicked the exact `Results` entry (header read back `ACCOUNT: HULU`). Hovered **Brand** > **Content** (`#explore/brand/content`). The brand selector already showed the exact name **Hulu**.
2. Data Set dropdown (visible one) > exact option **Video Views** (`table_data_set=video_views`).
3. Date picker START DATE = Jan 01, 2023, END DATE = Jan 10, 2023 (read back from `.date-range-fields`), **Ok**. URL `from=2023-01-01&to=2023-01-10`. `Posts (60)` with all channels on.
4. Twitter only: clicked the channel ghosts (Twitter was already on, the others were switched off). DOM check `enabled: ["twitter"]`, **Apply**, URL `channels=twitter`, `Posts (18)`. The spec's step 5/6 values were read from **Table View** (`L1-03-twitter-table.png`).
5. Instagram only: enabled Instagram first, then disabled Twitter (last-channel rule). DOM check `enabled: ["instagram"]`, **Apply**, URL `channels=instagram`, `Posts (19)`. Table View scrape (`L1-04-instagram-table.png`).
6. Each identity was evaluated per post in page JS. Sums must match exactly. Video Response Rate (shown as a %) must match Engagements / Video Views within 0.011 pp of the 2-decimal display.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-Hulu-Twitter | 5 | Organic Views + Paid Views = Video Views per post | 17 of 17 posts with a Video Views value match exactly (0 mismatches). Unclassified Views is 0 on every post. Post 1 (Tue Jan. 03, 2023 03:33 PM PST): 548,713 + 539,288 = 1,088,001. Sum row: 785,873 + 539,288 = 1,325,161. The per-post column totals add up to the Sum row (Video Views 1,325,161; Organic 785,873; Paid 539,288; Engagements 5,231) | PASS |
| A6-Hulu-Twitter | 6 | Engagements / Video Views = Video Response Rate per post | 17 of 17 evaluable posts match within rounding. Post 1: 2,447 / 1,088,001 = 0.2249%, shown 0.22%. Post 2: 1,037 / 52,400 = 1.979%, shown 1.98%. Post 3: 702 / 101,921 = 0.689%, shown 0.69%. Sum row Rate shows "N/A" by design | PASS |
| A8-Hulu-Instagram | 7–8 | Organic Views + Paid Views = Video Views per post | 18 of 18 posts with a Video Views value match exactly (0 mismatches). Post 1 (Tue Jan. 03, 2023 12:00 PM PST): 18,958 + 270,832 = 289,790. Sum row: 651,059 + 270,832 = 921,891 | PASS |
| A9-Hulu-Instagram | 7–9 | Engagements / Video Views = Video Response Rate per post | 18 of 18 evaluable posts match within rounding. Post 1: 13,021 / 289,790 = 4.493%, shown 4.49%. Post 2: 3,938 / 156,777 = 2.512%, shown 2.51%. Post 3: 3,553 / 85,159 = 4.172%, shown 4.17%. Sum row Rate shows "N/A" by design | PASS |

## Evidence
- Twitter, 18 posts. One post is not evaluable: Rank 18, Mon Jan. 02, 2023 02:25 PM PST, Type Video, text "You either ban together or fall apart. Stream the @abcnews H…". It has Engagements 15, with Video Views, Organic Views, Paid Views and Rate all "–". A "–" total is no data, so it was skipped and counted.
- Instagram, 19 posts. One post is not evaluable: Rank 19, Type Video, Engagements 47, with Video Views, Organic Views, Paid Views and Rate all "–". Same treatment.
- Sum rows. Twitter: Engagements 5,231 | Video Views 1,325,161 | Organic 785,873 | Paid 539,288 | Unclassified 0 | Rate N/A | Video Views (with Cross-Posts) 786,523. Instagram: Engagements 31,020 | Video Views 921,891 | Organic 651,059 | Paid 270,832 | Unclassified 0 | Rate N/A | Video Views (with Cross-Posts) 921,891.
- Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions.
- Toggles were clicked in the UI and the state read back from the DOM (`.channel-ghost.enabled`) and the URL (`channels=twitter`, then `channels=instagram`), per Rule 2.
- Screenshots in `.playwright-out/QA-29234/`: `L1-01-hulu-content.png`, `L1-02-ds-dates.png`, `L1-03-twitter-table.png`, `L1-04-instagram-table.png`. They were verified through DOM text, class and URL checks; none needed visual inspection.
- Console log: `.playwright-out/console-2026-10-30T06-31-56-963Z.log` (heavy pre-existing console-error noise on dev; nothing relevant to this case).

## Rotation legs not run
- Robinhood and PlayOn! Sports appear on the Friday row, but the Brand column lists only "Hulu" followed by a blank. With no named brand there is nothing to select, and Rule 1 forbids inventing one (for example the account's same-named brand). These legs are not counted in the verdict. The spec owner should add the brand names, or trim the row.

## Known bugs checked
- Case file "Open linked bugs": None open. Pre-fetched `bug-history.md` / `known-quirks.md` greps for QA-29234: none for Friday. The only quirk entries naming this case concern the Wednesday rotation (NBCU not in the account list, Apple Music data floor), which does not apply to Hulu.
- Hulu rendered promptly (no render hang) and no known bug interfered with any assertion. Nothing observed is a regression.

## Bugs filed
None.

## Notes for harvest / spec owner
- Hulu's Jan 01–10, 2023 window has real video data on both channels (Twitter 18 posts / 1.33M views; Instagram 19 posts / 0.92M views), so unlike the Sony Pictures Television leg on 10-29 this gives a meaningful check of A5, A6, A8 and A9.
- Each channel has one Video post with Engagements but "–" for every view metric (Twitter Rank 18, Instagram Rank 19). Treated as no data per the `brand-content-grid-math` rule. Worth a glance if that is unexpected collection behaviour.
- The Friday row lists only one brand for three accounts, and the case `## Notes` weekday line disagrees with the Description table. Both should be fixed in the case.
