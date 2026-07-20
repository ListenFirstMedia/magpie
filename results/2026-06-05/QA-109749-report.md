---
ticket: QA-109749
title: Brand Audience > Threads - Hovering Functionality
date: 2026-06-08
batch: QA-22296 batch 7
operator: magpie
result: PARTIAL (no-data carry-forward)
skill: audience-metrics-export / chart-hover-tooltip (n/a — no data to hover)
---

## Steps
1. Login as Yash on `app.lfmdev.in` — Adam Orfei account. PASS.
2. Navigate `/#explore/brand/audience?brand_id=4018&account_id=54&channels=threads` (MTV Threads Audience). PASS.
3. Confirm Threads-channel filter active (only Threads icon highlighted in the channel ghost row). PASS.
4. Hover Followers By Country tile to see tooltip — NO DATA.
5. Hover Followers By City tile to see tooltip — NO DATA.
6. Hover Followers: Gender Breakdown tile to see tooltip — NO DATA.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | Threads channel filter active | Threads icon highlighted; URL channels=threads | Confirmed | PASS |
| A2 | Followers By Country renders chart | Chart or table renders | "There is no data available. Please select a different brand, brand set, or date range." | BLOCKED-NO-DATA |
| A3 | Followers By City renders chart | Chart or table renders | "There is no data available." | BLOCKED-NO-DATA |
| A4 | Followers: Gender Breakdown renders chart | Donut/bar renders | "There is no data available." | BLOCKED-NO-DATA |
| A5 | Hover tooltip on Country tile shows country/% | Tooltip text | Not testable — no chart | NOT VERIFIED |
| A6 | Hover tooltip on City tile shows city/% | Tooltip text | Not testable — no chart | NOT VERIFIED |
| A7 | Hover tooltip on Gender tile shows gender/% | Tooltip text | Not testable — no chart | NOT VERIFIED |

## Evidence
- `/#explore/brand/audience?brand_id=4018&account_id=54&channels=threads&perspective=extended` — Authorized Data view; default 7-day window 2026-05-31 → 2026-06-06 returned no-data on all 5 Threads-Audience tiles.
- Extended date range probe `from=2026-01-01&to=2026-06-06` — still no data across all 5 tiles (Followers By Country, By City, Geo Breakdown By Country, Geo Breakdown By City, Followers: Gender Breakdown).
- Probed alternate brand Michael Kors (brand_id=12597) — Brand>Insights/Audience Threads renderer-hang reproduced (per known-quirks 2026-06-08 entry), forcing tab recovery.
- View toggle URL behavior: clicking perspective=standard URL stripped `channels=threads` to `channels=null` per Threads-perspective-toggle quirk.

## Bugs filed
None new. Carry-forward: Brand Audience > Threads tiles on MTV show NO DATA across all tested windows on Adam Orfei account. The hover-functionality assertion is unreachable without a brand+window combo that surfaces Threads-Audience numerics. This is data-availability-related rather than a Brand>Audience product defect. Recommend pairing this test with a known-Threads-data brand (e.g., Threads-confirmed Amazon Prime Video or alternate Adam-Orfei-account brand identified via QA-110074 sweep).

## Skill maintenance
- `audience-metrics-export` and `chart-hover-tooltip` not exercised on data — no streak bump.
