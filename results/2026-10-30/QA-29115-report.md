# QA-29115 — Brand Content > Basic Data Set > Past date range data test - LinkedIn

**Verdict: PASS**

- Run: 2026-10-30, headless `claude -p`, Playwright MCP, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com
- Account: UCLA (account_id=799), switched via profile menu > Search Account > Results "UCLA" (not "UCLA Law")
- Brand: University of California, Los Angeles (brand_id=127756), chosen from the brand typeahead Results (see Notes)
- Date range: Jan 01, 2025 – Oct 01, 2025 (URL `from=2025-01-01&to=2025-10-01`)
- Channel: LinkedIn only (URL `channels=linkedin`), Data Set = Public (Basic), perspective left at default (Authorized, `perspective=extended`; spec does not name a perspective)

## Steps executed
1. Logged in via Cognito "With existing account" form, landed on `#home`. Switched account to UCLA. Hovered **Brand** > clicked **Content** (`#explore/brand/content`).
2. Opened the brand selector, typed `UCLA` in "Search for a Brand": the typeahead returned only `UCLA …`-prefixed brands (UCLA Alumni, UCLA Anderson, UCLA Health, UCLA Law …) and no brand named exactly "UCLA". Searched `University of California, Los` and clicked the exact Results entry "University of California, Los Angeles" (127756). That is the UCLA account's primary brand and the one the existing `brand-content-native-post-check` skill treats as "UCLA".
3. Opened the date picker, clicked **Start Date** → Jan 01, 2025 (end auto-moved to Dec 31, 2025), clicked **End Date** → Oct 01, 2025, **Ok**. Picker fields read `Jan 01, 2025 → Oct 01, 2025`; URL updated to `from=2025-01-01&to=2025-10-01`.
4. Clicked off Facebook/Twitter/Instagram/TikTok/Threads ghosts (explicit clicks); only `linkedin enabled` remained (YouTube/Pinterest disabled). **Apply** → `Posts (1,013)`.
5. Switched to **Table View**, scrolled to lazy-load all rows (200 per batch: 201→401→601→801→1001→1014 rows = 1,013 posts + Sum row), and evaluated Reactions + Comments + Shares = Engagements for every post in page JS.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | For each LinkedIn post, Reactions + Comments + Shares = Engagements | 1,013 / 1,013 posts match exactly; 0 mismatches; 0 posts with "–" in Engagements/Reactions/Comments/Shares | PASS |
| A1b | 5 | Aggregate (Sum row) satisfies the same formula | Sum row: Reactions 133,014 + Comments 4,270 + Shares 7,147 = 144,431 = Engagements 144,431. Independent per-row column totals (133,014 / 4,270 / 7,147 / 144,431) equal the Sum row exactly | PASS |

## Evidence
- Post count: `Posts (1,013)`; last table rank 1,013, 1,013 unique ranks.
- Sample rows: #1 (Sat Mar. 15, 2025 09:32 AM PDT) Engagements 2,923 = 2,792 + 64 + 67; #1,013 (Tue Jun. 10, 2025) Engagements 3 = 3 + 0 + 0.
- Screenshots (`.playwright-out/QA-29115/`): `r3-00-home.png`, `r3-01-account-ucla.png`, `r3-03b-typeahead-results.png`, `r3-03c-typeahead-univ.png`, `r3-03d-brand-selected.png`, `r3-04e-dates-picked.png`, `r3-05a-channels-before-apply.png`, `r3-05b-linkedin-only.png`, `r3-06-table-view.png`, `r3-09-loaded-all.png`.

## Notes
- Brand interpretation: no brand named exactly "UCLA" exists in the typeahead; the case's precondition is the UCLA account, whose primary brand is "University of California, Los Angeles". Used that exact-name brand; no other brand substituted.
- UI drift vs the `brand-content-grid-math` / `brand-content-native-post-check` skills: Table View does not paginate by 200 here; it lazy-loads another 200 on each scroll to the bottom (a slow ~20–40 s per batch on dev; scroll up/down with the mouse wheel to retrigger). The date-picker buttons are labelled "Start Date"/"End Date" (uppercased by CSS) and the picker's month/year switch uses `.datepicker-switch` (click twice for the year grid). Candidate skill updates for harvest.sh.
- Other days' attempts left screenshots in the same folder (Oct 26–29); this run used fresh `r3-*` filenames.

## Known bugs checked
- Case file "Open linked bugs": None open (as of 2026-10-20) → Rule 7 screen passed. Pre-fetched grep of bug-history.md / known-quirks.md for QA-29115: no matches. No related bug reproduced; no interference with the assertions. The "Facebook Data Collection Disruption 9/27" banner is Facebook-only and irrelevant to the LinkedIn-only view.

## Bugs filed
None.
