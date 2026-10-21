# QA-30666 — Brand Insights - Cross-Channel Video Views Tile - Data QA

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Amazon Prime Video (342) (spec precondition "Amazon Prime Video, Wasserman" → brand Amazon Prime Video) · **Brand:** Amazon Prime Video (25864)
**Verdict: PASS (1/1) — Brand > Insights Video Views tile = 176,105,818; TWC Aggregate "By Channel" video views sum to exactly 176,105,818 (Δ 0)**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Insights, Amazon Prime Video, channels Facebook + Instagram + Twitter + TikTok (default selection), Authorized, default window Oct. 12 – Oct. 18, 2026 | ✅ (`channels=twitter,instagram,facebook,tiktok`) |
| 4 | Video Views tile | **176,105,818** (`.count[title]`; hover tooltip: Value 176,105,818 · Comparison 136,601,031 · Change +39,504,787) |
| 5–7 | Reporting → Time Window Comparison → Add Brand "Amazon Prime Video" (React-setter + `InputEvent` to surface `.al-typeahead__option`; keystrokes alone do not open the list on TWC) → Authorized (`label[for=0-perspective-toggle]`, checked=true) | ✅ |
| 8 | Absolute Dates Oct 12 → Oct 18 2026 (`.from-calendar` / `.to-calendar` day cells), Interval = **Aggregate** | ✅ |
| 9–10 | By Channel → Filter Metrics "Video Views" → Facebook › Video › **Page Video Views**, Twitter › Video › **Public Video Views**, Instagram › Video › **Video Views**, TikTok › Video › **Public Video Views** (leaf labels omit the channel prefix) | ✅ aria-checked=true ×4 |
| 11 | Options → **Show Metrics Graphs** unchecked | ✅ (true → false) |
| 12 | Run Report → story 161366; one Brand/Value table per metric | FB 25,021,999 · TW 812,651 · IG 73,268,368 · TikTok 77,002,800 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A12 | Insights cross-channel Video Views = Σ TWC channel video views | 25,021,999 + 812,651 + 73,268,368 + 77,002,800 = **176,105,818** = Insights **176,105,818** | ✅ PASS (exact) |

## Evidence
`.playwright-out/QA-30666/02-insights-video-views.png`, `05-twc-brand-dates.png`, `06-twc-metrics.png`, `07-twc-report.png`

## Known bugs checked
APPS-35918 / APPS-37192 (closed Test Failures) not reproduced; no open bugs.

## Bugs filed
None. · **Cleanup:** none (TWC story 161366 persists like any manual run).
