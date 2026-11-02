# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Run date:** 2026-10-27 (Tuesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched via the LFQA account menu) · **Brand:** University of California, Los Angeles (brand_id=127756, exact Tuesday-row brand, no substitution) · **Date range:** app default Oct. 19 – Oct. 25, 2026 (spec names none) · **Data set:** Video Views (`table_data_set=video_views`) · **Channel:** TikTok only (`channels=tiktok`) · **Perspective:** Authorized (default)

**Verdict: PASS (2/2) — on all 7 TikTok posts and the aggregate Sum row, Organic + Unclassified + Paid Views = Video Views, and Engagements / Video Views = Video Response Rate (per post).**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks: no QA-29126 entries (pre-fetched).

## Weekday rotation
Run day = Tuesday. The Description table row is "UCLA, Viacom, Wasserman" / "University of California, Los Angeles, MTV, Gatorade". The first pair (UCLA / University of California, Los Angeles) was used, same as the 2026-10-20 Tuesday run. The case's Notes block lists an older, different rotation, so the Description table was treated as authoritative. Viacom/MTV and Wasserman/Gatorade were not run in this session.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK. Session landed on the app (title "Brand Explorer"). |
| P | Precondition: Tuesday account UCLA. Hovered the LFQA menu, typed "UCLA", clicked the exact `.lfm-ta-option` "UCLA" (not "UCLA Law") | OK. Breadcrumb "ACCOUNT: UCLA", `account_id=799` |
| 1 | Hover Brand in top nav, click Content | OK. `#explore/brand/content?brand_id=127756` |
| 2 | Brand = University of California, Los Angeles (account default, confirmed in `.brand-selector-name`); Data Set dropdown, "Video Views" | OK. `table_data_set=video_views` |
| 3 | Only TikTok: enabled tiktok, clicked every other channel ghost off, verified `.channel-ghost.enabled` = [tiktok], clicked Apply | OK. `channels=tiktok`, `Posts (7)` |
| 4 | Table View; read Organic / Unclassified / Paid Views per post | OK. 7 post rows + Sum/Average row scraped from `table.lfm-table` (`Rank` header present) |
| 5 | Read Engagements and Video Views per post | OK |

## Data scraped (Table View, TikTok, Oct 19–25 2026)
| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 375 | 3,131 | – | – | 3,131 | 3,131 | 11.98% | 11.977% |
| 2 | 336 | 2,819 | – | – | 2,819 | 2,819 | 11.92% | 11.919% |
| 3 | 216 | 2,777 | – | – | 2,777 | 2,777 | 7.78% | 7.778% |
| 4 | 96 | 1,794 | – | – | 1,794 | 1,794 | 5.35% | 5.351% |
| 5 | 90 | 1,839 | – | – | 1,839 | 1,839 | 4.89% | 4.894% |
| 6 | 89 | 1,439 | – | – | 1,439 | 1,439 | 6.18% | 6.185% |
| 7 | 81 | 1,910 | – | – | 1,910 | 1,910 | 4.24% | 4.241% |
| Sum | 1,283 | 15,709 | – | – | 15,709 | 15,709 | N/A | 8.167% |

"–" in Organic/Paid Views is treated as 0 (skill `brand-content-grid-math`). All TikTok views are classified as Unclassified.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic + Unclassified + Paid Views = Video Views, in each grid post | 7/7 posts match exactly (0 mismatches, 0 skipped). Aggregate Sum row: 0 + 0 + 15,709 = 15,709 = Video Views 15,709. The per-post Video Views also add up to the Sum row (3,131+2,819+2,777+1,794+1,839+1,439+1,910 = 15,709). | PASS |
| A5 | 5 | Engagements / Video Views = Video Response Rate | 7/7 posts match the 2-decimal display (see table above; max deviation < 0.005 pp). The Engagements column also sums to the Sum row (375+336+216+96+90+89+81 = 1,283). The Sum row's Video Response Rate renders "N/A" (not computed for the aggregate; calc 1,283/15,709 = 8.17%). This is not a per-post assertion and is noted only. | PASS |

## Evidence
- `.playwright-out/QA-29126/01-content-initial.png`: UCLA / University of California, Los Angeles, Public data set, all channels, before changes
- `.playwright-out/QA-29126/02-tiktok-videoviews.png`: Video Views data set, TikTok only, `Posts (7)`
- `.playwright-out/QA-29126/03-table-view.png`: Table View
- Numbers were read directly from the `table.lfm-table` DOM. The identities were checked by hand from the scraped values above. Final URL carried `channels=tiktok` and `table_data_set=video_views`.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29126 entries. Nothing reproduced that interferes with the assertions.

## Bugs filed
None.

## Notes for harvest
- Flow covered by existing skill `brand-content-grid-math` (data set → channel → Apply → Table View scrape). This run is a second-day data point (UCLA, TikTok, Video Views data set).
- The TikTok Video Views data set shows Organic/Paid Views as "–" with all views in Unclassified; the Sum row Video Response Rate is "N/A". This matches the 2026-10-20 run.
- Helper note: loading `devprod-helpers.js` after setting `ctx._creds` also logs into a prod tab. That was unneeded for this dev-only case, and the prod tab was left idle and unused.
