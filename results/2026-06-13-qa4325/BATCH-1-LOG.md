# QA-4325 Re-run — Batch 1/12 — 2026-06-13

- **Env:** Dev · **Members:** QA-298, QA-461, QA-529, QA-567, QA-569 (order 1–5) · Accounts used: Hulu (Yash), Adam Orfei, Michael Kors

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-298 | TWC Graphs - Hovering | ✅ PASS | Hulu; tooltip "Jun. 13, 2026 / Hulu: 965" |
| QA-461 | Data QA - Partnership - Graph Values | ✅ PASS-with-finding | Adam's Brand Set; big-numbers render (Sponsored Posts 9, Eng 345K); no "Branded Content: Yes" filter |
| QA-529 | FB Content - Mixed Auth - Impressions | ✅ PASS | MK / SS22 Roll-Up; Brand filter TB+MK, TB locks(8)+en-dash, MK data, FB Reel incl. |
| QA-567 | FB Lifetime Private Data QA | ⚠️ PARTIAL | Hulu dev FB Impressions render (Posts 48, all cols); stage parity N/A (no stage login) |
| QA-569 | FB In Window Private Data QA | ⚠️ PARTIAL | Same Hulu dev FB private feed renders; stage parity N/A |

## Headline
- 3 PASS (1 with finding), 2 PARTIAL (dev verified; stage-parity inherently un-runnable without stage login). No new product bugs.
- **Automation fix this batch:** brand/account typeahead requires a ref-based focus click (coordinate/value-setter leaves field unfocused, no Results). Saved to known-quirks + memory.

## Cleanup
- No mutations. TWC story 154786 created (harmless). Account left on Michael Kors.
