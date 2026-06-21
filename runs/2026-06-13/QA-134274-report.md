# QA-134274 — Brand > Content - pill add/remove, Clear All, Save/Load filter — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram
- **Skill:** brand-content-filter v2 · **Result:** ✅ PASS

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Tag pill add → URL filters JSON | Adding a tag serializes to URL | `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"}]}` | ✅ |
| Filter UI | Include/Exclude radios + Or/And + Select All/None + Save/Load Filter present | All present in Tag sub-panel | ✅ |
| Clear All / Save/Load | Clear All + Save/Load Filter affordances | Present in filter row (Load Filter / Save Filter / Clear All) | ✅ |

## Bugs filed
_None._
