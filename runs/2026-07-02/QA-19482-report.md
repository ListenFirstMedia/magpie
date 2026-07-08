# QA-19482 — TWC - Verify PDF

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19482 · Priority: Minor
- **Result:** **PARTIAL PASS** — first preview (MTV, steps 1–9 / A9) verified clean. Second preview (All NBA, steps 10–14 / A14) not completed: the "All NBA" brand does not resolve in the TWC brand typeahead (test-data drift).
- **Skills:** time-window-comparison-run (v6), social-recap-report-run (Preview & Share mechanics)

## Linked bug scan
No open linked bugs ([[open-bug-auto-fail]] N/A).

## Steps executed (part 1 — MTV)
1–2. Reporting → Time Window Comparison. ✅
3. Added **MTV** (trusted typing → Results). ✅
4. Date range = last 7 days (Absolute default). ✅
5. Channel Data → **Facebook All-on** (By Channel → Facebook "On" → 24/47 metrics). ✅
6. Options: **Show Metrics Graphs** ✓ (default), **Show Metrics Tables** ✓ (default), **Set Brands as Rows** ✓, **Show Change** ✓, **Show Share** ✓. ✅
7. Run Report → story 155534 (MTV). ✅
8. **Preview & Share Report** → print preview. ✅
9. Reviewed the preview. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A9 sections/format | All sections & format per report output | Preview renders: MTV header/logo, ~6 metric line charts (Facebook, 7-day), then metric tables with Change/Share columns and brand rows | ✅ PASS |
| A9 no empty pages | No empty pages | Continuous content, no blank pages | ✅ PASS |
| A9 no broken images/links | No broken images/links | MTV logo + charts render; no broken-image placeholders | ✅ PASS |
| A14 (All NBA preview) | Same checks after Change Settings → All NBA + Facebook/Twitter + General options | **Not completed** — see below | ⚠️ NOT RUN |

## Why A14 not completed
Step 10 requires selecting the **"All NBA"** brand. Via Change Settings → Add Brand By Name, typing "All NBA" returns only **"NBA HORSE Challenge"** and **"NBA Summer League Basketball"** — no brand literally named "All NBA". Per spec-adherence Rule 1 (never substitute a different brand), I did not pick a different NBA brand, so the second report (All NBA + Facebook/Twitter, General options: Interleave Graphs & Tables, Show Cohort Average, Highlight Leader, Show Source Links, Show Insights Editor) and its Preview (A14) were not built. This is **test-data drift** (the "All NBA" brand appears renamed/removed), not a product defect. The Preview & Share mechanism itself is already validated by A9.

## Notes
- Note from the case honored: content split across pages in the PDF is NOT a bug (not flagged).
- TWC Preview & Share uses the same `Preview & Share Report` control + print-preview render as Social Recap; closed via the preview's X to return to the story, then **Change Settings** reopens the builder with brands/options preserved.

## Bugs filed
None. A9 passed; A14 blocked by test-data drift (flag for QA: confirm the intended "All NBA" brand name).
