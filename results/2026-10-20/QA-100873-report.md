# QA-100873 — Brand > Content - Basic Data Set - Threads

**Verdict: PASS**

- Run: 2026-10-20, unattended headless (Playwright MCP), skill `brand-content-grid-math` (+ date-picker mechanics from `brand-content-native-post-check`)
- Env: app.lfmdev.in, login lfiqa@listenfirstmedia.com, account switched to **HBO Max** (account_id 657) — the only "Max" result in Search Account Results

## Steps executed
1. Login via Cognito "With existing account" form. Account menu (LFQA) → Search Account "Max" → clicked Results entry "HBO Max". Hover **Brand** → **Content** → `#explore/brand/content?brand_id=155614&account_id=657`.
2. Clicked the Brand dropdown (chevron / brand name) → "Search for a Brand" textarea.
3. Typed "HBO Max"; the typeahead's Results list (slow on dev; needed Backspace + retype to surface) contained the literal exact entry "HBO Max" (also many "HBO Max (xxx)" variants); clicked the exact "HBO Max" → brand_id=155614 (selector shows "HBO Max"). Date range via START DATE / END DATE picker: Jan 01, 2026 → Jan 15, 2026 → Ok; URL `from=2026-01-01&to=2026-01-15`.
4. Channels: trusted-clicked the ghosts for twitter/instagram/facebook/linkedin/tiktok off; verified only `threads enabled` (youtube/pinterest were already disabled) → Apply. URL `channels=threads`; `Posts (13)`. Data set: Public (default, "Basic" set for Threads); perspective as loaded (`extended`, Authorized data) — spec names no perspective.
5. Switched to Table View (`[title="Table View"]`), scraped all 13 posts + Sum row from DOM; evaluated Reactions + Comments + Shares = Engagements per post and for the Sum row.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5.1 | 5 | Per post: Reactions + Comments + Shares = Engagements (13 posts) | 13/13 posts match exactly (table below) | PASS |
| A5.2 | 5 | Aggregate Sum row: Reactions + Comments + Shares = Engagements | 12,268 + 394 + 1,646 = 14,308 = Engagements 14,308 | PASS |
| A5.3 | 5 | Sum row equals the sum of the individual rows (sanity) | Hand-summed columns: Eng 14,308, Reactions 12,268, Comments 394, Shares 1,646 — all equal the Sum row | PASS |

### Per-post evidence (Threads, HBO Max, Jan 1–15 2026)
| # | Published | Reactions | Comments | Shares | R+C+S | Engagements | Match |
|---|-----------|-----------|----------|--------|-------|-------------|-------|
| 1 | Jan 04 08:00 | 5,232 | 74 | 580 | 5,886 | 5,886 | yes |
| 2 | Jan 09 17:08 | 2,629 | 73 | 363 | 3,065 | 3,065 | yes |
| 3 | Jan 11 22:20 | 1,862 | 18 | 272 | 2,152 | 2,152 | yes |
| 4 | Jan 01 14:00 | 668 | 7 | 103 | 778 | 778 | yes |
| 5 | Jan 14 08:00 | 399 | 190 | 141 | 730 | 730 | yes |
| 6 | Jan 09 16:00 | 435 | 10 | 51 | 496 | 496 | yes |
| 7 | Jan 03 09:01 | 316 | 2 | 28 | 346 | 346 | yes |
| 8 | Jan 02 10:00 | 293 | 6 | 25 | 324 | 324 | yes |
| 9 | Jan 14 16:00 | 237 | 9 | 46 | 292 | 292 | yes |
| 10 | Jan 13 08:00 | 92 | 2 | 20 | 114 | 114 | yes |
| 11 | Jan 08 10:30 | 72 | 3 | 13 | 88 | 88 | yes |
| 12 | Jan 08 09:15 | 23 | 0 | 1 | 24 | 24 | yes |
| 13 | Jan 15 08:09 | 10 | 0 | 3 | 13 | 13 | yes |
| Sum | | 12,268 | 394 | 1,646 | 14,308 | 14,308 | yes |

No "–" values in Engagements / Reactions / Comments / Shares for any Threads post (Video Views is "–" for Threads, not part of the identity).

## Evidence
Screenshots in `.playwright-out/QA-100873/`: `brand-typeahead.png`, `picker-open.png`, `picker-start.png`, `picker-end.png`, `threads-applied.png`, `table-view.png`.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-100873 entries (pre-fetched grep). Nothing reproduced that touches the assertions.
- Environment note (not a bug against this case): the status-page banner "Facebook Posts Insights Disruption" is shown; Facebook is not in scope for this Threads-only case.

## Notes
- Brand typeahead on dev: only "Recent Searches" displayed at first; Results appeared after Backspace + retype of the last character (already a documented dev gotcha).
- Date-picker: START/END DATE pickers navigated via switch → months → years → month → day (works as documented).

## Bugs filed
None.
