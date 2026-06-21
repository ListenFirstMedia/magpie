# QA-135429 — Settings > Custom Metrics - Edit functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skill:** settings-custom-metrics · **Result:** ⚠️ PARTIAL (consistent with 2026-06-08)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Edit menu opens Edit form | Row Actions (…) → Edit → `#custom-metrics/edit?report_id=74`, header "Edit Custom Metric" | ✅ |
| A2 | Form prefills name/description/formula | Name **Apps**, Description **Test**, formula chips prefilled: ( Comments + Comments ) + 200 + ( Comments + Engagements + Engagements ); "max limit of metric selection" note | ✅ |
| A3/A4 | Modify + Save persists | **DEFERRED (safety)** — "Apps" is another user's metric ("do not rename or modify"); not mutated. Cancelled (no save) | ⚠️ DEFERRED |

## Notes
- **Breadcrumb quirk persists:** Edit page breadcrumb reads "… > New Custom Metric" while the header correctly reads "Edit Custom Metric" (cosmetic, carry-forward).

## Cleanup
- Cancelled — no metric modified.

## Bugs filed
_None._ (Breadcrumb New-vs-Edit cosmetic only.)
