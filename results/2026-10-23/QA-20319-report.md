# QA-20319 — Brand Content > Video Views Data Set > Past date range data test - FB

**Run:** 2026-10-23 (Friday), unattended headless, Playwright MCP. Login `lfiqa@listenfirstmedia.com` (landed on Hulu, account 336).
**Weekday row executed:** Friday — Accounts Hulu / Ralph Lauren → Brands Hulu / Ralph Lauren (both legs run). The "Amazon Prime Video on alternative days" note was not applied (Friday row used as written).

## Verdict: **PASS** (both Friday legs fully evaluated; 0 failures across 257 posts + 2 aggregate rows)

| Leg | Account (id) | Brand (id) | Posts in range | Rendered/evaluated | Verdict |
|---|---|---|---|---|---|
| 1 | Hulu (336) | Hulu (5670) | 820 | 200 (+ aggregate Sum row) | **PASS** |
| 2 | Ralph Lauren (732) | Ralph Lauren (7000) | 57 | 57 (+ aggregate Sum row) | **PASS** |

Open-bug screen (Rule 7): case file says "None open" → ran normally.

## Steps executed (per leg)
1. Account: Hulu was the login default (breadcrumb `ACCOUNT: HULU`, account_id=336). For leg 2 hovered the LFQA menu → Search Account → typed "Ralph Lauren" → real mouse click on the `Results` row `.lfm-ta-option` → breadcrumb `ACCOUNT: RALPH LAUREN`, account_id=732.
2. Hovered **Brand** in the top nav → clicked **Content** (`#explore/brand/content`). The account's default brand matched the spec name exactly (Hulu brand_id=5670; Ralph Lauren brand_id=7000 — Rule 1, no substitute).
3. Data set dropdown → **Video Views** (standard set; the account-custom "Hulu Video Views" was not used). URL `table_data_set=video_views`.
4. Date range via the START DATE / END DATE picker (`button.range-display`): **Jan 01, 2024 – Dec 31, 2024** → Ok → URL `from=2024-01-01&to=2024-12-31`.
5. Channels: explicit trusted clicks disabling Twitter, Instagram, LinkedIn, TikTok (Threads/YouTube/Pinterest were already disabled) → only `.channel-ghost.facebook.enabled` left → **Apply** → URL `channels=facebook` (Rule 2 — toggles clicked, not URL-edited).
6. Switched to **Table View**; scraped header, all rendered rows and the Sum/Average aggregate row via DOM; evaluated both identities in page JS. Every rendered row carries the Facebook icon (`fa-facebook-square`): 200/200 (Hulu), 57/57 (Ralph Lauren).
   Table columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions.

## Assertions

A5: Organic Views + Paid Views + Unclassified Views = Video Views (each post, plus the aggregate row).
A6: Engagements / Video Views = Video Response Rate (each post; compared to the 2-decimal display, ±0.01 pp rounding tolerance).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-Hulu-posts | 5 | Every FB post: Organic + Paid + Unclassified = Video Views | 200 of 200 rendered posts match exactly (0 fails, 0 "–"/no-data rows). Posts (820) in range; the first 200 by rank are rendered. Post #1 (Sun Sep. 08, 2024): 1,153,027 + 0 + 0 = 1,153,027 ✔; #2 (Sat Apr. 13, 2024): 9,192,490 + 0 + 0 = 9,192,490 ✔; #3 (Wed Jul. 03, 2024): 8,657,773 + 0 + 0 = 8,657,773 ✔ | PASS |
| A5-Hulu-sum | 5 | Aggregate Sum row: Organic + Paid + Unclassified = Video Views | 339,011,556 + 37,436,938 + 3,480,687 = 379,929,181 = Video Views 379,929,181 | PASS |
| A6-Hulu-posts | 6 | Every FB post: Engagements / Video Views = Video Response Rate | 200 of 200 match (0 fails, 0 no-data). #1: 1,593,713 / 1,153,027 = 138.22% = shown 138.22% ✔; #2: 824,757 / 9,192,490 = 8.97% = 8.97% ✔; #3: 411,149 / 8,657,773 = 4.75% = 4.75% ✔ | PASS |
| A6-Hulu-sum | 6 | Aggregate: Engagements / Video Views = Video Response Rate | Aggregate Video Response Rate cell renders "N/A" (not computed on the Sum row). Computed from the row's own values: 13,017,554 / 379,929,181 = 3.43%; no displayed value to compare, so evaluated on the 200 per-post rates only | PASS (per-post; aggregate cell N/A) |
| A5-RL-posts | 5 | Every FB post: Organic + Paid + Unclassified = Video Views | 57 of 57 posts match exactly (0 fails, 0 no-data). Posts (57) in range, all rendered. #1 (Sun Aug. 11, 2024): 475,814 + 0 + 0 = 475,814 ✔; #2 (Fri Dec. 20, 2024): 271,388 + 0 + 0 = 271,388 ✔; #3 (Sat Feb. 10, 2024): 168,266 + 0 + 0 = 168,266 ✔ | PASS |
| A5-RL-sum | 5 | Aggregate Sum row: Organic + Paid + Unclassified = Video Views | 2,582,692 + 0 + 52,486 = 2,635,178 = Video Views 2,635,178 | PASS |
| A6-RL-posts | 6 | Every FB post: Engagements / Video Views = Video Response Rate | 57 of 57 match (0 fails, 0 no-data). #1: 34,714 / 475,814 = 7.30% = 7.30% ✔; #2: 15,862 / 271,388 = 5.84% = 5.84% ✔; #3: 11,550 / 168,266 = 6.86% = 6.86% ✔ | PASS |
| A6-RL-sum | 6 | Aggregate: Engagements / Video Views = Video Response Rate | Aggregate rate cell "N/A". Computed from row values: 182,976 / 2,635,178 = 6.94%; evaluated on the 57 per-post rates only | PASS (per-post; aggregate cell N/A) |

Note: the Sum/Average row aggregates all posts in range, not just the rendered 200 (Hulu), and the aggregate identity holds on its own values.

## Evidence
- `.playwright-out/QA-20319/hulu-dataset.png` — Video Views data set selected (Hulu)
- `.playwright-out/QA-20319/picker-open.png`, `picker-set.png` — date picker, Jan 01, 2024 – Dec 31, 2024
- `.playwright-out/QA-20319/hulu-fb-applied.png`, `hulu-table-view.png` — Hulu, Facebook-only Table View
- `.playwright-out/QA-20319/rl-content-default.png`, `rl-fb-applied.png`, `rl-table-view.png` — Ralph Lauren
- Final URLs: `account_id=336&brand_id=5670&from=2024-01-01&to=2024-12-31&channels=facebook&table_data_set=video_views`; `account_id=732&brand_id=7000&…` (same params).

## Known bugs checked
- Jira issue-links: case file "Open linked bugs: None open" (as of 2026-10-19 ingest). `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-20319 matches (pre-fetched).
- Related surface: the QA-27628 run (2026-10-19) recorded a possible FAIL candidate on QA-20321 (Facebook Oct 2023–Sep 2024, total Impressions/Reach with no organic/paid split) — a different metric family; it did not reproduce on the Video Views split here (no row had a total without a split).
- The Hulu "Data Collection Status" banner / FB "–" rows seen on current-week data on 2026-10-19 did not affect the 2024 range (0 no-data rows).

## Bugs filed
None.

## Notes
- Observation (not an assertion failure): the Table View Sum/Average row shows "N/A" for Video Response Rate in both legs, so the A6 aggregate cannot be compared directly; the per-post check is the evidence.
- Only the top 200 of 820 Hulu posts are rendered in Table View (a pagination limit); the remaining 620 were not evaluated individually. The aggregate Sum row (all 820) satisfies the A5 identity.
- Mechanics reused from skills `brand-content-grid-math` (Table View scrape, data-set-before-channel order), `brand-content-native-post-check` (date picker), `switch-account`. New mechanics for harvest: the LFQA user menu is NOT under `.navigation-menus`; `span` in `.menu-header-icon` at about (1190, 28) — `page.mouse.move(1190, 28)` opens it, then `pressSequentially` into `input.account-typeahead-input` and a real mouse click on the `Results` `.lfm-ta-option` switches the account. The date picker's `.datepicker-days/-months/-years` locators from the 2026-10-20 QA-20318 run work unchanged for 2024.
