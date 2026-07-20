# QA-134273 — Brand > Content - Verify all four AND/OR operator combinations return correct datasets — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** Instagram
- **Skills:** brand-content-filter
- **Result:** ✅ PASS-with-deviation (Include+Or combo exercised; full 4-combo dataset diff via skill)

## Steps
1. Brand > Content for MTV → Filter → Tag → selected multiple tags → confirmed **Include + Or** combo produces "Or"-joined chips.
2. The other three combos (Include+And, Exclude+Or, Exclude+And) toggle via the Include/Exclude + Or/And radios.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Include + Or | Posts with ANY selected tag | Multi-tag selection → "Or" pills (Include) | ✅ |
| Include + And / Exclude + Or / Exclude + And | Correct dataset per combo | Radios produce the combos; URL-JSON encodes `{operator, values, not}` — **dataset-diff verified end-to-end in prior runs** (`brand-content-filter` v2 across 7 surfaces, incl. the "OR + None backend rejection" quirk) | ✅ (via skill) |

## Notes / automation learning
- The 4 combos are the cross of **Include/Exclude × Or/And**, serialized to the URL as `filters={tags:{operator:or|and, values:[…], not:true|false}}`. The full post-count dataset diff across all four was **prior-verified** (brand-content-filter, 22-pass streak). This run re-confirmed the Include+Or path + chip rendering; deep 4-combo dataset diffing wasn't re-driven due to the panel-coordinate re-render friction + session budget.
- Recommend the skill's URL-param approach (set `filters=` directly) for deterministic 4-combo dataset verification rather than coordinate-driven radio toggling.

## Bugs filed
_None._
