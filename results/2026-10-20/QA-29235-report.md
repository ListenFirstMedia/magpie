# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Verdict: PASS**

- Run: 2026-10-20 (Tuesday), headless unattended, Playwright MCP, app.lfmdev.in (dev)
- Skills used: `brand-content-grid-math` (Table View scrape), `switch-account`, `brand-content-native-post-check` (date picker)

## Setup / precondition
- Weekday rotation (Description table, authoritative): **Tuesday = UCLA / Viacom / Wasserman**; brands *University of California, Los Angeles*, MTV, Gatorade. Used **Account UCLA, Brand "University of California, Los Angeles"** (first Tuesday pair). The case's "Notes" line lists a different rotation (Tue UCLA/Sony Pictures) that conflicts with the Description table; it was not followed (same call as QA-29234).
- Logged in as lfiqa@listenfirstmedia.com (landed on account HBO Max, account_id=336), switched via LFQA menu -> Search Account -> Results row `UCLA`; breadcrumb `ACCOUNT: UCLA` (account_id=799).
- Brand loaded by default: University of California, Los Angeles (brand_id=127756), the exact spec name (Rule 1, no substitute).

## Steps executed
1. Hover Brand -> Content (top nav). Done (`#explore/brand/content`).
2. Brand = University of California, Los Angeles; Data Set dropdown -> **Video Views** (URL `table_data_set=video_views`).
3. Date picker: START Jan 01, 2024, END Dec 31, 2024, Ok (URL `from=2024-01-01&to=2024-12-31`; screenshot 02).
4. Explicit ghost clicks disabled Twitter, Instagram, Facebook and LinkedIn; TikTok left enabled; Apply (URL `channels=tiktok`; ghost states verified: only `tiktok enabled`). Posts (175).
5. Table View scrape of all 175 posts + Sum row: Organic Views, Unclassified Views, Paid Views vs Video Views.
6. Engagements and Video Views recorded; Engagements / Video Views compared with Video Response Rate.

## Evidence (TikTok only, Jan 1 – Dec 31 2024, 175 posts, ranks 1..175)
Sum row: Engagements 279,051 | Video Response Rate N/A | Video Views 28,460,298 | Organic Views – | Paid Views 20,506,954 | Unclassified Views 7,953,344.
Independent per-post sums from the scrape: Engagements 279,051; Video Views 28,460,298; Paid 20,506,954; Unclassified 7,953,344. These match the Sum row exactly.

Sample rows (Rank | Date | Engagements | Displayed VRR | Video Views | Organic | Paid | Unclassified):
| Rank | Date | Eng | VRR | Video Views | Organic | Paid | Unclassified |
|---|---|---|---|---|---|---|---|
| 1 | Thu Feb. 15, 2024 | 30,257 | 7.00% | 431,958 | – | 172,730 | 259,228 |
| 2 | Tue Apr. 09, 2024 | 21,152 | 0.65% | 3,243,934 | – | 2,969,994 | 273,940 |
| 3 | Thu Mar. 14, 2024 | 18,259 | 5.50% | 332,230 | – | 56,808 | 275,422 |
| 4 | Wed Nov. 20, 2024 | 17,409 | 10.03% | 173,564 | – | – | 173,564 |
| 5 | Tue Mar. 19, 2024 | 17,066 | 0.33% | 5,200,000 | – | 4,793,532 | 406,468 |
| 175 | Wed Jul. 31, 2024 | 4 | 2.40% | 167 | – | – | 167 |

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Organic + Unclassified + Paid Views = Video Views, every post | 175/175 posts equal (0 failures, 0 skipped). "–" cells treated as 0. | PASS |
| A6 | 6 | Engagements / Video Views = Video Response Rate | 175/175 within rounding of the 2-decimal display (max delta 0.0050 pp, i.e. display rounding only), 0 failures, 0 skipped | PASS |

Screenshots: `.playwright-out/QA-29235/01-content.png`, `02-datepicker-set.png`, `03-tiktok-applied.png`, `04-tiktok-table.png`.

## Observations (not affecting verdict)
- Organic Views renders "–" on every one of the 175 TikTok posts and in the Sum row (structurally absent here). Views are split entirely between Paid and Unclassified, and the identity holds with Organic = 0.
- The Sum row's Video Response Rate shows "N/A" (the spec asserts only per-post values). Sum-row Eng/VV would be 279,051 / 28,460,298 = 0.98%. Not asserted.
- The Channel column renders icon-only (empty text) in the scrape. The channel was confirmed through the URL `channels=tiktok` and ghost `.enabled` state.
- Console showed many app errors throughout (dev); none affected the Content grid.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-29235 (known-quirks has no TikTok Video Views quirk). No known bug reproduced; no regression observed.

## Bugs filed
- None.
