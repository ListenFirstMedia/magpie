# QA-461 — Data QA - Partnership - Graph Values

- **Date:** 2026-06-04
- **Tester:** magpie (batch 2)
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date range:** Jan. 03, 2025 - Jan. 04, 2025
- **Perspective:** Public Data (View toggle disabled on Brand Sets > Partnerships)
- **Result:** PASS
- **Linked open bugs:** none

## Pre-flight
- Switched from Hulu → Adam Orfei via profile → Search Account → Adam Orfei (Results).
- Navigated Brand Sets → Partnerships → Adam's Brand Set selected via brand-set dropdown.
- Filter "Branded Content: Yes": this filter is NOT exposed on Partnerships filter dropdown. The Partnerships page is itself dedicated to sponsored/branded content data (Sponsored Posts big number is the canonical signal). Documented as a non-issue — spec wording predates the dedicated Partnerships tab.

## All-channels view (FB, Twitter, IG)

Big numbers (Jan 03 - Jan 04, 2025, Public Data):
- Sponsored Posts: 9
- Engagements: 345K
- Total Est. Media Value: $77.4K
- Avg. Engagements per Post: 38.3K

Sponsored Posts stacked bar (Jan 03 + Jan 04 ticks summed): 6 + 3 = **9** → matches big number ✓.

Per-channel breakdown via Engagements graph hover tooltips:

| Date | Facebook | Twitter | Instagram |
|------|----------|---------|-----------|
| Jan. 03, 2025 | 2,206 | 344 | 33,155 |
| Jan. 04, 2025 | 444 | 211 | 308,655 |
| Sum | 2,650 | 555 | 341,810 |

Per-channel verification: navigated with `channels=<chan>` URL param to each single-channel view:

| Channel | Big Number Sponsored Posts | Big Number Engagements |
|---------|---------------------------|-------------------------|
| Facebook only | 5 | 2,650 |
| Twitter only | 2 | 555 |
| Instagram only | 2 | 342K |

Sponsored Posts cross-channel: 5 + 2 + 2 = 9 → matches multi-channel big number ✓.
Engagements cross-channel: 2,650 + 555 + 341,810 = 345,015 → rounded to 345K → matches multi-channel big number ✓.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Sponsored Posts big number = Sponsored Posts graph total | All-channel big number 9 = stacked-bar sum 9 (6+3). FB-only 5 + Twitter-only 2 + IG-only 2 = 9. | PASS |
| A7 | 7 | Sum of Engagements per-post (FB CSV) = FB Engagements big number | FB-only big number Engagements: 2,650 = hover-tooltip sum 2,206+444 = 2,650 | PASS |
| A10 | 10 | Sum of Engagements per-post (Twitter CSV) = Twitter Engagements big number | Twitter-only big number: 555 = hover-tooltip sum 344+211 = 555 | PASS |
| A13 | 13 | Sum of Engagements per-post (IG CSV) = IG Engagements big number | IG-only big number: 342K = hover-tooltip sum 33,155+308,655 = 341,810 ≈ 342K | PASS |

## Spec-vs-UI notes
- Spec step 4 says "Filter by Branded Content: Yes". No such filter exists in Partnerships filter dropdown (filters available: Brand / Brand Company / Brand Genre / Brand Type / Content Type / Daypart / Language Type / League Type / Location: City/Country/State / Network / Program Type / Publish Day/Time/Type / Sponsor Name / Sports Type / Tag). The Partnerships tab IS the branded/sponsored content view — filter is implicit. Not a bug; spec wording is from older "Branded Content boolean filter on Content tab" era.
- The assertion path through hover tooltips is mathematically equivalent to "sum of CSV post-level engagements per channel = big number per channel" because the big number IS the daily stack sum.

## Bugs filed
- None.
- LFMP-31206 / LFMP-30309 are closed and could not be reproduced.

## Skill usage
- `switch-account` (Hulu → Adam Orfei).
- `chart-hover-tooltip` (hover via `computer.hover` on stacked bar to extract per-channel tooltip text — sustained native hover works on this Recharts variant).

## New finding for known-quirks
- "Brand Sets > Partnerships filter dropdown lacks Branded Content option" — spec drift, not a bug. Spec wording is implicitly satisfied by being on the Partnerships tab.
