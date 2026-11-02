# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: PASS** (A6 is vacuous: Reach, Organic Reach and Paid Reach are "–" on every rendered TikTok post, so there is no number to sum. See the note under the assertions table.)

- Run: 2026-10-26 (Monday), headless unattended, Playwright MCP, app.lfmdev.in (dev)
- Skills used: `brand-content-grid-math` (Table View scrape), `brand-content-native-post-check` (date picker mechanics, via `devprod-helpers.js`), switch-account (helper `m.switchAccount`).

## Setup / precondition
- Weekday rotation: the Description table is authoritative. **Monday = Account HBO Max / Amazon Prime Video / Conde Nast**, brands HBO Max / Amazon Prime Video / Vogue-US. I used **Account HBO Max, Brand "HBO Max"**, the first Monday pair. The case's "Notes" line lists a different Monday rotation (HBO Max/Viacom) that conflicts with the Description table; I did not follow it (same call as QA-29235 today and the 2026-10-20 runs).
- Logged in as lfiqa@listenfirstmedia.com with the "With existing account" Cognito form. The session landed on `ACCOUNT: NETFLIX SUSTAINABILITY TEAM` (account_id=3454), so I switched via the account menu: Search Account "HBO Max", clicked the Results row. Breadcrumb then read `ACCOUNT: HBO MAX` (account_id=657).
- Brand: the page loaded Brand > Content with **HBO Max** (brand_id=155614), the exact spec name (Rule 1, no substitute).
- Open linked bugs screen (Rule 7): "None open", so the case ran.

## Steps executed
1. Hovered Brand in the top nav and clicked Content. Opened `#explore/brand/content?brand_id=155614` (screenshot 01).
2. Brand is HBO Max. I opened the visible Data Set dropdown and clicked **Impressions** (URL `table_data_set=impressions`).
3. Date picker: START DATE Jan 01, 2023 and END DATE Dec 31, 2023, then Ok. The field text read back "Jan 01, 2023 / Dec 31, 2023" and the URL became `from=2023-01-01&to=2023-12-31` (screenshot 02).
4. Explicit ghost clicks enabled TikTok and disabled the other channels. Ghost state verified: only `tiktok` was `.enabled` (the helper checks every ghost). I clicked Apply, which gave URL `channels=tiktok` and the header **Posts (1,993)** (screenshot 03).
5. Switched to Table View (`[title="Table View"]`). The table renders the top 200 posts plus the "Sum Average" aggregate row (screenshot 04). I scraped all rows via DOM and read the Impressions, Organic Impressions and Paid Impressions columns.
6. Same scrape: Organic Reach + Paid Reach compared against Reach.
7. Same scrape: Engagement Rate compared against Engagements / Impressions * 100.

## Evidence (TikTok only, Jan 01 – Dec 31 2023)
Table columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

- 200 rendered posts, dated Feb. 27, 2023 (rank 1) to Nov. 27, 2023 (rank 200); all inside 2023.
- Sum row (all 1,993 posts): Engagements 52,193,225 | Engagement Rate N/A | Impressions 851,035,155 | Organic Impressions – | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A.
- Independent sums over the 200 rendered rows: Engagements 43,624,090, Impressions 591,409,848 (less than the Sum row because the Sum row covers all 1,993 posts while Table View renders only 200).

| Rank | Date | Engagements | Eng. Rate | Impressions | Organic Imp | Paid Imp | Reach | Org Reach | Paid Reach |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Mon Feb. 27, 2023 | 2,194,255 | 14.27% | 15,380,460 | – | – | – | – | – |
| 2 | Tue Feb. 07, 2023 | 2,146,110 | 13.83% | 15,517,956 | – | – | – | – | – |
| 3 | Tue Jan. 10, 2023 | 2,028,423 | 10.96% | 18,510,104 | – | – | – | – | – |
| 4 | Mon Mar. 06, 2023 | 1,748,574 | 17.69% | 9,881,976 | – | – | – | – | – |
| 5 | Fri Jan. 27, 2023 | 1,555,705 | 13.31% | 11,687,842 | – | – | – | – | – |
| 6 | Sun Feb. 05, 2023 | 1,207,650 | 9.23% | 13,080,040 | – | – | – | – | – |

Check on the first row: 2,194,255 / 15,380,460 * 100 = 14.267%, which displays as 14.27%.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a | 5 | The Impressions metric displays a value | 200/200 rendered posts show a numeric Impressions value (0 dashes). The Sum row shows 851,035,155. | PASS |
| A5b | 5 | En-dash displays for both Organic and Paid Impressions | 200/200 posts show "–" for Organic Impressions and for Paid Impressions (0 numeric values). The Sum row shows "–" for both. | PASS |
| A6 | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach and Paid Reach are all "–" on 200/200 rendered posts (the Sum row shows N/A for all three). There is no numeric value to sum, so the identity holds trivially: no post has components without a total, and none has a total without components (0 failures; 200 counted as no-data and skipped per the grid-math skill). | PASS (vacuous, N/A for TikTok) |
| A7 | 7 | Engagement Rate = Engagements / Impressions * 100 | 200/200 posts within rounding of the 2-decimal display (max delta 0.0050 pp, which is display rounding only). 0 failures, 0 skipped. | PASS |

Note on A6: the case text asserts this identity, but TikTok returns no Reach metrics at all for HBO Max in 2023. This could be a spec gap (Reach is not a TikTok metric) or a data-collection gap. Same observation as the 2026-10-20 UCLA run. I recorded it as an observation, not a bug, because no TikTok Reach value is shown anywhere that could contradict the sum. If QA expects numeric Reach for TikTok on this data set, flag it for follow-up.

Screenshots: `.playwright-out/QA-29237/01-content.png`, `02-datepicker-set.png`, `03-tiktok-applied.png`, `04-tiktok-table.png`.

## Observations (not affecting verdict)
- Only the top 200 of 1,993 TikTok posts render in Table View (no pager found), so the per-post checks cover those 200. The Sum row covers all posts.
- The Channel column renders icon-only (empty text) in the scrape; the channel was confirmed through URL `channels=tiktok` and the ghost `.enabled` state.
- The `Posts (N)` text was not available immediately after Apply (grid still loading); it appeared once Table View rendered.
- The dev console logged many app errors during the run (105 at peak). None blocked rendering or changed the data. I did not investigate them.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). The pre-fetched grep of `bug-history.md` and `known-quirks.md` for QA-29237 found no matches, and I did not run the optional known-quirks follow-up grep because no assertion result looked like accepted-product behavior beyond the Reach note above. No known bug reproduced; no regression observed.

## Bugs filed
None (markdown-only; no Jira tickets created).
