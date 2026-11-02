# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Verdict: PASS**

- Run: 2026-10-28 (Wednesday), unattended headless (Playwright MCP), skill `brand-content-grid-math` (helpers: `skills/_shared/playwright-helpers/devprod-helpers.js`)
- Env: app.lfmdev.in (dev tab), login lfiqa@listenfirstmedia.com (Cognito "With existing account")
- Weekday row used (Wednesday, from the case Description table): Account **Apple Services** (account_id=409) / Brand **Apple Music** (brand_id=31783). The first Wednesday pair was used. The case's `## Notes` weekday line says "Wed Apple Services/Wasserman", which disagrees with the Description table (Wed = Apple Services, NBCU EnterPrises; brands Apple Music, CNBC, NBC News). The Description table was treated as authoritative. Apple Services matches in both; the brand "Apple Music" comes from the table.
- Not run: the other Wednesday pair (NBCU EnterPrises / CNBC, NBC News). The case's weekday rotation takes one pair per run, as the 2026-10-26 and 2026-10-27 runs did.

## Known bugs checked
- Case file `## Open linked bugs`: "None open" (Rule 7 screen passed).
- PRE-FETCHED grep of bug-history.md / known-quirks.md for QA-29235: none.
- Nothing observed during the run matched a known bug.

## Steps executed
1. Logged in via Cognito. Account menu -> Search Account "Apple Services" -> clicked the `Results` entry **Apple Services** -> header read back `ACCOUNT: APPLE SERVICES`, account_id=409. Hovered top-nav **Brand** -> clicked **Content** (`#explore/brand/content`).
2. Brand selector already showed the exact name **Apple Music** (brand_id=31783), so no change was needed (Rule 1 satisfied). Data Set dropdown (visible one) -> exact option **Video Views**; URL `table_data_set=video_views`.
3. Date picker: START DATE = Jan 01, 2024 and END DATE = Dec 31, 2024 via year/month/day selection. Read back "START DATE Jan 01, 2024 / END DATE Dec 31, 2024"; **Ok** -> URL `from=2024-01-01&to=2024-12-31`.
4. Channels: trusted-clicked the ghosts to disable Facebook, Twitter, Instagram and LinkedIn (TikTok enabled; Threads/YouTube/Pinterest were already disabled). DOM check: only `tiktok enabled`. Clicked **Apply** -> URL `channels=tiktok`, `Posts (159)`. Perspective left as loaded (`extended`, Authorized); the spec names none.
5. Switched Layout to **Table View** (`[title="Table View"]`). Scraped all 159 post rows plus the Sum row from the DOM. Evaluated Organic + Paid + Unclassified Views = Video Views per post and on the aggregate row.
6. Evaluated Engagements / Video Views = Video Response Rate per post and on the aggregate rows.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5.1 | 5 | Per post: Organic + Paid + Unclassified Views = Video Views (all posts) | 159/159 posts match exactly, 0 failures, 0 skipped | PASS |
| A5.2 | 5 | Aggregate Sum row: Organic + Paid + Unclassified = Video Views | – (0) + 64,823,386 + 180,451,923 = 245,275,309 = Video Views 245,275,309 | PASS |
| A5.3 | 5 | Sum row equals the hand-summed post rows (sanity) | Column sums of the 159 posts: Engagements 6,148,064; Video Views 245,275,309; Paid 64,823,386; Unclassified 180,451,923; Organic 0. All equal the Sum row | PASS |
| A6.1 | 6 | Per post: Engagements / Video Views = Video Response Rate (within 0.005 pp of the 2-decimal display) | 159/159 posts match, 0 failures, 0 skipped | PASS |
| A6.2 | 6 | Aggregate: Engagements / Video Views = Video Response Rate | Sum row rate shows "N/A" (by design). Computed 6,148,064 / 245,275,309 = 2.5066%. Average row (after the Sum/Average toggle): 38,667 / 1,542,612 = 2.5066% vs displayed **2.51%** | PASS |

## Evidence
- Scope confirmation: all 159 posts are brand "Apple Music" and all are dated 2024 (159 of 159).
- Sample rows (rank | date | Engagements | Video Response Rate | Video Views | Organic | Paid | Unclassified):
  - 1 | Thu Nov. 21, 2024 08:18 AM PST | 689,633 | 5.29% | 13,046,064 | – | 10,796,154 | 2,249,910 (10,796,154 + 2,249,910 = 13,046,064; 689,633 / 13,046,064 = 5.29%)
  - 2 | Tue Oct. 29, 2024 01:02 PM PDT | 644,097 | 11.04% | 5,834,869 | – | – | 5,834,869 (0 + 5,834,869 = 5,834,869; 644,097 / 5,834,869 = 11.04%)
  - 3 | Wed Jan. 31, 2024 12:02 PM PST | 332,573 | 11.48% | 2,895,845 | – | – | 2,895,845 (sum = 2,895,845; 332,573 / 2,895,845 = 11.48%)
- Aggregate Sum row: Engagements 6,148,064 | Video Views 245,275,309 | Organic – | Paid 64,823,386 | Unclassified 180,451,923 | Video Views (with Cross-Posts) 245,275,309.
- Aggregate Average row: Engagements 38,667 | Video Views 1,542,612 | Organic – | Paid 407,694 | Unclassified 1,134,918 | Video Response Rate 2.51%.
- Screenshots: `.playwright-out/QA-29235/01-brand-ds.png`, `02-after-apply.png`, `03-table-view.png`, `04-average-row.png`.

## Observations (not failures)
- **Organic Views is "–" on all 159 TikTok posts and on the Sum row.** It was treated as 0 per the skill rule (component structurally absent for the channel). The identity then reduces to Paid + Unclassified = Video Views, which holds on every post. This matches the 2026-10-27 UCLA run and looks like TikTok behavior, so it is not filed as a bug.
- The Sum row's Video Response Rate is "N/A" by design. The Average row carries 2.51%, which matches the computed rate.
- The Channel column scrapes as empty text (it renders an icon). TikTok-only scope was confirmed instead by the `.channel-ghost` DOM state and `channels=tiktok` in the URL.
- A prod tab was also opened and logged in by the helper bootstrap. It was not used for any step or assertion.

## Bugs filed
None.
