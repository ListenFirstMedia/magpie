# QA-29236 — Brand Content > Video Views Data Set > Past date range data test - LinkedIn

**Run:** 2026-10-23, headless (`claude -p`), Playwright MCP · **Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · **Data set:** Video Views · **Range:** Oct. 01, 2022 – Sep. 30, 2023 · **Channel:** LinkedIn only · **Perspective:** Authorized (app default, `perspective=extended`; the spec does not name one)

**Verdict: PASS (2/2) with a spec-wording note.** 72 LinkedIn video posts. Engagements / Video Views = Video Response Rate holds on 72/72. For Organic + Paid = Video Views, LinkedIn shows Organic and Paid Views as "–" on every post and carries the whole value in Unclassified Views. With "–" read as 0 (skill rule 6) the identity holds only when Unclassified Views is included, and it does on 72/72. Read strictly, Organic + Paid = 0 on every post, which is not the Video Views value.

## Preconditions / screening
- "Open linked bugs" in the case file: **None open** (Rule 7 screen passed).
- Logged in programmatically (Cognito "With existing account" form, `config/.env`). Header showed `Account: UCLA` with no switch needed.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand in the top nav, click Content | Brand menu hovered, Content link clicked, landed on `#explore/brand/content` (default brand_id=127756) |
| 2 | Add brand UCLA; select Video Views data set | Typeahead "UCLA" lists only UCLA-prefixed roll-ups/units (UCLA - Ambassadors Roll-Up, UCLA Alumni, UCLA Anderson, …) and **no brand named exactly "UCLA"**. Selected "University of California, Los Angeles" from Recent Searches (header shows it), as in earlier UCLA cases. Data Set dropdown set to **Video Views** (`table_data_set=video_views`) |
| 3 | Date range Oct. 01, 2022 – Sep. 30, 2023 | START/END picker read `Oct 01, 2022` / `Sep 30, 2023`; Ok gave `from=2022-10-01&to=2023-09-30` |
| 4 | Enable LinkedIn only | Twitter, Instagram, Facebook and TikTok ghosts disabled; `.channel-ghost.linkedin.enabled` only; Apply gave `channels=linkedin`; **Posts (72)** |
| 5 | Per grid post, add Organic Views and Paid Views | Table View scraped for all 72 rows (plus the Sum/Average row) and the identity evaluated in page JS |
| 6 | Note Engagements and Video Views | Recorded per row and in the Sum row |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Organic Views + Paid Views = Video Views | **Organic Views and Paid Views are "–" on 72/72 posts** (LinkedIn has no organic/paid split). The full value is in **Unclassified Views**, a column in this data set that the older spec does not name. Organic + Paid + Unclassified = Video Views on **72/72** (rank 1: 56,255; rank 2: 41,596; rank 3: 175,663). Sum row: Unclassified 891,633 = Video Views 891,633, and the 72 row values add up to 891,633. Read literally, Organic + Paid = 0 ≠ Video Views on every post; that is how LinkedIn reports, not an arithmetic error. | PASS (spec-wording note) |
| A6 | 6 | Engagements / Video Views = Video Response Rate | **72/72** within ±0.01 pp of the 2-decimal display (rank 1: 2,865 / 56,255 = 5.09% ✓; rank 2: 2,119 / 41,596 = 5.09% ✓; rank 3: 1,567 / 175,663 = 0.89% ✓). 0 skipped, 0 failures. The Sum row shows Video Response Rate "N/A"; the aggregate math (21,467 / 891,633 = 2.41%) is consistent with the 72 row sums (Engagements 21,467, Video Views 891,633). | PASS |

## Evidence
- Table View headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions. 73 `tbody` rows = 72 posts + Sum/Average.
- All 72 rows are LinkedIn, from Oct 04, 2022 to Sep 28, 2023 (inside the requested range). Every row is `Type = Video`, brand = University of California, Los Angeles.
- Aggregate Sum row: Engagements 21,467 · Video Views 891,633 · Organic "–" · Paid "–" · Unclassified 891,633 · Viewers 771,862 · Watch Time 261,760.76 · Video Views (with Cross-Posts) 891,633.
- Screenshots (`.playwright-out/QA-29236/`): `02-brand-search-state.png`, `03-brand-typeahead-ucla.png`, `04-linkedin-vv-table-2026-10-23.png` (an earlier `01-linkedin-vv-2022-2023-table.png` from a prior attempt is also there).
- Console showed many errors (Facebook disruption, tile requests); none touched the LinkedIn table or the assertions.
- A stray `x.com` tab (chrome-error, offline) opened during the brand pick; it had no effect on the case.

## Known bugs checked
- Case file: no linked bugs. `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-29236 entries (pre-fetched shell-side).
- Related surface: the active "Facebook Data Collection Disruption 9/27" banner is Facebook-only and not in play (LinkedIn only). No known bug interfered with the steps or assertions.
- The "–" on LinkedIn Organic/Paid Views and the full value in Unclassified Views matches the earlier QA-29127 PASS and the skill's finding for LinkedIn (structurally absent split). It is not filed as a defect.

## Bugs filed
None. One spec-maintenance suggestion (not a product bug): the case's A5 should read "Organic + Paid + Unclassified Views = Video Views" for LinkedIn, since the channel reports no organic/paid split.
