# QA-23969 — Reporting > Social Recap - Download

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-23969
- **Run date:** 2026-05-20
- **Env:** dev (`app-reporting.lfmdev.in`)
- **Account:** Adam Orfei
- **Priority:** P2 (Critical)
- **Rules applied:** All 6 from `_shared/spec-adherence-rules.md`
- **Result:** ⚠ **5/6 PASS, 1 FAIL (page-number format) + 1 minor filename formatting observation**

## Steps executed (every step, no shortcuts)

| Step | Action | State |
|---|---|---|
| 1 | Hover Reporting top nav | ✓ |
| 2 | Click 'Social Recap' from menu | ✓ |
| 3 | Add brand 'ListenFirst' via Add Brand By Name (exact-name from Results, per Rule 1) + click Authorized toggle (per Rule 2). Confirmed by pill text changing from `Use Authorized Data` → `Use Public Data` (i.e. now in Authorized state) | ✓ |
| 4 | Check 'Show Insights Editor' in Options → General | ✓ |
| 5 | Click 'Run Report' → URL `/story/social_recap/153468`, title 'Weekly Social Recap (May 12, 2026 - May 18, 2026)' rendered | ✓ |
| 6 | Click 'Preview & Share Report' → top bar showed Share / Download / X | ✓ |
| 7 | Click 'Download' | ✓ — first PDF saved |
| 8 | Open PDF (LFIQA action) | ✓ |
| 9 | Click X (close) on preview | ✓ |
| 10 | Click 'Change Settings' | ✓ |
| 11 | Add 5 brands one-by-one from Results section (exact-name match per Rule 1):<br>• Pretty Little Liars<br>• NBA<br>• Michael Kors<br>• Suits<br>• New York Mets | ✓ |
| 12 | Check 'Show Source Links' in Options → General | ✓ |
| 13 | Click 'Run Report' → URL `/story/social_recap/153471` | ✓ |
| 14 | Click 'Preview & Share Report' | ✓ |
| 15 | Click 'Download' (second PDF) | ✓ |
| 16 | Open PDF (LFIQA action) | ✓ |

## Assertion results (verified end-to-end via PDF inspection)

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 7 | PDF should download | LFIQA confirmed PDF in Downloads folder | ✅ PASS |
| A2 | 8a | Each page displays `Page N(N - Page count)` at end | Pages display **`Page N` only** — e.g. `Page 1`, `Page 5`, `Page 13`. No `(N - Page count)` suffix anywhere. Verified pages 1, 5, 13 of the 13-page PDF. | ❌ **FAIL** |
| A3 | 8b | Filename `BrandName -Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` (space between BrandName and `-Weekly`) | Filename **`ListenFirst-Weekly Social Recap(May 12, 2026 - May 18, 2026).pdf`** (no space between `ListenFirst` and `-Weekly`). The `(1)` suffix is browser-added because Downloads already had a same-named file from an earlier run. | ⚠ Minor formatting deviation |
| A4 | 8c | Preview mode page matches PDF | Page 1 of PDF content matches the preview seen on screen: ListenFirst logo top-left, "Insights about your brand:" placeholder, Type: Marketing Advertising and Research, Section 1 Social Footprint - All-Time, 9,654 Total Fans, channel bar chart (LinkedIn 7,586 / X 824 / FB 543 / IG 526 / Threads 92 / YouTube 73 / TikTok 10), Section 2 Social Activity, 4 donut metrics, channel tables. Exact visual match. | ✅ PASS |
| A5 | 16a | Filename `Primary BrandName -Weekly Social Recap(...).pdf` (primary brand = first added) | Same file = primary brand `ListenFirst` (added first, kept in position 1 in the brand list during run 2). Same minor formatting deviation as A3 (no space before `-Weekly`). | ⚠ Minor formatting deviation |
| A6 | 16b | Preview mode page matches PDF (with 6 brands + Source Links) | Page 5 of PDF shows Social Activity with 4 donut metrics matching preview; Page 13 (last page) shows the Source Links section listing all source URLs for NBA, Michael Kors, Suits, and New York Mets across their FB / Twitter / Instagram / YouTube / TikTok platforms (the Show Source Links option correctly took effect). Full content match. | ✅ PASS |

## Evidence captured

| File | Description |
|---|---|
| `qa-23969-pdf-page-01.png` | Page 1 — Title, Insights placeholder, Social Footprint, Social Activity tables. Footer shows `Page 1` (NOT `Page 1(1 - 13)`). |
| `qa-23969-pdf-page-05.png` | Page 5 — Social Activity (May 12-18) donuts + channel tables + Best Performing Content posts. Footer shows `Page 5`. |
| `qa-23969-pdf-page-13.png` | Page 13 — Source Links section (NBA, Michael Kors, Suits, New York Mets URLs across 5 platforms each). Footer shows `Page 13`. |

PDF total: **13 pages** (`pdfinfo` confirms).

## 🐛 BC-4 — Social Recap PDF pages show `Page N` only, missing `(N - Page count)` suffix

- **Severity:** P2 (failing the page-format assertion of a Critical-priority test)
- **Source case:** QA-23969 A2
- **First seen:** 2026-05-20
- **Affected area:** Reporting → Social Recap → PDF download
- **Status:** Reproduced. Awaiting triage decision (real regression vs stale spec).

### Expected vs Actual

```diff
Expected (per QA-23969 A2):
  Each page displays "Page N(N - Page count)" at the end — e.g.
    Page 1: "Page 1(1 - 13)"
    Page 5: "Page 5(5 - 13)"
    Page 13: "Page 13(13 - 13)"

Actual (observed in the saved PDF, 13 pages):
    Page 1:  "Page 1"
    Page 5:  "Page 5"
    Page 13: "Page 13"

Missing in EVERY page: the "(N - Page count)" suffix.
```

### Evidence
- PDF: `ListenFirst-Weekly Social Recap(May 12, 2026 - May 18, 2026) (1).pdf`
- Producer: jsPDF 3.0.1
- Pages: 13
- Page 1, 5, 13 footer text captured via `pdftoppm` rasterization → screenshots in evidence files

### Reproduction
1. Run QA-23969 steps 1-16 exactly as specified.
2. Open either of the two downloaded PDFs.
3. Scroll to the bottom-right of any page.
4. Observe `Page N` text without the `(N - Page count)` suffix.

### Suggested next steps
- Backend / Frontend: check the jsPDF page-footer template. If the spec wants `Page N(N - Page count)`, the template needs `${currentPage}(${currentPage} - ${totalPages})` instead of just `${currentPage}`.
- QA / Product: confirm whether this format is the intended design or a regression. If the current `Page N` format is intentional, update QA-23969 wording.

## Minor observation — filename missing space before `-Weekly`

- Spec format: `BrandName -Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` (note the space between `BrandName` and `-Weekly`).
- Actual: `ListenFirst-Weekly Social Recap(May 12, 2026 - May 18, 2026).pdf` (no space).

This may be a spec-template artifact (the spec writer's space might be incidental). Not filing as a bug; flagging for QA review.

## Skill use
- `social-recap-report-run` v1 (new, authored from this test) — used for steps 1-16 end-to-end.
- `view-perspective-toggle` v1 — used for Step 3b (Authorized toggle).
- `_shared/spec-adherence-rules.md` — Rule 1 (exact brand name) and Rule 6 (download verified end-to-end via actual PDF read, not DOM signals).

## Bugs filed
- **BC-4** (this run) — Social Recap PDF page-footer missing `(N - Page count)` suffix.
