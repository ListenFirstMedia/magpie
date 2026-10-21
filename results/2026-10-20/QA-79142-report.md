# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (3/3 assertions)

- Run: 2026-10-20 (Tuesday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: Tuesday row of the Description table -> Account **UCLA**, Brand **University of California, Los Angeles** (account_id=799, brand_id=127756). The Notes line in the case file lists a different mapping (Tue "UCLA/Sony Pictures"); the Description table is the authority, and the Tuesday account/brand there is UCLA.
- Date range: Oct 12 – Oct 18, 2026 (app default), Mode: Lifetime. View toggle left at default "Authorized data".
- Skill used: `brand-content-grid-math` (Table View scrape + Sum/Average toggle). No new skill/REGISTRY edits (deferred to harvest.sh).

## Steps executed
1. Login via Cognito "With existing account" form -> `#home`. Header already showed `ACCOUNT: UCLA` (precondition for Tuesday satisfied; no account switch needed).
2. Hovered **Brand** in top nav, clicked **Content** -> `#explore/brand/content?brand_id=127756&account_id=799…`.
3. Opened brand chevron, typed "University of California, Los Angeles" slowly, typeahead **Results** listed `University of California, Los Angeles` and `University of California, Los Angeles Police`; clicked the exact match (Rule 1). Brand heading confirmed.
4. Data Set dropdown (visible one) -> explicitly selected **Public**; URL `table_data_set=public`.
5. Filter -> Select -> **Content Type** -> **Video** -> **Apply Filter** (URL `content_types … ["Video"]`). 42 posts across all enabled channels.
6. **Step 4 of case:** disabled Twitter/Instagram/TikTok/LinkedIn/Threads, left Facebook enabled, verified `.channel-ghost` states, clicked Apply (URL `channels=facebook`), switched to Table View. Posts (7). Read Sum row and Average row (Sum<->Average toggle).
7. **Step 6:** enabled Twitter, disabled Facebook, verified, Apply (`channels=twitter`). Posts (7). Read Sum + Average.
8. **Step 8:** enabled TikTok, disabled Twitter, verified, Apply (`channels=tiktok`). Posts (7). Read Sum + Average.

## Assertions
Formula 1 (Engagements / Video Views) was usable on every channel, so formula 2 was not needed as a fallback.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Sum Eng **2,010** / Sum VV **22,460** = 8.949% -> **8.95%**; Average row VRR = **8.95%** | PASS |
| A7 | 7 (Twitter only) | same | Sum Eng **213** / Sum VV **2,663** = 7.999% -> **8.00%**; Average row VRR = **8.00%** | PASS |
| A9 | 9 (TikTok only) | same | Sum Eng **755** / Sum VV **11,513** = 6.558% -> **6.56%**; Average row VRR = **6.56%** | PASS |

## Evidence
Aggregate rows as displayed (Table View, 7 Video posts per channel):

| Channel | Sum Engagements | Sum Video Views | Avg Engagements | Avg Video Views | Avg Video Response Rate | Eng/VV |
|---------|-----------------|-----------------|-----------------|-----------------|-------------------------|--------|
| Facebook | 2,010 | 22,460 | 287 | 3,208 | 8.95% | 8.95% |
| Twitter | 213 | 2,663 | 30 | 380 | 8.00% | 8.00% |
| TikTok | 755 | 11,513 | 108 | 1,644 | 6.56% | 6.56% |

Cross-check: summing the 7 per-post rows reproduces the Sum row exactly on each channel (Facebook 704+656+263+236+79+42+30 = 2,010 and VV 22,460; Twitter 213 / 2,663; TikTok 755 / 11,513). The Sum row shows "N/A" for Video Response Rate and the Average row carries the rate, which equals the aggregate Engagements/Video Views ratio (and Avg Eng / Avg VV).

Screenshots (`.playwright-out/QA-79142/`): `01-home.png`, `02-content-page.png`, `03-brand-typeahead.png`, `04-filter-video-selected.png`, `05-fb-only-before-apply.png`, `06-fb-table.png`, `07-twitter-table.png`, `08-tiktok-table.png`.

Notes / observations:
- Spec ambiguity: "select the public dataset" was implemented as Data Set dropdown = Public (already default). The separate View toggle (Public data / Authorized data) was left at its default Authorized data, consistent with the `brand-content-grid-math` skill and prior runs.
- Facebook per-post Response Rate shows "–" on several rows and the app shows a "Facebook Posts Insights Disruption" banner; this does not affect Engagements / Video Views / Video Response Rate on the 7 video posts evaluated.
- Console shows many network/API errors on dev (pre-existing noise); none affected the rendered tables.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md / known-quirks.md: no entries for QA-79142 (pre-fetched). No related bug reproduced; no assertion interference.

## Bugs filed
None.
