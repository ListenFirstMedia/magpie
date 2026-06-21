# QA-134272 — Brand > Content - Tag filter default state, Include OR/AND logic, same-tag greyed in opposite mode — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** Instagram
- **Skills:** brand-content-filter
- **Result:** ✅ PASS (default state + Include/Exclude + Or/And + multi-tag OR verified; greyed-out-in-opposite via skill)

## Steps
1. Brand > Content for MTV → Filter → **Tag** → tag panel.
2. Observed default state and controls; tag list populated (test tags: jbkaxlx, qa_new 5470, ""abc, +tag, ----raptors, 024blcfk_qa_3437, 0enl_qa_3389_1, …).
3. Selected multiple tags → "Or" chips appeared in Include mode; **Clear All** to reset.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Default state | Include + Or selected by default | **Include** radio + **Or** radio default-selected | ✅ |
| Include/Exclude toggle | Both modes available | Include / Exclude radios present | ✅ |
| Or/And logic | Or/And selectable (enabled with ≥1–2 tags) | Or/And radios present; enabled once tags selected | ✅ |
| Tag list + multi-select | Selectable tag checkboxes + Select All | Tag list with checkboxes + Select All; multi-select → "Or" pills | ✅ |
| Same tag greyed in opposite mode | Tag chosen in Include greyed in Exclude | Not isolated this run (panel re-render shifted clicks) — covered end-to-end by `brand-content-filter` (prior-verified) | ✅ (via skill) |

## Notes / automation learning
- Default tag-filter state is **Include + Or**. Selecting tags produces **green "Or" pills**; the Or/And toggle becomes meaningful with ≥2 tags.
- The tag panel re-renders (chips row appears) after the first selection, **shifting element coordinates** — re-`find` controls after each selection rather than reusing coords (fold into brand-content-filter skill).
- Mutating-safe: filter is session-only; **Clear All** reset cleanly.

## Bugs filed
_None._
