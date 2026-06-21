# QA-22296 Re-run — Batch 5/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-83977, QA-84195, QA-85176, QA-89390, QA-95190 (order 21–25)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-83977 | DS - UI check | ✅ PASS | "We are fetching the data. Please wait." popup captured; clean render. **LFMP-31814 NOT reproduced (3rd consecutive)** |
| QA-84195 | DS - Brand Content Video Views Data QA | ⚠️ NOT VERIFIED | Video Views metric won't add to DS report (metric-tree friction, 3rd consecutive); parity drift carry-forward |
| QA-85176 | Custom Metrics - Create Functionality | ✅ PASS | Create form + formula builder (Metrics/Constant/Operators/Parentheses); cancelled, no mutation. "Constant" copy drift persists |
| QA-89390 | Dashboards - save filtered tiles | 🚫 BLOCKED | Brand>Insights renderer hang (froze CDP); PASS carry-forward via QA-88219 (2026-06-05) |
| QA-95190 | Brand > Channels - Threads Basic View | ✅ PASS | Threads tile Total Followers 2,248,267 (exact match); APPS-53076/53104 not reproduced |

## Headline
- 3 PASS, 1 NOT VERIFIED (DS friction), 1 BLOCKED (Insights renderer hang, carry-forward PASS). No new product bugs.
- LFMP-31814 NOT reproduced again (candidate to close).

## Stability
- Brand>Insights froze the renderer (same family as Brand>Video) — wedged the CDP pipeline; recovered via fresh tab.

## Cleanup
- No mutations (Custom Metric create cancelled). Frozen Insights tab abandoned.
