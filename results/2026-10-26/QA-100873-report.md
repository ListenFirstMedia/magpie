# QA-100873 — Brand > Content - Basic Data Set - Threads

**Run date:** 2026-10-26 (Monday → HBO Max) · **Track:** Playwright MCP, unattended headless · **Account:** HBO Max (header "ACCOUNT: HBO MAX", switched from the post-login default "Adam Orfei" via the profile menu Search Account → Results → `HBO Max`) · **Brand:** HBO Max (brand_id 155614, exact `HBO Max` row picked from the typeahead Results, Rule 1) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker, field text confirmed) · **Channel:** Threads only · **Data set:** Public (Basic) · **View:** default perspective (spec gives none) · **Layout:** Table View.

**Verdict: PASS** — for all 13 Threads posts, and for the Sum row, Reactions + Comments + Shares = Engagements exactly.

## Steps executed
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com). Landed on `#home` as ADAM ORFEI; switched account to HBO Max (clicked `HBO Max` under Results); header showed "ACCOUNT: HBO MAX".
2. Hovered **Brand** in the top nav → clicked **Content** → `#explore/brand/content`.
3. Clicked the Brand selector, typed "HBO Max" slowly; Results listed exact `HBO Max` first (plus "HBO Max (ANZ)", "(APAC)", ...). Clicked the literal `HBO Max` → brand selector shows HBO Max, `brand_id=155614`.
4. Opened the date picker, set START Jan 01, 2026 and END Jan 15, 2026, clicked Ok → URL `from=2026-01-01&to=2026-01-15`.
5. Channels: clicked Twitter, Instagram, Facebook, LinkedIn, TikTok off (trusted mouse clicks); ghosts after = only `threads enabled` → Apply → URL `channels=threads`.
6. First load of the Posts table showed "This table failed to load" → clicked Reload once (known recover-first rule) → `Posts (13)` rendered.
7. Switched to Table View (`[title="Table View"]`), scraped all 13 rows + aggregate row from the visible Rank-header `table.lfm-table`.
8. Per post: Reactions + Comments + Shares compared with Engagements.

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

Cross-check: summing the 13 per-post columns independently gives Reactions 12,268, Comments 394, Shares 1,646, Engagements 14,308 — identical to the Sum row.

## Evidence
Screenshots in `.playwright-out/QA-100873/`: `01-content-landing.png`, `02-daterange-picker.png`, `03a-after-apply.png` (table failed-to-load state), `03b-after-reload.png`, `04-table-view.png` (13 rows), `05-average-row.png`. All numbers are read from the visible Table View DOM (`tbody tr` cells). The Channel cell is an icon (no text); single-channel state was verified via the `.channel-ghost` classes (only `threads enabled`) and `channels=threads` in the URL after Apply. Every row's Brand cell = HBO Max.

## Notes
- The Average row was not read (the toggle click did not change the row; the case only asks per-post and engagement identities, so it does not affect the verdict).
- Transient "This table failed to load" right after Apply cleared on a single Reload (counts as recovered, not a block).
- Spec's "Max" precondition resolved to account `HBO Max` (Monday rotation per set convention).

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). knowledge-base/bug-history.md and known-quirks.md: no matches for QA-100873 (pre-fetched). No bug reproduced or interfered; the identity holds on every post.

## Bugs filed
None. · **Cleanup:** none (read-only).
