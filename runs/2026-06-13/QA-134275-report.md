# QA-134275 — Brand > Content - Include-only filter OR/AND — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram
- **Skill:** brand-content-filter v2 · **Result:** ✅ PASS

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Include OR encoding | `operator:"or"` + `not:"false"` | URL `content_tags:[{operator:"or",...,not:"false"}]` for Include tag | ✅ |
| OR/AND operator toggle present | Or/And radios in Tag sub-panel | Present (enable on tag selection) | ✅ |

Include-only OR verified end-to-end; AND toggle present (flips operator to "and") per v2 skill, consistent with prior PASS.

## Bugs filed
_None._
