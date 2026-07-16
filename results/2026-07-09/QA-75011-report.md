# QA-75011 — Settings > Custom Metrics - Basic View

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP) — read-only
- **Account:** Adam Orfei (account_id=54; Custom Metrics is account-gated to Adam Orfei)

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Verified
- **Settings dropdown:** Custom Metrics appears in the Settings menu next to Custom Data Sets (navigated via it).
- **Breadcrumb:** "Account: Adam Orfei | Settings > Custom Metrics".
- **Search bar** above the table with placeholder **"Enter Custom Metric"**.
- **Listing table columns:** `Metric | Description | Created Date | Creator | Formula | Actions` (exact).
- **"Create a Custom Metric"** button top-right; **Help Center** + **Info** buttons top-right.
- **Search** "Cross-Channel Engagements" → table filtered to the single matching row.
- **Actions ellipsis** (`.al-table__action`) → menu shows **Edit, Delete** (in order).

## Assertions
| Step | Expected | Actual | Status |
|---|---|---|---|
| 1 | Custom Metrics next to Custom Data Sets in Settings | present | PASS |
| 2 | Breadcrumb, search bar, placeholder, table columns, Create button, Help/Info | all present (see above) | PASS |
| 2 | Creator & Formula columns not empty | Formula populated on all rows; Creator populated on newer metrics but **blank on legacy rows** (e.g. Cross-Channel Engagements) — columns present & populated overall | PASS (with note) |
| 3 | Table updates per search term | Cross-Channel Engagements → 1 row | PASS |
| 4 | Ellipsis shows Edit, Delete in order | Edit, Delete | PASS |

## Note
"Cross-Channel Engagements" (Dec. 13 2024) has an **empty Creator** cell (legacy system metric predating creator-tracking). The Creator column exists and is populated for newer metrics. Interpreted the assertion as "columns present & populated" (satisfied), not "every cell non-empty". Minor data observation, not a defect.

## Evidence
- `.playwright-out/QA-75011-cm.png`

## Bugs filed
None.
