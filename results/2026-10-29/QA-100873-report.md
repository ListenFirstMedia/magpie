# QA-100873 — Brand > Content - Basic Data Set - Threads

**Run date:** 2026-10-29 · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-grid-math` + `devprod-helpers.js` · **Account:** HBO Max (profile menu → Search Account → Results → `HBO Max`; header "ACCOUNT: HBO MAX", `account_id=657`) · **Brand:** HBO Max (`brand_id=155614`, exact `HBO Max` row from the typeahead, Rule 1) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker; fields read back "Jan 01, 2026 / Jan 15, 2026", button "Jan. 01, 2026 - Jan. 15, 2026", URL `from=2026-01-01&to=2026-01-15`) · **Channel:** Threads only (`channels=threads`; `.channel-ghost.enabled` = `threads` only) · **Data set:** Public (`table_data_set=public`) · **View:** default perspective (`perspective=extended`; the spec names none).

**Verdict: PASS**

## Steps executed
0. Rule 7 screen: case file "Open linked bugs" = "None open" → proceed.
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com) and landed on `#home`. Switched account to HBO Max (header confirmed). Precondition "User logged in as Max" satisfied.
2. Hovered **Brand** in the top nav and clicked **Content**, which opened `#explore/brand/content?brand_id=155614…` (`r3-01-content-landing.png`, 189 posts for the default week).
3. Clicked the Brand dropdown, typed "HBO Max" and clicked the literal `HBO Max` row. The selector reads "HBO Max" with `brand_id=155614` (`r3-02-brand.png`). Opened the date picker and set START Jan 01, 2026 and END Jan 15, 2026, then clicked Ok (`r3-03-dates.png`). Posts (436) across all channels.
4. Channels: enabled Threads, turned the other channels off and clicked Apply. Only `threads` is enabled and `Posts (13)` rendered (`r3-04-threads.png`).
5. Switched to Table View (`r3-05-table.png`). Scraped all 13 Threads post rows from the DOM and computed Reactions + Comments + Shares for each post, then compared it with Engagements.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Reactions + Comments + Shares = Engagements for each Threads post | 13 of 13 posts match exactly; 0 mismatches, 0 "–" / no-data rows (per-post table below) | PASS |
| A5-agg | 5 | The Sum row follows the same identity (supporting check) | Sum row: 12,268 + 394 + 1,646 = 14,308 = Engagements 14,308 | PASS |

### Per-post evidence (Table View, Public data set, sorted by Responses desc)
| Rank | Date (PST) | Reactions | Comments | Shares | R+C+S | Engagements | Match |
|---|---|---|---|---|---|---|---|
| 1 | Sun Jan 04, 08:00 AM | 5,232 | 74 | 580 | 5,886 | 5,886 | yes |
| 2 | Fri Jan 09, 05:08 PM | 2,629 | 73 | 363 | 3,065 | 3,065 | yes |
| 3 | Sun Jan 11, 10:20 PM | 1,862 | 18 | 272 | 2,152 | 2,152 | yes |
| 4 | Thu Jan 01, 02:00 PM | 668 | 7 | 103 | 778 | 778 | yes |
| 5 | Wed Jan 14, 08:00 AM | 399 | 190 | 141 | 730 | 730 | yes |
| 6 | Fri Jan 09, 04:00 PM | 435 | 10 | 51 | 496 | 496 | yes |
| 7 | Sat Jan 03, 09:01 AM | 316 | 2 | 28 | 346 | 346 | yes |
| 8 | Fri Jan 02, 10:00 AM | 293 | 6 | 25 | 324 | 324 | yes |
| 9 | Wed Jan 14, 04:00 PM | 237 | 9 | 46 | 292 | 292 | yes |
| 10 | Tue Jan 13, 08:00 AM | 92 | 2 | 20 | 114 | 114 | yes |
| 11 | Thu Jan 08, 10:30 AM | 72 | 3 | 13 | 88 | 88 | yes |
| 12 | Thu Jan 08, 09:15 AM | 23 | 0 | 1 | 24 | 24 | yes |
| 13 | Thu Jan 15, 08:09 AM | 10 | 0 | 3 | 13 | 13 | yes |

Column totals of the 13 rows: Reactions 12,268, Comments 394, Shares 1,646, Engagements 14,308, which equal the Sum row. The values are identical to the 2026-10-28 run, so the data is stable day to day.

## Evidence
- Screenshots in `.playwright-out/QA-100873/`: `r3-01-content-landing.png`, `r3-02-brand.png`, `r3-03-dates.png`, `r3-04-threads.png`, `r3-05-table.png`.
- Table columns scraped: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions.
- No render hang this run: the post list and the Table View rendered on the first load, well inside the 5-minute step budget.

## Known bugs checked
- Case file: "Open linked bugs: None open" (Rule 7 screen passed). `knowledge-base/bug-history.md` has no entry for QA-100873.
- Related known-quirk: the dev `/content` HTTP 500 / render-hang on Threads (seen 2026-10-28, attempt 1). It did not reproduce this run, so it did not touch any step or assertion.

## Bugs filed
None.

## Notes
- The headless harness bootstrap also signed in a prod tab (`app.listenfirstmedia.com`) alongside dev because `devprod-helpers.js` opens both. All case steps ran on dev only, and prod was not used or modified.
- Maintenance (skill pass_streak, REGISTRY) is deferred to harvest.sh as instructed.
