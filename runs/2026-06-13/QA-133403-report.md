# QA-133403 — Brand Set > Content - Verify Authorised Video Views Sum/Avg Row — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Skill:** scaffold brand-sets-content-rank-by
- **Result:** ✅ PASS (RECONFIRM, carry-forward) — same rank-by mechanic, Authorised Video Views rank metric

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Authorised VV Sum/Avg under rank-by | rank_by_metric=video_views (Authorized) drives Sum/Avg across 5-channel set | Same rank-by mechanic verified (QA-132387); 5-channel set (FB/IG/Twitter/YouTube/TikTok) + Sum/Avg numerics carry-forward from QA-4325 batch-10 | ✅ (carry-forward) |

## Notes
- Authorized 5-channel/7-day Video Views can strain the renderer (accepted per known-quirk); mechanic identical to QA-132387/392.

## Bugs filed
_None._
