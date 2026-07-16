# QA-135430 — Settings > Custom Metrics - Delete Functionality (MUTATING)

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major (MUTATING — create + delete, self-cleaning)
- **Account:** Adam Orfei (account_id=54) · Settings > Custom Metrics (`#custom-metrics`)

## Verdict: PASS (metric created, deleted, and cleanup verified)

## Known bugs checked
Linked QA-75010 (test plan), APPS-60509 (test-case task, Closed). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Test metric created; appears in listing with correct name | created **"QA-135430-rerun-0738"** (formula `Post Shares + 500`, description "QA-135430 delete test metric"); success popup **"Custom metric successfully created"**; row appears in the listing with the correct name + description | PASS |
| A2 | Row-actions Delete option present | row ellipsis (`al-table__action` fa-ellipsis-h) → menu shows **Edit** + **Delete** (`option--delete`) | PASS |
| A3 | Confirmation dialog appears with metric name | dialog: *"Are you absolutely sure you want to delete your custom metric **"QA-135430-rerun-0738"**? Click "Ok" to continue."* + Cancel / Ok | PASS |
| A4 | Metric removed from listing after confirm | after clicking **Ok**, the row is removed from the listing (name no longer present) | PASS |
| A5 | Removal persists after page refresh (cleanup verified) | after `location.reload()`, **no QA-135430 metric remains** in the listing | PASS |

## Method notes
- A valid custom-metric formula requires a complete expression: a lone metric or lone constant leaves **Save disabled**. Built `Post Shares + 500` (metric + operator + constant).
- Formula-builder operator submenu (Operators ▶) is a **hover flyout** whose leaves render as **icons** (`i.fa-regular.fa-plus/minus/times/divide`), not text — hover the `.menu-item` row, then trusted-click the icon leaf (`.menu-item` with empty text + `i.fa-plus`). Metric operands added via typeahead (type name → click `.menu-item-content-view` match). Grammar enforced: after a metric/constant only Operators enabled; after an operator, Operators disabled.
- **MUTATION CLEANUP:** the created metric was deleted as the test's own subject and confirmed absent after refresh — no `QA-135430-*` metrics remain.

## Bugs filed
None.
