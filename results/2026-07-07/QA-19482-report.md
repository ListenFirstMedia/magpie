# QA-19482 — TWC - Verify PDF

- **Run date:** 2026-07-07 (interactive recovery run — was 900 s timeout/no-report in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19482 · Priority: Minor
- **Verdict:** **PASS (best-effort; headless limitation noted)** — both report runs' Preview & Share print-previews render all sections, no empty pages, and no visibly broken images. "No broken links" is not fully verifiable in a headless browser (see limitation).
- **Account:** Viacom · **Skills:** switch-account, time-window-comparison-run

## Open linked bugs
None open (cache 2026-07-03) — ran normally.

## Runs
- **Run 1:** MTV · Last 7 Days · Facebook (All On, 24/47 authorized) · Show Metrics Graphs, Show Metrics Tables, Set Brands as Rows, Show Change, Show Share → Run → Preview & Share.
- **Run 2:** + All NBA brand · Facebook **and** Twitter (All On) · Interleave Graphs & Tables, Show Cohort Average (label "Cohort Average"), Highlight Leader, Show Source Links, Show Insights Editor → Run → Preview & Share.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 9a | All sections + format match report output (Run 1) | Preview shows MTV-branded pages with the metrics **graphs** then **tables** (Set Brands as Rows), matching the on-screen report | ✅ PASS (best-effort) |
| A2 | 9b | No empty pages (Run 1) | Full-page capture is content-filled across all pages; no blank pages | ✅ PASS (best-effort) |
| A3 | 9c | No broken images or links (Run 1) | MTV logo + ListenFirst logo render (no broken-image placeholders); charts render | ◐ PASS w/ limit (link-integrity not headless-verifiable) |
| A4 | 14a | All sections + format match (Run 2) | Preview shows **interleaved graphs & tables** (Interleave option) for Facebook + Twitter across MTV & All NBA, with leader-row highlight | ✅ PASS (best-effort) |
| A5 | 14b | No empty pages (Run 2) | Long multi-page doc content-filled throughout; no blank pages | ✅ PASS (best-effort) |
| A6 | 14c | No broken images or links (Run 2) | Brand logos render; no broken-image placeholders | ◐ PASS w/ limit (link-integrity not headless-verifiable) |

Per spec note: page-content-split-across-pages is NOT a bug — not flagged.

## Evidence
- `.playwright-out/QA-19482/run1-preview.png` — Run 1 print-preview (full page): MTV header, Facebook graphs + metric tables.
- `.playwright-out/QA-19482/run2-preview.png` — Run 2 print-preview (full page, ~55k px): interleaved graphs/tables, Facebook+Twitter, MTV + All NBA, leader highlight.
- `.playwright-out/QA-19482/report-top.png` — preview overlay header (Share/Download), MTV logo rendering.

## Limitation (headless)
"No broken **links**" (A3/A6) cannot be definitively verified in a headless browser — I can confirm images render and pages are non-empty from the preview capture, but link-target integrity in the generated PDF would need a human/manual PDF open. Flagged per the best-effort agreement.

## Why this recovered (vs 2026-07-04 BLOCKED)
Unattended run hit the 900 s watchdog (this is an extremely long flow: 2 full TWC builds + channel/option setup + 2 print-preview generations). No product issue — a per-case time-budget limit. Driven interactively with no timeout, both previews generated and rendered.

## Bugs filed
None.
