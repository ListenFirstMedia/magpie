# QA-100873 — Brand > Content - Basic Data Set - Threads

**Run date:** 2026-10-28 (re-run) · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-grid-math` + `devprod-helpers.js` · **Account:** HBO Max (profile menu → Search Account → Results → `HBO Max`; header "ACCOUNT: HBO MAX") · **Brand:** HBO Max (brand_id 155614, exact `HBO Max` row from the typeahead, Rule 1) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker; fields read back "Jan 01, 2026 / Jan 15, 2026", URL `from=2026-01-01&to=2026-01-15`) · **Channel:** Threads only (`channels=threads`; only the `threads` ghost enabled) · **Data set:** Public (`table_data_set=public`) · **View:** default perspective (`perspective=extended`; the spec names none).

**Verdict: PASS**

## Run history today
An earlier attempt at 14:15 IST ended BLOCKED (render-hang: dev `data-api /content` returned HTTP 500, Posts list never rendered; that report is kept as `QA-100873-report.attempt1-blocked.md.bak`). This re-run, about 45 minutes later, found the backend healthy and rendered the full Posts list on the first load, so the earlier BLOCKED was a transient dev outage. The earlier attempt was also not a spec problem.

## Steps executed
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com), landed on `#home`; switched account to HBO Max (header confirmed).
2. Hovered **Brand** in the top nav and clicked **Content**, which opened `#explore/brand/content`.
3. Clicked the Brand dropdown, typed "HBO Max" and clicked the literal `HBO Max` row. The selector reads "HBO Max" and the URL has `brand_id=155614`. Opened the date picker and set START Jan 01, 2026 and END Jan 15, 2026, then clicked Ok (screenshot `r2-02-dates.png`).
4. Channels: enabled Threads, turned the other channels off and clicked Apply. Only `threads` is enabled, `Posts (13)` rendered (`r2-03-threads.png`).
5. Switched to Table View (`r2-04-table.png`). Scraped all 13 Threads post rows from the DOM, then computed Reactions + Comments + Shares for each post and compared it with Engagements.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Reactions + Comments + Shares = Engagements for each Threads post | 13 of 13 posts match exactly; 0 mismatches, 0 "–" / no-data rows (per-post table below) | PASS |
| A5-agg | 5 | The Sum row follows the same identity (supporting check) | Sum row: 12,268 + 394 + 1,646 = 14,308 = Engagements 14,308 | PASS |

### Per-post evidence (Table View, Public data set, sorted by Engagements desc)
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

Column totals of the 13 rows: Reactions 12,268, Comments 394, Shares 1,646, Engagements 14,308, which equal the Sum row.

## Evidence
- Screenshots in `.playwright-out/QA-100873/`: `r2-01-brand.png`, `r2-02-dates.png`, `r2-03-threads.png`, `r2-04-table.png` (this re-run). The other files in that folder come from earlier runs.
- Console log `.playwright-out/console-2026-10-28T08-59-53-972Z.log` contains dev-environment network errors (35+ console errors), but the content data rendered fully and none of them affected the assertions.
- Results match the 2026-10-20, 10-26 and 10-27 runs, which also found 13 Threads posts and passed.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). `bug-history.md` and `known-quirks.md`: no matches for QA-100873 (pre-fetched). The HTTP 500 on dev `data-api /content` seen during the 14:15 attempt did not reproduce, so it is not tied to any ticket and did not affect this verdict. The "Facebook Data Collection Disruption 9/27" banner is unrelated to Threads.

## Bugs filed
None (markdown-only policy; no Jira created).

**Cleanup:** none (read-only). The temporary login bootstrap file was deleted.

**Verdict: PASS**
