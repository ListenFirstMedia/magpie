# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Verdict: PASS** (Tuesday rotation, all three rows: UCLA / MTV / Gatorade; Gatorade Twitter leg has no posts, so not evaluable)

- Run: 2026-10-27 (Tuesday), unattended headless, Playwright MCP, login `lfiqa@listenfirstmedia.com`, env `app.lfmdev.in` (dev)
- Skill used: `brand-content-grid-math` (Table View DOM scrape, identities evaluated in page JS) with `_shared/playwright-helpers/devprod-helpers.js`
- Date range: default week 2026-10-19..2026-10-25 (spec gives no dates, left unchanged)
- Data set: Video Views (`table_data_set=video_views`), Include Retweets off (default)

## Scope note
Tuesday rows in the Description table: UCLA -> University of California, Los Angeles; Viacom -> MTV; Wasserman -> Gatorade. All three were executed (the earlier runs on 2026-10-20 and 2026-10-26 executed only the first row). The case Notes' weekday mapping ("Tue UCLA/Sony Pictures") conflicts with the table (Sony Pictures is a Thursday account); the table was followed. Flagged for case cleanup.

## Steps executed (per row)
1. Logged in via the Cognito "With existing account" form (helper `m.login`). The helper also opened a prod tab (tab 0); it was not used for any step.
2. Switched account via the top-nav account menu: UCLA (`account_id=799`, breadcrumb confirmed), Wasserman (`account_id=863`, breadcrumb confirmed). Viacom: the switch ran through the same helper and the brand then resolved to MTV, but the helper's switch result was not captured in the output (see Notes).
3. Step 1: hovered **Brand** in the top nav and clicked **Content**.
4. Step 2: brand selector showed the exact spec brand (UCLA row: already "University of California, Los Angeles"; MTV and Gatorade selected from the typeahead by exact match; the Brand column of every scraped row equals the spec brand). Opened the visible data-set dropdown and clicked **Video Views**.
5. Step 3: Twitter only: clicked channel ghosts, verified enabled set = `["twitter"]`, clicked **Apply** (URL `channels=twitter`).
6. Steps 4-5: switched to **Table View** (`Rank` header verified), scraped all rows plus the Sum row, evaluated both identities. Every row's link host was twitter.com.
7. Step 6: Instagram only: enabled Instagram, disabled Twitter, verified enabled set = `["instagram"]`, clicked **Apply**. Every row's link host was instagram.com, so the table is not stale.
8. Steps 7-8: same scrape and evaluation.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 UCLA | 4 (Twitter) | Organic + Unclassified + Paid = Video Views | 8/8 posts hold. Sum row 6,068 + 0 + 0 = 6,068 | PASS |
| A5 UCLA | 5 (Twitter) | Engagements / Video Views = Video Response Rate | 8/8 match within 0.01 pp (e.g. 177/1,288 = 13.74%) | PASS |
| A7 UCLA | 7 (Instagram) | Sum identity | 8/8 hold. Sum row 682,494 + 0 + 0 = 682,494 | PASS |
| A8 UCLA | 8 (Instagram) | Rate identity | 8/8 match (e.g. 2,624/73,176 = 3.59%) | PASS |
| A4 MTV | 4 (Twitter) | Sum identity | 6/6 hold. Sum row 12,871 | PASS |
| A5 MTV | 5 (Twitter) | Rate identity | 6/6 match (e.g. 102/3,555 = 2.87%) | PASS |
| A7 MTV | 7 (Instagram) | Sum identity | 11/11 hold. Sum row 1,411,595 | PASS |
| A8 MTV | 8 (Instagram) | Rate identity | 11/11 match (e.g. 14,461/249,990 = 5.78%) | PASS |
| A4 Gatorade | 4 (Twitter) | Sum identity | `Posts (0)`, "There is no data available." No posts to evaluate | N/A (no data) |
| A5 Gatorade | 5 (Twitter) | Rate identity | No posts to evaluate | N/A (no data) |
| A7 Gatorade | 7 (Instagram) | Sum identity | 5/5 hold. Sum row 1,021,347 | PASS |
| A8 Gatorade | 8 (Instagram) | Rate identity | 5/5 match (e.g. 19,851/818,968 = 2.42%) | PASS |

## Evidence
Columns: Rank | Organic | Unclassified | Paid | Video Views | Engagements | shown rate. Paid Views is "–" on every post (treated as 0); Unclassified is 0 everywhere.

UCLA Twitter (Sum row: Organic 6,068, Video Views 6,068, Engagements 463, rate N/A):
1 | 1,288 | 0 | – | 1,288 | 177 | 13.74%; 2 | 2,309 | 0 | – | 2,309 | 129 | 5.59%; 3 | 583 | 0 | – | 583 | 69 | 11.84%; 4 | 529 | 0 | – | 529 | 33 | 6.24%; 5 | 483 | 0 | – | 483 | 25 | 5.18%; 6 | 375 | 0 | – | 375 | 13 | 3.47%; 7 | 280 | 0 | – | 280 | 12 | 4.29%; 8 | 221 | 0 | – | 221 | 5 | 2.26%

UCLA Instagram (Sum row: Video Views 682,494, Engagements 12,057):
1 | 73,176 | 0 | – | 73,176 | 2,624 | 3.59%; 2 | 126,217 | 0 | – | 126,217 | 2,158 | 1.71%; 3 | 74,022 | 0 | – | 74,022 | 1,975 | 2.67%; 4 | 77,143 | 0 | – | 77,143 | 1,856 | 2.41%; 5 | 99,287 | 0 | – | 99,287 | 1,338 | 1.35%; 6 | 65,160 | 0 | – | 65,160 | 723 | 1.11%; 7 | 102,371 | 0 | – | 102,371 | 715 | 0.70%; 8 | 65,118 | 0 | – | 65,118 | 668 | 1.03%

MTV Twitter (Sum row: Video Views 12,871, Engagements 376):
1 | 3,555 | 0 | – | 3,555 | 102 | 2.87%; 2 | 1,706 | 0 | – | 1,706 | 71 | 4.16%; 3 | 2,047 | 0 | – | 2,047 | 67 | 3.27%; 4 | 1,644 | 0 | – | 1,644 | 50 | 3.04%; 5 | 2,401 | 0 | – | 2,401 | 49 | 2.04%; 6 | 1,518 | 0 | – | 1,518 | 37 | 2.44%

MTV Instagram (Sum row: Video Views 1,411,595, Engagements 67,357):
1 | 249,990 | 0 | – | 249,990 | 14,461 | 5.78%; 2 | 187,143 | 0 | – | 187,143 | 14,293 | 7.64%; 3 | 123,190 | 0 | – | 123,190 | 11,190 | 9.08%; 4 | 194,335 | 0 | – | 194,335 | 10,772 | 5.54%; 5 | 172,442 | 0 | – | 172,442 | 8,202 | 4.76%; 6 | 120,231 | 0 | – | 120,231 | 3,739 | 3.11%; 7 | 96,296 | 0 | – | 96,296 | 1,749 | 1.82%; 8 | 75,139 | 0 | – | 75,139 | 1,044 | 1.39%; 9 | 102,924 | 0 | – | 102,924 | 927 | 0.90%; 10 | 41,077 | 0 | – | 41,077 | 538 | 1.31%; 11 | 48,828 | 0 | – | 48,828 | 442 | 0.91%

Gatorade Instagram (Sum row: Video Views 1,021,347, Engagements 23,415):
1 | 818,968 | 0 | – | 818,968 | 19,851 | 2.42%; 2 | 84,614 | 0 | – | 84,614 | 2,658 | 3.14%; 3 | 103,579 | 0 | – | 103,579 | 444 | 0.43%; 4 | 7,449 | 0 | – | 7,449 | 282 | 3.79%; 5 | 6,737 | 0 | – | 6,737 | 180 | 2.67%

Gatorade Twitter: `Posts (0)`, page text "There is no data available. Please select a different brand, brand set, or date range." Twitter was verified as the only enabled channel (`["twitter"]`) before the empty state was read.

Screenshots (`.playwright-out/QA-29125/`): `ucla-twitter-table.png`, `ucla-instagram-table.png`, `mtv-twitter-table.png`, `mtv-instagram-table.png`, `gatorade-instagram-table.png`, `gatorade-twitter-table.png`. The first five were saved by the run script after each scrape; I did not open them, and the verdicts rest on the DOM scrape.

## Notes
- The scrape's `Channel` column is an icon (empty text), so channel purity was confirmed from each row's permalink host (all twitter.com on the Twitter legs, all instagram.com on the Instagram legs).
- The Viacom account-switch result (`m.switchAccount` return value) was lost when a later step in the same script threw, and I did not re-verify the account breadcrumb for the MTV leg. The MTV brand was selected by exact-name typeahead match and every MTV row's Brand column reads "MTV". UCLA and Wasserman breadcrumbs were confirmed.
- Gatorade Twitter has no posts in the default week; this is "no data", not an identity failure. If the case requires Twitter data for every brand, test data for Gatorade would need a different date range. The spec gives none, so none was substituted.
- Sum-row Video Response Rate is "N/A" (not computed at aggregate level); not part of the per-post assertions.
- No step approached the 5-minute budget. No console errors on the dev tab.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-29125 matches (pre-fetched). No known bug reproduced or interfered.

## Bugs filed
None.
