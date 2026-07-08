# QA-134188 — Brand > Insights - Verify Export (Monthly Interval)

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (real Chrome), `app.lfmdev.in`, programmatic email/password login (lfiqa@listenfirstmedia.com)
- **Account:** Adam Orfei (account_id=54) — precondition met without switching (already active)
- **Brand:** MTV (brand_id=4018) — default brand on Adam Orfei Brand>Insights
- **Perspective:** Authorized (perspective=extended, default on load)
- **Interval / Range:** Monthly / Last 3 Months → Apr. 01, 2026 – Jun. 30, 2026 (compare Dec 31 2025 – Mar 31 2026)
- **Verdict:** **PASS** (13/13 in-scope assertions). A14 (Google Sheets) SKIPPED — out of scope (Google 2FA).
- **Skills used:** `brand-insights-interval-picker` (v2), `export-csv` (v2)

## Pre-flight
- Navigated to `app.lfmdev.in` → redirected to Cognito hosted UI.
- Filled the "With existing account" form and clicked its Sign in → `oauth_callback` succeeded.
- `#home` rendered, title "Home - ListenFirst: Home". Active account already `account_id=54` (Adam Orfei). ✓

## Open-bug screen (Rule 7)
- Case file "Open linked bugs (as of 2026-07-03)": **None open** → ran normally.

## Steps executed
1. Navigated to Brand > Insights (`#explore/brand/insights?account_id=54`) → resolved to MTV, 4 channels (FB/X/IG/TikTok), Authorized.
2. Clicked the Date Range pill → overlay opened (Make a Selection, Interval, historical banner "back to Jan. 02, 2014", two calendars).
3. Interval dropdown → options confirmed **Daily / Weekly / Monthly / Quarterly** (default Daily); selected **Monthly**.
4. Make a Selection = **Auto** (default) confirmed.
5. Make a Selection dropdown → selected **Last 3 Months** → URL updated to `from=2026-04-01&to=2026-06-30`.
   - **Transient render-hang note:** immediately after the range switch, 5 tiles (incl. Follower Growth) showed "This tile failed to load. Please try again." with a Reload control. Per reload-first rule, reloaded the page once (URL carries the 3-month range) → **0 failed tiles**. Reload reset Interval to Daily (not URL-persisted), so re-opened the overlay and re-set Interval=Monthly, clicked Ok. All tiles then rendered cleanly (0 failed). Recovery within the per-step budget.
6. Observed all tiles (screenshot `05-monthly-tiles-full.png`, `06-toprow.png`).
7. Verified graph axes + monthly labels via DOM tick read (all 8 tiles).
8. Follower Growth tile → Export dropdown (PNG / CSV / Google Sheets / Metrics).
9. Selected **CSV** → synchronous Playwright download fired.
10. Read exported CSV from disk.
11. Compared chart data with CSV (tile total, per-bar class map, June tooltip).
12–13. Export → **Google Sheets: SKIPPED (out of scope — Google 2FA).** Did not open docs.google.com.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | All tiles display successfully | All 8 spec tiles + Total Followers rendered with data after reload recovery; 0 "failed to load" tiles | PASS |
| A2 | 6b | No blank state, broken graph, or error | No blank/broken/error state post-reload | PASS |
| A3 | 7a | X-axis shows selected months | Every tile X-axis: `Apr. 2026`, `May. 2026`, `Jun. 2026` (DOM tick read) | PASS |
| A4 | 7b | Y-axis numeric for all tiles except Fan Growth Rate | Follower Growth −450K..150K; New Posts 0..900; Engagements 0..22M; Impressions 0..~350M; Video Views 0..300M; Brand Reputation 96.8..98.6 (numeric). Fan Growth Rate shows % scale (0.004%..−0.005%); Content Engagement Rate shows % scale (0%..5.5%) — both rate metrics | PASS |
| A5 | 9a | Export → CSV downloads successfully | Playwright `download` event fired synchronously; file saved | PASS |
| A6 | 9b | No error during export | No error/toast; clean synchronous download | PASS |
| A7 | 10a | Filename `BrandName-Insights-Follower Growth-YYYY-MM-DD-YYYY-MM-DD.csv` | Server name `MTV-Insights-Follower Growth-2026-04-01-2026-06-30.csv` | PASS |
| A8 | 10b | Columns Start Date, End Date, Brand Name, Channel, Follower Growth | Header exactly `"Start Date","End Date","Brand Name","Channel","Follower Growth"` | PASS |
| A9 | 10c | Monthly records for selected range | 12 rows = 3 months (Apr/May/Jun 2026) × 4 channels | PASS |
| A10 | 10d | Each row = correct monthly date range | `04/01–04/30`, `05/01–05/31`, `06/01–06/30` 2026 | PASS |
| A11 | 11a | CSV data matches page data | June tooltip = CSV exactly (FB −59,427 / X 104,556 / IG −43,794 / TikTok 0); 12 bar classes = 12 CSV rows; per-month sum = tile header total −255K (CSV sum −255,390) | PASS |
| A12 | 11b | No data outside Last 3 Months | Only Apr/May/Jun 2026 present | PASS |
| A13 | 11c | No duplicates or missing monthly records | 12 distinct rows, 4 channels × 3 consecutive months, none missing | PASS |
| A14 | 13 | CSV data matches GS data | **SKIPPED — Google Sheets out of scope (Google 2FA)** | SKIPPED |

## Evidence

**Exported CSV** — `MTV-Insights-Follower Growth-2026-04-01-2026-06-30.csv` (on disk slugified: `.playwright-out/MTV-Insights-Follower-Growth-2026-04-01-2026-06-30.csv`):
```
"Start Date","End Date","Brand Name","Channel","Follower Growth"
"06/01/2026","06/30/2026","MTV","Facebook","-59427"
"06/01/2026","06/30/2026","MTV","Twitter","104556"
"06/01/2026","06/30/2026","MTV","Instagram","-43794"
"06/01/2026","06/30/2026","MTV","TikTok","0"
"05/01/2026","05/31/2026","MTV","Facebook","-24250"
"05/01/2026","05/31/2026","MTV","Twitter","146075"
"05/01/2026","05/31/2026","MTV","Instagram","-388859"
"05/01/2026","05/31/2026","MTV","TikTok","0"
"04/01/2026","04/30/2026","MTV","Facebook","-49210"
"04/01/2026","04/30/2026","MTV","Twitter","99897"
"04/01/2026","04/30/2026","MTV","Instagram","-40378"
"04/01/2026","04/30/2026","MTV","TikTok","0"
```

**Tile totals (header ± change):** Total Followers 93.2M (−<1%); Follower Growth −255K (−199%); Fan Growth Rate −0.27% (−198%); New Posts 1,622 (−8%); Engagements 25.5M (−31%); Content Engagement Rate 4.52% (+42%); Impressions 517M (−53%); Video Views 373M (−44%); Brand Reputation Index 98.42 (−<1%).

**Parity math (A11):** Jun 1,335 + May −267,034 + Apr 10,309 = −255,390 ≈ tile header −255K.

**Follower Growth June 2026 tooltip:** Facebook −59,427 (−145.1%), Twitter 104,556 (−28.4%), Instagram −43,794 (+88.7%), TikTok 0 (0.0%) — matches CSV June rows exactly.

**Screenshots** (`.playwright-out/QA-134188/`):
- `01-insights-initial.png` — initial 7-day load
- `03-date-overlay-open.png` — date overlay (Interval, Make a Selection, historical floor)
- `05-monthly-tiles-full.png` — full page, Monthly + Last 3 Months, all tiles rendered
- `06-toprow.png` — top tile row with Monthly bars
- `07-fg-tooltip-jun.png` — Follower Growth June tooltip

## Notes / observations (not bugs)
- **Transient tile-load failure on range switch** (5 tiles, recovered by one page reload) — matches the documented Brand>Insights load friction; under Playwright a single reload recovers cleanly. Not a product defect.
- **Interval is not URL-persisted** — a page reload resets Interval to Daily while the date range (in URL) persists. Automation-only note; re-set Interval after any reload.
- Fan Growth Rate and Content Engagement Rate render percentage Y-axis scales (rate metrics), consistent with expectations; spec A4's "except Fan Growth Rate" wording refers to the near-zero fractional-percent scale.

## Bugs filed
None. All in-scope assertions passed; the tile-load failure was transient and recovered on reload (documented friction, not a defect).
