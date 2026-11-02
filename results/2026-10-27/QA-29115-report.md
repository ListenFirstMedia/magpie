# QA-29115 — Brand Content > Basic Data Set > Past date range data test - LinkedIn

**Run date:** 2026-10-27 (Tuesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** UCLA (account_id=799, switched via the account menu) · **Brand:** University of California, Los Angeles (brand_id=127756, exact spec brand "UCLA" entity) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** LinkedIn only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1)**. Reactions + Comments + Shares = Engagements held on every post checked (400 of 1,013 LinkedIn posts, see coverage note) and on the aggregate Sum row.

## Pre-screen (Rule 7)
- Case file "Open linked bugs": none open. `results/open-bugs-2026-10-27.json` has no QA-29115 entry, so the screen passed and the case was run.
- No QA-29115 entries in bug-history or known-quirks (pre-fetched).

## Interpretation notes
- Skill used: `brand-content-grid-math` (Table View DOM scrape) with `devprod-helpers.js`. The helper bootstrap was not used for the prod tab: this case is dev-only, so a single tab was logged in on dev with `config/.env`.
- Coverage: the grid cannot show all posts at once. The Posts counter reads **Posts (1,013)**, but Table View renders at most 200 rows and has no pagination or lazy-load (verified by scrolling to the bottom: row count stayed 201 including the Sum row). I checked the top 200 by Engagements (default sort, descending) and then re-sorted ascending via the Engagements column header to check the bottom 200 (ranks 1,013 to 814). The remaining 613 mid-range posts are not rendered by the UI in any single view and were not checked individually; the Sum row (which covers all 1,013) was checked instead.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK, landed on `#home`. The first attempt stayed on the auth page because dev was slow; the second attempt succeeded. |
| P | Precondition: account UCLA, via account menu "Search Account" then UCLA | OK, header `ACCOUNT: UCLA`, `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK, `#explore/brand/content` |
| 2 | Brand UCLA | OK, the brand selector showed "University of California, Los Angeles" (`brand_id=127756`) for account UCLA; no substitution |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK, date button reads `Jan. 01, 2025 - Oct. 01, 2025`; URL `from=2025-01-01&to=2025-10-01` |
| 4 | LinkedIn channel only: other channel ghosts clicked off, LinkedIn on, Apply | OK, enabled channels `["linkedin"]`, URL `channels=linkedin`; `Posts (1,013)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements. Table View, DOM scrape of `table.lfm-table` | See assertions |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-top200 | 5 | Reactions + Comments + Shares = Engagements for each post | Top 200 posts by Engagements (ranks 1–200): 200/200 exact match, 0 mismatches, 0 "–" values, 0 skipped. Rank 1: 2,923 = 2,792 + 64 + 67. Rank 2: 2,422 = 2,166 + 72 + 184. Rank 3: 2,198 = 2,042 + 85 + 71. Rank 200: 182 = 159 + 4 + 19. | PASS |
| A5-bottom200 | 5 | Same identity on the lowest-engagement posts | Ascending sort, ranks 1,013 to 814: 200/200 exact match, 0 mismatches, 0 skipped. Rank 1,013: 3 = 3 + 0 + 0. Rank 814: 19 = 17 + 2 + 0. | PASS |
| A5-agg | 5 | Aggregate Sum row (all 1,013 posts) obeys the same identity | Sum row: Reactions 133,014 + Comments 4,270 + Shares 7,147 = 144,431 = Engagements 144,431. | PASS |

Supporting numbers: the top-200 column totals were E 109,333 / R 101,459 / C 3,084 / S 4,790 (R+C+S = 109,333). These are lower than the Sum row because the Sum row covers all 1,013 posts.

## Evidence
- `.playwright-out/QA-29115/00-home.png` (logged in)
- `.playwright-out/QA-29115/01-account.png` (UCLA account active)
- `.playwright-out/QA-29115/02-content-landing.png` (Brand Content landing, UCLA brand)
- `.playwright-out/QA-29115/03-dates.png` (date range applied)
- `.playwright-out/QA-29115/04-linkedin.png` (LinkedIn-only applied)
- `.playwright-out/QA-29115/05-table.png` (LinkedIn Table View, descending)
- `.playwright-out/QA-29115/06-bottom.png` (bottom of the table, no pagination)
- `.playwright-out/QA-29115/07-sorted-asc.png` (ascending sort)
- Exact numbers were read from the DOM of `table.lfm-table` (headers include Rank, Engagements, Reactions, Comments, Shares, Response Rate, Video Views) and evaluated in page JS.

## Known bugs checked
- The case file lists no open linked bugs, and the shell-side `open-bugs-2026-10-27.json` has no QA-29115 entry. No bug-history entry exists. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, on QA-29111) does not touch LinkedIn; LinkedIn sums were exact on every checked post.
- Console showed errors/warnings on the app pages (not a step in this case; no effect on the data or assertions).

## Bugs filed
None. · **Cleanup:** none (read-only; the ascending sort lives only in the session URL).
