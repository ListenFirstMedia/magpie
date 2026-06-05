---
name: brand-insights-interval-picker
version: 2
last_verified: 2026-05-29
last_passed_run: 2026-05-29
trust: untrusted
pass_streak: 4
preconditions: [brand-insights-page-loaded]
postconditions: [interval-options-verified, historical-limits-enforced]
inputs: []
outputs: [interval_options, default_interval, historical_lower_bound]
related_pages: ["/#explore/brand/insights"]
---

# Brand > Insights — Date Range / Interval Picker

The Date Range overlay on Brand → Insights has two interactive controls beyond the calendars:
- **Interval** dropdown — default `Daily`, options: `Daily, Weekly, Monthly, Quarterly`.
- **Make a Selection** dropdown — default `Auto`, options vary by date range.

This skill documents both controls, the historical-limit enforcement (end-side `»` arrow suppression at current month/quarter; immediate-month/year arrow nav), and the partial-month X-axis extension rule (APPS-58615).

Used by:
- **QA-134174** — Verify Interval Date Selection Options (v1 baseline).
- **QA-134182** (v2) — Interval Date selector enforces historical date limits across Daily / Weekly / Quarterly / Monthly. End-side `»` never appears when at current month/quarter; partial Monthly ranges X-axis-extend to full months.
- **QA-134184** (v2) — Interval = Quarterly: arrow nav uses year granularity; Q1 2026 is the last selectable quarter (Q2 2026 disabled because current quarter not yet complete on 2026-05-29).
- **QA-134188** (v2) — Verify Monthly Interval export — partial-month rule confirmed end-to-end with the X-axis labels rounded to full months.

## Steps

### Step 1 — Open the date overlay
- **Action:** click the Date Range pill (e.g. `May. 11, 2026 - May. 17, 2026`).
- **Assertion:** an overlay opens with two side-by-side calendars (Start Date, End Date) and three controls at the top:
  - `Make a Selection:` dropdown
  - `Interval:` dropdown
  - "Historical data is available back to MMM. DD, YYYY" info banner

### Step 2 — Verify Interval default
- **Selector:** the `Interval` dropdown.
- **Assertion:** default-selected value is exactly `Daily` (string match).

### Step 3 — Open the Interval dropdown
- **Action:** click the `Interval` dropdown.
- **Assertion:** dropdown opens with exactly 4 options in this order:
  1. `Daily`
  2. `Weekly`
  3. `Monthly`
  4. `Quarterly`
- **No** `Aggregate`, no `Days/Weeks/Months/Quarters/Years` options. Those belong to TWC / Data Studio.

### Step 4 — Verify Make a Selection default
- **Selector:** the `Make a Selection` dropdown.
- **Assertion:** default-selected value is exactly `Auto`.

### Step 5 — Cross-tab assertion (negative test)
After observing the Brand > Insights interval picker, navigate to TWC or Data Studio. The Date Range overlay there should use **different** interval terms (`Days`, `Weeks`, `Months`, `Quarters`, `Years`, `Aggregate`) — NOT `Daily/Weekly/Monthly/Quarterly`.

This negative assertion catches regressions where the interval taxonomies bleed between pages.

## Why two taxonomies?

Brand > Insights aggregates pre-computed daily data, so its interval is "how to roll up" → `Daily/Weekly/Monthly/Quarterly` (granularity-of-display).

TWC / Data Studio build queries from scratch, so their interval is "what's the time bucket of each datapoint" → `Days/Weeks/...` (granularity-of-bucket) + `Aggregate` (collapse all buckets into one).

## Step 6 — Historical limit: end-side `»` never appears at "now"

- **Action:** Open the date overlay (any interval). Inspect the right calendar header.
- **Assertion:** the `»` (next-month or next-year) arrow on the End side is absent whenever the current calendar shows the current month (Daily/Weekly/Monthly) or the current year (Quarterly). The `«` (previous) arrow is always present.
- **Verified for:** Daily, Weekly, Monthly, Quarterly.

## Step 7 — Arrow navigation granularity per interval

- **Daily / Weekly / Monthly:** `»` and `«` on either calendar advance/retreat by **one month** per click.
- **Quarterly:** `»` and `«` advance/retreat by **one year** per click (the picker shows quarters within a year; navigation between years is the natural granularity).
- **Verified for:** all four intervals in QA-134182.

## Step 8 — Historical lower bounds

The "Historical data is available back to <date>" banner at the top of the overlay shows the system's true historical floor:

| Interval | Lower bound (observed 2026-05-29) |
|----------|------------------------------------|
| Daily / Weekly / Monthly | `Nov. 27, 2013` |
| Quarterly | `Jan. 01, 2014` |

The Make-a-Selection dropdown caps relative ranges at `Last 12 Months`; this is the *relative-range* cap, NOT the historical floor.

## Step 9 — Partial-month X-axis extension rule (APPS-58615)

When Interval = `Monthly` and the user selects a range that doesn't align with month boundaries (e.g., Sep 15 → Dec 15):

- The URL still applies the user-picked dates.
- The chart **rounds the range up to whole months** (Sep 1 → Dec 31) and the X-axis labels show every full month touched: `Sep, Oct, Nov, Dec`.
- This applies symmetrically — both the partial start month and the partial end month are kept (not dropped) in the X-axis labels.
- Confirmed by Philip on Atlassian ticket **APPS-58615**.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Default interval not `Daily` | Spec violation OR user-saved preference leaked | Check whether brand has a saved default; otherwise file bug |
| Interval dropdown missing one of the 4 options | Regression | File bug with screenshot |
| Interval dropdown has extra options (`Yearly`, `Aggregate`, etc.) | Taxonomy bleed from TWC/DS | File bug |
| `Make a Selection` default ≠ `Auto` | Possible user-saved preference; verify with fresh-session test |
| End-side `»` arrow visible when at current month/quarter | Regression on historical-limit guard | File bug |
| Quarterly arrows advance by month instead of year | Granularity bug | File bug |
| Monthly partial range drops the partial start or end month from X-axis | Regression of APPS-58615 fix | File bug, reference APPS-58615 |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v1** (2026-05-18): Initial draft from QA-134174 (Sony Pictures / Spider-Man: Across the Spider-Verse). All 4 options + Daily default + Auto default verified.
- **v2** (2026-05-29): +3 separate-day verifications (QA-134182, QA-134184, QA-134188 on Adam Orfei / MTV). Added Steps 6-9: end-side `»` suppression, Daily/Weekly/Monthly per-month arrow nav, Quarterly per-year arrow nav, historical lower bounds (Daily/Weekly/Monthly = Nov 27 2013; Quarterly = Jan 01 2014), and the APPS-58615 partial-month X-axis extension rule.
