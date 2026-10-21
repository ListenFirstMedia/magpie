# QA-20318 — Brand Content > Basic Data Set > Past date range data test - FB

**Run:** 2026-10-20 (Tuesday), unattended headless, Playwright MCP. Login `lfiqa@listenfirstmedia.com` (landed on Hulu, account 336).
**Weekday row executed:** Tuesday — Accounts UCLA / Viacom / Wasserman → Brands University of California, Los Angeles / MTV / Gatorade (all three legs run).

## Verdict: **PASS** (2 of 3 Tuesday legs fully evaluated and passing; Gatorade leg BLOCKED — test-data drift, not a product bug)

| Leg | Account (id) | Brand (id) | Verdict |
|---|---|---|---|
| 1 | UCLA (799) | University of California, Los Angeles (127756) | **PASS** — 200/200 posts |
| 2 | Viacom (181) | MTV (4018) | **PASS** — 200/200 posts |
| 3 | Wasserman (863) | Gatorade (3580) | **BLOCKED (test-data)** — Jan 01, 2023 not selectable (rolling retention floor); fallback range has 0 FB posts |

Open-bug screen (Rule 7): case file says "None open" → ran normally.

## Steps executed (per leg)
1. Switched account via LFQA menu → Search Account → `Results` row (Rule: not Recent Searches); verified breadcrumb `ACCOUNT: <name>`.
2. Top nav: hovered **Brand** → clicked **Content** (`#explore/brand/content`).
3. **Add a Brand:** chevron next to brand name → "Search for a Brand" → clicked the exact-name `.lfm-ta-option` Result ("University of California, Los Angeles", "MTV", "Gatorade" — Rule 1, no substitutes).
4. Date range via the START DATE / END DATE picker (`button.range-display`): **Jan 01, 2023 – Dec 31, 2023** → Ok → URL `from=2023-01-01&to=2023-12-31` (legs 1, 2). Leg 3: see below.
5. Channels: explicit trusted clicks disabling Twitter/Instagram/LinkedIn/TikTok/Threads (YouTube/Pinterest already disabled) → only `.channel-ghost.facebook.enabled` remained → **Apply** → URL `channels=facebook` (Rule 2 — toggles clicked, not URL-edited). Data set left at the default `Public` (spec says channel only).
6. Switched to **Table View** (`[title="Table View"]`), scraped header + all 200 rendered rows + the Sum/Average aggregate row via DOM, evaluated Reactions + Comments + Shares = Engagements in page JS.

## Assertions

Assertion A5: Reactions + Comments + Shares == Engagements (for each post, plus the aggregate Sum row).

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-UCLA-posts | 5 | Every FB post: R + C + S = Engagements | 200 of 200 rendered posts match exactly (0 fails, 0 "–"/no-data rows, 0 partial rows). All 200 rows carry the Facebook icon and a 2023 date. Posts (1,244) in range; first 200 rendered. Post #1 (Sun Sep. 17, 2023): 2,998 + 140 + 548 = 3,686 ✔; #2 (Mon Aug. 28, 2023): 3,192 + 53 + 166 = 3,411 ✔ | PASS |
| A5-UCLA-sum | 5 | Aggregate Sum row: R + C + S = Engagements | 165,196 + 5,050 + 9,374 = 179,620 = Engagements 179,620 | PASS |
| A5-MTV-posts | 5 | Every FB post: R + C + S = Engagements | 200 of 200 rendered posts match exactly (0 fails, 0 no-data, 0 partial). All 200 Facebook, all 2023. Posts (2,107) in range. Post #1 (Thu Dec. 14, 2023): 687,756 + 12,891 + 73,005 = 773,652 ✔; #2 (Fri Dec. 15, 2023): 304,801 + 6,081 + 79,948 = 390,830 ✔ | PASS |
| A5-MTV-sum | 5 | Aggregate Sum row: R + C + S = Engagements | 9,386,040 + 226,926 + 874,658 = 10,487,624 = Engagements 10,487,624 | PASS |
| A5-Gatorade | 4–5 | Jan 01 – Dec 31, 2023 selectable; FB posts satisfy R + C + S = Engagements | START picker for Gatorade (Wasserman acct 863) shows 2023 months Jan–Sep greyed `disabled`, Oct 1–17 2023 days disabled; earliest selectable day = **Oct 18, 2023**. Spec range cannot be set. Non-spec probe (NOT used for the verdict): Oct 18 – Dec 31, 2023, Facebook only → **Posts (0)**, so nothing to evaluate. | BLOCKED (test-data drift) |

Note: the Sum/Average row aggregates all posts in range, not just the 200 rendered; the aggregate identity holds on its own values in both legs.

## Evidence
- `.playwright-out/QA-20318/ucla-fb-applied.png`, `ucla-table-view.png` — UCLA, Facebook-only Table View
- `.playwright-out/QA-20318/mtv-table-view.png` — MTV, Facebook-only Table View
- `.playwright-out/QA-20318/gatorade-datepicker.png` — Gatorade picker with Jan–Sep 2023 greyed out
- `.playwright-out/QA-20318/gatorade-fb-oct18-dec31-0posts.png` — non-spec probe, Posts (0)
- Table View headers (Public data set): Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions.

## Known bugs checked
- Jira issue-links: case file "Open linked bugs: None open" (checked at ingest 2026-10-20). `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-20318 matches (pre-fetched).
- Related surface: the QA-27628 run (2026-10-19) recorded a possible FAIL candidate on QA-20321 (Facebook Oct 2023–Sep 2024, total Impressions/Reach with no organic/paid split) — a different metric family from Engagements/Reactions/Comments/Shares; it did not touch this case's assertions and did not reproduce here.
- **Gatorade leg** matches the known quirk *"2026-06-29 — Fixed historical date ranges in old specs roll out of the ~3-year data-retention window"* in `knowledge-base/known-quirks.md`: Wasserman's floor is ~Oct 18, 2023 (run date minus 3 years). Accepted behavior; no bug filed. Observation: UCLA (799) and Viacom (181) still allowed Jan 2023, so the retention window is account-specific.

## Bugs filed
None.

## Notes / recommendations
- Spec owner: the Wasserman/Gatorade leg (and any other fixed-2023 range on accounts with a 3-year floor) will stay un-runnable and keeps sliding forward daily; express the window relatively or move to a newer fixed range.
- Verdict logic: the assertion is identical across the three Tuesday rows and was fully verified on two (400 posts + two aggregate rows, 0 failures). The Gatorade leg is not evaluable because of retention, not because of a product defect. If a stricter all-legs-must-run policy is wanted, treat the case as BLOCKED instead.
- Mechanics reused from skills `brand-content-grid-math`, `brand-content-native-post-check` (date picker), `switch-account`. New mechanics found (for harvest): the date trigger is `button.range-display` and the picker fields are `.date-range-field`; `Posts (N)` contains commas (`Posts (1,244)`), so use `/Posts \([\d,]+\)/` when polling; the Gatorade picker shows `span.month.disabled` for months before the retention floor.
