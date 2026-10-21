# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Verdict: PASS** (scope: Tuesday rotation row UCLA / "University of California, Los Angeles" — see Scope note)

- Run: 2026-10-20 (Tuesday), unattended headless, Playwright MCP, login `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-grid-math` (Table View DOM scrape, identity evaluated against scraped values)

## Scope note
The Description table lists three Tuesday accounts (UCLA, Viacom, Wasserman -> University of California, Los Angeles, MTV, Gatorade). Following the case Notes (one account/brand row per weekday) and the QA-29122 precedent from the same set, only the first Tuesday pair (UCLA / University of California, Los Angeles) was executed. Viacom/MTV and Wasserman/Gatorade were NOT executed. The Notes' "Tue UCLA/Sony Pictures" text conflicts with the table (Sony Pictures is a Thursday account) — flagged for case cleanup.

## Steps executed
1. Login via Cognito "With existing account" form -> `#home`. (First attempt clicked the Corporate-email "Sign in" button by mistake; re-submitted via the existing-account form — no impact.) Landed on `Account: Disney Ad Sales` (account_id=634), so the Tuesday precondition required a switch.
2. Account switch (skill `switch-account`): hovered the LFQA user menu, typed `UCLA` slowly into `input.account-typeahead-input`, clicked the exact `UCLA` row under `Results` (not "UCLA Law"). Verified breadcrumb `Account: UCLA`, URL `account_id=799`.
3. Step 1 — hovered **Brand** in the top nav, clicked **Content** (`#explore/brand/content?brand_id=127756`).
4. Step 2 — Brand selector shows exact spec name "University of California, Los Angeles" (Rule 1 satisfied; no substitute). Date range left at default week 2026-10-12..2026-10-18. Data set left at the default `Public` (Basic) set, which carries Engagements / Reactions / Comments / Shares columns.
5. Step 3 — enabled TikTok only: clicked the Facebook, Twitter, Instagram, LinkedIn and Threads channel ghosts off (TikTok remained the last enabled one); verified state `tiktok enabled`, all others disabled; clicked **Apply** (URL `channels=tiktok`).
6. Step 4 — switched to **Table View** (`[title="Table View"]`, `Rank` header verified), `Posts (11)`; scraped every row and checked Reactions + Comments + Shares = Engagements.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (TikTok only, per post) | Reactions + Comments + Shares = Engagements for every post | Posts (11): 11/11 rows satisfy the identity, 0 failures. 3 rows (ranks 8, 10, 11 — gallery posts) show Shares "–", treated as 0 (identity holds exactly under that reading). | PASS |
| A4-agg | 4 (Sum row) | Aggregate Reactions + Comments + Shares = aggregate Engagements | Sum row: 932 + 19 + 12 = 963 = Engagements 963. Column totals of the 11 rows also equal the Sum row (E 963, R 932, C 19, S 12). | PASS |

## Evidence
Per-post values (Engagements = Reactions + Comments + Shares):
| Rank | Type | E | R | C | S |
|---|---|---|---|---|---|
| 1 | video | 132 | 129 | 2 | 1 |
| 2 | video | 127 | 124 | 1 | 2 |
| 3 | video | 127 | 123 | 1 | 3 |
| 4 | video | 100 | 96 | 3 | 1 |
| 5 | video | 100 | 97 | 1 | 2 |
| 6 | video | 89 | 87 | 1 | 1 |
| 7 | video | 80 | 77 | 2 | 1 |
| 8 | gallery | 71 | 66 | 5 | – |
| 9 | gallery | 58 | 57 | 0 | 1 |
| 10 | gallery | 48 | 46 | 2 | – |
| 11 | gallery | 31 | 30 | 1 | – |
| Sum | | 963 | 932 | 19 | 12 |

- Screenshot: `.playwright-out/QA-29123/ucla-tiktok-table.png`
- Browser console showed repeated errors throughout (15-41 per page); none affected rendering or the assertions.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-29123 matches (pre-fetched). No known bug reproduced or interfered.
- TikTok Shares "–" on gallery (photo) posts is treated as no shares; the identity holding exactly with 0 supports this. Not filed as a defect.

## Bugs filed
None.
