# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-28 (Wednesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** Apple Services (account_id=409, switched via the account menu) · **Brand:** Apple Music (brand_id=31783, exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1)** — Reactions + Comments + Shares = Engagements on all 179 TikTok posts and on the aggregate Sum row.

## Pre-screen (Rule 7)
- Case file "Open linked bugs": none open. The pre-fetched bug-history and known-quirks greps for QA-29116 returned nothing. The screen passed and the case was run.

## Interpretation notes
- The ticket says "date range as per the given date range in the description", but the description has no date range (only the weekday account/brand table). I used the range from sibling case QA-29115 (same test set): Jan. 01, 2025 – Oct. 01, 2025. This matches the 2026-10-20 and 2026-10-26 runs. Flagged for the case owner to confirm.
- Weekday rotation: Wednesday → Apple Services / Apple Music (first Wednesday row in the Description table). The table also lists NBCU EnterPrises with CNBC and NBC News; I did not run those, in line with earlier runs that used only the first account/brand per day. The case's Notes line maps Wednesday to "Apple Services/Wasserman", which does not match the table. I followed the table; Apple Services is common to both.
- Skill used: `brand-content-grid-math` (Table View DOM scrape) with the shared Playwright helpers.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK after one retry. The first attempt was bounced back to `auth.lfmdev.in` while the shell showed "Loading..."; the second landed on `#home`. |
| P | Precondition: account Apple Services — account menu, "Search Account" → Apple Services | OK — header `ACCOUNT: APPLE SERVICES`, `account_id=409` |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content` |
| 2 | Brand | OK — the selector showed "Apple Music" (`brand_id=31783`); re-selected via typeahead and picked the exact "Apple Music" result. No substitution. |
| 3 | Date range Jan 01, 2025 – Oct 01, 2025 via START/END DATE picker, then Ok | OK — fields read `Jan 01, 2025` / `Oct 01, 2025`; URL `from=2025-01-01&to=2025-10-01` |
| 4 | TikTok only: other channel ghosts clicked off, TikTok on, Apply | OK — enabled ghosts: `["tiktok"]`, URL `channels=tiktok`, `Posts (179)` |
| 5 | Each grid post: Reactions + Comments + Shares vs Engagements — Table View, DOM scrape of `table.lfm-table` | See assertions |

Table View renders 179 rows plus the aggregate row, under the 200-row cap, so every post was checked individually. All 179 rows link to tiktok.com and all show Brand "Apple Music". Post dates run from Sep. 28, 2025 back to May 23, 2025.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-posts | 5 | Reactions + Comments + Shares = Engagements for each post | 179/179 exact match, 0 mismatches, 0 skipped. Rank 1: 1,242,726 = 1,096,325 + 11,151 + 135,250. Rank 2: 467,187 = 446,379 + 5,321 + 15,487. Rank 3: 386,244 = 373,310 + 2,323 + 10,611. Rank 178: 60 = 59 + 1 + – (Shares "–", treated as 0). Rank 179: 58 = 56 + 2 + – (Shares "–", treated as 0). Two posts show "–" in Shares only; their identity still holds. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Sum row (179 posts): 4,881,118 + 70,747 + 244,608 = 5,196,473 = Engagements 5,196,473 | PASS |

## Evidence
- `.playwright-out/QA-29116/00-account.png` (account switch result)
- `.playwright-out/QA-29116/01-content-landing.png` (Brand Content landing, Apple Music)
- `.playwright-out/QA-29116/02-dates.png` (after the date range was applied)
- `.playwright-out/QA-29116/03-tiktok-table.png` (TikTok Table View)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and evaluated in page JS.

## Known bugs checked
- The case file lists no open linked bugs, and bug-history has no QA-29116 entry. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, seen on QA-29111) does not touch TikTok. TikTok sums were exact on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).
