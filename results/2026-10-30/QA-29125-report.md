# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Verdict: PASS** (scope: Friday rotation, Hulu account / Hulu brand — see Scope note)

- Run: 2026-10-30 (Friday), unattended headless, Playwright MCP, dev (app.lfmdev.in), login `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identities evaluated in page JS) with `devprod-helpers.js`
- Data set: Video Views (`table_data_set=video_views`), date range app default 2026-10-22 .. 2026-10-28 (spec names none; not changed), perspective left at the app default

## Scope note
The Description table's Friday row lists accounts Hulu, Robinhood, PlayOn! Sports but only one brand, "Hulu"; the brand cells for Robinhood and PlayOn! Sports are blank, so only Hulu / Hulu was executed (following the earlier days' first-pair precedent). The case Notes' "Fri Hulu/Ralph Lauren" conflicts with the table (Ralph Lauren is a Thursday account) — flagged for case cleanup. Robinhood and PlayOn! Sports were NOT executed (no brand specified).

## Pre-screen (Rule 7)
Case file "Open linked bugs": none open. Pre-fetched bug-history/known-quirks had no QA-29125 hit for Friday. Screen passed; case run.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK, `#home`, breadcrumb `ACCOUNT: HULU` (account_id=336) — precondition satisfied without a switch |
| 1 | Hover Brand, click Content | OK (`#explore/brand/content?brand_id=5670&account_id=336`) |
| 2 | Brand = "Hulu" (selector reads exactly `Hulu`, brand_id=5670, Rule 1); Data Set dropdown -> "Video Views" | OK, visible data-set box reads "Video Views", URL `table_data_set=video_views` (`f1-hulu-vv.png`) |
| 3 | Only Twitter: verified `.channel-ghost.enabled` = [twitter], Apply | OK, URL `channels=twitter`, Posts (29) |
| 4-5 | Table View (`Rank` header verified), scraped Organic / Paid / Unclassified / Video Views / Engagements / Video Response Rate for all 29 rows + Sum row | OK (`f2-hulu-twitter-table.png`) |
| 6 | Only Instagram: enabled Instagram first, disabled Twitter, verified enabled = [instagram], Apply | OK, URL `channels=instagram`, Posts (43); row links point to instagram.com/hulu so it is not a stale Twitter table |
| 7-8 | Table View, scraped all 43 rows + Sum row | OK (`f3-hulu-instagram-table.png`) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter only, per post) | Organic + Unclassified + Paid Views = Video Views | 27/27 posts with Video Views hold (Organic = Video Views, Unclassified 0, Paid "–" treated as 0). Ranks 28-29 show "–" on every view metric (Engagements 6 and 1) = no data, skipped. Sum row: 262,849 + 0 + 0 = 262,849. | PASS |
| A5 | 5 (Twitter only, per post) | Engagements / Video Views = Video Response Rate | 27/27 match the displayed 2-decimal rate (e.g. 629/10,319 = 6.10%, 375/29,181 = 1.29%, 166/159,534 = 0.10%, 9/116 = 7.76%). Sum-row rate shows "N/A" (not a per-post value). | PASS |
| A7 | 7 (Instagram only, per post) | Organic + Unclassified + Paid Views = Video Views | 41/41 posts with Video Views hold, including the three paid-split posts: rank 13 = 598,814 + 1,360,841 = 1,959,655; rank 14 = 469,198 + 290,236 = 759,434; rank 40 = 21,541 + 4,341 = 25,882. Ranks 42-43 show "–" (Engagements 64 and 58) = no data, skipped. Sum row: 13,821,692 + 1,655,418 + 0 = 15,477,110. | PASS |
| A8 | 8 (Instagram only, per post) | Engagements / Video Views = Video Response Rate | 41/41 match the displayed 2-decimal rate (e.g. 72,804/1,076,721 = 6.76%, 11,776/1,959,655 = 0.60%, 392/25,882 = 1.51%). | PASS |

## Evidence
Twitter only (29 posts, Sum row Engagements 2,468; Video Views 262,849 = Organic 262,849; Paid "–"; Unclassified 0):
| Rank | Engagements | Video Views | Shown | Computed |
|---|---|---|---|---|
| 1 | 629 | 10,319 | 6.10% | 6.10 |
| 2 | 375 | 29,181 | 1.29% | 1.29 |
| 4 | 166 | 159,534 | 0.10% | 0.10 |
| 27 | 9 | 116 | 7.76% | 7.76 |

Instagram only (43 posts, Sum row Engagements 482,911; Video Views 15,477,110; Organic 13,821,692; Paid 1,655,418; Unclassified 0):
| Rank | Engagements | Organic | Paid | Video Views | Shown | Computed |
|---|---|---|---|---|---|---|
| 1 | 72,804 | 1,076,721 | – | 1,076,721 | 6.76% | 6.76 |
| 13 | 11,776 | 598,814 | 1,360,841 | 1,959,655 | 0.60% | 0.60 |
| 14 | 11,218 | 469,198 | 290,236 | 759,434 | 1.48% | 1.48 |
| 40 | 392 | 21,541 | 4,341 | 25,882 | 1.51% | 1.51 |

Screenshots: `.playwright-out/QA-29125/f1-hulu-vv.png`, `f2-hulu-twitter-table.png`, `f3-hulu-instagram-table.png`.

## Known bugs checked
Case file lists no open linked bugs; bug-history has no QA-29125 entry. No known bug reproduced or interfered with the assertions. The only anomaly is four posts (Twitter ranks 28-29, Instagram ranks 42-43) with Engagements but "–" for all view metrics; treated as "no data" per the grid-math skill (total Video Views is "–", so no identity is evaluable). Not filed as a bug (consistent with documented collection gaps).

## Bugs filed
None.
