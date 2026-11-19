# QA-24279 — Brand Content - Video Views Data Set - Aggregate Data Test

**Run date:** 2026-11-18 (Wednesday), unattended headless `claude -p`, Playwright MCP, dev `app.lfmdev.in`, user lfiqa
**Account:** Apple Services (account_id=409) · **Brand:** Apple Music (brand_id=31783, header "Apple Music") · **Date range:** default week Nov. 10 – Nov. 16, 2026 · **Data set:** Video Views (`table_data_set=video_views`) · **View:** Table View, aggregate row read on both Sum and Average · **Perspective:** left at the page default (URL `perspective=extended`; the View control showed "Authorized data" highlighted — see Notes)

**Verdict: PASS (LinkedIn leg NOT EVALUABLE).** Organic Views + Paid Views + Unclassified Views = Video Views holds on the aggregate row (Sum and Average) and on every post row for Facebook, Twitter, Instagram and TikTok. LinkedIn has 0 posts for Apple Music this week ("There is no data available"), so step 12 / assertion 12 has no table or aggregate row to evaluate. Same handling as the 2026-10-22 and 2026-10-26 runs.

Rotation: the Wednesday row of the Description table is "Apple Services, Conde Nast" (account) / "Apple Music, GQ - Japan" (brand). The Notes line reads "Apple Services/Wasserman" for Wednesday. Both agree on Apple Services, so the first entry (Apple Services / Apple Music) was run. The second entry (Conde Nast / GQ - Japan) was not run, as in earlier runs. The "also use Amazon Prime Video on alternative days" note was not applied.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"). Profile menu (LFQA) > Search Account, typed "Apple Serv", clicked the "Apple Services" `.lfm-ta-option` under Results (real mouse click) | Header "ACCOUNT: APPLE SERVICES", `account_id=409` (00c-account-search.png) |
| 1 | Hovered Brand in top nav, clicked Content | `#explore/brand/content` loaded. Brand header "Apple Music" (`brand_id=31783`), the account's default brand and the exact name the case requires (01-brand-content-1118.png, 02-default-brand-1118.png) |
| 2 | Brand present. Data Set dropdown (visible `.lfm-dropdown-select-box`), clicked option "Video Views" | `table_data_set=video_views`, Posts (46) with the five default channels (03-dataset-videoviews-1118.png) |
| 3 | Only Facebook. The other four `.channel-ghost` toggles were clicked off and `.channel-ghost.enabled` was read back as [facebook] only. Clicked Apply | `channels=facebook`, Posts (3) (04-facebook-ghosts.png) |
| 4 | Table View (`[title="Table View"]`). Aggregate row read in both toggle states (toggle clicked in UI) | done (04-facebook-agg-first/second.png) |
| 5-6 | Only Twitter (ghost read-back = [twitter], Apply) | `channels=twitter`, Posts (3) (05-twitter-*.png) |
| 7-8 | Only Instagram | `channels=instagram`, Posts (19) (06-instagram-*.png) |
| 9-10 | Only TikTok | `channels=tiktok`, Posts (21) (07-tiktok-*.png) |
| 11-12 | Only LinkedIn (ghost read-back = [linkedin], Apply) | `channels=linkedin`, Posts (0), "There is no data available. Please select a different brand, brand set, or date range." No table, no aggregate row (08-linkedin-ghosts.png, 08-linkedin-probe.png) |

Rule 2: each channel was enabled by an explicit ghost click and the enabled set was read back as a single channel before Apply. The Sum/Average toggle was clicked in the UI; the state was identified by magnitude (Sum = Average x post count).

## Assertions
Values come from the Table View aggregate row. "–" is treated as 0 (no split for that channel). The per-post check covers every post row with a Video Views value. There were 0 skipped rows and 0 failures on every channel.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Sum | 4 Facebook | Organic + Paid + Unclassified = Video Views | 23,505 = 23,505 + 0 + 0 | PASS |
| A4-Avg | 4 Facebook | same | 7,835 = 7,835 + 0 + 0 (23,505 / 3 = 7,835.0) | PASS |
| A4-posts | 4 Facebook | same per post | 3/3 posts hold | PASS |
| A6-Sum | 6 Twitter | same | 45,756 = 45,756 + (– = 0) + 0 | PASS |
| A6-Avg | 6 Twitter | same | 15,252 = 15,252 + (– = 0) + 0 (45,756 / 3 = 15,252.0) | PASS |
| A6-posts | 6 Twitter | same per post | 3/3 posts hold | PASS |
| A8-Sum | 8 Instagram | same | 8,870,011 = 8,870,011 + (– = 0) + 0 | PASS |
| A8-Avg | 8 Instagram | same | 466,843 = 466,843 + (– = 0) + 0 (8,870,011 / 19 = 466,842.7) | PASS |
| A8-posts | 8 Instagram | same per post | 19/19 posts hold | PASS |
| A10-Sum | 10 TikTok | same | 118,910 = (– = 0) + (– = 0) + 118,910 | PASS (see note) |
| A10-Avg | 10 TikTok | same | 5,662 = (– = 0) + (– = 0) + 5,662 (118,910 / 21 = 5,662.4) | PASS (see note) |
| A10-posts | 10 TikTok | same per post | 21/21 posts hold | PASS |
| A12 | 12 LinkedIn | same | Posts (0): no table, no aggregate row | NOT EVALUABLE (no LinkedIn posts this week) |

Note on TikTok: all views are reported as Unclassified (Organic and Paid are "–"). The literal assertion text "Organic + Paid = Video Views" would not hold for TikTok. The case's own "Common formula" (Organic + Paid + Unclassified = Video Views) holds exactly, and was used, as in earlier runs.

## Evidence
- Screenshots in `.playwright-out/QA-24279/`: 00-header-1118.png, 00c-account-search.png, 01-brand-content-1118.png, 02-default-brand-1118.png, 03-dataset-videoviews-1118.png, 04-facebook-ghosts.png, 04-facebook-agg-first.png, 04-facebook-agg-second.png, 05-twitter-ghosts/agg-first/agg-second.png, 06-instagram-ghosts/agg-first/agg-second.png, 07-tiktok-ghosts/agg-first/agg-second.png, 08-linkedin-ghosts.png, 08-linkedin-probe.png. The folder also holds files from earlier runs.
- Table headers in this build are unspaced (`VideoViews`, `OrganicViews`, `PaidViews`, `UnclassifiedViews`). `VideoViews(withCross-Posts)` also exists and was not used. Columns were matched by exact header text.
- Values were scraped from `table.lfm-table` (the table with a `Rank` header; aggregate row Rank cell "SumAverage"). The identity was evaluated in page JS with a tolerance of 0.5 per post and 1 on the aggregate row. The aggregate row differences were 0 on every channel.
- Facebook example row: rank 1, 16,963 = 16,963 + 0 + 0. Rank 2: 3,298 = 3,298 + 0 + 0. Rank 3: 3,244 = 3,244 + 0 + 0.
- The console logged many errors during the session (the app does this on every page). None affected the table values.

## Known bugs checked
- Case file "Open linked bugs": none open (as of 2026-10-20). `results/open-bugs-2026-11-18.json` has no entry for QA-24279. The Rule 7 screen passed.
- knowledge-base/bug-history.md and known-quirks.md: no QA-24279 entries (pre-fetched). No known bug reproduced or interfered with the assertions.

## Notes
- The View control on Brand > Content showed "Authorized data" highlighted while the URL carried `perspective=extended`. The case does not specify a perspective, so it was left at the page default and not changed. Both states were consistent across all channels: the per-post and aggregate identities held.
- Data Collection Status for Apple Music: 1 red, 2 amber, 24 green. Not relevant to the assertions.
- LinkedIn: re-check on a week where Apple Music has LinkedIn video posts if step 12 coverage is wanted.

## Bugs filed
None.

## Cleanup
None (read-only).
