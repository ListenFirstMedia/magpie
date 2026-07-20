# QA-134188 — Brand > Insights - Verify Export (Monthly Interval)

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134188
- **Priority:** Blocker (P1)
- **Account:** Adam Orfei (account_id=54) — switched from Hulu via account typeahead
- **Brand:** MTV (brand_id=4018) — default brand on Adam Orfei Brand>Insights; spec names no specific brand
- **Config:** Interval = Monthly, Make a Selection = Last 3 Months (Auto date mode), Date Range = Apr. 01, 2026 – Jun. 30, 2026, View = Authorized (default)
- **Skills used:** `brand-insights-interval-picker`, `export-csv`
- **Verdict:** **PASS** (Google Sheets out of scope — A14 skipped)

## Steps executed

1. Logged in (programmatic Cognito email/password, lfiqa) → `#home`.
2. Switched account Hulu → **Adam Orfei** (account_id=54) via LFQA menu → account typeahead → Results `.lfm-ta-option`.
3. Navigated **Brand > Insights** via nav menu (`#explore/brand/insights?brand_id=4018`); page rendered (title "Brand Insights") with valid `from/to/compare` params — the Chrome-MCP "Insights renderer hang" did **not** reproduce under Playwright.
4. Opened Date Range overlay; confirmed Interval default `Daily`, Make a Selection default `Auto`, historical banner "back to Jan. 10, 2014".
5. Set **Interval = Monthly** (dropdown options Daily/Weekly/Monthly/Quarterly).
6. Set **Make a Selection = Last 3 Months** → URL updated to `from=2026-04-01&to=2026-06-30`.
7. Observed all tiles render with data (see A1).
8. Clicked **Export** on the Follower Growth tile → menu (PNG / CSV / Google Sheets).
9. Selected **CSV** → synchronous Playwright download event fired.
10. Read exported CSV on disk.
11. Compared CSV vs chart (aggregate + per-channel tooltip).
12–13. **Google Sheets — SKIPPED** (out of scope on Playwright track; Google 2FA).

## Tile render (step 6/7)

All spec tiles present with data (View = Authorized):
- Total Followers: 93.2M (−<1%) [donut]
- **Follower Growth: −255K (−199%)** [stacked bar]
- Fan Growth Rate: −0.27% (−198%) [bar]
- New Posts: 1,622 (−8%)
- Engagements: 25.5M (−31%)
- Content Engagement Rate: 4.52% (+42%)
- Impressions: 517M (−53%) [area]
- Video Views: 373M (−44%) [area]
- Brand Reputation Index: 98.42 (−<1%)
- (+ Best Performing Content Per Channel, Trends table)

No blank / broken-graph / error states. Evidence: `.playwright-out/QA-134188/04-tiles-monthly-full.png`.

**X-axis** month ticks (all chart tiles): `Apr. 2026`, `May. 2026`, `Jun. 2026` — exactly the 3 selected months.
**Y-axis** numeric ranges observed: Follower Growth −450K…150K; New Posts 100…900; Engagements 2M…22M; Impressions/Video Views 50M…150M; Content Engagement Rate 0.5%…5.5%; Fan Growth Rate −0.005%…0.004% (rate axis — the spec-named exception).

## Exported CSV (`MTV-Insights-Follower Growth-2026-04-01-2026-06-30.csv`)

On-disk path: `.playwright-out/MTV-Insights-Follower-Growth-2026-04-01-2026-06-30.csv` (Playwright slugifies spaces→`-`; server-emitted name from the download event keeps the space and matches the spec format — see known-quirks Radaac/slugification note).

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

**CSV vs page reconciliation:**
- Sum of all 12 rows = (Jun 1,335) + (May −267,034) + (Apr 10,309) = **−255,390** = Follower Growth tile Value **−255,390**. Exact match.
- Per-channel spot-check (chart tooltip, May 2026): Facebook −24,250 / Twitter 146,075 / Instagram −388,859 / TikTok 0 — matches CSV May rows exactly (`.playwright-out/QA-134188/05-fg-tooltip-may.png`).
- 12 chart bars (`facebook|twitter|instagram|tiktok`-`2026-04-01|05-01|06-01`) map 1:1 to the 12 CSV rows.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (6a) | Observe tiles | All tiles display successfully | All 9 metric tiles + BPC + Trends rendered with data | PASS |
| A2 (6b) | Observe tiles | No blank state / broken graph / error | None; all charts painted | PASS |
| A3 (7a) | Verify X-axis | Months shown (e.g. Apr/May/Jun 2026) | `Apr. 2026`, `May. 2026`, `Jun. 2026` | PASS |
| A4 (7b) | Verify Y-axis | Numeric for all tiles except Fan Growth Rate | Numeric axes on all; Fan Growth Rate is % (exception) | PASS |
| A5 (9a) | Export → CSV | Downloads successfully | Synchronous download event fired | PASS |
| A6 (9b) | Export | No error during export | No error | PASS |
| A7 (10a) | Filename | `BrandName-Insights-Follower Growth-YYYY-MM-DD-YYYY-MM-DD.csv` | `MTV-Insights-Follower Growth-2026-04-01-2026-06-30.csv` (server name) | PASS |
| A8 (10b) | Columns | Start Date, End Date, Brand Name, Channel, Follower Growth | Exact header match | PASS |
| A9 (10c) | Monthly records | CSV has monthly records for range | 3 months (Apr/May/Jun) × 4 channels = 12 rows | PASS |
| A10 (10d) | Row date ranges | Each row = correct monthly range | 06/01–06/30, 05/01–05/31, 04/01–04/30 | PASS |
| A11 (11a) | CSV vs page | CSV matches page data | Aggregate −255,390 exact; May per-channel exact | PASS |
| A12 (11b) | Out-of-range | No data outside Last 3 Months | Only Apr/May/Jun 2026 present | PASS |
| A13 (11c) | Integrity | No duplicates or missing monthly records | 3 unique months × 4 channels, none missing/dup | PASS |
| A14 (13) | CSV vs GS | CSV matches Google Sheets data | **SKIPPED** — Google Sheets out of scope | SKIPPED |

## Known bugs checked

- Case file "Open linked bugs": **None open** (screened, ran normally per Rule 7).
- `bug-history.md` grep QA-134188: skill `brand-insights-interval-picker` + `export-csv`; **0 open / 0 closed** defects. Prior PASS 2026-06-02 (batch-5) with the same CSV filename pattern.
- **Brand>Insights renderer hang** (known-quirk, Chrome-MCP era; batch-11/QA-134639 BLOCKED under Chrome MCP): did **NOT** reproduce under Playwright — tiles rendered fast with valid date params, consistent with the 2026-06-22 Playwright spike finding. No regression.

## Bugs filed

None.

## Evidence
- `.playwright-out/QA-134188/01-insights-initial.png`
- `.playwright-out/QA-134188/02-daterange-open.png`
- `.playwright-out/QA-134188/03-monthly-last3-set.png`
- `.playwright-out/QA-134188/04-tiles-monthly-full.png`
- `.playwright-out/QA-134188/05-fg-tooltip-may.png`
- `.playwright-out/MTV-Insights-Follower-Growth-2026-04-01-2026-06-30.csv`
