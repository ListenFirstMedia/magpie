# QA-63603 — Settings > Tags > Content Tagged - Upload Tags — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** ⚠️ PARTIAL — spec/UI drift re-confirmed (Upload Tags affordance is NOT on Settings>Tags)

## Findings
| Check | Expected (spec) | Actual | Status |
|-------|-----------------|--------|--------|
| Settings>Tags loads | Tags list with Content Tagged | Page renders; toolbar Filter / Apply Filter / Load/Save Filter / Clear All / Export | ✅ |
| "Content Tagged" present | Content Tagged column | Present (`Content Tagged` in page) | ✅ |
| "Upload Tags" affordance | Upload Tags on Settings>Tags | **Absent** — no "Upload Tags" anywhere on Settings>Tags | ❌ (drift) |

## Finding (re-confirmed)
- The **Upload Tags** flow lives on **Brand>Content** (Tag dropdown → Upload Tags → Update Tag Modal, verified in QA-27292), **not** on Settings>Tags as QA-63603's title implies. Export dropdown here serves CSV + Google Sheets only. Same as 2026-06-05 — recommend spec rewrite or feature relocation decision.

## Bugs filed
- Spec/UI drift re-confirmed — product/spec triage.
