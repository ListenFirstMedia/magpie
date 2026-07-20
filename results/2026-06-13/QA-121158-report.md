# QA-121158 — Brand Content - Instagram - Collaborated Total Filter — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** Instagram · **Window:** May 13 – Jun 12 2026
- **Skills:** brand-content-filter
- **Result:** ✅ PASS — **upgrades prior 2026-06-05 PARTIAL** (A5 now verified on MTV, which has collaborated IG posts). LFMP-31862 (Closed) NOT reproduced.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Collaborated Total filter option present (IG) | Filter list includes Collaborated, **Collaborated Total**, Collaborator Combined Followers, Collaborator Name… | ✅ |
| A2/A3 | Filter sub-UI with operator + values | Or/And radios + checkbox values 1–5 | ✅ |
| A4 | URL serializes the filter | `filters={"content_collaborator_count":{"operator":"or","values":["1"],"not":"false"}}` | ✅ |
| A5 | Apply returns collaborated posts | Collaborated Total = 1 → **Posts(29)** (non-empty; prior Hulu run was 0) | ✅ |

## Open-bug verdict
- LFMP-31862 (Closed) — Collaborated Total filter works end-to-end; NOT reproduced.

## Bugs filed
_None._
