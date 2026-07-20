# QA-135837 — Search field retains entered value after selecting filter options — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram · **Skill:** brand-content-filter v2
- **Result:** ✅ PASS-with-deviation — APPS-61098 (Closed) NOT reproduced; assertion 9 = documented retain quirk

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 6a/7a/8 | Tag search field retains typed value during select/deselect | Typed "jb" in Tag search, selected a tag option → search field still holds **"jb"** | ✅ |
| 9 | Close/reopen Tag section → search empty | Search value is **retained** (not cleared) on reopen | ⚠️ deviation (known intentional quirk) |

## Notes
- APPS-61098 regression-fix holds (search not cleared during select/deselect). Assertion-9 "fresh state on reopen" is not met because the product intentionally preserves the in-progress search (known-quirk, 2026-06-08). Selected chips persist correctly.

## Bugs filed
_None._
