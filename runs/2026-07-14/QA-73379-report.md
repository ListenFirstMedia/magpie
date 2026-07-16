# QA-73379 — Brand Content > Facebook Only: Reels - Current Data set Export - JMeter

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Viacom (account_id=181), Brand: MTV (brand_id=4018), Data Set: Public, Facebook channel only, Publish Type: Reel filter (carried over)
**Status:** ✅ PASS (2/2 assertions)

## Steps executed
1. MTV brand + Facebook-only channel already active from prior case; Publish Type: Reel filter (Include) also already active from the QA-43637 flow, kept in place.
2. Data Set dropdown → switched to "Public".
3. Confirmed Posts (279) — identical count to the Reels data set (QA-35084) and Facebook Only: Reactions data set (QA-43637) runs for the same brand/window, confirming only Reel posts render.
4. Clicked Export → "Export Select Data Sets" modal opened with **Public** pre-checked (the current data set) and **CSV** selected (not Google Sheets).
5. Clicked Ok. The export completed and auto-downloaded via Playwright's native `download` event: `MTV-Brand Content-2025-07-12-2026-07-12-posts.csv`.
6. Parsed the CSV on disk (`.playwright-out/MTV-Brand-Content-2025-07-12-2026-07-12-posts.csv`) and cross-checked against the on-screen table.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 5) | Reels post data only displays | CSV: 279/279 rows have `Publish Type = Reel`, 0 non-Reel rows | ✅ PASS |
| A2 (step 5) | Post Table and Export match | Row count: CSV 279 = on-screen Posts (279). Sum Engagements: CSV 3,771,566 = on-screen Sum row 3,771,566 (exact). Row 1 (Aug 10, 2025): CSV Engagements/Reactions/Comments/Shares = 392,027 / 338,906 / 12,824 / 40,297 — exact match to the Detail view's post 1 | ✅ PASS |

## Bugs filed
None.

## Cleanup
None — read-only export verification, no mutation. Downloaded file retained at `.playwright-out/MTV-Brand-Content-2025-07-12-2026-07-12-posts.csv` for evidence.

## Notes
Ticket title references "JMeter" (see also QA-43637) — a load-testing tool name likely carried over from an unrelated naming convention; executed as a standard UI + CSV export verification, not a load test.
