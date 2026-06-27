---
name: data-studio-post-level-run
version: 2
last_verified: 2026-06-22
last_passed_run: 2026-06-22
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in, account-set]
postconditions: [report-built]
inputs: [brand_name, perspective, metric_names, date_range, interval, window_mode]
outputs: [report_url, report_table_rows]
related_pages: ["/#explore/reporting/data_studio"]
---

# Run a Data Studio Post-Level report

End-to-end: Reporting → Data Studio → Post Level, add a brand, select metrics, click Go.

## Playwright MCP notes (verified 2026-06-22, Michael Kors, report 298410)

- **Brand picker** (`input` in "Add a Brand"): Playwright real keystrokes trigger the React
  typeahead. `browser_type` with `slowly:true` **appends** — clear with an empty `fill('')` first.
  Options render in `.al-typeahead__option` (class `dropdown-option--add-brand`), which are **not in
  the accessibility tree** — tag the exact-match option in `browser_evaluate`
  (`el.setAttribute('data-spk',…)`) then `browser_click('[data-spk=…]')`.
- **Metric tree**: open `Select Metrics` (`.metrics__tree-modal`). Type in the **Search for a Metric**
  input to filter (e.g. "Engagements" surfaces the Engagements rollup + per-channel variants). The
  metric checkboxes are `.controlled-check-box` and respond to a **trusted `browser_click`** — the
  Chrome-MCP focus+Space dispatch is **not needed**. `far fa-square` → `fas fa-check-square` on
  select; verify via the icon class. Close with `.metrics__tree-modal__close`.
- **Data grid**: rendered as `.al-table` → `.al-table__row` → `.al-table__cell` (metric name in
  `.al-table__metric`), NOT a `<table>`/`role=row`. Query `.al-table__row` directly. Row order:
  Metric, Brand, perspective badge (P/A), Sum, Average, then one cell per day. Σ(daily) == Sum holds;
  `–` (em dash) = missing day (excluded from Sum, but Average divides by the full day count).
- **Navigation**: drive via the **Reporting menu**, not hand-built URLs (per project rule). Direct-URL
  nav did render this run, but menu nav is the standard.

## Steps

### Step 1 — Open Reporting → Data Studio
- **Action sequence:** hover `Reporting` in top nav → click `Data Studio`.
- **Assertion:** URL transitions to `https://app.lfmdev.in/#explore/reporting/data_studio?account_id=<id>`. Page shows `Account: <name> | Reporting > Data Studio` breadcrumb and a `Data Studio | Affinities` tab row.

### Step 2 — Switch to Post Level
- The default is `Page Level`. Click the `Post Level` toggle.
- **Assertion:** the configuration panel grows additional controls — `Window Mode: Lifetime | In-Window` radio, `Breakdowns` dropdown, `Filters` row, and a `Go` button at the bottom. The metric label changes from `Page Level Metrics:` to `Post Level Metrics:`.

### Step 3 — Set the date range
- Click one of the preset chips: `7D`, `30D`, `90D`, `6M`, `12M`, `XTD`, `Custom`. Default is `7D`.
- For relative ranges (7D/30D/etc.), the window is "trailing N days ending yesterday."

### Step 4 — Set interval and window mode
- `Interval` dropdown defaults to `Days`. Other options exist for longer windows.
- `Window Mode` defaults to `Lifetime`. Switch to `In-Window` if the test specifies it.

### Step 5 — Add the brand

- **Action:** click the `Search for a Brand` textbox under `Add a Brand`, type the brand name, click the matching option from the dropdown.
- **Note:** unlike the TWC brand picker, the Data Studio brand picker **does respond to native typing** — no `dispatchEvent` workaround required here. But if a similar Recent-Searches-vs-Results pattern emerges in the future, prefer the Results section per the `switch-account` skill's guidance.
- **Assertion:** the brand appears in the `Brand Name` table with a `View: Public | Authorized` toggle. Default is Public Data (left position).

### Step 6 — Select metrics

- **Action:** click `Select Metrics`. A modal/panel opens with metric categories (Engagements, Impressions, Reels, Video, Rates) and a `Search for a Metric` textbox.
- **For each metric in `metric_names`:** click the search field, type the metric name, click its checkbox. Repeat.
- **Close the picker:** press `Escape` or click the `×`.
- **Assertion:** each metric appears as a row in the `Post Level Metrics:` table below `Select Metrics`.

### Step 7 — (Optional) Add a Breakdown

- `Add Breakdown` dropdown options (as of 2026-05-13): `Publish Type`, `Content Type`. **No per-post breakdown exists** — see Known Quirks below.

### Step 8 — Click Go

- **Action:** scroll to the bottom of the configuration; click the yellow `Go` button.
- **Target:** locate via `find` with "Go button" or via JS:
  ```javascript
  document.querySelectorAll('button').forEach(b => {
    if ((b.textContent||'').trim() === 'Go' && b.offsetWidth > 0) b.click();
  });
  ```
- **Assertion (during):** loading state in the chart area.
- **Assertion (after):** URL gains `&report_id=<numeric>`. Page shows a chart (or chart placeholder) and a data table with columns: `Metric`, `Brand`, `Sum`, `Average`, then one column per day in the range.

### Step 9 — Read the data table

The data table is **not** a `<table>` element — it's a custom grid. To extract rows:

```javascript
const rows = [...document.querySelectorAll('[role="row"], [class*="row"], tr')]
  .filter(el => /<metric pattern>/.test(el.textContent || '') && /\d/.test(el.textContent || '') && el.offsetWidth > 0)
  .map(el => (el.textContent || '').trim().replace(/\s+/g, ' '));
```

Each row contains, in order: metric name, brand name + perspective badge (`P` or `A`), Sum, Average, then daily values left-to-right.

## Known quirks

- **No per-post breakdown.** Despite the `Post Level` label, the report aggregates by metric across all posts. There is no way to slice down to individual posts via this report's UI.
- **`–` (em dash) for no-data days.** A day with no engagement activity renders `–` in every metric column for that day. Treat as missing, NOT zero, when reasoning about the Sum/Average aggregations.
- **Brand picker behaves normally here.** Unlike the TWC builder's brand picker, this one responds to plain `type` actions. The React-event dispatch workaround is not needed.

## Assertion patterns

### Math identity (per-row, per-aggregation)

For test cases like QA-84084 (`Engagements == Likes + Comments`):

```javascript
const cells = (rowText) => rowText.split(/[\s|]+/).filter(s => /^\d+$/.test(s)).map(Number);
const engagementCells = cells(engagementsRow);
const likeCells = cells(likesRow);
const commentCells = cells(commentsRow);
for (let i = 0; i < engagementCells.length; i++) {
  if (engagementCells[i] !== likeCells[i] + commentCells[i]) {
    // BUG: mismatch at column i
  }
}
```

Always check both the `Sum` column and each daily column separately. The identity should hold for every populated cell.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `Go` button stays greyed out | Missing required input (brand, metric, or date range) | check all three are set |
| Report builds but data table is empty for every metric | Brand has no data in the window, OR perspective mismatch | switch the View toggle to the other perspective; widen the date range |
| Math identity fails for a metric pair | **BUG** — data inconsistency between metrics | file with the exact row, column, expected vs actual numbers |
| Em dash appears for a metric on a day other metrics have data | Data pipeline gap — `Engagements` populated but `Likes`/`Comments` not, or vice versa | flag for backend investigation |

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-31977 (Major) — Reporting > Data Studio Report - Save to dashboard dropdown remains visible when graph tile is missing     [from QA-96818]

## Changelog
- **v2** (2026-06-22): Playwright MCP validation (Michael Kors, 7D, report 298410). Added "Playwright
  MCP notes": trusted `browser_click` on `.controlled-check-box` (focus+Space obsolete), DOM-tagging
  for non-a11y typeahead/tree widgets, `fill('')`-before-type to avoid appended input, and the data
  grid selectors (`.al-table__row`/`.al-table__cell`). Confirmed Engagements rollup ≈ Σ(channel
  engagements) and Σ(daily)=Sum; em-dash = missing day.
- **v1** (2026-05-13): Initial draft from QA-84084 exploration. Math identity (Engagements = Likes + Comments) confirmed for MTV Public Data on May 07, 2026 (Sum=433, Likes=413, Comments=20).

## 2026-06-11 batch-3 updates (QA-80360 page-level / QA-111213 page+post)

- **Page-level metrics config:** selected metrics render in `.metrics__table-wrapper table` rows = channel icon (`.channel-icon`) + metric name + trash. **Trash icons are `<button class="fas fa-trash button--unset…">` — dispatch events on the BUTTON; clicks on the inner `<i>` silently no-op** (this also applies to brand-row removal).
- Metric tree close = `.metrics__tree-modal__close`. Tree summaries: "Engagements" appears twice (section header + node) — pick by index or scope.
- Page Level ⇄ Post Level switch preserves brand + dates; Show Configuration reopens builder on a story.
- IG leaves verified: Page level Engagements>Impressions node contains `Instagram Views` (report 295925, Sum 116,351,436); Post level Impressions node contains `Instagram Post Impressions` (report 295927, data renders). Builder typeahead sometimes needs a real click + retype (cmd+a then type) when the React-setter path leaves a stale concatenated value.
