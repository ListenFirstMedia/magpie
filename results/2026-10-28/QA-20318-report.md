# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Verdict: BLOCKED (test-data drift)** — the spec date range (Jan. 01, 2023 – Dec. 31, 2023) cannot be set on dev, and the Wednesday NBCU Enterprises account (CNBC / NBC News legs) is not available to the test user. No leg could be executed on the exact spec configuration. Non-spec probes (documented below, **not used for the verdict**) show the Reactions + Comments + Shares = Engagements identity holds.

- Run: 2026-10-28 (Wednesday), unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com` (landed on APPLE SERVICES, account_id 409, after login).
- Weekday row executed: Wednesday — Accounts Apple Services / NBCU EnterPrises → Brands Apple Music / CNBC / NBC News.
- Skill: `brand-content-grid-math` (Table View DOM scrape) via `_shared/playwright-helpers/devprod-helpers.js` (dev tab only).
- Open-bug screen (Rule 7): case file says "None open" → ran normally.

| Leg | Account | Brand (id) | Spec range (Jan 01 – Dec 31, 2023) | Verdict |
|---|---|---|---|---|
| 1 | Apple Services (409) | Apple Music (31783) | NOT selectable (retention floor Oct 26, 2023) | BLOCKED (test-data) |
| 2 | NBCU EnterPrises | CNBC | Account not findable; the floor is also Oct 26, 2023 on CNBC | BLOCKED (account precondition + test-data) |
| 3 | NBCU EnterPrises | NBC News | Account not findable; brand not findable under the available account | BLOCKED (account precondition) |

## Steps executed
1. Logged in via Cognito "With existing account" (`#home`, ACCOUNT: APPLE SERVICES).
2. **Leg 1:** Brand → Content (`#explore/brand/content`). Brand selector → typed "Apple Music" → clicked the exact `Apple Music` Result (brand_id 31783), per Rule 1.
3. Opened the date picker (START/END). In the 2023 month view, **Jan–Sep 2023 are `disabled`**; only Oct, Nov, Dec are enabled. In Oct 2023, days 1–25 are disabled. The earliest selectable day is **Oct 26, 2023**. Spec step 3 (Jan 01, 2023) is impossible. Screenshots: `apple-2b-picker.png`, `apple-2c-oct2023.png`.
4. **Legs 2–3:** account menu → Search Account. Typed `NBCU Enterprises`, `NBCU EnterPrises`, `NBCU`, `NBC`, `NBCUniversal`, `NBC Universal`, `Enterprises`, `NBCU Ent`, `Comcast`, `CNBC`, `NBC News` (slow typing, 150 ms/char, up to 15 s wait). **Only "Recent Searches" ever rendered; no `Results` section and no `.lfm-ta-option` for any variant.** Control searches `Hulu` and `Spotify` in the same session rendered `Results` immediately, so the typeahead works and the NBCU Enterprises account is not visible to this user. Screenshots: `nbcu-0-search.png`, `nbcu-0-control-search.png`.
5. Brand typeahead under the currently available account (Apple Services): `CNBC` → `CNBC`, `Dan Mangan (CNBC)`; `NBC News` → no results (`nbcu-1-brand-probe.png`).
6. Non-spec probes (not used for the verdict): see below.

## Assertions

Assertion 5: Reactions + Comments + Shares = Engagements (each grid post; aggregate Sum row).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-AppleMusic | 3–5 | Jan 01 – Dec 31, 2023 selectable, Facebook only; every post R + C + S = Engagements | Spec range not selectable: START picker disables Jan 2023–Oct 25, 2023. Nothing evaluable on the spec range | BLOCKED (test-data drift) |
| A5-CNBC | 1–5 | Account NBCU EnterPrises → CNBC, spec range, FB only | Account not findable (typeahead returned no Results for 11 name variants); spec range also not selectable on CNBC (same floor) | BLOCKED (account precondition + test-data) |
| A5-NBCNews | 1–5 | Account NBCU EnterPrises → NBC News, spec range, FB only | Account not findable; brand "NBC News" returns no results under Apple Services | BLOCKED (account precondition) |

### Non-spec probes (informational only; verdict NOT based on these)
Range substituted to Oct 26 – Dec 31, 2023 (earliest selectable start → spec end), Facebook only (`channels=facebook`, `.channel-ghost.enabled` = facebook), data set Public, Table View.

| Probe | Posts | Per-post R + C + S = Engagements | Aggregate Sum row |
|---|---|---|---|
| Apple Music (acct Apple Services, perspective `extended`) | 94 of 94 rendered; header `Posts (94)` | 94 / 94 match, 0 failures, 0 "–" components. #1 (Mon Dec. 04, 2023): 66,703 + 1,255 + 2,077 = 70,035; #2 (Fri Dec. 15, 2023): 57,895 + 528 + 424 = 58,847 | 343,883 + 5,912 + 17,082 = 366,877 = Engagements 366,877 ✓ |
| CNBC (run under **Apple Services**, not the spec account NBCU EnterPrises; perspective `standard`) | 200 of 2,255 rendered (Table View caps at 200) | 200 / 200 match, 0 failures, 0 "–" components. #1 (Fri Nov. 03, 2023): 29,973 + 676 + 684 = 31,333; #2 (Thu Nov. 02, 2023): 17,771 + 1,429 + 874 = 20,074 | 1,725,663 + 224,327 + 168,913 = 2,118,903 = Engagements 2,118,903 ✓ |

## Evidence
- URLs at assertion time: Apple Music `brand_id=31783&account_id=409&from=2023-10-26&to=2023-12-31&channels=facebook&perspective=extended&table_data_set=public`; CNBC `brand_id=19207&account_id=409&from=2023-10-26&to=2023-12-31&channels=facebook&perspective=standard&table_data_set=public`.
- Picker months, 2023 (Apple Music and CNBC identical): `Jan–Sep (disabled), Oct, Nov, Dec`; year row `2019–2022 (disabled), 2023–2026`.
- Screenshots in `.playwright-out/QA-20318/`: `apple-1-brand.png`, `apple-2-dates.png`, `apple-2b-picker.png`, `apple-2c-oct2023.png`, `apple-3-facebook.png`, `apple-4-table.png`, `nbcu-0-search.png`, `nbcu-0-control-search.png`, `nbcu-1-brand-probe.png`, `cnbc-1-brand.png`, `cnbc-2-picker.png`, `cnbc-4-table.png`. I did not open them except `nbcu-0-search.png` (showed only "Recent Searches": Apple Services, UCLA, Sephora, Adam Orfei, Amazon Prime Video). State was otherwise verified through DOM text, URL, and class checks.
- Console: the dev app logs many console errors (`.playwright-out/console-2026-10-28T06-24-13-536Z.log`); none affected the grids. An orange "Facebook Data Collection Disruption 9/27" banner was shown but did not affect the evaluated posts.

## Scope note
Table View renders at most 200 posts per page; the CNBC probe covers the top 200 of 2,255 posts by Engagements (the aggregate Sum row covers the full filtered set). The Apple Music probe covers all 94 posts.

## Known bugs checked
- Case file "Open linked bugs": None open. `bug-history.md` / `known-quirks.md` had no QA-20318 matches (pre-fetched).
- The blocked date range matches known quirk **"2026-06-29 — Fixed historical date ranges in old specs roll out of the ~3-year data-retention window → BLOCKED (test-data drift, not a bug)"** (`known-quirks.md:97`). The floor has slid to **Oct 26, 2023** today (Oct 25 on 2026-10-27, Oct 18 on 2026-10-20). Accepted behavior; no bug filed. Per Rules 1/3/5 the date range was not substituted for the verdict.
- The account gap is a test-data/ACL issue (Rule 1, "wrong account / requires authorization"), not a product bug. No bug reproduced.

## Bugs filed
None.

## Notes for harvest / spec owner
- The spec's fixed 2023 range has aged out of retention for the Wednesday accounts. Recommend a relative or in-window range (e.g. the last 12 months ending ≥ the floor). The earlier weekday runs still passed on UCLA/MTV/HBO Max, where the floor was still earlier than Jan 2023.
- The test user (`lfiqa@listenfirstmedia.com`) cannot see an "NBCU EnterPrises" account on dev. Ask LFIQA/Spec owner to grant access or correct the account name; "NBC News" is also not findable by brand search under Apple Services.
- Case-file Notes weekday rotation (Wed = Apple Services/Wasserman) disagrees with the Description table (Wed = Apple Services, NBCU EnterPrises → Apple Music, CNBC, NBC News). I followed the Description table, which is authoritative.
- `browser_run_code_unsafe` has no `require`/dynamic `import`; credentials had to be passed inline from `config/.env`. `m.waitPosts` still ignores comma counts (`Posts (2,255)` returned `null`; the page had rendered anyway) — update the regex to `/Posts \(([\d,]+)\)/`.
