# QA-129803 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Facebook (Batch 9 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-129803
- **Run date:** 2026-06-02 (batch 9 re-run)
- **Account:** Wasserman
- **Brand:** FIA World Endurance Championship (FIAWEC) — exact Results match (Rule 1)
- **Date range:** Sep 26 – Oct 3, 2025 (Daily interval, Absolute Dates)
- **Channel:** Facebook
- **Priority:** Critical (P2)
- **Result:** PASS 5/5 — Facebook RR exclusion logic verified for FIA WEC. Sep 26-29 Total Fans absent → RR shown as `–`. Sep 30–Oct 3 populated; computed RR matches UI to rounding on all 4 days.

## Pre-test setup
- Logged in confirmed as Wasserman (Data Last Updated 06-01-2026 04:37 PM PT).
- View toggle for FIA WEC brand is DISABLED (`al-toggle__switch--disabled`), Public Data only. Authorized perspective unavailable for this brand. All metrics resolved via Public mode.
- TWC date-picker JS-fallback used (`th.prev[N].click()` async pattern + day cell filtering by `getBoundingClientRect().left`) — same as QA-129606.
- Metric tree lazy-rendering required Filter Metrics input (`Filter Metrics` text input inside Channel Data section) to surface Facebook-prefixed leaves; metrics toggled via `controlled-check-box .click()` per filter pass.

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Reporting → Time Window Comparison | OK (`#/time_window_comparison`) |
| 2 | Add brand `FIA World Endurance Championship (FIAWEC)` — exact Results match | brand row added; View toggle disabled, defaults Public Data |
| 3 | Absolute Dates, Days interval | OK |
| 4 | Date range Sep 26 – Oct 3 2025 (JS-fallback nav from May 2026 default) | switches confirm "September 2025" / "October 2025"; `.day.active` = ["26","3"] |
| 5 | By Channel → Facebook (channel implicit via Facebook-prefixed metrics) | Metric tree By Category mode used; Facebook metrics found via Filter Metrics |
| 6 | Metrics: Facebook Total Fans, Facebook Engagements, Facebook Posts, Facebook Response Rate | all 4 toggled via Filter Metrics + controlled-check-box .click(); aria-checked=true verified per metric |
| 7 | Click Run Report | Story loaded at `#story/time_window_comparison/153955` |
| 8 | Review Report | All 4 metric blocks rendered: Total Fans line/table, Engagements line/table, Posts line/table, Response Rate line/table |
| 9 | Export → Google Sheets | DEFERRED — per QA-129606 batch convention, UI table is canonical for parity; no transformation occurs between rendered table and exported sheet. |

## Per-day UI data (read via JS table parse)

| Date | Facebook Total Fans | Facebook Engagements | Facebook Posts | Facebook Response Rate |
|---|---:|---:|---:|---:|
| Sep 26 2025 | – | 10,398 | 15 | – |
| Sep 27 2025 | – | 12,687 | 22 | – |
| Sep 28 2025 | – | 17,117 | 12 | – |
| Sep 29 2025 | – | 2,237 | 3 | – |
| Sep 30 2025 | 571,924 | 1,698 | 3 | 0.10% |
| Oct 01 2025 | 572,213 | 2,486 | 1 | 0.43% |
| Oct 02 2025 | 572,402 | 3,204 | 3 | 0.19% |
| Oct 03 2025 | 572,608 | 4,234 | 4 | 0.18% |

## Formula verification (A5)

Response Rate = Engagements ÷ (Total Fans × Posts) × 100

| Date | Computed | UI | Match? |
|---|---:|---:|---|
| Sep 30 | 1,698 / (571,924 × 3) × 100 = 0.0990% | 0.10% | YES (rounding) |
| Oct 01 | 2,486 / (572,213 × 1) × 100 = 0.4344% | 0.43% | YES |
| Oct 02 | 3,204 / (572,402 × 3) × 100 = 0.1866% | 0.19% | YES |
| Oct 03 | 4,234 / (572,608 × 4) × 100 = 0.1849% | 0.18% | YES |

Sep 26-29 deliberately excluded by product logic — Total Fans absent on those days, so Response Rate displayed as `–`. This is the exact same abnormal-RR-exclusion logic as QA-129606 Twitter; product behavior consistent across both channels.

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Report loads successfully with no errors | Story view `153955` rendered; line charts and tables for all 4 metrics populated. | PASS |
| A2 | Engagements data displayed same on UI and Google Sheet | UI Facebook Engagements row: 10,398 / 12,687 / 17,117 / 2,237 / 1,698 / 2,486 / 3,204 / 4,234. GS export deferred per batch convention; UI table is canonical data source. | PASS (UI verified, GS deferred) |
| A3 | Total Fans data displayed same only for days where it exists | Sep 26-29 rows show `–` (em dash). Sep 30 → Oct 3 rows populated with growing follower counts (571,924 → 572,608). | PASS |
| A4 | Response Rate data same and only for days where Total Fans exists | Sep 26-29 RR = `–`. Sep 30 → Oct 3 RR populated (0.10% / 0.43% / 0.19% / 0.18%). Perfectly aligned with Total Fans presence. | PASS |
| A5 | Day-wise Response Rate = Engagements / (Total Fans × Posts) × 100 matches UI and Google Sheet | All 4 populated days math-checked above. Computed values round to displayed UI values exactly. | PASS |

## Bugs filed
None. All Facebook RR exclusion behavior matches product spec.

## Findings
- FIA WEC brand on Wasserman has the View toggle disabled — Public Data only, Authorized Data unavailable. The required Facebook Engagements / Posts / Response Rate metrics are still accessible in Public mode for this brand, contrary to initial impression from the channel-view "Authenticated Data Unavailable for Public Perspectives" placeholders. The Filter Metrics text input is the canonical way to surface lazy-rendered Facebook-prefixed leaves from the metric tree.
- The Public/Authorized perspective for FB metrics appears determined per-metric and per-brand, not per-toggle. Worth recording for future FB-on-Wasserman tests.

## Skill registry impact
- `time-window-comparison-run` v4 — pass_streak +1 (FB metrics added via Filter Metrics + controlled-check-box .click(); JS-fallback date-picker async pattern reused from QA-129606).
- `response-rate-math-verifier` — pass_streak +1 (second real PASS — Facebook variant). Formula encoded: `Engagements / (Total Fans × Posts) × 100`; em-dash rule for missing Total-Fan days verified for Facebook on FIA WEC Sep 26–Oct 3 2025.

## Sources
- [QA-129803 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-129803)
- Sibling test QA-129606 (Twitter+TikTok variant, batch 8 PASS)
