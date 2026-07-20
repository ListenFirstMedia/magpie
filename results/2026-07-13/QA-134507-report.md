# QA-134507 — BrandSet > Ranking > Instagram > Public Video Views & Average Public Video Views

- **Run:** 2026-07-13 (unattended, headless, Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134507
- **Account:** Viacom (account_id=181) — precondition met via account switch (started on Adam Orfei)
- **Brand Set:** LF // TV // Episodic (brand_set_id=756)
- **Surface:** Brand Sets → Rankings (`#explore/competitive/rankings`)
- **Channel:** Instagram only
- **Date Range:** Jul. 05, 2026 – Jul. 11, 2026 (default), Public Data perspective
- **Skill reused:** `brand-sets-content-posts` (Rankings sibling-page facts) + `switch-account`

## Verdict: **PASS** (12/12 assertions)

---

## Steps executed

1. Pre-flight programmatic login (lfiqa@listenfirstmedia.com) → `#home`. Session landed on **Adam Orfei**; switched to **Viacom** via LFQA menu (hover) → Search Account → Results row "Viacom" → account_id=181. ✓
2. Top nav **Brand Sets → Rankings** clicked → `#explore/competitive/rankings?brand_set_id=2956` (default set "2019 BET Awards Sponsors"). ✓
3. Brand-set chevron → "Search for a Brand Set" → typed `LF // TV // Episodic` → selected exact option (not "…Episodic Plus", Rule 1) → brand_set_id=756. ✓
4. Channels: deselected Facebook/Twitter/YouTube/TikTok, kept **Instagram** → Apply → URL `channels=instagram`, Brands (2,435). ✓
5. Opened **Rank** dropdown → enumerated options → selected **Public Video Views** (`rank_by_metric=lfm.owned_videos_score.public_owned_video_views_delta_v5`). Selecting the rank metric **reset channels to all 5** — re-applied Instagram only (see Findings). ✓
6. Clicked the **Public Video Views** column header twice (desc → asc). ✓
7. Read aggregate **Sum = 2,244,364,710**; computed Average; toggled aggregate **Sum → Average** → aggregate **Average = 921,710**. ✓
8. Rank dropdown → **Average Public Video Views** (`rank_by_metric=lfm.brand_view.avg_video_views_public`); channels reset again → re-applied Instagram only → Brands (432). ✓
9. Clicked the **Average Public Video Views** column header twice (desc → asc). ✓

---

## Evidence

### Public Video Views rank (Instagram, LF // TV // Episodic, Jul 5–11 2026)
- Columns: **Rank | Brand | Type | Programmer | Public Video Views | Share | Movement** (only the selected metric column present).
- Aggregate: **Sum = 2,244,364,710**, Average = N/A in Sum mode; **Average = 921,710** after toggle (+122.62%).
- Descending order (default & after 1st header click):
  1 Love Island UK 202,831,694 (9.04%) · 2 Love Island USA (Peacock) 152,750,780 (6.81%) · 3 CNN 136,764,510 (6.09%) · 4 Netflix 121,189,364 (5.40%) · 5 Entertainment Tonight 102,876,688 (4.58%) · 6 HBO Max 59,940,082 · 7 GO! Vive a tu manera 55,782,264 · 8 Amazon Prime Video 49,013,968 · 9 America's Got Talent 48,160,928 · 10 NBC Peacock 47,869,111 …
- Ascending (after 2nd header click): 0-value brands surface first (Disclaimer / Charlie's Colorforms City / Generation … all rank 568, value 0).
- **Share% consistency (proves Σ brands = aggregate Sum):** 202,831,694 / 2,244,364,710 = 9.04% ✓; 152,750,780 / 2,244,364,710 = 6.81% ✓; 136,764,510 / 2,244,364,710 = 6.09% ✓.
- **Average math (A7/A5d):** 2,244,364,710 ÷ 2,435 brands = 921,710.35 → displayed **921,710** ✓.
- Screenshot: `.playwright-out/QA-134507/pvv-average-aggregate.png`

### Average Public Video Views rank (Instagram, Brands (432))
- Columns: **Rank | Brand | Type | Programmer | Average Public Video Views | Share | Movement** (only the selected metric column present).
- Aggregate Sum/Average toggle is **disabled and locked to Average** (`#aggregate_toggle_brand_rankings` `disabled=true`, `checked=true`). Aggregate **Average = 514,484** (+57.34%).
- Descending order (default & after 1st header click):
  1 Saturday Night Live 12,357,295 (5.56%) · 2 MobLand 9,337,865 (4.20%) · 3 Rick and Morty 9,253,603 (4.16%) · 4 Starz 7,434,728 (3.35%) · 5 Outer Banks 6,799,436 (3.06%) · 6 X-Men '97 6,312,780 (2.84%) · 7 The Office (Peacock) 4,728,084 (2.13%) · 8 The Tonight Show 3,872,071 (1.74%) …
- Ascending (after 2nd header click): 0-value brands first (One Small Thing / Suits L.A. / Fuse / Jimmy Kimmel Live! … rank 421, value 0).
- **Average-of-averages math (A8d):** aggregate Average 514,484 × 432 = Σ 222,257,088; Share checks: 12,357,295 / 222,257,088 = 5.56% ✓; 9,337,865 / 222,257,088 = 4.20% ✓; 9,253,603 / 222,257,088 = 4.16% ✓. → aggregate Average = Σ(brand avgs) / 432.
- Screenshot: `.playwright-out/QA-134507/avg-pvv-rank.png`

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | Rank dropdown | Both "Public Video Views" and "Average Public Video Views" displayed | Both present in Rank dropdown (Public Data group), plus 20 other metrics | PASS |
| A5a | PVV rank | PVV column present; ranking determined by PVV | Public Video Views column present; rows descending by PVV (202.8M → 0) | PASS |
| A5b | PVV rank | No other (non-selected) rank-dropdown metric column shown | Only PVV metric column (+ Share/Movement derived, Type/Programmer dimensions) | PASS |
| A5c | PVV rank | Σ all-brand PVV = aggregate Sum | Aggregate Sum 2,244,364,710; per-brand Share% = value/Sum confirms Σ = aggregate Sum | PASS |
| A5d | PVV rank | Avg of all-brand PVV = aggregate Average | Aggregate Average 921,710 = Sum 2,244,364,710 / 2,435 brands | PASS |
| A6 | Step 6 | PVV column sorts desc & asc | 1st click desc (202.8M first); 2nd click asc (0-value first) | PASS |
| A7 | Step 7 | Calculated Avg PVV = aggregate table Average | 2,244,364,710 / 2,435 = 921,710 = aggregate Average (921,710) | PASS |
| A8a | Avg PVV rank | Avg PVV column present; ranking by Avg PVV | Average Public Video Views column present; rows descending (12.36M → 0) | PASS |
| A8b | Avg PVV rank | No other (non-selected) rank metric column shown | Only Average Public Video Views metric column present | PASS |
| A8c | Avg PVV rank | Aggregate Sum toggle NOT supported for Avg PVV | Sum/Average toggle disabled, locked to Average (no Sum value); only Average shown | PASS |
| A8d | Avg PVV rank | Avg of all-brand Avg PVV = aggregate average | Aggregate Average 514,484 = Σ(brand avgs 222,257,088) / 432 brands (Share% confirms) | PASS |
| A9 | Step 9 | Avg PVV column sorts desc & asc | 1st click desc (12.36M first); 2nd click asc (0-value first) | PASS |

---

## Known bugs checked (steps 2 & 5)

- **`knowledge-base/bug-history.md` grep `QA-134507`:** no entry.
- **Case file `## Open linked bugs`:** section absent → treated as none open; per Rule 7, ran the case normally.
- **Related Rankings history:**
  - **APPS-42920** (Test Failure, Major, **Closed**) — "Brand > Rankings – TikTok Channel disabled by default." Unrelated to Instagram; closed; did not interfere. Not reproduced (Instagram toggled cleanly).
  - **QA-134296** (Brandsets > Rankings – Data Last Updated timestamp, prior PASS, 0 open bugs) — cross-cut only. `Data Last Updated (PT): 07-12-2026 09:57 AM` observed, consistent.
- No known bug interfered with any assertion.

## Bugs filed

None (all assertions PASS).

## Findings / notes (non-blocking)

1. **Rank-metric change resets the channel filter to all 5 channels.** Each time a new Rank metric was selected, the channel selector reverted to Facebook/Twitter/Instagram/YouTube/TikTok (brand count jumped 2,435 → 4,809), and the applied filter was all-channels until re-applied. The spec order (Instagram first, then Rank) requires re-applying Instagram after every rank change to keep the ranking Instagram-scoped. Automation/UX behavior, not a defect for the assertions (Instagram re-applied before every measurement). Candidate known-quirk for a future `brand-sets-rankings` skill.
2. **Aggregate Average divisor = total brand count in the set.** For Public Video Views, aggregate Average = Sum ÷ 2,435 (the full brand count, zeros included), not ÷ (brands with non-zero value). Spec phrasing "Post Count for posts that have data" reconciles because every brand row carries a data value (0 counts as data). Calculated average matched exactly.
3. **Average-type rank metrics lock the aggregate to Average.** For "Average Public Video Views" the Sum/Average toggle is disabled (locked to Average) and the brand count is 432 (brands with an average value) vs 2,435 for the sum-type "Public Video Views" — consistent with A8c.
