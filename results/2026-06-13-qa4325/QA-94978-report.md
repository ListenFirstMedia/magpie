# QA-94978 — Brand Audience - LinkedIn Channel - PNG Export Functionality — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** UCLA (127756) · **Channel:** LinkedIn
- **Skills:** audience-metrics-export
- **Result:** ⛔ BLOCKED-data (PNG export needs rendered tile data, absent this run)

## Steps
1. Brand > Audience for UCLA, LinkedIn channel; tried Public and **Authorized** views, and windows Jun 1–15 2026 and Jun 2025–Jun 2026.
2. All LinkedIn demographic tiles (Job Function / Industry / Seniority / Staff Count Range) show **"There is no data available. Please select a different brand, brand set, or date range."**

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Tile PNG export | Valid PNG of a LinkedIn tile | No tile data renders → PNG would capture empty state only | ⛔ not observable |
| Export controls present | Tiles + audience Export menu exist | Per-tile **Export**/Save to Dashboard + audience **Export** (CSV/GS/Metrics) present | ✅ |

## Notes / automation learning
- **UCLA LinkedIn audience demographic data is absent in this dev environment this session** (Public and Authorized, across two windows) — a test-data gap, not a defect. A meaningful tile-level PNG can't be captured without rendered data.
- The **6-tile LinkedIn PNG export sweep was verified end-to-end in the 2026-06-04 run** (`audience-metrics-export` skill credit). The export mechanism is unchanged; only the data is missing now.
- The brand-audience View toggle visual stays on "Public Data" even with `perspective=extended` (APPS-58574 misalignment, prior-noted) — but data is empty in either view here.

## Bugs filed
_None (test-data gap)._
