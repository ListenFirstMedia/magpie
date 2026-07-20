# QA-22296 Re-run — Batch 9/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-131491, QA-132387, QA-132392, QA-133403, QA-134176 (order 41–45)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-131491 | Social Recap vs Content - IG Public Video View | ✅ PASS (RECONFIRM) | Exact match: Sum Eng 297,194 / VV 6,021,556; Post#1 VV 691,822 — no drift |
| QA-132387 | Brand Sets Content - Rank-by Sum/Avg | ✅ PASS (RECONFIRM) | rank_by_metric URL + default-disabled view toggle verified |
| QA-132392 | Brand Set Content - Impression Sum/Avg | ✅ PASS (RECONFIRM, carry-forward) | Same mechanic; Impressions numerics carry-forward |
| QA-133403 | Brand Set Content - Authorised VV Sum/Avg | ✅ PASS (RECONFIRM, carry-forward) | Same mechanic; 5-channel VV carry-forward |
| QA-134176 | Brand Insights - Auto Select Dates | ✅ PASS (RECONFIRM, carry-forward) | Not re-driven (Insights renderer hang); 3 prior separate-day passes hold |

## Headline
- 5 PASS (all RECONFIRM; QA-131491 freshly re-verified with exact match confirming the parity family has no drift). No new product bugs.
- Brand>Insights renderer hang again prevented fresh re-drive of the Insights-based RECONFIRM (QA-134176).

## Cleanup
- No mutations.
