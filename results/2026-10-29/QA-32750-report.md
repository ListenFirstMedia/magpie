# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-29 (Thursday) — case is fixed to Michael Kors
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook only · Date range: default week Oct. 21, 2026 – Oct. 27, 2026 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 83,043,832 · Ad Spend $651,239.77 · Ad Clicks 1,583,184 · Paid Actions 3,959,580 · Ad 95% Completed Views 467,005)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Paid → Michael Kors → Facebook only | ✅ `#explore/brand/paid?brand_id=3801&channels=facebook&table_data_set=engagements` |
| 4 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 892 · Paid Impressions **83,043,832** · Spend **$651,239.77** · Clicks **1,583,184** (CTR 1.91%) · Paid Actions **3,959,580** (rate 4.77%) · 95% Completed Video Views **467,005** |
| 5–7 | Reporting → Time Window Comparison → Add Brand By Name "Michael Kors" → perspective **Authorized** | ✅ brand row added, `0-perspective-toggle` checked |
| 8 | Absolute dates Oct 21 – Oct 27 2026, Interval **Aggregate** | ✅ from/to calendars OCTOBER 2026, range-start 21 / range-end 27 |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions | ✅ all five checked |
| 11–12 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/161982` (story tables rendered ~10 s after the Run Report redirect; read in a follow-up poll) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Paid page big numbers == TWC report values | Ad Impressions 83,043,832 = 83,043,832 · Ad Spend $651,239.77 = $651,239.77 · Ad Clicks 1,583,184 = 1,583,184 · Paid Actions 3,959,580 = 3,959,580 · Ad 95% Completed Views 467,005 = 467,005 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (tile titles) and `ctx._twc.mk_fb` (story URL + per-metric tables).

## Known bugs checked
- None open on QA-32750.

## Bugs filed
None.

## Cleanup
TWC story 161982 created on dev (read-only artifact, not deleted).
