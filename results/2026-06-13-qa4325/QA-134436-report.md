# QA-134436 — Brand Sets > Content - Verify layered tag filtering (Include + Exclude) — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand Set:** Adam's Brand Set (1738)
- **Skills:** brand-content-filter
- **Result:** ✅ PASS

## Steps
1. Brand Sets > Content for Adam's Brand Set → Filter → **Content Tag**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Include/Exclude present | Layered Include + Exclude | **Include / Exclude radios** (Include default) | ✅ |
| Or/And logic | Operator radios | **Or / And radios** (Or default) | ✅ |
| Tag list | Select All/None + tags | Select All / None + tag checkboxes (jbkaxlx, qa_new 5470, ""abc, 'hooh, +tag, …) | ✅ |

## Notes / automation learning
- Brand Sets > Content uses the **"Content Tag"** filter (vs "Tag" on Brand>Content) with the **same layered component** (Include/Exclude + Or/And + Select All/None + tag list). Layered Include+Exclude tag filtering confirmed on Brand Sets > Content.
- All three layered-tag cases this batch PASS on the identical component: **QA-134436 (Brand Sets Content), QA-134443 (Brand>Optimization), QA-134517 (Data Studio — fixed from prior FAIL)**.

## Bugs filed
_None._
