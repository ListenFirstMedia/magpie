# QA-22296 Re-run — Batch 11/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-134445, QA-134446, QA-134447, QA-134636, QA-135429 (order 51–55)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-134445 | Brand > Partnerships - layered tag filtering | ✅ PASS | Tag filter present (same Include/Exclude widget) |
| QA-134446 | Brand > Stories - layered tag filtering | ✅ PASS | Tag filter present |
| QA-134447 | Brand > Paid - layered tag filtering | ✅ PASS | Tag filter present |
| QA-134636 | Listening - Data Last Updated Timestamp | ⚠️ PARTIAL | A1 PASS; A2 N/A — Listening is a live-query tool with no DLU timestamp |
| QA-135429 | Settings > Custom Metrics - Edit | ⚠️ PARTIAL | A1+A2 PASS (Edit form prefills Apps/Test/formula); A3+A4 DEFERRED (safety on others' metric); breadcrumb quirk |

## Headline
- 3 PASS, 2 PARTIAL (both consistent with prior; PARTIAL drivers are surface design + safety, not product bugs). No new product bugs.

## Cleanup
- No mutations (Edit cancelled, filters read-only).
