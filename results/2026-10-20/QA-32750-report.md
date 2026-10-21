# QA-32750 — Brand Paid vs TWC > Big Numbers Data QA > Facebook

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, lfiqa user switched to **Michael Kors**
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Facebook · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 (Paid page default = TWC absolute dates Oct 12–18 2026)
**Verdict: PASS — all five Facebook Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 57,772,177 · Ad Spend $464,710.85 · Ad Clicks 1,397,238 · Paid Actions 2,967,197 · Ad 95% Completed Views 347,343)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand → Paid (visible submenu link) → brand Michael Kors (account default) → Facebook only | ✅ `#explore/brand/paid?brand_id=3801…channels=facebook`, Active Ads 918 |
| 4 | Note the big numbers (exact values from `.tile .count[title]`; the visible text is abbreviated) | ✅ Paid Impressions **57,772,177** (57.8M) · Spend **$464,710.85** ($465K) · Clicks **1,397,238** (1.4M) · Paid Actions **2,967,197** (2.97M) · 95% Completed Video Views **347,343** (347K) |
| 5–6 | Reporting → Time Window Comparison (`app-reporting.lfmdev.in/#/time_window_comparison`) | ✅ |
| 7 | Add Michael Kors (Authorized perspective toggle checked) | ✅ |
| 8 | Absolute Dates Oct 12 → Oct 18 2026, Interval → Aggregate | ✅ `range-start` 12 / `range-end` 18, Interval "Aggregate" |
| 9–10 | By Channel → Facebook › Paid › Ad Clicks, Paid Actions, Ad Impressions, Ad 95% Completed Views, Ad Spend | ✅ all five `aria-checked=true` |
| 11 | Deselect Show Metrics Graphs | ✅ `false` |
| 12 | Run Report | ✅ story `#story/time_window_comparison/161416`, one table per metric |
| 13 | Compare | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13a | Paid Impressions == Facebook Ad Impressions | 57,772,177 == 57,772,177 | ✅ PASS |
| A13b | Spend == Facebook Ad Spend | $464,710.85 == $464,710.85 | ✅ PASS |
| A13c | Clicks == Facebook Ad Clicks | 1,397,238 == 1,397,238 | ✅ PASS |
| A13d | Paid Actions == Facebook Paid Actions | 2,967,197 == 2,967,197 | ✅ PASS |
| A13e | 95% Completed Video Views == Facebook Ad 95% Completed Views | 347,343 == 347,343 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_fb` (big numbers) and `ctx._twcMK` (TWC tables, also carry the Instagram metrics used by QA-32751).

## Known bugs checked
- None open on the case.

## Notes (mechanics)
- Paid big-number tiles expose the exact value in `.count[title]` (e.g. title="57,772,177" while the text shows "57.8M"); no hover needed.
- TWC builder: the competitive-set dropdown stays open after adding a brand and intercepts clicks — click the "Select a Date Range" heading to close it, pick the Interval box by its text "Days", never force-click near the top nav (a force click on the metric filter landed on the Home menu and lost the builder once).

## Bugs filed
None.

## Cleanup
Report story created on dev (read-only data; harmless).
