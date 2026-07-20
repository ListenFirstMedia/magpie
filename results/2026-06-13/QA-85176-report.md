# QA-85176 — Settings > Custom Metrics - Create Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skill:** settings-custom-metrics
- **Result:** ✅ PASS — consistent with 2026-06-05 RECONFIRM (no mutation — Cancelled)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Create form opens | "Create a Custom Metric" → New Custom Metric form | `#custom-metrics/create`: Name, Description, "Configure your metric formula", Cancel/Save (Save disabled until valid) | ✅ |
| Name input works | Accepts metric name | Typed `QA-85176-verify-0613` | ✅ |
| Formula builder | Metrics / Constant(s) / Operators / Parentheses selectors | Dropdown shows **Metrics ▸ / Constant / Operators ▸ / Parentheses ▸** | ✅ |
| Cancel | Returns to list without saving | Cancel → `#custom-metrics` list, no metric created | ✅ |

## Notes
- Copy drift persists: the formula-builder option reads **"Constant"** (singular) while related UI/Save copy uses "Constants" — minor, carry-forward from prior.

## Cleanup
- None — Create cancelled, no custom metric persisted.
