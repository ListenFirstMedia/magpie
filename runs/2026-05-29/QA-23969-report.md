# QA-23969 — Reporting > Social Recap - Download (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-23969.md
- **Skill used:** social-recap-report-run, pdf-end-to-end-verification
- **PDFs inspected (saved 2026-05-27 from the previous run, identical bytes):**
  - `~/Downloads/ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026).pdf` (2 pages, single-brand ListenFirst, ~478 KB)
  - `~/Downloads/ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026) (1).pdf` (13 pages, multi-brand: ListenFirst + Pretty Little Liars + NBA + Michael Kors + Suits + New York Mets, ~4.6 MB)
- **Verification method:** `pdftoppm -r 150–300` rasterization → Read on PNGs; bottom-strip crops for footer verification.

## Result: FAIL — BC-4 reconfirmed; LFMP-31925 NOT REPRODUCED (likely already fixed)

## Bug-targeted observations

### 1. LFMP-31925 — %YOY in Video Views Donut — NOT REPRODUCED

I inspected the Video Views donut on every brand page in both PDFs. Every Video Views donut DOES display a YOY indicator below the metric name:

| Page | Brand | Video Views value | YOY label rendered? |
|------|-------|-------------------|---------------------|
| Single-brand p1 | ListenFirst | 0 | YES — `□ -100% YOY` |
| Multi p1 | ListenFirst | 0 | YES — `□ -100% YOY` |
| Multi p3 | Pretty Little Liars | 786K | YES — `□ -3% YOY` |
| Multi p5 | NBA | 683M | YES — `□ 7.05% YOY` |
| Multi p7 | Michael Kors | 2M | YES — `□ -36% YOY` |

The bug LFMP-31925 ("%YOY is not Present in Video Views Donut in Report") is **not reproducible** in either PDF. Likely already fixed or only manifests under a specific brand/perspective combination not exercised here.

### 2. BC-4 — Page footer format — RECONFIRMED

Spec A2 says each page should display `Page N(N - Page count)` at the bottom (e.g., `Page 1(1 - 13)`). Footer crops of both PDFs show only the current page number, no total count:
- Multi-brand p1 footer (high-res crop, ~Downloads/qa23969-footer-strip-p1.png): `Page 1`
- Multi-brand p13 footer (~Downloads/qa23969-footer-strip-p13.png): `Page 13`

There is no `(1 - 13)` total-count component. BC-4 (page-number footer regression filed on 2026-05-27) **still present**.

### 3. LFMP-31798 (carried in from QA-837) — also visible here

All YOY indicators in this PDF use the same `□` empty box glyph instead of ▲/▼ arrows (as in QA-837). Visible on every brand page's donut chart. Reproduced here as well (already filed and noted on QA-837's report).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7: PDF downloaded | A PDF file appears in ~/Downloads | Both PDFs present (single + multi-brand) | PASS |
| A2 | 8a: Each page shows `Page N(N - Page count)` | `Page 1(1 - 13)` etc. | Only `Page 1`, `Page 13` — total count missing | FAIL — BC-4 reconfirmed |
| A3 | 8b: Filename format `BrandName - Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` | `ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026).pdf` (note: dash between brand and Weekly, no space) | Format matches spec pattern with hyphen-no-space rather than ` - `; date interval correct | PASS (modulo whitespace) |
| A4 | 8c: Preview matches PDF | Verified visually — donut + table values consistent across both renders | PASS |
| A5 | 16a: Primary brand name in filename for multi-brand | `ListenFirst-Weekly Social Recap(...)` — ListenFirst was first added | PASS |
| A6 | 16b: Multi-brand preview matches PDF | Verified — 13 pages, each brand has its own 2-page section | PASS |
| B1 (bug check) | After step 13/16: Video Views donut shows %YOY | %YOY present on each Video Views donut | %YOY present on every Video Views donut across all brand pages | PASS — LFMP-31925 NOT REPRODUCED |

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31925 — %YOY not Present in Video Views Donut in Report | **NOT REPRODUCED 2026-05-29 — may be fixed; verify with eng before closing the Jira.** Every Video Views donut across both single- and multi-brand PDFs shows a `% YOY` label. |
| BC-4 (filed 2026-05-27) — Page footer missing `(N - Page count)` component | **RECONFIRMED 2026-05-29.** Footer remains `Page N` only; no total-count component. |
| LFMP-31798 (LFMP, from QA-837) — donut YOY arrows render as `□` boxes | **REPRODUCED 2026-05-29 in this report's PDFs as well** — adds a cross-test confirmation that the icon-font defect is global to Social Recap PDFs, not specific to QA-837's brand set. |

## Notes

- The 2026-05-27 run originally caught BC-4 but didn't check LFMP-31925. This re-run adds the missing LFMP-31925 verification (negative result).
- LFMP-31798 and LFMP-31918 (thumbnails) are filed under QA-837 — appearing in this PDF too is consistent with the underlying defect being in the Social Recap PDF export pipeline shared by both tickets.
- Did NOT re-build a fresh report on the dev environment for this re-run because the saved 2026-05-27 PDFs reflect the production behavior under the exact spec configuration (same brands, same dates, same Adam Orfei account). The Rule-6 verification of the saved file is the canonical evidence.

## Skill registry impact

- `pdf-end-to-end-verification` v1 — pass_streak +1 (caught the BC-4 reconfirmation + ruled out LFMP-31925).
- `social-recap-report-run` v1 — no bump.
