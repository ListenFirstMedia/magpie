# QA-100873 — Brand > Content - Basic Data Set - Threads

**Run date:** 2026-10-27 · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-grid-math` + `devprod-helpers.js` · **Account:** HBO Max (header "ACCOUNT: HBO MAX", switched from the post-login default via profile menu Search Account → Results → `HBO Max`) · **Brand:** HBO Max (brand_id 155614, exact `HBO Max` row picked from the typeahead Results, Rule 1) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker; fields read back "Jan 01, 2026 / Jan 15, 2026") · **Channel:** Threads only (`channels=threads`; ghosts: `threads enabled`, all 7 others `disabled`) · **Data set:** Public / Basic (`table_data_set=public`) · **View:** default perspective (`perspective=extended`; spec gives none) · **Layout:** Table View.

**Verdict: PASS** — for all 13 Threads posts, and for the Sum row, Reactions + Comments + Shares = Engagements exactly.

## Steps executed
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com); landed on `#home`; switched account to HBO Max (header confirmed "ACCOUNT: HBO MAX").
2. Hovered **Brand** in the top nav → clicked **Content** → `#explore/brand/content`.
3. Clicked the Brand selector, typed "HBO Max"; clicked the exact `HBO Max` row in the typeahead → selector reads "HBO Max", `brand_id=155614`. Opened the date picker, set START Jan 01, 2026 and END Jan 15, 2026, clicked Ok → URL `from=2026-01-01&to=2026-01-15`.
4. Channels: clicked the other channels off (trusted clicks), left Threads on → Apply → URL `channels=threads`, `Posts (13)`.
5. Switched to Table View (`[title="Table View"]`); scraped all 13 rows + the aggregate row from the Rank-header `table.lfm-table`; per post computed Reactions + Comments + Shares and compared with Engagements.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-1 | 5 (post #1, Jan 4) | R+C+S = Engagements | 5,232 + 74 + 580 = 5,886; Eng 5,886 | PASS |
| A5-2 | 5 (#2, Jan 9) | same | 2,629 + 73 + 363 = 3,065; Eng 3,065 | PASS |
| A5-3 | 5 (#3, Jan 11) | same | 1,862 + 18 + 272 = 2,152; Eng 2,152 | PASS |
| A5-4 | 5 (#4, Jan 1) | same | 668 + 7 + 103 = 778; Eng 778 | PASS |
| A5-5 | 5 (#5, Jan 14) | same | 399 + 190 + 141 = 730; Eng 730 | PASS |
| A5-6 | 5 (#6, Jan 9) | same | 435 + 10 + 51 = 496; Eng 496 | PASS |
| A5-7 | 5 (#7, Jan 3) | same | 316 + 2 + 28 = 346; Eng 346 | PASS |
| A5-8 | 5 (#8, Jan 2) | same | 293 + 6 + 25 = 324; Eng 324 | PASS |
| A5-9 | 5 (#9, Jan 14) | same | 237 + 9 + 46 = 292; Eng 292 | PASS |
| A5-10 | 5 (#10, Jan 13) | same | 92 + 2 + 20 = 114; Eng 114 | PASS |
| A5-11 | 5 (#11, Jan 8) | same | 72 + 3 + 13 = 88; Eng 88 | PASS |
| A5-12 | 5 (#12, Jan 8) | same | 23 + 0 + 1 = 24; Eng 24 | PASS |
| A5-13 | 5 (#13, Jan 15) | same | 10 + 0 + 3 = 13; Eng 13 | PASS |
| A5-Sum | 5 (aggregate Sum row) | R+C+S = Engagements | 12,268 + 394 + 1,646 = 14,308; Eng 14,308 | PASS |

Cross-check: independently summing the 13 per-post columns gives Reactions 12,268, Comments 394, Shares 1,646, Engagements 14,308 — identical to the Sum row. All values are populated (no "–" cells in these four columns).

## Evidence
- Screenshots in `.playwright-out/QA-100873/`: `01-content-landing.png`, `02-after-dates.png`, `03-after-channel.png` (Threads-only), `04-table-view.png` (13 rows).
- All numbers read from the Table View DOM (`tbody tr` cells). Column headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions. Every row's Brand cell = HBO Max.
- No "This table failed to load" state occurred this run; `Posts (13)` rendered after Apply.

## Notes
- Spec precondition "logged in as Max" resolved to account `HBO Max` / brand `HBO Max` (same resolution as the 2026-10-20 and 2026-10-26 runs). The case text should be updated to "HBO Max".
- Result is identical to the 2026-10-26 run (same 13 posts, same values).
- The Average row was not read; the case asks only for per-post and engagement identities.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). `bug-history.md` and `known-quirks.md`: no matches for QA-100873 (pre-fetched). No bug reproduced or interfered; the identity holds on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).

**Verdict: PASS**
