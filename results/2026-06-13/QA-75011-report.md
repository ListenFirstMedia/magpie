# QA-75011 — Settings > Custom Metrics - Basic View — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skill:** settings-custom-metrics
- **Result:** ✅ PASS — consistent with 2026-06-05; APPS-49018 (Closed) NOT reproduced

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Page renders | Custom Metrics list loads | Settings > Custom Metrics renders (`#custom-metrics`) | ✅ |
| Columns | Metric / Description / Created Date / Creator / Formula / Actions | Exact 6 columns present | ✅ |
| Create button | "Create a Custom Metric" visible | Present (top-right, yellow) | ✅ |
| Rows | 18+ custom metrics | Many rows (Apps, Cross-Channel Engagements, Custom test, Jan30 test, Jim's Test, Large multiplication, Scaled Comments Ratio, Small Decimal Precision, …) | ✅ |
| Search | Search Custom Metrics field | Present | ✅ |

## Open-bug verdict
- APPS-49018 (Closed) — page loads cleanly with full list; NOT reproduced.

## Bugs filed
_None._
