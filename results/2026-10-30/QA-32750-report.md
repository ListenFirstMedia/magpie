# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-30 (Friday) — case is fixed to Michael Kors
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook only · Date range: default week Oct. 22, 2026 – Oct. 28, 2026 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 78,826,961 · Ad Spend $576,277.34 · Ad Clicks 1,453,999 · Paid Actions 3,667,958 · Ad 95% Completed Views 426,683)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Paid → Michael Kors → Facebook only | ✅ `#explore/brand/paid?brand_id=3801&channels=facebook&table_data_set=engagements` |
| 4 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 850 · Paid Impressions **78,826,961** · Spend **$576,277.34** · Clicks **1,453,999** (CTR 1.84%) · Paid Actions **3,667,958** (rate 4.65%) · 95% Completed Video Views **426,683** |
| 5–7 | Reporting → Time Window Comparison → Add Brand By Name "Michael Kors" → perspective **Authorized** | ✅ brand row added, `0-perspective-toggle` checked |
| 8 | Absolute dates Oct 22 – Oct 28 2026, Interval **Aggregate** | ✅ from/to calendars OCTOBER 2026, range-start 22 / range-end 28 |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions | ✅ all five checked |
| 11–12 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/162043` (story tables polled after the Run Report redirect) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Paid page big numbers == TWC report values | Ad Impressions 78,826,961 = 78,826,961 · Ad Spend $576,277.34 = $576,277.34 · Ad Clicks 1,453,999 = 1,453,999 · Paid Actions 3,667,958 = 3,667,958 · Ad 95% Completed Views 426,683 = 426,683 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (tile titles) and `ctx._twc.mk_fb` (story URL + per-metric tables).

## Known bugs checked
- None open on QA-32750.

## Bugs filed
None.

## Cleanup
TWC story 162043 created on dev (read-only artifact, not deleted).
