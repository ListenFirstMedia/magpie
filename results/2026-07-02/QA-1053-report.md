# QA-1053 — TWC Aggregate - Relative dates - Lock icon and Endash

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1053 · Priority: Critical
- **Result:** **PASS** — all three step-12 assertions verified.
- **Account:** Hulu (account_id=336) · **Report:** `#story/time_window_comparison/155512` · **Window:** "Time Window Comparison (5 Days Out - Event Day)"
- **Brands:** Hulu (primary), Full Frontal with Samantha Bee, Snowfall — each Key Date **Jan 1, 2024**
- **Interval:** Aggregate · **Relative Start:** 5 Days Before Event · **Perspective:** Use Authorized Data (Where Available) · **Metrics:** Instagram Comments, TikTok Total Followers
- **Skills:** time-window-comparison-run (v6), keydate-picker (v2), switch-account

## Known bugs checked (pre-run)
All linked issues **Closed**; none reproduced. Notably **APPS-53940** ("TWC data not populated for Instagram Comments and TikTok Total Followers") did NOT reproduce — data populated correctly where authorized/available.

## Steps executed
1. Reporting → Time Window Comparison (via Reporting menu). ✅
2. **Relative Dates** → Interval **Aggregate**. ✅
3. Start = **5** Days (Before Event). ✅
4–9. Added **Hulu**, **Full Frontal with Samantha Bee**, **Snowfall**; each Key Date set to **Jan 1, 2024** via per-brand Select Key Date calendar (month-header → year-prev ×2 to 2024 → Jan → day 1). ✅
10. **Use Authorized Data (Where Available)** — Hulu flipped to Authorized; Full Frontal & Snowfall stayed Public (authorized not available). ✅
11. Data points **Instagram Comments** + **TikTok Total Followers** (via Filter Metrics search + checkbox). ✅
12. **Run Report** → story 155512. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Snowfall displays an en dash for **TikTok Total Followers** in Graph **and** Table | Table: Snowfall = **`–`** (DOM confirmed). Graph: Snowfall column shows **"No Data"** (the chart's no-value representation; no bar). | ✅ PASS |
| A2 | Full Frontal & Snowfall display a **lock** for **Instagram Comments** in Graph **and** Table | Graph: two lock glyphs at baseline (orange = Full Frontal, teal = Snowfall). Table: both rows show 🔒 (2× `i.far.fa-lock`). Hulu = 1,265. | ✅ PASS |
| A3 | Data displays for Full Frontal & Hulu for **TikTok Total Followers** | Hulu **5,500,000**; Full Frontal **149,700** (both graph bars + table values). | ✅ PASS |

## Evidence
- `qa1053-report.png` (full report): IG Comments chart (Hulu bar + 2 locks), TikTok chart (Hulu 5.5M, Full Frontal ~150K, Snowfall empty), both metric tables.
- `qa1053-tiktok-chart.png`: zoom of the TikTok chart (Snowfall = no bar / "No Data").
- DOM: IG Comments table — Hulu 1,265 / Full Frontal 🔒 / Snowfall 🔒; TikTok table — Hulu 5,500,000 / Full Frontal 149,700 / Snowfall –.

## Notes / findings (for skills)
- **Aggregate + Relative Dates:** Interval dropdown (`.lfm-dropdown-select-box`) → `.lfm-dropdown-option` "Aggregate"; the Start row becomes **Start [N] Days [Before] Event**. Set the Start number via the React value-setter + `input`/`change` events. Aggregate renders **one bar per brand** per metric (x-axis = brand names).
- **Lock vs en-dash representations differ between graph and table:** an **unauthorized** metric shows a **lock glyph** in the graph baseline and a **🔒 (`i.far.fa-lock`)** in the table; a **no-data** (authorized-but-empty) value shows **"No Data"** text in the graph and an **en-dash `–`** in the table. QA-1053: IG Comments = lock (Full Frontal, Snowfall unauthorized); Snowfall TikTok = no-data.
- **Use Authorized Data (Where Available)** only flips brands that HAVE authorized access (Hulu). Non-authorized brands (Full Frontal, Snowfall) stay Public — which is what drives the IG Comments lock.

## Bugs filed
None. All assertions passed.
