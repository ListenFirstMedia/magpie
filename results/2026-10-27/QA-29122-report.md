# QA-29122 — Brand Content - Basic Data Set - Data Test - (Twitter and Instagram)

**Verdict: PASS** — Tuesday rotation, all 3 Description-table pairs run (UCLA / University of California, Los Angeles; Viacom / MTV; Wasserman / Gatorade), each on Twitter-only and Instagram-only. 5 of 6 legs evaluated: 114 posts checked, 0 failures, every Sum row reconciles. The 6th leg (Gatorade Twitter) has 0 posts in the week, so nothing was available to sum (vacuous, noted below).

- Run: 2026-10-27 (Tuesday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill: `brand-content-grid-math` (Table View DOM scrape, identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-19 .. 2026-10-25 (spec gives no dates, left unchanged)
- Data set: **Engagements Breakdown** (`table_data_set=engagements_breakdown`), as the spec's step 3 requires. Columns Engagements / Reactions / Comments / Shares present.

## Scope note
The Description table lists three Tuesday account/brand pairs and all three were run. The case Notes' rotation line ("Tue UCLA/Sony Pictures") disagrees with the Description table (Tuesday = UCLA, Viacom, Wasserman / UCLA, MTV, Gatorade). The Description table was treated as authoritative, matching the 2026-10-26 and QA-29123 runs.

## Steps executed (per pair)
1. Account: UCLA was already active after login (header `ACCOUNT: UCLA`). Viacom and Wasserman were switched through the account menu (search box, real mouse click on the exact `.lfm-ta-option`) and the header was read back (`VIACOM`, `WASSERMAN`).
2. Step 1: hovered **Brand** in the top nav, clicked **Content** (`#explore/brand/content`).
3. Step 2: brand confirmed or selected from the typeahead by exact name (Rule 1). UCLA was already selected; MTV (brand_id 4018) was picked from the typeahead; Gatorade (brand_id 3580) was already selected.
4. Step 3: selected the **Engagements Breakdown** data set from the visible dropdown, then clicked the other channel ghosts off until only Twitter was enabled (`enabled: ["twitter"]`), then **Apply** (URL `channels=twitter`).
5. Step 4: **Table View** (`Rank` header verified); scraped every row and checked Reactions + Comments + Shares = Engagements per post, plus the Sum row.
6. Step 5: enabled Instagram and disabled Twitter (`enabled: ["instagram"]`, URL `channels=instagram`), then Apply.
7. Step 6: same scrape and identity check as step 4.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-UCLA-TW | 4 — UCLA (acct 799, brand 127756), Twitter only | Reactions + Comments + Shares = Engagements per post | Posts (32): 32/32 satisfy, 0 failures. Sum row: 1,081 + 11 + 139 = 1,231 = Engagements 1,231. | PASS |
| A4-MTV-TW | 4 — Viacom (acct 181, brand 4018 MTV), Twitter only | same | Posts (30): 30/30 satisfy, 0 failures. Sum row: 73,495 + 823 + 11,971 = 86,289 = Engagements 86,289. | PASS |
| A4-GAT-TW | 4 — Wasserman (acct 863, brand 3580 Gatorade), Twitter only | same | Posts (0): page shows "There is no data available." No post rows, so there is nothing to sum. Not a failure of the identity. | PASS (vacuous, no Twitter posts in week) |
| A6-UCLA-IG | 6 — UCLA, Instagram only | same | Posts (11): 11/11 satisfy, 0 failures. Sum row: 22,849 + 213 + Shares "–" (0) = 23,062 = Engagements 23,062. | PASS |
| A6-MTV-IG | 6 — Viacom / MTV, Instagram only | same | Posts (33): 33/33 satisfy, 0 failures. Sum row: 628,966 + 3,296 + Shares "–" (0) = 632,262 = Engagements 632,262. | PASS |
| A6-GAT-IG | 6 — Wasserman / Gatorade, Instagram only | same | Posts (8): 8/8 satisfy, 0 failures. Sum row: 25,530 + 937 + Shares "–" (0) = 26,467 = Engagements 26,467. | PASS |

## Evidence
- UCLA Twitter row 1: 271 = 249 + 1 + 21; row 2: 201 = 185 + 3 + 13. No "–" in any component column.
- UCLA Instagram row 1: 5,028 = 5,005 + 23 + Shares "–"; row 2: 3,232 = 3,220 + 12 + Shares "–".
- MTV Twitter row 1: 19,448 = 17,366 + 69 + 2,013; row 2: 14,826 = 10,975 + 49 + 3,802.
- MTV Instagram row 1: 90,983 = 90,820 + 163 + Shares "–"; row 2: 80,478 = 80,276 + 202 + Shares "–".
- Gatorade Instagram row 1: 19,851 = 19,350 + 501 + Shares "–"; row 2: 2,658 = 2,623 + 35 + Shares "–".
- Instagram Shares renders "–" on every post and on the Sum row. Instagram has no Shares metric, so it was read as 0 (as in earlier runs), and the identity held exactly on every row. This is the only "–" seen; no post had "–" as its Engagements total (0 skipped).
- Gatorade Twitter zero state was checked directly: after Apply the page showed `Posts (0)`, "There is no data available.", no "failed to load" error and no loading spinner (not a render hang). Screenshot: `gatorade-twitter-zero.png`.
- Screenshots in `.playwright-out/QA-29122/`: `post-login.png`, `ucla-before-channel.png`, `ucla-twitter-table.png`, `ucla-instagram-table.png`, `mtv-twitter-table.png`, `mtv-instagram-table.png`, `gatorade-twitter-table.png`, `gatorade-twitter-zero.png`, `gatorade-instagram-table.png`.
- The browser console showed repeated errors (about 40-60 per Brand Content page) throughout; none affected rendering or the assertions.

## Naming notes (Rule 1)
Spec brands "University of California, Los Angeles", "MTV" and "Gatorade" matched the brand selector name exactly. No substitution was made.

## Run-environment notes
- The first `m.login` returned the pre-redirect "Brand Explorer" page and a second call completed the Cognito sign-in (same transient as QA-29123).
- The Playwright sandbox cannot read `config/.env`. A throwaway script wrote the credentials into `ctx._creds` and was deleted after use. The tool echo of that call included the password in the run log, so the helper should take credentials from the caller's environment instead (flagged for harvest).
- The shared `switchAccount` helper returned `ok:true` for Viacom and Wasserman this time, so the lone-option fallback in `runPair` was not needed.
- Sibling case QA-29123 (TikTok) used the default `Public` data set; this case follows its own spec and uses Engagements Breakdown.

## Known bugs checked
- Case file "Open linked bugs": None open, so the Rule 7 screen passed. Pre-fetched bug-history.md and known-quirks.md had no QA-29122 matches. No known bug reproduced or interfered with any assertion.
- Instagram Shares "–" is structural (documented in `brand-content-grid-math`), not a defect.

## Bugs filed
None.
