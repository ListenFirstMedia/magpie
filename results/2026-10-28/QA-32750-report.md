# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-28 (Wednesday) — case is fixed to Michael Kors
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook only · Date range: default week Oct. 20, 2026 – Oct. 26, 2026 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 82,974,713 · Ad Spend $644,989.37 · Ad Clicks 1,565,967 · Paid Actions 3,970,290 · Ad 95% Completed Views 468,304)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Paid → Michael Kors → Facebook only | ✅ `#explore/brand/paid?brand_id=3801&channels=facebook&table_data_set=engagements` |
| 4 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 898 · Paid Impressions **82,974,713** · Spend **$644,989.37** · Clicks **1,565,967** (CTR 1.89%) · Paid Actions **3,970,290** (rate 4.78%) · 95% Completed Video Views **468,304** |
| 5–7 | Reporting → Time Window Comparison → Add Brand By Name "Michael Kors" → perspective **Authorized** | ✅ brand row added, `0-perspective-toggle` checked |
| 8 | Absolute dates Oct 20 – Oct 26 2026, Interval **Aggregate** | ✅ from/to calendars OCTOBER 2026, range-start 20 / range-end 26 |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions | ✅ all five checked |
| 11–12 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/161897` (brand typeahead and Run Report now verified/retried by the helper) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Paid page big numbers == TWC report values | Ad Impressions 82,974,713 = 82,974,713 · Ad Spend $644,989.37 = $644,989.37 · Ad Clicks 1,565,967 = 1,565,967 · Paid Actions 3,970,290 = 3,970,290 · Ad 95% Completed Views 468,304 = 468,304 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (tile titles) and `ctx._twc.mk_fb` (story URL + per-metric tables).

## Known bugs checked
- None open on QA-32750.

## Bugs filed
None.

## Cleanup
TWC story 161897 created on dev (read-only artifact, not deleted).
