# Batch 2 re-run log — 2026-05-29

| Ticket | Result | Open bug verdicts | Next action |
|--------|--------|-------------------|-------------|
| QA-1124 | FAIL (upgrade from PASS) | LFMP-31781: REPRODUCED | Engineering — legend chip + tooltip Twitter icon use `rgb(29,161,242)` (legacy Twitter blue) instead of black X branding; Channels-row icon is correctly black, confirming local inconsistency. |
| QA-12532 | FAIL (upgrade from PASS) | LFMP-31903: REPRODUCED | Engineering — Avg. Engagements per Post tile PNG saves without `.png` extension; bytes are valid PNG. Other Partnerships tiles save correctly. |
| QA-2706 | PASS (same as prior) | LFMP-31886: NOT REPRODUCED | Verify with eng before closing the Jira — Owned Average Video Views cell shows `794,992(-31%)` with parentheses consistent across all 7 metric columns. |
| QA-98368 | BLOCKED | APPS-57985: NOT VERIFIED | LFIQA — HBO Max on Adam Orfei dev lacks both Threads and LinkedIn channels in the Brand>Content channel selector; cross-channel LinkedIn thumbnail check requires LinkedIn-enabled brand/account. |
| QA-96665 | BLOCKED (Chrome MCP hang) | LFMP-32027: NOT VERIFIED | LFIQA / engineering — Brand Insights with Last 6 Months range repeatedly froze the Chrome MCP renderer across multiple fresh tabs; Trends graph never reached visible state for overlap inspection. Likely the same OOM-ish stall documented in known-quirks for heavy Brand-Insights renders. |
