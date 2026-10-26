# QA-20334 — Brand Content > Pinterest Only: Basic Data Set > Past date range data test

**Verdict: PASS**

- Run: 2026-10-23, headless Playwright MCP, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- Case: `cases/QA-20334.md` (Test Set QA-27628 "Daily Data Testing -1")
- Skill used: `brand-content-grid-math` (+ `switch-account`, date picker from `brand-content-native-post-check`)

## Preconditions
- Account **Sephora** (account_id=655) selected via LFQA menu > Search Account > Results row (login landed on Hulu, 336, first).
- The spec reads "Sephora | Ralph Lauren"; Sephora was used, as it is the first named option and Sephora's Pinterest data is established in this suite.

## Steps executed
1. Hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content?brand_id=7159`).
2. Opened the brand picker, typed `Sephora` into "Search for a Brand", and clicked the exact-match `Sephora` result (Rule 1; look-alikes such as "Sephora Lincoln" were ignored). Brand id 7159. Opened the date picker, set START DATE = Jun 11, 2024 and END DATE = Jun 10, 2025 explicitly, then clicked Ok. URL `from=2024-06-11&to=2025-06-10`.
3. Selected data set **Pinterest Only: Basic** from the visible Data Set dropdown. The channel bar then showed only Pinterest enabled (`.channel-ghost.pinterest.enabled`, the other seven disabled). URL `channels=pinterest&table_data_set=pinterest_only:_basic`. `Posts (62,031)` rendered (about 100 s on slow dev).
4. Switched to **Table View** (`[title="Table View"]`). The table has columns Rank … Engagements, Pin Saves, Comments, Actions and 201 `tbody` rows (200 posts plus the Sum/Average row). Scraped every row in page JS and evaluated Engagements = Pin Saves + Comments per post.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Per post: Engagements = Pin Saves + Comments | 200/200 rendered posts satisfy it; 0 failures, 0 posts with an Engagements total of "–". Pin Saves is "–" on 200/200 posts (structurally absent for Pinterest, counted as 0 per skill rule); Comments is numeric on 200/200. So Engagements equals Comments on every row. | PASS |
| A2 | 4 | Aggregate: Sum Engagements = Sum Pin Saves + Sum Comments | Sum row: Engagements **670**, Pin Saves **–**, Comments **670**. 670 = 0 + 670. Average row: 0 / – / 0. | PASS |

## Evidence
- Sum of the 200 rendered rows: Engagements 624, Pin Saves 0, Comments 624. This is internally consistent (624 = 0 + 624). The aggregate Sum row (670) is higher than the 200-row sum, so it covers posts beyond the first rendered page; it is consistent with the identity too.
- Sample rows: #1 Mon Dec. 30, 2024, Image, Engagements 27 / Pin Saves – / Comments 27; #2 Thu Mar. 06, 2025, Video, 20 / – / 20.
- Screenshots (`.playwright-out/QA-20334/`): `01-post-login.png`, `02-brand-content.png`, `03-brand-picker.png`, `04-date-picker.png`, `05-pinterest-loaded.png`, `06-table-view.png`.

## Notes
- The page's View toggle stayed at its default (Authorized data); the spec does not name a perspective.
- Dev was slow: login took about 70 s to settle and the post grid about 100 s. There was no render hang and no Reload was needed.
- The "Facebook Data Collection Disruption 9/27" banner was present, but Facebook is not part of this case.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). Pre-fetched bug-history and known-quirks greps for QA-20334: no matches. No related bug was observed reproducing.

## Bugs filed
- None.
