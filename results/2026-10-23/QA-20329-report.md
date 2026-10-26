# QA-20329 — Brand Content > Instagram Only: Insights > Past date range data test

**Run:** 2026-10-23 (Friday), unattended headless (`claude -p`, Playwright MCP) — dev env `app.lfmdev.in`
**Verdict: PASS**

## Setup (per weekday rotation — Friday)
- Account: **Hulu** (account_id=336) — switched from the default HBO Max via the LFQA menu → Search Account → Results row `Hulu`. Breadcrumb/URL confirmed `account_id=336`.
- Brand: **Hulu** (brand_id=5670) — the Brand menu's default brand for the account, exact name match with the spec (Rule 1). Ralph Lauren (second Friday row) not run — one account/brand row per weekday run.
- View: Authorized data (`perspective=extended` default; spec names no perspective).

## Steps executed
1. Hovered **Brand** in the top nav → clicked **Content** (`#explore/brand/content?brand_id=5670`). Page loaded (Posts count rendered within ~30 s).
2. Opened the Date Range picker (Mode: Lifetime), set START DATE and END DATE via the datepicker (year → month → day). Picker showed `START DATE Jan 01, 2024 / END DATE Dec 31, 2024`; clicked **Ok**. URL `from=2024-01-01&to=2024-12-31`. (Screenshot 02.)
3. Data Set dropdown → **Instagram Only: Insights** (URL `table_data_set=instagram_only%3A_insights`). Channels auto-narrowed to Instagram only (`.channel-ghost.instagram.enabled`, all others disabled). (Screenshot 03.)
4. Switched to **Table View**. `Posts (1,117)`; 200 posts rendered (top 200, sorted by the dataset's default sort) plus the Sum/Average aggregate row, no table error. Scraped every rendered row in page JS: columns `Saves` (idx 12), `Organic Saves` (13), `Paid Saves` (14). Compared Organic Saves + Paid Saves to Saves for each post and for the aggregate Sum row. (Screenshot 04.)

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4 | Per post: Paid Saves + Organic Saves = Saves | 200 rendered posts, 0 failures. 10 posts show all three values numerically and match exactly; the other 190 show Organic Saves = Saves with Paid Saves "–" (no paid component → treated as 0), so Saves = Organic + 0 holds. | PASS |
| A2 | 4 | Aggregate (Sum row): Organic + Paid = Saves | 1,175,883 + 23,450 = 1,199,333 = Saves Sum 1,199,333 (diff 0), covering all 1,117 posts. | PASS |

## Evidence
- Sum row (toggle on Sum): Saves 1,199,333; Organic Saves 1,175,883; Paid Saves 23,450.
- The 10 posts with a numeric Paid Saves (rank: Saves = Organic + Paid): 4: 9,187 = 768 + 8,419; 49: 3,990 = 516 + 3,474; 82: 1,035 = 834 + 201; 92: 735 = 86 + 649; 93: 1,358 = 86 + 1,272; 98: 330 = 315 + 15; 101: 942 = 206 + 736; 105: 4,429 = 834 + 3,595; 120: 1,323 = 561 + 762; 170: 1,121 = 1,118 + 3.
- Example no-paid posts: rank 1 (Fri Jan. 05, 2024 05:47 PM PST, Video) Saves 39,850 = Organic 39,850, Paid "–"; rank 200 (Tue Dec. 31, 2024 09:31 PM PST) 923 = 923, Paid "–".
- Rendered-200 totals: Saves 979,349 = Organic 960,223 + Paid 19,126.
- Scrape result: `{total:200, exact-with-numeric-paid:10, paid-dash-treated-as-0:190, failures:0, all-dash rows:0}`.
- Observation (not a verdict factor): 53 of the 200 posts carry the Paid-post `$` icon, but only 10 of those have a numeric Paid Saves; the other 43 show "–" with Saves = Organic Saves. Whether those are true zeros or unreported is not determinable from the grid; the assertion (Saves = Paid + Organic) holds either way on the displayed values.
- Limitation: the table renders only the top 200 of 1,117 posts (no pagination); the identity is verified on those 200 plus the aggregate row, which covers all 1,117.
- Screenshots: `.playwright-out/QA-20329/` — 01 (Brand Content landing, Hulu), 02 (date picker Jan 01 – Dec 31 2024), 03 (Instagram Only: Insights), 04 (Table View).

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-19)": none open → Rule 7 screen passed. PRE-FETCHED `knowledge-base/bug-history.md` and `known-quirks.md` greps for QA-20329: no matches. `results/open-bugs-2026-10-23.json` has no entry for QA-20329.
- Related surface: the Facebook Data Collection Disruption 9/27 status banner is displayed but affects Facebook only; this case is Instagram-only, so no interference.

## Bugs filed
None.

## Notes for harvest
- Reused `brand-content-grid-math` (data-set-first ordering, visible dropdown, Table View scrape) and `brand-content-native-post-check` (date picker); `switch-account` flow for HBO Max → Hulu was clean. No skill drift.
- New detail for the grid-math skill: Instagram Only: Insights has `Saves / Organic Saves / Paid Saves` at table cols 12/13/14; Paid Saves renders "–" on most posts, including many paid-flagged ones.
