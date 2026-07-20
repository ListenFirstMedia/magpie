# QA-23991 — Reporting > Content Performance Report - Download (re-run 2026-06-05 batch-3)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-23991
- **Description (verbatim):** "This test case ensures CPR Report Download view"
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (added via TWC builder typeahead Results — Rule 1 exact match)
- **Page:** `app-reporting.lfmdev.in/#story/content_performance/154220` (built report)
- **Date range (auto-selected):** May 31, 2026 – Jun 6, 2026 (default)

## Result: PASS — Download produces valid PDF on disk

## Steps executed

1. Navigated to `app-reporting.lfmdev.in/#/content_performance` (CPR builder).
2. Brand picker: typed `MTV` via real keyboard (triple_click + Delete + type), suggestions surfaced 25+ MTV variants. Selected literal `MTV` from `div.al-typeahead__option` Results.
3. Default date range auto-selected to current week (May 31, 2026 – Jun 6, 2026). Default channels = all 7. Default Options unchanged.
4. Clicked Run Report button via JS click on `button.al-button--primary-button` matching "Run Report".
5. Story page rendered at `#story/content_performance/154220` — header "MTV / Content Performance / (May 31, 2026 - Jun 6, 2026)" + per-channel content tiles (Facebook 80% Engagements 516K dist visible) + Page 1 marker.
6. Clicked `div.preview-and-share-btn` → Preview & Share Report mode entered. Controls bar shows `Share | Download`.
7. Clicked `div.download-btn` inside `.report-preview-controls` → download initiated via jsPDF.
8. Waited 28s for PDF generation + download.

## On-disk verification

- **File:** `/Users/yashsharma/Downloads/MTV-Content Performance(May 31, 2026 - Jun 6, 2026).pdf`
- **Size:** 300,968 bytes (294K)
- **Format:** PDF 1.3, Producer = jsPDF 3.0.1, A4 (595.28 x 841.89 pts)
- **Pages:** 1
- **Created:** Mon Jun  8 10:00:55 2026 UTC (matches click time)
- **Text extract:** `pdftotext` returns 0 lines (image-rendered content; jsPDF embeds canvas as image, no extractable text — same pattern as historic CPR downloads).
- **Rasterized to PNG:** `qa-23991-png/page-1.png` (40,895 bytes at 80 DPI).
- **Filename schema:** `<Brand>-Content Performance(<MM DD, YYYY> - <MM DD, YYYY>).pdf` — conforms to CPR-export filename pattern.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-3 | CPR builder loads; brand picker exact-match for MTV | Loaded; typed MTV → Results section returned exact MTV div.al-typeahead__option → clicked | PASS |
| A2 | 4 | Run Report button enabled; report builds to `#story/content_performance/<N>` | Built `story_id=154220`; tile MTV / TV Network | MTV with Engagements 516K | PASS |
| A3 | 6 | Preview & Share Report mode opens with Share + Download controls | `.preview-and-share-btn` opens preview pane with `.report-preview-controls` containing `.download-btn` and `Share` | PASS |
| A4 | 7-8 | Download produces a PDF on disk with brand+date filename | `MTV-Content Performance(May 31, 2026 - Jun 6, 2026).pdf` 294K 1pg jsPDF on disk; filename schema conforms | PASS |

## Bug reproduction outcomes
- **LFMP-32010 (Bug, Major, Open)** — "Least Engaging Posts & Heading Does not show in Preview & Share Report": **NOT VERIFIED THIS RUN.** The default CPR build did NOT include Least Engaging Content (Options section default `Most Engaging` only, `Least Engaging Content` checkbox not toggled). Therefore the 1-page PDF is correctly missing the Least Engaging section (because it wasn't enabled, not because the bug suppressed it). To verify LFMP-32010 properly requires toggling `Least Engaging Content` ON in Options before Run Report — deferred to a future targeted re-run.
- **APPS-59205 / APPS-57473 / APPS-56781 / APPS-56650 / APPS-55569 / APPS-53697 / APPS-52068 / APPS-50145 / APPS-49527 / APPS-49242** (all closed) — none re-reproduced this run. Build + download path clean.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-23991-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/qa-23991-png/page-1.png` (rasterized PDF page 1)

## Notes
- CPR Builder is responsive on Adam Orfei today. Auto-date-range = current week. Default options Most Engaging only → 1-page PDF.
- Brand-picker discipline: JS-typed value via React `Object.getOwnPropertyDescriptor(...).set` did NOT surface the typeahead Results section on this builder — required real `computer.triple_click + type` keyboard sequence (consistent with React-controlled input quirk in known-quirks).
- jsPDF 3.0.1 is a client-side PDF generator; the download path is local-render (not server-fetch), so no Recent Activity Notifications bell entry is generated (consistent with historic CPR pattern).
