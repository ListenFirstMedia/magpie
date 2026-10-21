# QA-32752 — Brand Paid vs TWC > Big Numbers Data QA > Twitter

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, lfiqa user switched to **Hulu**
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Twitter · Date range: Jan 01, 2025 – Jan 31, 2025 on both surfaces
**Verdict: PASS — all five Twitter Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 7,943,209 · Ad Spend $57,572.06 · Ad Clicks 41,909 · Ad Engagements 96,741 · Ad Retweets 318)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand → Paid → Hulu (account default) | ✅ |
| 3 | Twitter only | ✅ `channels=twitter`, Active Ads 20 |
| 4 | Date range 1 Jan 2025 → 31 Jan 2025 (START/END picker) | ✅ URL `from=2025-01-01&to=2025-01-31` |
| 5 | Big numbers (exact `.count[title]`) | ✅ Paid Impressions **7,943,209** · Spend **$57,572.06** · Clicks **41,909** (CTR 0.53%) · Engagements **96,741** (Engagement Rate 1.22%) · Retweets **318** |
| 6–7 | Reporting → Time Window Comparison | ✅ |
| 8 | Add Hulu (Authorized) | ✅ |
| 9 | Absolute dates: from-calendar and to-calendar paged back to JANUARY 2025 (`th.prev` ×21), 1 → 31; Interval Aggregate | ✅ |
| 10–11 | By Channel → Twitter › Paid › Ad Clicks, Ad Engagements, Ad Impressions, Ad Retweets, Ad Spend | ✅ all `aria-checked=true` |
| 12 | Graphs off → Run Report | ✅ `#story/time_window_comparison/161417` |
| 13 | Compare | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Paid Impressions == Twitter Ad Impressions | 7,943,209 == 7,943,209 | ✅ PASS |
| A2 | Spend == Twitter Ad Spend | $57,572.06 == $57,572.06 | ✅ PASS |
| A3 | Clicks == Twitter Ad Clicks | 41,909 == 41,909 | ✅ PASS |
| A4 | Engagements == Twitter Ad Engagements | 96,741 == 96,741 | ✅ PASS |
| A5 | Retweets == Twitter Ad Retweets | 318 == 318 | ✅ PASS |

## Evidence
- Session results `ctx._paid.hulu_tw` and `ctx._twcHulu`.

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
Report story created on dev (harmless).
