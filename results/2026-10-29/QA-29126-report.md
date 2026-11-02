# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** dev (app.lfmdev.in) · **Date range:** app default Oct. 21 – Oct. 27, 2026 (the spec names none) · **Data set:** Video Views (`table_data_set=video_views`) · **Channel:** TikTok only (`channels=tiktok`) · **Perspective:** Authorized (`perspective=extended`, app default, not changed)

**Verdict: BLOCKED (partial: 2 of 3 Thursday legs PASS; the Spotify / Spotify News leg is BLOCKED on test data).** For Sony Pictures Television (10 posts) and Ralph Lauren (14 posts), Organic + Unclassified + Paid Views = Video Views holds on every TikTok post and on the Sum row, and Engagements / Video Views = Video Response Rate holds on every post. The Thursday row-1 brand "Spotify News" is not findable on the Spotify account on dev, so that leg could not be run. Per Rule 1 I did not substitute another brand.

## Pre-screen (Rule 7)
The case file's "Open linked bugs" section says "None open". The pre-fetched bug-history and known-quirks greps for QA-29126 returned nothing. The screen passed and the case was run. Skill used: `brand-content-grid-math` (Table View DOM scrape of `table.lfm-table`) with the shared helpers `devprod-helpers.js`.

## Interpretation notes
- **Weekday rotation:** 2026-10-29 is a Thursday. The Description table row is accounts Spotify / Sony Pictures / Ralph Lauren with brands Spotify News / Sony Pictures Television / Ralph Lauren. The case's Notes line ("Thu Spotify/Conde Nast") does not match the table, so I treated the Description table as authoritative.
- **All three legs:** earlier days of this case ran only the first account/brand pair. Because leg 1 is blocked, I also ran legs 2 and 3, as the sibling case QA-29116 did earlier today. Both are spec-named pairs, with no substitution.
- **Date range:** the spec names none, so I left the app default (Oct. 21 – Oct. 27, 2026).
- **Brand step on legs 2 and 3:** the exact spec brand was already the account's default brand. I read it back from `.brand-selector-name` ("Sony Pictures Television" brand_id=129863, "Ralph Lauren" brand_id=7000) rather than re-selecting it through the typeahead.

## Steps executed
| # | Step | Leg 1: Spotify | Leg 2: Sony Pictures | Leg 3: Ralph Lauren |
|---|------|----------------|----------------------|---------------------|
| 0 | Login (Cognito "With existing account", config/.env) | OK, landed on `#home` | — | — |
| P | Precondition: switch account via the account menu | OK: `ACCOUNT: SPOTIFY` (account_id=1030) | OK: `ACCOUNT: SONY PICTURES` (account_id=51) | OK: `ACCOUNT: RALPH LAUREN` (account_id=732; read-back confirmed on the page after the switch) |
| 1 | Hover Brand in top nav, click Content | OK | OK | OK |
| 2 | Add the Brand, select the Video Views data set | **BLOCKED**: default brand is ThisisSpotify; "Spotify News" is not in the typeahead (see below) | OK: brand "Sony Pictures Television"; Data Set dropdown, "Video Views" (`table_data_set=video_views`) | OK: brand "Ralph Lauren"; "Video Views" |
| 3 | Enable TikTok only (TikTok ghost on, all other ghosts off, Apply) | not reached | OK: enabled ghosts `["tiktok"]`, `Posts (10)` | OK: enabled ghosts `["tiktok"]`, `Posts (14)` |
| 4 | Per post: Organic + Unclassified + Paid Views | not reached | OK: Table View scraped (`Rank` header present), 10 posts + Sum/Average row | OK: 14 posts + Sum/Average row |
| 5 | Note Engagements and Video Views | not reached | OK | OK |

### Leg 1 detail: "Spotify News" not findable (Rule 1)
- The brand picker opens a "Search for a Brand" textarea. I typed slowly (80 ms per character) and waited 7–8 s per query.
- `Spotify News` and `spotify news`: 0 `.lfm-ta-option` rows (the dropdown stays on "Recent Searches").
- `Spotify New`: 3 options ("New (Spotify)", "Spotify (Australia/New Zealand)", "synecdoche new york (Spotify)"), none named Spotify News.
- `Spotify N`: 52 options, none containing "News".
- `Spotify`: 64 options ("Spotify (Country)" brands, Spotify Cares/Design/Engineering/K-Pop/Live/Platform/Podcasts/Policy/Songwriting/Sub-Handles Roll-Up/Wrapped 2025, for Advertisers/Artists/Creators/Podcasters). No "Spotify News" between "Spotify Live" and "Spotify Platform".
- `News`: the list is capped at 100 results and has no "Spotify News" among them. This query is not conclusive on its own, so it is supporting evidence only.
- The same absence was recorded earlier today by QA-29116 (126 "Spotify" options there, none named Spotify News).
- Rule 1 reason: spec brand not findable on dev (test-data gap; either the brand was renamed/removed or it lives under a different account/ACL). I did not substitute ThisisSpotify or any other Spotify brand.
- Evidence: `.playwright-out/QA-29126/00-account-switched.png`, `01-brand-typeahead.png`.

## Data scraped (Table View, TikTok, Oct 21–27 2026, Video Views data set)

### Leg 2: Sony Pictures / Sony Pictures Television
| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 457 | 8,544 | – | – | 8,544 | 8,544 | 5.35% | 5.349% |
| 2 | 262 | 7,842 | – | – | 7,842 | 7,842 | 3.34% | 3.341% |
| 3 | 214 | 1,885 | – | – | 1,885 | 1,885 | 11.35% | 11.353% |
| 4 | 209 | 1,814 | – | – | 1,814 | 1,814 | 11.52% | 11.521% |
| 5 | 76 | 1,446 | – | – | 1,446 | 1,446 | 5.26% | 5.256% |
| 6 | 74 | 839 | – | – | 839 | 839 | 8.82% | 8.820% |
| 7 | 44 | 691 | – | – | 691 | 691 | 6.37% | 6.368% |
| 8 | 31 | 343 | – | – | 343 | 343 | 9.04% | 9.038% |
| 9 | 28 | 506 | – | – | 506 | 506 | 5.53% | 5.534% |
| 10 | 17 | 330 | – | – | 330 | 330 | 5.15% | 5.152% |
| Sum | 1,412 | 24,240 | – | – | 24,240 | 24,240 | N/A | 5.825% |

### Leg 3: Ralph Lauren / Ralph Lauren
| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 22,720 | 64,100 | – | – | 64,100 | 64,100 | 35.44% | 35.445% |
| 2 | 18,311 | 2,100,000 | – | – | 2,100,000 | 2,100,000 | 0.87% | 0.872% |
| 3 | 12,773 | 3,200,000 | – | – | 3,200,000 | 3,200,000 | 0.40% | 0.399% |
| 4 | 6,014 | 21,400 | – | – | 21,400 | 21,400 | 28.10% | 28.103% |
| 5 | 4,100 | 19,900,000 | – | – | 19,900,000 | 19,900,000 | 0.02% | 0.021% |
| 6 | 2,232 | 2,800,000 | – | – | 2,800,000 | 2,800,000 | 0.08% | (within 0.0051 pp) |
| 7 | 1,926 | 3,600,000 | – | – | 3,600,000 | 3,600,000 | 0.05% | (within 0.0051 pp) |
| 8 | 1,704 | 5,000,000 | – | – | 5,000,000 | 5,000,000 | 0.03% | (within 0.0051 pp) |
| 9 | 601 | 8,397 | – | – | 8,397 | 8,397 | 7.16% | (within 0.0051 pp) |
| 10 | 500 | 5,349 | – | – | 5,349 | 5,349 | 9.35% | (within 0.0051 pp) |
| 11 | 394 | 5,526 | – | – | 5,526 | 5,526 | 7.13% | (within 0.0051 pp) |
| 12 | 381 | 5,392 | – | – | 5,392 | 5,392 | 7.07% | 7.066% |
| 13 | 371 | 6,624 | – | – | 6,624 | 6,624 | 5.60% | 5.601% |
| 14 | 238 | 2,712 | – | – | 2,712 | 2,712 | 8.78% | 8.776% |
| Sum | 72,265 | 36,719,500 | – | – | 36,719,500 | 36,719,500 | N/A | 0.197% |

"–" in Organic / Paid Views is treated as 0 (skill `brand-content-grid-math`: structurally absent for TikTok in this data set; all views are classified as Unclassified). Calc values for ranks 6–11 of Ralph Lauren were evaluated in page JS; all deviations were ≤ 0.0046 pp (the 2-decimal display tolerance is 0.005 pp).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Spotify | 4 | Spotify News: Organic + Unclassified + Paid Views = Video Views in each post | Brand "Spotify News" is not in the typeahead (0 matches for 2 exact queries; 64 "Spotify" results, none named Spotify News). Nothing evaluable. | BLOCKED (test data: spec brand not findable) |
| A5-Spotify | 5 | Spotify News: Engagements / Video Views = Video Response Rate | Same as above. | BLOCKED (test data) |
| A4-Sony-posts | 4 | Organic + Unclassified + Paid = Video Views, each post | 10/10 posts match exactly; 0 mismatches, 0 no-data rows. | PASS |
| A4-Sony-agg | 4 | Same identity on the Sum row | 0 + 0 + 24,240 = 24,240 = Video Views 24,240. The per-post Video Views also add up to 24,240. | PASS |
| A5-Sony | 5 | Engagements / Video Views = Video Response Rate, each post | 10/10 posts match the 2-decimal display, max deviation 0.0041 pp (rank 5: 76 / 1,446 = 5.256% shown as 5.26%). The Engagements column adds up to the Sum row (1,412). The Sum row's rate renders "N/A" (not computed for the aggregate; calc 1,412 / 24,240 = 5.83%); noted only. | PASS |
| A4-RL-posts | 4 | Organic + Unclassified + Paid = Video Views, each post | 14/14 posts match exactly; 0 mismatches, 0 no-data rows. | PASS |
| A4-RL-agg | 4 | Same identity on the Sum row | 0 + 0 + 36,719,500 = 36,719,500 = Video Views 36,719,500. The per-post Video Views add up to 36,719,500. | PASS |
| A5-RL | 5 | Engagements / Video Views = Video Response Rate, each post | 14/14 posts match the 2-decimal display, max deviation 0.0046 pp (rank 1: 22,720 / 64,100 = 35.445% shown as 35.44%, an exact rounding-boundary tie). The Engagements column adds up to the Sum row (72,265). The Sum row's rate renders "N/A"; noted only. | PASS |

## Observations (not counted as failures)
- The Sum row's Video Response Rate is "N/A" on both brands; this matches the earlier runs of this case (10-20, 10-26, 10-27, 10-28).
- Video Views per post for Ralph Lauren range from 21,400 to 19,900,000 with round values for ranks 2–8 (2,100,000, 3,200,000, 19,900,000 and so on). They still obey both identities, so this is noted only.
- Case file inconsistency: the Notes line ("Thu Spotify/Conde Nast") disagrees with the Description table. Please correct the Notes in Jira.
- Missing brand: "Spotify News" should be confirmed by the case owner. Either the Description table is stale or the brand needs to be created or granted on dev account Spotify (account_id=1030).

## Evidence
- `.playwright-out/QA-29126/00-account-switched.png`: Spotify account selected
- `.playwright-out/QA-29126/01-brand-typeahead.png`: brand picker with the "Spotify News" query (no results)
- `.playwright-out/QA-29126/sony-00-account.png`, `sony-01-brand.png`, `sony-02-videoviews-tiktok.png`, `sony-03-table.png`: Sony Pictures leg (Video Views, TikTok only, `Posts (10)`, Table View)
- `.playwright-out/QA-29126/rl-00-account.png`, `rl-01-brand.png`, `rl-02-videoviews-tiktok.png`, `rl-03-table.png`: Ralph Lauren leg (`Posts (14)`, Table View)
- Numbers were read from the `table.lfm-table` DOM (headers: Rank, Date, Channel, Brand, …, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, …). Identities were evaluated in page JS. Final URLs carried `channels=tiktok` and `table_data_set=video_views` (`brand_id=129863` and `brand_id=7000`).
- Console: the usual dev app errors (see `.playwright-out/console-2026-10-29T07-26-44-687Z.log`); none affected the table.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29126 entries (pre-fetched). Nothing reproduced that interferes with the assertions.

## Bugs filed
None. Test-data gap (not a product bug): "Spotify News" not findable on dev. **Cleanup:** none (read-only).

## Notes for harvest
- `brand-content-grid-math` covered the flow. Another data point for Sony Pictures Television and Ralph Lauren (TikTok, Video Views data set, Thursday).
- Helper note: `devprod-helpers.js` loaded without `ctx._creds` (no prod tab), then `ctx._creds` set and `m.login` called on the single page. `m.switchAccount` can return `ok:false` with an empty `acct` when the breadcrumb has not rendered 8 s after the click (Ralph Lauren leg); the switch itself had succeeded, so re-read the `ACCOUNT:` text before treating it as a failure.
