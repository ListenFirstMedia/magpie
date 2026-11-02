# QA-29122 — Brand Content - Basic Data Set - Data Test - (Twitter and Instagram)

**Verdict: BLOCKED (test-data / entitlement: NBCU EnterPrises account not available)** — Wednesday rotation has two account/brand rows. The Apple Services / Apple Music leg ran in full and PASSED on both channels (31 posts, 0 failures). The NBCU EnterPrises leg (CNBC, NBC News) cannot be run because the account does not exist in the `lfiqa` account list, so under Rule 1 (no substitution) it is BLOCKED and the case cannot end as a full PASS.

- Run: 2026-10-28 (Wednesday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill: `brand-content-grid-math` (Table View DOM scrape, identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-20 .. 2026-10-26 (spec gives no dates, left unchanged)
- Data set: **Engagements Breakdown** (`table_data_set=engagements_breakdown`) per spec step 3. Columns Engagements / Reactions / Comments / Shares present (plus Organic/Paid splits).
- Open linked bugs (case file, as of 2026-10-20): none. Rule 7 screen passed.

## Scope note
Description table, Wednesday row: Accounts "Apple Services, NBCU EnterPrises"; Brands "Apple Music, CNBC, NBC News". The case Notes' rotation line says "Wed Apple Services/Wasserman", which disagrees with the Description table; the Description table was treated as authoritative (same as the 2026-10-26 / 2026-10-27 runs). Apple Services maps to Apple Music. NBCU EnterPrises maps to CNBC and NBC News.

## Steps executed — Apple Services / Apple Music
1. Account: header already read `ACCOUNT: APPLE SERVICES` after login; also switched explicitly through the account menu (search box, real mouse click on the exact option) and read back `APPLE SERVICES` (account_id 409).
2. Step 1: hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
3. Step 2: brand selector already showed **Apple Music** (brand_id 31783), exactly the spec brand (Rule 1).
4. Step 3: selected **Engagements Breakdown** from the visible Data Set dropdown, then clicked the other channel ghosts off until only Twitter was enabled (`enabled: ["twitter"]`), then **Apply** (URL `channels=twitter`).
5. Step 4: **Table View** (`Rank` header verified), scraped every row, checked Reactions + Comments + Shares = Engagements per post and on the Sum row.
6. Step 5: enabled Instagram and disabled Twitter (`enabled: ["instagram"]`, URL `channels=instagram`), Apply.
7. Step 6: same scrape and identity check as step 4.

## Steps attempted — NBCU EnterPrises
- Opened the account menu and typed `NBCU EnterPrises`, then `NBCU`, then `NBC` in "Search Account" (slow typing, 7 s wait each). No `Results` header and no `.lfm-ta-option` rows for any of the three queries (screenshot `nbcu-account-search.png`, dropdown empty).
- Control query `Enter` returns only: Briarcliff Entertainment, Disney Entertainment Television, Paramount Home Entertainment, Sony Home Entertainment, Universal Pictures Home Entertainment. So the typeahead works; the NBCU account is simply not in this user's account list.
- Active account stayed `APPLE SERVICES`. Steps 1-6 for CNBC and NBC News were not executed. CNBC does exist as a public brand under Apple Services, but that is a different account and not the spec precondition, so it was not used (Rule 1; known-quirk "Wednesday rotation is only half-runnable for lfiqa").

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-APPLEMUSIC-TW | 4 — Apple Services (acct 409) / Apple Music (brand 31783), Twitter only | Reactions + Comments + Shares = Engagements per post | Posts (8): 8/8 satisfy, 0 failures, 0 skipped. Sum row: 63,448 + 1,379 + 15,187 = 80,014 = Engagements 80,014. | PASS |
| A6-APPLEMUSIC-IG | 6 — Apple Services / Apple Music, Instagram only | same | Posts (23): 23/23 satisfy, 0 failures, 0 skipped. Sum row: 1,303,953 + 27,906 + Shares "–" (0) = 1,331,859 = Engagements 1,331,859. | PASS |
| A4-CNBC-TW | 4 — NBCU EnterPrises / CNBC, Twitter only | same | Account "NBCU EnterPrises" not findable in the account typeahead (queries NBCU EnterPrises / NBCU / NBC all empty). Leg not executable. | BLOCKED |
| A6-CNBC-IG | 6 — NBCU EnterPrises / CNBC, Instagram only | same | as above | BLOCKED |
| A4-NBCNEWS-TW | 4 — NBCU EnterPrises / NBC News, Twitter only | same | as above | BLOCKED |
| A6-NBCNEWS-IG | 6 — NBCU EnterPrises / NBC News, Instagram only | same | as above | BLOCKED |

## Evidence
- Apple Music Twitter, top rows (Engagements = Reactions + Comments + Shares): rank 1: 32,414 = 28,948 + 652 + 2,814; rank 2: 21,428 = 18,792 + 236 + 2,400; rank 3: 14,996 = 10,827 + 79 + 4,090. No "–" in any component column across the 8 posts.
- Apple Music Instagram, top rows: rank 1: 572,195 = 551,468 + 20,727 + Shares "–"; rank 2: 283,288 = 280,984 + 2,304 + Shares "–"; rank 3: 191,627 = 190,395 + 1,232 + Shares "–". Shares renders "–" on all 23 posts and on the Sum row; Instagram has no Shares metric, so it was read as 0 (as in earlier runs) and the identity held exactly on every row. No post had "–" as its Engagements total.
- No render hang: both tables rendered within the normal wait; no "failed to load" banner seen. The orange "Facebook Data Collection Disruption 9/27" banner is present but irrelevant to Twitter/Instagram-only views.
- Screenshots in `.playwright-out/QA-29122/`: `apple-music-twitter-before-table.png`, `apple-music-twitter-table.png`, `apple-music-instagram-table.png`, `nbcu-account-search.png`.

## Known bugs checked
- Case file "Open linked bugs": none open. `knowledge-base/bug-history.md` has no QA-29122 entry (pre-fetched). Nothing known to interfere with the Apple Music assertions, and none reproduced.
- Known quirk (not a bug): "Wednesday rotation is only half-runnable for lfiqa" — the NBCU EnterPrises account is missing from the lfiqa list; this run reproduces it exactly. Needs the entitlement raised for the test user, or the rotation trimmed.

## Bugs filed
- None (markdown-only policy). The NBCU block is a test-data / entitlement gap, not a product defect.
