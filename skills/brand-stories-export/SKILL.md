---
name: brand-stories-export
version: 1
last_verified: 2026-07-02
last_passed_run: 2026-07-02
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-set]
postconditions: [tile-csv-downloaded]
inputs: [brand_name, date_from, date_to, tile_name, graph_type]
outputs: [csv_filename, csv_text]
related_pages: ["#explore/brand/stories"]
---

# Brand > Stories — tile graph-type switch + tile-level CSV export

Brand > Stories page: per-tile (Engagements / Impressions / Taps Back / Exits) graph-type toggle
(Bar/Line) and a per-tile Export (PNG / CSV / Google Sheets). Verified on QA-68691 (Michael Kors,
Instagram, Jan 1–4 2025, Engagements → Line → CSV).

## Steps

### Step 1 — Navigate to Brand > Stories
- **Action:** hover the **Brand** top-nav item (it's a HOVER flyout, not a click menu), then click **Stories**.
- **Target (primary):** flyout `link "Stories"` → `/url` `#explore/brand/stories?brand_id=<id>`
- **Assertion:** URL `#explore/brand/stories`, title "Brand Stories - ListenFirst".

### Step 2 — Confirm brand (Rule 1)
- The account's default brand loads (e.g. Michael Kors → brand_id=3801). Confirm the brand chip shows
  the exact spec brand. If a different brand is required, use the brand picker (typeahead Results).

### Step 3 — Set the date range (TWO-calendar picker)
- **Action:** click the **Date Range** button (label shows current range).
- The popup has **two independent calendars**: **Start Date** (sets `from`) and **End Date** (sets `to`).
- Navigate each calendar via: click month-header → month grid → prev/next arrow for year → click month → day.
- **Set start:** in the Start (left) calendar, navigate to the from-month and click the from-day.
- **Set end:** navigate the **End (right) calendar SEPARATELY** to the to-month and click the to-day.
  ⚠ Do NOT click a second day in the Start calendar — it RESETS the from-date (bug seen on QA-68691:
  produced from=Jan-04/to=Dec-31). Verify range-start/range-end highlight before applying.
- **Action:** click **Ok**.
- **Assertion:** URL `from=<YYYY-MM-DD>&to=<YYYY-MM-DD>` matches spec; tiles reload.

### Step 4 — Switch a tile's graph type
- **Action:** in the target tile, click the graph-type `.dropdown-name` span (shows "Bar") → click the
  **Line** option (`.list-item`).
- **Assertion:** that tile's `.dropdown-name` now reads "Line"; the chart re-renders (screenshot).
  (Each tile has its own toggle — only the target tile changes.)

### Step 5 — Export the tile to CSV
- **Action:** in the same tile, click the **Export** `.dropdown-name` → options **PNG / CSV / Google Sheets**
  (`.list-item`). Click **CSV**. (Google Sheets = OUT OF SCOPE per env.md — skip it.)
- **Export is SYNCHRONOUS** — the file downloads straight to `--output-dir` (`.playwright-out/`), no
  queue / notification bell.
- **Assertion (Rule 6, on disk):**
  - Filename = `<Brand> - <Tab> - <Tile> - <YYYY-MM-DD start>-<YYYY-MM-DD end>.csv`
    (slugified on disk: spaces/`, ` → `-`), e.g. `Michael Kors-Stories-Engagements-2025-01-01-2025-01-04.csv`.
  - Columns = `Date, Brand Name, Channel, <Tile metric>` (Engagements tile → `Date,Brand Name,Channel,Engagements`).
  - Daily rows (one per day in range, per channel); Σ(daily) == the tile's Sum / heading value.
    Days with no story data render an EMPTY cell (`""`), not `0`.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Range ends up from=start-day/to=last-of-visible-month | Clicked 2nd day in Start calendar instead of the End calendar | re-open, set End calendar separately |
| CSV never downloads / no file in output-dir | Export path changed (async?) | check notification bell + `export-csv` async hook |
| Σ(daily CSV) ≠ tile Sum | data/aggregation mismatch | verify perspective + channel; file bug if real |
| Filename missing metric/date segment | filename bug (cf. BC-2) | verify on disk before filing |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|----------|--------|-----------------|-------|
| story insights fetch | GET | 200 | tile data for the window |
| tile CSV export | GET | 200 | synchronous file download |

## Changelog
- **v1** (2026-07-02): initial draft from QA-68691 (interactive headed). Two-calendar date picker,
  per-tile `.dropdown-name` graph-type + Export, synchronous CSV, on-disk column/sum verification.
