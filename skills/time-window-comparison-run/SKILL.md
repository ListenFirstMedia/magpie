---
name: time-window-comparison-run
version: 6
last_verified: 2026-06-22
last_passed_run: 2026-06-22
trust: untrusted
pass_streak: 18
preconditions: [user-logged-in, account-set]
postconditions: [report-built]
inputs: [brand_name, perspective, data_points, date_range_type, start_date, end_date, keydate_season, keydate_episode]
outputs: [report_url, report_brand_display_name, report_date_range_text, report_keydate]
related_pages: ["/#time_window_comparison", "/#story/time_window_comparison/{report_id}"]
related_skills: [keydate-picker]
---

# Run a Time Window Comparison report

End-to-end: open the TWC builder, add a brand, pick metrics, optionally choose date range type, run the report.

## Playwright MCP notes (verified 2026-06-22, QA-198, Disney Ad Sales)

Under **Playwright MCP**, several Chrome-MCP workarounds in this skill are **obsolete**:

- **Brand picker (Step 4):** Playwright real keystrokes trigger the React typeahead — type with
  `browser_type` (`pressSequentially`) and the dropdown populates. The
  `Object.getOwnPropertyDescriptor(...).set` + `dispatchEvent` workaround is **not needed**.
  Caveat: `slowly:true` typing **appends**; clear the field with an empty `fill('')` before each new
  brand. Pick the exact match from **Results**. **Exact-text gotcha:** "Fox News" renders as
  **"FOX News"** (uppercase) — match case-insensitively.
- **Metric checkboxes (Step 7) & Options checkboxes:** the `.controlled-check-box` widget responds to
  a **trusted `browser_click`** on `.controlled-check-box__label` — the v5 `focus()`+Space-dispatch
  workaround is **not needed** under Playwright.
- **Custom widgets aren't in the accessibility tree.** Brand options, metric checkboxes, and the
  Run/Export buttons don't appear in `browser_snapshot`. Locate by text/class in `browser_evaluate`,
  tag with `el.setAttribute('data-spk', …)`, then `browser_click('[data-spk=…]')`.
- **Exports → see "Exporting the report" below.** CSV/TSV/XLS download to disk synchronously.

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

### Step 9 — Export (QA-198 etc.)

On the built report, the **Export** control (`div.export-btn-container.lfm-button-dropdown` /
`button.cta-wrapper.call-to-action-button.export`) opens a dropdown of `.lfm-option-label` items:
**Google Sheets · CSV · TSV · XLS**.

- **Download-to-disk works under Playwright MCP (synchronous).** Clicking a format option fires a
  Playwright `download` event; the file is saved to the configured `--output-dir`
  (`.playwright-out/`). No async queue / notification-bell / signed-CDN anchor (unlike Content/Paid
  CSV). No `URL.createObjectURL`/anchor-click hook needed.
- **Flow per format:** click Export → tag the format label → `browser_click` it → the download event
  reports the saved path. The dropdown closes after each pick, so re-click Export for the next
  format. Filenames are slugified: `<Brand> - Time Window Comparison - <begin> - <end>.<ext>`
  (XLS saves as `.xlsx`).
- **Verifying on disk:** CSV header = `Perspective, Brand, Date, <metric…>`; one row per brand×day.
  TSV is byte-identical data to CSV (tab-delimited). XLS carries the same header/rows/values. Rate
  metrics serialize as a raw float (e.g. `0.000104…`), not a `%` string. Em-dash days appear as
  empty/absent cells. **Google Sheets is out of scope** for headless runs (Google 2FA on a separate
  auth surface) — skip A10-style GS assertions.

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

## v5 — × ÷ operators + controlled-check-box workaround + th.prev JS-fallback

### × ÷ operators in custom-metric column (QA-137558)

Custom metrics created with the new APPS-60358 × and ÷ operators (per `settings-custom-metrics` v2) render correctly as TWC table columns. The calc engine evaluates the formula at query time.

**TWC-side flow:**
1. Add brand → set perspective → date range.
2. In Filter Metrics search input (`input.corner-box.controlled-text-input` inside `.al-data-selection__filter`), type the custom metric name (e.g. `Automation - All Operators Metric`).
3. The custom metric appears under a `Custom Metrics` section in the picker — click the `label.controlled-check-box__label` matching exact text.
4. Run Report.
5. Results table column header matches the custom-metric name verbatim; cell value is the calculated numeric.

### `controlled-check-box` focus + Space-dispatch (CARRY FROM CPR builder)

> **Superseded under Playwright MCP (2026-06-22):** a trusted `browser_click` on
> `.controlled-check-box__label` flips and persists `aria-checked` — the focus+Space dispatch below
> is a Chrome-MCP-only workaround. Kept for history / Chrome-MCP fallback.

The TWC Options panel uses the same `controlled-check-box` React widget as CPR (see `cpr-builder` skill). For Options like `Show Cohort Average`, `Show Competitor Average`, `Show Source Links`:

```javascript
const cb = [...document.querySelectorAll('i[role="checkbox"]')]
  .find(el => /<option text>/i.test(el.closest('label, .controlled-check-box')?.textContent || ''));
cb.focus();
cb.dispatchEvent(new KeyboardEvent('keydown', {bubbles:true, key:' ', code:'Space'}));
cb.dispatchEvent(new KeyboardEvent('keyup',   {bubbles:true, key:' ', code:'Space'}));
```

**Assertion:** `aria-checked` flips to `true`. Use this pattern for any Options checkbox; coordinate clicks land on the wrapper not the toggle.

### `th.prev/th.next` JS-fallback for date-picker arrows

The Absolute Dates calendar exposes its `previous month` / `next month` arrows as `<th class="prev">` / `<th class="next">` cells. The clickable hitboxes are tiny and can miss coordinate-based clicks. Multi-month navigation (e.g., June 2026 → Sep 2025) needs many clicks in succession.

**JS-fallback for `N` month-back navigations:**
```javascript
const prev = document.querySelector('th.prev');
for (let i = 0; i < N; i++) {
  prev.click();
  await new Promise(r => setTimeout(r, 150));
}
```

The `setTimeout(150)` is required between clicks — the React re-render needs time to re-bind the `prev` reference. Without the wait, only the first click registers.

This pattern is confirmed required for:
- QA-129606 batch 8 (Absolute Days Sep 26 – Oct 3 2025 multi-month nav).
- QA-129803 batch 9 (Facebook variant of same flow).
- QA-198 / QA-281 (Relative Dates long intervals — still need calendar nav for the Key Date picker via `keydate-picker` skill).

## Additional Failure signatures (v5)

| Signature | Interpretation | Action |
|---|---|---|
| Custom metric column renders blank in results table | Calc engine couldn't evaluate the formula (e.g., division by zero day) | Inspect formula chips + brand context |
| Options checkbox doesn't flip on coordinate click | `controlled-check-box` quirk | Use focus + Space-dispatch |
| Calendar nav `th.prev.click()` stalls after first click | React handler re-binding lag | Add `await setTimeout(150)` between clicks |

## Changelog
- **v6** (2026-06-22): Playwright MCP validation (QA-198, Disney Ad Sales, 4 brands / 3 datapoints).
  Added "Playwright MCP notes" + Step 9 (Export). Confirmed obsolete-under-Playwright: brand-picker
  React dispatch workaround (real keystrokes work) and `controlled-check-box` focus+Space (trusted
  click works). Documented synchronous CSV/TSV/XLS download-to-disk to `--output-dir`, and the
  "FOX News" uppercase exact-text gotcha. GS out of scope.
- **v5** (2026-06-08): × ÷ operators in custom-metric columns (QA-137558); `controlled-check-box` focus+Space workaround for Options panel (overdue documentation); `th.prev/th.next` JS-fallback with `setTimeout(150)` for multi-month calendar nav.
- **v4** (2026-05-13): Added Aggregate interval semantics and Cohort/Competitor Average overlay-line behavior + assertion patterns (from QA-126530 run).
- **v3** (2026-05-13): Added Relative Dates flow (Start/End numbers, Before/After direction, Key Date column on brand rows, Bulk Select Key Date for multi-brand). Linked to new `keydate-picker` skill. Documented the Filter Metrics → category-level `On` button shortcut for enabling many metrics at once (subcategories need their own `On` clicks; deeply nested metrics may require expanding the tree first).
- **v2** (2026-05-13): Added hover-not-click for Reporting menu; "Recent Searches" caveat in brand picker; em-dash data freshness behavior; default date range shifts daily.
- **v1** (2026-05-13): Initial draft from QA-5757 exploration run. Successful build of TWC report for Hulu / Public Data / 2026-05-05 → 2026-05-11 / Facebook New Fans.

## 2026-06-11 batch-3 updates (QA-129801 / QA-129802 / QA-129673, Wasserman)

- **CRITICAL caveat — duplicate hidden datepicker:** TWO `.from-calendar` / `.to-calendar` / `.datepicker-days` instances exist in DOM. Synthetic events on the hidden one "succeed" silently but change nothing (cost 3 false attempts). ALWAYS filter `[...document.querySelectorAll('.datepicker-days')].filter(c => c.offsetParent)` before reading headers or clicking arrows/days.
- **Calendar day clicks must be inside the viewport.** A coordinate click below `innerHeight` silently no-ops. Scroll the picker into view, re-read the day cell rect, then click.
- **Channel group clear:** the per-channel `Off` link (inside the channel summary row) clears all selected metrics for that channel in one click — find via ancestor walk from the `Channel ( N / M )` summary, dispatch full `mousedown/mouseup/click`.
- **`<details>` expansion:** channel + sub-group summaries only render children after a REAL coordinate click on the summary (synthetic dispatch toggles state but children stay unrendered). Leaf checkbox clicks via `span.controlled-check-box > label` still work synthetically once rendered.
- **Cross-Channel group:** lives at the top of the By Channel tree as `Cross-Channel ( n / 62 )` with sub-groups Audience & Growth (3), Content (24), Engagement (2), Impressions & Reach (10), Interest (4), Paid (9).
- **Change Settings reuse:** on a story page, Change Settings reopens the full builder with brand/dates/metrics preserved — much cheaper than rebuilding when only interval/channel/metrics change between sibling tests (used for IG→YT→Aggregate trio).
- **Interval = Aggregate:** via `.lfm-dropdown-select-box` ("Days") → `.lfm-dropdown-option` "Aggregate". Aggregate report renders one table per metric with a single Brand|Value row.
- **Google Sheets export hang RE-CONFIRMED on second account (Wasserman story 154443):** spinner >60 s, no `window.open`, Export control locked until page reload. CSV via blob-hook is the reliable export-verification fallback.

## Changelog (cont.)
- **v5** (2026-06-11): hidden-duplicate-datepicker guard, real-click summary expansion, Off-link channel clear, Cross-Channel tree map, Change Settings reuse pattern, Aggregate interval, GS-hang reconfirmation.
