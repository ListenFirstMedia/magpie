# QA-134517 — Reporting > Data Studio - Verify layered tag filtering (Include + Exclude) — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** data-studio-post-level-run, brand-content-filter
- **Result:** ✅ PASS — **UPGRADE from prior FAIL** (Include/Exclude now present)

## Steps
1. Reporting → Data Studio → **Post Level** → **Filters → Tag**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| DS tag filter has Include/Exclude | Layered Include + Exclude controls | **Include / Exclude radios present** (Include default) | ✅ |
| Or/And logic | Or/And operator radios | **Or / And radios present** (Or default) | ✅ |
| Tag list | Selectable tags + Select All/None | Select All / None + tag checkboxes (000, 02-09-2022, 024blcfk_qa_3437, 0enl_qa_3389, …) | ✅ |

## Notes / automation learning
- **This was a FAIL in the prior run** ("Data Studio tag filter missing Include/Exclude" — see `lf-open-bug-status` / 2026-06-02 QA-4325 cumulative). It is **now FIXED**: the DS Post-Level Tag filter exposes the full layered structure (**Include/Exclude + Or/And + Select All/None + tag list**), matching Brand>Content. Layered Include+Exclude tag filtering is supported in Data Studio.
- Recommend marking the prior QA-134517 FAIL **resolved** and closing any associated bug.

## Cleanup
- Filter not applied / not saved (session-only). No mutation.

## Bugs filed
_None — prior FAIL now resolved._
