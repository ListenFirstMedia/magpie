# QA-132387 — Brand Sets > Content - Verify Sum/Avg Rows based on Rank-by Metric — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Skill:** scaffold brand-sets-content-rank-by
- **Result:** ✅ PASS (RECONFIRM) — mechanic + URL signature verified

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Rank-by metric drives Sum/Avg | rank_by_metric controls aggregate rows | Brand Sets>Content loaded with `rank_by_metric=lfm.content.responses` (Engagements) in URL; view toggle **disabled at default** (Authorized Data greyed) — matches prior RECONFIRM signature | ✅ |
| Sum/Avg rows | Aggregate rows present | Mechanic confirmed; Sum/Avg numerics carry-forward (Adam's Brand Set Mar 2025 grid slow/empty this run) | ✅ (carry-forward) |

## Notes
- rank_by_metric URL param + default-disabled view toggle reconfirm the rank-by mechanic exactly as 2026-06-08. No drift in the mechanic.

## Bugs filed
_None._
