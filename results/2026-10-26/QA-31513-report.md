# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in
**Account:** Amazon Prime Video (login landed on HBO Max; switched via LFQA menu → Search Account → Results row "Amazon Prime Video", header then read `ACCOUNT: AMAZON PRIME VIDEO`, account_id=342)
**Brand:** Amazon Prime Video (brand_id=25864, the exact first typeahead result — not any `(Country)` / `- Region` variant)
**Date range:** Jan. 01, 2025 – Jan. 10, 2025 (START/END picker, URL `from=2025-01-01&to=2025-01-10`) · **Channel:** Facebook only · **View:** Authorized data (page default, spec names no perspective; URL `perspective=extended`)

**Verdict: PASS** — Reel posts carry Impressions, the aggregate Engagement Rate equals Engagements ÷ Impressions × 100, and aggregate Impressions equals aggregate Plays exactly.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login via Cognito "With existing account"; account switched HBO Max → Amazon Prime Video (case precondition) | OK |
| 1 | Hover Brand (top nav) → click Content | OK — `#explore/brand/content`. First load sat on skeletons ~50 s (brand selector hidden, no brand in URL); one page reload recovered it with `brand_id=25864&account_id=342` |
| 2 | Brand dropdown chevron → typed "Amazon Prime Video" → clicked the literal `Amazon Prime Video` result | OK — brand_id=25864 |
| 3 | Date picker: START Jan 01 2025 / END Jan 10 2025 → Ok; Channels: clicked off Twitter, Instagram, TikTok, LinkedIn, Threads (Facebook left on) → verified only `.channel-ghost.facebook.enabled` → Apply | OK — URL `channels=facebook`, `from=2025-01-01&to=2025-01-10` |
| 4 | Data Set dropdown → `Impressions` | OK — URL `table_data_set=impressions` |
| 5 | Filter → Publish Type → Reel → Apply Filter | OK — chip "Publish Type: Reel / Include", URL `content_post_class: reel`. Table first failed to load ("This table failed to load"); clicked Reload once → `Posts (4)` |
| 6 | Table View: Sum row Engagements ÷ Impressions × 100 | 16,499 ÷ 1,546,300 × 100 = 1.0670 % (see A6) |
| 7 | Noted aggregate Impressions | Sum row: **1,546,300** |
| 8 | Data Set dropdown → `Reels` (Reel filter, FB channel, dates retained) | OK — URL `table_data_set=reels`, `Posts (4)` |
| 9 | Noted aggregate Plays | Sum row: **1,546,300** |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reel posts have Impressions data | 4 of 4 Reel posts show a numeric Impressions value: 746,373 / 257,737 / 509,388 / 32,802 (none "–"). Aggregate Sum Impressions 1,546,300. | PASS |
| A6 | 6 | Engagements ÷ Impressions × 100 equals the Engagement Rate value | Aggregate: 16,499 ÷ 1,546,300 × 100 = 1.067 % → rounds to 1.07 %; aggregate Engagement Rate (Average row) = **1.07 %**. Sum row shows "N/A" for Engagement Rate; the Average row carries it. Cross-check on the Average row: 4,125 ÷ 386,575 × 100 = 1.067 %. Per post: 11,414/746,373 = 1.529 % (shown 1.53 %), 2,500/257,737 = 0.970 % (0.97 %), 2,441/509,388 = 0.479 % (0.48 %), 144/32,802 = 0.439 % (0.44 %) — all match. | PASS |
| A9 | 9 | Aggregate Impressions equals aggregate Plays | Impressions Sum 1,546,300 = Plays Sum 1,546,300. Per post identical too (746,373 / 257,737 / 509,388 / 32,802); Average row Impressions 386,575 = Plays 386,575. | PASS |

## Evidence
- Impressions set, Sum row: Engagements 16,499 · Impressions 1,546,300 · Organic/Paid Impressions "–" · Engagement Rate "N/A" (Sum) / 1.07 % (Average). Posts (4), all Type Video / Publish Type Reel, dated Jan 04 and Jan 07, 2025.
- Reels set, Sum row: Engagements 16,499 · Plays 1,546,300 · Initial Plays 1,216,104 · Reel Replays 330,196 (Initial + Replays = Plays ✓).
- Screenshots in `.playwright-out/QA-31513/`: `06-date-picker.png`, `07-channels.png`, `08-impressions.png`, `10-publish-type.png`, `12-after-filter.png` (table-failed state), `14-table-impressions.png`, `15-aggregate-average.png`, `16-reels-dataset.png`, `17-reels-table-avg.png`, `18-reels-table-sum.png`.

## Known bugs checked
- Case file "Open linked bugs": none open → Rule 7 screen passed. `bug-history.md` / `known-quirks.md` pre-grep for QA-31513: no entries. Nothing matching was reproduced.
- Observations (not bugs against these assertions, verdict unaffected): orange "Facebook Data Collection Disruption 9/27" banner displayed; the Content page needed one reload on first open, and the table needed one Reload click after applying the filter (transient dev slowness, recovered each time, well inside the 5-min budget); post #4 shows Reach 36,520 > Impressions 32,802 (Impressions set) — not covered by any assertion here.

## Bugs filed
None.

## Cleanup
None (read-only).
