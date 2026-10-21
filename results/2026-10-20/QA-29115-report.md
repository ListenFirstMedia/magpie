# QA-29115 — Brand Content > Basic Data Set > Past date range data test - LinkedIn

**Run date:** 2026-10-20 · **Track:** Playwright MCP, unattended `claude -p` · **Account:** UCLA (account_id=799, switched from Adam Orfei via the LFQA menu) · **Brand:** University of California, Los Angeles (brand_id=127756, the UCLA account's default brand — exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** LinkedIn only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 400 rendered posts, and on the aggregate Sum row covering all 1,013 posts.**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). No entries in bug-history / known-quirks for QA-29115.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on `#home`, initial account Adam Orfei |
| P | Precondition: account UCLA — hover LFQA menu, type "UCLA", click `Results` row "UCLA" | OK — breadcrumb `Account: UCLA`, `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content`, `brand_id=127756` |
| 2 | Brand UCLA | OK — page loaded on "University of California, Los Angeles" (account default; same as QA-29124); no substitution |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK — URL `from=2025-01-01&to=2025-10-01` |
| 4 | LinkedIn channel only (disabled facebook/twitter/instagram/tiktok/threads, Apply) | OK — URL `channels=linkedin`, `Posts (1,013)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — via Table View (DOM scrape) | See assertion |

Table View renders only the 200 top-ranked rows + Sum/Average row (no pagination or infinite scroll; verified by scrolling to the bottom, still 201 rows). To widen coverage I re-sorted ascending by clicking the Engagements header and scraped the bottom 200 too (ranks 814–1,013).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reactions + Comments + Shares = Engagements per post | Desc sort, ranks 1–200: 200/200 exact match, 0 skipped, 0 mismatches (rank 1 = 2,923 = 2,792 + 64 + 67; rank 2 = 2,422 = 2,166 + 72 + 184; rank 3 = 2,198 = 2,042 + 85 + 71). Asc sort, ranks 814–1,013: 200/200 exact match (rank 1,013 = 3 = 3 + 0 + 0; rank 1,011 = 5 = 3 + 0 + 2; rank 814 = 19 = 17 + 2 + 0). No "–" in Reactions/Comments/Shares on any scraped row. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (all 1,013 posts): 133,014 + 4,270 + 7,147 = 144,431 = Engagements 144,431 | PASS |

**Coverage note:** the 613 middle-ranked posts (ranks 201–813) are not renderable in the UI (200-row cap per sort direction). They are covered only by the aggregate Sum row, which reconciles exactly. Because the Sum equals the sum over all posts and the 400 rendered posts all match individually, any hidden per-post mismatch would have to cancel exactly across the middle set — not observed.

## Evidence
- `.playwright-out/QA-29115/00-home.png` (home before account switch)
- `.playwright-out/QA-29115/01-linkedin-table-top.png` (Table View, desc)
- `.playwright-out/QA-29115/02-linkedin-table-asc.png` (Table View, asc)
- Exact numbers above were read from the DOM of `table.lfm-table`.

## Known bugs checked
- Case file lists no open linked bugs; bug-history has no QA-29115 entry. No bug reproduced or interfered. The Facebook Posts Insights Disruption banner is Facebook-only and does not touch LinkedIn.

## Bugs filed
None. · **Cleanup:** none (read-only; the grid sort was left ascending, session-local only).
