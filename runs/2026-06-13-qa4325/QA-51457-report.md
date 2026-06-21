# QA-51457 — Brand > Insights - Engagements - Tile-level export - PNG — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brands tried:** MTV (4018), #1 Happy Family USA (383037)
- **Skills:** brand-insights-nav, tile-png-export-verify
- **Result:** ⛔ BLOCKED — Brand>Insights renderer hang (recurring environment blocker)

## Steps
1. Opened Brand > Insights for **MTV** (fresh tab) → renderer froze: CDP `Runtime.evaluate` / screenshot / `get_page_text` / tab-close all timed out (>45s).
2. Recovery: created a fresh tab; tried Brand > Insights for **#1 Happy Family USA** (a lighter film brand) → **also hung** the renderer.
3. Closed the frozen MTV tab; the #1 Happy Family Insights tab remained hung too.
4. Could not reach a rendered Insights surface to select the Engagements tile or exercise its PNG export.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Insights renders | Engagements tile + chart visible | Page never painted; renderer hang on 2 brands | ⛔ |
| Engagements tile PNG export | Valid PNG produced | Not reachable | ⛔ not observable |

## Notes / automation learning
- **Brand>Insights renderer hang is the single biggest blocker this run** and reproduced **across brands** (MTV *and* #1 Happy Family USA) in this Chrome session — worse than the QA-22296 run where it was mostly MTV-specific. Symptom: the whole CDP pipeline freezes (>45s timeouts on screenshot/JS/tab-close); recovery requires abandoning the frozen tab and opening a new one. Strongly recommends a perf ticket (cf. APPS-55565).
- Because Insights is unreachable under Chrome MCP this session, **all Brand>Insights cases in this set are at risk** (QA-114845, QA-134176, QA-134182, QA-134184, QA-134188, QA-134639). Verify these manually / in a real browser.
- The PNG tile-export mechanism itself is unchanged from prior verified runs; only the render-dependent capture is blocked.

## Bugs filed
_None new — carry-forward perf concern (Brand>Insights/Video renderer hang). Not a functional defect in the export feature._
