# QA-29122 — Brand Content - Basic Data Set - Data Test (Twitter and Instagram)

**Verdict: PASS** (scope: Tuesday rotation row UCLA / "University of California, Los Angeles" — see Scope note)

- Run: 2026-10-20 (Tuesday), unattended headless, Playwright MCP, login `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-grid-math` (Table View DOM scrape, identities evaluated in page JS)

## Scope note
The Description table lists three Tuesday accounts (UCLA, Viacom, Wasserman → University of California, Los Angeles, MTV, Gatorade). The case's own Notes define the rotation as one account/brand row per weekday, so the run covered the first Tuesday pair (UCLA / University of California, Los Angeles). Viacom/MTV and Wasserman/Gatorade were NOT executed this run. (The Notes' "Tue UCLA/Sony Pictures" text is inconsistent with the table; Sony Pictures is a Thursday account — flagged for case cleanup.)

## Steps executed
1. Login via Cognito "With existing account" form -> `#home`; header showed `Account: UCLA` (account_id=799) — Tuesday precondition already satisfied, no switch needed.
2. Top nav: hovered **Brand**, clicked **Content** (`#explore/brand/content?brand_id=127756`). Brand selector shows exact spec name "University of California, Los Angeles" (Rule 1 satisfied; no substitute). Date range left at the default week 2026-10-12..2026-10-18.
3. Data set dropdown (visible one) -> **Engagements Breakdown** (URL `table_data_set=engagements_breakdown`; channels auto-reduced to Twitter+Instagram, all other ghosts disabled). Clicked the Instagram ghost to disable it -> only `channel-ghost twitter enabled`, **Apply** (URL `channels=twitter`).
4. Table View (`[title="Table View"]`, `Rank` header verified). Scraped all rows; for each post checked Reactions + Comments + Shares = Engagements.
5. Enabled Instagram, then disabled Twitter (last-channel rule), verified only `instagram` enabled, **Apply** (URL `channels=instagram`).
6. Table View scrape, same identity per post.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter only) | Reactions + Comments + Shares = Engagements for every post | Posts (32): 32/32 rows satisfy the identity, 0 failures, 0 skipped (all Twitter channel). Column totals 464 + 25 + 83 = 572 = aggregate Engagements 572 (Sum row). | PASS |
| A6 | 6 (Instagram only) | Reactions + Comments + Shares = Engagements for every post | Posts (13): 13/13 rows satisfy the identity, 0 failures, 0 skipped (all Instagram channel). Shares "–" on all 13 (structurally absent for Instagram, treated as 0). Column totals 10,486 + 155 + 0 = 10,641 = aggregate Engagements 10,641 (Sum row). | PASS |

## Evidence
- Twitter: Sum row `Engagements 572 | Reactions 464 | Comments 25 | Shares 83`; sample row 1: 77 = 71 + 1 + 5; row 2: 68 = 51 + 2 + 15.
- Instagram: Sum row `Engagements 10,641 | Reactions 10,486 | Comments 155 | Shares –`; sample row 1: 2,120 = 2,107 + 13 + 0.
- Screenshots: `.playwright-out/QA-29122/ucla-twitter-table.png`, `.playwright-out/QA-29122/ucla-instagram-table.png`
- Browser console showed repeated errors throughout (36-55 per page); none affected rendering or the assertions.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-29122 matches (pre-fetched). No known bug reproduced or interfered.
- Instagram Shares "–" is documented structural behavior (grid-math skill), not a defect.

## Bugs filed
None.
