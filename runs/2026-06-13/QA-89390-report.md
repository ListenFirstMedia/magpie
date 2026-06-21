# QA-89390 — Dashboards - Brand Content Insights - Save filtered tiles to dashboard — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV
- **Result:** 🚫 BLOCKED this run (Brand>Insights renderer hang) — PASS carry-forward from 2026-06-05 RECONFIRM (via QA-88219)

## Execution
- Navigated Brand>Insights (MTV) to exercise the Save-to-Dashboard-with-filter flow. Tiles never rendered (skeleton); after reload the page **froze the renderer** (CDP `Runtime.evaluate` timed out >45s) — same Brand>Insights renderer-hang family seen on Brand>Video this session.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Filtered tile can be saved to a dashboard (Save to Dashboard → Create/existing) | Save preserves filter | NOT REACHED — Insights tiles never rendered (renderer hang) | 🚫 BLOCKED |

## Notes
- Mechanic **PASSED 2026-06-05** (RECONFIRM via sister test QA-88219 full create→save-filtered-tile→cleanup cycle). Today's block is environmental (Brand>Insights renderer hang), not a feature regression. Verdict carried forward.

## Bugs filed
- Strengthens Brand>Insights/Video renderer-hang finding (now frozen on Insights too). See known-quirks.
