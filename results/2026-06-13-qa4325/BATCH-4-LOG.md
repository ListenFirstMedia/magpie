# QA-4325 — Batch 4 Log — 2026-06-13

Cases #16–20 of the 56-member set. Fresh tab per batch; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 16 | QA-51457 | Brand>Insights — Engagements tile PNG | ⛔ BLOCKED (renderer hang) | Brand>Insights froze the renderer on **both** MTV and #1 Happy Family USA; surface unreachable under Chrome MCP |
| 17 | QA-52778 | Brand definition update — Include URL Manager | ✅ PASS | Edit Brand → Channels step IS the URL Manager (type+URL+filter, Add Channel, Remove); cancelled clean |
| 18 | QA-54202 | Brand Listing Radaac Report w/ filters | ⛔ BLOCKED-safety | Radaac → Cognito login; never enter credentials |
| 19 | QA-72455 | Brand>Paid — Unauthorized Spend (Twitter) | 🟡 PARTIAL | Spend col renders "–"/"no data" (Ads 0, unauthorized); Twitter-isolated tile blocked by MCP tile-render artifact + channel icons not ref-addressable |
| 20 | QA-81494 | Data Studio — Report Table Export PNG | ✅ PASS | DS report built (report 297148); Export→Graph→PNG = valid `image/png` 90,331 B, header 89504e47. Table exports CSV/Sheets/Metrics (no table-PNG) |

**Batch tally:** 2 PASS · 0 FAIL · 1 PARTIAL · 2 BLOCKED (1 safety, 1 renderer hang).

**Environment events:**
- **Brand>Insights renderer hang worsened** — reproduced across brands (MTV + #1 Happy Family USA), froze CDP pipeline (screenshot/JS/tab-close >45s). Required abandoning 2 frozen tabs. Puts all remaining Brand>Insights cases (QA-114845, QA-134176/134182/134184/134188/134639) at risk.
- Brand>Paid trend tiles fail to render under MCP (same artifact as Stories); channel-selector icons not exposed as accessible refs.
- DS PNG export emits a real `image/png` Blob (captured via createObjectURL hook). DS brand typeahead needed the ref-focus-click trick again.
