# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** HBO Max (account_id=657, switched via the LFQA menu) · **Brand:** HBO Max (brand_id=155614, exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1)** — Reactions + Comments + Shares = Engagements on the 400 TikTok posts checked (the top 200 and bottom 200 of 1,389 by Engagements) and on the aggregate Sum row, which covers all 1,389 posts.

## Pre-screen (Rule 7)
- Case file "Open linked bugs": none open. `results/open-bugs-2026-10-26.json` has no QA-29116 entry, so the screen passed and the case was run.
- No QA-29116 entries in bug-history or known-quirks (pre-fetched).

## Interpretation notes
- The ticket says "date range as per the given date range in the description", but the description has no date range (only the weekday account/brand table). I used the range from sibling case QA-29115 (same test set): Jan. 01, 2025 – Oct. 01, 2025. This is the same choice as the 2026-10-20 run. Flagged for the case owner to confirm.
- Weekday rotation: Monday → account HBO Max, brand HBO Max (Description table). The case's Notes line maps Monday to "HBO Max/Viacom", which only partly matches the table; I followed the Description table, and HBO Max is common to both.
- Skill used: `brand-content-grid-math` (Table View DOM scrape).

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on `#home` |
| P | Precondition: account HBO Max — LFQA menu, "Search Account" → HBO Max | OK — header `ACCOUNT: HBO MAX`, `account_id=657` (the switch took ~20 s to settle) |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content` |
| 2 | Brand | OK — the brand selector already showed the exact spec brand "HBO Max" (`brand_id=155614`); no substitution |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK — date fields read `Jan 01, 2025` / `Oct 01, 2025`; URL `from=2025-01-01&to=2025-10-01` |
| 4 | TikTok only: other channel ghosts clicked off, TikTok on, Apply | OK — enabled channels `["tiktok"]`, URL `channels=tiktok` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — Table View, DOM scrape of `table.lfm-table` | See assertions |

`Posts (1,389)` for the range. Table View shows at most 200 rows with no pager, so I scraped two windows by clicking the Engagements column header: descending (default) for the top 200 and ascending for the bottom 200. The aggregate Sum row covers all 1,389 posts. The 789 posts in between were not individually scraped.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-top | 5 | Reactions + Comments + Shares = Engagements for each post | Top 200 by Engagements (ranks 1–200): 200/200 exact match, 0 mismatches, 0 skipped. Rank 1: 6,007,273 = 5,542,172 + 7,765 + 457,336. Rank 2: 4,197,781 = 4,068,504 + 5,698 + 123,579. Rank 3: 2,457,803 = 2,222,789 + 9,994 + 225,020. | PASS |
| A5-bottom | 5 | Same identity | Bottom 200 (ranks 1,189–1,389): 200/200 exact match, 0 mismatches. Rank 1,389: 16 = 14 + 2 + 0 (Shares "–", treated as 0). Rank 1,388: 52 = 49 + 3 + 0 (Shares "–", treated as 0). 6 of these posts show "–" in Shares only; their identity still holds. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (1,389 posts): 73,244,590 + 377,307 + 5,100,239 = 78,722,136 = Engagements 78,722,136 | PASS |

## Evidence
- `.playwright-out/QA-29116/00-account.png` (taken while the account switch was still loading)
- `.playwright-out/QA-29116/01-content-landing.png` (Brand Content landing, HBO Max)
- `.playwright-out/QA-29116/02-dates.png` (after the date range was applied)
- `.playwright-out/QA-29116/03-tiktok-table.png` (TikTok Table View, descending by Engagements)
- `.playwright-out/QA-29116/04-tiktok-table-asc.png` (TikTok Table View, ascending by Engagements)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and evaluated in page JS.

## Known bugs checked
- The case file lists no open linked bugs, and the shell-side `open-bugs-2026-10-26.json` has no QA-29116 entry. No bug-history entry exists. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, on QA-29111) does not touch TikTok. TikTok sums were exact on every checked post.

## Bugs filed
None. · **Cleanup:** none (read-only; the table sort was left ascending in the session only).
