# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: PASS** (A6 is vacuous: Reach, Organic Reach and Paid Reach are "–" on every TikTok post, so there is no number to sum. See the note under the assertions table.)

- Run: 2026-10-20 (Tuesday), headless unattended, Playwright MCP, app.lfmdev.in (dev)
- Skills used: `brand-content-grid-math` (Table View scrape), `brand-content-native-post-check` (date picker mechanics). No `switch-account` was needed.

## Setup / precondition
- Weekday rotation: the Description table is authoritative. **Tuesday = Account UCLA / Viacom / Wasserman**, brands *University of California, Los Angeles* / MTV / Gatorade. I used **Account UCLA, Brand "University of California, Los Angeles"**, the first Tuesday pair. The case's "Notes" line lists a different rotation (Tue UCLA/Sony Pictures) that conflicts with the Description table; I did not follow it. This is the same call as in QA-29234/29235.
- Logged in as lfiqa@listenfirstmedia.com with the "With existing account" Cognito form. The session landed directly on `ACCOUNT: UCLA` (account_id=799), confirmed in the breadcrumb, so no account switch was needed.
- Brand: University of California, Los Angeles (brand_id=127756), the exact spec name (Rule 1, no substitute).
- Open linked bugs screen (Rule 7): "None open", so the case ran.

## Steps executed
1. Hovered Brand in the top nav and clicked Content. This opened `#explore/brand/content?brand_id=127756`.
2. Brand is University of California, Los Angeles. I opened the visible Data Set dropdown and clicked **Impressions** (URL `table_data_set=impressions`).
3. Date picker: START DATE Jan 01, 2023 and END DATE Dec 31, 2023, then Ok. The field text read back "Jan 01, 2023 / Dec 31, 2023" and the URL became `from=2023-01-01&to=2023-12-31` (screenshot 02).
4. I clicked the Twitter, Instagram, Facebook, LinkedIn and Threads ghosts to disable them and left TikTok enabled. Ghost states before the clicks were all six enabled channels. After the clicks only `tiktok enabled` remained (YouTube and Pinterest stayed disabled). I clicked Apply, which gave URL `channels=tiktok` and **Posts (134)**.
5. I switched to Table View (`[title="Table View"]`). The table renders 134 post rows plus the "Sum Average" aggregate row. I scraped all rows via DOM and read the Impressions column.
6. Same scrape: Organic Reach + Paid Reach compared against Reach.
7. Same scrape: Engagement Rate compared against Engagements / Impressions * 100.

## Evidence (TikTok only, Jan 01 – Dec 31 2023, 134 posts, all dated 2023, all channel = TikTok)
Table columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Sum row: Engagements 729,214 | Engagement Rate N/A | Impressions 30,870,131 | Organic Impressions – | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A.
Independent per-post sums from the scrape: Engagements 729,214 and Impressions 30,870,131. Both match the Sum row exactly.

| Rank | Date | Engagements | Eng. Rate | Impressions | Organic Imp | Paid Imp | Reach | Org Reach | Paid Reach |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Fri Nov. 24, 2023 | 139,425 | 5.18% | 2,693,838 | – | – | – | – | – |
| 2 | Tue Jan. 31, 2023 | 115,228 | 2.91% | 3,957,226 | – | – | – | – | – |
| 3 | Mon Mar. 20, 2023 | 83,112 | 3.49% | 2,381,711 | – | – | – | – | – |
| 4 | Sun Sep. 17, 2023 | 35,632 | 0.40% | 8,925,528 | – | – | – | – | – |
| 5 | Fri Apr. 07, 2023 | 35,247 | 1.72% | 2,055,181 | – | – | – | – | – |
| 6 | Thu Jun. 01, 2023 | 29,592 | 8.86% | 333,910 | – | – | – | – | – |

Check on the first row: 139,425 / 2,693,838 * 100 = 5.176%, which displays as 5.18%.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a | 5 | The Impressions metric displays a value | 134/134 posts show a numeric Impressions value (0 dashes). The Sum row shows 30,870,131. | PASS |
| A5b | 5 | En-dash displays for both Organic and Paid Impressions | 134/134 posts show "–" for Organic Impressions and for Paid Impressions (0 numeric values). The Sum row shows "–" for both. | PASS |
| A6 | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach and Paid Reach are all "–" on 134/134 posts (the Sum row shows N/A for all three). There is no numeric value to sum, so the identity holds trivially (no post has components without a total, and no post has a total without components). Per the grid-math skill, a "–" total counts as no data and the post is skipped (134 skipped, 0 failures). | PASS (vacuous, N/A for TikTok) |
| A7 | 7 | Engagement Rate = Engagements / Impressions * 100 | 134/134 posts within rounding of the 2-decimal display (max delta 0.0050 pp, which is display rounding only). 0 failures, 0 skipped. | PASS |

Note on A6: the case text asserts this identity, but the TikTok data returns no Reach metrics at all for UCLA in 2023. This could be a spec gap (Reach is not a TikTok metric) or a data-collection gap. I filed it as an observation, not a bug, because no TikTok Reach value is shown anywhere that could contradict the sum. If QA expects numeric Reach for TikTok on this data set, flag it for follow-up.

Screenshots: `.playwright-out/QA-29237/01-content.png`, `02a-picker-open.png`, `02-datepicker-set.png`, `03-tiktok-applied.png`, `04-tiktok-table.png`.

## Observations (not affecting verdict)
- The dev console logged many errors during the run (88 at peak). None blocked rendering or changed the data. I did not investigate them.
- The Facebook Posts Insights Disruption banner on the status iframe is unrelated to TikTok.

## Known bugs checked
- Linked bugs: the case file lists "None open" as of 2026-10-20, and the pre-fetched grep of `bug-history.md` for QA-29237 found no entries.
- `known-quirks.md` has no entry for TikTok Impressions or Reach on this surface (one narrow grep for "tiktok"; hits are unrelated Facebook, Max, Pinterest and Insights quirks).
- During the run nothing reproduced that matches a known bug.

## Bugs filed
None (markdown-only; no Jira tickets created).
