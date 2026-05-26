---
name: pdf-end-to-end-verification
version: 1
last_verified: 2026-05-20
last_passed_run: 2026-05-20
trust: untrusted
pass_streak: 1
preconditions: [pdf-file-available-in-uploads]
postconditions: [pdf-content-and-filename-verified]
inputs: [pdf_path, expected_filename_pattern, expected_page_footer_pattern]
outputs: [verification_matrix]
related_pages: ["any download flow"]
---

# PDF end-to-end verification (per spec-adherence Rule 6)

This skill lets us perform GENUINE end-to-end PDF verification — actually reading the saved file's filename + content — rather than the false-positive-prone DOM-signal approach.

Used by:
- **QA-23969** (Social Recap Download) — verified BC-4 (missing page-count suffix in footer) by rasterizing pages 1, 5, 13 and reading the actual on-page text.
- Any future test with PDF download assertions.

## Why this skill exists

Per `_shared/spec-adherence-rules.md` Rule 6: NEVER claim a PDF filename or content is wrong based on DOM attribute inspection (`anchor.download`, response headers). The browser may set the filename programmatically when the user clicks the link.

The valid approach: have LFIQA share the actually-saved PDF, then inspect filename + render the page contents using `pdftoppm` and read the rendered image.

## Steps

### Step 1 — Ask LFIQA to upload the PDF
Tell LFIQA the test required a PDF download and ask them to upload the saved file via the Cowork file-upload flow. The file lands at `/sessions/<session>/mnt/uploads/<filename>`.

### Step 2 — Read the filename (A3-style assertions)
The uploaded filename in the path is the exact filename the browser saved. Compare against spec.

Important: browsers append ` (1)`, ` (2)`, etc. when a same-named file already exists in Downloads. Strip that suffix before comparing against spec.

### Step 3 — Inspect the PDF metadata
```bash
pdfinfo "/sessions/.../mnt/uploads/<filename>.pdf"
```
Shows: producer (`jsPDF 3.0.1` for Social Recap), page count, page size, dates.

### Step 4 — Try text extraction first
```bash
pdftotext -layout "<file>.pdf" /tmp/out.txt
wc -l /tmp/out.txt
```
If the PDF was generated from a vector-text source, text extraction works and you can grep for spec strings. If `wc -l` returns 0, the PDF is fully-rasterized — go to Step 5.

### Step 5 — Rasterize specific pages to PNG for visual inspection
```bash
# Rasterize first page
pdftoppm -r 100 -f 1 -l 1 -png "<file>.pdf" page

# Rasterize last page
pdftoppm -r 100 -f <last> -l <last> -png "<file>.pdf" lastpage

# Rasterize a middle page
pdftoppm -r 100 -f 5 -l 5 -png "<file>.pdf" middlepage
```
Output: `page-01.png`, `lastpage-13.png`, etc.

### Step 6 — Copy to outputs and read via the Read tool
```bash
cp /tmp/page-01.png /sessions/.../mnt/outputs/qa-XXXXX-pdf-page-01.png
```
Then use the file-reading tool — it's a multimodal LLM and can read PNG images natively. Document what you see in the page footer, header, body.

### Step 7 — Document the verification matrix
For each assertion that's about PDF content, record: expected text/pattern, actual text observed, page numbers checked, pass/fail.

Spec patterns commonly encountered:
- `Page N(N - Page count)` — the format observed in QA-23969 was just `Page N`. Real bug BC-4.
- Filename `BrandName -Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` — observed missing space before `-Weekly`. Spec ambiguity, filed as IF-3.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| `pdftotext` returns 0 lines | PDF is rasterized (no vector text) | Use `pdftoppm` to convert to PNG, then Read |
| `pdftoppm` fails | PDF is encrypted or corrupted | Check `pdfinfo` for encryption status |
| Spec format `Page N(N - X)` not found anywhere | Real bug — file as candidate | Rasterize 3 pages (first, middle, last) for evidence |
| Filename matches spec exactly | A3 PASS | No further action |
| Filename has `(1)` suffix | Browser auto-rename for duplicate | Strip suffix, compare base name |

## Notes
- Always rasterize at `-r 100` (DPI) — high enough to read footer text, low enough to keep file size manageable.
- Render the first page, last page, and at least one middle page. The footer pattern should be consistent across all; a mid-page check catches inconsistencies.
- Save rasterized PNGs to the outputs folder with `qa-<id>-pdf-page-NN.png` naming so they can be referenced in the case report.

## Changelog
- **v1** (2026-05-20): Initial draft from QA-23969 PDF inspection. Used `pdftoppm` for rasterization (`pdftotext` returned 0 lines because the PDF is image-based). Footer pattern was confirmed deviation across pages 1, 5, 13 — filed as BC-4.
