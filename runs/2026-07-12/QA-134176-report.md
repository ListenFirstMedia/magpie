# QA-134176 — Brand > Insights - Auto Select Dates for all Intervals

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134176
- **Skill reused:** `brand-insights-interval-picker` (v2, untrusted)
- **Account/Brand:** Adam Orfei (account_id=54). Spec precondition brand **Sephora (brand_id=29)** is
  **not reachable on Adam Orfei** — navigating `…/insights?brand_id=29&account_id=54` redirects to
  `#home` (documented edge case; prior 2026-06-04 / 2026-06-08 runs hit the same wall). Per that
  precedent, the **brand-independent** date-picker-contents test was run on the **MTV** brand
  (brand_id=4018) substitute. This test verifies ONLY the Auto-Select dropdown contents per interval
  (Nikhil clarification in the spec Notes), which do not depend on the brand's data — so the
  substitution does not affect any assertion. No brand substitution was made to satisfy a
  data-bearing assertion (Rule 1 respected).

## Verdict: **PASS** (7/7 in-scope assertions)

---

## Time-shift context (per spec Notes)

Spec was authored when current month = **March 2026**; this run is **2026-07-12**. Hardcoded date
presets are time-dependent and must be shifted forward. As of 2026-07-12 the last **complete**
quarter is **Q2 2026** (Q3 in progress) and the last complete month is **June 2026**. The quarter
preset list runs back to **Q2 2014** (historical floor banner: "Historical data is available back to
**Jan. 10, 2014**" → Q1 2014 partially unavailable, Q2 2014 is the earliest full quarter). The month
preset list is capped at **11 months** (back to August 2025). The spec's authored quarter list (11
entries) is an abbreviated snapshot; prior PASS runs (2026-06-04 "Daily 80 entries / Quarterly 50
entries", 2026-06-08) accepted the full historical enumeration.

---

## Steps executed

1. Logged in programmatically (lfiqa@listenfirstmedia.com) → `#home` (Account: HBO Max).
2. Attempted precondition brand Sephora (29) on account 54 → redirect to `#home` (unreachable).
   Fell back to MTV (4018) on account 54 (brand-independent picker test) → Brand > Insights rendered.
3. Clicked the **Date Range** pill (`.range-display`) → date overlay opened with the
   `Make a Selection` / `Interval` / `Select Mode` toolbar + historical banner.
4. Read Interval default (`.interval-selector-container`) and Make-a-Selection default
   (`.range-auto-selector-container`).
5. Opened the Interval dropdown → captured the 4 interval options.
6. For each interval (Daily → Weekly → Monthly → Quarterly): selected it, opened the Auto-Select
   ("Make a Selection") dropdown, and enumerated its options via
   `.range-auto-selector-container .lfm-dropdown-options .lfm-option-label`.

---

## Captured data (verbatim from DOM)

**Interval dropdown options:** `Daily, Weekly, Monthly, Quarterly` (4, in order).

**Daily Auto-Select:** `Auto` / — / `Last 7 Days, Last 30 Days, Last 90 Days, Last 6 Months, Last 12 Months` / — / `Prior Year, Month to Date, Year to Date` / — / `Q2 2026 … Q2 2014` (49 quarters, newest→oldest) / — / `June 2026, May 2026, April 2026, March 2026, February 2026, January 2026, December 2025, November 2025, October 2025, September 2025, August 2025` (11 months).

**Weekly Auto-Select:** `Auto` / — / `Last Week, Last 4 Weeks, Last 12 Weeks, Last 36 Weeks, Last 52 Weeks`.

**Monthly Auto-Select:** `Auto` / — / `Last Month, Last 3 Months, Last 6 Months, Last 12 Months` / — / `Q2 2026 … Q2 2014` / — / `June 2026 … August 2025` (11 months).

**Quarterly Auto-Select:** `Auto` / — / `Q2 2026 … Q2 2014` (quarters only; no months, no relative entries).

Evidence: `.playwright-out/QA-134176/quarterly-autoselect.png`.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Default Interval = `Daily` | `Daily` | PASS |
| A2 | 3b | Default Make a Selection = `Auto` | `Auto` | PASS |
| A3 | 4 | Interval options = `Daily, Weekly, Monthly, Quarterly` | Exactly those 4, in order | PASS |
| A4 | 5 | Daily Auto-Select: Auto → (Last 7/30/90 Days, Last 6/12 Months) → (Prior Year, MTD, YTD) → quarters → months, newest→oldest, time-shifted | Structure exact; latest quarter Q2 2026, latest month June 2026; quarters→Q2 2014, months=11 (→Aug 2025) | PASS |
| A5 | 7 | Weekly Auto-Select: `Auto, Last Week, Last 4/12/36/52 Weeks` | Exact match (time-independent) | PASS |
| A6 | 9 | Monthly Auto-Select: Auto → (Last Month, Last 3/6/12 Months) → quarters → months; NO day-based ranges, NO Prior Year/MTD/YTD | Exact structure; regression-guard holds (no Last 7/30/90 Days, no Prior Year/MTD/YTD) | PASS |
| A7 | 11 | Quarterly Auto-Select: `Auto` + quarters only; NO months, NO relative entries | `Auto` + Q2 2026→Q2 2014 only | PASS |

### Notes on non-defect variances
- **Label casing:** UI renders `Month to Date` / `Year to Date`; spec writes `Month To Date` /
  `Year To Date`. Cosmetic (spec typo), not a defect.
- **Preset "latest period" = last COMPLETE period** (Q2 2026 / June 2026 as of Jul 12 2026), not the
  in-progress Q3 2026 / July 2026. Internally consistent across quarter + month lists; matches the
  spec's structural intent under the documented time-shift. Not a defect.
- **Spec quarter list is abbreviated** (11 of the ~49 shown). Full historical enumeration back to the
  Q2 2014 floor is expected/accepted behavior (consistent with prior PASS runs).

---

## Known bugs checked
- **bug-history.md (QA-134176):** Open bugs (0), Closed bugs (0). No linked defects.
- **Case Notes / linked bugs:** none open.
- **Brand>Insights renderer hang** (Chrome-MCP-era quirk, historically blocked QA-134176 under CDP):
  did **NOT** reproduce under Playwright MCP — the overlay + dropdowns rendered and responded within
  budget (consistent with the 2026-06-22 spike re-characterization: the "hang" was a
  missing-compare-date issue, not a perf hang). Navigated with full `from/to/compare_from/compare_to`.

## Bugs filed
None.
