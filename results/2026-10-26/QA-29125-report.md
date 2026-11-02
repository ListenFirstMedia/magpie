# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Verdict: PASS** (scope: Monday rotation, first row HBO Max / HBO Max — see Scope note)

- Run: 2026-10-26 (Monday), unattended headless, Playwright MCP, login `lfiqa@listenfirstmedia.com`, env `app.lfmdev.in` (dev)
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identities evaluated in page JS) with `_shared/playwright-helpers/devprod-helpers.js`
- Date range: default week 2026-10-18..2026-10-24 (unchanged; spec gives no dates)

## Scope note
The Description table lists three Monday accounts (HBO Max, Amazon Prime Video, Conde Nast -> HBO Max, Amazon Prime Video, Vogue-US). Following the case Notes (one account/brand row per weekday) and the 2026-10-20 precedent for this case, only the first Monday pair (HBO Max / HBO Max) was executed. Amazon Prime Video and Conde Nast/Vogue-US were NOT executed. The Notes' weekday mapping ("Mon HBO Max/Viacom") conflicts with the table (Viacom is a Tuesday account) — flagged for case cleanup.

## Steps executed
1. Login via Cognito "With existing account" form (helper `m.login`) -> `#home`. The helper also opened a prod tab (tab 0); it was not used for any step. All work was on the dev tab.
2. Account precondition: switched account via the top-nav account menu to **HBO Max** (`account_id=657`, breadcrumb `ACCOUNT: HBO MAX`).
3. Step 1 — hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content?brand_id=155614`).
4. Step 2 — brand shown in the selector is the exact spec name "HBO Max" (Rule 1, no substitute). Opened the visible data-set dropdown and clicked **Video Views** (URL `table_data_set=video_views`).
5. Step 3 — Twitter only: clicked channel ghosts; verified enabled set = `["twitter"]`; clicked **Apply** (URL `channels=twitter`). `Posts (10)`.
6. Steps 4–5 — switched to **Table View** (`Rank` header verified), scraped all 10 rows + Sum row (Organic, Unclassified, Paid, Video Views, Engagements, Video Response Rate).
7. Step 6 — Instagram only: enabled Instagram and disabled Twitter; verified enabled set = `["instagram"]`; clicked **Apply** (URL `channels=instagram`). `Posts (35)`; all 35 rows link to instagram.com and carry the `fa-instagram` icon, so this is not a stale Twitter table.
8. Steps 7–8 — scraped all 35 rows + Sum row and evaluated both identities.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter only, per post) | Organic + Unclassified + Paid Views = Video Views | 10/10 posts hold (Organic = Video Views, Unclassified 0, Paid "–" treated as 0). Sum row: 154,227 + 0 + 0 = 154,227. | PASS |
| A5 | 5 (Twitter only, per post) | Engagements / Video Views = Video Response Rate | 10/10 posts match the displayed 2-decimal rate (e.g. 957/71,688 = 1.335% shown 1.33%; 268/3,379 = 7.931% shown 7.93%). | PASS |
| A7 | 7 (Instagram only, per post) | Organic + Unclassified + Paid Views = Video Views | 34/34 evaluable posts hold (Paid "–" treated as 0, Unclassified 0). Rank 35 has Video Views "–" (no data) and was skipped. Sum row: 26,638,615 + 0 + 0 = 26,638,615. | PASS |
| A8 | 8 (Instagram only, per post) | Engagements / Video Views = Video Response Rate | 34/34 evaluable posts match the displayed rate within ±0.01 pp (e.g. 247,861/3,787,964 = 6.544% shown 6.54%; 150,471/1,703,579 = 8.833% shown 8.83%). Rank 35 skipped (no data). | PASS |

## Evidence
Twitter only (Rank | Organic | Unclassified | Paid | Video Views | Engagements | shown rate):
| Rank | Organic | Uncl. | Paid | Video Views | Eng. | Rate |
|---|---|---|---|---|---|---|
| 1 | 71,688 | 0 | – | 71,688 | 957 | 1.33% |
| 2 | 26,492 | 0 | – | 26,492 | 818 | 3.09% |
| 3 | 34,902 | 0 | – | 34,902 | 380 | 1.09% |
| 4 | 3,379 | 0 | – | 3,379 | 268 | 7.93% |
| 5 | 3,211 | 0 | – | 3,211 | 257 | 8.00% |
| 6 | 2,113 | 0 | – | 2,113 | 114 | 5.40% |
| 7 | 6,162 | 0 | – | 6,162 | 102 | 1.66% |
| 8 | 2,177 | 0 | – | 2,177 | 69 | 3.17% |
| 9 | 2,703 | 0 | – | 2,703 | 64 | 2.37% |
| 10 | 1,400 | 0 | – | 1,400 | 36 | 2.57% |
| Sum | 154,227 | 0 | – | 154,227 | 3,065 | N/A |

Instagram only: 35 posts; all 34 posts with data hold both identities (Organic == Video Views, Unclassified 0, Paid "–"). Spot rows: #1 3,787,964 VV / 247,861 E / 6.54%; #2 1,703,579 / 150,471 / 8.83%; #13 2,568,867 / 18,532 / 0.72%; #34 75,569 / 695 / 0.92%. Sum row: Engagements 992,012; Video Views = Organic = 26,638,615; Unclassified 0; Paid "–"; rate "N/A". Row totals recomputed from the scrape equal the Sum row (E 992,012; VV 26,638,615).

Notes:
- Rank 35 (Instagram, "That took a turn. #AbbottElementary", Tue Oct 20 2026) has Engagements 216 but Video Views / Organic / rate "–" — a non-video/no-view-data post; treated as "no data" per the skill's judging rule and excluded from A7/A8 (not a failure of the identities).
- Paid Views is "–" on every post in both channels (no paid views in this window); Unclassified Views is 0 everywhere. Treated as 0 per the skill's judging rule.
- Sum row Video Response Rate is "N/A" (not computed at aggregate level); not part of the per-post assertions.
- Screenshots: `.playwright-out/QA-29125/hbomax-content-landing.png`, `hbomax-twitter-table.png`, `hbomax-instagram-table.png`
- Wall-clock rendering was normal; no step approached the 5-minute budget.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-29125 matches (pre-fetched). No known bug reproduced or interfered.

## Bugs filed
None.
