# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Verdict: PASS**

- Run: 2026-10-27 (Tuesday), unattended headless (Playwright MCP), skill `brand-content-grid-math` (+ date-picker mechanics from `brand-content-native-post-check`)
- Env: app.lfmdev.in, login lfiqa@listenfirstmedia.com (Cognito "With existing account")
- Weekday row used (Tuesday, from the case Description table): Account **UCLA** (account_id=799) / Brand **University of California, Los Angeles** (brand_id=127756). The first Tuesday pair was used. The case's `## Notes` weekday line lists "Tue UCLA/Sony Pictures", which disagrees with the Description table (Tue = UCLA, Viacom, Wasserman; brands UCLA, MTV, Gatorade). The Description table was treated as authoritative.

## Known bugs checked
- Case file `## Open linked bugs`: "None open" (Rule 7 screen passed).
- PRE-FETCHED grep of bug-history.md / known-quirks.md for QA-29235: none.
- Nothing observed during the run matched a known bug.
- Facebook Data Collection Disruption 9/27 banner (global status widget) is irrelevant to the TikTok-only scope.

## Steps executed
1. Login via Cognito. Account menu (LFQA) -> Search Account "UCLA" -> clicked the `Results` entry **UCLA** (not "UCLA Law") -> account_id=799. Hovered top-nav **Brand** -> clicked **Content** (`#explore/brand/content`).
2. Brand selector: opened the dropdown, typed "University of California, Los Angeles", clicked the exact Results entry "University of California, Los Angeles" (brand_id=127756). Data Set dropdown (visible one) -> exact option **Video Views** (not the custom "UCLA Video Views"); URL `table_data_set=video_views`.
3. Date picker: START DATE = Jan 01, 2024 via year/month/day selection; END DATE read back as Dec 31, 2024; **Ok** -> URL `from=2024-01-01&to=2024-12-31`.
4. Channels: trusted-clicked the ghosts to disable Facebook, Twitter, Instagram and LinkedIn. DOM check: only `tiktok enabled` (threads/youtube/pinterest were already disabled). Clicked the channel-selector **Apply** -> URL `channels=tiktok`. Perspective left as loaded (`extended`, Authorized); the spec names none. Screenshot `.playwright-out/QA-29235/02-after-apply.png` shows `Posts (175)`, Data Set "Video Views", only the TikTok icon active.
5. Switched Layout to **Table View** (`div.view-mode[title="Table View"]`). Scraped all 175 post rows plus the Sum/Average row from the DOM. Evaluated Organic + Paid + Unclassified Views = Video Views per post and for the Sum row.
6. Evaluated Engagements / Video Views = Video Response Rate per post and for the aggregate rows.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5.1 | 5 | Per post: Organic + Paid + Unclassified Views = Video Views (all posts) | 175/175 posts match exactly, 0 failures, 0 skipped | PASS |
| A5.2 | 5 | Aggregate Sum row: Organic + Paid + Unclassified = Video Views | – (0) + 20,506,954 + 7,954,137 = 28,461,091 = Video Views 28,461,091 | PASS |
| A5.3 | 5 | Sum row equals the hand-summed post rows (sanity) | Column sums: Engagements 279,068; Video Views 28,461,091; Paid 20,506,954; Unclassified 7,954,137; Organic 0 — all equal the Sum row | PASS |
| A6.1 | 6 | Per post: Engagements / Video Views = Video Response Rate (±0.005 pp of the 2-decimal display) | 175/175 posts match, 0 failures, 0 skipped (154 distinct rate values) | PASS |
| A6.2 | 6 | Aggregate: Engagements / Video Views = Video Response Rate | Sum row rate shows "N/A" (by design). Computed 279,068 / 28,461,091 = 0.9805%. Average row 1,595 / 162,635 = 0.9807% vs displayed **0.98%** | PASS |

## Evidence
- Scope confirmation: all 175 posts are brand "University of California, Los Angeles", all dated 2024 (175 of 175).
- Sample rows (rank | date | Engagements | Video Response Rate | Video Views | Organic | Paid | Unclassified):
  - 1 | Thu Feb. 15, 2024 12:23 PM PST | 30,262 | 7.00% | 432,088 | – | 172,730 | 259,358 (172,730 + 259,358 = 432,088; 30,262 / 432,088 = 7.00%)
  - 2 | Tue Apr. 09, 2024 05:22 PM PDT | 21,154 | 0.65% | 3,243,987 | – | 2,969,994 | 273,993 (sum = 3,243,987; 21,154 / 3,243,987 = 0.65%)
  - 3 | Thu Mar. 14, 2024 07:25 PM PDT | 18,259 | 5.50% | 332,246 | – | 56,808 | 275,438 (sum = 332,246; 18,259 / 332,246 = 5.50%)
- Aggregate row: Engagements 279,068 | Video Views 28,461,091 | Organic – | Paid 20,506,954 | Unclassified 7,954,137 | Average: Engagements 1,595, Video Views 162,635, Paid 117,183, Unclassified 45,452.
- Screenshots: `.playwright-out/QA-29235/01-content-landing.png`, `02-after-apply.png`, `03-table-view.png`.

## Observations (not failures)
- **Organic Views is "–" on all 175 TikTok posts and on the Sum row.** It was treated as 0 per the skill rule (component structurally absent for the channel). The identity then reduces to Paid + Unclassified = Video Views, which holds on every post. This looks like TikTok behavior (no organic/paid split from the platform) and is not filed as a bug.
- The Sum row's Video Response Rate is "N/A" by design. The Average row carries 0.98%, which matches the computed rate.
- Brand>Content console shows many errors (100+) throughout the run on dev (pre-existing noise). None affected the rendered data.

## Bugs filed
None.
