# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Verdict: PASS**

- Run: 2026-10-26 (Monday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- Account / Brand: **HBO MAX** / **HBO Max** (brand_id=155614, account_id=657). This is the Monday row of the case's weekday table.
- Skill used: `brand-content-grid-math` (Table View DOM scrape) with `_shared/playwright-helpers/devprod-helpers.js`
- An earlier attempt the same day was killed at the 900 s cap before it could write a report. This run replaces that placeholder.

## Steps executed
1. Logged in via the Cognito "With existing account" form. The account was ADAM ORFEI after login, so I switched to HBO MAX using the account menu. The header showed `ACCOUNT: HBO MAX`. Hovered Brand in the top nav and clicked Content (`#explore/brand/content`).
2. Set the brand through the brand selector. Typed `HBO Max` and clicked the exact-match typeahead result. Header confirmed `HBO Max`, `brand_id=155614`.
3. Set the date range through the START/END date pickers. The fields showed `Jan 01, 2023` / `Dec 31, 2023`, the header showed `Date Range: Jan. 01, 2023 - Dec. 31, 2023`, and the URL showed `from=2023-01-01&to=2023-12-31`. Posts (8,674) with all channels.
4. Enabled Facebook only. Clicked the other channel ghosts off and applied. `.channel-ghost.enabled` = `facebook` only, URL `channels=facebook`. Data set stayed on Public, which has Engagements, Reactions, Comments and Shares columns. Posts (2,641).
5. Switched to Table View (`[title="Table View"]`). Scraped all rendered rows via DOM and evaluated Reactions + Comments + Shares = Engagements for each post, plus the aggregate row.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Per post: Reactions + Comments + Shares = Engagements | 200 of 200 rendered posts match exactly. 0 failures, 0 skipped, 0 posts with a "–" component. | PASS |
| A2 | 5 | Same identity on the aggregate (Sum) row | Engagements 12,622,652 = 11,571,981 + 289,515 + 761,156 = 12,622,652 (diff 0) | PASS |

## Evidence
- Filters at assertion time: Facebook only, Jan. 01 – Dec. 31 2023, Public data set, sorted by Engagements, Posts (2,641), perspective `extended` (the default).
- Sample rows:
  - Rank 1: 970,108 = 955,390 + 2,553 + 12,165
  - Rank 2: 659,110 = 646,923 + 2,103 + 10,084
  - Rank 3: 295,095 = 225,097 + 23,229 + 46,769
  - Rank 200: Engagements 10,651
- Rendered rows span Apr 07 – Sep 27, 2023, all brand `HBO Max`.
- Screenshots in `.playwright-out/QA-20318/`: `03-brand.png`, `04-dates.png`, `05-postdates.png`, `06-facebook.png`, `07-table.png`. I did not open them. State was verified through DOM text, URL and `.channel-ghost` classes.

## Scope note
Table View renders 200 posts per page, so the per-post identity covers the top 200 posts by Engagements out of 2,641. The aggregate row covers the full filtered set, and its identity also holds. That is the same coverage the `brand-content-grid-math` skill uses for every other run.

## Known bugs checked
- The case file's "Open linked bugs" section says None open, so the open-bug screen passed.
- `bug-history.md` and `known-quirks.md` had no QA-20318 matches (pre-fetched).
- No bug reproduced. Console errors were logged by the dev app (`.playwright-out/console-2026-10-26T10-34-31-986Z.log`). None affected the grid or the assertion.

## Bugs filed
None.

## Notes for harvest
- `page.goto` to dev timed out at 30 s on the first login attempt. A retry with `domcontentloaded` succeeded. After the account switch the page sat on "Loading..." for about 10 s before the home page rendered.
- `m.waitPosts` only matches `Posts (\d+)` and returns null for counts with thousands separators such as `Posts (8,674)`. The page was rendered anyway, so the call just burned its timeout. The regex should accept commas. I did not change the helper because this run defers maintenance.
