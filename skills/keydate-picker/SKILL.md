---
name: keydate-picker
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [twc-builder-open, relative-dates-selected, brand-row-present]
postconditions: [keydate-set-on-brand-row]
inputs: [season_label, episode_label]
outputs: [resolved_calendar_date]
related_pages: ["/#/time_window_comparison"]
---

# Pick a Key Date on a brand row (TWC Relative Dates)

When the TWC builder is in **Relative Dates** mode, each brand row in the Brands table gets a `Key Date` column with a red-bordered `Select Key Date` button. Clicking it opens a chained Season → Episode picker plus a fallback calendar. This skill drives that picker.

## Preconditions

- The TWC builder is open (`https://app-reporting.lfmdev.in/#/time_window_comparison`).
- The Date Range tab is **Relative Dates** (the Key Date column only appears in Relative mode).
- A brand has been added to the Brands table (otherwise there's nothing to attach a keydate to).

## Steps

### Step 1 — Open the keydate picker
- **Action:** click the `Select Key Date` button on the target brand row.
- **Target (primary):** find with "Select Key Date button on <brand_name> brand row"
- **Visual cue:** the button has a **red border** when no keydate is set; that's how to tell the field is required.
- **Assertion:** a popover opens beneath the brand row containing an `Auto-Select:` dropdown plus a calendar view.

### Step 2 — Select the Season

The popover starts with one `Auto-Select:` dropdown. After clicking it, a list appears with `Auto-Select:` (reset) plus `Season N` entries for every season the brand has.

- **Action:** click the `Auto-Select:` dropdown trigger → click `Season {season_label}` (e.g., `Season 9`).
- **Target (primary):** find with "Auto-Select dropdown in keydate picker" then "Season {N} option in Auto-Select dropdown".
- **Assertion:** after selection, the dropdown trigger now shows `Season {N}`, AND a SECOND `Auto-Select:` dropdown appears to the right (with an arrow `→` connector between them) for episode selection.

### Step 3 — Select the Episode

- **Action:** click the **second** `Auto-Select:` dropdown trigger → click `Episode {episode_label}` (e.g., `Episode 16`).
- **Target (primary):** find with "second Auto-Select dropdown (below Season N, for choosing episode)" then "Episode {N} option in episode dropdown".
- **Assertion (final):** the popover closes AND the brand row's `Key Date` cell now displays a resolved calendar date (e.g., `Mar 31, 2019` for The Walking Dead S9E16).

### Step 4 — Capture the resolved date

The displayed calendar date is the **anchor** for the report's Relative Dates math. Capture it so the report can report the actual window:

```javascript
const cell = document.querySelector('table tr td [class*=key-date], table tr td input[type=date], table tr td');
// Or simpler: find the brand's row and read the visible date text
```

Save as `resolved_calendar_date` in the case's results.json so prod-vs-dev compares can ensure both sides used the same anchor.

## Bulk select (multi-brand reports)

When the Brands table has more than one row, a `Bulk Select Key Date` button appears at the bottom of the brands section. It applies the same Season/Episode pick to every brand row in a single action. Not exercised by QA-458 (single brand), so not yet documented here — flag for a future skill update if a multi-brand test case touches it.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `Select Key Date` button missing on the brand row | STALE SKILL — confirm Date Range tab is Relative | flag |
| `Select Key Date` button present but click does nothing | BUG (handler regressed) | report |
| Auto-Select dropdown opens but has no Season entries | DATA — this brand has no seasons | report; suggest a different brand for the test |
| Season picks but Episode dropdown doesn't appear | BUG (chained-dropdown regression) | report with screenshot |
| Episode selected but Key Date cell stays empty / still red | BUG | report; capture the network requests around the click |
| Wrong calendar date renders after the pick | BUG (Season/Episode→date mapping broken) | report with the expected date |

## Network expectations

When picking a keydate, the LFM frontend probably hits a `/api/.../seasons/{seasonId}/episodes/{episodeId}` style endpoint to resolve the calendar date. **TODO:** capture the actual endpoint pattern next time this skill runs so we can populate `_shared/network-patterns.md`.

## Known quirks

- The chained Auto-Select uses the same `Auto-Select:` placeholder label for both Season and Episode triggers — locate them by ORDER (first / second on the page) or by their relative DOM position to the `→` arrow.
- Greyed-out seasons/episodes mean no data is available — the test should pick a season/episode the brand actually has.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-458 exploration run. Successful Season 9 Episode 16 selection for The Walking Dead → resolved to Mar 31, 2019.
