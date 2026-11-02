# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Michael Kors
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook only · Date range: default week Oct. 19, 2026 – Oct. 25, 2026 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 82,745,937 · Ad Spend $631,266.15 · Ad Clicks 1,595,010 · Paid Actions 4,043,959 · Ad 95% Completed Views 475,041)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Paid → Michael Kors → Facebook only | ✅ `#explore/brand/paid?brand_id=3801&channels=facebook&table_data_set=engagements` |
| 4 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 886 · Paid Impressions **82,745,937** · Spend **$631,266.15** · Clicks **1,595,010** (CTR 1.93%) · Paid Actions **4,043,959** (rate 4.89%) · 95% Completed Video Views **475,041** |
| 5–7 | Reporting → Time Window Comparison → Add Brand By Name "Michael Kors" → perspective **Authorized** | ✅ brand row added, `0-perspective-toggle` checked |
| 8 | Absolute dates Oct 19 – Oct 25 2026, Interval **Aggregate** | ✅ from/to calendars OCTOBER 2026, range-start 19 / range-end 25 |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions | ✅ all five checked |
| 11–12 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/161802` (brand typeahead and Run Report now verified/retried by the helper) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Paid page big numbers == TWC report values | Ad Impressions 82,745,937 = 82,745,937 · Ad Spend $631,266.15 = $631,266.15 · Ad Clicks 1,595,010 = 1,595,010 · Paid Actions 4,043,959 = 4,043,959 · Ad 95% Completed Views 475,041 = 475,041 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (tile titles) and `ctx._twc.mk_fb` (story URL + per-metric tables).

## Known bugs checked
- None open on QA-32750.

## Bugs filed
None.

## Cleanup
TWC story 161802 created on dev (read-only artifact, not deleted).
