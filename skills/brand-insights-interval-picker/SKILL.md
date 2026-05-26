---
name: brand-insights-interval-picker
version: 1
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 1
preconditions: [brand-insights-page-loaded]
postconditions: [interval-options-verified]
inputs: []
outputs: [interval_options, default_interval]
related_pages: ["/#explore/brand/insights"]
---

# Brand > Insights — Date Range / Interval Picker

The Date Range overlay on Brand → Insights has two interactive controls beyond the calendars:
- **Interval** dropdown — default `Daily`, options: `Daily, Weekly, Monthly, Quarterly`.
- **Make a Selection** dropdown — default `Auto`, options vary by date range.

This skill documents both controls and the exact spec for what should appear.

Used by:
- **QA-134174** — Verify Interval Date Selection Options.

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

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Default interval not `Daily` | Spec violation OR user-saved preference leaked | Check whether brand has a saved default; otherwise file bug |
| Interval dropdown missing one of the 4 options | Regression | File bug with screenshot |
| Interval dropdown has extra options (`Yearly`, `Aggregate`, etc.) | Taxonomy bleed from TWC/DS | File bug |
| `Make a Selection` default ≠ `Auto` | Possible user-saved preference; verify with fresh-session test |

## Changelog
- **v1** (2026-05-18): Initial draft from QA-134174 (Sony Pictures / Spider-Man: Across the Spider-Verse). All 4 options + Daily default + Auto default verified.
