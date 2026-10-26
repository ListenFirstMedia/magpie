# QA-23667 — TikTok > Content - Data Test - Paid Posts

**Run date:** 2026-10-23 (Friday) · **Track:** Playwright MCP, unattended `claude -p` · **Account:** Hulu (336) — Friday rotation row (Hulu / Hulu) · **Brand:** Hulu (exact typeahead result "Hulu"; Authorized entity 5670 / Public entity 11003) · **Date range:** Jan. 01, 2025 – Dec. 31, 2025 (step 5 "according to table" — the ticket's table has no date column; the current week was not used, 2025 has plenty of paid TikTok posts, same window as the 2026-10-19 run) · **Channel:** TikTok only · Table View, top 200 rendered rows (Posts 1,483 Authorized / 1,483 Public)

**Verdict: PASS (7/7)**

## Steps executed
1. Logged in via Cognito "With existing account" (config/.env); account already HULU.
2. Brand > Content via nav menu (hover Brand → Content link, real mouse click). Brand picker chevron → typed "Hulu" → clicked the literal result `Hulu` (first of 63 results; Rule 1) → brand_id=5670.
3. Channels: disabled Facebook/X/Instagram/LinkedIn/Threads by ghost clicks, TikTok the only `.enabled` → Apply (URL `channels=tiktok`).
4. Date range via picker: START Jan 01, 2025 / END Dec 31, 2025 → Ok (`from=2025-01-01&to=2025-12-31`).
5. Data Set → Impressions (`table_data_set=impressions`), Table View, scraped 200 rows + aggregate row.
6. Data Set → Video Views (`table_data_set=video_views`), scraped 200 rows + aggregate row.
7. Clicked the "Public Data" pill with a real mouse click at its bounding box → `perspective=standard`, `perspective` checkbox false, brand entity switched to 11003, channels reset to 4 + data set reset to Public (screenshots `05a`/`05b`).
8. Re-selected TikTok only (disabled Facebook/X/Instagram) → Apply → `channels=tiktok&perspective=standard`, Posts (1,483), Table View scraped.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Impressions grid, Authorized) | Paid posts included with the $ (promoted) icon | 124 of 200 rendered rows carry `i.fas.fa-dollar-sign[title="Paid post"]` (ranks 1, 2, 3, 4, 5, 6 …); Video Views view: 126 of 200 (the top-200 membership differs per data-set sort) | PASS |
| A6a | 6 (Impressions) | Paid and Organic Impressions display no data for posts | Organic Impressions "–" 200/200, Paid Impressions "–" 200/200 (aggregate row also "–"/"–") | PASS |
| A6b | 6 (Impressions) | Total Impressions displays a value or en-dash | 200/200 numeric values (e.g. rank 1 = 48,451,141; rank 2 = 8,495,633; rank 3 = 10,081,714), 0 malformed; aggregate Sum 1,203,578,167 | PASS |
| A7a | 7 (Video Views) | Paid Video Views only displays data for Paid posts | Paid Views populated on all 126 paid-icon rows (e.g. rank 1 = 45,857,595; rank 2 = 346; rank 3 = 185,910) and "–" on all 74 non-paid rows; 0 non-paid rows with a value | PASS |
| A7b | 7 (Video Views) | Organic Video Views display no data for posts | Organic Views "–" 200/200 (aggregate "–") | PASS |
| A7c | 7 (Video Views) | Unclassified = Total Video Views − Paid Video Views for all posts | 200/200 rows exact: rank 1: 48,451,141 − 45,857,595 = 2,593,546 ✓; rank 2: 8,495,633 − 346 = 8,495,287 ✓; organic rank 8: 8,188,536 − "–"(0) = 8,188,536 ✓. Aggregate: 1,206,198,697 − 633,310,214 = 572,888,483 ✓ | PASS |
| A9 | 8 (Public Data, TikTok only) | No Paid posts displayed ($ icon should not display) | Public perspective (`perspective=standard`, brand 11003), table headers have **no Paid column**; 0 `i.fa-dollar-sign` / `[title="Paid post"]` across 200 rows (Posts 1,483) | PASS |

## Evidence
Screenshots under `.playwright-out/QA-23667/`: `01-hulu-tiktok-2025.png`, `02-impressions.png`, `03-table-impressions.png`, `04-table-videoviews.png`, `05a-before-public.png`, `05b-after-public.png`, `06-public-tiktok.png`, `07-public-table.png`. Numbers above come from DOM scrapes of `table.lfm-table` (all identities evaluated in page JS over the 200 rendered rows).

## Notes / observations (none affect the verdict)
- Hulu has paid TikTok posts in the current-year window; the ticket gives no date column so the 2025 calendar year (as in the 2026-10-19 run) was used.
- Selecting Video Views changes the top-200 membership (sorted by Engagements for that set), hence 126 vs 124 paid icons across the two views — both are the same 1,431/1,483-post universe, not a discrepancy.
- Header text of the perspective toggle is "Public Data" (capital D); on this page the sticky header copy sits at y≈8 after scroll — scroll to top before clicking. A stray click on the sticky header landed on the Settings menu (opened "Brands" page); recovered with browser back, no data was changed.
- During the run the browser received unsolicited CSV download events (`Hulu-Brand Content-2026-10-15-2026-10-21-posts.csv`, `Hulu-Brand Content-2024-06-27-2024-07-03-posts.csv`) with date ranges this case never selected — most likely export completions from a parallel batch session on the same shared user. Incidental; not part of this case's assertions and not evaluated.
- Dev rendered quickly (grid ≤ ~10 s each time); no 5-minute budget issues, no reloads needed.

## Known bugs checked
Case file "Open linked bugs": None open (screen passed, Rule 7). `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-23667 entries (pre-fetched). Prior 2026-10-19 run cited APPS-41308 (closed Test Failure) — not reproduced here. No regression observed.

## Bugs filed
None. · **Cleanup:** none needed (read-only case).
