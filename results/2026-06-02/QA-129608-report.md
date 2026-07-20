# QA-129608 — Handle Abnormally High Response Rate – Aggregate Value Calculation Across Multiple Channels

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-129608
- **Run date:** 2026-06-04 (QA-4325 batch-9)
- **Account/Brand:** Adam Orfei (spec requires Wasserman) / "FIA World Endurance Championship (FIAWEC)"
- **Result:** BLOCKED — spec brand not on active account; account switch requires authentication that cannot be performed
- **Skill mapped:** `time-window-comparison-run` + `response-rate-math-verifier`

## Steps executed
1. Reporting → Time Window Comparison.
2. TWC builder loaded on Adam Orfei (`app-reporting.lfmdev.in/#/time_window_comparison`). All builder sections rendered cleanly: Add Brands, Add Reporting Competitive Set, Add Brand By Name typeahead, Absolute Dates / Relative Dates tabs, Interval=Days default, Make a Selection=Auto, Start/End Date calendars at May/June 2026.
3. Click Add Brand By Name typeahead → focused.
4. React-aware setter dispatch `inp.value='FIA' + input event` → typeahead Results section opened with 32+ option rows.
5. Inspected first 15 results: `90 Day Fiance`, `90 Day Fiance: UK`, `90 Day Fiance: What Now?`, `A Fiance for Christmas`, `AUNTY SOFIA`, `Alaffia`, `Amira (90 Day Fiance)`, `Amish Mafia`, `Ana (90 Day Fiance)`, `Andre Fialho`, `Andrew (90 Day Fiance)`, `Anfisa (90 Day Fiance)`, `Anna Sofia`, `Aqib Fiaz`, `Ash (90 Day Fiance)`. None match the spec brand "FIA World Endurance Championship (FIAWEC)" — substring matching on "FIA" returns unrelated brands.
6. Per Rule 1 — Never substitute brands — BLOCKED.

## Why blocked
- Spec preconditions require user logged in as `Wasserman` (per ticket precondition). FIA WEC brand is on the Wasserman account (verified in prior batch-8 QA-129606 run on 2026-06-02).
- Active session is Adam Orfei (account_id=54); switching accounts to Wasserman requires re-authentication via Cognito sign-in or a documented account-switcher flow neither of which is exposed in the current session.
- Substituting a different brand (e.g., a TV-show brand from the typeahead) would violate Rule 1 and the spec's intent (Feb 9-15 2026 cross-channel Aggregate RR math on the FIA WEC dataset).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A0 | preflight | Logged in as Wasserman | Logged in as Adam Orfei | BLOCKED |
| A8 | 8 | Report loads successfully for Aggregate values with no errors | Cannot execute (brand not selectable) | NOT VERIFIED |
| A9a | 9 | Aggregate Engagements value and number of posts match exported data | Cannot execute | NOT VERIFIED |
| A9b | 9 | UI-displayed Aggregate Response Rate = Exported Response Rate | Cannot execute | NOT VERIFIED |
| A9c | 9 | Calculated Aggregate RR matches both UI + exported data per formula `(Aggregate Engagements / Aggregate Total Footprint) × 100` where `Aggregate Footprint = Aggregate Posts × Aggregate Total Followers` | Cannot execute | NOT VERIFIED |

## Notes
- The `time-window-comparison-run` skill, `keydate-picker`-style `th.prev` JS-fallback, and `response-rate-math-verifier` skill are all ready for this test once the Wasserman account context is available. Prior batches (QA-129606 Twitter+TikTok, QA-129803 Facebook variant) confirmed the formula and the em-dash freshness exclusion rules for daily/Feb-2026 windows.
- Recommend: LFIQA execute under Wasserman directly, OR document a procedure to switch sessions in-flow (the magpie account-switching skill currently covers brand-level switches but not Adam Orfei↔Wasserman account session switches).

## Bugs filed
- None.
