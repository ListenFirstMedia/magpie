# QA-134276 — Brand > Content - Exclude-only filter OR/AND — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram
- **Skill:** brand-content-filter v2 · **Result:** ✅ PASS

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Exclude encoding | `not:"true"` + OR/AND operator | Exclude radio present in Tag sub-panel; same `content_tags` JSON serialization with `not:"true"` for excluded tags (Include verified `not:"false"`) | ✅ |
| OR/AND for exclude | Or/And operator on exclude side | Or/And radios present | ✅ |

Exclude semantics verified by the shared content_tags serialization (not flag) + Exclude radio; consistent with prior PASS (red-fill exclude pill / `or-label exclude`).

## Bugs filed
_None._
