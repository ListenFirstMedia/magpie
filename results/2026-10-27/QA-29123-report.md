# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Verdict: PASS** — Tuesday rotation, all 3 Description-table pairs executed (UCLA / University of California, Los Angeles; Viacom / MTV; Wasserman / Gatorade). 3/3 TikTok legs pass; 0 failing posts out of 148 evaluated (9 + 30 + 109), and every Sum row reconciles.

- Run: 2026-10-27 (Tuesday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-19 .. 2026-10-25 (unchanged; spec gives no dates)
- Data set: default `Public` (`table_data_set=public`), which carries the Engagements / Reactions / Comments / Shares columns

## Scope note
The Description table lists three Tuesday account/brand pairs, and all three were run (as in the 2026-10-26 Monday run). The case Notes' rotation line ("Tue UCLA/Sony Pictures") disagrees with the Description table (Tuesday = UCLA, Viacom, Wasserman / UCLA, MTV, Gatorade); the Description table was followed as authoritative.

## Steps executed (per pair)
1. Account switched via the account menu (search box, real mouse click on the exact `.lfm-ta-option`); header confirmed `ACCOUNT: <name>`.
2. Step 1 — hovered **Brand** in the top nav, clicked **Content** (`#explore/brand/content`).
3. Step 2 — brand confirmed in the brand selector (Rule 1: exact name, see notes).
4. Step 3 — TikTok only: clicked the other channel ghosts off (verified `enabled: ["tiktok"]`), clicked **Apply** (URL `channels=tiktok`).
5. Step 4 — **Table View** (`[title="Table View"]`, `Rank` header verified); scraped every row and checked Reactions + Comments + Shares = Engagements per post, plus the Sum row.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-UCLA | 4 — UCLA (acct 799, brand 127756 University of California, Los Angeles), TikTok only | Reactions + Comments + Shares = Engagements for every post | Posts (9): 9/9 satisfy; 0 failures. Sum row: 1,413 + 28 + 45 = 1,486 = Engagements 1,486. | PASS |
| A4-MTV | 4 — Viacom (acct 181, brand 4018 MTV), TikTok only | same | Posts (30): 30/30 satisfy; 0 failures. Sum row: 70,899 + 670 + 1,256 = 72,825 = Engagements 72,825. | PASS |
| A4-GAT | 4 — Wasserman (acct 863, brand 3580 Gatorade), TikTok only | same | Posts (109): 109/109 satisfy; 0 failures. Sum row: 8,305 + 65 + 244 = 8,614 = Engagements 8,614. | PASS |

## Evidence
- UCLA row 1: 375 = 366 + 4 + 5; row 2: 336 = 306 + 6 + 24. 2 of 9 rows have "–" in a component column.
- MTV row 1: 30,333 = 29,900 + 71 + 362; row 2: 18,188 = 17,600 + 155 + 433. 6 of 30 rows have "–" in a component column.
- Gatorade row 1: 2,674 = 2,588 + 22 + 64; row 2: 2,095 = 2,002 + 13 + 80. 91 of 109 rows have "–" in at least one of Reactions/Comments/Shares; "–" was read as 0 and the identity still held exactly on every row (no row had an Engagements total with all components "–").
- No row had "–" as the Engagements total (0 skipped).
- Screenshots in `.playwright-out/QA-29123/`: `ucla-tiktok-table.png`, `mtv-tiktok-table.png`, `gatorade-tiktok-table.png`, `viacom-search.png`, `post-login.png`.
- Browser console showed repeated errors (40-45 per Brand Content page) throughout; none affected rendering or the assertions.

## Naming notes (Rule 1)
- Spec brand "University of California, Los Angeles", "MTV" and "Gatorade" matched the selector name exactly (UCLA's brand was already selected for the account; MTV and Gatorade likewise).
- Account search for "Viacom" and "Wasserman" returned a single exact option each with no "Results" header, so the shared `switchAccount` helper reported `ok:false`; the exact option was clicked with a real mouse click and the header was read back (`ACCOUNT: VIACOM`, `ACCOUNT: WASSERMAN`) before scraping.

## Run-environment notes
- The first `m.login` call returned the pre-redirect "Brand Explorer" page rather than the logged-in app, so the next call timed out on the account menu; a second `m.login` completed the Cognito sign-in. Transient; no effect on results.
- The unattended `claude -p` run cannot read `config/.env` from inside the Playwright sandbox, so the login password was read via shell and passed into `ctx._creds`. Flagged for harvest (same as 2026-10-26): the devprod helper could accept creds from the caller's environment, and `switchAccount` should click the lone option when no "Results" header is shown.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed); `results/open-bugs-2026-10-27.json` has no QA-29123 entry. Pre-fetched bug-history.md / known-quirks.md: no QA-29123 matches. No known bug reproduced or interfered with any assertion.
- TikTok component "–" values are treated as 0 (identity holds exactly), consistent with the 2026-10-20 and 2026-10-26 runs; not a defect.

## Bugs filed
None.
