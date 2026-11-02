# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** dev (app.lfmdev.in) · **Data set:** Video Views (`table_data_set=video_views`) · **Date range:** app default Oct. 21 – Oct. 27, 2026 (spec names none; not changed) · **Perspective:** app default per account (Spotify: Public; Sony Pictures / Ralph Lauren: Authorized), not changed

**Verdict: BLOCKED.** The Twitter leg (A4/A5) is PASS on Ralph Lauren (7/7 posts + Sum row). The Instagram leg (A7/A8) could not be evaluated on any Thursday brand. Spotify News does not exist on dev, Sony Pictures Television has no Instagram video metrics this week, and Ralph Lauren has 0 Instagram posts. No substitute brand or date range was used.

## Pre-screen (Rule 7)
The case file's "Open linked bugs" section says none open. `results/open-bugs-2026-10-29.json` was not read (pre-fetched context gave no QA-29125 hit). The screen passed and the case was run. The pre-fetched bug-history and known-quirks greps had no QA-29125 entries. One narrow follow-up grep of known-quirks for "video views" / "spotify news" found only an unrelated Hulu Twitter In-Window skeleton-hang note, which did not occur here.

## Weekday rotation
Run day is Thursday. The Description table row lists three account/brand pairs: Spotify / Spotify News, Sony Pictures / Sony Pictures Television, Ralph Lauren / Ralph Lauren. The case's Notes block lists an older rotation ("Thu Spotify/Conde Nast"), so the Description table was treated as authoritative. Previous days ran only the first pair. Because the first pair was blocked, I ran the remaining two pairs from the same Thursday row.

## Steps executed
| # | Pair | Step | Result |
|---|------|------|--------|
| 0 | all | Login (Cognito "With existing account", config/.env) | OK, landed on `#home` |
| P | Spotify | Account precondition: account menu, typed "Spotify", clicked the exact "SPOTIFY" option | OK. `ACCOUNT: SPOTIFY`, `account_id=1030` |
| 1 | Spotify | Hover Brand, click Content | OK. Opens on default brand "Star Wars" (`02-content.png`) |
| 2 | Spotify | Add brand "Spotify News" via brand selector typeahead | **BLOCKED.** "Spotify News" returned no options (`03-brand.png`, `03c-spotify-news.png`). Typing "Spotify" returned 68 options and none is "Spotify News" (`03b-typeahead.png`). Stale typeahead ruled out because the shorter query works. |
| P | Sony | Account = Sony Pictures (exact "SONY PICTURES" option), `account_id=51` | OK |
| 1 | Sony | Brand > Content | OK |
| 2 | Sony | Brand = Sony Pictures Television (exact typeahead result, `brand_id=129863`); Data Set "Video Views" | OK (`11-sony-brand.png`) |
| 3 | Sony | Only Twitter: verified `.channel-ghost.enabled` = [twitter], Apply | OK, `channels=twitter`, **Posts (0)**, "There is no data available" (`13-sony-twitter-table.png`) |
| 4-5 | Sony | Twitter grid values | Not evaluable, no posts |
| 6 | Sony | Only Instagram: enabled = [instagram], Apply | OK, `channels=instagram`, Posts (7) (`12-sony-instagram-applied.png`) |
| 7-8 | Sony | Instagram Table View | 7 rows + Sum row. Video Views, Organic, Paid, Unclassified and Video Response Rate are "–" on every row (`13-sony-instagram-table.png`) |
| P | Ralph Lauren | Account = Ralph Lauren (exact option), `account_id=732` | OK |
| 1-2 | Ralph Lauren | Brand = Ralph Lauren (`brand_id=7000`, confirmed in `.brand-selector-name`); Data Set "Video Views" | OK (`21-rl-brand.png`) |
| 3 | Ralph Lauren | Only Twitter: enabled = [twitter], Apply | OK, `channels=twitter`, Posts (8) (`22-rl-twitter-applied.png`) |
| 4-5 | Ralph Lauren | Twitter Table View, read Organic / Paid / Unclassified / Engagements / Video Views | OK. 8 rows + Sum row (`23-rl-twitter-table.png`) |
| 6 | Ralph Lauren | Only Instagram: enabled = [instagram], Apply | OK, `channels=instagram`, **Posts (0)**, "There is no data available" (`23-rl-instagram-table.png`) |
| 7-8 | Ralph Lauren | Instagram grid values | Not evaluable, no posts |

## Data scraped

### Ralph Lauren, Twitter only (Oct 21–27, 2026)
"–" in Paid Views means no paid component (treated as 0). Unclassified shows 0. Table View read via DOM, identities evaluated in page JS.

| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Rate shown | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 12,058 | 29,776 | 29,776 | – | 0 | 29,776 | 40.50% | 40.496% |
| 2 | 7,126 | 18,060 | 18,060 | – | 0 | 18,060 | 39.46% | 39.457% |
| 3 | 383 | 4,179 | 4,179 | – | 0 | 4,179 | 9.16% | 9.165% |
| 4 | 236 | 2,251 | 2,251 | – | 0 | 2,251 | 10.48% | 10.484% |
| 5 | 182 | 1,943 | 1,943 | – | 0 | 1,943 | 9.37% | 9.367% |
| 6 | 164 | 1,989 | 1,989 | – | 0 | 1,989 | 8.25% | 8.245% |
| 7 | 111 | 1,788 | 1,788 | – | 0 | 1,788 | 6.21% | 6.208% |
| 8 | 0 | – | – | – | – | n/a | – | no video data, skipped |
| Sum | 20,260 | 59,986 | 59,986 | – | 0 | 59,986 | N/A | 33.77% (not displayed) |

Sum row: 59,986 + 0 + 0 = 59,986. Rank 8 has Engagements 0 and "–" for every video metric (a Twitter post with no video), so it is "no data" and skipped, not a failure.

### Sony Pictures Television, Instagram only (Oct 21–27, 2026)
7 posts, Engagements 21,370 / 4,047 / 1,830 / 1,216 / 417 / 297 / 51 (Sum 29,228), but Video Views, Organic, Paid, Unclassified and Video Response Rate are "–" on all 7 rows and the Sum row. The identities have no operands, so nothing can be asserted.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter) | Organic + Unclassified + Paid Views = Video Views | Ralph Lauren: 7/7 posts exact, Sum row exact, 1 post skipped (no video data). Spotify News: brand not on dev. Sony Pictures Television: 0 Twitter posts. | PASS (Ralph Lauren only) |
| A5 | 5 (Twitter) | Engagements / Video Views = Video Response Rate | Ralph Lauren: 7/7 within ±0.005 pp of the displayed 2-decimal rate (e.g. rank 1: 12,058 / 29,776 = 40.496% vs 40.50%). Sum row rate shows "N/A". | PASS (Ralph Lauren only) |
| A7 | 7 (Instagram) | Organic + Unclassified + Paid Views = Video Views | Spotify News: brand not findable. Sony Pictures Television: 7 posts, all video metrics "–". Ralph Lauren: 0 posts. | BLOCKED (no evaluable data) |
| A8 | 8 (Instagram) | Engagements / Video Views = Video Response Rate | Same as A7. | BLOCKED (no evaluable data) |

## Evidence
- `.playwright-out/QA-29125/00-home.png`, `01-account.png`, `02-content.png`
- Spotify News lookup: `03-brand.png`, `03b-typeahead.png` (68 "Spotify ..." options, none "Spotify News"), `03c-spotify-news.png`
- Sony: `10-sony-account.png`, `11-sony-brand.png`, `12-sony-twitter-applied.png`, `13-sony-twitter-table.png` (Posts (0)), `12-sony-instagram-applied.png`, `13-sony-instagram-table.png`
- Ralph Lauren: `20-rl-account.png`, `21-rl-brand.png`, `22-rl-twitter-applied.png`, `23-rl-twitter-table.png`, `22-rl-instagram-applied.png`, `23-rl-instagram-table.png` (Posts (0))
- Skill used: `brand-content-grid-math` with shared `devprod-helpers.js` (dev tab only, no prod). Console errors on the app (Facebook data-collection banner and routine dev noise) did not affect the grid.

## Known bugs checked
- Case "Open linked bugs": none. Pre-fetched bug-history / known-quirks greps: no QA-29125 entries.
- No known bug reproduced or interfered. The Facebook Data Collection Disruption banner (9/27) is shown but is irrelevant to Twitter/Instagram.
- No Jira issue-link lookup was possible (Atlassian MCP absent in headless runs); the baked-in case section was relied on.

## Bugs filed
None filed. Open items for LFIQA (test-data, not product defects):
1. **Spotify News is not available** to the LFQA user on dev under account Spotify (searched "Spotify News", "Spotify", "News"). Either the brand was renamed or removed (spec drift) or it needs ACL access. The spec's Thursday brand list may need updating. Not substituted (Rule 1).
2. **Thursday data gap for the Instagram leg.** For the default week (Oct 21–27), Sony Pictures Television has no Instagram video metrics and Ralph Lauren has no Instagram posts, so A7/A8 have no operands. A spec-approved date range with Instagram video posts would unblock it. I did not widen the range because the spec names none.
3. The case Notes block (weekday rotation) is stale versus the Description table (Thu "Spotify/Conde Nast" vs Spotify / Sony Pictures / Ralph Lauren).
