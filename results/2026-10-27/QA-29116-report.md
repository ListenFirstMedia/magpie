# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-27 (Tuesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** UCLA (account_id=799, switched via the account menu) · **Brand:** University of California, Los Angeles (brand_id=127756, exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1)** — Reactions + Comments + Shares = Engagements on all 193 TikTok posts in range (the full set; under the 200-row Table View cap) and on the aggregate Sum row.

## Pre-screen (Rule 7)
- Case file "Open linked bugs": none open. `results/open-bugs-2026-10-27.json` has no QA-29116 entry, so the screen passed and the case was run.
- No QA-29116 entries in bug-history or known-quirks (pre-fetched).

## Interpretation notes
- The ticket says "date range as per the given date range in the description", but the description contains no date range (only the weekday account/brand table). I used Jan. 01, 2025 – Oct. 01, 2025, the range used by sibling case QA-29115 and by the previous runs of this case (2026-10-20, 2026-10-26). Flagged for the case owner to confirm.
- Weekday rotation: Tuesday → account UCLA, brand "University of California, Los Angeles" (Description table row). The case's Notes line maps Tuesday to "UCLA/Sony Pictures", which only partly matches the table; I followed the Description table, and UCLA is common to both.
- Skill used: `brand-content-grid-math` (Table View DOM scrape) with `devprod-helpers.js`.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on `#home` |
| P | Precondition: account UCLA — account menu, "Search Account" → UCLA | OK — header `ACCOUNT: UCLA`, `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content` |
| 2 | Brand | OK — the brand selector already showed the exact spec brand "University of California, Los Angeles" (`brand_id=127756`); no substitution |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK — date fields read `Jan 01, 2025` / `Oct 01, 2025`; URL `from=2025-01-01&to=2025-10-01` |
| 4 | TikTok only: other channel ghosts clicked off, TikTok on, Apply | OK — enabled channels `["tiktok"]`, URL `channels=tiktok`; `Posts (193)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — Table View, DOM scrape of `table.lfm-table` | See assertions |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-posts | 5 | Reactions + Comments + Shares = Engagements for each post | 193/193 posts exact match, 0 mismatches, 0 skipped. Rank 1: 1,382,654 = 1,351,458 + 4,997 + 26,199. Rank 2: 40,558 = 38,457 + 407 + 1,694. Rank 3: 20,182 = 19,718 + 168 + 296. Rank 193: 10 = 10 + 0 + 0 (Shares "–", treated as 0). 10 posts show "–" in Shares only; their identity still holds. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row: 1,541,891 + 13,159 + 36,263 = 1,591,313 = Engagements 1,591,313. Independent column totals of the 193 rows equal the Sum row on all four columns (E 1,591,313 / R 1,541,891 / C 13,159 / S 36,263). | PASS |

## Evidence
- `.playwright-out/QA-29116/01-account.png` (UCLA account active)
- `.playwright-out/QA-29116/02-content-landing.png` (Brand Content landing, UCLA brand)
- `.playwright-out/QA-29116/03-dates.png` (after the date range was applied)
- `.playwright-out/QA-29116/04-tiktok.png` (TikTok-only applied)
- `.playwright-out/QA-29116/05-table.png` (TikTok Table View)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and evaluated in page JS. Table rows (193) equal the `Posts (193)` count.

## Known bugs checked
- The case file lists no open linked bugs, and the shell-side `open-bugs-2026-10-27.json` has no QA-29116 entry. No bug-history entry exists. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, on QA-29111) does not touch TikTok. TikTok sums were exact on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).
