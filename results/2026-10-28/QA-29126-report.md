# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Run date:** 2026-10-28 (Wednesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** Apple Services (account_id=409, switched via the account menu) · **Brand:** Apple Music (brand_id=31783, exact Wednesday-row brand, no substitution) · **Date range:** app default Oct. 20 – Oct. 26, 2026 (spec names none) · **Data set:** Video Views (`table_data_set=video_views`) · **Channel:** TikTok only (`channels=tiktok`) · **Perspective:** Authorized (`perspective=extended`, app default, not changed)

**Verdict: PASS (2/2) — on all 18 TikTok posts that have Video Views, and on the aggregate Sum row, Organic + Unclassified + Paid Views = Video Views. Engagements / Video Views = Video Response Rate on all 15 posts where a rate is displayed. Two edge-case rows are noted below.**

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks: no QA-29126 entries (pre-fetched). One extra grep of known-quirks for "response rate" found nothing relevant to the "–" rate cells below.

## Weekday rotation
Run day = Wednesday. The Description table row is "Apple Services, NBCU EnterPrises" / "Apple Music, CNBC, NBC News". The first pair (Apple Services / Apple Music) was used, following the earlier runs (Tuesday 10-27 used the first pair, UCLA). The case's Notes block lists an older, different rotation, so the Description table was treated as authoritative. NBCU Enterprises / CNBC and NBC News were not run in this session.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK. Landed on `#home` (title "Home - ListenFirst: Home"). |
| P | Precondition: Wednesday account Apple Services. Hovered the account menu, typed "Apple Services", clicked the exact option under "Results" | OK. Breadcrumb "ACCOUNT: APPLE SERVICES", `account_id=409` |
| 1 | Hover Brand in top nav, click Content | OK. `#explore/brand/content?brand_id=31783` |
| 2 | Brand = Apple Music (account default, confirmed in `.brand-selector-name`); Data Set dropdown, "Video Views" | OK. `table_data_set=video_views` |
| 3 | Only TikTok: clicked tiktok on, every other channel ghost off, verified `.channel-ghost.enabled` = [tiktok], clicked Apply | OK. `channels=tiktok`, `Posts (20)` |
| 4 | Table View; read Organic / Unclassified / Paid Views per post | OK. 20 post rows + Sum/Average row scraped from `table.lfm-table` (`Rank` header present) |
| 5 | Read Engagements and Video Views per post | OK |

## Data scraped (Table View, TikTok, Oct 20–26 2026)
| Rank | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | 127,051 | 918,431 | – | – | 918,431 | 918,431 | 13.83% | 13.833% |
| 2 | 70,382 | 580,725 | – | – | 580,725 | 580,725 | 12.12% | 12.120% |
| 3 | 18,862 | 158,756 | – | – | 158,756 | 158,756 | 11.88% | 11.881% |
| 4 | 6,517 | 73,461 | – | – | 73,461 | 73,461 | 8.87% | 8.871% |
| 5 | 2,518 | 28,883 | – | – | 28,883 | 28,883 | 8.72% | 8.718% |
| 6 | 1,048 | 15,029 | – | – | 15,029 | 15,029 | 6.97% | 6.973% |
| 7 | 670 | 12,229 | – | – | 12,229 | 12,229 | 5.48% | 5.479% |
| 8 | 650 | 9,653 | – | – | 9,653 | 9,653 | 6.73% | 6.734% |
| 9 | 280 | 7,251 | – | – | 7,251 | 7,251 | 3.86% | 3.862% |
| 10 | 276 | 13,366 | – | – | 13,366 | 13,366 | 2.06% | 2.065% |
| 11 | 266 | 5,551 | – | – | 5,551 | 5,551 | 4.79% | 4.792% |
| 12 | 236 | 5,728 | – | – | 5,728 | 5,728 | 4.12% | 4.120% |
| 13 | 195 | 7,921 | – | – | 7,921 | 7,921 | 2.46% | 2.462% |
| 14 | 183 | 4,441 | – | – | 4,441 | 4,441 | 4.12% | 4.121% |
| 15 | 151 | 10,540 | – | – | 10,540 | 10,540 | 1.43% | 1.433% |
| 16 | 0 | – | – | – | – | no data | – | n/a |
| 17 | 0 | – | – | – | – | no data | – | n/a |
| 18 | 0 | – | – | – | – | no data | – | n/a |
| 19 | 0 | 3 | – | – | 3 | 3 | – | 0.000% |
| 20 | 0 | 2 | – | – | 2 | 2 | – | 0.000% |
| Sum | 229,285 | 1,851,970 | – | – | 1,851,970 | 1,851,970 | N/A | 12.381% |

"–" in Organic/Paid Views is treated as 0 (skill `brand-content-grid-math`). All TikTok views are classified as Unclassified. Rows 16–18 have "–" for Video Views itself, so they count as "no data" and are skipped.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic + Unclassified + Paid Views = Video Views, in each grid post | 17/17 posts with a numeric Video Views value match exactly (ranks 1–15, 19, 20; 0 mismatches). 3 posts (ranks 16–18) skipped because Video Views is "–" (no data). Aggregate Sum row: 0 + 0 + 1,851,970 = 1,851,970 = Video Views 1,851,970. The per-post Video Views also add up to the Sum row. | PASS |
| A5 | 5 | Engagements / Video Views = Video Response Rate | 15/15 posts with a displayed rate match the 2-decimal display (max deviation 0.0051 pp, ranks 10 and 14 are exact ties at the rounding boundary, 2.065 → 2.06 and 4.121 → 4.12). The Engagements column also sums to the Sum row (229,285). The Sum row's Video Response Rate renders "N/A" (not computed for the aggregate; calc 229,285 / 1,851,970 = 12.38%); this is not a per-post assertion and is noted only. Ranks 19 and 20 are not evaluable (see observation 1). | PASS (with observation) |

## Observations (not counted as failures)
1. **Ranks 19 and 20:** Engagements 0 with Video Views 3 and 2. Mathematically 0 / 3 = 0%, but the Video Response Rate cell shows "–", not "0.00%". Ranks 16–18 (Engagements 0, Video Views "–") also show "–". The app appears to render "–" for the rate whenever Engagements is 0. Per the skill convention ("–" = no data) these two rows were treated as not evaluable. If the reviewer wants "0 engagements" to read as "0.00%", this is a possible display inconsistency worth a look; it was not filed as a bug, because the posts are tiny, brand-new placeholders (all published Oct. 25 10:37 PM PDT or Oct. 26) and no spec text says how zero-engagement posts should render.
2. **Ranks 16–18** have no Video Views at all (collection not yet populated), published at the same timestamp (Sun Oct. 25, 10:37 PM PDT).

## Evidence
- `.playwright-out/QA-29126/00-account-switched.png`: Apple Services account selected
- `.playwright-out/QA-29126/01-content-initial.png`: Apple Music, Public data set, all channels, before changes (`Posts (60)`)
- `.playwright-out/QA-29126/02-tiktok-videoviews.png`: Video Views data set, TikTok only, `Posts (20)`
- `.playwright-out/QA-29126/03-table-view.png`: Table View
- Numbers were read directly from the `table.lfm-table` DOM (headers: Rank, Date, Channel, …, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, …). The identities were then recomputed in a script from the scraped values above. Final URL carried `channels=tiktok` and `table_data_set=video_views`.
- Console showed the usual dev app errors (see `.playwright-out/console-2026-10-28T07-05-21-520Z.log`); none affected the table.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29126 entries. Nothing reproduced that interferes with the assertions.

## Bugs filed
None.

## Notes for harvest
- Flow covered by existing skill `brand-content-grid-math` (data set → channel → Apply → Table View scrape). This run is another data point (Apple Services / Apple Music, TikTok, Video Views data set, Wednesday).
- The TikTok Video Views data set shows Organic/Paid Views as "–" with all views in Unclassified; the Sum row Video Response Rate is "N/A". This matches the 10-20, 10-26 and 10-27 runs.
- New edge case for the skill's judging rules: a row with Engagements 0 renders Video Response Rate "–" even when Video Views is a positive number (observation 1).
- Helper note: `devprod-helpers.js` was loaded with no `ctx._creds` (so no prod tab was opened), then `ctx._creds` was set and `m.login` was called on the single dev page. This avoids the unneeded prod login. `require`/`import('fs')` are not available inside `browser_run_code_unsafe`, so the password has to be passed in by the caller.
