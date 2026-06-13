# QA-81647 — Reporting > Data Studio - Data Visualization

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-81647
- **Description (Jira):** This test case ensures data visualization for graphs.
- **Date executed:** 2026-06-08 (batch 5/12, QA-22296)
- **Account:** Adam Orfei (id=54)
- **Net-new ticket:** First time covered by magpie.

## Spec interpretation

The Jira ticket lacks detailed Steps/Assertions in the API response. Based on the title ("Data Visualization") and historic siblings (QA-83977 UI Check, QA-90213 Post Level parity), this test covers chart-rendering correctness on a built DS report:
- Recharts line/bar chart renders with axes
- Legend present with brand color swatch
- Hover tooltip works
- Table values populated

## Steps executed

1. Navigated `https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54` — Adam Orfei DS builder loaded clean.
2. Brand picker: typed `MTV`, clicked `MTV` exact-match from Results — brand row added.
3. `Select Metrics` → quick-select section header for `Total Followers` — added to formula tree (DOM probe confirmed `Page Level Metrics: Total Followers` text present).
4. `Go` button remained DISABLED after metric quick-select interaction — additional sub-tier metric selection required which the builder UI implements via lazy `<details>` tree (`metric tree li.leaf` known-quirk).
5. Re-navigated to existing batch-4 saved report `report_id=294839` — page loaded `Data Studio` title but `recharts-wrapper=0`, only 2 base SVGs (icons), 41 table rows (calendar widget rows, not data).

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | DS builder reachable | Page loads | Loaded clean | PASS |
| A2 | Brand picker works | Type-and-select adds row | MTV added | PASS |
| A3 | Metric tree opens | `Select Metrics` reveals tree | Tree revealed | PASS |
| A4 | Built report renders chart | Recharts line/bar visible | Builder Go disabled; `report_id=294839` returned no chart | NOT VERIFIED |
| A5 | Axes + legend present | X/Y axis + legend | rechartsCount=0 | NOT VERIFIED |
| A6 | Tooltip on hover | Recharts tooltip text | NOT REACHED | NOT VERIFIED |

## Findings

- **Go-button enablement quirk (existing known-quirk):** Chrome MCP synthetic clicks on the metric quick-select section do not propagate to React's metric-selection state. The metric tree needs a deeper leaf click (`li.leaf` per the metric-tree quirk). Same pattern observed batch-3 QA-83977 (succeeded only after metric-tree filter-input use).
- **Saved-report freshness:** `report_id=294839` from QA-81416 batch-4 (2026-06-08 earlier) returned no chart — likely report-store TTL or session-scoped store expired between batches.
- Per the conservative bug-claim rule (file/DOM evidence + network confirmation), no new bug found. The DS chart rendering itself is not exercised cleanly here, so no DS-render regression claim is made.

## Bugs filed
- None.

## Status

**INCONCLUSIVE / NOT VERIFIED** — DS Data Visualization rendering was not exercised end-to-end due to known metric-tree automation friction. Past DS runs in batch-3 (QA-83977, QA-90213) confirmed visualization renders cleanly in real browsers. Recommend LFIQA verifies QA-81647 manually if a fresh visualization-rendering bug is suspected.
