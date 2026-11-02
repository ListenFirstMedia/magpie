# QA-29125 — Brand Content - Video Views Dataset - Data Test - (Twitter and Instagram)

**Run date:** 2026-10-28 (Wednesday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** Apple Services (account_id=409, switched via the account menu) · **Brand:** Apple Music (brand_id=31783, exact Wednesday-row brand, no substitution) · **Date range:** app default Oct. 20 – Oct. 26, 2026 (spec names none) · **Data set:** Video Views (`table_data_set=video_views`) · **Perspective:** Authorized (`perspective=extended`, app default, not changed)

**Verdict: PASS (4/4).** On both Twitter-only (3 posts) and Instagram-only (15 posts), Organic + Unclassified + Paid Views = Video Views on every post and on the aggregate Sum row, and Engagements / Video Views = Video Response Rate on every post.

## Pre-screen (Rule 7)
Case file "Open linked bugs": none open. `results/open-bugs-2026-10-28.json` has no QA-29125 entry. The screen passed and the case was run. The pre-fetched bug-history and known-quirks greps had no QA-29125 entries.

## Weekday rotation
Run day is Wednesday. The Description table row is "Apple Services, NBCU EnterPrises" / "Apple Music, CNBC, NBC News". I used the first pair (Apple Services / Apple Music), consistent with the sibling QA-29126 run today. The case's Notes block lists an older, different rotation ("Wed Apple Services/Wasserman"), so the Description table was treated as authoritative. NBCU Enterprises / CNBC / NBC News were not run in this session.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK. Landed on `#home`. |
| P | Account precondition: hovered account menu, typed "Apple Services", clicked the exact option under "Results" | OK. Header `ACCOUNT: APPLE SERVICES`, `account_id=409` |
| 1 | Hover Brand in the top nav, click Content | OK. `#explore/brand/content?brand_id=31783`. The page sat on "Loading" for more than 5 minutes (`02a`/`02b`). Per the step budget I did one reload+retry, and it rendered (`Posts (60)`, `02c`). |
| 2 | Brand = Apple Music (confirmed in `.brand-selector-name`); Data Set dropdown, "Video Views" | OK. `table_data_set=video_views` |
| 3 | Only Twitter: clicked twitter on, every other channel ghost off, verified `.channel-ghost.enabled` = [twitter], clicked Apply | OK. `channels=twitter`, `Posts (3)` (`03-twitter.png`) |
| 4 | Table View; read Organic / Unclassified / Paid Views per post | OK. 3 rows + Sum row (`04-twitter-table.png`) |
| 5 | Read Engagements and Video Views per post | OK |
| 6 | Only Instagram: clicked instagram on, twitter off, verified enabled = [instagram], Apply | OK. `channels=instagram`, `Posts (15)` |
| 7 | Table View; read Organic / Unclassified / Paid Views per post | OK. 15 rows + Sum row (`05-instagram-table.png`) |
| 8 | Read Engagements and Video Views per post | OK |

## Data scraped
"–" in Paid Views means no paid component (treated as 0). The Unclassified column shows 0.

### Twitter only (Oct 20–26, 2026)
| Rank | Posted (PDT) | Engagements | Video Views | Organic | Paid | Unclassified | O+P+U | Rate shown | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Wed Oct 21, 08:01 AM | 32,414 | 695,302 | 695,302 | – | 0 | 695,302 | 4.66% | 4.662% |
| 2 | Wed Oct 21, 08:15 AM | 21,428 | 354,842 | 354,842 | – | 0 | 354,842 | 6.04% | 6.039% |
| 3 | Mon Oct 26, 06:50 PM | 7,636 | 4,724,483 | 4,724,483 | – | 0 | 4,724,483 | 0.16% | 0.162% |
| Sum | | 61,478 | 5,774,627 | 5,774,627 | – | 0 | 5,774,627 | N/A | 1.065% (not displayed) |

### Instagram only (Oct 20–26, 2026)
| Rank | Posted (PDT) | Engagements | Video Views | Organic | Paid | Unclassified | Rate shown | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|
| 1 | Mon Oct 26, 06:52 PM | 572,195 | 14,738,589 | 14,738,589 | – | 0 | 3.88% | 3.882% |
| 2 | Wed Oct 21, 08:15 AM | 283,288 | 4,703,347 | 4,703,347 | – | 0 | 6.02% | 6.023% |
| 3 | Wed Oct 21, 08:01 AM | 191,627 | 4,225,047 | 4,225,047 | – | 0 | 4.54% | 4.535% |
| 4 | Wed Oct 21, 05:07 PM | 38,202 | 513,431 | 513,431 | – | 0 | 7.44% | 7.441% |
| 5 | Thu Oct 22, 08:03 AM | 29,706 | 551,425 | 551,425 | – | 0 | 5.39% | 5.387% |
| 6 | Tue Oct 20, 02:00 PM | 15,653 | 352,883 | 352,883 | – | 0 | 4.44% | 4.436% |
| 7 | Thu Oct 22, 06:57 PM | 6,592 | 136,541 | 136,541 | – | 0 | 4.83% | 4.828% |
| 8 | Thu Oct 22, 06:34 PM | 4,688 | 113,347 | 113,347 | – | 0 | 4.14% | 4.136% |
| 9 | Thu Oct 22, 07:13 PM | 4,305 | 118,940 | 118,940 | – | 0 | 3.62% | 3.619% |
| 10 | Fri Oct 23, 05:00 PM | 4,117 | 141,609 | 141,609 | – | 0 | 2.91% | 2.907% |
| 11 | Thu Oct 22, 11:31 AM | 2,994 | 89,881 | 89,881 | – | 0 | 3.33% | 3.331% |
| 12 | Mon Oct 26, 08:50 PM | 2,375 | 49,637 | 49,637 | – | 0 | 4.78% | 4.785% |
| 13 | Thu Oct 22, 04:02 PM | 1,836 | 78,150 | 78,150 | – | 0 | 2.35% | 2.349% |
| 14 | Thu Oct 22, 05:06 PM | 1,608 | 116,031 | 116,031 | – | 0 | 1.39% | 1.386% |
| 15 | Mon Oct 26, 09:11 PM | 817 | 35,333 | 35,333 | – | 0 | 2.31% | 2.312% |
| Sum | | 1,160,003 | 25,964,191 | 25,964,191 | – | 0 | N/A | 4.468% (not displayed) |

The Sum row Engagements and Video Views equal the column totals of the rows, which I computed in page JS (Instagram: E 1,160,003, VV 25,964,191, Organic 25,964,191).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 (Twitter) | Organic + Unclassified + Paid Views = Video Views | 3/3 posts exact (e.g. rank 3: 4,724,483 + 0 + 0 = 4,724,483). Sum row: 5,774,627 + 0 + 0 = 5,774,627. | PASS |
| A5 | 5 (Twitter) | Engagements / Video Views = Video Response Rate | 3/3 match the 2-decimal display (4.66%, 6.04%, 0.16%). The Sum row shows "N/A" for the rate, so there was no aggregate rate to compare. | PASS |
| A7 | 7 (Instagram) | Organic + Unclassified + Paid Views = Video Views | 15/15 posts exact, 0 mismatches, 0 skipped (e.g. rank 1: 14,738,589 + 0 + 0 = 14,738,589). Sum row: 25,964,191 + 0 + 0 = 25,964,191. | PASS |
| A8 | 8 (Instagram) | Engagements / Video Views = Video Response Rate | 15/15 within ±0.005 pp of the displayed 2-decimal rate (e.g. rank 1: 572,195 / 14,738,589 = 3.882% vs 3.88%). The Sum row shows "N/A" for the rate. | PASS |

## Evidence
- `.playwright-out/QA-29125/00-home.png` (logged in)
- `.playwright-out/QA-29125/01-account.png` (Apple Services active)
- `.playwright-out/QA-29125/02a-state.png`, `02b-loaded.png` (stuck "Loading" before reload), `02c-reloaded.png` (rendered after the reload)
- `.playwright-out/QA-29125/03-twitter.png` (Video Views + Twitter only applied)
- `.playwright-out/QA-29125/04-twitter-table.png` (Twitter Table View)
- `.playwright-out/QA-29125/05-instagram-table.png` (Instagram Table View)
- Numbers were read from the DOM of `table.lfm-table` (headers include Rank, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views) and evaluated in page JS. Skill used: `brand-content-grid-math`, with the shared `devprod-helpers.js`.

## Observations (non-blocking)
- Organic Views equals Video Views on every post and Paid Views is "–" throughout. The identity therefore holds trivially here (Paid and Unclassified contribute 0), so this run does not exercise a non-zero Paid or Unclassified split.
- The Sum row's Video Response Rate is "N/A" in Sum mode. I did not toggle the Sum/Average row, since the spec asks for per-post values. The aggregate rate computed from the Sum row would be 1.065% (Twitter) and 4.468% (Instagram).
- The initial Brand Content load stalled on "Loading" for more than 5 minutes, then rendered after one reload (dev slowness, transient). This did not affect the data.
- Console showed errors on the app pages. This was not a step in this case and had no effect on the data or assertions.

## Known bugs checked
The case file lists no open linked bugs, and `open-bugs-2026-10-28.json` has no QA-29125 entry. No bug-history entry exists. Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, on QA-29111) concerns a different identity, and Engagements was only read here, not decomposed. APPS-60871 (en-dash rendering across datasets) did not interfere: the only "–" cells were Paid Views and the unavailable Viewers/Duration/Watch Time columns, none of which break the asserted identities. No bug reproduced.

## Bugs filed
None. · **Cleanup:** none (read-only).
