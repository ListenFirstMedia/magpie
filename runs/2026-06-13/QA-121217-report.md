# QA-121217 — Brand > Content - Instagram - Collaborator count - Export — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** Instagram · **Window:** May 13 – Jun 12 2026 (Collaborated Total=1 filter)
- **Skills:** brand-content-filter, export-csv v2
- **Result:** ✅ PASS — **upgrades prior 2026-06-05 BLOCKED** (Hulu had no collaborated posts; MTV has 29)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Collaborator count exportable | Export includes IG Collaborator count | CSV (200, 29 rows) header has **Instagram Collaborator Count** + **Instagram Collaborator Name** | ✅ |
| Count populated for collaborated posts | Non-empty count on collaborated rows | All **29/29** rows have a non-empty/non-zero Instagram Collaborator Count | ✅ |

## Bugs filed
_None._

## Cleanup
- Export queued (notification, harmless). No mutations.
