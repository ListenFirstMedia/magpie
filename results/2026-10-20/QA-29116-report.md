# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-20 (Tuesday) · **Track:** Playwright MCP, unattended `claude -p` · **Account:** UCLA (account_id=799, switched from the default account via the LFQA menu) · **Brand:** University of California, Los Angeles (brand_id=127756, the UCLA account's default brand — exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 193 TikTok posts, and on the aggregate Sum row.**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). No entries in bug-history / known-quirks for QA-29116.

## Interpretation notes
- The ticket says "date range as per the given date range in the description", but the description contains no date range (only the weekday account/brand table). I used the same past range as sibling case QA-29115 (LinkedIn, same test set): Jan. 01, 2025 – Oct. 01, 2025. Flagged for the case owner to confirm.
- Weekday rotation: Tuesday → account UCLA, brand "University of California, Los Angeles" (Description table row 1). The case's Notes line maps Tuesday to "UCLA/Sony Pictures", which conflicts with the Description table; I followed the Description table (the spec) and the account/brand that QA-29115/29124 used.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on `#home` |
| P | Precondition: account UCLA — hover LFQA menu, type "UCLA", click the `Results` row "UCLA" (not "UCLA Law") | OK — breadcrumb `ACCOUNT: UCLA`, `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content` |
| 2 | Brand UCLA | OK — page loaded on "University of California, Los Angeles" (`brand_id=127756`); no substitution |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK — URL `from=2025-01-01&to=2025-10-01` |
| 4 | TikTok channel only (explicitly clicked facebook/twitter/instagram/linkedin/threads off; verified `.channel-ghost` states; Apply) | OK — URL `channels=tiktok`, `Posts (193)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — via Table View (DOM scrape of `table.lfm-table`) | See assertion |

Table View rendered 194 rows = 193 posts + the Sum/Average aggregate row — fewer than the 200-row cap, so every post in range was checked.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reactions + Comments + Shares = Engagements for each post | 193/193 posts exact match, 0 mismatches, 0 skipped (rank 1 = 1,382,572 = 1,351,380 + 4,997 + 26,195; rank 2 = 40,519 = 38,420 + 407 + 1,692; rank 3 = 20,181 = 19,717 + 168 + 296). 10 posts show "–" in Shares only (treated as 0); their identity still holds exactly. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (193 posts): 1,541,763 + 13,159 + 36,256 = 1,591,178 = Engagements 1,591,178 | PASS |

## Evidence
- `.playwright-out/QA-29116/01-tiktok-table.png` (TikTok Table View, desc by Engagements)
- Exact numbers above were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …).

## Known bugs checked
- Case file lists no open linked bugs; bug-history has no QA-29116 entry. No bug reproduced or interfered. The Facebook Posts Insights Disruption banner (status page) is Facebook-only and does not touch TikTok.

## Bugs filed
None. · **Cleanup:** none (read-only).
