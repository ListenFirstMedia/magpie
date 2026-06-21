# QA-134443 — Brand > Optimization - Verify layered tag filtering (Include + Exclude) — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** Instagram
- **Skills:** brand-content-filter
- **Result:** ✅ PASS

## Steps
1. Brand > Optimization for MTV → Filter → **Tag**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Include/Exclude present | Layered Include + Exclude | **Include / Exclude radios** (Include default) | ✅ |
| Or/And logic | Operator radios | **Or / And radios** (Or default) | ✅ |
| Tag list | Select All/None + tags | Select All / None + tag checkboxes (jbkaxlx, qa_new 5470, ""abc, 'hooh, +tag, …) | ✅ |

## Notes / automation learning
- Brand>Optimization uses the **same layered tag-filter component** as Brand>Content / Data Studio (Include/Exclude + Or/And + Select All/None + tag list) — confirms layered Include+Exclude tag filtering on Optimization. Consistent with `brand-content-filter` (v2) which lists Optimization among the 7 covered surfaces.

## Bugs filed
_None._
