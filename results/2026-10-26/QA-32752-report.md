# QA-32752 — Brand Paid vs TWC > Big Numbers Data QA > Twitter

**Run date:** 2026-10-26 (Monday) — case is fixed to Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Twitter only · Date range: Jan. 01, 2025 – Jan. 31, 2025 (same absolute dates in TWC, Aggregate interval, Authorized perspective)
**Verdict: PASS — all five Twitter Paid big numbers equal the TWC aggregate values exactly (Ad Impressions 7,943,209 · Ad Spend $57,572.06 · Ad Clicks 41,909 · Ad Engagements 96,741 · Ad Retweets 318)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand > Paid → Hulu → Twitter only → date range Jan 01 – Jan 31 2025 | ✅ `from=2025-01-01&to=2025-01-31&channels=twitter` |
| 5 | Big numbers (`.tile .count[title]`) | ✅ Active Ads 20 · Paid Impressions **7,943,209** · Spend **$57,572.06** · Clicks **41,909** (CTR 0.53%) · Engagements **96,741** (rate 1.22%) · Retweets **318** |
| 6–8 | Reporting → Time Window Comparison → Add Brand By Name "Hulu" → perspective **Authorized** | ✅ (typeahead option needed a real mouse click; `locator.click()` left the dropdown open) |
| 9 | Absolute dates Jan 1 – Jan 31 2025 (21 month-steps back on each calendar), Interval **Aggregate** | ✅ JANUARY 2025 / 1 → 31 |
| 10–11 | By Channel → Twitter › Paid › Ad Clicks, Ad Engagements, Ad Impressions, Ad Retweets, Ad Spend | ✅ all five checked |
| 12–13 | Show Metrics Graphs off → Run Report | ✅ `#story/time_window_comparison/161732` |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A14 | Paid page big numbers == TWC report values | Ad Impressions 7,943,209 = 7,943,209 · Ad Spend $57,572.06 = $57,572.06 · Ad Clicks 41,909 = 41,909 · Ad Engagements 96,741 = 96,741 · Ad Retweets 318 = 318 | ✅ PASS |

## Evidence
- Session results `ctx._paid.hulu_tw` and `ctx._twc.hulu_tw`. Values identical to the 2026-10-20 run (closed January 2025 window).

## Known bugs checked
- None open on QA-32752.

## Bugs filed
None.

## Cleanup
TWC story 161732 created on dev (read-only artifact, not deleted).
