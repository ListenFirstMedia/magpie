---
name: time-window-comparison-run
version: 4
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 4
preconditions: [user-logged-in, account-set]
postconditions: [report-built]
inputs: [brand_name, perspective, data_points, date_range_type, start_date, end_date, keydate_season, keydate_episode]
outputs: [report_url, report_brand_display_name, report_date_range_text, report_keydate]
related_pages: ["/#time_window_comparison", "/#story/time_window_comparison/{report_id}"]
related_skills: [keydate-picker]
---

# Run a Time Window Comparison report

End-to-end: open the TWC builder, add a brand, pick metrics, optionally choose date range type, run the report.

## Steps

### Step 1 — Open Reporting → Time Window Comparison

The Reporting menu in the top nav opens on **hover**, not click. Clicking the label is unreliable — on some browser builds it just toggles closed.

- **Action sequence:**
  1. `hover` over the "Reporting" label in the top navigation
  2. wait ~1s for the dropdown to appear
  3. `left_click` on the "Time Window Comparison" link
- **Targets:**
  - Reporting menu trigger: find with "Reporting dropdown menu in top navigation"
  - Time Window Comparison link: find with "Time Window Comparison menu item in Reporting dropdown"
- **Assertion:** URL transitions to `https://app-reporting.lfmdev.in/#/time_window_comparison`. Page header reads `Account: <name> | Reporting > Time Window Comparison`.

### Step 2 — Verify default state
- **Assertions:**
  - "Absolute Dates" tab is selected by default (toggle has dark background)
  - Default date range is "last 7 days ending yesterday" populated as a range in both Start and End calendars. **The default range shifts forward each day** — a run today and a run tomorrow will see different default ranges. Capture the rendered range from the page (`Time Window Comparison (<begin> - <end>)` text in the built report) rather than hardcoding.

### Step 3 (optional) — Change to Relative Dates

Only if `date_range_type == "relative"`. Click the `Relative Dates` tab.

When Relative Dates is selected:
- The calendar grid is replaced by `Key Date Label` (text), `Start` (number), `Days`, `Before|After`, `Event` row, and an `End` row in the same shape.
- The Brands table grows a **`Key Date` column** with a red-bordered `Select Key Date` button on every row, plus a `Bulk Select Key Date` button at the bottom for multi-brand selection.
- The interval cap shown in the banner is `4,564 days or less`.

Set the `Start` and `End` numeric inputs by `ref` and `form_input`:

```python
form_input(ref=<Start_ref>, value=<start_int>)  # e.g., 3 (days)
form_input(ref=<End_ref>, value=<end_int>)      # e.g., 1 (days)
```

The `Before|After` direction dropdowns default to `Before` for Start and `After` for End — the common case for an "around the keydate" window. If the case requires otherwise, click the dropdown and pick the other direction.

Set the keydate per brand using the [`keydate-picker`](../keydate-picker/SKILL.md) skill **after step 5** (brand selection) — the picker only exists once a brand row is in place.

### Step 4 — Add brand by name
- **Action:** locate the `Search for a Brand` textbox in the "Add Brand By Name" section (NOT the same as Account search in the profile dropdown).
- **CRITICAL — React onChange quirk:** Using the Chrome MCP `type` action alone is insufficient. The typeahead is React-controlled and requires a dispatched `InputEvent`. Use the following pattern:

```javascript
const input = document.querySelector('input.al-typeahead__text-input');
const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
setter.call(input, '<brand_name>');
input.dispatchEvent(new Event('input', { bubbles: true }));
input.focus();
```

  Alternative: click the field, type, then explicitly dispatch the input event via `javascript_tool`.
- **Assertion:** A dropdown of matching brand options appears within 2s.

### Step 5 — Select the brand
- **Action:** click the brand row matching exactly the desired entity.
- **CRITICAL — "Recent Searches" vs "Results":** the typeahead may show a "Recent Searches" section above the live "Results". **Clicking an item in the Recent Searches section does NOT add a brand row** — it appears to be display-only. Always pick from the `Results` section. The DOM marker is a `Results` heading sibling above the live options.
- Concretely: locate the bare `Hulu` (or your brand) entry whose containing list is under the `Results` heading, not the `Recent Searches` heading.
- **Assertion:** A row appears in the "Brands" list with columns `Primary | Brand Name | Remove`. The selected brand's row shows the brand name, plus a per-brand `View: Public Data | Authorized Data` toggle.

### Step 6 (optional) — Set perspective
- **Default:** toggle is in the LEFT position (`Public Data` selected). DOM check:
  - `document.getElementById('<rowIdx>-perspective-toggle').checked === false` → Public Data
  - `checked === true` → Authorized Data
- If the test requires `Public Data`, no action needed unless the toggle is in the right position. If `Authorized Data`, click the toggle.

### Step 7 — Pick data points
- **Action:** scroll down to the "Select Channel Data" panel. Click the checkbox next to the desired metric. For QA-5757 this is `Facebook New Fans` under Audience & Growth → Fan Growth.
- **Assertion:** The counter in the category header increments (e.g., `Audience & Growth ( 1 / 36 )` after one selection).

### Step 8 — Run report
- **Action:** scroll to bottom; verify three indicators are green: `Brands ✓ · Dates ✓ · Data ✓`. Click the yellow `Run Report` button.
- **Assertion (during):** a "Building Your Story" interstitial briefly appears.
- **Assertion (after):** URL changes to `/#story/time_window_comparison/<numeric_id>`. Page shows a brand panel with `Type` and `Manufacturer`, plus a line chart and a data table for the chosen metric. Header shows `Time Window Comparison (<begin_date> - <end_date>)`.

## Data freshness — em-dash rows

The data table for a metric may show `–` (an em dash) for any date past the "Data Last Updated" timestamp. This is **normal data freshness behavior**, not a bug, and should not fail an assertion unless the case specifically tests that all dates in range have data. The current `Data Last Updated (PT)` value is shown in the Home page header and reflects the most recent ETL run.

When comparing exports against the in-app table, treat `–` as "missing value": the corresponding CSV / Google Sheet cell may be empty, `"–"`, `"-"`, or `null` — record what the export actually produces in the run's `results.json` and add a quirk if it varies.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Reporting menu doesn't open on hover | STALE SKILL (interaction model changed) | flag |
| Reporting → Time Window Comparison link missing | STALE SKILL (nav redesign) | flag |
| Brand autocomplete shows no results for an exact-name query | STALE CANDIDATE or test-data drift (brand renamed/removed) | flag with the actual results shown |
| Clicking a brand from Recent Searches doesn't add a brand row | NOT A BUG (covered above) | ensure click target is from Results |
| `Run Report` is greyed out even with Brands/Dates/Data shown | BUG (validation logic broken) | report with all selected state captured |
| "Building Your Story" stays >30s | PERF/BUG | report; check `/api/.../build` or similar for status |
| Built report renders without the selected metric | BUG | report with both UI and the underlying API response |
| Built report has `–` in cells | NOT A BUG (data freshness) | record per `Data freshness` section above |

## Known quirks

- The yellow Run Report button has no stable `data-testid`. Locate by visible text "Run Report" and color contrast as the brightest CTA on the page.
- The View toggle for Public Data / Authorized Data is per-brand, not global — the global "Use Authorized Data (Where Available)" green pill at the bottom of the brands list is a separate setting that does not override per-brand choice.

## Aggregate interval mode

When the test specifies `Interval = Aggregate`:

- The Interval dropdown options are `Days, Weeks, Months, Quarters, Years, Aggregate`. `Aggregate` is the last option.
- Switching to Aggregate collapses the per-day time series into a single value per brand per metric — the chart renders **3 bars** (one per brand) instead of a line chart per metric over time.
- The chart axis labels are the brand names (MTV, Star Wars, HBO Max …), not dates.

## Cohort Average / Competitor Average as overlay lines

Two Options-section checkboxes under General add horizontal reference lines to the bar chart:

- **Show Cohort Average** — draws a **solid horizontal line** across the chart at the cohort's average value. Label `Cohort Average` appears at the right edge of the line. Default cohort label is `"Cohort Average"` (editable via the Cohort Average Label textbox that appears below the checkbox).
- **Show Competitor Average** — draws a **dotted/dashed horizontal line** across the chart. Label `Competitor Average` appears at the right edge.

Both lines are SVG line elements drawn on top of the bar chart, NOT additional bars. Hovering over the label area reveals a tooltip with the literal value (e.g., `Cohort Average: 45275`, `Competitor Average: 70990`).

### Assertion patterns for line-vs-bar tests

- **A "as a line" assertion** can be verified by checking that the corresponding element is a path/line with stroke and NO width matching a bar (`<rect>`). Or, behaviorally, the legend swatch shows a horizontal-line pattern (solid for Cohort, dashed for Competitor) rather than a filled-square swatch.
- **A "tooltip with value" assertion** is verified by hovering near the right-edge label and reading the resulting tooltip text. The tooltip format is consistent: `<Label>: <numericValue>` with no thousands separators.

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-31961 (Major) — Reporting > TWC > New Followers > The data is not displayed correctly.     [from QA-281]

## Changelog
- **v4** (2026-05-13): Added Aggregate interval semantics and Cohort/Competitor Average overlay-line behavior + assertion patterns (from QA-126530 run).
- **v3** (2026-05-13): Added Relative Dates flow (Start/End numbers, Before/After direction, Key Date column on brand rows, Bulk Select Key Date for multi-brand). Linked to new `keydate-picker` skill. Documented the Filter Metrics → category-level `On` button shortcut for enabling many metrics at once (subcategories need their own `On` clicks; deeply nested metrics may require expanding the tree first).
- **v2** (2026-05-13): Added hover-not-click for Reporting menu; "Recent Searches" caveat in brand picker; em-dash data freshness behavior; default date range shifts daily.
- **v1** (2026-05-13): Initial draft from QA-5757 exploration run. Successful build of TWC report for Hulu / Public Data / 2026-05-05 → 2026-05-11 / Facebook New Fans.
