# QA-29234 — Brand Content > Video Views Data Set > Past date range data test (Twitter/Instagram)

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** HBO Max (account_id=657, switched via the LFQA menu, header `ACCOUNT: HBO MAX`) · **Brand:** HBO Max (brand_id=155614, exact spec brand) · **Date range:** Jan. 01, 2023 – Jan. 10, 2023 · **Data set:** Video Views (`table_data_set=video_views`) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (4/4)**

- Twitter: for the 15 posts that have video views, Organic Views + Paid Views = Video Views and Engagements / Video Views = Video Response Rate.
- Instagram: the same two identities hold for the 43 posts that have video views.
- Posts with "–" in Video Views were skipped (5 Twitter, 1 Instagram).

## Pre-screen (Rule 7)
- Case file "Open linked bugs": none open. `results/open-bugs-2026-10-26.json` has no QA-29234 entry, so the screen passed and the case was run.
- No QA-29234 entries in bug-history or known-quirks (pre-fetched).

## Interpretation notes
- Weekday rotation: Monday → account HBO Max, brand HBO Max (Description table; Amazon Prime Video is the "alternative days" option and was not used). The case's Notes line maps Monday to "HBO Max/Viacom", which only partly matches the table. HBO Max is common to both.
- The identities are evaluated per post (every row of the Table View) and on the Sum row.
- Paid Views shows "–" on every post (organic-only videos). I treated "–" as 0, as the skill specifies.
- The table also has an "Unclassified Views" column, which was 0 on every post. It does not affect either identity.
- The Video Response Rate display is 2 decimals, so I allowed ±0.005 pp.
- Skill used: `brand-content-grid-math`. The helpers came from `skills/_shared/playwright-helpers/devprod-helpers.js`, driving one dev tab only.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", config/.env) | OK — landed on the app. The first `goto` timed out at 30 s on the slow dev env; the retry with `domcontentloaded` succeeded. |
| P | Account precondition: LFQA menu > "Search Account" > HBO Max | OK — header `ACCOUNT: HBO MAX`, `account_id=657`. |
| 1 | Hover Brand in the top nav, click Content | OK — `#explore/brand/content`. |
| 2 | Brand: the selector already showed the exact spec brand "HBO Max" (`brand_id=155614`). No substitution. Data set dropdown > "Video Views" (visible dropdown, exact option label). | OK — `table_data_set=video_views`; the dropdown label reads "Video Views". |
| 3 | Date range Jan 01, 2023 – Jan 10, 2023 via the START/END DATE picker, then Ok | OK — the date fields read `Jan 01, 2023` / `Jan 10, 2023`; URL `from=2023-01-01&to=2023-01-10`. |
| 4 | Twitter only: Twitter ghost on, all other ghosts off, Apply | OK — enabled channels `["twitter"]`, URL `channels=twitter`, Posts (20). |
| 5 | Table View; add Organic Views + Paid Views for every post and compare to Video Views | See A5. |
| 6 | Note Engagements and Video Views (Table View, same scrape) | See A6. |
| 7 | Instagram only: Instagram ghost enabled before the others were disabled (last-channel rule), Apply | OK — enabled channels `["instagram"]`, URL `channels=instagram`, data set still `video_views`, Posts (44). |
| 8 | Table View; Organic Views + Paid Views vs Video Views for every post | See A8. |
| 9 | Note Engagements and Video Views | See A9. |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Twitter) | Organic Views + Paid Views = Video Views for each post | 20 posts rendered. 15/15 posts with video views match exactly, 0 mismatches. 5 posts (ranks 16–20) have Video Views "–", so there was nothing to compare. Rank 1: 265,486 + 0 = 265,486. Rank 2: 95,941 + 0 = 95,941. Rank 3: 145,512 + 0 = 145,512. Sum row: Organic 736,003 + Paid "–" (0) = Video Views 736,003. The per-post column totals also add up to 736,003. | PASS |
| A6 | 6 (Twitter) | Engagements / Video Views = Video Response Rate | 15/15 posts match within ±0.005 pp. Rank 1: 14,533 / 265,486 = 5.474% → shown 5.47%. Rank 2: 5,157 / 95,941 = 5.375% → 5.38%. Rank 5: 1,790 / 10,678 = 16.76% → 16.76%. Rank 15: 99 / 4,836 = 2.047% → 2.05%. The 5 posts with Video Views "–" show Video Response Rate "–", so they were skipped. Sum row: 38,542 / 736,003 = 5.2367%, but the Sum row's Video Response Rate cell reads "N/A" (see note below). | PASS |
| A8 | 8 (Instagram) | Organic Views + Paid Views = Video Views for each post | 44 posts rendered. 43/43 posts with video views match exactly, 0 mismatches. Rank 38 has Video Views "–" (Engagements 2,349), so it was skipped. Rank 1: 8,157,461 + 0 = 8,157,461. Rank 2: 3,172,055 + 0 = 3,172,055. Rank 3: 770,513 + 0 = 770,513. Sum row: Organic 18,354,270 + Paid "–" (0) = Video Views 18,354,270. The per-post column totals match the Sum row. | PASS |
| A9 | 9 (Instagram) | Engagements / Video Views = Video Response Rate | 43/43 posts match within ±0.005 pp. Rank 1: 1,642,301 / 8,157,461 = 20.13% → shown 20.13%. Rank 2: 132,151 / 3,172,055 = 4.166% → 4.17%. Rank 4: 70,587 / 286,195 = 24.666% → 24.66%. Rank 25: 3,338 / 107,522 = 3.104% → 3.10%. Rank 38 was skipped (Video Views "–"). Sum row: 2,242,287 / 18,354,270 = 12.2167%, Sum row cell "N/A". | PASS |

Note on the Sum row's Video Response Rate: the cell reads "N/A" for the Sum row in both channels. I read the Table View Sum row as simply not computing a rate. I did not treat it as a failure, because the case asks for the identity "in each grid post". The row's Engagements and Video Views would give 5.24% (Twitter) and 12.22% (Instagram). The Sum row's Engagements also include posts without video views.

## Evidence
- `.playwright-out/QA-29234/00-home.png` (after login)
- `.playwright-out/QA-29234/01-state.png` (account HBO MAX)
- `.playwright-out/QA-29234/02-content-landing.png` (Brand Content landing, HBO Max, default week)
- `.playwright-out/QA-29234/03-ds-dates.png` (Video Views data set + Jan 01–10, 2023, all channels)
- `.playwright-out/QA-29234/04-twitter-table.png` (Twitter-only Table View)
- `.playwright-out/QA-29234/05-instagram-table.png` (Instagram-only Table View)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views …) and evaluated in page JS.
- Twitter Sum row: Engagements 38,542; Video Views 736,003; Organic Views 736,003; Paid Views –; Unclassified Views 0; Video Views (with Cross-Posts) 776,145.
- Instagram Sum row: Engagements 2,242,287; Video Views 18,354,270; Organic Views 18,354,270; Paid Views –; Unclassified Views 0.

## Known bugs checked
- The case file lists no open linked bugs, and the shell-side `open-bugs-2026-10-26.json` has no QA-29234 entry. No bug-history entry exists. No known bug reproduced or interfered with the assertions.
- Related surface: APPS-61116 (Twitter Reactions + Comments + Shares ≠ Engagements, seen on QA-29111) is about a different identity. The Video Views identities here were exact on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).
