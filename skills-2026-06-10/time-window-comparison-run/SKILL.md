---
name: time-window-comparison-run
version: 5
last_verified: 2026-06-10
last_passed_run: 2026-06-10
trust: untrusted
pass_streak: 6
preconditions: [user-logged-in, account-set]
postconditions: [report-built]
inputs: [brand_name, perspective, data_points, date_range_type, start_date, end_date, keydate_season, keydate_episode]
outputs: [report_url, report_brand_display_name, report_date_range_text, report_keydate]
related_pages: ["/#time_window_comparison", "/#story/time_window_comparison/{report_id}"]
related_skills: [keydate-picker, csv-export-capture]
---

# Run a Time Window Comparison report

End-to-end: open the TWC builder, add brand(s), pick metrics, set options, run.

## Steps

### Step 1 — Open the builder
- Direct URL `https://app-reporting.lfmdev.in/#/time_window_comparison` works and is faster than hover-nav.
- Reporting top-nav menu opens on **hover**, not click, if navigating by UI.

### Step 2 — Default state
- "Absolute Dates" tab selected (dark background). Relative-dates banner reads **"4,565 days or less"** (v5 correction: was documented as 4,564).

### Step 3 — Relative Dates (if needed)
- Click `Relative Dates` tab. Brands table gains `Key Date` column + `Bulk Select Key Date`.
- Set Start/End numeric inputs via React setter + `input`/`change`/`blur` events (find inputs by walking from the `Start`/`End` labels).
- Keydate picker: click red `Select Key Date` → `Auto-Select:` dropdown → Season N → second `Auto-Select:` dropdown → Episode N. (TWD S9E16 resolves to Mar 31, 2019.)

### Step 4/5 — Add brand
- Typeahead requires React setter on `input.al-typeahead__text-input` + dispatch `input` event.
- Click options via `.al-typeahead__option` whose exact trimmed text matches; **pick from Results, never Recent Searches**. Options may take 3-5 s to render — retry once.

### Step 6 — Perspective
- Per-row toggle id `'{rowIdx}-perspective-toggle'`; `checked===true` → Authorized. Toggle by clicking its label/element.

### Step 7 — Metric tree interactions (v5,重要)
- Categories/subcategories are `<details>` elements; expand by clicking their `summary` (setting `.open=true` shows the node but children only render after a real `summary` click).
- Leaf checkboxes: click `span.controlled-check-box > label` for the metric's exact name. `input[type=checkbox]` state is visible afterwards; tree counts update e.g. `Instagram ( 4 / 99 )`.
- Coordinate clicks on tree checkboxes are unreliable — always use the label-click pattern.
- Filter Metrics box: set via React setter (find input whose grandparent text contains "Filter Metrics").
- **By Category / By Channel** toggle buttons: click element with exact text.
- Category-level `On` links select all *available* filtered metrics (greyed/unavailable ones stay off).

### Step 8 — Options section (v5)
- Options checkboxes are also `span.controlled-check-box > label` (Show Metrics Graphs, Show Metrics Tables, Set Brands as Rows, Show Change, Show Share, Show Cohort Average, Show Competitor Average, Show Dates Table, Show Metrics, …).
- **Verify the checkbox took effect before Run** — a click on the bare span can silently no-op. If the built report lacks the option, use Change Settings → label click → Run again.

### Step 9 — Run Report
- `document.querySelectorAll('button')` text === 'Run Report', click when enabled. "Building Your Story" interstitial → `/#story/time_window_comparison/<id>`.
- **Transient (3 occurrences across runs):** story page can sit on "Loading…" >30 s — one `location.reload()` recovers. Log occurrences.

## Cohort / Competitor Average (QA-126530 verified)
- With Aggregate interval + multiple brands: Cohort Average renders as **solid horizontal line**, Competitor Average as **dashed line**, labels at right edge; hovering the label shows tooltip `<Label>: <value>` (e.g. `Cohort Average: 6,871`). Neither adds bars (rect count unchanged).
- Legend gains swatches: solid square for Cohort, dotted for Competitor.
- Cosmetic: with averages enabled, channel section header icons may render as empty squares on the story page.

## Interval dropdown (v5)
- Custom dropdown: `.interval__dropdown .lfm-dropdown-select-box` to open, `.lfm-dropdown-option` to choose. Options: Days, Weeks, Months, Quarters, Years, Aggregate. Native `<select>` does not exist.

## Show Metrics + CSV export (QA-111132 verified)
- With `Show Metrics` checked, the CSV export appends a `"Display Name","Key"` section listing each metric's key (e.g. `instagram.page_insight.views_authorized`).
- The `Data Last Updated` timestamp is NOT included in the CSV (expected).
- CSV columns: Perspective, Brand, Date, then one column per metric; em-dash days export as empty strings.
- Capture CSVs in-page with the csv-export-capture technique (hook URL.createObjectURL + anchor click).

## Google Sheets export
- See export-google-sheets skill. v5 note: observed a full hang (>90 s, no window.open) on 2026-06-10 — treat >30 s spinner as a bug.

## Data freshness
- `–` cells for dates past "Data Last Updated" are normal. Timestamps can differ between app.lfmdev.in and app-reporting.lfmdev.in (caching) — note but don't fail.

## Changelog
- **v5** (2026-06-10): details/summary expansion semantics; controlled-check-box label-click pattern; custom interval dropdown selectors; 4,565-day banner; options-silently-not-applying caveat; Show Metrics CSV section; loading-stuck transient; keydate Season/Episode two-stage dropdown.
- **v4** (2026-05-13): Aggregate semantics; Cohort/Competitor overlay lines.
- **v3/v2/v1**: see prior history.
