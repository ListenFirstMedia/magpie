---
name: data-studio-short-link
version: 1
last_verified: 2026-07-07
last_passed_run: 2026-07-07
trust: untrusted
pass_streak: 1
preconditions: [data-studio-report-built]
postconditions: [short-link-verified]
inputs: [report_id]
outputs: [short_link_url]
related_pages: ["/#explore/reporting/data_studio"]
---

# Data Studio — Short Link creation + config-change re-run

Covers the Data Studio "pin" (short link) feature: generating a short link for a built report, verifying it resolves to the same report, then editing the configuration (remove a metric) and re-running to get a fresh report.

Used by:
- **QA-82626** — Short Link & URL loads.

## Precondition warning — builder state persists across navigations

The Data Studio builder (brand list, metric list) is **not reset** by navigating away to another page and back within the same tab/session — it behaves like a saved draft. Before starting a fresh case, explicitly clear both:
```javascript
Array.from(document.querySelectorAll('*'))
  .filter(el => el.children.length === 0 && el.textContent.trim() === 'Remove All')
  .forEach(el => el.click());
```
Do this for **both** the Brand table and the Metric table (there are two separate "Remove All" links). Skipping this step contaminates the report with leftover brands/metrics from a prior ticket in the same session.

## Steps

### Step 1 — Build the source report
- Add brands via `input.al-typeahead__text-input` (see `data-studio-post-level-run` / `data-studio-multi-perspective` for the typeahead mechanics — exact-text match required, click from the `.al-typeahead__option` list).
- Toggle any brand's View via its row-scoped `.al-toggle__checkbox`.
- Select Metrics → Search for a Metric → click each label text (checkboxes have no reliable `<li>`/native-checkbox wrapper; a plain `browser_click` on the visible label text works).
- Click **Go**. URL gains `&report_id=<numeric>`.

### Step 2 — Create the short link
- **Target:** `.short-link-button` (a real Playwright click works directly, no JS fallback needed).
- **Assertion:** an inline link input/text appears reading `https://app.lfmdev.in/#s/<slug>`, alongside a copy icon.

### Step 3 — Verify the short link resolves
- Open the short link in a **new tab** (`browser_tabs` action `new`, or navigate the link directly).
- **Assertion:** the resulting URL is `#explore/reporting/data_studio?account_id=<id>&report_id=<SAME report_id as Step 1>` — confirms A1/A2 (same report, same URL target).
- Cross-check brand rows + metric rows/values match the source report exactly (A3).

### Step 4 — Edit configuration and re-run
- Click **Show Configuration** (button text `Show Configuration`) to reopen the builder from the report view.
- **Assertion (pre-edit):** the **Go** button is `disabled=true` (no pending changes).
- Remove a metric via its trash icon. **Note:** the icon markup varies by report level —
  - Page-level metrics table: bare `<i class="fas fa-trash" tabindex="0">` (no button wrapper) — click it directly.
  - Post-level metrics table (per `data-studio-post-level-run`): `<button class="fas fa-trash …">` — click the button, not the inner icon.
- **Assertion (post-edit):** the removed metric's row is gone from the metric table; **Go** button becomes `disabled=false`.
- Click **Go** again.
- **Assertion:** URL gains a **new**, different `report_id`; the resulting report's metric table only contains the remaining (non-deleted) metric(s).

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Short link input never appears after clicking `.short-link-button` | Regression or slow network — wait longer before failing | retry with longer wait |
| Short link resolves to a different `report_id` or blank page | **BUG** — short-link generation/resolution broken | file with both URLs |
| Go button stays enabled with zero changes made | Stale leftover edit state from before this run (see precondition warning) — clear builder state and retry | not necessarily a bug |
| Go button stays disabled after a real metric removal | **BUG** — change-detection broken | file with repro steps |
| Re-run keeps the same `report_id` | **BUG** — Go isn't generating a fresh report for the edited config | file |

## Changelog
- **v1** (2026-07-07): Initial draft from QA-82626 (Adam Orfei, Star Wars + MTV Authorized, Facebook Total Fans / Twitter Total Followers). All 6 assertions PASS — short link round-trip, config-preservation, disabled→enabled Go transition, and fresh report_id on re-run all verified end-to-end.
