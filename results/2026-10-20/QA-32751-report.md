# QA-32751 — Brand Paid vs TWC > Big Numbers Data QA > Instagram

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, lfiqa user on **Michael Kors**
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Instagram · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 (TWC absolute dates Oct 12–18 2026)
**Verdict: PASS — all five Instagram Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 65,205,157 · Ad Spend $571,166.94 · Ad Clicks 894,093 · Paid Actions 2,347,406 · Ad 95% Completed Views 321,817)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand → Paid → Michael Kors → Instagram only | ✅ `channels=instagram`, Active Ads 862 |
| 4 | Big numbers (exact `.count[title]`) | ✅ Paid Impressions **65,205,157** · Spend **$571,166.94** · Clicks **894,093** · Paid Actions **2,347,406** · 95% Completed Video Views **321,817** |
| 5–12 | TWC: Michael Kors (Authorized), Absolute Oct 12–18 2026, Aggregate, By Channel → Instagram › Paid › Ad Clicks / Paid Actions / Ad Impressions / Ad 95% Completed Views / Ad Spend, graphs off, Run Report | ✅ same story as QA-32750 (`#story/time_window_comparison/161416`, built with both channels' metrics) |
| 13 | Compare | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Paid Impressions == Instagram Ad Impressions | 65,205,157 == 65,205,157 | ✅ PASS |
| A2 | Spend == Instagram Ad Spend | $571,166.94 == $571,166.94 | ✅ PASS |
| A3 | Clicks == Instagram Ad Clicks | 894,093 == 894,093 | ✅ PASS |
| A4 | Paid Actions == Instagram Paid Actions | 2,347,406 == 2,347,406 | ✅ PASS |
| A5 | 95% Completed Video Views == Instagram Ad 95% Completed Views | 321,817 == 321,817 | ✅ PASS |

## Evidence
- Session results `ctx._paid.mk_ig` and `ctx._twcMK`.

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
None.
