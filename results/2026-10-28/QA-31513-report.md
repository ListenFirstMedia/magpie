# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Verdict: PASS**

- **Run date:** 2026-10-28 (headless, unattended, Playwright MCP, dev `app.lfmdev.in`)
- **Account:** Amazon Prime Video (account_id=342) — switched from the default "Adam Orfei" via the LFQA user menu → Search Account → `Results` entry (exact text "Amazon Prime Video"; the "Amazon Prime Video India" sibling was not used).
- **Brand:** Amazon Prime Video (brand_id=25864) — Brand > Content loaded this brand by default for the account, matching the spec name exactly (Rule 1).
- **Channel:** Facebook only. **Dates:** Jan 01, 2025 – Jan 10, 2025 (`from=2025-01-01&to=2025-01-10`). **Window mode:** Lifetime. **View perspective:** left at the app default (`perspective=extended`); the spec does not name a perspective.
- **Open-bug screen (Rule 7):** case file says "None open" → ran normally.

## Steps executed
1. Logged in via the Cognito "With existing account" form (`LFM_EMAIL`), then switched account to Amazon Prime Video (precondition).
2. Hovered `Brand` in the top nav → clicked `Content`. Brand "Amazon Prime Video" (25864) was already selected as the account default.
3. Disabled Twitter, Instagram, LinkedIn, TikTok and Threads in the channel ghosts and kept Facebook enabled (verified `.channel-ghost.facebook.enabled` was the only enabled ghost), then clicked **Apply** (URL `channels=facebook`). Opened the date picker and set START DATE Jan 01, 2025 and END DATE Jan 10, 2025 (field text verified), then clicked **Ok** (URL `from=2025-01-01&to=2025-01-10`).
4. Opened the Data Set dropdown and clicked the visible "Impressions" option (URL `table_data_set=impressions`). Screenshot: `.playwright-out/QA-31513/step4-impressions-dataset.png`.
5. Filter → Publish Type → Reel → Apply. The filter chip reads "Publish Type: Reel" (URL `content_post_class: reel`). **Posts (4).** Screenshots: `step5-after-apply.png`, `step5-reel-filter-table.png`.
6. Switched to Table View. Aggregate row (Sum mode): Engagements 16,499, Impressions 1,546,300. Calculation: 16,499 / 1,546,300 × 100 = **1.0670 %**. Toggled the aggregate row to Average: Engagement Rate = **1.07 %**. Screenshots: `step6-table-impressions.png`, `step6-average-row.png`.
7. Aggregate Impressions noted (Sum row): **1,546,300**.
8. Data Set → "Reels" (URL `table_data_set=reels`, Reel filter retained, Posts (4)). Screenshot: `step8-reels-table.png`.
9. Aggregate Plays noted (Sum row): **1,546,300**. Screenshot: `step9-reels-sum-plays.png`.

## Evidence

Impressions data set, Facebook, Publish Type = Reel, Jan 1–10 2025 (Table View, 4 posts):

| # | Date (PST) | Engagements | Eng. Rate | Impressions | Reach |
|---|---|---|---|---|---|
| 1 | Sat Jan 04, 2025 04:00 PM | 11,414 | 1.53% | 746,373 | 595,866 |
| 2 | Sat Jan 04, 2025 09:00 AM | 2,500 | 0.97% | 257,737 | 207,972 |
| 3 | Tue Jan 07, 2025 03:00 PM | 2,441 | 0.48% | 509,388 | 397,320 |
| 4 | Tue Jan 07, 2025 11:00 AM | 144 | 0.44% | 32,802 | 36,520 |
| **Sum row** | | **16,499** | N/A | **1,546,300** | N/A |
| **Average row** | | 4,125 | **1.07%** | 386,575 | 309,420 |

- Sum cross-check: 746,373 + 257,737 + 509,388 + 32,802 = 1,546,300 (matches the Sum row). 11,414 + 2,500 + 2,441 + 144 = 16,499 (matches).
- Reels data set per-post Plays: 746,373 / 257,737 / 509,388 / 32,802 — each equals that post's Impressions value. Sum row Plays = **1,546,300**, Average row Plays = 386,575 (equal to the Average Impressions).
- Reels Sum row also shows Engagements 16,499 (consistent with the Impressions data set), Initial Plays 1,216,104 + Reel Replays 330,196 = 1,546,300 = Plays.
- Organic/Paid Impressions columns show "–" (not broken out for these Reels); the total Impressions column is fully populated.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Reel posts have Impressions data | All 4 Reel posts have non-"–" Impressions (746,373 / 257,737 / 509,388 / 32,802); aggregate Sum 1,546,300 | PASS |
| A6 | 6 | Engagements / Impressions × 100 equals the Engagement Rate value | 16,499 / 1,546,300 × 100 = 1.0670 % → 1.07 %; the aggregate Engagement Rate (Average row) displays 1.07 % | PASS |
| A9 | 9 | Aggregate Impressions equals aggregate Plays | Impressions Sum 1,546,300 = Plays Sum 1,546,300 (and per-post equal on all 4 posts) | PASS |

## Notes
- The aggregate Engagement Rate cell shows "N/A" in Sum mode and the value (1.07 %) only in Average mode. This is existing aggregate-row behavior (Sum mode shows N/A for rate columns); the value was read from the Average row. The rate is a ratio, so it is the aggregate rate, and it matched the hand calculation.
- The 1.07 % comparison is at the 2-decimal display precision (calculated 1.0670 %, so within the ±0.01 pp tolerance in the `brand-content-grid-math` skill).
- The Average-row Engagement Rate (1.07 %) also matches the unweighted mean of the per-post rates only approximately (mean of 1.53 / 0.97 / 0.48 / 0.44 = 0.855 %), so the aggregate rate is evidently computed as total Engagements ÷ total Impressions, which is what step 6 asks for.
- Console showed many errors, none of them blocking the flow; no "failed to load" tile occurred (Reels data set needed ~12 s to load, within the step budget).

## Known bugs checked
- Case file "Open linked bugs": none open.
- `knowledge-base/bug-history.md` / `known-quirks.md`: no entries for QA-31513 (pre-fetched grep).
- During the run: no linked bug behavior observed; nothing interfered with the steps or assertions.

## Bugs filed
None.
