# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Login:** `lfiqa@listenfirstmedia.com` (Cognito "With existing account") · **Date range:** app default week 2026-10-21 .. 2026-10-27 (spec gives no dates, left unchanged) · **Channel:** TikTok only · **Data set:** Public (`table_data_set=public`) · **Perspective:** Authorized (default `extended`)

**Verdict: BLOCKED (partial: 2 of 3 Thursday legs PASS; the Spotify News leg is BLOCKED on test data)** — Reactions + Comments + Shares = Engagements holds on every TikTok post and on the aggregate Sum row for Sony Pictures Television (10/10) and Ralph Lauren (16/16). The Thursday row-1 brand "Spotify News" cannot be found on the Spotify account, so that leg could not be run. Under Rule 1 I did not substitute another brand, so the case cannot end as a full PASS.

## Pre-screen (Rule 7)
The case file's "Open linked bugs" section says "None open". The pre-fetched bug-history match for QA-29123 was empty. `results/open-bugs-2026-10-29.json` was not consulted. The screen passed and the case was run.

## Interpretation notes
- **Weekday rotation:** 2026-10-29 is a Thursday. The Description table row is Spotify / Sony Pictures / Ralph Lauren, with brands Spotify News / Sony Pictures Television / Ralph Lauren. The case Notes line ("Thu Spotify/Conde Nast") does not match the table, so I treated the Description table as authoritative and ran all three legs.
- **Date range:** the ticket gives none. The app's default week was left unchanged, as in earlier runs of this case.
- **Skill:** `brand-content-grid-math` (Table View DOM scrape, identity evaluated in page JS) with the shared helpers (`devprod-helpers.js`, `set-helpers.js`).

## Steps executed
| # | Step | Spotify (leg 1) | Sony Pictures (leg 2) | Ralph Lauren (leg 3) |
|---|------|-----------------|-----------------------|----------------------|
| 0 | Login | OK, landed on `#home` | — | — |
| P | Precondition: switch account via the account menu | OK — `ACCOUNT: SPOTIFY` (account_id=1030) | OK — `ACCOUNT: SONY PICTURES` (account_id=51) | OK — `ACCOUNT: RALPH LAUREN` (account_id=732) |
| 1 | Hover Brand in top nav, click Content | OK (default brand ThisisSpotify, brand_id=343324) | OK | OK |
| 2 | Add the Brand | **BLOCKED** — "Spotify News" is not in the typeahead (see below) | OK — typeahead result "Sony Pictures Television" (brand_id=129863) | OK — "Ralph Lauren" (brand_id=7000), read back from `.brand-selector-name` |
| 3 | Enable TikTok channel only | not reached | OK — enabled ghosts `["tiktok"]`, Apply, URL `channels=tiktok`, Posts (10) | OK — enabled ghosts `["tiktok"]`, Apply, URL `channels=tiktok`, Posts (16) |
| 4 | Each post: Reactions + Comments + Shares vs Engagements (Table View, `Rank` header verified) | not reached | See assertions | See assertions |

### Leg 1 detail: "Spotify News" not findable (Rule 1)
- The brand picker opens a "Search for a Brand" textarea. I typed `Spotify News` with the helper (50 ms per character, polled up to ~40 s with two nudges). It returned 0 `.lfm-ta-option` rows.
- `Spotify N` (typed at 120 ms per character): 36 options, none named "Spotify News" (for example `LNA (Spotify)`, `NAKED (Spotify)`, `Spotify (Canada)`, `Spotify (Denmark)`).
- `Spotify`: 124 options, none containing "news" (`Air (Spotify)`, `DOX (Spotify)`, `Daisy (Spotify)`, and similar sub-brands).
- Rule 1 reason: spec brand not findable on dev (test-data gap). I did not substitute ThisisSpotify or any other Spotify brand.
- Evidence: `.playwright-out/QA-29123/1029-01-spotify-content.png`, `1029-02-spotify-news-search.png`, `1029-03-spotify-typeahead.png`.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Spotify | 2–4 | Account Spotify, brand "Spotify News", TikTok only, every post Reactions + Comments + Shares = Engagements | "Spotify News" is not in the typeahead (0 results for the exact query; 36 for `Spotify N` and 124 for `Spotify`, none matching). Nothing evaluable. | BLOCKED (test data: spec brand not findable) |
| A4-Sony-posts | 4 | Reactions + Comments + Shares = Engagements for each post | Sony Pictures Television, 10 TikTok posts (all 10 link to tiktok.com), 10/10 match, 0 mismatches. Rank 1: 457 = 425 + 11 + 21. Rank 2: 262 = 236 + 13 + 13. Rank 3: 214 = 188 + 8 + 18. Rank 9: 28 = 26 + 1 + 1. Rank 10: 17 = 16 + 1 + – (Shares "–", treated as 0). 5 posts have a "–" in one of the three components; the identity holds with "–" as 0. | PASS |
| A4-Sony-agg | 4 | Aggregate Sum row obeys the same identity | Sum row (10 posts): 1,311 + 41 + 60 = 1,412 = Engagements 1,412 | PASS |
| A4-RL-posts | 4 | Reactions + Comments + Shares = Engagements for each post | Ralph Lauren, 16 TikTok posts (all 16 link to tiktok.com), 16/16 match, 0 mismatches. Rank 1: 22,720 = 21,500 + 110 + 1,110. Rank 2: 18,311 = 16,300 + 641 + 1,370. Rank 3: 12,773 = 11,500 + 287 + 986. Rank 15: 238 = 226 + 5 + 7. Rank 16: 194 = 192 + 2 + – (Shares "–", treated as 0). 1 post has a "–" component. | PASS |
| A4-RL-agg | 4 | Aggregate Sum row obeys the same identity | Sum row (16 posts): 67,420 + 1,214 + 4,074 = 72,708 = Engagements 72,708 | PASS |

## Evidence
- `.playwright-out/QA-29123/1029-01-spotify-content.png`, `1029-02-spotify-news-search.png`, `1029-03-spotify-typeahead.png` (Spotify leg)
- `.playwright-out/QA-29123/1029-10-sony-tiktok.png`, `1029-11-sony-table.png` (Sony Pictures Television)
- `.playwright-out/QA-29123/1029-20-rl-tiktok.png`, `1029-21-rl-table.png` (Ralph Lauren)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and the identity was evaluated in page JS. The first screenshot for Sony (`1029-10-sony-tiktok.png`) was not saved because that helper call errored on `tableViewSlow` after the TikTok filter had already applied. The state was read back afterwards (brand, enabled channels, URL).

## Known bugs checked
- The case file lists no open linked bugs, and bug-history has no QA-29123 entry. No bug reproduced or interfered.
- The known-quirks entry about the missing NBCU EnterPrises account is for Wednesday and is not relevant today.
- No known quirk explains the missing "Spotify News" brand. It is a test-data gap that sibling cases (for example QA-29116) also hit today.
- The Twitter-only Reactions + Comments + Shares ≠ Engagements issue (APPS-61116, seen on QA-29111) does not touch TikTok. TikTok sums were exact on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).

## Follow-ups for the case owner
1. Restore or rename the "Spotify News" brand on dev under the Spotify account, or update the Description table. Until then the Thursday row-1 leg stays BLOCKED.
2. The case Notes weekday mapping ("Thu Spotify/Conde Nast") is stale versus the Description table.
3. Add an explicit date range to the ticket if a past range is intended. This run used the default week, which has few TikTok posts (10 and 16).
