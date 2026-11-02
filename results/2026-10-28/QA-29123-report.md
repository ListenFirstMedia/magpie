# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Verdict: BLOCKED (test-data / entitlement: NBCU EnterPrises account not available)** — The Wednesday rotation has two account/brand rows. The Apple Services / Apple Music leg ran in full and PASSED (22 TikTok posts, 0 failures, Sum row reconciles). The NBCU EnterPrises leg (CNBC, NBC News) cannot be run because the account does not exist in the `lfiqa` account list. Under Rule 1 (no substitution) that leg is BLOCKED, so the case cannot end as a full PASS.

- Run: 2026-10-28 (Wednesday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill: `brand-content-grid-math` (Table View DOM scrape, identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-20 .. 2026-10-26 (spec gives no dates, left unchanged)
- Data set: default `Public` (`table_data_set=public`); it carries the Engagements / Reactions / Comments / Shares columns
- Open linked bugs (case file, as of 2026-10-20): none. Rule 7 screen passed. `results/open-bugs-2026-10-28.json` has no QA-29123 entry.

## Scope note
Description table, Wednesday row: Accounts "Apple Services, NBCU EnterPrises"; Brands "Apple Music, CNBC, NBC News". The case Notes' rotation line says "Wed Apple Services/Wasserman", which disagrees with the Description table. The Description table was treated as authoritative (same as the 2026-10-26 / 2026-10-27 runs and today's QA-29122). Apple Services maps to Apple Music. NBCU EnterPrises maps to CNBC and NBC News.

## Steps executed — Apple Services / Apple Music
1. Account: switched through the account menu (typed `Apple Services` in "Search Account", real mouse click on the exact option). Header read back `ACCOUNT: APPLE SERVICES` (account_id 409). The session had started on NETFLIX SUSTAINABILITY TEAM, so the switch was a real change.
2. Step 1: hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
3. Step 2: the brand selector showed **Apple Music** (brand_id 31783), exactly the spec brand (Rule 1). 60 posts across all channels in the default week.
4. Step 3: clicked the channel ghosts so only TikTok was enabled (verified `enabled: ["tiktok"]`), then **Apply** (URL `channels=tiktok`). 22 posts.
5. Step 4: **Table View** (`Rank` header verified). Scraped every row and checked Reactions + Comments + Shares = Engagements per post, plus the Sum row.

## Steps attempted — NBCU EnterPrises
- Opened the account menu and typed `NBCU EnterPrises`, then `NBCU`, then `NBC` in "Search Account" (slow typing, 7 s wait each). There was no `Results` header and no `.lfm-ta-option` rows for any of the three queries (screenshot `nbcu-account-search.png`, dropdown empty).
- Control query `Enter` returned: Briarcliff Entertainment, Disney Entertainment Television, Paramount Home Entertainment, Sony Home Entertainment, Universal Pictures Home Entertainment. So the typeahead works; the NBCU account is simply not in this user's account list.
- The active account stayed `APPLE SERVICES`. Steps 1-4 for CNBC and NBC News were not executed. CNBC does exist as a public brand under Apple Services, but that is a different account from the spec precondition, so it was not used (Rule 1; known quirk "Wednesday rotation is only half-runnable for lfiqa").

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-APPLEMUSIC | 4 — Apple Services (acct 409), brand Apple Music (31783), TikTok only | Reactions + Comments + Shares = Engagements for every post | Posts (22): 22/22 satisfy; 0 failures; 0 rows skipped. Sum row: 201,429 + 4,215 + 23,644 = 229,288 = Engagements 229,288. | PASS |
| A4-CNBC | 4 — NBCU EnterPrises, brand CNBC, TikTok only | same | Account not available in the lfiqa account list; not executed | BLOCKED |
| A4-NBCNEWS | 4 — NBCU EnterPrises, brand NBC News, TikTok only | same | Account not available in the lfiqa account list; not executed | BLOCKED |

## Evidence
- Apple Music row 1: 127,051 = 105,336 + 2,959 + 18,756; row 2: 70,382 = 65,612 + 734 + 4,036; row 3: 18,862 = 18,278 + 241 + 343.
- 7 of 22 rows have "–" in at least one of Reactions / Comments / Shares. "–" was read as 0 and the identity still held exactly on every row. No row had "–" as the Engagements total.
- Screenshots in `.playwright-out/QA-29123/`: `applemusic-tiktok-table.png`, `nbcu-account-search.png`.
- The browser console showed repeated errors (about 37-39 per Brand Content page) throughout; none affected rendering or the assertions.

## Run-environment notes
- The unattended run cannot read `config/.env` from inside the Playwright sandbox. The login snippet was generated shell-side into a temporary file under `.playwright-out/QA-29123/` and deleted straight after use. The Playwright MCP tool echoes the executed code in its result, so the login password appeared in the run transcript. Flagged for harvest: have the helper read credentials from the caller's environment instead of inlining them.
- Dev was responsive on this run; the first login completed without retry.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). Pre-fetched bug-history.md matched nothing for QA-29123. The only known-quirks entry is "Wednesday rotation is only half-runnable for lfiqa", and it reproduced exactly (NBCU EnterPrises not in the account list). It is an entitlement / test-data gap, not a product defect.
- TikTok component "–" values are treated as 0 (identity holds exactly), consistent with earlier runs; not a defect.

## Bugs filed
None. The NBCU gap needs an entitlement or rotation change, not a Jira bug.
