# QA-837 — Social Recap: Report - Multiple brands

- **Run date:** 2026-07-01
- **Skill used:** `social-recap-report-run` (v2) + `pdf-end-to-end-verification` (v2, adapted — no `poppler` on this machine, used macOS `qlmanage -t` for page-1 thumbnail + `strings`/`grep` for `/Producer` and `/Count` instead of `pdfinfo`/`pdftoppm`)
- **Account:** Hulu (account_id=336, switched via URL id per token-minimization instruction)
- **Report:** `report_id=155422`, brands added in order **Hulu → Conan**, default date range (Jun 23–29, 2026), default channels/options (no Source Links / no Insights Editor / no YoY or Prior Period toggles changed).

## Assertions

| # | Expected | Actual | Status |
|---|---|---|---|
| 1 | Correct URL updates to `app-reporting.../#/template` pattern | URL updated to `app-reporting.lfmdev.in/#story/social_recap/155422` — dev-env path naming (`#story/social_recap/<id>`), not literal `#/template`. This is the same path pattern this skill has always produced (see QA-23969/QA-19486 prior runs) — spec wording likely predates a URL-scheme rename or refers to the initial `/social_recap` builder route before Run. Not treated as a bug (Rule 5) — documenting the observed pattern. | INFO / spec-wording drift |
| 2 | Selected template loads | Page rendered `Hulu / Weekly Social Recap (Jun 23, 2026 - Jun 29, 2026)` with populated tiles (Social Footprint, Social Activity, etc.) | PASS |
| 3 | Primary brand not offered again once entered | After adding Hulu, re-typing "Hulu" in Add Brand By Name returned zero exact-match results (verified via DOM query for `.al-typeahead__option` text === "Hulu") | PASS |
| 4 | Brands display in order added | `document.body.innerText` shows "Hulu\nWeekly Social Recap..." at index 121, "Conan\nWeekly Social Recap..." at index 3437 — Hulu section precedes Conan section | PASS |
| 5 | Page break after every brand (Print Preview) | Stylesheet rule confirmed: `@media print { .app-wrapper .page { break-inside: avoid; break-after: page; } }`. Downloaded PDF has 4 pages (`/Count 4`) for a 2-brand report, consistent with each brand spanning its own page(s). Only page 1 was rasterized (tooling limits — see below), so the exact page 2/3 boundary wasn't visually confirmed. | PASS (CSS rule + page count consistent); page-boundary not visually rasterized |
| 6 | New sidebar + header per brand | DOM has 10 `[class*=sidebar]` elements carrying brand text — 5 tagged "Hulu", 5 tagged "Conan", in that order | PASS |
| 7 | Downloaded report matches generated report | Downloaded PDF `Hulu-Weekly Social Recap(Jun 23, 2026 - Jun 29, 2026).pdf` (4.7MB, `Producer: jsPDF 3.0.1`). Page 1 rasterized via `qlmanage -t`: header "Hulu / Weekly Social Recap (Jun 23, 2026 - Jun 29, 2026)", Social Footprint bars (6,201,187 / 6,200,000 / 2,990,629 / 2,680,000 / 2,416,356), Social Activity donuts "927K Public Impressions -36% YOY / 145K New Followers +643% YOY / 3M Engagements +93% YOY / 121M Video Views +169% YOY" — **verbatim match** to the in-app preview text captured before download | PASS |

**Overall: 6/7 PASS, 1 informational (URL path naming differs from spec wording — not a functional defect).**

## Bugs / findings

- **LFMP-31798 (Major, Open, carried forward — RE-OBSERVED).** In the rasterized page 1, the YOY change indicators next to each donut (`-36% YOY`, `+643% YOY`, etc.) render as small colored squares rather than clear ▲/▼ triangle glyphs. Consistent with the previously-documented jsPDF glyph-rendering defect from this same skill's prior runs. Not re-filed (already open).
- **Tooling limitation this run:** `poppler` (`pdftoppm`/`pdfinfo`/`pdftotext`) is not installed on this machine, so the `pdf-end-to-end-verification` skill's documented pipeline couldn't be used verbatim. Substituted macOS `qlmanage -t -s 1200` (built-in Quick Look) for a page-1 PNG thumbnail, and `strings | grep` for `/Producer` and `/Count` (page count) in place of `pdfinfo`. This only gives page 1 — pages 2–4 (Conan's section + any mid-report page-break boundary) were not visually rasterized. Recommend installing `poppler` (`brew install poppler`) on this machine for full multi-page verification in future runs.

## Cleanup
No mutating actions — Social Recap report generation is non-destructive (creates a persisted `report_id` but no test data/tags requiring cleanup), consistent with prior runs of this skill.
