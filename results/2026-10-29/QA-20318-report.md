# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Verdict: BLOCKED (partial — 2 of 3 Thursday legs PASS; Spotify News leg BLOCKED on test data)** — Sony Pictures Television and Ralph Lauren satisfy Reactions + Comments + Shares = Engagements on every evaluated Facebook post and on the aggregate Sum row for Jan 01 – Dec 31, 2023. The Spotify account's brand "Spotify News" does not exist in the brand typeahead, so that leg could not be run on the exact spec configuration (Rule 1: no substitution). No product defect found.

- Run: 2026-10-29 (Thursday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on HULU after login).
- Weekday row executed: Thursday — Accounts Spotify / Sony Pictures / Ralph Lauren → Brands Spotify News / Sony Pictures Television / Ralph Lauren (Description table is authoritative; the case-file Notes weekday line is stale).
- Skill: `brand-content-grid-math` (Table View DOM scrape) via `_shared/playwright-helpers/devprod-helpers.js` (dev tab only).
- Open-bug screen (Rule 7): case file says "None open" → ran normally.

| Leg | Account | Brand | Spec range Jan 01 – Dec 31, 2023 | Verdict |
|---|---|---|---|---|
| 1 | Spotify (account_id 1030) | Spotify News | n/a — brand not findable | BLOCKED (test-data) |
| 2 | Sony Pictures (51) | Sony Pictures Television (129863) | Selected via picker; URL `from=2023-01-01&to=2023-12-31` | PASS |
| 3 | Ralph Lauren (732) | Ralph Lauren (7000) | Selected via picker; URL `from=2023-01-01&to=2023-12-31` | PASS |

## Steps executed
1. Logged in via Cognito "With existing account" (`#home`, ACCOUNT: HULU).
2. Per leg: switched account via the account menu → Search Account (result ok for SPOTIFY, SONY PICTURES, RALPH LAUREN), hovered Brand → Content from the top nav (`#explore/brand/content`).
3. **Leg 1:** Brand selector → typed `Spotify News` (slow, 120 ms/char, up to 24 s wait): no `.lfm-ta-option`. Also tried `Spotify N` (nothing) and `Spotify` (124 results: 49 "Spotify (Country)" brands, "<Name> (Spotify)" sub-brands, Life at Spotify, Spotify - GOSS, Cares, Design, Engineering, K-Pop, Live, Platform, Podcasts, Policy, Songwriting, Sub-Handles Roll-Up, Wrapped 2025, for Advertisers/Artists/Creators/Podcasters). **No "Spotify News".** The account's default brand was "ThisisSpotify" (not a spec brand, not used). Screenshots: `spotify-1-brand.png`, `spotify-2-typeahead.png`, `spotify-3-probe.png`.
4. **Leg 2:** Brand selector showed the exact `Sony Pictures Television` (brand_id 129863) after the account switch. Opened the date picker (START/END): 2023 months Jan–Dec all enabled (no retention floor). Clicked START → Jan 01, 2023, END → Dec 31, 2023, OK; picker fields read `START DATE Jan 01, 2023 / END DATE Dec 31, 2023`.
5. Clicked the Facebook channel ghost explicitly (Rule 2) and Apply: `.channel-ghost.enabled` = `facebook` only; header `Posts (161)`; URL `channels=facebook`, `table_data_set=public`, `perspective=extended`.
6. Switched to Table View (`table.lfm-table` with `Rank` header), scraped all rows via DOM, evaluated Reactions + Comments + Shares vs Engagements per post and on the Sum row.
7. **Leg 3:** same as 2 for `Ralph Lauren` (brand_id 7000). START cell `day`, END cell `active selected range-end day`; fields read Jan 01, 2023 / Dec 31, 2023; Facebook only; `Posts (265)`; Table View renders the top 200 of 265 (page cap).

## Assertions

Assertion 5: Reactions + Comments + Shares = Engagements (each grid post; aggregate Sum row).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-SpotifyNews | 2–5 | Account Spotify → brand "Spotify News", Jan 01 – Dec 31, 2023, FB only; every post R + C + S = Engagements | Brand "Spotify News" not in typeahead (0 matches for 3 queries; 124 "Spotify" results listed, none named Spotify News). Nothing evaluable | BLOCKED (test-data: spec brand not findable) |
| A5-SonyPicturesTV (posts) | 5 | Every FB post: R + C + S = Engagements | 161 / 161 posts match, 0 failures, 0 "–" components, 0 skipped. #1 (Fri Nov. 17, 2023): 12,133 + 63 + 869 = 13,065; #2 (Tue Nov. 07, 2023): 8,315 + 88 + 924 = 9,327 | PASS |
| A5-SonyPicturesTV (aggregate) | 5 | Sum row R + C + S = Engagements | 43,260 + 675 + 3,408 = 47,343 = Engagements 47,343 | PASS |
| A5-RalphLauren (posts) | 5 | Every FB post: R + C + S = Engagements | 200 / 200 rendered posts match (of 265 total), 0 failures, 0 "–" components, 0 skipped. #1 (Mon Mar. 13, 2023): 10,780 + 430 + 474 = 11,684; #2 (Sun Dec. 31, 2023): 9,608 + 179 + 1,333 = 11,120 | PASS |
| A5-RalphLauren (aggregate) | 5 | Sum row R + C + S = Engagements | 258,214 + 6,967 + 17,055 = 282,236 = Engagements 282,236 | PASS |

## Evidence
- URLs at assertion time: Sony `brand_id=129863&account_id=51&from=2023-01-01&to=2023-12-31&channels=facebook&perspective=extended&table_data_set=public`; Ralph Lauren `brand_id=7000&account_id=732&from=2023-01-01&to=2023-12-31&channels=facebook&perspective=extended&table_data_set=public`.
- Table headers (both legs): Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions.
- Screenshots in `.playwright-out/QA-20318/`: `spotify-1-brand.png`, `spotify-2-typeahead.png`, `spotify-3-probe.png`, `sony-1-brand.png`, `sony-2-picker.png`, `sony-3-dates.png`, `sony-4-fb-table.png`, `rl-1-brand.png`, `rl-3-dates.png`, `rl-4-fb-table.png`. None were opened; state was verified through DOM text, URL, and class checks (picker fields, `.channel-ghost.enabled`, `Posts (N)`).
- Console: the dev app logs many console errors (`.playwright-out/console-2026-10-29T06-43-59-573Z.log`); none affected the grids.

## Scope note
Table View caps at 200 rows per page. Sony (161 posts) is fully covered; Ralph Lauren covers the top 200 of 265 by Engagements (the Sum row covers the full filtered set and also balances).

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` had no QA-20318 match; `known-quirks.md` QA-20318 matches concern the Wednesday rotation / Apple Music data floor only (not Thursday). Nothing reproduced.
- The Apple Music data floor (Oct 26, 2023) does not apply to the Thursday brands: Sony Pictures Television and Ralph Lauren both allow Jan 2023.
- Spotify News absence is an account/test-data gap (Rule 1, "spec drift / brand not on dev"), not a product bug.

## Bugs filed
None.

## Notes for harvest / spec owner
- "Spotify News" is not findable on dev under the Spotify account (or typeahead search by `Spotify` / `Spotify N` / `News`). Ask the spec owner to confirm the brand name (possible rename/removal) or restore it; rerun picks the leg up automatically once it exists.
- The account menu landed on HULU after login, so the account switch is required for each leg; `m.switchAccount` worked for all three Thursday accounts.
- The Sony and Ralph Lauren brand selector already showed the spec brand after the account switch (account default brand); the exact name was verified in `.brand-selector-name` per Rule 1.
- Case-file Notes weekday rotation (Thu = Spotify / Conde Nast) disagrees with the Description table (Thu = Spotify, Sony Pictures, Ralph Lauren); the Description table was followed.
