# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Verdict: PASS** (the one brand the spec names for Friday, Hulu, passes. The Robinhood and PlayOn! Sports accounts have no brand in the spec, so those two legs were not run — see "Spec gap")

- Run: 2026-10-30 (Friday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on HULU after login).
- Weekday row executed: Friday — Accounts Hulu / Robinhood / PlayOn! Sports -> Brands `Hulu` (the Brands cell lists only "Hulu"). The Description table is authoritative; the case-file Notes weekday line is stale.
- Skill: `brand-content-grid-math` (Table View DOM scrape) via `_shared/playwright-helpers/devprod-helpers.js` (dev tab only; prod not touched).
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

| Leg | Account (id) | Brand (id) | Spec range Jan 01 – Dec 31, 2023 | Verdict |
|---|---|---|---|---|
| 1 | Hulu (336) | Hulu (5670) | Selected via picker; URL `from=2023-01-01&to=2023-12-31` | PASS — 200/200 posts + aggregate |
| 2 | Robinhood | none in spec | not run | NOT RUN (spec gap) |
| 3 | PlayOn! Sports | none in spec | not run | NOT RUN (spec gap) |

## Steps executed
1. Logged in via Cognito "With existing account" (`#home`, `ACCOUNT: HULU`).
2. Switched account through the account menu: Search Account -> `Results` row `Hulu`. Breadcrumb confirmed `ACCOUNT: HULU`.
3. Hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
4. **Add a Brand:** brand selector -> typed `Hulu` -> clicked the exact-name `.lfm-ta-option` Result (Rule 1). Header and URL confirmed `Hulu`, `brand_id=5670`, `account_id=336`. The 5670 -> 11003 redirect from known-quirks (2026-06-08) did **not** occur this run.
5. Date range via the START/END pickers: `Jan 01, 2023` / `Dec 31, 2023` -> Ok. Picker fields read `START DATE Jan 01, 2023 / END DATE Dec 31, 2023`; the header read `Date Range: Jan. 01, 2023 - Dec. 31, 2023`. No retention floor hit.
6. Channels: clicked the Facebook ghost and Apply (Rule 2, explicit clicks). `.channel-ghost.enabled` = `facebook` only, URL `channels=facebook`. Data set left on `Public` and perspective on the default `extended` (the spec asks for neither). Dev took about 2 minutes to settle; the header ended at `Posts (1,022)`.
7. Switched to **Table View** (`[title="Table View"]`, `table.lfm-table` with a `Rank` header). Scraped the header, 200 rendered rows and the Sum/Average row via DOM, and evaluated Reactions + Comments + Shares = Engagements in page JS.

## Assertions

Assertion 5: Reactions + Comments + Shares = Engagements (each grid post; aggregate Sum row).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-Hulu-posts | 5 | Every FB post: R + C + S = Engagements | 200 of 200 rendered posts match exactly (0 failures, 0 no-data, 0 posts with a "–" component). All 200 dated 2023 (rank 1 Fri Dec. 29, 2023 ... rank 200 Fri Nov. 03, 2023). #1: 628,286 + 40,169 + 108,589 = 777,044; #2 (Thu Jul. 27, 2023): 319,153 + 1,566 + 16,825 = 337,544; #3 (Thu Oct. 12, 2023): 167,088 + 4,113 + 7,086 = 178,287 | PASS |
| A5-Hulu-sum | 5 | Aggregate Sum row identity | 3,782,516 + 177,461 + 454,871 = 4,414,848 = Engagements 4,414,848 | PASS |

## Evidence
- Filters at assertion time: Facebook only, Jan. 01 - Dec. 31 2023, Public data set, sorted by Engagements, perspective `extended`, Posts (1,022).
- Table columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions. Table View has no text column for Channel (icon only), so channel was verified via `.channel-ghost.enabled` = `facebook` and URL `channels=facebook`.
- Screenshots in `.playwright-out/QA-20318/`: `hulu-1-brand.png`, `hulu-2-dates.png`, `hulu-3-facebook.png`, `hulu-3b-state.png`, `hulu-4-table.png`. I did not open them; state was verified through DOM text, URL and class checks.
- Console: the dev app logs many console errors (`.playwright-out/console-2026-10-30T05-49-41-074Z.log`); none affected the grids or the assertion.

## Scope note
Table View renders 200 posts per page, so the per-post identity covers the top 200 posts by Engagements out of 1,022. The aggregate Sum row covers the full filtered set and its identity also holds.

## Spec gap
The Friday row lists three accounts (Hulu, Robinhood, PlayOn! Sports) but a single brand (`Hulu`); the Brands cell has a trailing blank. Rule 1 forbids inventing a brand, so Robinhood and PlayOn! Sports were not run and are not counted in the verdict. Spec owner: add the intended Robinhood and PlayOn! Sports brand names to the Brands cell, or trim the Accounts list.

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` / `known-quirks.md` had no QA-20318 bug matches (pre-fetched).
- The known-quirk "Hulu brand_id 5670 auto-redirects to 11003" (2026-06-08) did not reproduce; the URL stayed on 5670.
- The known quirk about Jan 2023 falling outside the data-retention window did not apply to Hulu (the picker accepted Jan 01, 2023).
- No bug reproduced.

## Bugs filed
None.

## Notes for harvest
- `m.waitPosts` regex `Posts \((\d+)\)` ignores comma counts (`Posts (1,022)`), so `setChannels` returned `posts: null` after its full 90 s wait. Change the regex to `/Posts \(([\d,]+)\)/` in `devprod-helpers.js`.
- `browser_run_code_unsafe` echoes the code it ran even when loaded via `filename`, so the temporary credentials loader's contents (including the password) appear in the tool output. The loader file was deleted after use.
- Friday dev run: login landed directly on `ACCOUNT: HULU`, so the account switch was a no-op confirmation.
