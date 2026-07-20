# QA-24021 — Reporting > TWC - Download

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV
**Status:** ✅ PASS

## Steps executed
1. Reporting → Time Window Comparison. Default Absolute Dates, current week (Jul 5–11, 2026).
2. Added brand MTV (Results, exact match).
3. Selected Facebook New Fans metric → Run Report → story 155912.
4. Export → CSV → downloaded synchronously to disk.
5. Verified file: `MTV - Time Window Comparison - Jul 5, 2026 - Jul 11, 2026.csv`.

## Assertions

| Expected | Actual | Status |
|----------|--------|--------|
| TWC report builds and downloads via Export → CSV | Confirmed. CSV header `Perspective,Brand,Date,Facebook New Fans`, 7 rows (one per day Jul 5–11), absolute `MM/DD/YYYY` dates (this report used **Absolute Dates**, not Relative — so the QA-199 relative-label finding does not apply here) | ✅ PASS |
| Values plausible | Facebook New Fans shows negative values (-1653 to -1946) — net fan loss for the week. Not flagged as a defect; net-negative growth is a valid real-world value for this metric | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
