# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Verdict: PASS** (scope: Tuesday rotation, first row UCLA / "University of California, Los Angeles" — see Scope note)

- Run: 2026-10-20 (Tuesday), unattended headless, Playwright MCP, login `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identities recomputed by hand from the scraped values)

## Scope note
The Description table lists three Tuesday accounts (UCLA, Viacom, Wasserman -> University of California, Los Angeles, MTV, Gatorade). Following the case Notes (one account/brand row per weekday) and the QA-29122/QA-29123 precedent from the same set, only the first Tuesday pair (UCLA / University of California, Los Angeles) was executed. Viacom/MTV and Wasserman/Gatorade were NOT executed. The Notes' "Tue UCLA/Sony Pictures" text conflicts with the table (Sony Pictures is a Thursday account) — flagged for case cleanup.

## Steps executed
1. Login via the Cognito "With existing account" form -> `#home`. Landed directly on `account_id=799`, breadcrumb `ACCOUNT: UCLA`, so no account switch was needed (precondition satisfied).
2. Step 1 — hovered **Brand** in the top nav, clicked **Content** (`#explore/brand/content?brand_id=127756`).
3. Step 2 — selected brand shown is the exact spec name "University of California, Los Angeles" (Rule 1; no substitute). Date range left at the default week 2026-10-12..2026-10-18. Opened the visible data-set dropdown and clicked the standard **Video Views** option (not the custom "UCLA Video Views"); URL `table_data_set=video_views`.
4. Step 3 — Twitter only: clicked the Facebook, Instagram, TikTok and LinkedIn channel ghosts off; verified state `twitter enabled`, all others disabled; clicked **Apply** (URL `channels=twitter`).
5. Steps 4–5 — switched to **Table View** (`Rank` header verified), `Posts (7)`; scraped all rows (Organic Views, Paid Views, Unclassified Views, Video Views, Engagements, Video Response Rate).
6. Step 6 — Instagram only: enabled Instagram first, then disabled Twitter; verified `instagram enabled`, all others disabled; clicked **Apply** (URL `channels=instagram`). Table rows carry the `fa-instagram` icon and link to instagram.com/ucla, so it is not a stale Twitter table.
7. Steps 7–8 — `Posts (7)`; scraped all rows and evaluated both identities.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter only, per post) | Organic + Unclassified + Paid Views = Video Views | 7/7 posts hold (Organic = Video Views, Unclassified 0, Paid "–" treated as 0). Sum row: 2,663 + 0 + 0 = 2,663. | PASS |
| A5 | 5 (Twitter only, per post) | Engagements / Video Views = Video Response Rate | 7/7 posts match the displayed 2-decimal rate (e.g. 68/458 = 14.85%, 23/705 = 3.26%, 6/149 = 4.03%). | PASS |
| A7 | 7 (Instagram only, per post) | Organic + Unclassified + Paid Views = Video Views | 7/7 posts hold (Paid "–" treated as 0, Unclassified 0). Sum row: 425,637 + 0 + 0 = 425,637. | PASS |
| A8 | 8 (Instagram only, per post) | Engagements / Video Views = Video Response Rate | 7/7 posts match the displayed 2-decimal rate (e.g. 1,591/72,776 = 2.19%, 346/49,812 = 0.69%, 250/56,162 = 0.45%). | PASS |

## Evidence
Twitter only (Engagements, Video Views, displayed rate, computed rate):
| Rank | E | Video Views (= Organic) | Shown | Computed |
|---|---|---|---|---|
| 1 | 68 | 458 | 14.85% | 14.847% |
| 2 | 44 | 422 | 10.43% | 10.427% |
| 3 | 41 | 381 | 10.76% | 10.761% |
| 4 | 23 | 705 | 3.26% | 3.262% |
| 5 | 18 | 312 | 5.77% | 5.769% |
| 6 | 13 | 236 | 5.51% | 5.508% |
| 7 | 6 | 149 | 4.03% | 4.027% |
| Sum | 213 | 2,663 | N/A | 8.00% |

Instagram only:
| Rank | E | Video Views (= Organic) | Shown | Computed |
|---|---|---|---|---|
| 1 | 1,591 | 72,776 | 2.19% | 2.186% |
| 2 | 1,249 | 69,383 | 1.80% | 1.800% |
| 3 | 1,109 | 57,192 | 1.94% | 1.939% |
| 4 | 779 | 52,266 | 1.49% | 1.490% |
| 5 | 493 | 68,046 | 0.72% | 0.725% |
| 6 | 346 | 49,812 | 0.69% | 0.695% |
| 7 | 250 | 56,162 | 0.45% | 0.445% |
| Sum | 5,817 | 425,637 | N/A | 1.37% |

- Column totals of the rows equal the Sum row in both channels (Twitter E 213 / VV 2,663; Instagram E 5,817 / VV 425,637).
- The aggregate Sum row shows Video Response Rate "N/A" (not computed at aggregate level). Not part of the assertions, which are per post; noted only.
- Paid Views is "–" on every post in both channels (no paid views in this window); Unclassified Views is 0 everywhere. Treated as 0 per the skill's judging rule.
- Screenshots: `.playwright-out/QA-29125/ucla-twitter-table.png`, `.playwright-out/QA-29125/ucla-instagram-table.png`
- Browser console showed repeated errors throughout (up to ~55 per page); none affected rendering or the assertions.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-29125 matches (pre-fetched). No known bug reproduced or interfered.

## Bugs filed
None.
