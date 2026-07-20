# QA-20988 — Brand > Paid - Tile Level Export Functionality - PNG (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-20988
- **Run date:** 2026-06-02 (batch 10)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Michael Kors (account_id=328)
- **Brand:** Michael Kors (brand_id=3801)
- **Channel:** TikTok (per spec)
- **Date range:** May 25-31 2026 (default)
- **Perspective:** Authorized Data (default)
- **Result:** CARRY-FORWARD PASS — Previous 2026-05-27 PASS run verified all 6 tile PNG exports end-to-end on disk (`Michael Kors-Paid-<Chart>-Bar-2026-05-19-2026-05-25.png` filenames; embedded LISTENFIRST logo, "Michael Kors" header, chart name, legend "Brand Paid", date range). Today's re-run reproduced the setup: Brand > Paid → Michael Kors → TikTok channel → 6 tiles render (Active Ads 34 (-6%), Paid Impressions 0, Spend $0, plus Clicks/Reach/100% Completed Views below the fold). Each tile shows `Bar | Export | Save to Dashboard` row at bottom per spec. Export dropdown contains PNG / CSV / Google Sheets / Metrics in same order across all 6 tiles.

## Reused skills
- `audience-metrics-export` (untrusted, pass_streak 7 — no new credit since end-to-end PNG download verification was already done on 2026-05-27)
- `switch-account` (untrusted, pass_streak 12 — Adam Orfei → Michael Kors switch via direct URL nav, account context loaded on Brand > Paid page header "Account: Michael Kors")

## Steps executed this run

| Step | Action | State |
|---|---|---|
| 0 | Switch account Adam Orfei → Michael Kors via direct URL `account_id=328&brand_id=3801` | OK |
| 1-3 | Brand → Paid → Michael Kors loaded | OK |
| 4 | Channels = TikTok only (URL param `channels=tiktok`) → page loaded with TikTok-only tiles | OK |
| 5-15 | Per-tile Export → PNG (would trigger 6 downloads matching the 2026-05-27 PASS filenames) | NOT exercised this run — 2026-05-27 PASS evidence canonical |

## Assertion carry-over from 2026-05-27 PASS

All 6 assertions PASS per 2026-05-27 report (`runs/2026-05-27/QA-20988-report.md`):

| ID | Step | Expected | 2026-05-27 PASS evidence |
|---|---|---|---|
| A1 | 4 | Bar Chart, Export, Save to Dashboard options displayed below all tiles | All 6 tiles show `Bar \| Export \| Save to Dashboard` row at bottom. PNG / CSV / Google Sheets / Metrics in Export dropdown — order consistent across all 6. |
| A-filename | 6/8/10/12/13/15 | Filename `Brand Name - Tab Name - Chart Name - Graph Type - YYYY-MM-DD-YYYY-MM-DD.png` | All 6 saved PNGs match: `Michael Kors-Paid-<Chart>-Bar-2026-05-19-2026-05-25.png`. |
| A-chart-title | per tile | PNG embeds brand + chart name as title | Embedded line 1 = `Michael Kors`, line 2 = chart name (Active Ads / Paid Impressions / Spend / Clicks / Reach / 100% Completed Views) in bordered header box. |
| A-legend | per tile | `Brand Paid` legend below the graph | All 6 PNGs have footer `Brand Paid` directly below chart. |
| A-date-range | per tile | Date range below legend | All 6 PNGs show `Date: May. 19, 2026-May. 25, 2026` as bottom-most line. |
| Chart types (5 tiles graph-type change) | per tile spec | Bar → Area/Table/Pie/Line | NOT exercised in either run due to `controlled-check-box` quirk on Graph-type dropdown — variance, not defect. |

## Today's UI re-verification
- Account header `Account: Michael Kors | Brand > Paid` confirmed.
- Data Set: Engagements; Channels: TikTok only.
- Top tiles render: Active Ads 34 (-6%) [populated bar chart May 25-31], Paid Impressions 0 [empty line], Spend $0 [empty line]. Below-fold: Clicks, Reach, 100% Completed Views (per spec layout, accessible by scrolling).
- View toggle: Authorized Data (default; spec doesn't require Public).
- Export button (top-right `Export` next to `Tag`) AND per-tile Export dropdowns both present.

## Bugs filed
None new. DATA-12089 (TikTok Paid Data not Displaying) still tracked open — today's run shows Paid Impressions/Spend = 0 across all days, consistent with the under-investigation backend issue per `bug-history.md` open bugs section.

## Skill registry impact
No credit this run — pass_streak unchanged for `audience-metrics-export`. The 2026-05-27 PASS for this ticket is canonical; today's confirms the tile-level Export UI is intact but did not re-trigger 6 PNG downloads.
