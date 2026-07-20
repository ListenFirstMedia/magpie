# QA-104876 — Settings > Custom Data Sets - Delete Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skills:** settings-custom-data-sets, dashboard-mutation-flows
- **Result:** ✅ PASS (MUTATING + cleanup) — consistent with 2026-06-05

## Steps
1. Settings > Custom Data Sets → Create a Custom Data Set → name `QA-104876-del-0613`, metric Engagements → Create (listed: Jun 13 2026, LFQA Testing, Engagements).
2. Row Actions (…) → Edit / **Delete** / Duplicate → Delete.
3. Confirmation modal → Ok.
4. Reload (F5) → confirm removal.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Create works (precondition) | New CDS appears in list | `QA-104876-del-0613` created + listed | ✅ |
| Delete confirmation modal | Verbatim warning | "Delete" / **'Are you absolutely sure you want to delete your data set "QA-104876-del-0613"? Click "Ok" to continue.'** / Cancel · Ok | ✅ |
| Deletion persists | Removed after F5 | CDS absent from list after reload (`stillPresent:false`) | ✅ |

## Cleanup
- Self-cleaning: the created CDS was the one deleted. No residual test data. (One transient "Failed to generate the link" toast from a stray share-link icon click — not part of the delete flow.)

## Bugs filed
_None._
