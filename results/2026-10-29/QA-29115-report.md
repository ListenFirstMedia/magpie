# QA-29115 — Brand Content > Basic Data Set > Past date range data test - LinkedIn

**Run date:** 2026-10-29 · **Track:** Playwright MCP, unattended `claude -p` (headless) · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched from the default Spotify account via the LFQA menu) · **Brand:** University of California, Los Angeles (brand_id=127756, the UCLA account's own brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** LinkedIn only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 400 rendered posts (top 200 and bottom 200 by Engagements), and on the aggregate Sum row covering all 1,013 posts.**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). No entries in bug-history / known-quirks for QA-29115 (pre-fetched shell-side).

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on `#home`, initial account Spotify (account_id=1030) |
| P | Precondition: account UCLA — LFQA menu → Search Account "UCLA" → clicked the `Results` row "UCLA" | OK — breadcrumb `ACCOUNT: UCLA`, `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content`, default brand_id=127756 |
| 2 | Add a Brand UCLA — opened the brand picker, typed "UCLA" | **No result named exactly "UCLA"** (68 results: "UCLA - Ambassadors Roll-Up", "UCLA Bruins", "UCLA Anderson", …; no exact match). Per the established mapping (skill `brand-content-native-post-check`, prior runs of this case) the UCLA account's own brand is "University of California, Los Angeles". Re-searched that exact name in the typeahead and clicked the exact-match result (brand_id=127756). No "UCLA …" sub-brand was substituted. See "Notes / judgment call" |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START DATE / END DATE picker, then Ok | OK — picker read `Jan 01, 2025` / `Oct 01, 2025`; URL `from=2025-01-01&to=2025-10-01` |
| 4 | Enable LinkedIn channel only — clicked facebook/twitter/instagram/tiktok/threads ghosts off, verified only `.channel-ghost.linkedin.enabled`, clicked Apply | OK — URL `channels=linkedin`, `Posts (1,013)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — Table View (DOM scrape of `table.lfm-table`, see skill `brand-content-grid-math`) | See assertion |

Table View renders only 200 rows per sort direction plus the Sum/Average row. To widen coverage the Engagements header was clicked to re-sort ascending and the bottom 200 were scraped too (ranks 1,013 → 814).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reactions + Comments + Shares = Engagements per post | Desc sort, ranks 1–200: 200/200 exact match, 0 skipped, 0 "–" cells, 0 mismatches (rank 1 = 2,923 = 2,792 + 64 + 67; rank 2 = 2,422 = 2,166 + 72 + 184; rank 3 = 2,198 = 2,042 + 85 + 71). Asc sort, ranks 1,013–814: 200/200 exact match, 0 mismatches (rank 1,013 = 3 = 3 + 0 + 0; rank 1,012 = 4 = 4 + 0 + 0; rank 816 = 19 = 18 + 1 + 0; rank 815 = 19 = 19 + 0 + 0; rank 814 = 19 = 17 + 2 + 0). | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (all 1,013 posts): 133,014 + 4,270 + 7,147 = 144,431 = Engagements 144,431 (identical in both sort directions) | PASS |

**Coverage note:** the 613 middle-ranked posts (ranks 201–813) are not renderable in the UI (200-row cap per sort direction). They are covered only by the aggregate Sum row, which reconciles exactly. All 400 rendered posts match individually, so a hidden per-post mismatch would have to cancel exactly across the middle set — not observed.

**Method note:** the case wording is "in each grid post"; the check was done on Table View (same data source, same metrics as the grid tiles) because it exposes all 200 posts per sort at once. Grid tiles were not individually read.

## Notes / judgment call
- Rule 1 tension: the spec says brand "UCLA", but the dev typeahead has no brand with that exact name. The UCLA account's primary brand is "University of California, Los Angeles", which is what the account loads by default and what every prior run of this case and its siblings (QA-29124, QA-27628 set) used. I treated that as the spec brand and selected it via the typeahead exact match. If the intended brand were one of the "UCLA …" sub-brands, this verdict would not cover it — flagging for a human to confirm the case wording.
- A local login helper script holding the password was written under `.playwright-out/QA-29115/` (gitignored) and deleted immediately after login. The Playwright MCP tool echoed the credentials in its own output for that one call; consider rotating if tool output is retained anywhere shared.
- Older screenshots from earlier runs exist in `.playwright-out/QA-29115/` (no `r2-` prefix); this run's are prefixed `r2-`.

## Evidence
- `.playwright-out/QA-29115/r2-00-home.png` (home before account switch, account Spotify)
- `.playwright-out/QA-29115/r2-01-content-landing.png` (Brand > Content, UCLA account, default week)
- `.playwright-out/QA-29115/r2-02-brand-click.png` (brand picker open)
- `.playwright-out/QA-29115/r2-03-dates-picked.png` (date picker Jan 01, 2025 – Oct 01, 2025)
- `.playwright-out/QA-29115/r2-04-linkedin-only.png` (LinkedIn only, Posts (1,013))
- `.playwright-out/QA-29115/r2-05-table-desc.png`, `r2-06-after-sort-click.png`, `r2-07-table-asc.png` (Table View desc / asc)
- Exact numbers above were read from the DOM of `table.lfm-table`.

## Known bugs checked
- Case file lists no open linked bugs; bug-history has no QA-29115 entry. No bug reproduced or interfered. The Facebook Data Collection Disruption banner is Facebook-only and does not touch LinkedIn. Console showed the usual dev 4xx/5xx noise unrelated to the grid math.

## Bugs filed
None. · **Cleanup:** none (read-only; the table sort was left ascending, session-local only).
