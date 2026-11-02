# QA-24279 — Brand Content - Video Views Data Set - Aggregate Data Test

**Run date:** 2026-10-26 (Monday), unattended headless `claude -p`, Playwright MCP, dev `app.lfmdev.in`, user lfiqa
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614) · **Date range:** default week Oct. 18 – Oct. 24, 2026 · **Data set:** Video Views (`table_data_set=video_views`) · **View:** Table View, aggregate row Sum and Average
**Verdict: PASS (LinkedIn leg NOT EVALUABLE).** Organic Views + Paid Views + Unclassified Views = Video Views holds on the aggregate row (both Sum and Average) and on every post that has a Video Views value, for Facebook, Twitter, Instagram and TikTok. LinkedIn has 0 posts this week, so step 12 / assertion 12 has no data to evaluate.

Rotation: Monday row of the Description table is "HBO Max, Sony Pictures". The first entry (HBO Max) was used, matching the Notes section and the earlier Monday runs (2026-10-19). Sony Pictures was not run.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"), profile menu > Search Account "HBO Max" > clicked the `.lfm-ta-option` in Results | `account_id=657`, sub-header "Account: HBO Max" |
| 1 | Hover Brand, click Content in top nav | Brand > Content loaded, brand HBO Max (`brand_id=155614`) |
| 2 | Brand present, Data Set = Video Views (visible `.lfm-dropdown-select-box` > option "Video Views") | `table_data_set=video_views` (01-dataset-videoviews.png) |
| 3 | Only Facebook: clicked the other ghosts off, read back `.channel-ghost.enabled` = [facebook], Apply | `channels=facebook`, Posts (24) |
| 4 | Table View, aggregate row Sum and Average (toggle clicked in UI) | done (02-facebook-agg-first/second.png) |
| 5-6 | Only Twitter (same procedure) | `channels=twitter`, Posts (10) (03-twitter-agg-*.png) |
| 7-8 | Only Instagram | `channels=instagram`, Posts (35) (04-instagram-agg-*.png) |
| 9-10 | Only TikTok | `channels=tiktok`, Posts (126) (05-tiktok-agg-*.png) |
| 11-12 | Only LinkedIn | `channels=linkedin`, Posts (0), "no data available", no table / aggregate row (06-linkedin-state.png) |

Each channel was enabled by an explicit `.channel-ghost` click, the others were deselected, and `.channel-ghost.enabled` was read back to confirm a single channel before clicking Apply (Rule 2).

## Assertions
Aggregate row values from Table View. "–" is treated as 0 (no split for that channel). Per-post check covers every post row that has a Video Views value.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Sum | 4 Facebook | Organic + Paid + Unclassified = Video Views | 20,247,128 = 20,247,128 + 0 + 0 | PASS |
| A4-Avg | 4 Facebook | same | 843,630 = 843,630 + 0 + 0 (20,247,128 / 24 = 843,630.3) | PASS |
| A4-posts | 4 Facebook | same per post | 24/24 posts hold, 0 skipped | PASS |
| A6-Sum | 6 Twitter | same | 154,227 = 154,227 + (– = 0) + 0 | PASS |
| A6-Avg | 6 Twitter | same | 15,423 = 15,423 + (– = 0) + 0 (154,227 / 10 = 15,422.7) | PASS |
| A6-posts | 6 Twitter | same per post | 10/10 posts hold | PASS |
| A8-Sum | 8 Instagram | same | 26,638,615 = 26,638,615 + (– = 0) + 0 | PASS |
| A8-Avg | 8 Instagram | same | 761,103 = 761,103 + (– = 0) + 0 (26,638,615 / 35 = 761,103.3) | PASS |
| A8-posts | 8 Instagram | same per post | 34/34 posts with a Video Views value hold; 1 post has "–" Video Views (skipped) | PASS |
| A10-Sum | 10 TikTok | same | 46,411,992 = (– = 0) + (– = 0) + 46,411,992 | PASS (see note) |
| A10-Avg | 10 TikTok | same | 368,349 = (– = 0) + (– = 0) + 368,349 (46,411,992 / 126 = 368,349.1) | PASS (see note) |
| A10-posts | 10 TikTok | same per post | 59/59 posts with a Video Views value hold; 67 posts have "–" Video Views (skipped) | PASS |
| A12 | 12 LinkedIn | same | Posts (0): no table, no aggregate row | NOT EVALUABLE (no LinkedIn posts this week) |

Toggle order: the Sum/Average toggle was in opposite states on different channels when the table loaded. Sum vs Average was identified by magnitude (Sum = Average x post count) and both states were read for every evaluable channel.

Note on TikTok: the literal assertion text "Organic + Paid = Video Views" would not hold, because TikTok reports all views as Unclassified (Organic and Paid are "–"). The case's own "Common formula" (Organic + Paid + Unclassified = Video Views) holds exactly. Judged on the Common formula, consistent with the 2026-10-20 run.

## Evidence
- Screenshots in `.playwright-out/QA-24279/`: 01-dataset-videoviews.png, 02-facebook-agg-first.png, 02-facebook-agg-second.png, 03-twitter-agg-first.png, 03-twitter-agg-second.png, 04-instagram-agg-first.png, 04-instagram-agg-second.png, 05-tiktok-agg-first.png, 05-tiktok-agg-second.png, 06-linkedin-state.png
- Table headers in this build are unspaced (`VideoViews`, `OrganicViews`, `PaidViews`, `UnclassifiedViews`; there is also `VideoViews(withCross-Posts)`, which must not be confused with `VideoViews`). Columns were matched by exact header text.
- Values were scraped from the DOM (`table.lfm-table` with a `Rank` header) and the identity was evaluated in page JS with a tolerance of 0.5.

## Known bugs checked
- Case file "Open linked bugs": none open (as of 2026-10-20). `results/open-bugs-2026-10-26.json` has no entry for QA-24279. Rule 7 screen passed.
- knowledge-base/bug-history.md and known-quirks.md: no QA-24279 entries (pre-fetched).
- No known bug reproduced or interfered with the assertions. TikTok "–" on Organic/Paid and the 67 TikTok posts with "–" Video Views are collection-side gaps that do not break the identity on rows with data.

## Bugs filed
None.

## Cleanup
None (read-only).
