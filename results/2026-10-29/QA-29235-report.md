# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in), login `lfiqa@listenfirstmedia.com` via Cognito "With existing account" · **Data set:** Video Views (`table_data_set=video_views`) · **Date range:** Jan 01, 2024 – Dec 31, 2024 · **Channel:** TikTok only (`channels=tiktok`) · **View:** Table View · **Skill:** `brand-content-grid-math`

**Verdict: BLOCKED (spec brand "Spotify News" not findable on dev). The other two Thursday account/brand pairs PASS.**

| Thursday pair (case Description table) | Verdict |
|---|---|
| Spotify → Spotify News | BLOCKED: brand not in the typeahead; no substitute used (Rule 1) |
| Sony Pictures → Sony Pictures Television | PASS (139/139 posts, both identities) |
| Ralph Lauren → Ralph Lauren | PASS (200/200 evaluated of 296 posts, both identities) |

The case lists three accounts for Thursday, and "Spotify News" belongs to the first. The overall verdict is BLOCKED because one in-spec pair could not be run. The two pairs that did run showed no defect.

## Pre-screen
- Case file "Open linked bugs (as of 2026-10-20)": none open, so the Rule 7 screen passed.
- Pre-fetched bug-history and known-quirks greps for QA-29235: no entries.
- Case-file inconsistency: the Notes line says "Thu Spotify/Conde Nast", but the Description table says Thursday = Spotify / Sony Pictures / Ralph Lauren (brands Spotify News / Sony Pictures Television / Ralph Lauren). The Description table is the spec and was followed. The Notes mapping looks stale.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login, then account switch via the profile menu "Search Account" | OK for all three accounts (`ACCOUNT: SPOTIFY` / `SONY PICTURES` / `RALPH LAUREN`) |
| 1 | Hover Brand in the top nav, click Content | OK for all three |
| 2a | Spotify: brand selector, typed "Spotify News" (80 ms/char, waited 8 s) | **Typeahead returned no results.** "Spotify New" returned only `New (Spotify)`, `Spotify (Australia/New Zealand)`, `synecdoche new york (Spotify)`. "Spotify" returned `Spotify (Africa)`, `Spotify (Arabia)` and similar regional brands. The account default brand is "ThisisSpotify" (brand_id=343324). BLOCKED, no substitute |
| 2b | Sony Pictures: typed "Sony Pictures Television", clicked the exact result | OK, brand_id=129863. Data Set dropdown, "Video Views" |
| 2c | Ralph Lauren: typed "Ralph Lauren", clicked the exact result | OK, brand_id=7000. Data Set dropdown, "Video Views". Page sat on "Loading" for about 150 s after the brand switch, then one reload recovered it (see Notes) |
| 3 | Date picker: START Jan 01, 2024, END Dec 31, 2024 | OK, `from=2024-01-01&to=2024-12-31` |
| 4 | Channel toggles: clicked off every channel except TikTok, then Apply | OK, `.channel-ghost.enabled` = [tiktok], `channels=tiktok` |
| 5-6 | Table View (`[title="Table View"]`), scraped `table.lfm-table` (Rank header present), evaluated identities in page JS | OK |

Data set was selected before the channel, per the skill. The final URL for both runs carried `table_data_set=video_views`, `channels=tiktok`, `from=2024-01-01&to=2024-12-31`, `perspective=extended`.

## Data (Table View, TikTok, Video Views data set)
Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions.

### Sony Pictures Television (account Sony Pictures, account_id=51)
- Posts (139); 139 rows scraped. The Channel cell is the `fa-tiktok` icon on 139/139 rows, so no other channel appears.
- Post dates span Jan 03, 2024 – Dec 11, 2024.
- Rank 1 (Wed Dec 11, 2024): Engagements 552,802 / Video Response Rate 9.76% / Video Views 5,662,902 / Organic – / Paid – / Unclassified 5,662,902. 552,802 / 5,662,902 = 9.762%.
- Rank 2 (Fri Nov 01, 2024): 257,274 / 13.96% / 1,842,535 / – / – / 1,842,535. 257,274 / 1,842,535 = 13.963%.
- Rank 3 (Mon Nov 04, 2024): 118,737 / 18.13% / 654,821 / – / – / 654,821. 118,737 / 654,821 = 18.133%.
- Sum row: Engagements 1,883,321 · Video Response Rate N/A · Video Views 30,122,155 · Organic – · Paid – · Unclassified 30,122,155 · Video Views (with Cross-Posts) 30,122,155.
- Column totals over the 139 posts: Σ Video Views 30,122,155, Σ Unclassified 30,122,155, Σ Engagements 1,883,321. These match the Sum row exactly.
- Organic Views and Paid Views are "–" on 139/139 posts; Unclassified Views is numeric on 139/139.

### Ralph Lauren (account Ralph Lauren, account_id=732)
- Posts (296). The table renders 200 posts per page, so 200 rows (ranks 1-200) were scraped; 96 rows were not rendered. The Channel cell is the `fa-tiktok` icon on 200/200 rows.
- Rank 1 (Sat Sep 07, 2024): Engagements 2,239,281 / 16.71% / Video Views 13,400,000 / Organic – / Paid – / Unclassified 13,400,000. 2,239,281 / 13,400,000 = 16.710%.
- Rank 2 (Mon Jul 15, 2024): 210,977 / 30.15% / 699,700 / – / – / 699,700. 210,977 / 699,700 = 30.153%.
- Sum row (all 296 posts): Engagements 3,979,377 · Video Response Rate N/A · Video Views 53,654,670 · Organic – · Paid – · Unclassified 53,654,670 · Video Views (with Cross-Posts) 53,654,670.
- Column totals over the 200 rendered rows: Σ Video Views 51,427,900, Σ Engagements 3,933,160. These are below the Sum row, as expected, because 96 posts were not rendered.
- Organic Views and Paid Views are "–" on 200/200 rows; Unclassified Views is numeric on 200/200.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-Sony | 5 | Organic + Unclassified + Paid Views = Video Views, in each grid post | 139/139 exact, 0 mismatches, 0 skipped. Organic and Paid are "–" (no data, treated as 0) on all posts, so the identity reduces to Unclassified = Video Views, e.g. rank 1: 5,662,902 = 5,662,902. Sum row: 30,122,155 = 30,122,155 | PASS |
| A6-Sony | 6 | Engagements / Video Views = Video Response Rate | 139/139 within ±0.0051 pp of the 2-decimal display, 0 mismatches, 0 skipped. Samples above | PASS |
| A5-RL | 5 | Organic + Unclassified + Paid Views = Video Views, in each grid post | 200/200 rendered posts exact, 0 mismatches, 0 skipped. Organic and Paid "–" on all, so Unclassified = Video Views, e.g. rank 1: 13,400,000 = 13,400,000. Sum row (296 posts): 53,654,670 = 53,654,670. Ranks 201-296 not rendered, so not individually evaluated | PASS (200 of 296 posts) |
| A6-RL | 6 | Engagements / Video Views = Video Response Rate | 200/200 within ±0.0051 pp of the 2-decimal display, 0 mismatches, 0 skipped. Samples above | PASS (200 of 296 posts) |
| A5/A6-Spotify | 2, 5, 6 | Spotify News brand selectable; same identities | Brand "Spotify News" not in the typeahead on the Spotify account. Steps 3-6 not run for this pair | BLOCKED |

Organic Views and Paid Views are "–" on every TikTok post for both brands, so the Organic/Paid/Unclassified identity holds only because all views are classified as Unclassified. Product behavior was not judged defective; this matches the structural-absence pattern in the grid-math skill (TikTok has no organic/paid split).

## Evidence
- `.playwright-out/QA-29235/01-brand-attempt.png`: Spotify account, brand selector before the search.
- `.playwright-out/QA-29235/02-brand-Spotify_News.png`, `02-brand-Spotify_New.png`, `02-brand-News.png`: typeahead results for each query. "Spotify News" shows no options.
- `.playwright-out/QA-29235/10-sony-setup.png`, `11-sony-table.png`: Sony Pictures Television setup and Table View.
- `.playwright-out/QA-29235/20-rl-stuck.png`, `20-rl-after-wait.png`, `22-rl-after-reload.png`: Ralph Lauren "Loading" hang and recovery after reload.
- `.playwright-out/QA-29235/20-rl-setup.png`, `21-rl-table.png`: Ralph Lauren setup and Table View.
- All numbers were read from the `table.lfm-table` DOM. Screenshots were saved but not visually inspected; no verdict depended on one.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29235 entries. No known bug reproduced or interfered with the assertions.
- Dev slowness: the Ralph Lauren Brand > Content page stayed on "Loading" for about 150 s after the brand switch. One reload brought it back in about 20 s (52 posts). This is a transient dev load issue, not a render-hang call, since it recovered within the step budget.
- The console showed errors on the app pages throughout; none related to the table data, and they were not investigated.

## Bugs filed
None filed. Possible test-data gap for the QA team to confirm: the brand "Spotify News" (named in the case Description for Thursday) does not exist in the typeahead under the Spotify account on dev. It may have been renamed or removed, or may sit under an account the lfiqa user cannot see (Rule 1, reasons 1/2/4). The case's Notes line (Thu "Spotify/Conde Nast") disagrees with its Description table and should be reconciled.
Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- `brand-content-grid-math` reused unchanged for the two executed pairs (pass_streak +1; no new mechanics). Video Views data set columns confirmed: Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts).
- Ralph Lauren TikTok 2024 renders 200 of 296 posts (page limit), so only the top 200 ranks were individually evaluated.
