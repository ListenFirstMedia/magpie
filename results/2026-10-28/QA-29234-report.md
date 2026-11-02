# QA-29234 — Brand Content > Video Views Data Set > Past date range data test - (Twitter/Instagram)

**Verdict: BLOCKED (test-data drift + account precondition)**. The spec range (Jan. 01, 2023 – Jan. 10, 2023) cannot be set on any Wednesday brand, and the Wednesday account "NBCU EnterPrises" (CNBC / NBC News legs) is not visible to the test user. No leg could be run on the exact spec configuration, so no assertion was evaluated against the spec. Non-spec probes (below) are informational only and do not set the verdict.

- Run: 2026-10-28 (Wednesday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on ADAM ORFEI; switched to APPLE SERVICES, account_id 409).
- Weekday row: Wednesday per the Description table: Accounts Apple Services / NBCU EnterPrises, Brands Apple Music / CNBC / NBC News. The case `## Notes` line (Wed = Apple Services/Wasserman) disagrees; the Description table was treated as authoritative (same call as QA-20318 today).
- Skill: `brand-content-grid-math` (Table View DOM scrape) via `_shared/playwright-helpers/devprod-helpers.js` (dev tab only).
- Open-bug screen (Rule 7): case file says "None open" → ran normally.

| Leg | Account | Brand | Spec range (Jan 01–10, 2023) | Verdict |
|---|---|---|---|---|
| 1 | Apple Services (409) | Apple Music (31783) | Not selectable (retention floor Oct 26, 2023) | BLOCKED (test-data) |
| 2 | NBCU EnterPrises | CNBC | Account not findable (floor is also Oct 26, 2023 for the brand family) | BLOCKED (account precondition) |
| 3 | NBCU EnterPrises | NBC News | Account not findable; brand not findable under Apple Services | BLOCKED (account precondition) |

## Steps executed
1. Logged in via Cognito "With existing account"; account menu → Search Account → `Apple Services` → clicked the exact `Results` entry (account_id=409).
2. Step 1: hovered **Brand** → **Content** (`#explore/brand/content`). Step 2: brand selector already showed the exact name **Apple Music** (brand_id=31783, no substitution); Data Set dropdown (visible one) → exact option **Video Views** (`table_data_set=video_views`, `Posts (43)` on the default week).
3. Step 3: opened the date picker (START DATE / END DATE). START → month view → year list: 2019–2022 disabled, 2023–2026 enabled. In the 2023 month view **Jan–Sep are `disabled`** (only Oct, Nov, Dec enabled); clicking Jan does nothing (view stays on 2023). In Oct 2023 **days 1–25 are disabled**; earliest selectable day is **Oct 26, 2023**. Spec Jan 01 – Jan 10, 2023 is impossible. Steps 4–9 (Twitter only / Instagram only on that range) therefore could not run on spec. Screenshots: `02-picker-2023-months.png`, `03-picker-oct2023.png`.
4. Legs 2–3: account menu → Search Account, slow typing (150 ms/char, up to 15 s wait each): `NBCU EnterPrises`, `NBCU Enterprises`, `NBCU`, `NBC`, `Enterprises` → no `Results` section and no `.lfm-ta-option` for any. Control search `Hulu` in the same session returned `Results: Hulu` immediately, so the typeahead works and the account is not visible to this user. Screenshot: `04-nbcu-search.png`.
5. Brand typeahead under Apple Services: `CNBC` → `CNBC`, `Dan Mangan (CNBC)`; `NBC News` → no results (`05-brand-probe-nbcnews.png`). CNBC under Apple Services is not the spec account, so it was not run on spec.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-AppleMusic-Twitter | 3–5 | Jan 01–10, 2023, Twitter only; Organic + Paid Views = Video Views per post | Range not selectable (picker disables Jan 2023 – Oct 25, 2023); nothing evaluable on spec | BLOCKED (test-data drift) |
| A6-AppleMusic-Twitter | 3–6 | Engagements / Video Views = Video Response Rate | Same | BLOCKED (test-data drift) |
| A8-AppleMusic-Instagram | 3, 7–8 | Instagram only; Organic + Paid = Video Views | Same | BLOCKED (test-data drift) |
| A9-AppleMusic-Instagram | 3, 7–9 | Engagements / Video Views = Rate | Same | BLOCKED (test-data drift) |
| A5/6/8/9-CNBC | 1–9 | Account NBCU EnterPrises → CNBC, spec range, Twitter then Instagram | Account not findable (5 name variants, no Results) | BLOCKED (account precondition) |
| A5/6/8/9-NBCNews | 1–9 | Account NBCU EnterPrises → NBC News, spec range | Account not findable; brand not findable under Apple Services | BLOCKED (account precondition) |

### Non-spec probe (informational only; verdict NOT based on this)
Apple Music (Apple Services, perspective `extended`), data set Video Views, range substituted to **Oct 26 – Nov 04, 2023** (earliest selectable start, 10-day window like the spec), Table View, trusted channel clicks with `.channel-ghost.enabled` verified.

| Channel | Posts | Organic + Paid = Video Views | Engagements / Video Views = Rate | Sum row |
|---|---|---|---|---|
| Twitter (`enabled: ["twitter"]`) | 21 of 21 | 21/21 match, 0 failures, 0 skipped (Paid "–" treated as 0) | 21/21 within 2-dp display, 0 failures. #1 Thu Oct. 26, 2023: 8,788 / 82,089 = 10.71%; #2 Tue Oct. 31, 2023: 7,197 / 51,328 = 14.02% | Engagements 32,616 · Video Views 491,830 = Organic 491,830 + Paid – ; Unclassified 0; Rate "N/A" by design |
| Instagram (`enabled: ["instagram"]`) | 7 of 7 | 7/7 match, 0 failures | 7/7 match. #1 Fri Oct. 27, 2023: 45,981 / 988,229 = 4.65%; #2 Fri Nov. 03, 2023: 20,512 / 597,198 = 3.43% | Engagements 83,251 · Video Views 2,049,300 = Organic 2,049,300 + Paid – ; Unclassified 0; Rate "N/A" by design |

## Evidence
- Picker 2023 months (Apple Music): `Jan–Sep (disabled), Oct, Nov, Dec`; Oct 2023 days: `1–25 disabled, 26–31 enabled`; year row `2019–2022 disabled`.
- Probe URLs: `…brand_id=31783&account_id=409&from=2023-10-26&to=2023-11-04&channels=twitter|instagram&perspective=extended&table_data_set=video_views`.
- Screenshots in `.playwright-out/QA-29234/`: `01-apple-music-videoviews.png`, `02-picker-2023-months.png`, `03-picker-oct2023.png`, `04-nbcu-search.png`, `05-brand-probe-nbcnews.png`, `06-probe-twitter.png`, `06-probe-instagram.png`. Not opened; state was verified through DOM text, class and URL checks.
- Console: the dev app logs heavy pre-existing console-error noise (`.playwright-out/console-2026-10-28T10-33-47-020Z.log`); none affected the grids.

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` had no QA-29234 matches (pre-fetched).
- `known-quirks.md` already records both blockers for QA-29234: **"Wednesday rotation is only half-runnable for lfiqa"** (NBCU EnterPrises absent from the account list) and **"Apple Music data floor"** (dev history starts Oct 26, 2023, so Jan 2023 cannot be set on Wednesday), plus the 2026-06-29 quirk that fixed historical ranges roll out of the ~3-year retention window. Both reproduced exactly as documented. Accepted behavior / test-data drift; no product bug, and I did not substitute a range, brand or account for the verdict (Rules 1, 3, 5).

## Bugs filed
None.

## Notes for harvest / spec owner
- The fixed Jan 2023 range has aged out of retention for Apple Music (floor slides forward daily). Recommend a relative or in-window range. The Mon/Tue/Thu/Fri rows can still pass (QA-29234 PASSed on UCLA 2026-10-27).
- The test user cannot see an "NBCU EnterPrises" account on dev and "NBC News" is not findable by brand search under Apple Services; needs an entitlement or a corrected rotation.
- Informational: Paid Views is "–" for every Apple Music Twitter/Instagram post in the probe window, as on the 10-27 UCLA run.
