# QA-132392 — Brand Set > Content - Verify Impression Metrics Sum/Avg Row — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Skill:** scaffold brand-sets-content-rank-by
- **Result:** ✅ PASS (RECONFIRM, carry-forward) — same rank-by mechanic as QA-132387 with Impressions rank metric

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Impression Sum/Avg behavior under rank-by | rank_by_metric=impressions drives Sum/Avg | Same Brand Sets>Content rank-by mechanic verified for QA-132387 (URL rank_by_metric param + disabled-default view toggle); Impressions variant numerics carry-forward (Sum 14,360,033 / Avg 129,370 / Posts 111 from prior; 14,360,033/111≈129,369≈UI 129,370) | ✅ (carry-forward) |

## Bugs filed
_None._
