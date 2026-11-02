# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Verdict: PASS**

- **Run date:** 2026-10-29 (headless, unattended, Playwright MCP, dev `app.lfmdev.in`)
- **Account:** Amazon Prime Video (account_id=342) — switched from the default via the LFQA user menu → Search Account → `Results` entry (exact text "Amazon Prime Video"). Breadcrumb confirmed `ACCOUNT: AMAZON PRIME VIDEO`.
- **Brand:** Amazon Prime Video (brand_id=25864) — Brand > Content loaded it by default for the account; name matches the spec exactly (Rule 1).
- **Channel:** Facebook only. **Dates:** Jan 01, 2025 – Jan 10, 2025 (`from=2025-01-01&to=2025-01-10`). **Window mode:** Lifetime. **Perspective:** app default (`perspective=extended`, "Authorized data" pill active); the spec names none.
- **Open-bug screen (Rule 7):** case file says "None open" → ran normally.

## Steps executed
1. Logged in via the Cognito "With existing account" form (`LFM_EMAIL`), switched account to Amazon Prime Video (precondition).
2. Hovered `Brand` in the top nav → clicked `Content`. Brand "Amazon Prime Video" (25864) was the account default.
3. Channel ghosts: kept Facebook only (verified `enabled` = `["facebook"]`), clicked **Apply** (URL `channels=facebook`). Opened the date picker, set START DATE Jan 01, 2025 / END DATE Jan 10, 2025 (field text verified), clicked **Ok** (URL `from=2025-01-01&to=2025-01-10`). Screenshot: `step3-fb-dates.png`.
4. Data Set dropdown → visible option "Impressions" (URL `table_data_set=impressions`). Screenshot: `step4-impressions-dataset.png`.
5. Filter → Publish Type → Reel → Apply. Chip reads "Publish Type: Reel" (URL `content_post_class: reel`). Posts (4). Screenshots: `step5-after-apply.png`, `step5-state.png`, `step6-table-impressions.png`.
6. Table View. Aggregate row (Sum): Engagements 16,499, Impressions 1,546,300. Calculation: 16,499 / 1,546,300 × 100 = **1.0670 %**. Toggled the aggregate row to Average: Engagement Rate = **1.07 %**. Screenshots: `step6-table-impressions.png`, `step6-average-row.png`.
7. Aggregate Impressions noted (Sum row): **1,546,300**.
8. Data Set → "Reels" (URL `table_data_set=reels`; Reel filter retained; Posts (4)). Screenshot: `step8-reels-table.png`.
9. Aggregate Plays noted (Sum row): **1,546,300**. Screenshots: `step9-reels-sum-plays.png`, `step9-reels-avg.png`.

## Evidence

Impressions data set, Facebook, Publish Type = Reel, Jan 1–10 2025 (4 posts):

| # | Date (PST) | Engagements | Eng. Rate | Impressions | Reach |
|---|---|---|---|---|---|
| 1 | Sat Jan 04, 2025 04:00 PM | 11,414 | 1.53% | 746,373 | 595,866 |
| 2 | Sat Jan 04, 2025 09:00 AM | 2,500 | 0.97% | 257,737 | 207,972 |
| 3 | Tue Jan 07, 2025 03:00 PM | 2,441 | 0.48% | 509,388 | 397,320 |
| 4 | Tue Jan 07, 2025 11:00 AM | 144 | 0.44% | 32,802 | 36,520 |
| **Sum row** | | **16,499** | N/A | **1,546,300** | N/A |
| **Average row** | | 4,125 | **1.07%** | 386,575 | 309,420 |

- Sum cross-check: 746,373 + 257,737 + 509,388 + 32,802 = 1,546,300; 11,414 + 2,500 + 2,441 + 144 = 16,499 (both match the Sum row).
- Reels data set per-post Plays: 746,373 / 257,737 / 509,388 / 32,802 — each equals that post's Impressions. Sum-row Plays = **1,546,300**; Average-row Plays = 386,575 (equals Average Impressions).
- Reels Sum row: Engagements 16,499 (consistent with the Impressions set); Initial Plays 1,216,104 + Reel Replays 330,196 = 1,546,300 = Plays.
- Organic/Paid Impressions show "–" for these Reels; the total Impressions column is fully populated.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Reel posts have Impressions data | All 4 Reel posts have non-"–" Impressions (746,373 / 257,737 / 509,388 / 32,802); Sum 1,546,300 | PASS |
| A6 | 6 | Engagements / Impressions × 100 equals the Engagement Rate value | 16,499 / 1,546,300 × 100 = 1.0670 % → 1.07 %; aggregate Engagement Rate (Average row) displays 1.07 % (within ±0.01 pp of the 2-decimal display) | PASS |
| A9 | 9 | Aggregate Impressions equals aggregate Plays | Impressions Sum 1,546,300 = Plays Sum 1,546,300 (also equal on every one of the 4 posts) | PASS |

## Notes
- The aggregate Engagement Rate cell shows "N/A" in Sum mode and the value (1.07 %) only in Average mode — existing aggregate-row behavior; the value was read from the Average row.
- Dev render: after applying the Reel filter the post list showed skeleton/"Loading" for roughly 1–2 minutes and briefly flipped back to loading after `Posts (4)` first appeared (so the Table View control vanished once). It stabilized on its own inside the 5-minute step budget; no reload and no "failed to load" tile was needed. Switching data sets (Reels / Impressions) took ~4–12 s.
- Console showed many errors on dev (pre-existing noise); none blocked the flow.

## Known bugs checked
- Case file "Open linked bugs": none open.
- `knowledge-base/bug-history.md` / `known-quirks.md`: no entries for QA-31513 (pre-fetched grep).
- During the run: no linked-bug behavior observed; nothing interfered with the steps or assertions.

## Bugs filed
None.
