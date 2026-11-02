# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Verdict: PASS**

- Run: 2026-10-26 (Monday), headless unattended, Playwright MCP, app.lfmdev.in (dev)
- Skills used: `brand-content-grid-math` (Table View scrape), `switch-account` (inline), `brand-content-native-post-check` (date picker)

## Setup / precondition
- Weekday rotation (Description table, authoritative): **Monday = HBO Max / Amazon Prime Video / Conde Nast**; brands HBO Max / Amazon Prime Video / Vogue-US. Used the first pair: **Account HBO Max, Brand "HBO Max"**. The case's "Notes" line lists a different Monday rotation (HBO Max/Viacom) that conflicts with the Description table; not followed (same call as the 2026-10-20 run).
- Logged in as lfiqa@listenfirstmedia.com (landed on account Disney Ad Sales), switched via LFQA menu -> Search Account -> Results row `HBO Max`; breadcrumb `ACCOUNT: HBO MAX` (account_id=657).
- Brand loaded by default on Brand > Content: **HBO Max** (brand_id=155614), the exact spec name (Rule 1, no substitute).

## Steps executed
1. Hover Brand -> Content (top nav). Done (`#explore/brand/content`; screenshot 01).
2. Brand = HBO Max; Data Set dropdown (visible one) -> **Video Views** (URL `table_data_set=video_views`).
3. Date picker: START Jan 01, 2024, END Dec 31, 2024, Ok (URL `from=2024-01-01&to=2024-12-31`; screenshot 02).
4. Explicit ghost clicks disabled Twitter, Instagram, Facebook and LinkedIn; TikTok left enabled. Ghost states verified: only `tiktok enabled` (Threads/YouTube/Pinterest stay disabled by the data set). Apply -> URL `channels=tiktok` (screenshot 03).
5. Table View scrape of the rendered posts + Sum row: Organic Views, Unclassified Views, Paid Views vs Video Views.
6. Engagements and Video Views recorded; Engagements / Video Views compared with Video Response Rate.

## Evidence (TikTok only, Jan 1 – Dec 31 2024)
- Header shows **Posts (2,188)**; Table View renders the top **200** (ranks 1..200) plus the Sum/Average row. The identities were evaluated on all 200 rendered posts and on the Sum row.
- Sum row: Engagements 56,655,505 | Video Response Rate N/A | Video Views 1,361,465,573 | Organic Views – | Paid Views – | Unclassified Views 1,361,465,573 | Video Views (with Cross-Posts) 1,361,465,573.
- Sum row identity: 0 (Organic –) + 0 (Paid –) + 1,361,465,573 = 1,361,465,573 = Video Views. OK.
- Rendered 200 posts, independent sums from the scrape: Engagements 38,095,021; Video Views 883,673,118; Organic 0; Paid 0; Unclassified 883,673,118.

Sample rows (Rank | Date | Engagements | Displayed VRR | Video Views | Organic | Paid | Unclassified):
| Rank | Date | Eng | VRR | Video Views | Organic | Paid | Unclassified |
|---|---|---|---|---|---|---|---|
| 1 | Thu Apr. 18, 2024 | 1,539,849 | 6.75% | 22,825,871 | – | – | 22,825,871 |
| 2 | Sun Nov. 17, 2024 | 1,391,310 | 8.67% | 16,043,426 | – | – | 16,043,426 |
| 3 | Mon Apr. 15, 2024 | 986,647 | 1.04% | 94,950,784 | – | – | 94,950,784 |
| 4 | Sun Nov. 24, 2024 | 801,784 | 7.57% | 10,598,039 | – | – | 10,598,039 |
| 5 | Mon Jun. 17, 2024 | 714,982 | 1.95% | 36,728,260 | – | – | 36,728,260 |

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Organic + Unclassified + Paid Views = Video Views, every post | 200/200 rendered posts equal (0 failures, 0 skipped; "–" cells treated as 0). Sum row also equal (0 + 0 + 1,361,465,573 = 1,361,465,573). | PASS |
| A6 | 6 | Engagements / Video Views = Video Response Rate | 200/200 within rounding of the 2-decimal display (max delta 0.0050 pp, display rounding only), 0 failures, 0 skipped | PASS |

Screenshots: `.playwright-out/QA-29235/01-content.png`, `02-datepicker-set.png`, `03-tiktok-applied.png`, `04-tiktok-table.png`.

## Observations (not affecting verdict)
- Only the top 200 of 2,188 TikTok posts render in Table View (no pager found), so the per-post check covers those 200. The Sum row covers all posts and also satisfies the identity.
- Organic Views and Paid Views render "–" on every one of the 200 posts and in the Sum row; the views are entirely Unclassified, and the identity holds with Organic = Paid = 0.
- The Sum row's Video Response Rate shows "N/A" (the spec asserts only per-post values). Sum-row Eng/VV would be 56,655,505 / 1,361,465,573 = 4.16%. Not asserted.
- The Channel column renders icon-only (empty text) in the scrape; the channel was confirmed through URL `channels=tiktok` and the ghost `.enabled` state.
- The `Posts (N)` text was not present immediately after Apply (grid still loading); it appeared once Table View rendered.
- Console showed many app errors throughout (dev); none affected the Content grid.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-29235 (pre-fetched). No known bug reproduced; no regression observed.

## Bugs filed
- None.
