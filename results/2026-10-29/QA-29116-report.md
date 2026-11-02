# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: BLOCKED (partial: 2 of 3 Thursday legs PASS; the Spotify News leg is BLOCKED on test data)** — Reactions + Comments + Shares = Engagements holds on every TikTok post and on the aggregate Sum row for Sony Pictures Television (212/212) and Ralph Lauren (399/399). The Thursday row-1 brand "Spotify News" cannot be found on the Spotify account, so that leg could not be run. Per Rule 1 I did not substitute another brand.

## Pre-screen (Rule 7)
- The case file's "Open linked bugs" section says "None open". The pre-fetched bug-history and known-quirks greps for QA-29116 returned nothing. The screen passed and the case was run.

## Interpretation notes
- **Date range:** the ticket says "date range as per the given date range in the description", but the description has no date range (only the weekday account/brand table). I used the range from sibling case QA-29115: Jan. 01, 2025 – Oct. 01, 2025, which is the same as the earlier QA-29116 runs (2026-10-20, 26, 27, 28). Flagged for the case owner to confirm.
- **Weekday rotation:** 2026-10-29 is a Thursday. The Description table row is Spotify / Sony Pictures / Ralph Lauren, with brands Spotify News / Sony Pictures Television / Ralph Lauren. The case's Notes line ("Thu Spotify/Conde Nast") is stale and does not match the table. I followed the table and ran all three legs. Earlier Wednesday runs of this case executed only the first row; I ran all three because leg 1 is blocked and the other two still give evidence.
- **Skill:** `brand-content-grid-math` (Table View DOM scrape) with the shared Playwright helpers (`devprod-helpers.js`).

## Steps executed
| # | Step | Spotify (leg 1) | Sony Pictures (leg 2) | Ralph Lauren (leg 3) |
|---|------|-----------------|-----------------------|----------------------|
| 0 | Login (Cognito "With existing account") | OK, landed on `#home` | — | — |
| P | Precondition: switch account via the account menu | OK — `ACCOUNT: SPOTIFY` (account_id=1030) | OK — `ACCOUNT: SONY PICTURES` (account_id=51) | OK — `ACCOUNT: RALPH LAUREN` (account_id=732) |
| 1 | Hover Brand in top nav, click Content | OK | OK | OK |
| 2 | Add the Brand | **BLOCKED** — the default brand is ThisisSpotify, and "Spotify News" is not in the typeahead (see below) | OK — typeahead result "Sony Pictures Television" (brand_id=129863) | OK — typeahead result "Ralph Lauren" (brand_id=7000) |
| 3 | Date range via the START/END DATE picker, then Ok | not reached | OK — fields `Jan 01, 2025` / `Oct 01, 2025`, URL `from=2025-01-01&to=2025-10-01` | OK — same |
| 4 | Enable TikTok only (other channel ghosts off, TikTok on, Apply) | not reached | OK — enabled ghosts `["tiktok"]`, `Posts (212)` | OK — enabled ghosts `["tiktok"]`, `Posts (399)` |
| 5 | Each post: Reactions + Comments + Shares vs Engagements (Table View DOM scrape of `table.lfm-table`) | not reached | See assertions | See assertions |

### Leg 1 detail: "Spotify News" not findable (Rule 1)
- The brand picker (the chevron next to the brand name) opens a "Search for a Brand" textarea. I typed slowly (100–150 ms per character) and waited up to 24 s per query.
- `Spotify News` and `Spotify news`: 0 `.lfm-ta-option` rows, with the dropdown still on "Recent Searches". I also retried by nudging the last character, 8 times.
- `Spotify N`: 52 options, none named "Spotify News".
- `Spotify`: 126 options, none named "Spotify News" (`<Name> (Spotify)` sub-brands, "Spotify (Country)" brands, Life at Spotify, and similar).
- The same absence was verified on dev and prod on 2026-10-22 and again today by sibling cases (QA-20534, QA-20318, QA-21021).
- Rule 1 reason: spec brand not findable on dev (test-data gap). I did not substitute ThisisSpotify or any other Spotify brand.
- Evidence: `.playwright-out/QA-29116/1029-02-brand.png`, `1029-02b-brand-open.png`, `1029-02c-brand-typed.png`, `1029-02d-brand-spotify.png`, `1029-02e-brand-news.png`.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-Spotify | 2–5 | Account Spotify, brand "Spotify News", TikTok only, every post Reactions + Comments + Shares = Engagements | The brand "Spotify News" is not in the typeahead (0 matches for 3 queries; 126 "Spotify" results, none named Spotify News). Nothing evaluable. | BLOCKED (test data: spec brand not findable) |
| A5-Sony-posts | 5 | Reactions + Comments + Shares = Engagements for each post | 212 TikTok posts. Table View renders at most 200 rows, so I scraped it twice: Engagements descending (ranks 1–200) and ascending (ranks 212 down to 13). All 212 posts were covered, with 200/200 matches on each scrape and 0 mismatches. Rank 1: 246,049 = 209,397 + 4,974 + 31,678. Rank 2: 210,391 = 199,101 + 960 + 10,330. Rank 3: 189,043 = 182,061 + 2,448 + 4,534. Rank 212: 22 = 19 + 3 + – (Shares "–", treated as 0). Rank 211: 33 = 30 + 1 + 2. The 13 posts with a "–" in Reactions, Comments or Shares in the descending scrape still satisfy the identity with "–" as 0. All rows link to tiktok.com. | PASS |
| A5-Sony-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (212 posts): 2,112,719 + 27,380 + 132,858 = 2,272,957 = Engagements 2,272,957 | PASS |
| A5-RL-posts | 5 | Reactions + Comments + Shares = Engagements for each post | 399 TikTok posts. Descending scrape covers ranks 1–200 (200/200 match) and ascending scrape covers ranks 399 down to 200 (200/200 match), so all 399 are covered, with 0 mismatches. Rank 1: 492,279 = 468,400 + 7,079 + 16,800. Rank 2: 450,043 = 419,400 + 3,643 + 27,000. Rank 3: 379,601 = 361,800 + 2,901 + 14,900. Rank 200: 1,018 = 982 + 19 + 17. Rank 399: 157 = 138 + 8 + 11. Rank 398: 163 = 160 + 3 + – (Shares "–", treated as 0). All rows are brand "Ralph Lauren" and link to tiktok.com. | PASS |
| A5-RL-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (399 posts): 3,729,240 + 33,854 + 164,487 = 3,927,581 = Engagements 3,927,581 | PASS |

## Evidence
- `.playwright-out/QA-29116/1029-00-account.png` (Spotify account switch)
- `.playwright-out/QA-29116/1029-01-content-landing.png` (Brand Content landing, ThisisSpotify)
- `.playwright-out/QA-29116/1029-02*.png` (Spotify News search attempts)
- `.playwright-out/QA-29116/1029-10-sony-account.png`, `1029-11-sony-dates.png`, `1029-12-sony-tiktok.png`, `1029-13-sony-table.png`, `1029-14-sony-table-asc.png`
- `.playwright-out/QA-29116/1029-20-rl-account.png`, `1029-21-rl-tiktok.png`, `1029-22-rl-table-desc.png`, `1029-23-rl-table-asc.png`
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and the identity was evaluated in page JS.

## Known bugs checked
- The case file lists no open linked bugs, and bug-history has no QA-29116 entry. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, seen on QA-29111) does not touch TikTok. TikTok sums were exact on every post.
- No known quirk explains the missing "Spotify News" brand; it is a test-data gap that was also seen on 2026-10-22.

## Bugs filed
None. · **Cleanup:** none (read-only).

## Follow-ups for the case owner
1. Restore or rename the "Spotify News" brand on dev under the Spotify account, or update the Description table. Until then the Thursday row-1 leg stays BLOCKED.
2. Add the explicit date range to the ticket description. Runs currently borrow Jan 01 – Oct 01, 2025 from QA-29115.
3. The case Notes weekday mapping is stale versus the Description table.
