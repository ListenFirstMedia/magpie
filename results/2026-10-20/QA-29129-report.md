# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless `claude -p` · **Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756, the account default; the case says only "Add a Brand", so the default brand was used, as in sibling QA-29124/29127) · **Date range:** Last 30 Days = Sep 19 – Oct 18, 2026 · **Channel:** LinkedIn only (`channels=linkedin`) · **Data set:** Impressions (`table_data_set=impressions`) · **Perspective:** Authorized (default) · **Posts (133)**

**Verdict: PASS (4/4 assertions)**
- Organic + Paid Impressions = Impressions on 133/133 posts.
- Engagements / Impressions = Engagement Rate on 133/133 posts.
- Engaged User Rate is "–" on 133/133 posts.
- Reach is "–" on every LinkedIn post for all three reach columns, so the reach identity holds only trivially (see A5).

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Programmatic login (`lfiqa@listenfirstmedia.com`, "With existing account"); lands in the UCLA account (`account_id=799`, breadcrumb "ACCOUNT: UCLA") | ✅ |
| 1 | Hover **Brand** in the top nav → click **Content** | ✅ `#explore/brand/content`, brand "University of California, Los Angeles" |
| 2 | Brand = UCLA default; Data Set dropdown → **Impressions** (picked before the channel, per the grid-math skill) | ✅ `table_data_set=impressions` |
| 3 | Channels: clicked Facebook, X, Instagram, TikTok, Threads off (LinkedIn enabled, left on last); **Apply** → `channels=linkedin` | ✅ `.channel-ghost.linkedin.enabled`, all others disabled |
| 3 | Date picker → "Make a Selection" dropdown → **Last 30 Days** (Sep 19, 2026 – Oct 18, 2026); the picker applied on selection | ✅ `from=2026-09-19&to=2026-10-18`, Posts (133) |
| 4–6 | Switched to **Table View** (`[title="Table View"]`); scraped all 133 rows plus the Sum/Average row via DOM, with the identities evaluated in page JS | ✅ 133 rows, headers: Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions for each post | 133/133 exact, 0 mismatches, 0 skipped. Paid Impressions is "–" on all 133 posts, so Organic = Impressions. Rank 1: 223,644 + – = 223,644 ✓; rank 2: 45,951 ✓; rank 3: 80,546 ✓. Sum row: Impressions 1,888,569 = Organic 1,888,569 + Paid "–". The sums of the post rows match the Sum row exactly (Σ Impressions 1,888,569, Σ Organic 1,888,569, Σ Paid 0). | ✅ PASS |
| A5 | 5 | Organic Reach + Promoted (Paid) Reach = Reach for each post | Reach, Organic Reach and Paid Reach are all "–" on 133/133 posts, and "N/A" on the Sum row (all three). No post has a numeric value in any reach column, so the identity holds only as 0 = 0 / no data. LinkedIn does not populate Reach in this data set (like Twitter, per QA-20321/24278), and I treated that as structural absence. Not evaluable numerically. | ✅ PASS (n/a, consistent) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 133/133 within ±0.01 pp of the 2-decimal display, 0 mismatches, 0 skipped. Rank 1: 11,200 / 223,644 = 5.008% → 5.01% ✓; rank 2: 2,089 / 45,951 = 4.546% → 4.55% ✓; rank 3: 1,331 / 80,546 = 1.652% → 1.65% ✓. Aggregate: Σ Engagements 27,993 / Σ Impressions 1,888,569 = 1.482%, which matches the Average row's Engagement Rate of 1.48%. The Sum row's own Engagement Rate cell shows "N/A" by design. | ✅ PASS |
| A6b | 6 | Engaged User Rate displays en-dash | "–" on 133/133 posts. The Sum row shows "N/A" (aggregate cell), and the Average row shows "–". | ✅ PASS |

## Evidence
- Landing page, UCLA account and brand: `.playwright-out/QA-29129/01-landing.png`
- Date picker and Last 30 Days preset: `.playwright-out/QA-29129/02-datepicker.png`, `.playwright-out/QA-29129/03-last30-picked.png`
- Applied state (Impressions data set, LinkedIn only, Sep 19 – Oct 18, 2026, Posts (133), aggregate rows): `.playwright-out/QA-29129/04a-state.png`
- Table View: `.playwright-out/QA-29129/04-table.png`
- Aggregate numbers (Sum row): Engagements 27,993 · Impressions 1,888,569 · Organic 1,888,569 · Paid "–". Average row: Engagements 210 · ER 1.48% · Impressions 14,200.
- Post dates span Sep 21 – Oct 12, 2026 (LinkedIn).
- Observation: the page showed a "Facebook Posts Insights Disruption" banner. It does not affect this LinkedIn-only case.

## Known bugs checked
- Case file "Open linked bugs": none open, so the Rule 7 screen passed and the case ran.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-29129 entries (pre-fetched). Nothing reproduced that interferes with the assertions.
- The Reach "–" on LinkedIn is consistent with the structural-absence pattern recorded for other channels (see the grid-math skill and QA-20321/24278), and is not a new defect.

## Bugs filed
None. Nothing was mutated, so no cleanup was needed.

## Notes
- The skill/REGISTRY bump for `brand-content-grid-math` is deferred to harvest.sh. The Last 30 Days preset lives in the "Make a Selection: Auto" dropdown inside the date picker (`.lfm-option-label` "Last 30 Days"), and the picker applied without needing the Ok button.
- Because the case names no brand, the default UCLA brand was used. If a different LinkedIn-active brand is intended, the case text should say so.
