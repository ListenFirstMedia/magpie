# QA-29234 — Brand Content > Video Views Data Set > Past date range data test - (Twitter/Instagram)

**Verdict: PASS**

- Run: 2026-10-27 (Tuesday), unattended headless (Playwright MCP). Mechanics: `brand-content-grid-math` (Table View DOM scrape) with the shared helpers in `skills/_shared/playwright-helpers/devprod-helpers.js`.
- Env: app.lfmdev.in, login lfiqa@listenfirstmedia.com (Cognito "With existing account").
- Weekday row used (Tuesday, from the case Description table): Account **UCLA** (account_id=799) / Brand **University of California, Los Angeles** (brand_id=127756). The case's `## Notes` weekday line says "Tue UCLA/Sony Pictures", which disagrees with the Description table (Tue = UCLA, Viacom, Wasserman; brands UCLA, MTV, Gatorade). The Description table was treated as authoritative, the same call made in QA-29235 today.

## Known bugs checked
- Case file `## Open linked bugs`: "None open" (Rule 7 screen passed).
- PRE-FETCHED grep of bug-history.md / known-quirks.md for QA-29234: none.
- Nothing observed during the run matched a known bug. Dev console shows heavy pre-existing error noise on Brand > Content, with no effect on the rendered data.

## Steps executed
1. Logged in via Cognito. Account menu -> Search Account "UCLA" -> clicked the exact `Results` entry **UCLA** -> account_id=799. Hovered top-nav **Brand** -> clicked **Content** (`#explore/brand/content`).
2. Brand: the selector already showed the exact name "University of California, Los Angeles" (brand_id=127756), so no typeahead substitution was needed. Data Set dropdown (visible one) -> exact option **Video Views**; URL `table_data_set=video_views`.
3. Date picker: START DATE = Jan 01, 2023, END DATE = Jan 10, 2023 (read back from `.date-range-fields`), then **Ok**. URL `from=2023-01-01&to=2023-01-10`.
4. Channels: trusted-clicked the channel ghosts so that only Twitter was enabled (DOM check `enabled: ["twitter"]`), then **Apply**. URL `channels=twitter`, `Posts (6)`.
5. Switched to **Table View** and scraped all 6 post rows plus the Sum row. Checked Organic Views + Paid Views (+ Unclassified Views) = Video Views per post and for the Sum row.
6. Checked Engagements / Video Views = Video Response Rate per post.
7. Enabled Instagram and disabled Twitter (enable-first order), verified `enabled: ["instagram"]`, then **Apply**. URL `channels=instagram`, `Posts (2)`. All rows belong to brand "University of California, Los Angeles".
8-9. Same Table View scrape and identities for Instagram (2 posts + Sum row).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Twitter) | Per post and in aggregate: Organic Views + Paid Views = Video Views | 6/6 posts match, and the Sum row matches (9,174 + – (0) = 9,174; Unclassified 0). 0 failures, 0 skipped. | PASS |
| A6 | 6 (Twitter) | Engagements / Video Views = Video Response Rate | 6/6 posts match within the 2-decimal display (5.69, 1.47, 1.89, 1.29, 1.54, 0.72 %). Sum row rate shows "N/A" by design; computed 303 / 9,174 = 3.30%. | PASS |
| A8 | 8 (Instagram) | Per post and in aggregate: Organic Views + Paid Views = Video Views | 2/2 posts match, and the Sum row matches (149,500 + – (0) = 149,500; Unclassified 0). | PASS |
| A9 | 9 (Instagram) | Engagements / Video Views = Video Response Rate | 2/2 posts match (31.03%, 5.10%). Sum row rate "N/A" by design; computed 17,169 / 149,500 = 11.48%. | PASS |

## Evidence
Twitter (Jan 01-10, 2023; Rank | Date | Engagements | Organic | Paid | Unclassified | Video Views | Rate | computed rate):
- 1 | Mon Jan. 09, 2023 12:38 PM PST | 234 | 4,115 | – | 0 | 4,115 | 5.69% | 5.6865%
- 2 | Mon Jan. 02, 2023 04:00 PM PST | 23 | 1,569 | – | 0 | 1,569 | 1.47% | 1.4659%
- 3 | Tue Jan. 03, 2023 09:00 AM PST | 16 | 848 | – | 0 | 848 | 1.89% | 1.8868%
- 4 | Fri Jan. 06, 2023 04:00 PM PST | 14 | 1,082 | – | 0 | 1,082 | 1.29% | 1.2939%
- 5 | Wed Jan. 04, 2023 09:00 AM PST | 9 | 583 | – | 0 | 583 | 1.54% | 1.5437%
- 6 | Mon Jan. 02, 2023 09:00 AM PST | 7 | 977 | – | 0 | 977 | 0.72% | 0.7165%
- Sum row: Engagements 303 | Video Views 9,174 | Organic 9,174 | Paid – | Unclassified 0 | Rate N/A.

Instagram (same range):
- 1 | Mon Jan. 09, 2023 12:39 PM PST | 11,427 | 36,826 | – | 0 | 36,826 | 31.03% | 31.0297%
- 2 | Fri Jan. 06, 2023 04:18 PM PST | 5,742 | 112,674 | – | 0 | 112,674 | 5.10% | 5.0961%
- Sum row: Engagements 17,169 | Video Views 149,500 | Organic 149,500 | Paid – | Unclassified 0 | Rate N/A.

Screenshots: `.playwright-out/QA-29234/01-ds-dates.png`, `02-twitter-table.png`, `03-instagram-table.png`.

## Observations (not failures)
- **Paid Views is "–" on every row for both channels.** It is treated as 0 per the skill rule for a component that is structurally absent. Organic Views carries the whole Video Views value. This matches the Paid-"–" behavior seen on other channels and is not filed as a bug.
- The Sum row's Video Response Rate is "N/A" by design; the rate was verified from the Sum row's Engagements and Video Views.
- The date range is small (6 Twitter posts, 2 Instagram posts), so every post was checked individually.

## Bugs filed
None.
