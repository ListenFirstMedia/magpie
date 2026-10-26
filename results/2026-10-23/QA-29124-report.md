# QA-29124 — Brand Content - Basic Data Set - Data Test - LinkedIn

**Verdict: PASS**

**Run date:** 2026-10-23 · **Track:** Playwright MCP, unattended (`claude -p`) · **Env:** app.lfmdev.in
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · **Date range:** default week Oct. 15 – Oct. 21, 2026 (Mode: Lifetime) · **Channel:** LinkedIn only · **Data set:** Public (Basic) · **Perspective:** Authorized (default, `perspective=extended`)

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Precondition: logged in on UCLA account | Programmatic login (lfiqa); breadcrumb after login read `ACCOUNT: UCLA`, URL `account_id=799`. No switch needed. (shot 01) |
| 1 | Hover Brand → Content in top nav | Hovered `Brand`, clicked the `Content` submenu link → `#explore/brand/content?brand_id=127756`. (shot 02) |
| 2 | Add a Brand as UCLA | Opened the brand chevron, typed `UCLA` (slowly). The typeahead returned 70 `UCLA …` brands but **no brand named exactly "UCLA"** (shot 03). The account's own brand is "University of California, Los Angeles"; earlier runs of this set (QA-29124 / 29129 / 29236 / 29237, 2026-10-19/20) treated that as the spec's UCLA. Typed `University of California, Los`, clicked the exact result "University of California, Los Angeles" → brand_id=127756. See "Notes". |
| 3 | Enable LinkedIn channel only | Clicked off Facebook, X, Instagram, TikTok, Threads (LinkedIn stays enabled); verified `.channel-ghost.linkedin.enabled` and all others disabled; clicked **Apply** → URL `channels=linkedin`. Posts (31). (shot 04) |
| 4 | Add Reactions + Comments + Shares for each grid post | Switched to Table View (`[title="Table View"]`), scraped all 31 rendered rows via DOM (`Posts (31)`, 31 rows + Sum/Average aggregate row). Evaluated Reactions + Comments + Shares vs Engagements for every row in page JS. (shot 05) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For each post, Reactions + Comments + Shares = Engagements | 31 of 31 posts match exactly; 0 mismatches; 0 skipped (no "–" values in any of the four columns) | PASS |
| A4-agg | 4 (extra check) | Same identity holds on the Sum row | Sum row: 2,696 + 60 + 89 = 2,845 = Engagements 2,845 | PASS |

## Evidence (Table View, LinkedIn only, Oct 15–21 2026; Rank | Engagements | Reactions | Comments | Shares)
1|688|669|7|12 · 2|459|439|10|10 · 3|190|183|2|5 · 4|172|154|5|13 · 5|168|158|6|4 · 6|144|136|2|6 · 7|138|134|3|1 · 8|130|122|1|7 · 9|77|71|0|6 · 10|64|61|2|1 · 11|64|57|7|0 · 12|53|52|0|1 · 13|46|46|0|0 · 14|45|42|2|1 · 15|41|39|0|2 · 16|41|41|0|0 · 17|40|37|0|3 · 18|32|26|2|4 · 19|31|28|2|1 · 20|31|26|2|3 · 21|28|25|0|3 · 22|26|21|5|0 · 23|26|24|2|0 · 24|21|20|0|1 · 25|21|18|0|3 · 26|18|17|0|1 · 27|15|14|0|1 · 28|13|13|0|0 · 29|9|9|0|0 · 30|8|8|0|0 · 31|6|6|0|0

All 31 rows' Brand cell = "University of California, Los Angeles". The Channel column is an icon (no text); the LinkedIn-only scope is confirmed by `channels=linkedin` in the URL and the disabled state of every other channel ghost.

Screenshots: `.playwright-out/QA-29124/` — 01-home-after-login.png, 02-brand-content-landing.png, 03-brand-typeahead-UCLA.png, 04-linkedin-only-applied.png, 05-table-view-linkedin.png.

## Notes
- **Brand name (Rule 1):** no brand named exactly "UCLA" exists in the dev typeahead. I used the UCLA account's own brand "University of California, Los Angeles", as the earlier runs of this case did. If the spec means a different brand, this verdict would need a re-run. This is not a substitution of a related brand: it is the account's primary brand.
- Two harness slips during the run, neither affecting results: an over-broad selector opened the Help Center (Zendesk) in a second tab, which I closed immediately; and my first "exact UCLA" check matched the search textarea itself, so I re-inspected the option list only.
- Facebook Data Collection Disruption banner (9/27) is shown but irrelevant to a LinkedIn-only scope.
- Console shows many errors on the app throughout (pre-existing; not related to the assertion).

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md: no entry for QA-29124. known-quirks.md: no entry for QA-29124.
- Observed behaviour: no bug reproduced; no interference with the assertion.

## Bugs filed
None.
