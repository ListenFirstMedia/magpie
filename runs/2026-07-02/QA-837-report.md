# QA-837 — Social Recap: Report - Multiple brands

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-837 · Priority: Minor
- **Result:** **PASS** — report generated for multiple brands, previewed, and downloaded; PDF matches the generated report.
- **Account:** Hulu (account_id=336) · **Brands added:** Hulu, then Conan (add-order)
- **Skills:** social-recap-report-run, pdf-end-to-end-verification

## Known bugs checked (pre-run)
- **LFMP-31918** (Open) — thumbnails missing for Conan IG image posts in PDF export. **Not reproduced:** page 4 (Conan "Best Performing Content") shows all 4 post thumbnails rendered, including image posts.
- **LFMP-31798** (Open) — donut YOY arrows render as □ boxes in export. **Not reproduced:** donut YOY indicators render normally (colored arrows + % values) on all pages.

## Steps executed
1. Switched account to **Hulu** (account_id=336). ✅
2. Reporting → **Social Recap** (`app-reporting.lfmdev.in/#/social_recap`). ✅
3. Added brands: **Hulu** then **Conan** (order confirmed via `.al-typeahead__option`). ✅
4. **Run Report** → generated story `#story/social_recap/155511`, title "ListenFirst: Social Recap > Hulu". ✅
5. Clicked **Preview & Share Report** (`.preview-and-share-btn`). ✅
6. Clicked **Download** (`.download-btn` in `.navigation-header`). ✅ → `Hulu-Weekly-Social-Recap-Jun-25-2026---Jul-1-2026-.pdf` (4 pages, 1.8 MB).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | URL updates to reporting story/template; template loads | URL → `#story/social_recap/155511`; report rendered (Social Footprint / Social Activity / Best Performing Content / YTD) | ✅ PASS |
| A2 | Primary/account brand not offered as a displayed add option | Add-brand typeahead did not offer the account's own primary; added Hulu + Conan as distinct options | ✅ PASS |
| A3 | Brands appear in add-order | Hulu section first, Conan section second (both preview + PDF) | ✅ PASS |
| A4 | Page break after each brand | PDF: Hulu = pp. 1–2, Conan = pp. 3–4; each brand starts a new page | ✅ PASS |
| A5 | New sidebar/header per brand | Each brand section starts with its own name/logo header (Hulu logo; Conan photo + Series/Network) | ✅ PASS |
| A6 | Downloaded report matches generated report | PDF donuts, metric tables, and Best-Performing-Content thumbnails match the on-screen preview | ✅ PASS |

## Evidence
- Preview screenshot: `qa837-preview.png` (Hulu then Conan, each with page break + header).
- PDF: `.playwright-out/Hulu-Weekly-Social-Recap-Jun-25-2026---Jul-1-2026-.pdf` → rendered `qa837-pdf-{1..4}.png`.
  - p.1 Hulu — Social Footprint (20,529,319 fans), Social Activity Jun 25–Jul 1 2026 (962K Public Impressions, 3M Engagements, 126M Video Views).
  - p.2 Hulu — Best Performing Content (5 posts) + Social Activity YTD.
  - p.3 Conan — Social Footprint (18,188,653 fans), Social Activity (6,850 Public Impressions, 2,708 New Followers, 209K Engagements, 8M Video Views).
  - p.4 Conan — Best Performing Content (4 posts, thumbnails present) + Social Activity YTD.

## Bugs filed
None. All assertions passed; the two open cosmetic export bugs (LFMP-31918, LFMP-31798) did not reproduce in this run.
