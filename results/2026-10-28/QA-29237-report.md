# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: BLOCKED (test-data drift + account precondition)**. The spec range (Jan. 01, 2023 – Dec. 31, 2023) cannot be set on any Wednesday brand, and the Wednesday account "NBCU EnterPrises" (CNBC / NBC News legs) is not visible to the test user. No leg could be run on the exact spec configuration, so no assertion was evaluated against the spec. The non-spec probe below is informational only and does not set the verdict.

- Run: 2026-10-28 (Wednesday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on MICHAEL KORS; switched to APPLE SERVICES, account_id 409).
- Weekday row: Wednesday per the Description table: Accounts Apple Services / NBCU EnterPrises, Brands Apple Music / CNBC / NBC News. The case `## Notes` line (Wed = Apple Services/Wasserman) disagrees; the Description table was treated as authoritative (same call as QA-29234 / QA-20318 today).
- Skill: `brand-content-grid-math` (Table View DOM scrape) via `_shared/playwright-helpers/devprod-helpers.js` (dev tab only).
- Open-bug screen (Rule 7): case file says "None open" → ran normally.

| Leg | Account | Brand | Spec range (Jan 01 – Dec 31, 2023) | Verdict |
|---|---|---|---|---|
| 1 | Apple Services (409) | Apple Music (31783) | Not selectable (retention floor Oct 26, 2023) | BLOCKED (test-data) |
| 2 | NBCU EnterPrises | CNBC | Account not findable | BLOCKED (account precondition) |
| 3 | NBCU EnterPrises | NBC News | Account not findable; brand not findable under Apple Services | BLOCKED (account precondition) |

## Steps executed
1. Logged in via Cognito "With existing account". Account menu → Search Account → `Apple Services` → clicked the exact `Results` entry (`ACCOUNT: APPLE SERVICES`, account_id=409).
2. Step 1: hovered **Brand** → **Content** (`#explore/brand/content`). Step 2: brand selector showed the exact name **Apple Music** (brand_id=31783, no substitution). The visible Data Set dropdown → exact option **Impressions** (`table_data_set=impressions`, `Posts (60)` on the default week Oct 20–26, 2026).
3. Step 3: opened the date picker (START DATE / END DATE). START → month view → year list: 2023–2026 enabled. In the 2023 month view **Jan–Sep carry class `month disabled`** (only Oct, Nov, Dec enabled); a forced click on Jan left the view on the months screen. In Oct 2023 the only selectable days are **26–31**. The spec range Jan 01 – Dec 31, 2023 is impossible. Steps 4–7 (TikTok only, then read Impressions / Organic+Paid Reach / Engagement Rate on that range) therefore could not run on spec. Screenshots: `02-picker-2023-months.png`, `03-picker-oct2023.png`.
4. Legs 2–3: account menu → Search Account, slow typing (150 ms/char, up to 15 s wait each): `NBCU EnterPrises`, `NBCU Enterprises`, `NBCU`, `NBC`, `Enterprises` → no `Results` header and no `.lfm-ta-option` for any. Control search `Hulu` in the same session returned `Hulu` immediately, so the typeahead works and the account is not visible to this user. Screenshot: `04-nbcu-search.png`.
5. Brand typeahead under Apple Services: `NBC News` → no results (`05-brand-probe-nbcnews.png`); `CNBC` → `CNBC`, `Dan Mangan (CNBC)`. CNBC under Apple Services is not the spec account, so it was not run on spec.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a-AppleMusic | 3–5 | Jan 01 – Dec 31, 2023, TikTok only; Impressions metric displays a value per post | Range not selectable (picker disables Jan – Sep 2023 and Oct 1–25, 2023); nothing evaluable on spec | BLOCKED (test-data drift) |
| A5b-AppleMusic | 3–5 | En-dash for both Organic and Paid Impressions | Same | BLOCKED (test-data drift) |
| A6-AppleMusic | 3–6 | Organic Reach + Paid Reach = Reach per post | Same | BLOCKED (test-data drift) |
| A7-AppleMusic | 3–7 | Engagement Rate = Engagements / Impressions × 100 | Same | BLOCKED (test-data drift) |
| A5/6/7-CNBC | 1–7 | Account NBCU EnterPrises → CNBC, spec range, TikTok only | Account not findable (5 name variants, no Results) | BLOCKED (account precondition) |
| A5/6/7-NBCNews | 1–7 | Account NBCU EnterPrises → NBC News, spec range | Account not findable; brand not findable under Apple Services | BLOCKED (account precondition) |

### Non-spec probe (informational only; verdict NOT based on this)
Apple Music (Apple Services, perspective `extended`), data set Impressions, range substituted to **Oct 26 – Dec 31, 2023** (earliest selectable start, same end day as the spec), TikTok only (`enabled: ["tiktok"]` verified, trusted clicks, Apply), Table View.

| Check | Result |
|---|---|
| Posts scraped | 30 of 30 (`Posts (30)`) |
| A5a Impressions displays a value | 30/30 posts show a value. #1 Mon Dec. 04, 2023: 7,797,760; #2 Thu Nov. 09, 2023: 867,068 |
| A5b En-dash for Organic and Paid Impressions | 30/30 posts show `–` in both columns; Sum row also `–` / `–` |
| A6 Organic Reach + Paid Reach = Reach | Not evaluable: Reach, Organic Reach and Paid Reach are `–` on all 30 TikTok posts (`N/A` in the Sum row). Reach is not collected for TikTok here, so the identity is vacuous (0 + 0 vs `–`), not verified |
| A7 Engagement Rate = Engagements / Impressions × 100 | 30/30 within the 2-dp display (±0.01 pp), 0 failures, 0 skipped. #1: 542,278 / 7,797,760 = 6.95%; #2: 168,821 / 867,068 = 19.47% |
| Sum row | Engagements 1,406,766 · Impressions 52,018,998 · Organic/Paid Impressions `–` · Engagement Rate `N/A` (by design) |

## Evidence
- Picker 2023 months (Apple Music): `Jan–Sep (disabled), Oct, Nov, Dec`; Oct 2023 selectable days: `26–31`; years row 2023–2026 enabled.
- NBCU search results: `{hasResults:false, opts:[]}` for all 5 query variants; control `Hulu` → `["Hulu"]`.
- Probe URL: `…brand_id=31783&account_id=409&from=2023-10-26&to=2023-12-31&channels=tiktok&perspective=extended&table_data_set=impressions`.
- Screenshots in `.playwright-out/QA-29237/`: `01-apple-services-content.png`, `02-picker-2023-months.png`, `03-picker-oct2023.png`, `04-nbcu-search.png`, `05-brand-probe-nbcnews.png`, `06-probe-tiktok.png`. Not opened; state was verified through DOM text, class and URL checks.
- Console: the dev app logs heavy pre-existing console-error noise (`.playwright-out/console-2026-10-28T10-44-44-667Z.log`); none affected the grids.

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` had no QA-29237 matches (pre-fetched).
- `known-quirks.md` already records both blockers for QA-29237: **"Wednesday rotation is only half-runnable for lfiqa"** (NBCU EnterPrises absent from the account list) and **"Apple Music data floor"** (dev history starts Oct 26, 2023, so Jan 2023 cannot be set on Wednesday). Both reproduced exactly as documented. Accepted behavior / test-data drift; no product bug, and no range, brand or account was substituted for the verdict (Rules 1, 3, 5).

## Bugs filed
None.

## Notes for harvest / spec owner
- The fixed Jan – Dec 2023 range has aged out of retention for Apple Music (the floor slides forward daily). Recommend a relative or in-window range. Mon/Tue/Thu/Fri rows can still pass.
- The test user cannot see an "NBCU EnterPrises" account on dev, and "NBC News" is not findable by brand search under Apple Services; needs an entitlement or a corrected rotation.
- Informational: Apple Music TikTok posts carry Impressions and Engagements but no Organic/Paid split and no Reach, so the A6 Reach identity has nothing to evaluate for TikTok on this brand.
