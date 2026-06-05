# QA-4325 Batch 4 Log

| Ticket | Result | Date | Account/Brand | Notes |
|---|---|---|---|---|
| QA-28405 | PASS | 2026-06-04 | Adam Orfei / Hulu | All Data Sets CSV verified end-to-end on disk; Video Views sum 26,449,739 = UI |
| QA-43914 | PASS | 2026-06-04 | Hulu + token 5001 | Radaac TSV downloaded; 9-column header verified; no file_format selector (deviation noted) |
| QA-48160 | PASS | 2026-06-04 | Adam Orfei / Alex Test 1 (422865) | Edit + cleanup revert verified; React-aware setter needed for Brand Name input |
| QA-51442 | PARTIAL | 2026-06-04 | Adam Orfei / MTV (Authorized, IG) | Export menu present (PNG/CSV/GS/Metrics); PNG blocked by NEW bug — Brand>Stories chart tiles fail-to-load across multiple date windows |
| QA-51457 | BLOCKED | 2026-06-04 | Adam Orfei / MTV+Hulu+Disney Channel (Standard) | Renderer hung on Brand>Insights across multiple brands+date windows; spec drift carryforward from QA-10387 (Trends-consolidated tile has no per-tile PNG export) |
