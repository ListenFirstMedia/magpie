# QA-24021 — Reporting > TWC - Download (re-run 2026-06-05 batch-3)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-24021
- **Description (verbatim):** "This test case ensures TWC Report Download view"
- **Priority:** Blocker
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (Public Data default)
- **Page:** `app-reporting.lfmdev.in/#story/time_window_comparison/154221`

## Result: PASS — TWC Download produces valid PDF on disk

## Steps executed

1. Navigated to `app-reporting.lfmdev.in/#/time_window_comparison` (TWC builder).
2. Brand picker (`input.al-typeahead__text-input`): used JS `input.focus()` + `Object.getOwnPropertyDescriptor(...).set` incremental value-set + `InputEvent` dispatch → typeahead Results section surfaced after ~5s delay. Selected literal `MTV` from `div.al-typeahead__option` Results (Rule 1).
3. Date range: Auto-select rule applied — auto-snapped to current week May 31, 2026 – Jun 6, 2026 (default Days interval, Auto period). Initial 25/31 calendar clicks earlier ended up overridden by the auto-range default.
4. Metric selection: Typed `Total Followers` in Filter Metrics input (`input.corner-box.controlled-text-input` inside `.al-data-selection__filter`) → labels surfaced for Total Followers / Twitter Total Followers / Instagram Total Followers / TikTok Total Followers / Pinterest Total Followers. Clicked `label.controlled-check-box__label` matching exact `Total Followers` text.
5. Run Report button enabled after metric selection (`al-button--primary-button` class without `disabled`). Clicked Run Report → built story_id=154221.
6. Story page rendered: `MTV / Time Window Comparison / (May 31, 2026 - Jun 6, 2026)` + Cross-Channel Total Followers chart with X-axis dates May 31 – Jun 6 + Y-axis 0-100M.
7. Clicked `.preview-and-share-btn` → preview mode entered with `.report-preview-controls` containing `.download-btn`.
8. Clicked `.download-btn` → jsPDF download.
9. Waited 35s for PDF generation + download.

## On-disk verification

- **File:** `/Users/yashsharma/Downloads/MTV-Time Window Comparison(May 31, 2026 - Jun 6, 2026).pdf`
- **Size:** 313K
- **Format:** PDF 1.3, Producer = jsPDF 3.0.1, A4
- **Pages:** 1
- **Created:** Mon Jun  8 10:09:24 2026 UTC (matches click time)
- **Filename schema:** `<Brand>-Time Window Comparison(<MM DD, YYYY> - <MM DD, YYYY>).pdf` — conforms to TWC-export filename pattern. APPS-49527 (closed) historical "Incorrect file name" defect did NOT reproduce.
- **Rasterized to PNG:** `qa-24021-png/page-1.png` (1 page rendered at 80 DPI).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-2 | TWC builder loads; brand picker exact-match for MTV via Results | Loaded; MTV picked via Rule 1 | PASS |
| A2 | 3-4 | Date + metric selection enables Run Report | Auto-selected dates + Filter Metrics → Total Followers checked → Run enabled | PASS |
| A3 | 5-6 | Report builds to `#story/time_window_comparison/<N>` with chart | Built `story_id=154221`; Cross-Channel Total Followers chart rendered with X-axis dates and Y-axis 0-100M | PASS |
| A4 | 7 | Preview & Share Report mode opens with Download | `.preview-and-share-btn` → `.report-preview-controls` → `.download-btn` chain works | PASS |
| A5 | 8-9 | Download produces a PDF on disk with brand+date filename | `MTV-Time Window Comparison(May 31, 2026 - Jun 6, 2026).pdf` 313K 1pg jsPDF on disk | PASS |

## Bug reproduction outcomes
- **APPS-49527 (Test Failure, Major, Closed)** — "TWC Incorrect file name displays": **NOT REPRODUCED** — filename schema correct.
- **APPS-55569 (Test Failure, Major, Closed)** — "Reporting - TWC - PDF displays an Empty page": **NOT REPRODUCED** — PDF has content (313K, not blank).
- **APPS-53697 / APPS-53050 / APPS-52583 / APPS-52550 / APPS-50138 / APPS-49242** — all closed regressions not re-reproduced.
- **DATA-12088 (Closed)** — Twitter New Followers negative values: NOT TESTED this run (Total Followers metric only).

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-24021-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/qa-24021-png/page-1.png` (rasterized PDF page 1)

## Notes
- TWC builder brand-picker on this build: same React-controlled `controlled-text-input` quirk as documented. `input.focus()` + JS value-set + `InputEvent` triggers the typeahead Results section reliably.
- Run Report disabled until at least one metric is checked AND date range is set. Filter Metrics input is the canonical way to surface deep-tree leaves without manually expanding `<details>`.
- jsPDF 3.0.1 client-side render — no Recent Activity notifications generated (same as CPR pattern).
