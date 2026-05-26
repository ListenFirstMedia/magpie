# QA-19482 — TWC - Verify PDF (Print Preview)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19482
- **Run date:** 2026-05-20
- **Env:** dev (`app-reporting.lfmdev.in`)
- **Account:** Viacom
- **Priority:** P4 (Minor)
- **Result:** ✅ **6/6 PASS (A1-A6)**
- **Rules applied:** All 6 from `_shared/spec-adherence-rules.md`

Note: per spec, "Verify PDF" here uses the on-screen print preview (Preview & Share → review). No actual PDF download required.

## Run 1 — MTV, FB All On, basic table options

Story ID: 153480
URL: https://app-reporting.lfmdev.in/#story/time_window_comparison/153480

### Steps executed
| Step | Action | State |
|---|---|---|
| 1-2 | Reporting → Time Window Comparison | ✓ |
| 3 | Add Brand By Name → typed "MTV" → selected "MTV" (exact match per Rule 1) | ✓ |
| 4 | Date Range: Absolute Dates → Make a Selection: Last 7 Days → May 12-18, 2026 | ✓ |
| 5 | Select Channel Data → By Channel tab → Facebook → All On (Public Data: 24/47 metrics selected) | ✓ |
| 6 | Options → Graph Options: Show Metrics Graphs ✓ (default); Table Options: Show Metrics Tables ✓ (default), Set Brands as Rows ✓, Show Change ✓, Show Share ✓ | ✓ |
| 7 | Run Report → URL `/story/time_window_comparison/153480` | ✓ |
| 8 | Preview & Share Report | ✓ |
| 9 | Scrolled through preview top-to-bottom (~22,350px) | ✓ |

### Assertion results
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 9a | All sections + format match report output | Preview matched on-screen report: MTV cover page with brand metadata (TV Network, Manufacturer: MTV, MTV [P] indicator), Facebook section header, Facebook Total Fans chart line ~45M, Facebook posts/comments/reactions/sads chart sections, page breaks between sections, ListenFirst logo on every page top-right, MTV brand logo on cover | ✅ PASS |
| A2 | 9b | No empty pages | All scrolled pages contained content (charts, tables, or section headers). Page boundaries (dashed blue page-break lines) separated content, no truly blank pages | ✅ PASS |
| A3 | 9c | No broken images or links | MTV brand logo rendered. ListenFirst logo rendered on every preview page. All chart graphics rendered (line charts for Total Fans, Posts, Comments, Reactions, Sads, etc.). No broken-image icons or 404 placeholders | ✅ PASS |

## Run 2 — MTV + All NBA, FB+Twitter All On, full options

Story ID: 153481
URL: https://app-reporting.lfmdev.in/#story/time_window_comparison/153481

### Steps executed
| Step | Action | State |
|---|---|---|
| 10 | Change Settings → Add Brand By Name "All NBA" → selected "All NBA" (exact match per Rule 1) | ✓ |
| 11 | By Channel → Twitter → All On (Public Data: 21/70 metrics selected; FB still 24/47 from Run 1) | ✓ |
| 12 | Options → General checked: Interleave Graphs & Tables ✓, Show Cohort Average ✓ (Label="Cohort Average" default), Highlight Leader ✓, Show Source Links ✓, Show Insights Editor ✓ | ✓ |
| 13 | Run Report → URL `/story/time_window_comparison/153481` | ✓ |
| 14 | Preview & Share Report | ✓ |
| - | Scrolled through preview top-to-bottom (~55,614px — much longer due to 2 brands × 2 channels × all metrics + interleave + tables + source links) | ✓ |

### Assertion results
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 14a | All sections + format match | Preview matched on-screen report: MTV cover (Type=TV Network, Manufacturer=MTV, Competitors: All NBA, Legend: MTV [P], All NBA [P], Cohort Average gray); Insights Editor "Insights about your brand:" editor box rendered (Show Insights Editor effective); Facebook section + all metric pages; Twitter section + all metric pages; interleaved graphs and tables (Show Metrics Graph followed by Show Metrics Table for each metric); per-cell yellow highlighting on dominant brand values (Highlight Leader effective); Source Links table at end | ✅ PASS |
| A5 | 14b | No empty pages | All ~ 50+ preview pages contained graph or table content. Source Links page was the last and was fully populated | ✅ PASS |
| A6 | 14c | No broken images or links | MTV logo rendered. ListenFirst logo on every page. All chart graphics rendered for both brands. Source Links Profile column rendered as clickable links: https://www.facebook.com/MTV, https://twitter.com/MTV, https://twitter.com/ALLCITY_NBA | ✅ PASS |

## Source Links observed (Run 2)
| Brand | Channel | Profile URL |
|---|---|---|
| MTV [P] | Facebook | https://www.facebook.com/MTV |
| MTV [P] | Twitter | https://twitter.com/MTV |
| All NBA [P] | Twitter | https://twitter.com/ALLCITY_NBA |

## Highlight Leader sample row (Run 2 bottom table)
| Metric (last row visible) | MTV | All NBA |
|---|---|---|
| ... | 0.00% | **100%** (highlighted) |
| ... | 22% | **78%** (highlighted) |
| ... | 0.00% | **100%** (highlighted) |
| ... | **100%** (highlighted) | 0.00% |
| ... | **96%** (highlighted) | 4% |
| ... | – | – |

Yellow background indicates the "leading" cell per Highlight Leader option.

## Cohort Average legend
The third legend item (gray square) "Cohort Average" appeared throughout. Per QA-126530 / TWC Cohort Avg flow already validated, this is correctly an overlay line in the multi-brand charts.

## Skill use
- Existing: `time-window-comparison-run` (Brand add + perspective + options + Run)
- Existing: `switch-account` (Viacom switch)
- Existing: `keydate-picker` was NOT used (this test used Absolute Dates + Make a Selection: Last 7 Days, not Key Date)
- React-aware input setter pattern (from `brand-content-tag-post` skill v1) used for brand search

## Notes
- Spec note acknowledged: "page-content-split-across-pages is NOT a bug" — observed multiple sections split across page boundaries in both runs; not flagged.
- Public Data only: many metrics greyed out (require Authorized Data). 24/47 FB and 21/70 Twitter selected. This is platform behavior, not a bug.
- Both runs completed without errors. URL parameters captured for reproducibility.

## Bugs filed
None.
