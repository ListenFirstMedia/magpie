# QA-24279 — Brand Content - Video Views Data Set - Aggregate Data Test

**Run date:** 2026-10-20 (Tuesday), headless unattended Playwright MCP run, dev `app.lfmdev.in`, user lfiqa
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756, shown in the header) · **Date range:** Oct. 12 – Oct. 18, 2026 (default week) · **Data set:** Video Views (`table_data_set=video_views`) · **View:** Table View, aggregate row Sum and Average
**Verdict: PASS** (all five channels satisfy the case's "Common formula" Organic + Paid + Unclassified = Video Views, on both Sum and Average). See the note on TikTok/LinkedIn: for those two channels the per-step assertion text, read literally, would not hold.

Rotation note: the case Description table and the Notes section disagree on Tuesday's second entry (Wasserman/Gatorade vs. Sony Pictures). Both agree on UCLA / "University of California, Los Angeles", the first entry, so that is the one used. The same row was used by the sibling runs on 2026-10-20.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"), switch account to UCLA via the profile menu, `ACCOUNT: UCLA`, `account_id=799` | done |
| 1 | Hover Brand, click Content in the top nav | Brand > Content loaded, brand "University of California, Los Angeles" (01-brand-content.png) |
| 2 | Brand present, Data Set = Video Views | `table_data_set=video_views` (02-dataset-videoviews.png) |
| 3 | Only Facebook enabled, Apply | `channels=facebook`, Posts (7) |
| 4 | Table View, aggregate row Sum and Average | done (03-fb-table.png, 04-fb-avg.png) |
| 5-6 | Only Twitter enabled, Apply; Sum and Average | `channels=twitter`, Posts (7) (05-twitter-table.png) |
| 7-8 | Only Instagram enabled, Apply; Sum and Average | `channels=instagram`, Posts (7) (05-instagram-table.png) |
| 9-10 | Only TikTok enabled, Apply; Sum and Average | `channels=tiktok`, Posts (7) (06-tiktok-table.png) |
| 11-12 | Only LinkedIn enabled, Apply; Sum and Average | `channels=linkedin`, Posts (7) (06-linkedin-table.png) |

Each channel was enabled by an explicit `.channel-ghost` click, the others were deselected, `.channel-ghost.enabled` was read back to confirm only that channel was on, and Apply was clicked (Rule 2). The Sum/Average toggle was clicked in the UI for every channel.

## Assertions
Aggregate row values (Table View). "–" is treated as 0 (structurally absent or no split for that channel).

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Sum | 4 Facebook | Organic + Paid + Unclassified = Video Views | 1,001 + 0 + 0 = 1,001 | PASS |
| A4-Avg | 4 Facebook | same | 143 + 0 + 0 = 143 (1,001 / 7 = 143.0) | PASS |
| A6-Sum | 6 Twitter | same | 2,663 + (– = 0) + 0 = 2,663 | PASS |
| A6-Avg | 6 Twitter | same | 380 + (– = 0) + 0 = 380 (2,663 / 7 = 380.4) | PASS |
| A8-Sum | 8 Instagram | same | 425,637 + (– = 0) + 0 = 425,637 | PASS |
| A8-Avg | 8 Instagram | same | 60,805 + (– = 0) + 0 = 60,805 (425,637 / 7 = 60,805.3) | PASS |
| A10-Sum | 10 TikTok | same | (– = 0) + (– = 0) + 11,513 = 11,513 | PASS (see note) |
| A10-Avg | 10 TikTok | same | (– = 0) + (– = 0) + 1,645 = 1,645 (11,513 / 7 = 1,644.7) | PASS (see note) |
| A12-Sum | 12 LinkedIn | same | (– = 0) + (– = 0) + 19,870 = 19,870 | PASS (see note) |
| A12-Avg | 12 LinkedIn | same | (– = 0) + (– = 0) + 2,839 = 2,839 (19,870 / 7 = 2,838.6) | PASS (see note) |

Raw aggregate rows:

| Channel | Mode | Engagements | Video Views | Organic | Paid | Unclassified | Viewers |
|---|---|---|---|---|---|---|---|
| Facebook | Sum | 2,010 | 1,001 | 1,001 | 0 | 0 | 1,001 |
| Facebook | Avg | 287 | 143 | 143 | 0 | 0 | 143 |
| Twitter | Sum | 213 | 2,663 | 2,663 | – | 0 | – |
| Twitter | Avg | 30 | 380 | 380 | – | 0 | – |
| Instagram | Sum | 5,817 | 425,637 | 425,637 | – | 0 | – |
| Instagram | Avg | 831 | 60,805 | 60,805 | – | 0 | – |
| TikTok | Sum | 755 | 11,513 | – | – | 11,513 | – |
| TikTok | Avg | 108 | 1,645 | – | – | 1,645 | – |
| LinkedIn | Sum | 1,250 | 19,870 | – | – | 19,870 | 19,173 |
| LinkedIn | Avg | 179 | 2,839 | – | – | 2,839 | 2,739 |

Sum and Average are consistent on every channel (Sum / 7 posts = Average, within rounding).

### Note on TikTok and LinkedIn
The step assertions are worded "Organic Views + Paid Views = Video Views". On TikTok and LinkedIn, Organic and Paid Views are "–" and the whole Video Views value sits in Unclassified Views. Read literally, that wording would give 0 ≠ 11,513 (TikTok) and 0 ≠ 19,870 (LinkedIn). The case itself states "Common formula: Organic + Paid + Unclassified = Video Views", and the step-4/6/8/10/12 instruction is to add the Unclassified column as well, so I judged against the common formula, which holds. LinkedIn's lack of an Organic/Paid split is the documented structural absence in the brand-content-grid-math skill. If the case owner intends the literal two-term check for TikTok/LinkedIn, the assertion text should be corrected. This is a spec-wording observation, not a product bug.

## Evidence
Screenshots in `.playwright-out/QA-24279/`: 01-brand-content.png, 02-dataset-videoviews.png, 03-fb-table.png, 04-fb-avg.png, 05-twitter-table.png, 05-instagram-table.png, 06-tiktok-table.png, 06-linkedin-table.png. Values above were read from the Table View aggregate row via DOM scrape. The console showed the usual dev noise; no render hang occurred (every Posts (N) count resolved within the first poll).

## Known bugs checked
- Case "Open linked bugs": None open, so the screen passed.
- bug-history.md and known-quirks.md: no entries for QA-24279 (pre-fetched). One extra grep of known-quirks.md for Unclassified / TikTok / LinkedIn Organic/Paid found nothing.
- No known bug interfered with the assertions.

## Bugs filed
None.

## Cleanup
None needed (read-only). The account was left switched to UCLA in this isolated browser session.
