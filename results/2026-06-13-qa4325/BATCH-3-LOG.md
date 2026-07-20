# QA-4325 — Batch 3 Log — 2026-06-13

Cases #11–15 of the 56-member set. Fresh tab per batch; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 11 | QA-19486 | Social Recap — Verify PDF download | ✅ PASS | MTV Weekly Recap (Jun 9–15); blob `%PDF-1.3`, 2,157,712 bytes, 2 pages |
| 12 | QA-28405 | Content CSV — Video Views data set | ✅ PASS | MTV; CSV 124 rows/29 cols, "Video Views" col populated (49/50 sampled >0) |
| 13 | QA-43914 | FB User Accounts (Radaac) | ⛔ BLOCKED-safety | Radaac → Cognito login; never enter credentials (carry-forward) |
| 14 | QA-48160 | Settings > Brands — Edit | ✅ PASS | Edit Brand wizard opens, Basic Info prefilled, stepper OK, cancelled clean |
| 15 | QA-51442 | Brand>Stories — Impressions tile PNG | ⛔ BLOCKED (MCP artifact) | Trend-tile chart won't render under Chrome MCP (3 attempts); PNG menu present, data layer correct (Impr Sum 1,248,958). Not a product defect. |

**Batch tally:** 3 PASS · 0 FAIL · 2 BLOCKED (1 safety, 1 MCP-artifact).

**Environment events:**
- **Brand>Insights renderer hang recurred** on the first MTV Insights load (CDP `Runtime.evaluate`/screenshot/tab-close all timed out >45s) → recovered via fresh tab + abandoned the frozen tab. Same known blocker as QA-22296 run.
- Social Recap & Content brand typeaheads both needed the ref-focus-click + backspace/retype trick (coordinate typing leaves field unfocused).
- Content CSV export is async; captured via anchor-click hook + in-page fetch.
