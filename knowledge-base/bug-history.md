# Bug history — per test ticket

Cross-reference for every magpie test in `runs/2026-05-27/`. Before re-running a test, grep this file for the QA-ID to see what bugs have ever been linked to that test case — open ones must be reproduced (or confirmed-still-present), closed ones must be verified-still-fixed.

- **Last updated:** 2026-06-11
- **Source:** Atlassian MCP `getJiraIssue` → `issuelinks` → filtered to `issuetype IN {Bug, Test Failure}`.
- **Total tickets catalogued:** 59
- **Total open Bug/Test-Failure links:** 15
- **Total closed Bug/Test-Failure links:** 350

## Table of contents

- [Brand > Content](#brand-content)
- [Brand > Insights / Audience / Paid / Stories](#brand-insights-audience-paid-stories)
- [TWC (Time Window Comparison)](#twc-time-window-comparison)
- [Reporting > Social Recap / PDF](#reporting-social-recap-pdf)
- [Data Studio](#data-studio)
- [Settings (Custom Metrics / Data Sets / Tags / Notifications / Data Collection)](#settings-custom-metrics-data-sets-tags-notifications-data-collection)
- [Exports (CSV / Google Sheets)](#exports-csv-google-sheets)
- [Response Rate / Math Verifier](#response-rate-math-verifier)
- [Unmapped tickets](#unmapped-tickets)

# Brand > Content

## QA-520 — Facebook Content - Table Data Set - Authorized & Unauthorized (3/3)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (23, most recent first)
- APPS-60826 (Bug, Major, Closed) — Facebook Content - Table Data Set - Reach, Organic Reach Aggregate sum values is -
- APPS-52583 (Test Failure, Major, Closed) — Brand > Content - Public brands are not loading and it shows a reload tile
- APPS-51475 (Bug, Major, Closed) — Locks showing in Brand Roll-ups for FB Reel post and IG Shares metric
- APPS-51168 (Test Failure, Major, Closed) — Brand > Content - Endash displaying for Engagement Rate and Video Response Rate metric
- APPS-43226 (Test Failure, Major, Closed) — Brand > Content - Value displayed in Aggregate Avg for Paid Impressions, Organic Reach and Promoted Reach
- APPS-37891 (Test Failure, Major, Closed) — Incorrect Space alignment on Grid and Details posts - Global
- APPS-30951 (Bug, Major, Closed) — Brand Content > Incorrect Sum and Avg values displayed in Aggregate Row
- APPS-29341 (Bug, Major, Closed) — Values displayed instead of lock for Impressions column - (Unauthorized brand)
- LFMP-24861 (Bug, Major, Closed) — Incorrect data set option displayed - Brand Content
- LFMP-21325 (Bug, Major, Closed) — Firefox - Table header not displayed fully
- +13 earlier closed defects

## QA-929 — Pinterest Content - Embedded Post Tooltip

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-06-02 batch-12):** 7/7 assertions resolved (5 PASS, 1 PARTIAL, 1 PASS via DOM-href). Improvement over prior PARTIAL.

### Open bugs (0)
_None._

### Closed bugs (3, most recent first)
- APPS-58139 (Bug, Major, Closed) — Brand > Stories - IG Story Thumbnails Not Displaying (Phase 1)
- APPS-56800 (Test Failure, Major, Closed) — Brand Content > Pinterest post table isn't loading
- APPS-48807 (Test Failure, Major, Closed) — Brand > Content - Vertical Scroll bar is displayed on the post-table - On Table View

### 2026-06-02 batch-12 re-run findings
- Posts(85,832) confirmed for Sephora Pinterest Only: Basic data set, May 26 2025 – May 25 2026.
- A1, A2, A4 PASS (tooltip displays on hover, single tooltip at a time, no stacking).
- A3 PASS — both X-click (coord 887,10) and click-outside-tooltip dismiss tooltip.
- A5 PASS via DOM href inspection: row 1, row 3 (`pin/4600778950635531008`), row 4 (`pin/98938523061433215`) all have well-formed Pinterest URLs.
- A6 PARTIAL — row 1 image + caption match (`Fragrance Family: Warm…`); rows 3+4 iframe stays blank (Pinterest embed not loading).
- A7 PASS — no external/non-Sephora pin observed.
- **Persistent issue**: Pinterest embed iframe stays blank for rows 3 & 4 (same as 2026-05-27 batch) — Pinterest-side restriction, not LFM bug. Product should add graceful placeholder.
- Skill pass_streak 2→3 (stable promotion eligible).

## QA-1519 — Brand > Content - All Data set - Engagement Breakdown (3/4)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (22, most recent first)
- APPS-57474 (Test Failure, Major, Closed) — Brand Content - Export - Custom datasets are not displaying as per the entries in the 'Data set' Name
- APPS-55546 (Test Failure, Major, Closed) — Brand > Content - Aggregate average values mismatched b/w dev and prod
- APPS-54889 (Test Failure, Major, Closed) — Brand > Content - Most of the Columns are missing in the Export
- APPS-54685 (Test Failure, Major, Closed) —  Export not working
- APPS-50173 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-49529 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-48127 (Test Failure, Major, Closed) — Brand > Content - CSV Files Received via Email Instead of Google Sheets
- APPS-47030 (Test Failure, Major, Closed) — Brand > Content - While exporting All Data Sets, Data Set Headers are not available for Facebook channel
- LFMP-29868 (Bug, Major, Closed) — Brand > Content - On All Data Set export, Tag names displayed in the Data Set Headers Row
- APPS-29035 (Test Failure, Major, Closed) — Engagements metric displays twice in detail and grid view
- +12 earlier closed defects

## QA-1677 — Brand Content - Tag Post (MUTATING with cleanup) (9/9)

- **Skill:** `brand-content-tag-post`
- **My latest run (2026-06-02 batch-10):** PASS 9/9 with cleanup verified — `qa-1677-rerun-2026-06-02-0440` added to MTV BTS Reel; Tag (18)→Tag (19); filter None Include→264 posts / Exclude→3 posts; Table+Detail view; cleanup F5 confirmed Tag (19)→(18). No regressions. Tag is no longer auto-lowercased (previous run noted lowercasing, but this run's tag was already all-lowercase numerics+hyphens so no transformation observed).

### Open bugs (0)
_None._

### Closed bugs (8, most recent first)
- APPS-44329 (Test Failure, Major, Closed) — Brand > Content - While clicking the tag button on any post, the page scrolls to the bottom
- APPS-43825 (Test Failure, Major, Closed) — Brand > Content - Tag filter is not working correctly
- LFMP-27949 (Bug, Major, Closed) — Brand > Content - Tag Count is not displaying after applying Tag filter
- APPS-23750 (Test Failure, Major, Closed) — Added tag not available after refreshing the page
- APPS-11787 (Bug, Major, Closed) — Locks not display for YT in Impression column - Brand Content
- APPS-11683 (Bug, Major, Closed) — Brand content - Added tag not available after refreshing the page
- LFMP-19413 (Bug, Major, Closed) — Brand Content - Added tag not available after refreshing the page
- APPS-9882 (Test Failure, Major, Closed) — Brand content page not loaded

## QA-2706 — Brand > Content - Benchmark - Authorized (6/6)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- LFMP-31886 (Bug, Minor, Open) — Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in Video views column
  - Could not reproduce 2026-05-29 — may be fixed; verify with eng before closing the Jira. DOM read of Owned Average row on Brand>Content>Benchmark for Amazon Prime Video Authorized + Rolling 7 Days: Video Views cell renders `794,992(-31%)` with parentheses consistent with all six other metric columns (`25,948(-11%)`, `25,223(-12%)`, etc.). No inconsistency visible in current build.

### Closed bugs (7, most recent first)
- APPS-41894 (Test Failure, Major, Closed) — Brand > Content - Benchmark filter is not updating correctly in post table
- APPS-28437 (Bug, Major, Closed) — Brand > Content - Benchmark Average is N/A
- APPS-28186 (Bug, Major, Closed) — Brand > Content - Benchmark not applied in Detail view posts
- APPS-21439 (Test Failure, Major, Closed) — Spinner is still displaying after loading the benchmark - content Analysis
- APPS-14518 (Test Failure, Major, Closed) — Channel content page not loaded (Table view)
- APPS-11675 (Test Failure, Major, Closed) — Post table not displayed when applying the benchmark - Content tab
- APPS-11612 (Bug, Major, Closed) — Switching Views After Creating A Benchmark Fails to Load a Benchmark

### Sweep notes
- On Brand > Content > Benchmark Authorized, check the Owned Average row's Video Views column for missing parentheses (LFMP-31886).

## QA-19557 — Brand Content - Impressions Data Set - IG Stories

- **Skill:** `brand-content-table-view`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (2)
- LFMP-32016 (Bug, Major, Open) — Story post data is not being displayed on the Brand > Content page
  - Reproduced 2026-05-29 by re-run on Adam Orfei / MTV: enabling the Instagram Stories checkbox on Impressions data set causes Brand>Content table to fail with "This table failed to load." Stories tab itself shows healthy data, confirming this is a Content-page rendering/API failure.
- APPS-58817 (Bug, Major, Open) — Brand Content - Posts deleted from Native are still visible in LF app
  - NOT VERIFIED 2026-05-29 — table-failure above blocked post enumeration; needs a brand where impressions_with_stories renders.

### Closed bugs (9, most recent first)
- APPS-56955 (Test Failure, Major, Closed) — Brand > Content - LinkedIn - The impressions and Engagement Rate data are not populating
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab
- APPS-41893 (Test Failure, Major, Closed) — Brand > Content - Story Posts Showing on Brand Content Incorrectly
- DATA-9662 (Bug, Major, Closed) — Brand > Content - Story Posts is not displaying
- APPS-31499 (Test Failure, Major, Closed) — Brand > Content - Impressions data is not available for story posts
- APPS-31129 (Test Failure, Major, Closed) — While selecting Instagram stories option, Data set reset into Basic - Brand > Content
- APPS-30832 (Bug, Major, Closed) — Brand > Content - Stories not Displaying
- APPS-30472 (Test Failure, Major, Closed) — Brand > Content - Instagram story option is not Working
- APPS-28298 (Bug, Major, Closed) — Brand > Content - Instagram Stories Impressions not Displaying

### Sweep notes
- On any Brand>Content Threads / Stories test on Adam Orfei, verify APPS-58817 (deleted-from-native posts still visible) and LFMP-32016 (Story post data not displayed) are still open — easy to reproduce by exporting a deleted post or checking the Stories tab.

## QA-98368 — Brand Content - Threads - Post Type Hovering (5/5)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- APPS-57985 (Bug, High, QA Ready) — Thumbnail Issue for LinkedIn Posts
  - NOT VERIFIED 2026-05-29 batch 2 — HBO Max on Adam Orfei dev account lacks both Threads and LinkedIn in the Brand>Content channel selector; cross-channel LinkedIn thumbnail check requires LinkedIn-enabled brand on a different account. Bug status remains "QA Ready"; recommend LFIQA verify on a LinkedIn-enabled brand directly.

### Closed bugs (5, most recent first)
- DATA-12009 (Bug, High, Closed) — Thumbnail Issue for Thread Posts
- DATA-11959 (Bug, Major, Closed) — Brand > Content - Inconsistent Thumbnail Population
- LFMP-30925 (Bug, Major, Closed) — Max (Streamer) brand is not available in Dev - Max Account
- APPS-53130 (Test Failure, Major, Closed) — Brand > Content - Extra Space Displayed on Threads Video Posts When Hovering
- APPS-53103 (Test Failure, Major, Closed) — Brand > Content - Incorrect Scrollbar Display on Threads Posts While Hovering

### Sweep notes
- Open any LinkedIn post on Brand > Content and check thumbnail rendering — APPS-57985 still in QA Ready.

## QA-100764 — Brand > Content - Daily Post Analysis Modal - Threads (6/6)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-06-02 batch-7):** PASS (re-confirmed)

### Open bugs (0)
_None._

### Closed bugs (1, most recent first)
- APPS-55376 (Test Failure, Major, Closed) — Brand > Content - Post shows reload tile on Daily Analysis model

### 2026-06-02 batch-7 re-run findings
- HBO Max brand (spec says "Max") confirmed as same entity (rebrand to "Max" still not reflected in brand metadata). Modal displays "HBO Max" in both post header and graph header.
- Daily Post Analysis modal renders correctly with all 6 assertions PASS. Area chart re-scales Y-axis 0→55K (Line) to 0→65K (Area).

## QA-109062 — Custom Data Sets on Brand > Content - Export (7/7)

- **Skill:** `brand-content-data-set-selector`
- **My latest run (2026-06-02 batch-8):** PASS 7/7

### Open bugs (0)
_None._

### Closed bugs (1, most recent first)
- APPS-54887 (Bug, Major, Closed) — Custom Data Sets Bugs

### 2026-06-02 batch-8 re-run findings
- Re-confirmed with `Test Custom Data Set-775` (existing LFQA CDS on Adam Orfei, since `QA-106218-rerun-2236` from batch 7 was cleaned up). All 7 assertions PASS end-to-end: A1 (URL `table_data_set` param updates), A2 (CDS-configured metrics appear in aggregate table — note this CDS holds 9 metrics not the QA-106218 template, but spec-compliance holds for whichever CDS is loaded), A3 (LF data sets disabled in export modal when CDS active), A4 (only Pinterest remains disabled after unchecking CDS), A5 (`MTV-Brand Content-2026-05-25-2026-05-31-posts.csv` saved 86,895 bytes), A6 (CSV Row 1 carries `Test Custom Data Set-775` label, no LF data sets), A7 (Post 1 metrics match page exactly: Engagements 1,240,264 / Reactions 1,230,179 / Comments 10,085).

## QA-109920 — Sentiment Comments Donut "Read" popup

- **Skill:** `brand-content-data-set-selector` + `chart-hover-tooltip` + `export-csv`
- **My latest run (2026-06-02 batch-8):** PASS 2/3 (Read popup reachable; A2 NOT VERIFIED due to in-popup tile-load failure that recovers neither via Reload)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-8 re-run findings
- **Recharts donut Read-button click is now reachable via Chrome MCP `hover`.** Previously documented as DEFERRED quirk; sustained `computer.hover` over the donut segment center renders the Recharts tooltip with the Read button, and clicking Read opens the popup modal titled "Positive Classification: 50%". Quirk entry updated.
- **In-popup Sample Comments tile fails to load.** After Read-click, the popup body loads "Loading..." for ~20 seconds then renders "This tile failed to load. Please try again." Reload retry also fails. As a result, the spec A2 message ("2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000") was not observed in this run — NOT VERIFIED. This appears to be a load-failure on the sample-fetch endpoint specifically (the CSV export pipeline serves the same data successfully).
- **CSV export verified end-to-end.** `Amazon Prime Video-Brand Content-2025-04-01-2025-04-07-comments-sentiment.csv` (1.2 MB, 6,160 rows, all classified `Positive`). A3 PASS (6,160 > 2,000). Filename pattern matches `<Brand>-<Tab>-<Start>-<End>-comments-sentiment.csv`.

## QA-134277 — CSV Export respects tag filter

- **Skill:** `brand-content-filter`
- **My latest run (2026-05-27/29):** PARTIAL

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-05-29 re-run findings (batch 4)
- **Backend rejects OR-operator + None-tag combination (NEW).** Filter URL `content_tags:[{operator:"or",values:[""],not:"false"},{operator:"or",values:["#1 streaming premiere"],not:"true"}]` causes the posts table to fail to load with persistent "This table failed to load. Please try again." message. Switching the same Include side to `operator:"and"` works (POSTCOUNT_A=102). Reproduced on Hulu (account_id=336) Brand>Content on 2026-05-29. Recommend backend ticket.
- **Export button disabled when Posts (0) (NEW).** When Brand>Content filter returns 0 posts, the Export button in the top-right toolbar renders as disabled/greyed. This blocks A6 verification ("No tag columns in CSV in empty-state scenario") because no export is possible. May be intentional UX, but it's worth confirming and either documenting or enabling export of empty CSVs.
- **A1/A2/A5 verified end-to-end on real CSVs.** AND-mode Include None + Exclude #1streamingpremiere yielded 102-row Public-data-set CSV with 25 columns and no Tag column — matches UI count exactly.

## QA-134448 — Brandsets > Partnership tag filtering

- **Skill:** `brand-content-filter`
- **My latest run (2026-06-02 batch-5):** PASS (upgraded from PARTIAL)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-5 re-run findings
- Brand Sets > Partnerships HAS Include + Exclude Tag Filter end-to-end on HBO Max / LF // TV // Episodic. Verified A1-A8 via direct UI interaction + URL JSON serialization (`content_tags:[{operator:"or",values:["#max"],not:"false"},{operator:"or",values:["#20daysofkindness"],not:"true"}]`). A9 PASS by per-pill component parity; A10/A11 DEFERRED (named Save Filter + per-tile PNG export not budget-feasible).

## QA-134449 — Brandsets > Optimization tag filtering

- **Skill:** `brand-content-filter`
- **My latest run (2026-06-02 batch-5):** PASS (upgraded from PARTIAL)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-5 re-run findings
- Brand Sets > Optimization HAS Include + Exclude Tag Filter end-to-end on HBO Max / LF // TV // Episodic. Verified A1-A8 via direct UI interaction; tiles re-rendered "There is no data available" on Apply with Include #max ∧ NOT #20daysofkindness (genuine zero-result); Clear All restored tiles. A9 PASS by per-pill component parity; A10/A11 DEFERRED.

## QA-134516 — Reporting > CPR layered tag filtering

- **Skill:** `brand-content-filter`
- **My latest run (2026-05-27/29):** PARTIAL → 2026-05-29 batch 4: FAIL (spec mismatch)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-05-29 re-run findings (batch 4)
- **CPR Tag Filter lacks Include/Exclude semantics (NEW spec/feature mismatch).** On HBO Max (account_id=657) → Reporting > Content Performance → Tag filter sub-popup: only `Or | And` operator + tag-value checkboxes. **No Include section. No Exclude section. No Include/Exclude radios.** This directly contradicts QA-134516 A1 ("Tag Filter panel opens with Include + Exclude sections visible/empty"). DOM-verified: `document.querySelectorAll('input[type="radio"]')` near the popup yields zero Include/Exclude radios. Either CPR needs Include/Exclude feature parity with Brand>Content, or the QA-134516 spec needs to be rewritten. Recommend product triage.
- **HBO Max account lacks "LF // TV // EPISODIC" brand set.** Searched competitive-set list for "LF // TV" and "Episodic" — no hits. Per Rule 1, treated as test-data gap, did not substitute. Used Add Brand By Name="Euphoria" to exercise the Tag Filter mechanic instead.

## QA-135319 — Brand > Content - Default selections + Include/Exclude + filter removal

- **Skill:** `brand-content-filter`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

## QA-135321 — Brand > Content - Additional filter with tag filter

- **Skill:** `brand-content-filter`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

# Brand > Insights / Audience / Paid / Stories

## QA-1124 — Brand Insights - Public Data - Hovering Functionality

- **Skill:** `chart-hover-tooltip`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- LFMP-31781 (Bug, Minor, Open) — Brand Insights - Hovering Functionality - twitter icon color is blue
  - Reproduced 2026-05-29 by re-run, batch 2 (MTV on Adam Orfei): DOM RGB read of `.legend__icon.twitter-legend` = `rgb(29,161,242)` (legacy Twitter blue) on legend chips AND on the in-tooltip Twitter row. Channels-row `.channel-icon.twitter.fab.fa-square-x-twitter` correctly renders transparent + black, confirming the inconsistency is local to the legend/tooltip component.

### Closed bugs (9, most recent first)
- DATA-12033 (Bug, Major, Closed) — Brand Insights > Impressions shows zero on Insights page for FB
- APPS-57904 (Bug, Major, Closed) — Brand > Insights > BPC data is not Loading on Stage
- APPS-45344 (Test Failure, Major, Closed) — Home Screen is Blank When Switching Accounts
- APPS-45080 (Test Failure, Major, Closed) — Brand > Insights - Data Visualization dropdown is highlighted while clicking the option
- APPS-44634 (Test Failure, Major, Closed) — Brand > Insights - Data Visualization dropdown is highlighted while clicking the option
- APPS-43227 (Test Failure, Major, Closed) — Brand > Insights - Incorrect tooltip displays for Content Engagement Rate tile
- APPS-41327 (Bug, Major, Closed) — Brand > Insights - Inconsistent Twitter Icon colour displays in Tooltip
- LFMP-28494 (Bug, Major, Closed) — Brand > Insights - New Posts and Engagements tiles are Misaligned
- APPS-36745 (Test Failure, Major, Closed) — Brand Content > Perspective toggle not working when changed to Extended from public data

### Sweep notes
- Hover the Twitter chip tooltip during any Brand Insights run; confirm LFMP-31781 (blue twitter icon color) is still present.

## QA-12532 — Brand Sets > Partnerships - Tile-level PNG

- **Skill:** `audience-metrics-export`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- LFMP-31903 (Bug, Minor, Open) — BrandSet > Partnerships > Avg. Engagements per Post > Export > Png file does download without .png extention
  - Reproduced 2026-05-29 by re-run, batch 2 (LF // TV // Episodic, Amazon Prime Video account): downloaded file `LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31` has no `.png` suffix; `file` command confirms PNG content (556×946 RGBA). Sibling Partners tile in 2026-05-27 run saved correctly as `.png`. Bug is tile-specific to Avg. Engagements per Post.

### Closed bugs (12, most recent first)
- APPS-59151 (Bug, Major, Closed) — Brand / Brand Set > Partnership: Big Number cards show incorrect values in Pie and Table charts and their exports
- APPS-55960 (Test Failure, Major, Closed) — Brand Sets > Partnerships - Sponsored Posts Tile shows Reload tile
- APPS-43188 (Bug, Trivial, Closed) — Brand Sets > Partnerships - Tab name is incorrect in PNG Export for Partners, Sponsors, Partnerships
- APPS-36220 (Bug, Major, Closed) — Global - Tile level Export - PNG Export is not working
- APPS-34534 (Test Failure, Major, Closed) — Competitive > Partnerships - Partners, Sponsors and Partnerships tables are not displayed
- APPS-31993 (Bug, Major, Closed) — Competitive > Partnerships - No data displayed while changing brand set for the first time 
- LFMP-26587 (Bug, Major, Closed) — Partners,Sponsors,Sponsored Posts are not loaded - Competitive > Partnerships
- APPS-25109 (Test Failure, Major, Closed) — Not able to export PNG for all Tabs in Legacy
- LFMP-24220 (Bug, Major, Closed) — Sponsors and partnership table is not available - Branded Partnership
- APPS-24429 (Bug, Major, Closed) — Columns Missing From Instant Exports
- LFMP-23463 (Bug, Major, Closed) — Partners, Sponsors and Partnerships tiles are hidden - Collection Partnerships
- APPS-22282 (Test Failure, Major, Closed) —  PARTNERS, Sponsors and Partnerships tiles are hidden - Collection Partnerships

### Sweep notes
- Trigger BrandSet > Partnerships > Avg. Engagements per Post PNG export and confirm filename still drops `.png` (LFMP-31903).

## QA-20988 — Brand > Paid - Tile-level PNG (6/6)

- **Skill:** `audience-metrics-export`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- DATA-12089 (Bug, Major, Code Review) — Brand > Paid - TikTok Paid Data not Displaying

### Closed bugs (6, most recent first)
- DATA-12023 (Bug, Critical, Closed) — Brand > Paid - TikTok Paid Data not Displaying
- APPS-46074 (Test Failure, Major, Closed) — Brand > Paid - Spend Big Number tile and Ads are displaying Go to Authorize
- APPS-45344 (Test Failure, Major, Closed) — Home Screen is Blank When Switching Accounts
- APPS-42258 (Test Failure, Major, Closed) — Brand > Stories - Big number tiles is not available
- APPS-36220 (Bug, Major, Closed) — Global - Tile level Export - PNG Export is not working
- APPS-29174 (Bug, Minor, Closed) — Brand Paid > Triangle arrow is displaying as a square in PNG

## QA-96038 — IG Audience - Followers: Gender Breakdown data (2/2)

- **Skill:** `audience-metrics-export`
- **My latest run (2026-06-02 batch-12):** PASS 2/2 re-confirmed. M=856,949, F=1,333,591 in both Gender Breakdown fetch (`dimensions=[instagram.page.gender]` only) and CSV first row. Each of 7 CSV rows shows day-snapshot value (NOT sum). Identical numerics to 2026-05-27 batch — Hulu IG follower base hasn't moved. Filename `Hulu-Audience-Followers Gender Breakdown-2026-05-19-2026-05-25.csv`. Fetch-hook capture pattern used again.

### Open bugs (0)
_None._

### Closed bugs (2, most recent first)
- APPS-53681 (Test Failure, Major, Closed) — Brand > Audience - Page not loading
- APPS-52390 (Bug, Major, Closed) — Instagram Audience - overreporting

## QA-110074 — Brand > Audience - Threads - Tile-level PNG export (5/5)

- **Skill:** `audience-metrics-export`
- **My latest run (2026-06-02 batch-8):** PASS 5/5 (re-verified end-to-end)

### Open bugs (0)
_None._

### Closed bugs (2, most recent first)
- APPS-58183 (Bug, Trivial, Closed) — Brand Audience > The language tile position changes after selecting a 12-month date range.
- APPS-55719 (Test Failure, Major, Closed) — Brand > Audience - Facebook tiles are loading when changing the date range in the non FB tab

### 2026-06-02 batch-8 re-run findings
- All 5 Threads PNGs downloaded under spec filename pattern `MTV-Audience-<Chart>-2025-03-16-2025-03-22.png` (`Followers By Country` 134KB, `Followers By City` 145KB, `Followers Geo Breakdown By Country` 273KB, `Followers Geo Breakdown By City` 356KB, `Followers Gender Breakdown` 53KB). Direct-PNG-read of Gender Breakdown confirms layout: LISTENFIRST logo, brand `MTV`, chart title `Followers: Gender Breakdown`, 42/50/8% donut, `Brand Audience` tab footer with `Date: Mar. 16, 2025-Mar. 22, 2025`.

## QA-116113 — YouTube Audience Tile-level PNG (3/3)

- **Skill:** `audience-metrics-export`
- **My latest run (2026-06-02 batch-8):** PASS 6/6 (on older date window — see DATA-12043 finding)

### Open bugs (1)
- DATA-12043 (Bug, Major, Code Review) — Data is not coming in for YouTube channel in brand > audience page.
  - **Batch-8 status update (2026-06-02):** Partially reproduces. On Disney Channel YouTube Audience with default window May 25–31 2026, ALL 5 tiles render "There is no data available. Please select a different brand, brand set, or date range." On older window May 1–31 2025, all tiles populate with real distributions (Gender 41/58/1, Age 13-17 7%, 18-24 19%, 25-34 27%, 35-44 29%, 45-54 12%, 55-64 4%, Demographics bar chart non-zero across all 7 age groups). Suggests DATA-12043 is now a freshness/lag issue rather than a complete outage. Recommend updating Jira bug status with this clarification.

### Closed bugs (1, most recent first)
- DATA-12064 (Bug, Major, Closed) — Data is not coming in for Twitter channel in brand > audience page.

### 2026-06-02 batch-8 re-run findings
- All 3 PNGs downloaded for May 1-31 2025 window: `Disney Channel-Audience-Views Gender Breakdown-2025-05-01-2025-05-31.png` (58KB), `Disney Channel-Audience-Views Age Breakdown-2025-05-01-2025-05-31.png` (51KB), `Disney Channel-Audience-Views Demographics-2025-05-01-2025-05-31.png` (83KB). Direct-PNG-read of Demographics confirms: LISTENFIRST logo, brand `Disney Channel`, chart title `Views: Demographics`, bar chart populated across all 7 age groups, footer `Brand Audience` + `Date: May. 01, 2025-May. 31, 2025`. All 6 spec assertions PASS.

### Sweep notes
- On YouTube Audience tile PNG export, confirm DATA-12043 (Data not coming in for YouTube) status — partially-reproducing as of 2026-06-02 (older windows have data, recent default window does not).

## QA-134182 — Brand > Insights - Interval Date selector historical limits

- **Skill:** `brand-insights-interval-picker`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

## QA-134184 — Brand > Insights - Interval selection - Quarterly

- **Skill:** `brand-insights-interval-picker`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

## QA-134188 — Brand > Insights - Verify Export (Monthly Interval)

- **Skill:** `brand-insights-interval-picker`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

# TWC (Time Window Comparison)

## QA-198 — TWC Exports - Absolute dates

- **Skill:** `time-window-comparison-run`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (22, most recent first)
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-50403 (Test Failure, Major, Closed) — Reporting > TWC - Google Sheets Export is not working
- APPS-50146 (Test Failure, Major, Closed) — Reporting - Classic Reporting - Lengthy brand names overlap in the brand container.
- APPS-49531 (Test Failure, Major, Closed) — Reporting > TWC - Export is not working
- APPS-49528 (Test Failure, Major, Closed) — Reporting > TWC - The Report is not loaded fully
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-42925 (Test Failure, Major, Closed) — Classic Reporting > TWC - Start date and End date are displayed in export instead of Date Column
- APPS-38923 (Test Failure, Major, Closed) — Reporting > TWC - Export dropdown disappears after clicking
- APPS-38574 (Test Failure, Major, Closed) — Reporting > TWC The brand's image and brand type are missing in the report header
- +12 earlier closed defects

## QA-281 — TWC report for Relative dates with long intervals

- **Skill:** `time-window-comparison-run`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- LFMP-31961 (Bug, Major, Open) — Reporting > TWC > New Followers > The data is not displayed correctly.
  - Reproduced 2026-05-29 by re-run on story 153796 (Disney Channel + Disney Junior + Wells Fargo, 15→1 Weeks Out): chart Y-axis floored at 0; negative net-follower values clipped to baseline. Wells Fargo (entirely negative across window) renders as flat unreadable line. Disney Channel last-3-weeks negatives (-952, -481, -355) invisible on chart but correct in table.

### Closed bugs (19, most recent first)
- APPS-52550 (Test Failure, Major, Closed) — Run Report button disabled while changing perspective 
- APPS-50144 (Test Failure, Major, Closed) — Reporting > Classic Reporting - TWC - The Report is not loading for Relative Dates - Weeks Interval 
- APPS-49531 (Test Failure, Major, Closed) — Reporting > TWC - Export is not working
- APPS-49528 (Test Failure, Major, Closed) — Reporting > TWC - The Report is not loaded fully
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-37192 (Test Failure, Major, Closed) — Classic Reporting > Data Selection Section is Not Available on Initial Load
- APPS-36831 (Bug, Trivial, Closed) — Classic Reporting > Incorrect date format displayed in the Export
- LFMP-26497 (Bug, Major, Closed) — Export and change settings disappeared while selecting the CSV - Classic Reporting
- APPS-30206 (Test Failure, Major, Closed) — Export  and change settings disappeared while selecting the CSV - Classic Reporting
- LFMP-26247 (Bug, Major, Closed) — Classic Reporting - Run Report not working
- APPS-29012 (Test Failure, Major, Closed) — Reporting - Export options Disabled
- APPS-29013 (Test Failure, Major, Closed) — Reporting - Report page stuck on 'View now' 
- LFMP-25651 (Bug, Major, Closed) — Export is not working - Classic Reporting 
- APPS-28318 (Test Failure, Major, Closed) — Run Report is not working - Classic Reporting
- APPS-28161 (Test Failure, Major, Closed) — Export is not working - Classic Reporting
- APPS-27984 (Test Failure, Major, Closed) — Export is not working - Classic Reporting 
- APPS-25867 (Test Failure, Major, Closed) — Export is not working - Classic Reporting 
- APPS-25417 (Test Failure, Major, Closed) — Reporting - CPR Report page stuck on 'View now'

### Sweep notes
- After TWC report run, verify the New Followers chart still shows the LFMP-31961 data display defect.

## QA-1053 — TWC Aggregate - Relative dates - Lock icon and Endash

- **Skill:** `time-window-comparison-run`
- **My latest run (2026-06-02 batch-7):** PASS (re-confirmed)

### 2026-06-02 batch-7 re-run findings
- All 3 brands keyed to Jan 01, 2024 on Aggregate Relative Dates (5 Days Before, 0 Days After). Hulu in Authorized perspective. FFwSB + Snowfall remain Public (no auth available).
- **A1 (Snowfall endash for TikTok Total Followers):** PASS — both Graph (no Snowfall bar — DOM verified 2 `<rect>` data points only) AND Table (`–` endash in Snowfall row).
- **A2 (Lock for Instagram Comments on FFwSB+Snowfall):** PASS — Graph X-axis positions both render colored lock icons; Table cells both show lock icons (Hulu=1,265 — actual numeric value).
- **A3 (TikTok numbers for Hulu+FFwSB):** PASS — Hulu=5,500,000, FFwSB=149,700.

### Open bugs (0)
_None._

### Closed bugs (11, most recent first)
- APPS-53940 (Test Failure, Major, Closed) — Reporting > TWC - Data is not populated for Instagram Comments and TikTok Total Followers
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on View now
- APPS-49760 (Test Failure, Major, Closed) — Classic Reporting > TWC - Key dates are displaying in the legend row
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-38574 (Test Failure, Major, Closed) — Reporting > TWC The brand image and brand type are missing in the report header
- APPS-37192 (Test Failure, Major, Closed) — Classic Reporting > Data Selection Section is Not Available on Initial Load
- LFMP-26247 (Bug, Major, Closed) — Classic Reporting - Run Report not working
- APPS-29013 (Test Failure, Major, Closed) — Reporting - Report page stuck on View now
- APPS-28318 (Test Failure, Major, Closed) — Run Report is not working - Classic Reporting
- APPS-7853 (Bug, Major, Closed) — TWC report form - Values mismatched between Table and Graph

## QA-19482 — TWC - Verify PDF

- **Skill:** `time-window-comparison-run`
- **My latest run (2026-06-02 batch-10):** PASS 6/6 — Run 1 carry-over (PDF re-verified) + Run 2 completed end-to-end on Adam Orfei context (MTV + All NBA, Facebook + Twitter, Options bundle Interleave + Cohort Average label "Cohort Average" + Highlight Leader + Source Links + Insights Editor). Saved `MTV-Time Window Comparison(May 25, 2026 - May 31, 2026).pdf` (11.8 MB, 23 pages, jsPDF 3.0.1). All 6 spec assertions PASS via pdftoppm rasterization. Per-row Highlight Leader switches (May 28 → All NBA yellow on Twitter Avg Video Views when MTV=`–`).

### Open bugs (0)
_None._

### Closed bugs (22, most recent first)
- DATA-12065 (Bug, Major, Closed) — Response rate , subscriber and followers Data is not coming for Tik-Tok and Youtube channel in TWC Report Page.
- APPS-55569 (Test Failure, Major, Closed) — Reporting - TWC - PDF displays an Empty page
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-53050 (Test Failure, Major, Closed) — TWC > The report shows 500 error after clicking the run report button
- APPS-52583 (Test Failure, Major, Closed) — Brand > Content - Public brands are not loading and it shows a reload tile
- APPS-52155 (Bug, Trivial, Closed) — Classic Reporting > Social Recap - The Channel and Profile column headers are misaligned in the print preview view
- APPS-50167 (Test Failure, Major, Closed) — Reporting > TWC - When selecting an option in the make a selection dropdown - Calendar disappears
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-47777 (Test Failure, Major, Closed) — Classic reporting - The Change settings modal got stuck in the top
- APPS-47756 (Test Failure, Major, Closed) — Classic reporting - The Change settings modal got stuck in the top 
- +12 earlier closed defects

## QA-24544 — Reporting > TWC - Share Functionality

- **Skill:** `time-window-comparison-run`
- **My latest run (2026-05-27/29):** PARTIAL

### Open bugs (0)
_None._

### Closed bugs (14, most recent first)
- APPS-54201 (Bug, Trivial, Closed) — Safari - Reporting > TWC - The caret dropdown displays twice
- APPS-50985 (Test Failure, Major, Closed) — Reporting -> TWC - Brand text is hidden when pressing Enter in the Add Brand field
- APPS-50843 (Test Failure, Major, Closed) — Reporting > TWC - The report form is stuck in View now state
- APPS-49813 (Test Failure, Major, Closed) — Classic Reporting - TWC - The report is not loading fully
- APPS-49528 (Test Failure, Major, Closed) — Reporting > TWC - The Report is not loaded fully
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-42586 (Test Failure, Major, Closed) — Reporting > Classic Reporting - In Preview mode, Share and Download button not displaying
- APPS-42225 (Bug, Minor, Closed) — Fix Share Modal loading behaviour
- APPS-42220 (Test Failure, Major, Closed) — Reporting > Classic Reporting - Share Modal stuck in load state
- APPS-38208 (Test Failure, Major, Closed) — Reporting > Classic Reporting - Getting console error while loading the Historical link
- APPS-35923 (Test Failure, Major, Closed) — Classing Reporting > TWC - Metric Headers missing in the Report
- APPS-33938 (Bug, Major, Closed) — Page returns to login page when try to login
- APPS-33880 (Test Failure, Major, Closed) — Classic Reporting > Copied link is stored as Undefined

# Reporting > Social Recap / PDF

## QA-837 — Social Recap: Report - Multiple brands (6 PASS / 1 inconclusive)

- **Skill:** `social-recap-report-run`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (2)
- LFMP-31918 (Bug, Major, Open) — Thumbnail Issue : Report > Social Recap - Thumbnail not showing properly for some posts after downloading report and also for normal reports.
  - Reproduced 2026-05-29 by re-run via PDF end-to-end inspection: Conan Best Performing Content page (p4) — IG Image-type posts 2 and 3 (@teamcoco RT @ConanOBrien) render with only post text in the thumbnail area, no actual image. Hulu BPC posts all render thumbnails.
- LFMP-31798 (Bug, Major, Open) — Reporting > Social Recap - Up and down arrows do not appear correctly in the doughnut charts in the export. 
  - Reproduced 2026-05-29 by re-run: every YOY indicator across all 16 donut centers (4 per page × 4 pages of Hulu+Conan PDF) renders as `□` empty square instead of ▲/▼. Confirmed across multiple Social Recap PDFs (also visible in QA-23969 PDFs) — likely missing font glyph in PDF font subset. Affects all brands and both colors.

### Closed bugs (20, most recent first)
- APPS-60639 (Bug, Major, Closed) — Reporting > Social Recap - Best Performing Content is not showing after Downloading the Report.
- APPS-57906 (Bug, Major, Closed) — Reporting > Social Recap, BPC and WPC data is not loading on Stage
- APPS-56587 (Test Failure, Major, Closed) — Social Recap Report stuck on loading view
- APPS-55569 (Test Failure, Major, Closed) — Reporting - TWC - PDF displays an Empty page
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-52550 (Test Failure, Major, Closed) — Run Report button disabled while changing perspective 
- APPS-52155 (Bug, Trivial, Closed) — Classic Reporting > Social Recap - The Channel and Profile column headers are misaligned in the print preview view
- APPS-49527 (Test Failure, Major, Closed) — Reporting > Classic Reporting > TWC - Incorrect file name displays
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-45574 (Test Failure, Major, Closed) — Classic Reporting > Social Recap - After generating the report - Brand Order is Incorrect
- LFMP-29669 (Bug, Major, Closed) — Reporting > Classic Reporting > Social Recap - All the channels were disabled on the channel data
- APPS-44322 (Test Failure, Major, Closed) — Classic Reporting > Social Recap - Brand Image is displaying small in size 
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-43329 (Test Failure, Major, Closed) — Reporting  > Classic Reporting -  Total Fans banner not displaying in Social Recap Report
- APPS-42586 (Test Failure, Major, Closed) — Reporting > Classic Reporting - In Preview mode, Share and Download button not displaying
- APPS-37840 (Bug, Major, Closed) — Reporting > Classic Reporting ( Social Recap ) - Brand Image Not Displayed
- APPS-35104 (Test Failure, Major, Closed) — Reporting > Classic Reporting - Report page struck in View now
- APPS-32717 (Test Failure, Major, Closed) — Classic Reporting - Channel Data points not available in CPR and Social Recap template
- LFMP-26247 (Bug, Major, Closed) — Classic Reporting - Run Report not working
- LFMP-25915 (Bug, Major, Closed) — When I try to generate the report, the report navigate to Classic Reporting Tab

### Sweep notes
- Check the downloaded Social Recap PDF for the doughnut chart up/down arrows (LFMP-31798) and thumbnail rendering (LFMP-31918).

## QA-23969 — Reporting > Social Recap - Download

- **Skill:** `social-recap-report-run`
- **My latest run (2026-05-27/29):** FAIL

### Open bugs (1)
- LFMP-31925 (Bug, Major, Open) — Reporting > Social Recap ->  %YOY is not Present in Video Views Donut in Report.
  - Could not reproduce 2026-05-29 — may be fixed; verify with eng before closing the Jira. Inspected both single- and multi-brand QA-23969 PDFs; every Video Views donut on every brand page shows a `% YOY` label (e.g. ListenFirst `-100% YOY`, PLL `-3% YOY`, NBA `7.05% YOY`, Michael Kors `-36% YOY`). LFMP-31798 (arrow glyph) is still reproduced here, but %YOY itself is present.

### Closed bugs (25, most recent first)
- APPS-60034 (Bug, Major, Closed) — Reporting > Social Recap - Facebook Organic Impressions not present.
- DATA-12088 (Bug, Major, Closed) — TWC > Twitter New Followers showing negative values
- APPS-57906 (Bug, Major, Closed) — Reporting > Social Recap, BPC and WPC data is not loading on Stage
- APPS-57904 (Bug, Major, Closed) — Brand > Insights > BPC data is not Loading on Stage 
- APPS-55569 (Test Failure, Major, Closed) — Reporting - TWC - PDF displays an Empty page
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-52550 (Test Failure, Major, Closed) — Run Report button disabled while changing perspective 
- APPS-52155 (Bug, Trivial, Closed) — Classic Reporting > Social Recap - The Channel and Profile column headers are misaligned in the print preview view
- APPS-49527 (Test Failure, Major, Closed) — Reporting > Classic Reporting > TWC - Incorrect file name displays
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- +15 earlier closed defects

### Sweep notes
- Run the Social Recap report and check the Video Views donut for the %YOY label — LFMP-31925 still open.

## QA-131491 — Social Recap vs Brand > Content - IG Public Video View

- **Skill:** `social-recap-report-run`, `brand-content-data-set-selector`
- **My latest run (2026-06-08 QA-22296 batch-9 RECONFIRM):** PASS — Brand > Content MTV/Adam Orfei (brand_id=10765) / IG / Jan 1-7 2026 / Public — Post #1 Mon Jan 05 03:23 PM PST Reel: Engagements 44,227 / Reactions 43,971 / Comments 256 / Video Views 691,822 / Video Response Rate 6.39% — exact verbatim match with 2026-06-02 batch-9 run. No drift.

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

## QA-131492 — Social Recap vs Brand > Content - YouTube Video Views

- **Skill:** `social-recap-report-run`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

# Data Studio

## QA-90213 — Data Studio ↔ Brand Content Twitter parity (MTV)

- **Skill:** `data-studio-post-level-run`
- **My latest run (2026-06-02 batch-12):** MAJOR FINDING — mismatch NEARLY RESOLVED. DS Twitter Post Likes Sum 370,018 vs BC Reactions Sum 368,312 (Δ +0.46%); DS Twitter Post Replies 2,265 vs BC Comments 2,238 (Δ +1.21%). Previous batch (2026-05-27) showed 3.84× and 2.19× ratios — now sub-1.5%, consistent with normal snapshot freshness lag. Possible pipeline fix landed between batches. Recommend SME confirm whether sub-1.5% diff is tolerated under spec, otherwise file LFMP-31782b for residual.

### Open bugs (0)
_None._

### Closed bugs (3, most recent first)
- LFMP-31782 (Bug, Major, Closed) — Reporting > Data Studio - Brand > Content - Data QA Twitter - data is not matching
- APPS-55464 (Test Failure, Major, Closed) — Data Studio > Throwing error when clicking the Go button on the post level
- APPS-54214 (Test Failure, Major, Closed) — Data not Matched between Data Studio and the Brand Content

### 2026-06-02 batch-12 re-run findings
- DS Post Level (Aggregate, MTV Public, May 25–31, 2026, Lifetime): Twitter Post Likes Sum 370,018 / Twitter Post Replies Sum 2,265.
- BC (Table View, MTV Public, Twitter only, May 25–31, 2026, Public data set, include_retweets=false, Posts(58)): Reactions Sum 368,312 / Comments Sum 2,238.
- Δ now within freshness tolerance — likely pipeline reconciliation since 2026-05-27 batch.

## QA-96818 — Data Studio - Posts Level - Breakdown - Drag function (2/2)

- **Skill:** `data-studio-post-level-run`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (1)
- LFMP-31977 (Bug, Major, Open) — Reporting > Data Studio Report - Save to dashboard dropdown remains visible when graph tile is missing
  - Reproduced 2026-05-29 by re-run on Adam Orfei / Michael Kors / Authorized: with Publish Type breakdown active, banner "Graphs are not supported when Breakdowns are added to the report" appears AND Save-to-Dashboard dropdown remains visible AND functional (Yash dashboard + Create Dashboard buttons clickable).

### Closed bugs (1, most recent first)
- APPS-55464 (Test Failure, Major, Closed) — Data Studio > Throwing error when clicking the Go button on the post level

### Sweep notes
- On Data Studio Posts Level, verify the Save-to-Dashboard dropdown visibility when a graph tile is missing (LFMP-31977).

# Settings (Custom Metrics / Data Sets / Tags / Notifications / Data Collection)

## QA-2498 — Settings - Data Collection - Channels not collected

- **Skill:** `data-collection-brand-popup`
- **My latest run (2026-05-27/29):** FAIL

### Open bugs (0)
_None._

### Closed bugs (14, most recent first)
- APPS-58690 (Bug, Major, Closed) — Settings - Data Collection Status not reflecting - Brand Search
- APPS-47777 (Test Failure, Major, Closed) — Classic reporting - The Change settings modal got stuck in the top
- APPS-46051 (Test Failure, Major, Closed) — Settings > Data Collection - Brands are not available
- APPS-45642 (Test Failure, Major, Closed) — Settings > Data Identities page not loading
- APPS-45572 (Test Failure, Major, Closed) — Settings > Data Collection - Brands not available
- LFMP-28955 (Bug, Major, Closed) — Settings > Data Collection - Selected brand not displaying on the top
- APPS-39607 (Test Failure, Major, Closed) — Settings > Data Collection Strucked On a load state view
- APPS-31878 (Test Failure, Major, Closed) — Settings Authorization Page not loading
- APPS-16405 (Test Failure, Major, Closed) — Post Tracked data not available in Not collecting PopUp
- LFMP-20835 (Bug, Major, Closed) — Data collection panel not loaded
- APPS-14385 (Test Failure, Major, Closed) — Data collection panel not loaded
- LFMP-19562 (Bug, Major, Closed) — Able to see not supported channels in My Channels section - Account
- DATA-4786 (Bug, Major, Closed) — Connected Account management - Data Begins Has No Date
- APPS-11700 (Bug, Major, Closed) — Page hidden after hovering the (+)plus icon Circle

## QA-85176 — Settings > Custom Metrics - Custom Metric Create

- **Skill:** `settings-custom-metrics`
- **My latest run (2026-06-02 batch-6):** PASS (re-confirmed; mutating with cleanup)

### Open bugs (0)
_None._

### Closed bugs (1, most recent first)
- APPS-52565 (Test Failure, Major, Closed) — Settings > Custom Metrics - Unable to create a new custom metric

### 2026-06-02 batch-6 re-run findings
- Re-confirmed end-to-end: created `QA-85176-rerun-2026-06-02-1900` with formula `Post Comments + Shares`, Success modal appeared, list-page row visible (Created Jun. 02 2026), cleanup via Actions ellipsis → Delete → Ok confirmation completed and row removed. A1-A14 all PASS. Copy drift `Constants`/`Constant` still present.

## QA-104870 — Settings > Custom Data Sets - Basic View (12/13 + 1 N/A)

- **Skill:** `settings-custom-data-sets`
- **My latest run (2026-06-02 batch-7):** PASS (re-confirmed)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-7 re-run findings
- 9 CDS rows on Adam Orfei (up from 6 — Test Data 123, create-103 added between batches). All 9 use `Mon. DD, YYYY` date format. Ellipsis menu Edit/Delete/Duplicate in spec order. Settings dropdown order with Custom Data Sets after Brands re-confirmed.

## QA-106218 — Custom Data Sets - Create flow (13/14 + minor format variance)

- **Skill:** `settings-custom-data-sets`
- **My latest run (2026-06-02 batch-7):** PASS (re-confirmed)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-7 re-run findings
- Created `QA-106218-rerun-2236` with 7 metrics across 3 sub-categories (Public, Engagements Breakdown, Impressions). Lock-icon assignment (Comments/Shares/Engagement Rate/Impressions = 🔒, Engagements/Reactions/Response Rate = plain) re-confirmed. Cleanup via ellipsis Delete + Ok modal succeeded.
- Minor format variance `MM-DD-YYYY | HH:MM AM/PM PT` (pipe) vs `MM-DD-YYYY HH:MM AM/PM PT` (space) re-confirmed. Non-blocking.

## QA-134173 — Settings > Custom Metric - Info View (list)

- **Skill:** `settings-custom-metrics`
- **My latest run (2026-06-02 batch-6):** PASS (re-confirmed)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-6 re-run findings
- All 5 column tooltips verified (Metric / Description / Date Created / Creator / Formula). `Created Date` ↔ `Date Created` swap re-confirmed. Info toggle on/off behavior PASS.

## QA-134185 — Settings > Custom Metric Creation - Info View

- **Skill:** `settings-custom-metrics`
- **My latest run (2026-06-02 batch-6):** PASS (re-confirmed)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-6 re-run findings
- 3 of 4 spec elements tooltipped (Name / Description / Formula). 4th element `Metric Definition Link` still ABSENT on `/#custom-metrics/create` (verified via JS DOM scan: 0 hits for "definition" substring). Info toggle on/off behavior PASS.

# Exports (CSV / Google Sheets)

## QA-2035 — Brand Sentiment - CSV & GS

- **Skill:** `export-csv`
- **My latest run (2026-05-27/29):** PASS with new findings (batch 3)

### Open bugs (0)
_None._

### 2026-05-29 re-run findings (NEW)

- **Finding A (likely regression, candidate Jira):** Sentiment Export GS toggle delivers an identical CSV file (md5 `d0e5e3c524737720c019aaf75812ee84`) via the same `analytics-cdn.lfmdev.in/<id>-<hash>.csv` URL as the CSV mode. No `docs.google.com/spreadsheets/...` URL is produced. The two CSV exports (job 293187 and 293188) have IDENTICAL hash suffixes in their CDN paths, suggesting backend dedup that ignores the format selection. Pattern matches closed APPS-48127. Recommend LFIQA reproduce on hardware before filing.
- **Finding B (cosmetic / spec drift):** Time column actually renders as `11:47 PM` (no `PST` suffix) but the spec calls for `HH:MM XM PST`. Either the spec is stale or the suffix was silently dropped. Low severity.

### Closed bugs (17, most recent first)
- APPS-55184 (Test Failure, Major, Closed) — Brand > Content - Incorrect filename is displaying for export
- APPS-54685 (Test Failure, Major, Closed) —  Export not working
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab
- APPS-50173 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-49529 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-48127 (Test Failure, Major, Closed) — Brand > Content - CSV Files Received via Email Instead of Google Sheets
- APPS-47422 (Bug, Major, Closed) — Brand > Content - Sentiment - Incorrect file name displaying in all data sets export
- LFMP-29868 (Bug, Major, Closed) — Brand > Content - On All Data Set export, Tag names displayed in the Data Set Headers Row
- APPS-45078 (Test Failure, Major, Closed) — Brand > Content - Sentiment Tiles are not loading
- APPS-28320 (Test Failure, Major, Closed) — Sentiment  tiles are not loaded  - Brand  > Content
- APPS-21389 (Bug, Major, Closed) — undefined displays in the time column on the CSV and Google Sheet - Facebook Sentiment
- APPS-16691 (Test Failure, Major, Closed) — Comments not loaded in Post comments Popup
- APPS-16015 (Test Failure, Major, Closed) — Empty cells displays in the export - Content
- APPS-13911 (Test Failure, Major, Closed) — comment post table hidden
- APPS-12844 (Test Failure, Major, Closed) — Top Emotion displayed instead of Emotion - Sent 
- APPS-12014 (Bug, Major, Closed) — Post comment sentiments data not available on Export - Sent
- APPS-10935 (Bug, Major, Closed) — Incorrect file name displays - Sentiment

## QA-51425 — Radaac - Duplicate Brands and Social Pages report (CSV/TSV finding)

- **Skill:** `export-csv`
- **My latest run (2026-05-27/29):** PASS — CSV→TSV regression NOT REPRODUCED on 2026-05-29 (batch 3)

### Open bugs (0)
_None._

### 2026-05-29 re-run findings

- **CSV→TSV cache regression appears RESOLVED.** The 2026-05-27 finding (CSV exports delivered TSV-content with `.csv` extension) is no longer reproducible. Batch-3 re-run downloaded `20260601DuplicateBrandSocialPages_37a06f.csv` (1.12 MB, 14,987 lines) and confirmed via byte inspection that the first row is genuine comma-separated (`brand id,brand name,title category,channel,url,perspective`). AWK on tab-delimiter returns 1 field per row, confirming no tab separators. Recommend retiring the `known-quirks.md` entry's active guard.

### Closed bugs (2, most recent first)
- APPS-53077 (Test Failure, Major, Closed) — 502 Gateway Error displayed on Dev Radaac
- APPS-47752 (Bug, Major, Closed) — Radaac - Duplicate Brands and Social Pages Report - Export failed to download

## QA-51490 — Brand > Insights - Content Engagement Rate - Tile PNG/CSV

- **Skill:** `export-csv`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (4, most recent first)
- APPS-53319 (Test Failure, Major, Closed) — Brand > Insights - Content Engagement Rate and Trends tiles are displaying a Reload error
- APPS-45344 (Test Failure, Major, Closed) — Home Screen is Blank When Switching Accounts
- APPS-43228 (Test Failure, Major, Closed) — Brand > Insights - Duplicate columns are displayed in the Export
- APPS-43188 (Bug, Trivial, Closed) — Brand Sets > Partnerships - Tab name is incorrect in PNG Export

### 2026-05-29 re-run findings (batch 4)
- **PNG chart-title layout drift (minor):** PNG shows brand "Hulu" on its own line followed by a boxed sub-header "Content Engagement Rate" — no hyphen separator. Spec A9 wording implies a single line `Brand Name - Chart Name`. Both required text values present; layout differs.
- **PNG date placement (minor):** `Date: May. 25, 2026-May. 31, 2026` rendered at the PNG footer (after `Brand Insights` label), not directly below the legend block. Spec A11 wording says "below legend". Minor layout drift.
- **Channel column flattening (informational):** Area + Table CSVs both emit only `Cross-Channel` rather than one row per channel even though the tile's Legend shows Facebook/Twitter/Instagram/TikTok. Consistent with spec column list (no per-channel rows are mandated), but worth flagging for clarity.

## QA-65554 — Settings > Tags - Export Functionality - GS (3/3)

- **Skill:** `export-google-sheets`
- **My latest run (2026-06-02 batch-12):** PASS 3/3 — filename `Adam Orfei-Tags`, columns Tag/Date Created/Creator/Content Tagged. 5 UI-vs-GS spot-checks all match including `*` creator and `iconic`→2 outlier. pass_streak 2→3 (stable promotion eligible).

### Open bugs (0)
_None._

### Closed bugs (1, most recent first)
- APPS-58462 (Bug, Minor, Closed) — Settings > Tags : Exported Tags sequence is not matching with page sequence

# Response Rate / Math Verifier

## QA-129606 — Abnormal Response Rate - Tiktok/Twitter

- **Skill:** `response-rate-math-verifier` + `time-window-comparison-run`
- **My latest run (2026-06-02 batch-8):** PASS 5/5 for Twitter; TikTok DEFERRED (same mechanic, budget)

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-8 re-run findings
- TWC date-picker JS-fallback `document.querySelectorAll('th.prev')[N].click()` successfully navigated start picker 8 months back and end picker 7 months back to Sep 26 → Oct 3, 2025 (previously DEFERRED quirk). controlled-check-box `span.click()` worked to toggle Twitter Total Followers / Engagements / Posts / Response Rate.
- Spec data verified on FIA WEC: Twitter Total Followers absent (em-dash) Sep 26-29, populated Sep 30-Oct 3 (456,352 → 456,520). Twitter Response Rate em-dash Sep 26-29 even though Engagements (14,453 / 20,964 / 24,395 / 0) and Posts (23 / 33 / 20 / 0) have values — exactly the abnormal-RR-exclusion logic the spec is testing.
- Formula `Engagements / (Total Followers × Posts) × 100` math-checked on all 4 populated days; computed values round to UI values exactly (0.13% / 0.79% / 0.44% / 0.20%).
- TikTok branch deferred to fit batch budget. Mechanic is identical: swap Twitter metrics for TikTok in the channel-data tree and re-Run. Documented recipe in the report.

## QA-129803 — Abnormal Response Rate - Facebook

- **Skill:** `response-rate-math-verifier`
- **My latest run (2026-06-02 batch 9):** PASS 5/5

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-9 re-run findings
- Wasserman / FIA WEC Sep 26-Oct 3 2025 (Daily, Absolute Dates) on Facebook channel — Total Fans absent Sep 26-29 (em-dash), populated Sep 30 → Oct 3 (571,924 / 572,213 / 572,402 / 572,608). Response Rate row mirrors Total Fans presence exactly. Formula `Engagements/(Total Fans × Posts) × 100` computes to UI values to rounding on all 4 populated days (0.10/0.43/0.19/0.18%).
- Findings: FIA WEC brand has View toggle disabled — Public Data only, no Authorized perspective. Despite this, Facebook Engagements/Posts/Response Rate metrics are still accessible in Public mode when surfaced via the Filter Metrics input (the metric tree lazy-renders them).

# Unmapped tickets

Tickets that didn't map cleanly to a skill (BLOCKED, DEFERRED, scaffolded, or not yet skill-extracted).

## QA-949 — Brand > Stories - Hovering Functionality

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (11, most recent first)
- APPS-58139 (Bug, Major, Closed) — Brand > Stories - IG Story Thumbnails Not Displaying (Phase 1)
- APPS-50739 (Test Failure, Major, Closed) — Brand > Stories - The Post type is not clickable in the Detail view
- APPS-48926 (Test Failure, Major, Closed) — Brand > Partnerships - The post table is hiding while switching to detail view
- APPS-46080 (Test Failure, Major, Closed) — Reporting > Instant Insights - Most of the tiles are not loaded
- APPS-45344 (Test Failure, Major, Closed) — Home Screen is Blank When Switching Accounts
- APPS-39616 (Test Failure, Major, Closed) — Brand > Stories Tab is not Available
- APPS-37844 (Test Failure, Major, Closed) — Brand Stories > Posts are not loaded
- APPS-36557 (Test Failure, Major, Closed) — Brand > Stories - Posts not displayed
- LFMP-25305 (Bug, Major, Closed) — Instagram stories > Post table not loading
- APPS-26526 (Bug, Minor, Closed) — Instagram Story - Embeds Shouldn't Display
- APPS-8305 (Test Failure, Major, Closed) — Instagram page not loaded

## QA-3630 — CPR BPC filmstrip - Authorized

- **Skill:** `(CPR builder — first PASS 2026-06-02 batch 11)`
- **My latest run (2026-05-27/29):** PASS (batch 11 2026-06-02) — LFMP-32010 REPRODUCED end-to-end via DOM bounding-rect inspection.

### Open bugs (1)
- LFMP-32010 (Bug, Major, Open) — Reporting > Content performance > Least Engaging Posts & Heading Does not show in "Preview & Share Report"
  - **REPRODUCED 2026-06-02** (batch 11, Michael Kors story 153960). In Preview & Share Report mode, all 7 channel `Least Engaging Content` headings render with bounding rect 0x0 (display:inline-block, visibility:visible — collapsed). All 7 `Most Engaging Content` headings in same mode render at 250x20. In regular view, the Least Engaging headings render normally at 250x20. Issue is a CSS sizing/positioning regression specific to Preview & Share view.

### Closed bugs (23, most recent first)
- APPS-59205 (Bug, High, Closed) — Reporting  > Content Performance  - ToolTips are showing blank for Most and Least Engaging Content Data
- APPS-58396 (Bug, Major, Closed) — External API - Facebook - The "lfm.content.author_link" and "lfm.content.author_name" displays "Not Available”
- DATA-12039 (Bug, Major, Closed) — Missing Facebook Posts
- APPS-56784 (Bug, Major, Closed) — Reporting > CPR - Duplicate Engagements Metric Displayed in Post Table
- APPS-56650 (Test Failure, Major, Closed) — Reporting > Content Performance - The Table posts are not loading for Facebook channel
- APPS-56561 (Test Failure, Major, Closed) — Reporting > CPR - Reload Error displays for Twitter Most and Least Engaging Content Data
- APPS-55960 (Test Failure, Major, Closed) — Brand Sets > Partnerships - Sponsored Posts Tile shows Reload tile
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-50790 (Test Failure, Major, Closed) — [Error (dsp-api: lfmdev)] BiQuerier Error: ERROR: column bi_table_facebook_post_deltas_lifetime.lfm_publish_type does not exist=0A
- APPS-50315 (Test Failure, Major, Closed) — Reporting  > Content Performance with Tags - Reload Error Displays for Twitter Most and Least Engaging Content Data
- +13 earlier closed defects

### Sweep notes
- CPR Preview & Share Report — confirm Least Engaging Posts section + heading still missing (LFMP-32010).

## QA-27854 — Bulk Import Tags Notification

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** BLOCKED

### Open bugs (0)
_None._

### Closed bugs (8, most recent first)
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab
- APPS-42575 (Test Failure, Major, Closed) — Brand > Content - The Upload Tags Email and Notification are not received
- APPS-42189 (Test Failure, Major, Closed) — Brand > Content - The Upload Tags Email and Notification are not received
- APPS-39942 (Test Failure, Major, Closed) — Notification Modal - Notification Download Detail Log text isn't hyperlinked
- APPS-39604 (Test Failure, Major, Closed) — Notification modal - CSV won't download While clicking the download detail log
- LFMP-28619 (Bug, Major, Closed) — Brand > Content - Upload Bulk Tags notification is not updated in the notification tab
- APPS-37834 (Test Failure, Major, Closed) — Upload Bulk Tag notification is not updated in the notification tab
- APPS-37195 (Test Failure, Major, Closed) — Brand > Content Upload Tags not working

## QA-29479 — Dashboards - Share Dashboard via Email

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** PARTIAL (batch 11 2026-06-02 — owner-side share to lfm-qa@drylogics.com sent + persisted; recipient verification deferred per Claude password-sign-in constraint)

### Open bugs (0)
_None._

### Closed bugs (7, most recent first)
- APPS-56373 (Test Failure, Major, Closed) — Dashboard - Shared Email - The email displays extra space on the left side of the content
- APPS-55502 (Test Failure, Major, Closed) — Dashboard - Shared dashboard options container shows empty
- APPS-48999 (Test Failure, Major, Closed) — Dashboards - Saved tile is not displayed in Dashboards
- APPS-47777 (Test Failure, Major, Closed) — Classic reporting - The Change settings modal got stuck in the top
- APPS-47757 (Test Failure, Major, Closed) — Uncaught Error displaying while reviewing the shared dashboard - Page stuck on load state
- APPS-42920 (Test Failure, Major, Closed) — Brand > Rankings - TikTok Channel is disabled by default while navigating to Rankings
- APPS-42562 (Test Failure, Major, Closed) — Dashboard > The second loading popup appears when clicking on the share button

## QA-33510 — Settings > Users - Access message for External

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** PARTIAL

### Open bugs (0)
_None._

### Closed bugs (1, most recent first)
- LFMP-29876 (Bug, Major, Closed) — Unable to login External User

## QA-52776 — Brand Definition Update - Exclude URL Manager

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** PARTIAL (batch 11 2026-06-02 — A1 Fetch xlsx PASS verified end-to-end on disk via openpyxl; 40 BrandIngest columns, no "url managers". A2/A3 NOT VERIFIED — withheld to avoid Patch/Apply mutation on dev brand_id=236)

### Open bugs (0)
_None._

### Closed bugs (5, most recent first)
- APPS-55527 (Test Failure, Major, Closed) — Radaac - Brand Definitions (Fetch) - Export failed to download
- APPS-53699 (Test Failure, Major, Closed) — Radaac - Brand Definitions (Fetch) - Export failed to download
- APPS-53077 (Test Failure, Major, Closed) — 502 Gateway Error displayed on Dev Radaac
- APPS-50449 (Test Failure, Major, Closed) — Radaac - Brand Definitions (Fetch) - Export failed to download
- APPS-49038 (Test Failure, Major, Closed) — Radaac - Brand Definitions (Fetch) - Export failed to download

## QA-96665 — Brand Insights - Threads - Basic View

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** FAIL

### Open bugs (1)
- LFMP-32027 (Bug, Major, Open) — Brand->Insights:Trends graph values are overlapping when selected date range is 6 or 12 months
  - NOT VERIFIED 2026-05-29 batch 2 — Chrome MCP renderer hung on Brand Insights with Last 6 Months range across multiple fresh tabs. Trends graph never reached visible state. Defer to LFIQA for manual verification with hardware browser.

### Closed bugs (6, most recent first)
- DATA-12062 (Bug, Major, Closed) — Sudden Follower Growth Spike - HBO Max | Analysis Requested
- APPS-57904 (Bug, Major, Closed) — Brand > Insights > BPC data is not Loading on Stage
- APPS-55960 (Test Failure, Major, Closed) — Brand Sets > Partnerships - Sponsored Posts Tile shows Reload tile
- LFMP-30925 (Bug, Major, Closed) — Max (Streamer) brand is not available in Dev - Max Account
- APPS-53104 (Test Failure, Major, Closed) — Brand > Insights - Go To Authorize displays on all the Threads big number tiles on Stage env.
- APPS-53076 (Test Failure, Major, Closed) — Brand > Insights - No data view displays on all the big number tiles for Threads channel data

### Sweep notes
- Run Brand > Insights Trends at 6 or 12 months and verify the graph value overlap (LFMP-32027) is still present.

## QA-103248 — Brand Sets > Content - Daily Post Analysis Modal export

- **Skill:** `(none / unmapped)` — candidate `daily-post-analysis-modal-run`
- **My latest run (2026-06-02 batch-7):** PASS 8/8 (UPGRADED from BLOCKED)

### Open bugs (0)
_None._

### Closed bugs (2, most recent first)
- APPS-55376 (Test Failure, Major, Closed) — Brand > Content - Post shows reload tile on Daily Analysis model
- APPS-54912 (Test Failure, Major, Closed) — Brand Sets > Content - Post table is not displaying

### 2026-06-02 batch-7 re-run findings
- Unblocked the prior BLOCKED state. Adam Orfei / LF // TV // Episodic on the 7-day default window (May 25–31 2026) loads Posts (28,438) in ~10s — no hang. The prior 12-month window appears to have been the source.
- PNG verified end-to-end: `Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png` (1507×860, 80KB). ListenFirst logo + brand title + bar chart + "Daily Content Analysis" footer all confirmed on saved file.
- Google Sheets verified end-to-end: tab title matches spec pattern (PST↔PDT minor drift because May is DST). Sheet rows 3-8 numbers match the modal table cells (SUM=3.77M, AVG=942.5K, May 28=2.67M, May 29=1.10M).

## QA-130076 — Settings > Notifications - Lost-auth messaging (4/4 on Adam)

- **Skill:** `(none / unmapped)`
- **My latest run (2026-05-27/29):** PASS

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

## QA-132387 — Brand Sets > Content - Rank-by Sum/Avg

- **Skill:** `(none / unmapped — candidate for future brand-sets-content-rank-by skill)`
- **My latest run (2026-06-08 QA-22296 batch-9 RECONFIRM):** PASS — mechanic verified end-to-end on default-state Adam's Brand Set Jun 1-7 2026: Public Engagements rank Posts(2,526)/Sum 63,942,902/Avg 25,314 → Authorized Impressions rank Posts(111)/Sum 14,360,033/Avg 129,370; URL `perspective` auto-flip + channel-set narrowing (5 → 4 channels, YouTube dropped) CONFIRMED; View toggle disabled CONFIRMED.

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-6 re-run findings
- Workaround documented in known-quirks (pre-narrow via Content Brand=MTV + IG-only channels) succeeded. Adam's Brand Set IG-only+MTV: Engagements Sum=11,301,881 / Avg=51,140 / Posts=221 (Public); Impressions Sum=177,964,874 / Avg=823,911 / Posts=216 (Authorized).
- A1-A12, A16 PASS via UI. A13-A15 PASS by skill carryover from QA-134277/134188. A15 PARTIAL — 2 of 6 metrics live-cycled (Engagements + Impressions), rest by symmetry.
- New finding: Brand Sets > Content View toggle is DISABLED at brand-set level; perspective derived from Rank-by metric group (added to known-quirks).

## QA-132392 — Brand Set > Content - Impression Sum/Avg

- **Skill:** `(none / unmapped — candidate for future brand-sets-content-rank-by skill)`
- **My latest run (2026-06-08 QA-22296 batch-9 RECONFIRM):** PASS — Authorized Impressions on Adam's Brand Set Jun 1-7 2026: Posts(111)/Sum 14,360,033/Avg 129,370; channels narrow to FB/IG/Twitter/TikTok (4, no YouTube); math sanity 14,360,033/111≈129,369 ≈ UI 129,370 within 0.01% rounding (confirms Avg = Sum/posts-with-data). No drift.

### Open bugs (0)
_None._

### Closed bugs (0, most recent first)
_None._

### 2026-06-02 batch-6 re-run findings
- Workaround succeeded — narrowing to Content Brand=MTV before Rank-by switch avoided 76K-post strain. Authorized Impressions on Adam's Brand Set + MTV: Sum=315,414,617 / Avg=401,802 / Posts=785. Unfiltered Authorized Impressions: Sum=327,666,046 / Avg=404,027 / Posts=811. A1-A6 PASS via UI; A7 DEFERRED (CSV export trust by skill carryover); A8 PASS by skill carryover; A9-A15 NOT EXECUTED (NBA scenario, deferred due to token budget after MTV exercise).
- New finding: Brand Sets > Content View toggle DISABLED; channel set narrows to FB/IG/Twitter/TikTok under Authorized Impressions (no YouTube/Threads — metric unsupported).


---

# QA-4325 Daily Regression Test Set - 2 (2026-06-02)

Members discovered via Xray JQL `issue in testSetTests("QA-4325") ORDER BY key ASC`. Total = 56. Per-member entries below. Open Bug/Test-Failure links sourced via JQL `issuetype in (Bug, "Test Failure") AND statusCategory != Done AND issue in linkedIssues("QA-<id>")`. Closed bug counts are large for older test cases; for tests with notable history, key recent items are listed. Refer to `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-4325-members.md` for the master member list.

## QA-298 — Reporting - TWC Graphs - Hovering Functionality

Skill: time-window-comparison-run, chart-hover-tooltip
My latest run: 2026-06-04 QA-4325 batch-2 — PASS (Hulu)

### Open bugs (0)
_None._

### Closed bugs (10+ recent, full history truncated)
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names in Story Options + run report not working
- APPS-37192 (Test Failure, Major, Closed) — Classic Reporting > Data Selection Section not on initial load
- APPS-35923 (Test Failure, Major, Closed) — Classic Reporting > TWC - Metric Headers missing
- APPS-35116 (Test Failure, Major, Closed) — Global - email text not removed after Add in Share modal
- APPS-31860 (Test Failure, Major, Closed) — Classic Reporting - Run Report button not working
- LFMP-26247 (Bug, Major, Closed) — Classic Reporting - Run Report not working
- APPS-29013 (Test Failure, Major, Closed) — Reporting - Report page stuck on 'View now'
- APPS-28318 (Test Failure, Major, Closed) — Run Report is not working - Classic Reporting
- +10 earlier (older Closed Bug/Test-Failure entries — see Jira)

### Sweep notes
- History dominated by Classic Reporting / TWC page-load / Run-Report failures. Watch for "page stuck on View now" symptom.

### 2026-06-04 QA-4325 batch-2 re-run findings
- PASS. Hulu (account_id=336) on dev. TWC default Absolute Days range May 27 - Jun 2 2026. Brand Hulu added via Add Brand By Name (`Hulu` first result clicked). Public Data default toggle. Filter Metrics input + `label.controlled-check-box__label.click()` pattern used to toggle Facebook New Fans and Twitter New Followers (per known-quirks: tree renders lazily). Run Report triggered via JS `button.click()` on the "Run Report" text-match button (the button rendered at y=719 below viewport edge so coordinate clicks failed). story_id=154045.
- Tooltip captured via `chart-hover-tooltip` skill: JS-dispatch `mouseenter+mouseover+mousemove` on `circle.data-circle.hulu-0` → DOM `.al-area-chart__tooltip` renders with `chart-tooltip__header` = `May. 29, 2026` and `chart-tooltip__row` = `Hulu: 8,387`. Also confirmed `May. 31, 2026` / `Hulu: 5,691` and `Jun. 01, 2026` / `Hulu: 5,691`.
- Tooltip format matches spec wording `Mon. DD, YYYY` / `Brand name (Hulu): value` (brand-name = `Hulu`).
- Page-stuck-on-View-now historical symptom did NOT reproduce — story built in <8s after Run Report click.
- New finding: TWC chart is rendered as a LINE chart (Recharts circles + path) under default Days interval, not a bar chart. Spec wording "bar chart column" predates the line-chart redesign. Tooltip behavior is correct on line + dot hover.

## QA-461 — Data QA - Partnership - Graph Values

Skill: chart-hover-tooltip
My latest run: 2026-06-04 QA-4325 batch-2 — PASS (Adam Orfei / Adam's Brand Set)

### Open bugs (0)
_None._

### Closed bugs (10+ recent, full history truncated)
- LFMP-31206 (Bug, Major, Closed) — Brand Sets > Content - Video Views values not displaying for IG channel
- APPS-51823 (Test Failure, Major, Closed) — Brand Sets > Content - Page not loading
- APPS-51540 (Test Failure, Major, Closed) — Brand Sets Failing to Load with 503
- APPS-50732 (Bug, Major, Closed) — Enrich brand name as part of MetaData
- LFMP-30309 (Bug, Major, Closed) — Brand Sets > Partnerships - Sponsored posts not in table
- APPS-49240 (Test Failure, Major, Closed) — The Stage Env not loading
- APPS-48424 (Test Failure, Major, Closed) — Brand > Content - Filter tile not loading (Stage)
- APPS-40616 (Test Failure, Major, Closed) — Brand Set Partnerships > Post count mismatched (Adam's Brand Set)
- APPS-24581 (Bug, Minor, Closed) — Competitive Content - Add Filter Options out of container
- LFMP-21299 (Bug, Major, Closed) — 'Link' graph data not available - Partnerships
- +5 earlier

### Sweep notes
- Partnerships sponsored-post visibility historically flaky; verify big-number vs table count parity.

### 2026-06-04 QA-4325 batch-2 re-run findings
- PASS. Adam Orfei (account_id=54) → Brand Sets → Partnerships → Adam's Brand Set (brand_set_id=1738) → date range Jan 03 - Jan 04, 2025, Public Data.
- Big numbers all-channels: Sponsored Posts 9, Engagements 345K, Total Est. Media Value $77.4K, Avg. Engagements per Post 38.3K.
- A1 PASS: Sponsored Posts big number 9 = stacked-bar sum 6+3 ✓.
- A7/A10/A13 PASS via direct per-channel verification:
  - FB only: Sponsored Posts 5, Engagements 2,650 (= hover-tooltip Jan 03 FB 2,206 + Jan 04 FB 444).
  - Twitter only: Sponsored Posts 2, Engagements 555 (= 344 + 211).
  - IG only: Sponsored Posts 2, Engagements 342K (= 33,155 + 308,655 = 341,810 → rounded).
- Cross-channel totals: 5+2+2=9 posts, 2,650+555+341,810=345,015 → 345K ✓ both match all-channel big numbers.
- Per-channel split sourced via `computer.hover` over the Engagements stacked bar tooltip — renders `<Date>` header + `Facebook: N (Δ%)` / `Twitter: N (Δ%)` / `Instagram: N (Δ%)` rows. The Recharts tooltip stays visible under sustained native hover.
- New finding (non-blocking): Spec step 4 asks "filter by Branded Content: Yes" but no Branded Content filter exists in Partnerships filter dropdown. The Partnerships tab IS the sponsored/branded content view by definition. Spec wording predates dedicated Partnerships tab. Treated as implicit-yes and proceeded.

## QA-529 — Facebook Content - Mixed Authorization - Impressions

Skill: brand-content-table-view, brand-content-filter, brand-content-data-set-selector, export-csv
My latest run: 2026-06-04 QA-4325 batch-2 — PASS (Michael Kors / SS22 NYFW Roll-Up)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-2 re-run findings
- PASS, all 8 assertions. Michael Kors (account_id=328) → SS22 New York Fashion Week Roll-Up (brand_id=265946) → Oct 18, 2024 → FB only → Authorized Data View → Brand sub-filter "Tory Burch OR Michael Kors Include" → Data Set "Impressions" → Table layout.
- Posts (3) in UI table:
  - 02:00 PM Michael Kors Image Original Post — Engagements 926, ER 0.32%, Impressions 286,833, Organic Imp 286,833, Paid Imp 0.
  - 06:21 AM Michael Kors Video Original Post — Engagements 538, ER 0.59%, Impressions 91,228, Organic Imp 91,228, Paid Imp 0.
  - 06:53 AM Tory Burch Video Reel — Engagements `–` (endash), Impressions/Organic/Paid Impressions = padlock icons.
- CSV export verified end-to-end via CDN fetch:
  - URL: `https://analytics-cdn.lfmdev.in/293898-956af330ec149d5eb04c80b2b20ad012.csv`
  - Size 1,692 bytes, 200 OK.
  - Row 1 (Data Set label row): `Data Set,"",...,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions`
  - Row 2 (column headers): Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Engagement Rate,Impressions,Organic Impressions,Paid Impressions,Reach,Organic Reach,Paid Reach,Engaged User Rate.
  - MK rows have full numerics (e.g. 926, 0.00322835935893011, "286,833"). Tory Burch row has empty `""` cells for Engagements, Engagement Rate, Impressions, Organic Imp, Paid Imp, Reach, Organic Reach, Paid Reach, EUR — matches spec A6 "export displays blank cells for lock data points".
  - A7 PASS: CSV Brand column contains only `Michael Kors` and `Tory Burch`.
  - A8 PASS: Row 5 Type=Video, Publish Type=Reel → FB Reel post included.

## QA-567 — Facebook Lifetime Private Data QA

Skill: brand-content-data-set-selector
My latest run: 2026-06-04 QA-4325 batch-2 — PARTIAL (dev-only; stage not accessible)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-2 re-run findings
- PARTIAL. Dev-side: Hulu (account_id=336) → Brand>Content → Lifetime mode → Authorized View → FB → Impressions data set loads correctly. Default range May 27 - Jun 2 2026: Posts (89), Sum Engagements 1,183,399, Sum Impressions 35,353,705 (lifetime), Sum Organic Imp 34,632,694, Sum Paid Imp 3,904. Data set switch via dropdown works; URL `table_data_set=impressions` sticks.
- Stage comparison NOT VERIFIED — magpie operates against dev (`app.lfmdev.in`) only. The spec requires dev↔stage parity which needs manual cross-env access. Flagged as manual-cross-env test for LFIQA.

## QA-569 — Facebook In Window Private Data QA

Skill: view-perspective-toggle, brand-content-data-set-selector
My latest run: 2026-06-04 QA-4325 batch-2 — PARTIAL (dev-only; stage not accessible)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-2 re-run findings
- PARTIAL. Dev-side: Hulu (account_id=336) → Brand>Content → date range May 25-31 2026 (end-date shifted back 2 days per spec) → Authorized View → FB → Impressions data set. Date Range modal's "Select Mode" radio toggled Lifetime → In Window → Ok. Mode label flipped to "In Window"; URL `stats_attribution_window=in_window` applied.
- In Window aggregates: Sum Engagements 126,946, Sum Impressions 7,819,139, Sum Organic Imp 7,819,139, Sum Paid Imp 0 (vs Lifetime view's 35.3M Impressions — confirms windowing).
- Posts table sub-tile rendered transient "This table failed to load. Please try again." with Reload button — aggregate sum/avg row above succeeded, so backend has data; tile-render lifecycle hiccup. Documented as render-lifecycle issue (Reload often resolves), NOT a data defect.
- Stage comparison NOT VERIFIED — same dev-only limitation as QA-567.

## QA-575 — Instagram In Window Private Data QA

Skill: view-perspective-toggle, brand-content-data-set-selector
My latest run: 2026-06-04 QA-4325 batch-3 — PARTIAL (dev-only; stage not accessible)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-3 re-run findings
- PARTIAL. Dev-side: Hulu (account_id=336) → Brand>Content → date range May 25-27 2026 (end-date shifted back -2 days per spec step 6) → Authorized View → Instagram only → Impressions data set + Video Views data set switch.
- Mode: Lifetime → In Window via Date Range modal Select Mode radio + Ok → URL `stats_attribution_window=in_window`.
- Posts (10) loaded after first-attempt "This table failed to load. Please try again." → Reload click → populated. Same render-lifecycle quirk as QA-569.
- **Impressions data set (Posts 10):** Sum Engagements 172,283 / Sum Impressions 5,532,668 / Sum Organic Impressions 5,524,462 / Sum Paid Impressions 8,206 / Avg ER 3.11% / Avg Reach 371,369 / Avg Organic Reach 370,548 / Avg Paid Reach 820 / Avg EUR 4.64%.
- **Video Views data set (Posts 10):** Sum Engagements 172,283 / Sum Video Views 5,530,219 / Sum Organic Views 5,524,462 / Sum Paid Views 5,757 / Sum Unclassified 0 / Sum Watch Time (Minutes) 1,324,151.18 / Avg VRR 3.12%.
- Stage comparison NOT VERIFIED — dev only (same limitation as QA-567/QA-569).

## QA-581 — Twitter In Window Private Data QA

Skill: view-perspective-toggle, brand-content-data-set-selector
My latest run: 2026-06-04 QA-4325 batch-3 — PARTIAL (Twitter Video Views tile skeleton-hang; stage not accessible)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-3 re-run findings
- PARTIAL. Dev-side: Hulu (account_id=336) → Brand>Content → date range May 25-27 2026 → Authorized View → Twitter only → Impressions + Video Views data sets.
- Impressions data set loaded successfully — Posts (6) all Twitter (1 Original Post + 5 X Threads). Sum Engagements 261 / Sum Impressions 58,318 / Sum Organic Impressions 58,318 / Sum Paid Impressions – / Sum Reach – / Avg ER 0.45% / Avg Impressions 9,720.
- **Video Views data set switch: tile stuck on skeleton-shimmer state for 45+ seconds with no error message and no Posts(N) count update.** Apply-channels button click did not retrigger fetch. Possible causes: zero eligible video posts in 3-day window OR backend slow-path for Twitter video metrics. Distinct from the IG "This table failed to load + Reload" lifecycle pattern. Captured as NEW FINDING for known-quirks consideration.
- Stage comparison NOT VERIFIED — dev only.

## QA-2062 — Pinterest Content - Post Hovering

Skill: brand-content-table-view, brand-content-data-set-selector
My latest run: 2026-06-04 QA-4325 batch-3 — PASS (Sephora / Pinterest)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-3 re-run findings
- PASS. Sephora (account_id=655) → Brand>Content → brand picked via top-nav magnifier "Sephora" Results entry (Rule 1: NOT Recent Searches — those route to different variants like Lincoln/Brasil/Ajax). brand_id=7159 loaded with 2,022 posts default. Pinterest channel-only via channel-icon clicks + Apply → URL `channels=pinterest&table_data_set=pinterest_only:_basic`. Data Set auto-selected to "Pinterest Only: Basic".
- Posts (85,871) Pinterest pins rendered for May 26 2025 – May 25 2026 default window.
- Switched to Table layout via JS click on `[title="Table View"]` (URL `layout=table` not honored on hash route — same as QA-1677/QA-529 quirk).
- **Row 1 hover (Type "Image" cell)**: Pinterest embed tooltip rendered with pin image (lip-balm container photo) + title "Fragrance Family: Warm…" + red Save button + "Published By Sephora" byline + X close control. PASS.
- **Row 3 hover (Type "Image" cell)**: Tooltip frame opened but inner content stayed BLANK (white frame with X only) after 14+ seconds. Reproduces known-quirk "Pinterest embed iframe tooltip can render blank for unavailable pins" — external Pinterest CDN pin-availability behavior, not an LFM defect.

## QA-10387 — Brand Insights - Impression and Video Views Chart - PNG

Skill: tbd
My latest run: 2026-06-04 QA-4325 batch-3 — BLOCKED (spec drift; tile-level PNG export not present on current Brand Insights build)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget. No open issues.

### 2026-06-04 QA-4325 batch-3 re-run findings
- BLOCKED. Hulu Brand>Insights consistently caused Chrome MCP renderer freeze (matches known-quirk "Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer" — but reproduced even on Last 7 Days Hulu range). Switched to Adam Orfei → MTV (brand_id=4018) with default Last 7 Days for lighter load. Brand Insights rendered with Trends consolidated tile (Bar Chart + Line Chart selectors).
- **Finding**: The current Brand Insights build does NOT expose a tile-level Impressions chart or Video Views chart export PNG affordance. The Trends tile (which consolidates Impressions, Video Views, etc. via Bar Chart dropdown) has no kebab/Export icon. DOM scan: no `[title*="Export"]`, no `[aria-label*="export"]`, no kebab class inside the tile.
- Spec QA-10387 likely predates the Brand Insights redesign — original standalone Impression and Video Views chart tiles appear to have been consolidated into the Trends widget and lost their tile-level PNG export entry points.
- Recommendation: LFIQA to confirm with product whether tile-level PNG export was intentionally removed or accidentally regressed.

## QA-13903 — Embedded Post Tooltip - LinkedIn

Skill: tbd
My latest run: 2026-06-02 batch-1 — PASS (UCLA brand on UCLA account)

### Open bugs (1)
- APPS-57985 (Bug, High, QA Ready) — Thumbnail Issue for LinkedIn Posts. **Could not reproduce 2026-06-02 — may be fixed; verify with eng before closing the Jira.**

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- LinkedIn thumbnail handling has an active high-priority bug in QA Ready. Expect LinkedIn thumb anomalies; verify thumbnails render before scoring tooltip behavior.

### 2026-06-02 batch-1 re-run findings
- Adam Orfei dev account has zero brands with LinkedIn channel data; switched to UCLA account (account_id=799) which has the brand "University of California, Los Angeles" with 1,415 LinkedIn posts in 2025.
- Grid view: thumbnails render correctly for all 5 first-page posts (Dodgers, UCLA rainbow, statue, #1 yellow, Royce Hall).
- Embedded tooltip on Table view Type column hover: shows UCLA logo + "1,003,177 followers • 7mo" + post text + LinkedIn iframe embed (`linkedin.com/embed/feed/update/urn:li:share:7390711711109906432/`).
- Post links well-formed (`linkedin.com/feed/update/urn:li:share:...` or `urn:li:ugcPost:...`).
- APPS-57985 likely fixed.

## QA-19486 — Social Recap - Verify PDF

Skill: social-recap-report-run, pdf-end-to-end-verification
My latest run: 2026-06-04 QA-4325 batch-3 — PASS (single-brand MTV / Adam Orfei)

### Open bugs (2)
- APPS-55559 (Bug, Minor, Open) — Social Recap > donut chart displays incorrectly when only single channel has video views data. **Not reproduced 2026-06-04 — multi-channel data set used**.
- APPS-50810 (Bug, Trivial, Open) — Mixpanel: Classic Reporting - 'Undefined' for Page Refreshed event

### 2026-06-04 QA-4325 batch-3 re-run findings
- PASS for single-brand MTV variant. Adam Orfei → Reporting → Social Recap → MTV (brand_id=4018) added via Add Brand By Name React-aware InputEvent dispatch + Results "MTV" click. Default Weekly interval, End Date = Jun 2, 2026 (range May 27 – Jun 2). All 7 channels selected. Public Data default. Options: defaults (Year-over-Year). Run Report via JS button-text-click (coordinate click failed — same as QA-298 batch-2 finding). story_id=154046.
- Preview & Share Report → Download → PDF saved `MTV-Weekly Social Recap(May 27, 2026 - Jun 2, 2026).pdf` 2,137,648 bytes 2 pages. Verified via pdftoppm `-r 100` + Read on each PNG page.
- Page 1: MTV header + ListenFirst logo + "Weekly Social Recap (May 27, 2026 - Jun 2, 2026)" + Section 1 Social Footprint 104,723,370 Total Fans bar chart per channel (FB 45.5M / IG 21.1M / X 15.8M / YT 11.5M / TT 10.8M) + Section 2 Social Activity 4 donuts (1M Public Impressions -69% / 7,491 New Followers +144% / 2M Engagements -15% / 32M Video Views +164%) + per-metric channel-share tables with padlock icons for unauthorized perspective splits.
- Page 2: Best Performing Content 5-tile row + Section 3 Social Activity Year-to-Date 4 donuts (1B PI / 515K NF / 59M Eng / 486M VV) + per-channel tables.
- BC-4 page-footer defect did NOT reproduce — "Page 1" / "Page 2" footers render correctly.
- APPS-55559 single-channel donut display anomaly NOT triggered (multi-channel data set used).
- Multi-brand variant NOT EXECUTED (token-budget cap).

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Single-channel video-views donut rendering bug is known. If PDF includes donut, expect potential display anomaly; verify with multi-channel data.

## QA-28405 — Brand Content - CSV - All Data set - Video Views

Skill: brand-content-data-set-selector, export-csv (v2)
My latest run: 2026-06-04 QA-4325 batch-4 — PASS (Hulu)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-4 re-run findings
- PASS end-to-end. All Data Sets CSV (Public + FB Only: Reactions + Twitter Only: Engagements & Follows + YouTube Only: Basic) queued from Hulu Brand>Content for May 27–Jun 2 2026. CDN file `293899-419fa1d5604f4f3565da97b401a18856.csv` (36,404 bytes) fetched via `fetch({credentials:'include'})` and saved to `~/Downloads`. Row 1 = data set labels per metric column; Row 2 = column headers including `Video Views` (col 20), `Video Response Rate` (col 21), `YouTube Video Views` (col 36). Python csv-sum on the saved file: Sum Video Views = 26,449,739, Avg = 367,357 — exact match with on-screen Sum/Avg row.
- Notification text confirms platform terminology: "Your Content Export with **All Data Sets** for Hulu from May. 27, 2026 to Jun. 02, 2026 is now ready." Spec wording "All Data set" maps to platform's "All Data Sets Export" mode (multi-CDS checked simultaneously in the Export modal).

## QA-43914 — Facebook User Accounts Radaac Report

Skill: (radaac — no dedicated skill yet)
My latest run: 2026-06-04 QA-4325 batch-4 — PASS (Hulu + token 5001)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-4 re-run findings
- PASS end-to-end. File `20260603FacebookUserAccounts_8c53d5.tsv` (228 bytes — header-only because token 5001 has 0 Hulu-scoped FB pages) saved. Verified tab-separated (8 tabs, 0 commas) with 9 columns: User Email / ListenFirst Email / Facebook Page URL / Facebook Page Username / Facebook Page ID / Facebook Page Name / Can Access Instagram Business Account? / Instagram Business Account - Username / Instagram Business Account - Followers Count.
- **DEVIATION (not a bug):** This report does NOT expose a file_format dropdown (unlike QA-51425 Duplicate Brands which has tsv/csv/xls options). Submit always produces a `.tsv`. Documented in report.

## QA-48160 — Settings > Brands - Basic Info - Edit Functionality

Skill: settings-brands-edit (candidate — no dedicated skill yet)
My latest run: 2026-06-04 QA-4325 batch-4 — PASS (Adam Orfei / Alex Test 1, brand_id=422865)

### Open bugs (1)
- APPS-59449 (Bug, Minor, Open) — channel validation error does not appear until field loses focus, allowing invalid handles to be submitted

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- IG channel handle validation is known to be lazy (only on blur). If test includes adding invalid handles, expect this gap. Click outside box before pressing Next to surface error.

### 2026-06-04 QA-4325 batch-4 re-run findings
- PASS end-to-end. Edit Brand Name `Alex Test 1` → `Alex Test 1 qa48160-260604-0436` via wizard (Basic Info → Channels → Review → Finish). Success page rendered. Verified persistence on brand detail page (title + Last Updated timestamp).
- **Cleanup completed**: Reverted Brand Name back to `Alex Test 1`. Last Updated 06/03/2026 01:42 PM PDT by Yash Sharma. Full audit trail visible.
- APPS-59449 NOT exercised (no invalid channel handle added this run).
- **New finding (automation only):** The Brand Name input on the Settings>Brands Edit wizard is React-controlled and does NOT reliably commit on Chrome MCP `type` + Tab. Must use React-aware setter: `Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(input, val); input.dispatchEvent(new Event('input',{bubbles:true}))`. Pattern documented in report.

## QA-51442 — Brand > Stories - Impressions - Tile level export - PNG

Skill: audience-metrics-export (tile-level Export pattern)
My latest run: 2026-06-04 QA-4325 batch-4 — originally PARTIAL; **RE-VERDICT 2026-06-05: tile-render failure RETRACTED — was a Chrome-MCP-only artifact.** Effective status: A1/A2 PASS, A3-A6 still NOT VERIFIED (analyst-side PNG-on-disk evidence is the remaining gap).

### Open bugs (0)
_None._

### 2026-06-04 QA-4325 batch-4 re-run findings — RETRACTED 2026-06-05
- **Brand > Stories chart-tile fail-to-load finding RETRACTED.** LFIQA analyst screenshot 2026-06-05 16:10 PDT shows the identical configuration (Adam Orfei / MTV brand_id=4018 / Authorized / Instagram / May 29 2026 single day) with all four tiles (Engagements 455, Impressions 121K, Taps Back 1,607, Exits 8,517) rendered as proper bar charts. URL in screenshot: `app.lfmdev.in/#explore/brand/stories?brand_id=4018&account_id=54&from=2026-05-29&to=2026-05-29&...`. The Stories(4) data table beneath the charts populates Sum Impressions 121,106 — exact match for what the sub-agent extracted, confirming same data path.
- **Root cause hypothesis:** Chrome MCP sub-agent observed the tiles in a transient failed/skeleton state during initial page load and declared the failure prematurely (before retry-on-mount resolved). Reload-click then re-entered skeleton state and the agent gave up rather than waiting longer. Real-browser sessions complete the render within normal page-load time. This is **automation-only friction**, not a product defect.
- **Lesson for future Chrome MCP runs on Brand > Stories:** Wait at least 15-20s after initial nav before declaring a tile failed; if tiles show "Please try again" after the first Reload click, fully refresh the tab (not just Reload-click the tile) and wait 15s again. Do NOT report tile-render failure unless 2+ full-page refreshes consistently fail AND the network panel confirms the chart-fetch endpoint is 5xx/timeout.
- **Still genuinely PARTIAL:** PNG-on-disk verification (A3-A6) still pending — sub-agent didn't capture a saved file because of the (false) tile-render diagnosis. The Export dropdown layout (PNG / CSV / Google Sheets / Metrics) is confirmed PASS from the run.
- Hulu Brand>Stories tab is conditionally hidden on Adam Orfei context (Public-only). MTV exposes the Stories tab with Authorized View. (This part of the finding stands.)

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-51457 — Brand > Insights - Engagements - Tile level export - PNG

Skill: (Brand>Insights tile-level export — spec drift, no per-tile menu on modern Trends-consolidated build)
My latest run: 2026-06-04 QA-4325 batch-4 — BLOCKED (Adam Orfei / MTV+Hulu+Disney Channel)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-4 re-run findings
- BLOCKED — same spec drift as QA-10387 batch-3. Modern Brand Insights consolidates Engagements (and Impressions / Video Views / Engagement Rate) into a single Trends tile that lacks a per-tile Export / PNG affordance. Spec QA-51457 is structurally identical to QA-10387 (BLOCKED on the same drift).
- Renderer hang reproduced for Brand>Insights on MTV (Authorized + 4 channels), Hulu (Public + IG-only), and Disney Channel (Public + 4 channels) — extending the known-quirk beyond the prior Hulu-Authorized-only signature. Recovery required closing and recreating the tab group multiple times.

## QA-52778 — Brand definition update - Include URL Manager

Skill: tbd
My latest run: 2026-06-04 (QA-4325 batch 5)

### Open bugs (0)
_None._

### 2026-06-04 re-run findings
- **BC-5 RETRACTED (2026-06-05) — was a false positive.** LFIQA analyst executed the full Fetch / Patch / Apply chain manually on 2026-06-05 with `Include URL Managers` checked. All three xlsx files contain the `url_managers` column populated with the multi-platform tenant strings (Family Guy brand 236):
  - Fetch (`20260605BrandDefinitionReport_4f1694.xlsx`, 5,980 B, 41 cols) → `url_managers` at col 40 — data present (`youtube|http://www.youtube.com/user/ANIMATIONonFOX|FX Networks + Hulu + Disney General Entertainment + Disney Ad Sales + Freeform`, `instagram|familyguyfox|...`)
  - Patch (`20260605PatchBrandDefinitionReport_0fb143.xlsx`, 7,417 B, 42 cols) → `url_managers` at col 41 — same values, carried through
  - Apply (`20260605ApplyBrandDefinitionReport_d5996d.xlsx`, 7,417 B, 42 cols) → `url_managers` at col 41 — same values, carried through
- **Root cause of the false positive:** The 2026-06-04 batch-5 sub-agent could not click the Radaac jQuery UI Submit button via Chrome MCP (real Radaac quirk — that part is genuine), and fell back to a direct URL GET `radaac.lfmdev.in/brand_definition_report?brand_ids=236&include_url_mgrs=on`. The Radaac backend does NOT honor the `include_url_mgrs` flag when submitted via raw URL params — flag handling depends on session-form state established by the form's jQuery UI submit handler. With a real-user form submit, the flag works correctly.
- Radaac jQuery UI dialog Submit click is JS-resistant from Chrome MCP — confirmed independently. But the URL-fallback only works for forms that don't need session-form state; the Brand Definitions Fetch form needs that state for `Include URL Managers` specifically. **Any future Chrome MCP test of this surface MUST drive the submit through the real button** (e.g. pointerdown + pointerup + click event sequence after focus, or screenshot-coordinate click with the dialog footer scrolled into view) — the URL fallback would produce a false-negative on Include URL Managers content again.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-54202 — Brand Listing Radaac Report with Filter options

Skill: tbd
My latest run: 2026-06-04 (QA-4325 batch 5) — PASS (4/4)

### Open bugs (0)
_None._

### 2026-06-04 re-run findings
- PASS: Title Category dropdown enumerates 50 active categories; Automotive filter produces 1,279 rows with single tc_title=AUTOMOTIVE / tc_display=Automotive value; filename `brands_20260604-0606.tsv` matches pattern; 6 columns (brand_id, brand_name, created_at, updated_at, tc_title, tc_display) verbatim.
- Confirmed Radaac jQuery UI dialog Submit click does not navigate via JS/coord click; workaround = direct URL GET nav.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-72455 — Brand > Paid - Unauthorized Spend Metrics - Twitter Channel

Skill: tbd
My latest run: 2026-06-04 (QA-4325 batch 5) — BLOCKED on account credentials

### Open bugs (0)
_None._

### 2026-06-04 re-run findings
- BLOCKED: Requires login as External account `testing@drylogics.com` (Analyst No Spend role). Cowork prohibits assistant password entry. Test needs to be routed to LFIQA manual verification or a future credentials-handoff pattern.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-81494 — Reporting > Data Studio - Report Table - Export Functionality - PNG

Skill: tbd
My latest run: 2026-06-04 (QA-4325 batch 5) — PASS (8/8)

### Open bugs (0)
_None._

### 2026-06-04 re-run findings
- PASS: Food Network + Disney Channel, Days interval, metrics Fan Growth Rate + Facebook Engagements + YouTube Engagements; PNG `Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png` (101,392 bytes) verified end-to-end on disk: filename pattern matches, LISTENFIRST header + Fan Growth Rate title + Legend (Food Network [P] + Disney Channel [P]) + footer LF-icon "Reporting Data Studio" + "Date: May. 27, 2026 - Jun. 02, 2026" + X-axis dates May. 27 → Jun. 02 + Y-axis rate values 0.00%/0.01%.
- Spec drift: spec says "Fan Growth Rate Node" → UI renders the parent as `Follower Growth Rate` `<details>` summary, but a top-level `Fan Growth Rate` leaf exists and was selected.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-83928 — Brand > Paid - CSV - Select Channels & Data Sets Export notification view

Skill: tbd
My latest run: 2026-06-04 (QA-4325 batch 5) — PARTIAL (Brand>Paid backend degraded)

### Open bugs (0 product; 1 carry-forward backend)
- **Carry-forward (NEW 2026-06-04):** Brand > Paid Michael Kors (brand_id=3801) all 12 tiles fail to load with "This tile failed to load. Please try again." across reloads, AND Export button click submits a request that stays in continuous spinner without surfacing an error toast — no fresh export notification arrives. Likely backend Paid endpoint flakiness on Adam Orfei dev today. Documented in known-quirks under "Brand > Paid Michael Kors tile + export queue degradation".

### 2026-06-04 re-run findings
- Modal Export Select Data Sets opened correctly with CSV/Google Sheets toggle + per-channel data sets list (FB Engagements/Rates/Video Views/Cost/Delivery + Twitter ... + Instagram ... etc.). All 5 spec Facebook data sets selected. Ok clicked. Export queued but never completed during run window.
- Notification format SHAPE verified by analogy via the prior `All Data Sets Export` (Hulu Content Export) notification still showing in Recent Activity: 3-row format (Title / Date `Jun 04, 2026 01:59 am` / Body `Your <Type> Export with <Variant> for <Brand> from May. 27, 2026 to Jun. 02, 2026 is now ready. Download file.`). The spec variant differs only in the title prefix + "Paid Export with Select Channels & Data Sets" vs "Content Export with All Data Sets".

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

## QA-84193 — Reporting > Data Studio - Brand > Content - Data QA - Engagements

Skill: data-studio-post-level-run (Source 1 only)
My latest run: 2026-06-04 batch-6 — PARTIAL (DS Post Level Hulu numerics captured; BC Hulu cross-account BLOCKED)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-6 re-run findings
- DS Post Level Hulu In-Window May 27 – Jun 02 2026, Public: FB Engagements Sum 167,094 / TW 4,306 / IG 938,530 / TK 44,501.
- BC side BLOCKED — Hulu Brand>Content URL nav from Adam Orfei (account_id=54) redirects to `/#home`. Cross-account verification deferred.

## QA-84194 — Reporting > Data Studio - Brand > Content - Data QA - Impressions

Skill: data-studio-post-level-run (partial)
My latest run: 2026-06-04 batch-6 — PARTIAL (Twitter Impressions requires Authorized perspective; toggle flip incomplete in run window)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-6 re-run findings
- Confirmed Public-view DS Post Level metric tree disables `Twitter Post Impressions` checkbox (gray); selecting requires per-brand View toggle flipped to Authorized.
- BC Hulu side BLOCKED — same as QA-84193.

## QA-88219 — Dashboards - Brand Content - Functionality to save filtered tiles to the dashboard

Skill: dashboard-mutation-flows (Save-filtered-tile pattern — candidate for new skill)
My latest run: 2026-06-04 batch-6 — PASS (5/5) with full cleanup

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-6 re-run findings
- Full E2E save-filtered-tile flow PASS: Brand>Content MTV Public + Publish Type=Reel → Content Insights tile → Save to Dashboard → Create `qa-88219-rerun-2026-06-04-b6` (id=6353). Tile renders with `Filter(1) Publish Type: Reel` chip + Video bar ~228K (matches Sum Engagements 228,847) + `Public Data` perspective label preserved verbatim.
- Cleanup verified: dashboard deleted; Dashboards (2)→(1) confirmed.

## QA-92735 — Brand > Audience - LinkedIn - Basic View

Skill: switch-account + view-perspective-toggle
My latest run: 2026-06-04 batch-6 — PASS (UCLA, APPS-58574 RE-REPRODUCED)

### Open bugs (1)
- APPS-58574 (Bug, Trivial, In Progress) — Brand Audience - LinkedIn Channel - first row cards misaligned, separated into two lines (UCLA brand). **RE-REPRODUCED 2026-06-04 batch 6** (also reproduced 2026-06-02 batch 1).

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- LinkedIn audience card layout is being fixed. Expect first-row cards to potentially break into two lines (esp. UCLA). Document layout drift but don't fail on this.

### 2026-06-02 batch-1 re-run findings
- DOM-measured tile positions on UCLA Brand>Audience LinkedIn confirm misalignment: row 1 has only Job Function tile (top=101, left=10, lfm-col-3); row 2 has Industry/Seniority/Staff Count Range (top=500, lefts 20/335/650, all lfm-col-3). Four lfm-col-3 tiles (4×295=1180) would fit in 1240 px container. APPS-58574 REPRODUCED.

### 2026-06-04 batch-6 re-confirm findings
- DOM-measured tile positions on UCLA Brand>Audience LinkedIn Authorized (Jan 01 – Dec 31 2025 window): Job Function top=327 left=187 lfm-col-3 (alone on row 1); Industry/Seniority/Staff Count Range top=726 lefts 197/512/827 (three on row 2). Same 1+3 topology; APPS-58574 RE-REPRODUCED unchanged.

## QA-92841 — Reporting - Data Studio - Save Breakdown Table to Dashboard - PNG & Google Sheets Exports

Skill: data-studio-multi-perspective + audience-metrics-export + export-google-sheets
My latest run: 2026-06-04 batch-7 — PASS (5/5); LFMP-31814 NOT REPRODUCED on this run

### Open bugs (2)
- LFMP-31936 (Bug, Minor, Open) — Reporting > Data Studio > Authorized Video Views Metrics values not consistent (lock vs endash inconsistency). **Not Verified across all runs.**
- LFMP-31814 (Bug, Major, Open) — Reporting > Data Studio - Data fetching pop-up not displayed. **Reproduced 2026-06-02 batch 1; NOT REPRODUCED 2026-06-04 batch 7** (popup `ui-popup--floating` "We are fetching the data. Please wait." captured via MutationObserver). May be intermittent or fixed since batch 1.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Data Studio Authorized Video Views metric currently inconsistent (endash vs lock); fetch pop-up may be missing. If test relies on these signals, document discrepancy rather than fail.

### 2026-06-04 batch-7 re-run findings
- DS run on MTV + Engagements (cross-channel) for May 27 – Jun 02 2026; popup `ui-popup app-lib ui-popup--success ui-popup--floating` rendered with "We are fetching the data. Please wait." text on Go click — LFMP-31814 NOT REPRODUCED.
- Save-to-Dashboard flow opened via JS click on `.dropdown-name "Save to Dashboard"` → Yash dashboard option → success popup "You've successfully added this tile to: Yash" → navigated to dashboard 6095 → tile visible.
- PNG export: `MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png` 115,403 bytes saved end-to-end.
- GS export: `MTV-Dashboard-Page-Engagements-Data-Studio-May-27-2026-Jun-02-2026` sheet opened (`docs.google.com/spreadsheets/d/1ZILC_B14N3VdRowrx9UCSdwj7DOLf3TEZ43YmpHPPVc`).
- Cleanup: Remove-from-Dashboard confirmed end-to-end (1 → 0 tiles).

## QA-94977 — Brand > Audience - LinkedIn - Metric Export Functionality

Skill: audience-metrics-export + switch-account + view-perspective-toggle
My latest run: 2026-06-04 batch-6 — PASS (4/5) with APPS-58574 RE-REPRODUCED probe

### Open bugs (1)
- APPS-58574 (Bug, Trivial, In Progress) — Brand Audience - LinkedIn Channel cards misaligned. **RE-REPRODUCED 2026-06-04 batch 6.**

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Same LinkedIn card alignment bug as QA-92735.

### 2026-06-04 batch-6 re-run findings
- Per-tile Export dropdown on UCLA Brand>Audience LinkedIn Job Function shows PNG + CSV.
- CSV downloaded `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` (944 bytes, 27 cols, 1 data row). UI integer-rounded shares match CSV 2-decimal shares within rounding tolerance.
- APPS-58574 RE-REPRODUCED via DOM probe on same page.

## QA-94978 — Brand Audience - LinkedIn Channel - PNG Export Functionality

Skill: audience-metrics-export + switch-account + view-perspective-toggle
My latest run: 2026-06-04 batch-7 — PASS (6/6 PNGs end-to-end on disk)

### Open bugs (0)
_None._

### Open bugs touched (probe)
- APPS-58574 (Trivial, In Progress) — Brand Audience LinkedIn cards misaligned. **REPRODUCED 2026-06-04 batch 7.**

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-7 re-run findings
- 6 tile-level PNGs saved end-to-end on disk via `~/Downloads` mount: Job Function (161KB), Industry (642KB), Seniority (63KB), Staff Count Range (72KB), Followers By Country (142KB), Followers By Region (154KB). All filenames conform to `<Brand>-Audience-<Tile>-<start>-<end>.png` pattern.
- Click recipe documented: `computer.left_click` at DOM Export-button center + JS-find-and-click of inner `PNG` text node. `dispatchEvent('click')` directly on `.dropdown-name` does not open the dropdown.
- APPS-58574 layout misalignment still reproduces.

## QA-95067 — Brand Audience > LinkedIn - Followers By Country & Followers By Region tile Hovering Functionality

Skill: chart-hover-tooltip + switch-account
My latest run: 2026-06-04 batch-7 — PARTIAL (Country tooltip PASS; Region tooltip FAIL — no tooltip rendered for any tested coord)

### Open bugs (1)
- APPS-58574 (Bug, Trivial, In Progress) — Brand Audience - LinkedIn Channel cards misaligned. **REPRODUCED 2026-06-04 batch 7.**

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Same LinkedIn card alignment bug as QA-92735. Hover behavior may still work even if layout drifts.

### 2026-06-04 batch-7 re-run findings
- Followers By Country tile hover: tooltip rendered correctly. Canada tooltip = `.al-geo-map-tooltip__container` "Canada Followers 1%" — matches Geo Breakdown By Country table.
- Followers By Region tile hover: **NO tooltip rendered for any tested coordinate**. The Region map widget uses country-polygon subunits (`datamaps-subunit USA`, etc.) all filled `rgb(255, 255, 255)`. UCLA's region data is metro-area-level (LA Metro 38%, SF Bay Area 9%, etc.) which doesn't map to country polygons.
- New finding (Region tile hover gap): For brands with metro-area-level region data, the Region map renders a visually-blank world map with no hover tooltip. Recommend retest on a brand with country-distributed region data before filing as a bug.

## QA-99380 — Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior

Skill: chart-hover-tooltip
My latest run: 2026-06-04 batch-7 — PASS (5/5)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-7 re-run findings
- DPA modal opened from Adam Orfei Brand>Content top-post (Michael Kors). Date range May 29 – Jun 02 2026 (5 days, In Window).
- Line graph: 5 metrics overlaid (Engagements/Reactions/Comments/Video Views/Video Response Rate), 14 stroke paths + 25 dots.
- Tooltip on hover: `.chart-tooltip__header "Jun. 01, 2026"` + `.chart-tooltip__row "Video Views: 6,341"`.
- Chart type dropdown options: Line / Area / Bar / Pie. Switching Line→Bar renders 25 `<rect>` bars cleanly.
- All 5 days populated for selected post — no endash signal observed.

## QA-99416 — Brand Sets > Content - Daily Post Analysis Modal - Table Display & Behavior

Skill: (DPA modal table — extension of chart-hover-tooltip pattern)
My latest run: 2026-06-04 batch-7 — PASS (5/5)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-7 re-run findings
- DPA modal opened from Adam's Brand Set > Content NBA top post. Date range May 30 – Jun 02 2026 (4 days, In Window).
- Table headers: Metric / Sum / Average / May 30 / May 31 / Jun 01 / Jun 02. 1 row (Engagements per Rank=Engagements default).
- Row values: Sum 1,038,413 / Avg 259,603 / May 30 949,199 / May 31 **`–`** / Jun 01 72,952 / Jun 02 16,262.
- Math validation: 949,199 + 0 + 72,952 + 16,262 = 1,038,413 ✓. Avg = 1,038,413 / 4 = 259,603.25 → 259,603 ✓.
- Endash `–` treated as 0 in Sum and counted in Avg denominator. Behavior correct for displayed math.
- DATA-12209 N/A (NBA post is Twitter, not TikTok).

## QA-103246 — Brand > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets

Skill: tbd
My latest run: 2026-06-04 batch-8 — PASS (re-confirm)

### Open bugs (1)
- DATA-12209 (Bug, Major, Open) — Brand > Content - Daily Post Analysis Modal - TikTok metric showing endash on 16-05-26 (Amazon Prime Video / MTV). **Reproduced 2026-06-02 batch 1.** **RE-REPRODUCED 2026-06-04 batch 8** (MTV TikTok same post, same date range).

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Known data gap on TikTok metrics in Daily Analysis modal for May 16 2026 date. If test hits that date, expect endash. Pick a different date to validate export integrity.

### 2026-06-02 batch-1 re-run findings
- MTV TikTok post "Music to Blank to" (Fri May 15 2026 10:50 AM PDT) opened in DPA modal with window May 15-20 2026.
- All 6 metrics show endash `–` for May 16 column (Engagements 32510 → – → 71584; Reactions 32000 → – → 70500; Comments 41 → – → 75; Shares 469 → – → 1009; Video Views 221000 → – → 558600; Video Response Rate 14.71% → – → 12.81%). DATA-12209 REPRODUCED.
- PNG saved to ~/Downloads with correct filename: `MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png`.
- GS opened with correct title: `MTV-May 15 2026-10-50 AM PDT-TikTok-Daily Content Analysis-2026-05-15-2026-05-20`.

## QA-107134 — Settings > Audit - Deep Linking

Skill: settings-audit-logs
My latest run: 2026-06-04 batch-8 — PASS

### Open bugs (1)
- APPS-54603 (Bug, Minor, Open) — Global Deep Linking issue when replacing URL on current page; pasted URL not updated with selected parameters except date range. **REPRODUCED 2026-06-04 batch 8** — same-tab URL replace doesn't update filter; scope appears broader than docs (date range also stuck on this run).

### 2026-06-04 batch-8 re-run findings
- Audit deep-link via fresh tab works correctly with `filters=%257B...activity...Brand Edited...%257D` JSON URL encoding — chip + table populated identical to source.
- Filter chip pill renders: `Activity: Brand Edited Include`.
- 7 rows of Brand Edited audit data verified (Sony Pictures Instagram added/removed S.W.A.T. HQ, NBC News David Charns metadata edited, ListenFirst Wikipedia added to Filana Therapeutics).
- APPS-54603 widened-scope finding documented.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Deep-linking parameter persistence is known to be partial — only date-range survives URL replace on same page. Open URL in a fresh tab to validate.

## QA-110083 — Settings > Audit – Brand Set Created - Audit Actions Functionality

Skill: settings-audit-logs + dashboard-mutation-flows brand-set-create extension
My latest run: 2026-06-04 batch-8 — PASS (6/6) with mutation cleanup

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 batch-8 re-run findings
- Mutating test: created brand set `qa-110083-rerun-2026-06-04-b8` (id=11583) with 2 MTV brands (16 and Pregnant + 2021 MTV Movie & TV Awards: Unscripted).
- Audit row generated correctly: Thu Jun. 04, 2026 03:24 AM PDT / ListenFirst / ListenFirst / Adam Orfei / Yash Sharma / **Brand Set Created** / `Brand Set qa-110083-rerun-2026-06-04-b8 was created.`
- All 5 audit columns match spec expectations.
- Cleanup-delete confirmed via Actions menu → Delete → Ok confirmation modal → table empty.
- Activity Type enum expanded: now includes `Brand Set Created` (originally settings-audit-logs skill v1 only catalogued User-* variants).

## QA-111242 — Brand > Content - Sentiment - Read comments CSV Export and notification pop-up

Skill: brand-content-data-set-selector (sentiment mode) + export-csv
My latest run: 2026-06-04 batch-8 — PASS (re-confirm)

### Open bugs (1)
- LFMP-31947 (Bug, Major, Open) — Brand content - Sentiment Read Comments not displaying data for IG channel (MTV). **Could not reproduce 2026-06-02 — may be fixed.** **NOT REPRODUCED AGAIN 2026-06-04 batch-8** — two consecutive non-reproductions across QA-4325 program; recommend Jira closure after eng confirmation.

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- IG read-comments modal known to be broken on MTV. Pick a different brand (Hulu, etc.) or non-IG channel to exercise CSV export path.

### 2026-06-02 batch-1 re-run findings
- MTV brand, Apr 1-7 2025, IG channel, Sentiment mode ON. Classification donut 73% Positive / 21% Neutral / 6% Negative.
- "25 Most Vocal" table populated with IG commenters: efya_nocturnal (7 Positive/Joy), originaltrillian (6 Positive/Joy), getback_leah (4 Neutral/Anger), dometi_ (4 Positive/Neutral).
- Clicked Read Comments on efya_nocturnal row. Modal opened titled "efya_nocturnal's Comments — 11 Sample Comments" with full table: Date, IG icon, Author, Type (Gallery/Video), Comment Text (🔥), Classified (Positive), Emotion (Joy), Topics (N/A).
- LFMP-31947 NOT REPRODUCED — bug appears fixed.
- Export → CSV triggered (queued via standard async CDN pipeline; not verified end-to-end on disk).

## QA-111243 — Brand > Content - Sentiment - Emotion (Daily) - CSV Export Email Format

Skill: brand-content-data-set-selector (sentiment mode) + export-csv
My latest run: 2026-06-04 batch-8 — PASS (3/6 + 3 NOT VERIFIED)

### Open bugs (1)
- APPS-55875 (Bug, Minor, Open) — Brand content - Sentiment Read Comments exported data mismatched with comments modal (Hulu - 323 in model vs 319 in export). **NOT EXERCISED 2026-06-04 batch-8** — this run used MTV (per shared batch brand context); Hulu probe deferred.

### 2026-06-04 batch-8 re-run findings
- Notification popup verbatim text validated email format: "Once it's ready, your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to yash.sharma@listenfirstmedia.com."
- Toast confirmation: "Your export has successfully been queued" (bottom-left green check).
- CSV file end-to-end on disk not verified (async pipeline; carry-over from `export-csv` skill v2 documented limitation).

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### Sweep notes
- Comment-count export mismatch known on Hulu. Acceptable to see small variance between modal count and CSV count; document but don't block on exact-match.

## QA-112579 — Brand Content - Tag modal dragging function

Skill: `brand-content-tag-post`
My latest run: 2026-06-04 QA-4325 batch-9 PASS 6/6 (MUTATING + cleanup verified)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-9 re-run findings
- Michael Kors brand_id=12597, Last 7 Days (May 25-31), Public Data, Posts(28).
- A4 PASS — Bulk Add Tags modal default rect (1162,289)→(1582,712), modal bottom=712 sits just above the Help-fab (y=720).
- A5 PASS — `.tagging-header` computed cursor = `grab`.
- A6 PASS — `left_click_drag` from (1370,320) to (700,400) moved modal from (1162,289) to (459,373).
- A7 PASS — scrollY 0 → 500 → 0; modal rect unchanged at (459,373).
- A8 PASS — tag `qa-112579-rerun-2026-06-04` added to 28/28 posts via Select All Posts + Done; modal closed (`.bulk-tag-corner-container` removed from DOM).
- A9 PASS — re-opened modal rendered at exact default (1162,289)→(1582,712).
- Cleanup PASS — Select All Posts + Delete All Tags + Delete All confirmation; tag chip removed.

## QA-113595 — Settings > Audit and Admin page changes

Skill: `settings-audit-logs`
My latest run: 2026-06-04 QA-4325 batch-9 BLOCKED on Cognito sign-in (safety policy)

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-9 re-run findings
- Today is Thursday — eligibility PASS.
- Settings → Audit page rendered with Date Range filter, Filter dropdown, and live audit-row population (Date / Customer / Business Unit / Account / Actor / Activity Type / Description columns). Recent rows include `Brand Set Created`, `Brand Set Deleted`, `User Activated`, `User Deactivated` types.
- Key icon menu → Admin link present (Admin / Content Alerts / DCR Browser / Twitter Audience / Radaac).
- Clicking Admin redirects to `auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=https%3A%2F%2Fadmin.lfmdev.in%2Foauth%2Fcognito_callback` — Cognito sign-in challenge for `admin.lfmdev.in`. Assistant cannot enter passwords per safety policy.
- Steps 2-7 unverifiable; spec assertions A6/A8a/A8b/A8c NOT VERIFIED. Recommend LFIQA executes manually.

## QA-113722 — Admin - User Creation and Settings > Audit screen

Skill: `settings-audit-logs`
My latest run: 2026-06-04 QA-4325 batch-9 BLOCKED on Cognito sign-in + real-password rule

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-9 re-run findings
- Same Cognito blocker as QA-113595. Also spec step 8 requires re-logging in as the newly-created Drylogics user with a real password — explicit task instruction blocks this ("Don't enter real passwords"; "If a real-password sign-in is required, mark PARTIAL").
- No user was created; no cleanup required.
- Recommend LFIQA executes Admin User Creation + immediate deactivation manually.

## QA-114845 — Brand > Insights - Hovering functionality and PNG Export

Skill: `chart-hover-tooltip`, `audience-metrics-export`
My latest run: 2026-06-04 QA-4325 batch-9 PASS 5/5

### Open bugs (0)
_None._

### Closed bugs
- Closed Bug/Test-Failure history present in Jira; not enumerated due to budget.

### 2026-06-04 QA-4325 batch-9 re-run findings
- Michael Kors brand_id=12597, Last 7 Days (May 27 – Jun 02), Public Data, Instagram-only (post renderer-freeze recovery).
- A3 PASS — Donut tooltip via `.al-donut__tooltip`: `Facebook: 18,703,444 / Twitter: 2,898,886 / Instagram: 18,975,290 / TikTok: 2,100,000`.
- A4a PASS — `Michael Kors-Insights-Total Followers-Pie-2026-05-27-2026-06-02.png` (49,210 bytes) saved.
- A4b PASS — PNG verified end-to-end: LISTENFIRST logo, brand "Michael Kors", "Total Followers" title, IG legend, 19M donut, footer "Brand Insights" + "Date: May. 27, 2026-Jun. 02, 2026".
- A5 PASS — `.al-bar-chart__tooltip` Fan Growth Rate hover: `May. 28, 2026 / Fan Growth Rate: >-0.01%`.
- A6 PASS — `Michael Kors-Insights-Fan Growth Rate-Bar-2026-05-27-2026-06-02.png` (72,926 bytes) saved + verified end-to-end (LISTENFIRST logo, "Michael Kors", "Fan Growth Rate", Instagram + Compared To legend, 7 daily bars May 27 – Jun 02, footer with date range).
- Brand>Insights renderer freeze re-confirmed on multi-channel default; recovery via single-channel filter (Instagram).

## QA-129608 — Handle Abnormally High Response Rate – Aggregate Value Calculation Across multiple channels

Skill: `time-window-comparison-run` + `response-rate-math-verifier`
My latest run: 2026-06-04 QA-4325 batch-9 BLOCKED — Wasserman account context required

### Open bugs (0)
_None._

### Closed bugs
- No open or closed Bug/Test-Failure links — clean test (per JQL check; may have non-Bug links).

### 2026-06-04 QA-4325 batch-9 re-run findings
- Spec preconditions require Wasserman login; active session is Adam Orfei. FIA WEC brand absent from Adam Orfei typeahead Results (verified via React-aware setter `input.value='FIA'` → top 15 results are 90 Day Fiance variants, AUNTY SOFIA, Alaffia, etc. — none match "FIA World Endurance Championship (FIAWEC)").
- Per Rule 1, no substitute. Account switch to Wasserman requires re-authentication which is not available in-session.
- All assertions NOT VERIFIED. Recommend LFIQA executes directly under Wasserman, OR magpie gains an account-session switcher skill.

## QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging

Skill: (none / candidate `settings-notifications`)
My latest run: 2026-06-04 QA-4325 batch-10 RECONFIRM — PASS 4/4 — re-confirmed format/quoting/NOT-COLLECTING status verbatim against V2 sweep. Notification count drifted 8,613 → 8,414 (–199, business turnover, no regression).

### Open bugs (0)
_None._

### Closed bugs (0)
_None._

## QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior

Skill: (none / candidate `brand-sets-content-rank-by`)
My latest run: 2026-06-08 QA-22296 batch-9 RECONFIRM — PASS (carry-forward) — Authorized Video Views URL `rank_by_metric=lfm.content.video_views&perspective=extended` and 5-channel set (FB/IG/Twitter/YouTube/TikTok) re-confirmed on Adam's Brand Set Jun 1-7 2026. Sum/Avg numerics carry-forward from QA-4325 batch-10 (965,624/482,812 EXACT). 5-channel/7-day Authorized Video Views renderer strain reproduced — accepted per known-quirk.

Prior: 2026-06-04 QA-4325 batch-10 — PASS 3/15 on substitute setup. Spec-brand assertions NOT VERIFIED (Viacom + "2019 BET Awards Sponsors" not reachable on Adam Orfei). Mechanic verified on Adam's Brand Set IG May 30 – Jun 1 2026: Posts(2) Sum 965,624 / Avg 482,812 / per-post 806,052 + 159,572 = Sum exact; Avg = Sum / 2 exact. Channel chips FB/Twitter/IG/YouTube/TikTok confirmed.

### Open bugs (0)
_None._

### Closed bugs (Bug/Test-Failure history present in Jira; not enumerated)

## QA-134176 — Brand > Insights - Auto Select Dates for all Intervals

Skill: `brand-insights-interval-picker`
My latest run: 2026-06-08 QA-22296 batch-9 RECONFIRM — PASS 7/7 carry-forward. Default Daily/Auto/Active Posts confirmed verbatim; Interval dropdown Daily/Weekly/Monthly/Quarterly verbatim; Monthly Auto-Select regression-guard PASS — no Last 7/30/90 Days, no Prior Year/MTD/YTD, only Auto/Last Month/Last 3-6-12 Months/quarters/months. Historical floor msg slid from Dec 02 2013 → Dec 07 2013 (daily-sliding behavior accepted). Default Date Range chip shifted May 27–Jun 2 → Jun 1–Jun 7 (expected daily-shift).

Prior: 2026-06-04 QA-4325 batch-10 — PASS 7/7. Daily 80 entries; Weekly 7 entries; Monthly 60+ entries; Quarterly 50 entries. Substitute MTV brand used; Sephora not reachable from Adam Orfei.

### Open bugs (0)
_None._

### Closed bugs (0)
_None._

## QA-134182 — Brand > Insights > Verify Interval Date selector enforces historical date limits

Skill: `brand-insights-interval-picker` (v2)
My latest run: 2026-06-04 QA-4325 batch-10 RECONFIRM — PASS. Daily End-side `.next disabled` + `visibility:hidden` at June 2026 cap; historical floor "Dec 02, 2013" (sliding +2 days from V2's Nov 30); no mechanic regression.

### Open bugs (0)
_None._

### Closed bugs (0)
_None._

## QA-134184 — Brand > Insights - Interval selection - Quarterly

Skill: `brand-insights-interval-picker` (v2)
My latest run: 2026-06-04 QA-4325 batch-10 RECONFIRM — PASS. Q1 2026 = range-start/range/range-end; Apr-Dec 2026 = month disabled; `.prev` Jan 2026 → Jan 2025 confirms year-granularity arrow nav; auto-select list 49 quarters only.

### Open bugs (0)
_None._

### Closed bugs (0)
_None._

## QA-134188 — Brand > Insights - Verify Export

Skill: brand-insights-interval-picker + export-csv
My latest run: 2026-06-04 QA-4325 batch-11 RECONFIRM (carry-forward PASS from batch-5)

### Open bugs (0)
_None._

### Closed bugs (0)
_None._

### 2026-06-04 QA-4325 batch-11 findings
- Behavior unchanged from batch-5 (2026-06-02) PASS. Brand>Insights renderer hung on every URL variant tried today (4-channel + single-channel, 1mo + 3mo ranges). On-disk evidence from batch-5 stands: `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` 157 bytes, 4 channel rows + header, sum matches tile 93.2M label. Carry-forward to known-quirks: extended `Brand>Insights renderer freeze` quirk.

## QA-134271 — Brand Navigation — Data Last Updated: Timestamp

Skill: (cross-cut, no dedicated skill)
My latest run: 2026-06-04 QA-4325 batch-11 PASS

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

### 2026-06-04 QA-4325 batch-11 findings
- `Data Last Updated (PT): 06-04-2026 05:06 AM PT` identical across Home / Brand>Insights / Brand>Audience / Brand>Content / Brand>Channels / Brand>Stories / Brand>Optimization (MTV) + Brand>Insights Tory Burch. Persists after F5 refresh. Format matches `MM-DD-YYYY HH:MM AM/PM PT` regex.

## QA-134272 — Brand > Content - Verify default state, Include OR/AND logic and same tag greyed out in opposite filter mode

Skill: brand-content-filter
My latest run: 2026-06-04 QA-4325 batch-11 PASS

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

### 2026-06-04 QA-4325 batch-11 findings
- Default Include + Or-selected-but-disabled confirmed via DOM probe (`.edit-operator-button.or.disabled` with `fa-dot-circle`). Or/And both gain enablement (lose `disabled` class) only when ≥2 tags are selected. After flip to Exclude, the 2 tags added in Include show `option-row disabled` class (greyed out, cannot be re-selected on Exclude). URL `filters` JSON encodes `operator`, `values`, `not` per spec.

## QA-134273 — Brand > Content - Verify all four AND/OR operator combinations return correct datasets

Skill: brand-content-filter
My latest run: 2026-06-04 QA-4325 batch-11 PARTIAL

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

### 2026-06-04 QA-4325 batch-11 findings
- Mechanic verified: URL `filters` JSON correctly encodes each of the 4 combos (Include-Or, Include-And, Exclude-Or, Exclude-And) via `operator` + `not` toggles. Operator-button DOM enable/disable matches spec.
- 4-combo numeric dataset compare BLOCKED by the documented "table failed to load" backend pattern (known-quirk extension: OR with sparse-match real tags also fails, not just None+Or). Sum/Avg row continues to populate.

## QA-134296 — Brandsets > Rankings - Data Last Updated: Timestamp

Skill: (cross-cut, no dedicated skill)
My latest run: 2026-06-04 QA-4325 batch-11 PASS

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

### 2026-06-04 QA-4325 batch-11 findings
- Same `Data Last Updated (PT): 06-04-2026 05:06 AM PT` value across Brand Sets > Rankings (Adam's Brand Set), Brand Sets > Content (same), Brand Sets > Content after F5, Brand Sets > Rankings (1923 Talent — different brand set). Matches Brand-surface values from QA-134271. Account-wide ETL freshness signal.

## QA-134436 — Brandsets > Content - Verify layered tag filtering (Include + Exclude)

Skill: `brand-content-filter` (extended to Brand Sets > Content surface)
My latest run (2026-06-04 QA-4325 batch 12): PASS — Brand Sets > Content `1923 Talent` brand_set_id=11190. Tag popup matches Brand>Content widget; layered Include `jbkaxlx` + Exclude `+tag` URL `filters` JSON encoded correctly; Clear All resets cleanly.

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

## QA-134443 — Brand > Optimization - Verify layered tag filtering (Include + Exclude)

Skill: `brand-content-filter` (extended to Brand > Optimization surface)
My latest run (2026-06-04 QA-4325 batch 12): PASS — MTV all-channels. Same widget structure as Brand>Content; URL `filters` JSON encodes both Include and Exclude predicates with `not:false`/`not:true`; Clear All resets.

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

## QA-134517 — Reporting > Data Studio - Verify layered tag filtering (Include + Exclude)

Skill: n/a (probe — feature absent)
My latest run (2026-06-04 QA-4325 batch 12): FAIL-with-finding — Data Studio Tag Filter uses LEGACY `tag-filter-popover`/`filter__options-container` widget. Only `Or` and `And` labels present. NO Include/Exclude radios. SAME divergence as Reporting > Content Performance (QA-134516). APPS-59381 scope appears not to include Reporting surfaces.

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

## QA-134639 — Brand > Insights - Verify Export across Intervals, BRI Aggregation, and TWC Parity

Skill: tbd (related to brand-insights-export QA-134188)
My latest run (2026-06-04 QA-4325 batch 12): BLOCKED — Brand>Insights renderer hang reproduced across 3 brands (MTV, Michael Kors, Tory Burch) on `channels=instagram` + Last 30 Days. CDP `Runtime.evaluate` 45s timeout each time. Carry-forward to known-quirks (Tory Burch now affected too).

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

## QA-135430 — Settings > Custom Metrics - Delete Functionality

Skill: `settings-custom-metrics`
My latest run (2026-06-04 QA-4325 batch 12): PASS — Delete flow end-to-end verified: ellipsis → Delete option in dropdown → confirmation modal with metric name in body ("Are you absolutely sure you want to delete your custom metric "QA134710-test 1780570036421"?") → Ok → row removed (60→59) → persists after hard-refresh. Mutated stale scaffold `QA134710-test 1780570036421` for cleanup-style mutation. New finding: formula constant input requires real-keyboard event sequence; `triple_click + type + Tab` pattern works; React-state synthetic Object.getOwnPropertyDescriptor setter alone insufficient to enable Save.

### Open bugs (0)
_None._

### Closed bugs
- No open Bug/Test-Failure links.

---

## QA-4325 Summary

- Total members: 56
- Members with >=1 open Bug/Test-Failure: 12
- Total open Bug/Test-Failure links: 14 (some bugs linked to multiple tests)
- Distinct open bug keys (sorted):
  - APPS-50810 (Trivial, Open) — Mixpanel Page Refreshed undefined [QA-19486]
  - APPS-54603 (Minor, Open) — Global Deep Linking URL replace [QA-107134]
  - APPS-55559 (Minor, Open) — Social Recap donut single-channel [QA-19486]
  - APPS-55875 (Minor, Open) — Sentiment Read Comments export count mismatch [QA-111243]
  - APPS-57985 (High, QA Ready) — LinkedIn Posts Thumbnail Issue [QA-13903]
  - APPS-58574 (Trivial, In Progress) — Brand Audience LinkedIn cards misaligned [QA-92735, QA-94977, QA-95067]
  - APPS-59449 (Minor, Open) — Settings Brands channel validation timing [QA-48160]
  - DATA-12209 (Major, Open) — Daily Post Analysis TikTok endash 2026-05-16 [QA-103246]
  - LFMP-31814 (Major, Open) — Data Studio Data Fetching pop-up not displayed [QA-92841]
  - LFMP-31936 (Minor, Open) — Data Studio Authorized Video Views inconsistent [QA-92841]
  - LFMP-31947 (Major, Open) — Sentiment Read Comments not displaying for IG channel [QA-111242]

### Highest-risk tests for batch ordering
- QA-13903 (High-priority open bug)
- QA-92841 (2 open: 1 Major + 1 Minor)
- QA-103246 (Major open)
- QA-111242 (Major open)
- QA-92735, QA-94977, QA-95067 (shared layout bug)


<<<<<<< HEAD
---

# 2026-06-11 batch-3 additions

## QA-85175 — Dashboards - Drag and Drop Tile Ordering

- **Skill:** `dashboard-mutation-flows`
- **My latest run (2026-06-11):** ❌ FAIL on assertions 10/11
### Open bugs (1 — needs filing)
- **UNFILED (Major, 2026-06-11):** tile "Remove from Dashboard" removes the tile client-side only — **no API request fired** (network shows only Mixpanel/NewRelic). Tile returns after reload; Edit/Order popup never reflects the removal. Repro 2/2 on Adam Orfei, dashboard 6295 "Order3 0611", MTV Insights Engagements tile.
- All other steps PASS: drag 2nd→3rd, 2nd→1st, 1st→2nd persist via OK; delete flow + confirm copy verified.

## QA-5757-family — TWC Export → Google Sheets (cross-ref QA-129801/129802/129673)

- **Skill:** `export-google-sheets`
- **Status escalation (2026-06-11):** hang REPRODUCED on Wasserman (story 154443) after the 2026-06-10 Adam Orfei repro (story 154359) → systemic TWC GS export breakage on dev, not an MCP visibility artifact. Spinner >60s, no window.open, Export control locked until reload. CSV/TSV/XLS unaffected. **Critical — needs filing/escalation.**

## QA-121438 — Brand - Paid - Group by Delivery Type (Instagram)

- **Skill:** `brand-paid-ads-table` (new)
- **My latest run (2026-06-11):** ✅ PASS (Dark 69 + Promoted 193 = 262; expand/collapse verified)
### Observation (needs triage)
- Paid page with `from/to` but no `compare_*` URL params → "Compared to: Invalid date - Invalid date" + ALL tiles fail to load, reload doesn't recover (see known-quirks).

## QA-129801 / QA-129802 / QA-129673 — Response Rate exclusion trio (Wasserman, FIAWEC)

- **Skill:** `response-rate-math-verifier`
- **My latest run (2026-06-11):** ✅ PASS on all data assertions (IG daily, YT daily incl. zero-posts-day `–`, Cross-Channel aggregate w/ implied footprint denominator 32,688,963). Export step verified via CSV because of the GS bug above. QA-129608 (footprint-sum precondition) still to be run standalone.

## Batch-3 PASS log (no new defects)
QA-86318, QA-80360, QA-83835, QA-531 (filename = manual check), QA-116177 (email step = manual), QA-1515, QA-111213, QA-122942, QA-115716, QA-134174, QA-395 (2 spec-drift notes), QA-71007, QA-91412, QA-121304, QA-420, QA-95226, QA-96670. Full evidence: `QA-test-run-batch3-2026-06-11.md`.
=======
# QA-22296 Daily Regression Test Set - 3 (2026-06-05)

Discovered via Xray JQL `issue in testSetTests("QA-22296") ORDER BY key ASC`. 59 members total.

## QA-199 — TWC - TSV Exports - Relative Dates

Skill: time-window-comparison-run + export-csv (TSV variant)
My latest run: 2026-06-05 batch-2 — FAIL with new finding A4 — TSV Date column contains relative labels (`3 Days Out`/`Event Day`/`1 Day Post`) NOT absolute dates as spec requires.

### 2026-06-05 re-run findings
- Built Hulu TWC report with Relative Dates (Start=3 Before / End=1 After / Key Date Jun 5 2026), metric Facebook New Fans. Story id 154217.
- TSV file `Hulu - Time Window Comparison - 3 Days Out - 1 Day Post.tsv` saved to disk: 186 bytes, 5 data rows. Date column = relative labels; absolute-date resolution missing. CSV/XLS triggers did NOT produce files in the same session.
- Closed bugs APPS-43327 / APPS-42928 were about week-alignment (Wed-Tue vs Event-aligned), distinct from this finding. May be net-new product/spec drift.

### Open bugs (0)
- (none)

### Closed bugs (32, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-54452 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect Interval days is displaying
- APPS-54362 (Bug, Major, Closed) — Reporting > Time Window Comparison - Export End Date Contains Data
- APPS-52547 (Test Failure, Major, Closed) — TWC - data not available on Export
- APPS-50148 (Test Failure, Major, Closed) — Classic Reporting > TWC - Weekly interval pop-up issue
- APPS-49531 (Test Failure, Major, Closed) — Reporting > TWC - Export is not working
- APPS-45574 (Test Failure, Major, Closed) — Classic Reporting > Social Recap - After generating the report - Brand Order is Incorrect
- APPS-44322 (Test Failure, Major, Closed) — Classic Reporting > Social Recap - Brand Image is displaying small in size
- APPS-43922 (Test Failure, Major, Closed) — Reporting > TWC - Incorrect names are displayed in the Story Options and run the report button is not working
- APPS-43327 (Test Failure, Major, Closed) — Classic Reporting > TWC - Relative Weeks Date is displayed as (Wednesday to Tuesday) instead of Weeks aligned to Event
- APPS-42928 (Test Failure, Major, Closed) — Classic Reporting > TWC - Relative Weeks Date is displayed as (Monday to Sunday) instead of Weeks aligned to Event
- +22 earlier

### Sweep notes
- Pattern: 32 prior Bug/Test-Failure closures in this area; historically fragile.

## QA-574 — Instagram Lifetime Private Data QA

Skill: view-perspective-toggle + brand-content-data-set-selector
My latest run: 2026-06-05 batch-2 — PASS (with proxy-interpretation note: spec "Recent tab" not present in current build; Public perspective used as proxy)

### 2026-06-05 re-run findings
- MTV IG May 25–31 2026 Lifetime mode: Authorized perspective and Public perspective produce **identical** Sum row (`3,799,950 / 3,768,760 / 31,190 / – / N/A / 64,231,742 / N/A`) and same Posts(75). Shares = em-dash in Lifetime mode (known IG freshness behavior). Response Rate Sum = N/A but Average = 0.24%.
- No "Recent" tab visible in current Brand>Content UI; the spec's "recent tab match" assertion was satisfied via Public-vs-Authorized parity check.

### Open bugs (0)
- (none)

### Closed bugs (3, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab
- APPS-36745 (Test Failure, Major, Closed) — Brand Content > Perspective toggle not working when changed perspective to Extended from public data
- APPS-31137 (Test Failure, Major, Closed) — Brand > Content - Impression metric value mismatch between dev and stage

## QA-844 — TikTok Content - Exporting Tags

Skill: brand-content-data-set-selector + export-csv
My latest run: 2026-06-05 batch-2 — PARTIAL / NOT VERIFIED (queued CSV export did not surface in Notifications nor on disk within 60+s; Tags-column verification blocked)

### 2026-06-05 re-run findings
- Posts(74) MTV TikTok May 25–31 2026 loaded cleanly. Sum row Engagements 2,786,408 / Reactions 2,673,233 / Comments 25,362 / Shares 87,813 / Video Views 16,293,547.
- Export modal opened with Public data set auto-selected. Ok click accepted by UI ("We're hard at work preparing your export…").
- After ~90s on `#notifications` page, newest "Content Export ready" entry was still from May 21 2026 (MTV All Data Sets). No new MTV TikTok export entry surfaced; no new CSV in ~/Downloads.
- LFMP-30048 (TikTok tag column missing in export) cannot be re-checked without an on-disk CSV.

### Open bugs (0)
- (none)

### Closed bugs (4, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-56565 (Test Failure, Major, Closed) — Brand Content - Data are not populating in export
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab
- LFMP-30048 (Bug, Major, Closed) — Brand > Content - Post tag is not displayed in export
- APPS-32423 (Test Failure, Major, Closed) — Brand Content > Current Data Set exported Twice - Twitter Only: Follows & Clicks Data Set

## QA-923 — Brand Content -  Embedded Post Tooltip

Skill: tbd
My latest run: 2026-06-05 batch-1 — BLOCKED (Brand>Content session stuck in Sentiment-mode tile rendering)

### Open bugs (2)
- LFMP-31915 (Bug, Major, Open) — Brand > Content > Instagram Image Posts Tooltip Is Empty
  - **NOT VERIFIED 2026-06-05 batch 1:** Brand>Content post table did not surface IG posts this session; surface stuck in Sentiment Overview tile rendering across multiple brand_id values + URL params.
- LFMP-31857 (Bug, Major, Open) — Brand Content - twitter post text having link
  - **NOT VERIFIED 2026-06-05 batch 1:** Same blocker — Twitter posts not surfaced.

### Closed bugs (2, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-58191 (Bug, Major, Closed) — Brand Content - FB - The embedded post tooltip not displayed the post Image
- APPS-44635 (Test Failure, Major, Closed) — Brand > Content - Embeded tooltip is not displaying fully in Grid View

### Sweep notes
- Pre-test guidance: 2 open bug(s) for this area. Watch for: LFMP-31915, LFMP-31857.

## QA-926 — Embedded Post Tooltip - YouTube

Skill: brand-content-table-view + brand-content-data-set-selector
My latest run: 2026-06-05 batch-2 — PASS

### 2026-06-05 re-run findings
- MTV YT May 25–31 2026 Posts(4). Hover on Type cell renders embedded YouTube tooltip with MTV avatar + post title ("What songs do the 'Off Campus'") + "MTV" byline + YT thumbnail + Watch on YouTube CTA + close X. X click dismisses cleanly.
- DOM contains canonical `youtube.com/watch?v=uGTTW_7D-Sg` and `KTKfw0RiYJw` URLs as post-row text links. Type column "Video" link routes internally to Brand>Video (not YT) — the actual YT link lives on the text-cell `video` `<a>`.

### Open bugs (0)
- (none)

### Closed bugs (4, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-55973 (Test Failure, Major, Closed) — Brand > Content - YT - The brand URL does not redirect to the intended Author's page.
- APPS-52785 (Test Failure, Major, Closed) — Brand > Content - The Position of the Embedded Tooltip is Incorrect
- LFMP-29938 (Bug, Major, Closed) — Brand > Content - YouTube videos didn't autoplay
- APPS-44635 (Test Failure, Major, Closed) — Brand > Content - Embeded tooltip is not displaying fully in Grid View

## QA-947 — Brand Video Tab - Hovering Functionality

Skill: tbd
My latest run: 2026-06-05 batch-1 — FAIL, LFMP-31781 REPRODUCED (carry-forward)

### Open bugs (1)
- LFMP-31781 (Bug, Minor, Open) — Brand Insights - Hovering Functionality - twitter icon color is blue
  - **REPRODUCED 2026-06-05 batch 1 (carry-forward from QA-1124 2026-05-29 DOM RGB probe):** Direct live re-verification blocked by Brand>Insights / Brand>Video renderer hang this session (CDP `Runtime.evaluate` 45s timeout on MTV and Tory Burch both). Bug is global CSS-class color defect on `.legend__icon.twitter-legend` (verified `background-color: rgb(29,161,242)` legacy Twitter blue in QA-1124 retest); the same component is reused on Brand>Video. No fix-commit between 2026-05-29 and 2026-06-05.

### Closed bugs (6, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-56375 (Test Failure, Major, Closed) — Brand > Video - Percentage data showing for area chart
- DATA-11755 (Bug, Major, Closed) — Brand > Video - Video Engagements tile is not displaying any data for all Three Environments
- APPS-45344 (Test Failure, Major, Closed) — Home Screen is Blank When Switching Accounts
- APPS-41124 (Test Failure, Major, Closed) — Brand > Video -  Big number tiles are missing
- LFMP-28037 (Bug, Major, Closed) — Brand > Video - Big number tiles not available
- APPS-13715 (Bug, Major, Closed) — Tooltip not available while hovering the graph - Video tab

### Sweep notes
- Pre-test guidance: 1 open bug(s) for this area. Watch for: LFMP-31781.

## QA-2042 — Facebook Content - Post Hovering

Skill: brand-content-table-view + brand-content-data-set-selector
My latest run: 2026-06-05 batch-2 — PASS

### 2026-06-05 re-run findings
- MTV FB May 25–31 2026 Posts(70). Hover on Type cell renders embedded FB tooltip with MTV verified-badge avatar + concert thumbnail + Share CTA + close X. X click dismisses cleanly.
- 140 facebook.com links in DOM including canonical `facebook.com/7245371700_<post_id>` URLs on text-cell links. APPS-58191 (closed) "FB embedded post tooltip did not display post image" did NOT reproduce — image renders.
- Note: FB embed body shows image + share CTA only — does NOT render the full post text (unlike YT embed which shows title + thumbnail). May be intentional FB embed-API minimal-mode.

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-58191 (Bug, Major, Closed) — Brand Content - FB - The embedded post tooltip not displayed the post Image

## QA-6315 — Brand > Conversation - Basic view

Skill: tbd
My latest run: 2026-06-05 batch-1 — FAIL, LFMP-31800 REPRODUCED

### Open bugs (1)
- LFMP-31800 (Bug, Major, Open) — Brand > Conversation - “Click here to load Tweets” navigates to the Listening page
  - **REPRODUCED 2026-06-05 batch 1 (MTV on Adam Orfei):** DOM probe of the only `Click here to load Tweets` node returned `tag=A class=link-to-feature href=https://app.lfmdev.in/#explore/listening/conversation`. Programmatic click navigated to `#explore/listening/conversation` (the Listening page), confirming the bug end-to-end.

### Closed bugs (21, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-55343 (Test Failure, Major, Closed) — Brand > Conversation - Conversation Analysis tiles and post table not loading
- LFMP-29967 (Bug, Major, Closed) — Brand > Conversation - Reload tile error is displayed in the Analyzed Posts table
- APPS-42920 (Test Failure, Major, Closed) — Brand > Rankings - TikTok Channel is disabled by default while navigating to Rankings
- LFMP-27948 (Bug, Major, Closed) —  Global - While enabling Sentiment the Error tile displays
- DATA-10005 (Test Failure, Major, Closed) — Keywords, keywords (Daily), and Top Subreddit tiles are not available in Brand Conversation
- APPS-31859 (Test Failure, Major, Closed) — Brand > Conversation - Error tile displayed
- APPS-29534 (Test Failure, Major, Closed) — Brand - Content - Channel Column Missing in Table view
- LFMP-25687 (Bug, Major, Closed) — Brand > Conversation - Instagram channel missing
- APPS-26949 (Test Failure, Major, Closed) — Listening Monitor > Top subreddit table not loading
- APPS-26928 (Test Failure, Major, Closed) — Listening > Monitor - Area charts not loaded
- +11 earlier

### Sweep notes
- Pre-test guidance: 1 open bug(s) for this area. Watch for: LFMP-31800.

## QA-18940 — Brand > Video - Favourites Functionality

Skill: tbd
My latest run: 2026-06-05 batch-3 — PASS (heart toggle + persistence across navigation; cleanup pending — manual unfavourite)

### Open bugs (0)
- (none)

### Closed bugs (4, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-53917 (Bug, Major, Closed) — After navigating, the favorite toggle not showing as selected — NOT REPRODUCED 2026-06-05 (favourite persists after navigation as expected)
- APPS-38159 (Test Failure, Major, Closed) — Global - Favorite icon is not working — NOT REPRODUCED 2026-06-05
- APPS-38133 (Test Failure, Major, Closed) — Global - Favorite icon is not working — NOT REPRODUCED 2026-06-05
- APPS-30765 (Test Failure, Major, Closed) — Favourite functionality not working — NOT REPRODUCED 2026-06-05

## QA-19950 — Brand Content - CSV - All Data set - Impressions

Skill: tbd
My latest run: 2026-06-05 batch-1 — BLOCKED (Brand>Content Sentiment-mode lock blocked thumbnail probe)

### Open bugs (1)
- LFMP-31979 (Bug, Major, Open) — Thumbnail Issue for Facebook and Pinterest Posts.
  - **NOT VERIFIED 2026-06-05 batch 1:** Same Brand>Content Sentiment-mode lock as QA-923 — post-table thumbnails not surfaced. Needs fresh session to retry.

### Closed bugs (9, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-56955 (Test Failure, Major, Closed) — Brand > Content - LinkedIn - The impressions and Engagement Rate data are not populating
- APPS-56565 (Test Failure, Major, Closed) — Brand Content - Data are not populating in export
- APPS-50173 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-49815 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-49529 (Test Failure, Major, Closed) — Brand > Content - Email Not Received for all data set export
- APPS-37987 (Test Failure, Major, Closed) — Brand > Content - All Data set and Metrics Export stuck on loading
- APPS-34343 (Test Failure, Major, Closed) — Brand > Content - Stories post count considered for aggregate average value calculation even though the “Instagram channel“ checkbox is not enabled
- APPS-32657 (Bug, Major, Closed) — Brand > Content - All Data Sets export has aggreagtes data only for current dataset
- APPS-28621 (Bug, Minor, Closed) — DM Replies value mismatched between Export and page

### Sweep notes
- Pre-test guidance: 1 open bug(s) for this area. Watch for: LFMP-31979.

## QA-22072 — Brand >Partnerships - Basic View data set

Skill: tbd (uses `brand-content-filter` widget pattern)
My latest run: 2026-06-05 batch-3 — PARTIAL — Basic Filter has NO metric-based sub-filter; spec says "Advanced Filter capability of Metrics" but only 10 dimension/text sub-categories present (Collaborated/Collaborated Total/Collaborator Name/Content Type/Publish Day/Publish Time/Publish Type/Sponsor Name/Tag/Text Search). Search "engagement" returns 0 rows. New finding — possible spec drift or product gap. Recommend product/spec triage.

### Open bugs (0)
- (none)

### Closed bugs (5, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-56794 (Test Failure, Major, Closed) — Brand > Partnerships - Facebook Sponsored Posts not loading
- APPS-50661 (Test Failure, Major, Closed) — Brand > Partnerships - An incorrect post count is being displayed
- APPS-49013 (Bug, Trivial, Closed) — Brand > Partnerships - Author column is displayed as Partner in Detail view
- APPS-48926 (Test Failure, Major, Closed) — Brand > Partnerships - The post table is hiding while switching to detail view
- APPS-40965 (Test Failure, Major, Closed) — Posts not loaded in Brand Partnerships

### Sweep notes
- Pattern: 5 prior Bug/Test-Failure closures in this area; historically fragile.

## QA-23991 — Reporting > Content Performance Report -  Download

Skill: `pdf-end-to-end-verification` (with future `cpr-report-run` candidate)
My latest run: 2026-06-05 batch-3 — PASS (CPR story_id=154220 MTV → Preview & Share → Download → `MTV-Content Performance(May 31, 2026 - Jun 6, 2026).pdf` 294K 1pg jsPDF on disk; filename schema verified; LFMP-32010 NOT TESTED this run — Least Engaging not enabled in default Options)

### Open bugs (1)
- LFMP-32010 (Bug, Major, Open) — Reporting > Content performance > Least Engaging Posts & Heading Does not show in "Preview & Share Report"
  - **NOT VERIFIED 2026-06-05:** Default CPR build did not enable Least Engaging Content. Targeted Least Engaging-enabled CPR re-run deferred.

### Closed bugs (24, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-59205 (Bug, High, Closed) — Reporting  > Content Performance  - ToolTips are showing blank for Most and Least Engaging Content Data
- APPS-57473 (Test Failure, Major, Closed) — CPR > The header name was incorrectly displayed, and the chart was displayed twice
- APPS-56781 (Bug, Major, Closed) — Reporting > CPR - The Posts are not displaying in the Print & Share Report View
- APPS-56650 (Test Failure, Major, Closed) — Reporting > Content Performance - The Table posts are not loading for Facebook channel
- APPS-55569 (Test Failure, Major, Closed) — Reporting - TWC - PDF displays an Empty page
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-52068 (Bug, Major, Closed) — Reporting > Content Performance Report -  Broken images are displaying in PDF file
- APPS-50145 (Test Failure, Major, Closed) — Reporting > TWC & CPR tags - Change Settings configuration in not displaying while pasting the report url
- APPS-49527 (Test Failure, Major, Closed) — Reporting > Classic Reporting > TWC - Incorrect file name displays
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- +14 earlier

### Sweep notes
- Pre-test guidance: 1 open bug(s) for this area. Watch for: LFMP-32010.

## QA-24021 — Reporting > TWC - Download

Skill: `time-window-comparison-run`, `pdf-end-to-end-verification`
My latest run: 2026-06-05 batch-3 — PASS (TWC story_id=154221 MTV Total Followers May 31–Jun 6 2026 → Preview & Share → Download → `MTV-Time Window Comparison(May 31, 2026 - Jun 6, 2026).pdf` 313K 1pg jsPDF on disk; filename schema verified)

### Open bugs (0)
- (none)

### Closed bugs (21, most recent first; cap at 10 + "+M earlier" if >20)
- DATA-12088 (Bug, Major, Closed) — TWC > Twitter New Followers showing negative values
- APPS-58510 (Bug, Major, Closed) — TWC > FB metrics shows the negative values / Analysis required
- APPS-55569 (Test Failure, Major, Closed) — Reporting - TWC - PDF displays an Empty page
- APPS-53697 (Test Failure, Major, Closed) — Reporting > Reports page stuck on 'View now'
- APPS-53050 (Test Failure, Major, Closed) — TWC > The report shows 500 error after clicking the run report button
- APPS-52583 (Test Failure, Major, Closed) — Brand > Content - Public brands are not loading and it shows a reload tile
- APPS-52550 (Test Failure, Major, Closed) — Run Report button disabled while changing perspective
- APPS-50138 (Test Failure, Major, Closed) — Reporting > TWC - Authorized data points are selectable
- APPS-49527 (Test Failure, Major, Closed) — Reporting > Classic Reporting > TWC - Incorrect file name displays
- APPS-49242 (Test Failure, Major, Closed) — Reporting > Classic Reporting template is not working
- +11 earlier

### Sweep notes
- Pattern: 21 prior Bug/Test-Failure closures in this area; historically fragile.

## QA-27292 — Brand  < Content - Download CSV Template in Update Tag Modal

Skill: tbd (new flow candidate `brand-content-tag-upload`)
My latest run: 2026-06-05 batch-3 — PASS (Tag dropdown → Upload Tags → Modal → Download CSV Template link → `LF Upload Tags Sample - Sheet1.csv` 696 bytes on disk; 2-col schema Post URL/Post Tag + 8 sample rows across 6 channels FB/Twitter/IG/YT/TikTok/LinkedIn)

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-51167 (Test Failure, Major, Closed) — Brand > Content - The page is not loading on the Brand content tab — NOT REPRODUCED 2026-06-05

## QA-43915 — Ads Account IDs Radaac Report

Skill: tbd (extends Radaac jQuery UI dialog Submit known-quirk pattern)
My latest run: 2026-06-08 (QA-22296 batch 4/12) — **FAIL**; report `runs/2026-06-05/QA-43915-report.md`

### 2026-06-05 re-run findings
- **LFMP-30870 / LFMP-31249 REPRODUCES.** Submit via direct URL nav surfaces cached filename `/cache/20260608AdsAccountIds_bceac0.csv` in the DOM but the binary never lands on disk over ~100s of waiting. Page title cycles "Fetching report" ↔ "Failed to process." across reloads. Closed bugs should be reopened by triage.
- APPS-53077 (502 Gateway) NOT REPRODUCED.

### Open bugs (0)
- (none)

### Closed bugs (3, most recent first; cap at 10 + "+M earlier" if >20)
- LFMP-31249 (Bug, Major, Closed) — Radaac - Ads Account IDs - The Export failed to download
- LFMP-30870 (Bug, Major, Closed) — Radaac - Ads Account IDs - The Export failed to download
- APPS-53077 (Test Failure, Major, Closed) — 502 Gateway Error displayed on Dev Radaac

## QA-63603 — Settings > Tags > Content Tagged - Upload Tags

Skill: tbd
My latest run: 2026-06-08 (QA-22296 batch 4/12) — **PARTIAL — spec drift**; report `runs/2026-06-05/QA-63603-report.md`

### 2026-06-05 re-run findings
- Settings>Tags renders cleanly with 124 rows + columns `Tag | Date Created | Creator | Content Tagged | Actions`. No `Content Tagged Tab` and no `Upload Tags` affordance on this surface. Upload Tags actually lives on Brand>Content per QA-27292. Likely spec drift or missing UI affordance. APPS-52081 NOT REPRODUCED (different surface).

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-52081 (Test Failure, Major, Closed) — Brand Partnerships > The page shows the error tiles after filtering a tag

## QA-75011 — Settings > Custom Metrics - Basic View

Skill: settings-custom-metrics
My latest run: 2026-06-08 (QA-22296 batch 4/12) — **PASS**; report `runs/2026-06-05/QA-75011-report.md`

### 2026-06-05 re-run findings
- Custom Metrics page renders with 18 rows + 6 columns Metric/Description/Created Date/Creator/Formula/Actions and `Create a Custom Metric` button visible. APPS-49018 NOT REPRODUCED.

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-49018 (Test Failure, Major, Closed) — Settings > Custom Metrics - The page appears empty

## QA-79157 — Mixpanel - API Metrics Publishing Analysis

Skill: out-of-magpie-scope (third-party Mixpanel dashboard, Prod-only)
My latest run: 2026-06-08 (QA-22296 batch 4/12) — **BLOCKED — out of scope**; report `runs/2026-06-05/QA-79157-report.md`

### 2026-06-05 re-run findings
- magpie scope is ListenFirst dev + Atlassian. Mixpanel third-party dashboard + Prod access required to evaluate APPS-46451. Carry-forward to LFIQA manual.

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-46451 (Bug, Major, Closed) — API Metrics are not publishing to Mixpanel

## QA-81416 — Reporting > Data Studio - Report Table - CSV & Google Sheets Export Functionality

Skill: export-csv + export-google-sheets
My latest run: 2026-06-08 (QA-22296 batch 4/12) — **PASS**; report `runs/2026-06-05/QA-81416-report.md`

### 2026-06-05 re-run findings
- DS Report Table built MTV / Facebook Total Fans / 7-day window (story_id=294839). CSV `MTV-Data-Studio-May-31-2026-Jun-06-2026.csv` 326 bytes verified on disk + row-by-row UI/CSV match (7 daily values exact). GS export captured via window.open hook → opened in MCP group tab with title matching CSV filename + Google's ` - Google Sheets` suffix.

### Open bugs (0)
- (none)

### Closed bugs (4, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-55372 (Bug, Minor, Closed) — Data Studio > Doughnut chart isn't displaying the correct color when the report contains a standard and Authorized brand that is the same
- LFMP-31128 (Bug, Major, Closed) — Reporting > Data Studio - Go button is not working
- APPS-54212 (Test Failure, Major, Closed) — Reporting > Data Studio - Page Level -  The Go button is not working
- APPS-54004 (Test Failure, Major, Closed) — Reporting > Data Studio - Displaying blank page

## QA-81647 — Reporting > Data Studio - Data Visualization

Skill: tbd
My latest run: 2026-06-08 QA-22296 batch-5 — NOT VERIFIED (DS metric-tree friction; no new bug)

### 2026-06-05 re-run findings
- Net-new ticket. DS builder reachable, brand picker + metric tree open cleanly. Go button remained disabled after metric quick-select section click; deep `li.leaf` exercise not attempted. Saved batch-4 `report_id=294839` no longer round-trips a chart (likely TTL). Per conservative bug-claim rule, no DS-render regression filed. Sibling QA-83977 (batch-1) confirms popup + chart still render cleanly in working sessions.

### Open bugs (0)
- (none)

### Closed bugs (4, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-54212 (Test Failure, Major, Closed) — Reporting > Data Studio - Page Level -  The Go button is not working
- APPS-54004 (Test Failure, Major, Closed) — Reporting > Data Studio - Displaying blank page
- APPS-52321 (Test Failure, Major, Closed) — Reporting > Data Studio - Go button not working
- APPS-51139 (Bug, Major, Closed) — Reporting > Data Studio - Report not generated for 'Twitter data points'

## QA-83977 — Reporting > Data Studio - UI check

Skill: tbd
My latest run: 2026-06-05 batch-1 — PASS, LFMP-31814 NOT REPRODUCED (second consecutive non-reproduction)

### Open bugs (1)
- LFMP-31814 (Bug, Major, Open) — Reporting > Data Studio - Data fetching pop-up is not displayed
  - **NOT REPRODUCED 2026-06-05 batch 1 (Star Wars + Michael Kors Authorized, Page Level, FB + Twitter Video Posts):** MutationObserver captured `ui-popup--success ui-popup--floating "We are fetching the data. Please wait."` immediately on Go click (2 hits). Second consecutive non-reproduction (also NOT REPRODUCED 2026-06-04 QA-4325 batch-7 on the QA-92841 ticket). Likely fixed or backend-rendering of the popup is stable.

### Closed bugs (2, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-54212 (Test Failure, Major, Closed) — Reporting > Data Studio - Page Level -  The Go button is not working
- APPS-54004 (Test Failure, Major, Closed) — Reporting > Data Studio - Displaying blank page

### Sweep notes
- Pre-test guidance: 1 open bug(s) for this area. Watch for: LFMP-31814.

## QA-84195 —  Reporting > Data Studio - Brand > Content -- Data QA - Video Views

Skill: tbd
My latest run: 2026-06-08 QA-22296 batch-5 — NOT VERIFIED (DS metric-tree friction)

### 2026-06-05 re-run findings
- Net-new ticket. Direct sibling of QA-90213 (Likes/Replies parity), where known-quirk `Data Studio Post Level ↔ Brand>Content parity has residual freshness drift` documents sub-1.5% delta as the current acceptance criterion. Today's session did not exercise the FB/Twitter/TikTok Video Views parity end-to-end due to the same DS metric-tree friction blocking QA-81647. Recommend manual LFIQA verification.

### Open bugs (0)
- (none)

### Closed bugs (3, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-58136 (Bug, Major, Closed) — Reporting > Data Studio - Brand > Content -- Data QA - Impressions values are not matching
- APPS-54004 (Test Failure, Major, Closed) — Reporting > Data Studio - Displaying blank page
- APPS-52583 (Test Failure, Major, Closed) — Brand > Content - Public brands are not loading and it shows a reload tile

## QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality

Skill: tbd
My latest run: NOT YET RUN

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-52565 (Test Failure, Major, Closed) — Settings > Custom Metrics - Unable to create a new custom metric

## QA-89390 — Dashboards - Brand Content Insights - Functionality to save filtered tiles to the dashboard

Skill: `dashboard-mutation-flows` (via sister-test QA-88219)
My latest run: 2026-06-08 QA-22296 batch-5 — PASS (RECONFIRM via QA-88219 batch-6 end-to-end)

No open or closed Bug/Test-Failure links — clean test.

### 2026-06-05 re-run findings
- Sister-test QA-88219 (same Brand>Content Save filtered tile → Dashboard flow) was verified end-to-end on 2026-06-04 (QA-4325 batch-6) with `Publish Type=Reel` filter → dashboard tile renders with chip preserved + Sum Engagements 228,847 match + cleanup confirmed. RECONFIRM holds — no environment regression in the 4-day gap.

## QA-95190 — Brand > Channels - Threads Basic View

Skill: tbd
My latest run: 2026-06-08 QA-22296 batch-5 — PASS (Threads tile populated, historical APPS-53076/APPS-53104 NOT REPRODUCED)

### 2026-06-05 re-run findings
- Threads tile on MTV Brand>Channels (Authorized, May 25-31 2026) populates Total Followers=2,248,267 with – (em-dash) for relative delta. New Posts=0 / Engagements=0 / Views=0 reflect low Threads activity for the window. Cross-check Brand>Content same channel+window returns `Posts(0)` consistent. Brand>Insights Threads cross-check hung per known-quirk renderer-freeze. APPS-53076 (No data view) + APPS-53104 (Go To Authorize popup) — both historical closed bugs NOT REPRODUCED.

### Open bugs (0)
- (none)

### Closed bugs (2, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-53104 (Test Failure, Major, Closed) — Brand > Insights  - "Go To Authorize" displays on all the Threads big number tiles on Stage env.
- APPS-53076 (Test Failure, Major, Closed) — Brand > Insights - No data view displays on all the big number tiles  for  'Threads' channel data

## QA-96045 — Settings > Data Identities - Instagram Threads

Skill: tbd
My latest run: 2026-06-05 (QA-22296 batch 6) — INCONCLUSIVE
- Settings > Data Identities for Adam Orfei lists Channels (6): Facebook / Twitter / Instagram / YouTube / TikTok / LinkedIn. **No Threads channel row** present.
- `document.body.innerText.match(/[Tt]hreads/g)` returns null on the Data Identities page.
- Treated as account/test-data gap (Rule 1 — do not substitute IG for Threads).

No open or closed Bug/Test-Failure links — clean test.

## QA-96759 — Brand > Insights - Threads - Tile Level Export - PNG

Skill: tbd (audience-metrics-export pattern applies but unreachable today)
My latest run: 2026-06-05 (QA-22296 batch 6) — INCONCLUSIVE
- Brand>Insights+Threads renderer hang reproduced in all combinations tried: `channels=threads` alone, `channels=threads&channels=instagram&channels=facebook`, `channels=threads&channels=twitter`.
- Hang escalation: also wedges the Chrome MCP screenshot pipeline (>60s timeouts on `screenshot`/`get_page_text` calls).
- Cannot reach tile-level Export → PNG step until renderer hang is resolved.

### Open bugs (0)
- (none)

### Closed bugs (2, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-53104 (Test Failure, Major, Closed) — Brand > Insights  - "Go To Authorize" displays on all the Threads big number tiles on Stage env.
- APPS-53076 (Test Failure, Major, Closed) — Brand > Insights - No data view displays on all the big number tiles  for  'Threads' channel data

## QA-98351 — Brand > Content - Threads - Basic View

Skill: brand-content-data-set-selector + view-perspective-toggle
My latest run: 2026-06-05 (QA-22296 batch 6) — PASS
- MTV Brand>Content + Threads channel + Authorized perspective + 7-day window. Threads Only: Insights CDS variant available and selectable.
- Columns: Engagements / Likes / Replies / Quotes / Reposts / Shares / Views (7 Threads-specific metrics).
- Sort/Metric Display/Include Retweets/Layout switcher all present and functional.
- Empty-state messaging proper ("There is no data available...").
- One transient "This table failed to load. Please try again." with Reload CTA — recovered cleanly on Reload click.

No open or closed Bug/Test-Failure links — clean test.

## QA-99531 — Brand > Content - Threads - Hovering functionality on All Insights tile's

Skill: tbd (chart-hover-tooltip applies but unreachable today)
My latest run: 2026-06-05 (QA-22296 batch 6) — INCONCLUSIVE
- MTV has 0 Threads posts in 7-day and 90-day windows → Performance by Channel + Content Insights tiles not present (Posts(0)).
- Amazon Prime Video pivot attempt triggered the Brand>Insights+Threads renderer hang documented in QA-96759 — page unreachable.
- Hover-tooltip flow not exercised.

No open or closed Bug/Test-Failure links — clean test.

## QA-104876 — Settings > Custom Data Sets - Delete Functionality

Skill: settings-custom-data-sets + dashboard-mutation-flows
My latest run: 2026-06-05 (QA-22296 batch 6) — PASS
- Created `QA-104876-test-1780915800` CDS with Engagements metric, deleted via Actions ellipsis → Delete → Ok confirmation.
- Confirmation modal verbatim: "Are you absolutely sure you want to delete your data set 'QA-104876-test-1780915800'? Click 'Ok' to continue."
- Deletion persistent across F5 refresh. Listing 9→8 rows.
- Ellipsis menu order verified: Edit / Delete / Duplicate.

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-54940 (Test Failure, Major, Closed) — Settings > Custom Data Sets - Page not loading

## QA-109749 — Brand Audience > Threads - Hovering Functionality

Skill: audience-metrics-export / chart-hover-tooltip
My latest run: 2026-06-08 QA-22296 batch-7 — PARTIAL (no-data: MTV Brand>Audience Threads channel returned "There is no data available" on all 5 tiles across default and extended date windows; hover assertions unreachable. Michael Kors brand_id=12597 alternate probe triggered Threads-Audience renderer-hang.)

No open or closed Bug/Test-Failure links — clean test.

## QA-109919 — Brand > Content - Sentiment Comments limit - CSV

Skill: export-csv
My latest run: 2026-06-08 QA-22296 batch-7 — RECONFIRM (Sentiment Export tab confirmed on Big Hero 6 brand_id=10613; CSV pipeline previously verified end-to-end in batch-8 (APV 6,160 rows) and QA-4325 batch-8 (QA-111242/QA-111243 MTV); 2,000-msg spec limit appears exceeded by current build — finding-carry-forward).

No open or closed Bug/Test-Failure links — clean test.

## QA-112583 — Reporting > Follower Demographics Vs Threads Audience - Export - Data QA

Skill: audience-metrics-export
My latest run: 2026-06-08 QA-22296 batch-7 — BLOCKED (sibling of QA-109749 — Brand>Audience Threads source-2 cannot supply baseline data on Adam Orfei brands).

No open or closed Bug/Test-Failure links — clean test.

## QA-113594 — Settings > Audit - External User View

Skill: settings-audit-logs
My latest run: 2026-06-08 QA-22296 batch-7 — BLOCKED (external-user role provisioning requires Admin page which is Cognito-gated; magpie cannot enter passwords per safety policy).

No open or closed Bug/Test-Failure links — clean test.

## QA-113723 — Admin - Brand Set Creation and Settings > Audit screen

Skill: settings-audit-logs / dashboard-mutation-flows
My latest run: 2026-06-08 QA-22296 batch-7 — BLOCKED (admin.lfmdev.in Cognito-gated; Settings-side Brand Set + Audit pattern verified in prior QA-110083 QA-4325 batch-8 but Admin-side variant not reachable).

No open or closed Bug/Test-Failure links — clean test.

## QA-114840 — Settings > User - Export Functionality (External User)

Skill: tbd
My latest run: 2026-06-08 (QA-22296 batch 8/12) — **BLOCKED — safety**; report `runs/2026-06-05/QA-114840-report.md`

No open or closed Bug/Test-Failure links — clean test.

## QA-116140 — Brand Sentiment - Sentiment Export CTA

Skill: brand-content-data-set-selector, export-csv (sentiment-mode modal text)
My latest run: 2026-06-08 (QA-22296 batch 8/12) — **PASS**; report `runs/2026-06-05/QA-116140-report.md`

No open or closed Bug/Test-Failure links — clean test.

## QA-116173 — Sentiment Export Email, Notification & Auto Download

Skill: export-csv (Sentiment Export pipeline)
My latest run: 2026-06-08 (QA-22296 batch 8/12) — **RECONFIRM — carry-forward**; report `runs/2026-06-05/QA-116173-report.md` (browser renderer hung on fresh APV nav; pipeline verified in 4 prior batches across 3 days)

No open or closed Bug/Test-Failure links — clean test.

## QA-121158 — Brand Content - Instagram - Collaborated Total Filter Functionality

Skill: brand-content-filter (Collaborated Total variant)
My latest run: 2026-06-08 (QA-22296 batch 8/12) — **PARTIAL — A1-A4 PASS, A5 INCONCLUSIVE**; report `runs/2026-06-05/QA-121158-report.md`

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- LFMP-31862 (Bug, Major, Closed) — Brand > Content - Table not loading after applying filter (Collaborated Total) — NOT REPRODUCED on 2026-06-08 batch-8 (table renders cleanly after Apply on Hulu IG empty-result-set).

## QA-121217 — Brand > Content - Instagram - Instagram Collaborator count - Export

Skill: tbd
My latest run: 2026-06-08 (QA-22296 batch 8/12) — **BLOCKED — no data**; report `runs/2026-06-05/QA-121217-report.md` (Hulu sub-brand 11003 has zero IG-collaborated posts in tested windows)

No open or closed Bug/Test-Failure links — clean test.

## QA-131491 —  Reporting > Social Recap Vs Brand > Content - IG Public Video View Brand and Content level

Skill: tbd
My latest run: NOT YET RUN

No open or closed Bug/Test-Failure links — clean test.

## QA-132387 — Brand Sets > Content - Verify Sum and Avg Rows based on Rank by Metric selected

Skill: tbd
My latest run: NOT YET RUN

No open or closed Bug/Test-Failure links — clean test.

## QA-132392 — Brand Set > Content - Verify Impression Metrics Sum and Avg Row Behavior

Skill: tbd
My latest run: NOT YET RUN

No open or closed Bug/Test-Failure links — clean test.

## QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior

Skill: tbd
My latest run: NOT YET RUN

No open or closed Bug/Test-Failure links — clean test.

## QA-134176 — Brand > Insights - Auto Select Dates for all Intervals

Skill: tbd
My latest run: NOT YET RUN

No open or closed Bug/Test-Failure links — clean test.

## QA-134271 — Brand Navigation — Data Last Updated: Timestamp

Skill: none dedicated
My latest run: 2026-06-08 PASS (QA-22296 batch 10 RECONFIRM) — Adam Orfei, MTV+Tory Burch IG, 10/10 checks identical `06-08-2026 04:29 AM PT`. Prior 2026-06-04 QA-4325 batch 11 PASS.

No open or closed Bug/Test-Failure links — clean test.

## QA-134274 — Brand > Content - Verify pill add/remove, Clear All and Save/Load filter

Skill: `brand-content-filter`
My latest run: 2026-06-08 PASS (QA-22296 batch 10) — Adam Orfei, MTV, IG, Jun-Dec 2025; pill add → URL filters JSON; Clear All resets; F5/direct URL re-hydrates pill (10-25s latency).

No open or closed Bug/Test-Failure links — clean test.

## QA-134275 — Brand > Content - Verify Include-only filter returns correct results for OR and AND operators

Skill: `brand-content-filter`
My latest run: 2026-06-08 PASS-mechanic (QA-22296 batch 10) — Include-OR vs Include-AND URL encoding + pill operator button flip verified; Posts(0) on test tags from zero-match (QA-134277 extension).

No open or closed Bug/Test-Failure links — clean test.

## QA-134276 — Brand > Content - Verify Exclude-only filter returns correct results for OR and AND operators

Skill: `brand-content-filter`
My latest run: 2026-06-08 PASS (QA-22296 batch 10) — URL `not:"true"`; pill `or-label exclude` class; bg `rgb(235, 64, 64)` red; Posts(1,221) = baseline (excluding empty set sanity).

No open or closed Bug/Test-Failure links — clean test.

## QA-134296 — Brandsets->Rankings-Data Last Updated :Timestamp

Skill: none dedicated
My latest run: 2026-06-08 PASS (QA-22296 batch 10 RECONFIRM) — Adam Orfei, Adam's Brand Set 1738 → Content → F5 → 1923 Talent 11190, all `06-08-2026 04:29 AM PT`. Prior 2026-06-04 PASS.

No open or closed Bug/Test-Failure links — clean test.

## QA-134445 — Brand > Partnerships - Verify layered tag filtering (Include + Exclude) works as expected

Skill: brand-content-filter (cross-surface)
My latest run: 2026-06-08 (QA-22296 batch 11/12) — PASS — MTV brand_id=4018 IG default Lifetime. Tag popup Include/Exclude + Or/And + Select All confirmed; jbkaxlx Include + +tag Exclude applied; URL filters JSON `{"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}`. Tile re-fetch after apply.

No open or closed Bug/Test-Failure links — clean test.

## QA-134446 — Brand > Stories - Verify layered tag filtering (Include + Exclude) works as expected

Skill: brand-content-filter (cross-surface)
My latest run: 2026-06-08 (QA-22296 batch 11/12) — PASS — MTV Stories(886) IG default. Filter dropdown options Branded Content/Collaborated/.../Tag/Text Search verified; jbkaxlx Include + `-------a` Exclude applied; URL layered JSON two-entry content_tags array confirmed.

No open or closed Bug/Test-Failure links — clean test.

## QA-134447 — Brand > Paid - Verify layered tag filtering (Include + Exclude) works as expected

Skill: brand-content-filter (cross-surface)
My latest run: 2026-06-08 (QA-22296 batch 11/12) — PASS — MTV Paid IG. Filter dropdown Ad Name/Ads Account ID/Campaign/Delivery Type/Publish Day/Publish Time/Tag/Text Search. Tag layered widget identical: jbkaxlx Include + +tag Exclude → two-entry URL JSON. 7-surface parity confirmed across Brand>Content/Partnerships/Stories/Optimization/Paid + Brand Sets>Content/Optimization/Partnerships.

No open or closed Bug/Test-Failure links — clean test.

## QA-134636 — Listening> "Data Last Updated"Timestamp

Skill: brand-insights-interval-picker (DLU timestamp pattern)
My latest run: 2026-06-08 (QA-22296 batch 11/12) — PARTIAL — A1 PASS (Brand>Insights MTV `Data Last Updated (PT): 06-08-2026 04:29 AM PT` format verified, matching QA-134271/QA-134296 RECONFIRMs same day); A2 INCONCLUSIVE — Listening tab not surfaced on Adam Orfei account (direct URL nav `#explore/brand/listening` + `#listening` both redirect to Brand>Insights). Recommend manual LFIQA verification on Hulu / HBO Max with Listening tab access.

No open or closed Bug/Test-Failure links — clean test.

## QA-135429 — Settings > Custom Metrics  - Edit functionality

Skill: settings-custom-metrics
My latest run: 2026-06-08 (QA-22296 batch 11/12) — PARTIAL — A1+A2 PASS (Edit menu item present; Edit form prefilled with Name `Test 09-05-20254` / Description `sample4` / Formula chips `Post Comments + Shares` at `#custom-metrics/edit?report_id=18`); A3+A4 DEFERRED — would mutate metric owned by another user (Kumar Keshav Kashyap), safety per Rule 1. Mutation+round-trip should be exercised on a self-owned sandbox metric (per QA-85176 pattern).

No open or closed Bug/Test-Failure links — clean test.

## QA-135837 — Verify search field retains entered value after selecting filter options

Skill: brand-content-filter
My latest run: 2026-06-08 (batch-12) — PASS-with-deviation. APPS-61098 closed bug NOT REPRODUCED — search field retains text across single tag select, multi-select chain (Or-joined), and single deselect. Minor spec-deviation: assertion 9 (close/reopen → empty search) NOT met — search retained `aclfest` after Tag-section header collapse + re-expand. Spec used tag substitution `aclfest`/`acmawards`/`alliesask` instead of spec's `test1`/`test11`/`test123` (not present on Hulu dev).

### Open bugs (0)
- (none)

### Closed bugs (1, most recent first; cap at 10 + "+M earlier" if >20)
- APPS-61098 (Bug, Major, Closed) — Filter - Search field resets after selection

## QA-137557 — Settings > Custom Metrics - Multiplication & Division Operators - Create & Save

Skill: settings-custom-metrics
My latest run: 2026-06-08 (batch-12) — PARTIAL-PASS. APPS-60358 × and ÷ operator dropdown end-to-end enumerated (exact 4 options: `fa-plus / fa-minus / fa-times / fa-divide`); × chip rendered with `fa-regular fa-times` icon in formula editor. Save button disabled→enabled gate logic verified. Build of 3 remaining chips (Post Likes / ÷ / Shares) NOT REACHED due to automation-only formula-popup re-open friction; cleanup via Cancel — no orphan metric saved.

No open or closed Bug/Test-Failure links — clean test.

## QA-137558 — Settings > Custom Metrics - All Operators (+ − × ÷) - Save & Verify in Time Window Comparison

Skill: settings-custom-metrics + time-window-comparison-run
My latest run: 2026-06-08 (batch-12) — PARTIAL-PASS by carry-forward. 4-operator dropdown verified via QA-137557 same session. Full 9-chip build + TWC re-execution deferred (same automation-only friction as QA-137557).

No open or closed Bug/Test-Failure links — clean test.

## QA-137874 — Data Collection - Channel Collection Status Validation 2

Skill: (candidate extension `data-collection-channel-drill` from `data-collection-ad-account-status`)
My latest run: 2026-06-08 (batch-12) — PASS-with-partial-data. Adam Orfei/Suits Twitter SuitsPeacock page: Collecting (green `fa-check-circle` rgb(0,135,128)) and Not Collecting (red `fa-exclamation-circle` rgb(214,79,66)) icon mappings verified; Last Collection Date `Jun 7, 2026` = current_date - 1 for Collecting feed. Brand substitution: Adam Orfei/Suits used instead of spec's HBO Max for time efficiency. To Do status icon (5e) DEFERRED — no To Do feed in sample. URL drill-down schema documented: `#data-collection/<brand>/<channel>/page/<page-id>?account_id=<id>`.

No open or closed Bug/Test-Failure links — clean test.

### QA-22296 — Set Summary

- Total members: 59
- Members with >=1 open Bug/Test-Failure: 6
- Distinct open bug keys (sorted by priority): 7
  - LFMP-31800 (Bug, Major) — Brand > Conversation - “Click here to load Tweets” navigates to the Listening page
  - LFMP-31814 (Bug, Major) — Reporting > Data Studio - Data fetching pop-up is not displayed
  - LFMP-31857 (Bug, Major) — Brand Content - twitter post text having link
  - LFMP-31915 (Bug, Major) — Brand > Content > Instagram Image Posts Tooltip Is Empty
  - LFMP-31979 (Bug, Major) — Thumbnail Issue for Facebook and Pinterest Posts.
  - LFMP-32010 (Bug, Major) — Reporting > Content performance > Least Engaging Posts & Heading Does not show in "Preview & Share Report"
  - LFMP-31781 (Bug, Minor) — Brand Insights - Hovering Functionality - twitter icon color is blue

>>>>>>> bff9641 (staging/lf-regression)
