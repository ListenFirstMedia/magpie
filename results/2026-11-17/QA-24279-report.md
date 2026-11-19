# QA-24279 — Brand Content - Video Views Data Set - Aggregate Data Test

**Run date:** 2026-11-17 (Tuesday), unattended headless `claude -p`, Playwright MCP, dev `app.lfmdev.in`, user lfiqa
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · **Date range:** default week Nov. 09 – Nov. 15, 2026 · **Data set:** Video Views (`table_data_set=video_views`) · **View:** Table View, aggregate row Sum and Average · **Perspective:** Public data (`perspective=extended`, default, not changed)
**Verdict: PASS.** Organic Views + Paid Views + Unclassified Views = Video Views holds on the aggregate row (Sum and Average) and on every post row, for Facebook, Twitter, Instagram, TikTok and LinkedIn.

Rotation: the Tuesday row of the Description table is "UCLA, Wasserman" (account) / "University of California, Los Angeles, Gatorade" (brand). The Description and the Notes section disagree on Tuesday's second entry (Wasserman/Gatorade vs Sony Pictures). Both agree on UCLA and "University of California, Los Angeles", so the first entry was used, as in the 2026-10-20 Tuesday run. The second entry was not run. The Amazon Prime Video note ("also use on alternative days") was not applied.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"), profile menu > Search Account "UCLA", clicked the `.lfm-ta-option` "UCLA" under Results (not "UCLA Law") | `account_id=799`, header "ACCOUNT: UCLA" |
| 1 | Hover Brand in top nav, click Content | Brand > Content loaded with brand "University of California, Los Angeles" (`brand_id=127756`) |
| 2 | Brand present, Data Set dropdown (visible `.lfm-dropdown-select-box`), clicked option "Video Views" | `table_data_set=video_views` (01-dataset-videoviews.png) |
| 3 | Only Facebook: Facebook ghost kept enabled, the other ghosts clicked off, `.channel-ghost.enabled` read back = [facebook] only, Apply | `channels=facebook`, Posts (7) |
| 4 | Table View (`[title="Table View"]`), aggregate row read on both Sum and Average (toggle clicked in UI) | done (02-facebook-agg-first/second.png) |
| 5-6 | Only Twitter (same procedure, single-ghost read-back before Apply) | `channels=twitter`, Posts (7) (03-twitter-agg-*.png) |
| 7-8 | Only Instagram | `channels=instagram`, Posts (7) (04-instagram-agg-*.png) |
| 9-10 | Only TikTok | `channels=tiktok`, Posts (6) (05-tiktok-agg-*.png) |
| 11-12 | Only LinkedIn | `channels=linkedin`, Posts (7) (06-linkedin-agg-*.png) |

Each channel was enabled by an explicit `.channel-ghost` click, the others were deselected, and `.channel-ghost.enabled` was read back to confirm a single channel before clicking Apply (Rule 2). Sum vs Average was identified by magnitude (Sum = Average x post count) and both states were read for every channel.

## Assertions
Aggregate row values from Table View. "–" is treated as 0 (no split for that channel). The per-post check covers every post row that has a Video Views value; there were 0 skipped rows and 0 failures on every channel.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Sum | 4 Facebook | Organic + Paid + Unclassified = Video Views | 12,163 = 12,163 + 0 + 0 | PASS |
| A4-Avg | 4 Facebook | same | 1,738 = 1,738 + 0 + 0 (12,163 / 7 = 1,737.6) | PASS |
| A4-posts | 4 Facebook | same per post | 7/7 posts hold | PASS |
| A6-Sum | 6 Twitter | same | 2,901 = 2,901 + (– = 0) + 0 | PASS |
| A6-Avg | 6 Twitter | same | 414 = 414 + (– = 0) + 0 (2,901 / 7 = 414.4) | PASS |
| A6-posts | 6 Twitter | same per post | 7/7 posts hold | PASS |
| A8-Sum | 8 Instagram | same | 448,112 = 448,112 + (– = 0) + 0 | PASS |
| A8-Avg | 8 Instagram | same | 64,016 = 64,016 + (– = 0) + 0 (448,112 / 7 = 64,016.0) | PASS |
| A8-posts | 8 Instagram | same per post | 7/7 posts hold | PASS |
| A10-Sum | 10 TikTok | same | 9,970 = (– = 0) + (– = 0) + 9,970 | PASS (see note) |
| A10-Avg | 10 TikTok | same | 1,662 = (– = 0) + (– = 0) + 1,662 (9,970 / 6 = 1,661.7) | PASS (see note) |
| A10-posts | 10 TikTok | same per post | 6/6 posts hold | PASS |
| A12-Sum | 12 LinkedIn | same | 23,556 = (– = 0) + (– = 0) + 23,556 | PASS (see note) |
| A12-Avg | 12 LinkedIn | same | 3,365 = (– = 0) + (– = 0) + 3,365 (23,556 / 7 = 3,365.1) | PASS (see note) |
| A12-posts | 12 LinkedIn | same per post | 7/7 posts hold | PASS |

Note on TikTok and LinkedIn: all views are reported as Unclassified (Organic and Paid are "–"). The literal assertion text "Organic + Paid = Video Views" would not hold for these two channels. The case's own "Common formula" (Organic + Paid + Unclassified = Video Views) holds exactly. Judged on the Common formula, consistent with the 2026-10-20 and 2026-10-26 runs.

## Evidence
- Screenshots in `.playwright-out/QA-24279/`: 01-dataset-videoviews.png, 02-facebook-agg-first.png, 02-facebook-agg-second.png, 03-twitter-agg-first.png, 03-twitter-agg-second.png, 04-instagram-agg-first.png, 04-instagram-agg-second.png, 05-tiktok-agg-first.png, 05-tiktok-agg-second.png, 06-linkedin-agg-first.png, 06-linkedin-agg-second.png. The folder also holds files from earlier runs and probes.
- Table headers in this build are unspaced (`VideoViews`, `OrganicViews`, `PaidViews`, `UnclassifiedViews`). `VideoViews(withCross-Posts)` also exists and was not used. Columns were matched by exact header text.
- Values were scraped from the DOM (`table.lfm-table` with a `Rank` header). The identity was evaluated in page JS with a tolerance of 0.5.
- The console showed many errors during the session (the app logs these on every page). None affected the table values or the assertions.

## Known bugs checked
- Case file "Open linked bugs": none open (as of 2026-10-20). `results/open-bugs-2026-11-17.json` has no entry for QA-24279. The Rule 7 screen passed.
- knowledge-base/bug-history.md and known-quirks.md: no QA-24279 entries (pre-fetched).
- No known bug reproduced or interfered with the assertions.

## Bugs filed
None.

## Cleanup
None (read-only).
