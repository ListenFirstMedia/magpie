# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-26 (Monday) — case is fixed to Michael Kors
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook only · Date range: default week Oct. 18, 2026 – Oct. 24, 2026 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 80,078,438 · Ad Spend $617,199.62 · Ad Clicks 1,580,027 · Paid Actions 3,921,949 · Ad 95% Completed Views 456,200)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Paid → Michael Kors → Facebook only | ✅ `#explore/brand/paid?brand_id=3801&channels=facebook&table_data_set=engagements` |
| 4 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 891 · Paid Impressions **80,078,438** · Spend **$617,199.62** · Clicks **1,580,027** (CTR 1.97%) · Paid Actions **3,921,949** (rate 4.90%) · 95% Completed Video Views **456,200** |
| 5–7 | Reporting → Time Window Comparison → Add Brand By Name "Michael Kors" → perspective **Authorized** | ✅ brand row added, `0-perspective-toggle` checked |
| 8 | Absolute dates Oct 18 – Oct 24 2026, Interval **Aggregate** | ✅ from/to calendars OCTOBER 2026, range-start 18 / range-end 24 |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions | ✅ all five checked |
| 11–12 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/161733` (first Run click needed a second click after ~60 s — builder had not navigated) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Paid page big numbers == TWC report values | Ad Impressions 80,078,438 = 80,078,438 · Ad Spend $617,199.62 = $617,199.62 · Ad Clicks 1,580,027 = 1,580,027 · Paid Actions 3,921,949 = 3,921,949 · Ad 95% Completed Views 456,200 = 456,200 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (tile titles) and `ctx._twc.mk_fb` (story URL + per-metric tables).

## Known bugs checked
- None open on QA-32750.

## Bugs filed
None.

## Cleanup
TWC story 161733 created on dev (read-only artifact, not deleted).
