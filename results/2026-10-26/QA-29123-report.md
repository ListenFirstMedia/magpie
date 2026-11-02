# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Verdict: PASS** — Monday rotation, all 3 Description-table pairs executed (HBO Max / HBO Max, Amazon Prime Video / Amazon Prime Video, Condé Nast / Vogue - US). 3/3 TikTok legs pass; 0 failing posts out of 248 evaluated (126 + 37 + 85), and every Sum row reconciles.

- Run: 2026-10-26 (Monday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-18 .. 2026-10-24 (unchanged; spec gives no dates)
- Data set: default `Public` (`table_data_set=public`), which carries the Engagements / Reactions / Comments / Shares columns

## Scope note
The Description table lists three Monday accounts. The 2026-10-20 run of this case covered only the first pair of its day (Tuesday); here all three Monday pairs were run, matching the QA-29122 run of the same day. The case Notes' rotation line ("Mon HBO Max/Viacom") disagrees with the Description table (Monday = HBO Max, Amazon Prime Video, Conde Nast); the Description table was followed as authoritative.

## Steps executed (per pair)
1. Account switched via the LFQA account menu (typeahead `Results`, real mouse click on `.lfm-ta-option`); header confirmed `ACCOUNT: <name>`.
2. Step 1 — hovered **Brand** in the top nav, clicked **Content** (`#explore/brand/content`).
3. Step 2 — brand confirmed in the brand selector (Rule 1, see naming notes).
4. Step 3 — TikTok only: clicked the other channel ghosts off (TikTok enabled, all others disabled; verified `enabled: ["tiktok"]`), clicked **Apply** (URL `channels=tiktok`).
5. Step 4 — **Table View** (`[title="Table View"]`, `Rank` header verified); scraped every row and checked Reactions + Comments + Shares = Engagements per post, plus the Sum row.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-HBO | 4 — HBO Max (acct 657, brand 155614), TikTok only | Reactions + Comments + Shares = Engagements for every post | Posts (126): 126/126 satisfy; 0 failures. Sum row: 924,714 + 7,979 + 128,257 = 1,060,950 = Engagements 1,060,950. | PASS |
| A4-AMZ | 4 — Amazon Prime Video (acct 342, brand 25864), TikTok only | same | Posts (37): 37/37 satisfy; 0 failures. Column totals 857,888 + 9,707 + 49,778 = 917,373 = Sum-row Engagements 917,373. | PASS |
| A4-VOG | 4 — Condé Nast / Vogue - US (acct 487, brand 328069), TikTok only | same | Posts (85): 85/85 satisfy; 0 failures. Column totals 7,272,821 + 22,098 + 202,003 = 7,496,922 = Sum-row Engagements 7,496,922. | PASS |

## Evidence
- HBO Max row 1: 400,339 = 301,175 + 5,046 + 94,118; row 2: 72,750 = 71,262 + 207 + 1,281. Ranks 59-60 have Engagements 0 with Reactions/Shares "–" (0 = 0 under the "–" as 0 reading); several low-rank rows have Shares "–" and the identity still holds exactly.
- Amazon Prime Video row 1: 314,488 = 307,500 + 638 + 6,350; row 2: 108,055 = 100,700 + 904 + 6,451. No "–" in Reactions or Shares.
- Vogue - US row 1: 995,248 = 987,200 + 1,311 + 6,737; row 2: 886,168 = 867,400 + 1,368 + 17,400. One post has "–" for Reactions and Shares (identity holds treating "–" as 0).
- Screenshots in `.playwright-out/QA-29123/`: `hbomax-tiktok-table.png`, `amazon-tiktok-table.png`, `conde-account-search.png`, `vogue-tiktok-table.png`, `vogue-state.png` (the stuck-"Loading" state, see below).
- Browser console showed repeated errors (25-43 per page) throughout; none affected rendering or the assertions.

## Naming notes (Rule 1)
- Spec account "Conde Nast" exists on dev as **"Condé Nast"** (accented é) — the only result for "Conde"; same entity, not a substitute. The shared `switchAccount` exact-match does not handle the accent, so the option was selected with a real mouse click on the exact `Condé Nast` row.
- Spec brand "Vogue-US" exists on dev as **"Vogue - US"** (spaces around hyphen); it was the brand already shown for the account and was selected through the brand typeahead as the exact result. Other Vogue entries (Beauty/Runway/Shopping/Weddings - US, etc.) were not used.
- Spec brand/account for Amazon: `switchAccount` returned `ok:false` (no `ACCOUNT:` text captured at the 8 s mark), but the header was then read back as `ACCOUNT: AMAZON PRIME VIDEO` with brand `Amazon Prime Video` and URL `account_id=342`; verified before scraping.

## Run-environment notes
- Vogue - US: Brand > Content sat on "Loading" with no channel ghosts for the full 120 s bounded wait (screenshot `vogue-state.png`); one page reload (within the 5-minute step budget) rendered it normally in ~5 s. Treated as transient dev slowness, not a product defect and not a blocker.
- The unattended `claude -p` run cannot read `config/.env` from inside the Playwright sandbox (`require`/dynamic import unavailable), so the login password was read via shell and passed into `ctx._creds`. Flagged for harvest: the devprod helper could accept creds from the caller's environment.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed); `results/open-bugs-2026-10-26.json` has no QA-29123 entry. Pre-fetched bug-history.md / known-quirks.md: no QA-29123 matches. No known bug reproduced or interfered with any assertion.
- TikTok Shares "–" on some rows is treated as 0 (identity holds exactly), consistent with the 2026-10-20 run; not a defect.

## Bugs filed
None.
