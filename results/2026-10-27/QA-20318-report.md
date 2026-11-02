# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Verdict: PASS** (2 of 3 Tuesday legs fully evaluated and passing; Gatorade leg BLOCKED on test-data drift, not a product bug)

- Run: 2026-10-27 (Tuesday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on RALPH LAUREN after login).
- Weekday row executed: Tuesday — Accounts UCLA / Viacom / Wasserman -> Brands University of California, Los Angeles / MTV / Gatorade (all three legs, same as the 2026-10-20 Tuesday run).
- Skill: `brand-content-grid-math` (Table View DOM scrape) with `_shared/playwright-helpers/devprod-helpers.js` (dev tab only; prod not touched).
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

| Leg | Account (id) | Brand (id) | Verdict |
|---|---|---|---|
| 1 | UCLA (799) | University of California, Los Angeles (127756) | PASS — 200/200 posts + aggregate |
| 2 | Viacom (181) | MTV (4018) | PASS — 200/200 posts + aggregate |
| 3 | Wasserman (863) | Gatorade (3580) | BLOCKED (test-data) — Jan 01, 2023 not selectable (retention floor); fallback range has 0 FB posts |

## Steps executed (per leg)
1. Logged in via Cognito "With existing account". The first `m.login` call returned before the auth redirect landed (page bounced to the sign-in form); a second call completed login at `#home`.
2. Switched account through the account menu: Search Account -> `Results` row. Breadcrumb confirmed `ACCOUNT: UCLA` / `VIACOM` / `WASSERMAN`.
3. Hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
4. **Add a Brand:** brand selector -> typed the name -> clicked the exact-name `.lfm-ta-option` Result (Rule 1). Header confirmed each brand and brand_id.
5. Date range via START/END date pickers: `Jan 01, 2023` / `Dec 31, 2023` -> Ok -> URL `from=2023-01-01&to=2023-12-31` (legs 1, 2). Leg 3: see below.
6. Channels: clicked the non-Facebook ghosts off and Apply; `.channel-ghost.enabled` = `facebook` only, URL `channels=facebook` (Rule 2). Data set left on `Public` (spec only asks for the channel).
7. Switched to **Table View** (`[title="Table View"]`), scraped header + 200 rendered rows + the Sum/Average row via DOM, and evaluated Reactions + Comments + Shares = Engagements in page JS.

## Assertions

Assertion 5: Reactions + Comments + Shares = Engagements (each post, plus aggregate Sum row).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-UCLA-posts | 5 | Every FB post: R + C + S = Engagements | 200 of 200 rendered posts match exactly (0 failures, 0 no-data, 0 posts with a "–" component). All 200 dated 2023. Posts (1,244) in range. #1 (Sun Sep. 17, 2023): 2,998 + 140 + 548 = 3,686; #2 (Mon Aug. 28, 2023): 3,192 + 53 + 166 = 3,411 | PASS |
| A5-UCLA-sum | 5 | Aggregate Sum row identity | 165,196 + 5,050 + 9,374 = 179,620 = Engagements 179,620 | PASS |
| A5-MTV-posts | 5 | Every FB post: R + C + S = Engagements | 200 of 200 match (0 failures, 0 no-data, 0 partial). All 200 dated 2023. Posts (2,107) in range. #1 (Thu Dec. 14, 2023): 687,756 + 12,891 + 73,005 = 773,652; #2 (Fri Dec. 15, 2023): 304,801 + 6,081 + 79,948 = 390,830 | PASS |
| A5-MTV-sum | 5 | Aggregate Sum row identity | 9,386,040 + 226,926 + 874,658 = 10,487,624 = Engagements 10,487,624 | PASS |
| A5-Gatorade | 3-5 | Jan 01 - Dec 31, 2023 selectable; FB posts satisfy R + C + S = Engagements | Picker for Gatorade (Wasserman acct 863): in the 2023 view months Jan-Sep are `disabled`; Oct 2023 days 1-24 are disabled; earliest selectable day = **Oct 25, 2023**. Spec range cannot be set. Non-spec probe (NOT used for the verdict): Oct 25 - Dec 31, 2023, Facebook only -> **Posts (0)**, no table, nothing to evaluate | BLOCKED (test-data drift) |

## Evidence
- Filters at assertion time (legs 1, 2): Facebook only, Jan. 01 - Dec. 31 2023, Public data set, sorted by Engagements, perspective `extended`.
- Rendered-row date spans: UCLA ends at rank 200 = Sat Sep. 23, 2023 (Engagements 205); MTV ends at rank 200 = Fri Nov. 03, 2023 (Engagements 6,500).
- Table View has no text column for Channel (icon only), so channel was verified via `.channel-ghost.enabled` = `facebook` and URL `channels=facebook`.
- Screenshots in `.playwright-out/QA-20318/`: `ucla-1-brand/2-dates/3-facebook/4-table.png`, `mtv-1-brand/2-dates/3-facebook/4-table.png`, `gatorade-1-brand.png`, `gatorade-2-dates.png`, `gatorade-3-picker.png`, `gatorade-4-oct-days.png`, `gatorade-5-probe-fb.png`. I did not open them; state was verified through DOM text, URL and class checks.
- Console: the dev app logs many console errors (`.playwright-out/console-2026-10-27T06-56-27-883Z.log`); none affected the grids or the assertion.

## Scope note
Table View renders 200 posts per page, so the per-post identity covers the top 200 posts by Engagements out of 1,244 (UCLA) and 2,107 (MTV). The aggregate Sum row covers the full filtered set and its identity also holds.

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` / `known-quirks.md` had no QA-20318 matches (pre-fetched).
- Gatorade leg matches the known quirk "2026-06-29 — Fixed historical date ranges in old specs roll out of the ~3-year data-retention window" (known-quirks.md, found via the 2026-10-20 report). Wasserman's floor moved from Oct 18, 2023 (2026-10-20) to Oct 25, 2023 today, i.e. it slides forward daily. Accepted behavior; no bug filed. UCLA (799) and Viacom (181) still allow Jan 2023.
- No bug reproduced.

## Bugs filed
None.

## Notes for harvest
- `m.login` can return before the Cognito redirect lands (page showed `app.lfmdev.in/` titled "Brand Explorer", then bounced to `auth.lfmdev.in`). Fix: poll up to ~20 s for either `#home` or an `auth.` URL, and sign in if the latter.
- `m.waitPosts` regex `Posts \((\d+)\)` ignores comma counts (`Posts (1,244)`); I overrode it in-session with `/Posts \(([\d,]+)\)/`. The helper file should be updated.
- Spec owner: the Wasserman/Gatorade leg stays un-runnable while the fixed 2023 range is outside the account's retention window; express the range relatively or move to a newer fixed range.
- `require` is not available in `browser_run_code_unsafe`, so credentials had to be injected via a temporary generated file (deleted afterwards). Note the tool echoes the code it ran, including the password, in its output.
