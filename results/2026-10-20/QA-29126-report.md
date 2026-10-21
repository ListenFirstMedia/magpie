# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Run date:** 2026-10-20 (Tuesday) · **Track:** Playwright MCP, unattended `claude -p` · **Account:** UCLA (account_id=799, switched from the initial account via the LFQA menu) · **Brand:** University of California, Los Angeles (brand_id=127756 — the exact Tuesday-row brand; no substitution) · **Date range:** app default Oct. 12 – Oct. 18, 2026 (spec names none) · **Data set:** Video Views (`table_data_set=video_views`) · **Channel:** TikTok only (`channels=tiktok`) · **Perspective:** Authorized (default)

**Verdict: PASS (2/2) — on all 7 TikTok posts and the aggregate Sum row, Organic + Paid + Unclassified Views = Video Views, and Engagements / Video Views = Video Response Rate (per-post).**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). No entries for QA-29126 in bug-history / known-quirks.

## Weekday rotation
Run day = Tuesday → Description table row "UCLA, Viacom, Wasserman" / "University of California, Los Angeles, MTV, Gatorade". First pair used: account UCLA, brand University of California, Los Angeles. (The case's Notes block lists a different, older rotation; the Description table was treated as authoritative.)

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — `#home` |
| P | Precondition: Tuesday account UCLA — hover LFQA menu, type "UCLA", click `.lfm-ta-option` "UCLA" (not "UCLA Law") | OK — `account_id=799`, breadcrumb "ACCOUNT: UCLA" |
| 1 | Hover Brand in top nav, click Content | OK — `#explore/brand/content?brand_id=127756` |
| 2 | Brand = University of California, Los Angeles (account default, header confirmed in screenshot); Data Set dropdown → "Video Views" | OK — `table_data_set=video_views` |
| 3 | Only TikTok: clicked facebook/twitter/instagram/linkedin ghosts off, verified `.channel-ghost` states (only `tiktok enabled`), clicked Apply | OK — `channels=tiktok`, `Posts (7)` |
| 4 | Table View; read Organic / Unclassified / Paid Views per post | OK — 7 post rows + Sum/Average row scraped from `table.lfm-table` |
| 5 | Read Engagements and Video Views per post | OK |

## Data scraped (Table View, TikTok, Oct 12–18 2026)
| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 132 | 1,943 | – | – | 1,943 | 1,943 | 6.79% | 6.7936% |
| 2 | 127 | 1,488 | – | – | 1,488 | 1,488 | 8.53% | 8.5349% |
| 3 | 127 | 2,036 | – | – | 2,036 | 2,036 | 6.24% | 6.2377% |
| 4 | 100 | 1,384 | – | – | 1,384 | 1,384 | 7.23% | 7.2254% |
| 5 | 100 | 1,664 | – | – | 1,664 | 1,664 | 6.01% | 6.0096% |
| 6 | 89 | 1,544 | – | – | 1,544 | 1,544 | 5.76% | 5.7642% |
| 7 | 80 | 1,454 | – | – | 1,454 | 1,454 | 5.50% | 5.5021% |
| Sum | 755 | 11,513 | – | – | 11,513 | 11,513 | N/A | 6.5578% |

"–" in Organic/Paid Views treated as 0 (per skill `brand-content-grid-math`); all TikTok views are classified as Unclassified.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic + Unclassified + Paid Views = Video Views, in each grid post | 7/7 posts match exactly (0 mismatches, 0 skipped). Aggregate Sum row: 0 + 0 + 11,513 = 11,513 = Video Views 11,513; the Video Views column also adds up across posts (1,943+1,488+2,036+1,384+1,664+1,544+1,454 = 11,513). | PASS |
| A5 | 5 | Engagements / Video Views = Video Response Rate | 7/7 posts within ±0.005 pp of the 2-decimal display (all rates in the table above). Engagements column also sums (132+127+127+100+100+89+80 = 755 = Sum row). Sum row's Video Response Rate renders "N/A" (not computed for the aggregate; calc 755/11,513 = 6.56%) — not a per-post assertion, noted only. | PASS |

## Evidence
- `.playwright-out/QA-29126/01-content-initial.png` — UCLA / University of California, Los Angeles, Public data set, all channels, before changes
- `.playwright-out/QA-29126/02-tiktok-videoviews.png` — Video Views data set, TikTok only, `Posts (7)`
- `.playwright-out/QA-29126/03-table-view.png` — Table View
- Numbers read directly from the `table.lfm-table` DOM (headers include `Rank`); identities evaluated in page JS.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29126 entries. Nothing reproduced that interferes with the assertions. Console showed generic app errors only (not related to the tested values). A Facebook "Posts Insights Disruption" banner was visible on the page but does not affect the TikTok-only view.

## Bugs filed
None.

## Notes for harvest
- Flow covered by existing skill `brand-content-grid-math` (data set → channel → Apply → Table View scrape); this run was a new data point (UCLA, TikTok, Video Views data set). TikTok Video Views data set shows Organic/Paid Views as "–" with all views in Unclassified; Sum row Video Response Rate is "N/A".
