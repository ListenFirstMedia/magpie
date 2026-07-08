# QA-12532 — Brand Sets > Partnerships — Sponsors, Partners, N Partnerships, Big Numbers tile-level export (PNG)

- **Run date:** 2026-07-04
- **Branch:** feature/playwright-mcp (headless, unattended)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-12532
- **Verdict:** **FAILED (blocked by open bug)**

## Result

Not executed. Per **spec-adherence Rule 7 (open-bug auto-fail)**, this case was screened
before any browser flow and **not run**.

The cached case file's **"## Open linked bugs (as of 2026-07-03)"** section lists:

- **LFMP-31903 (Open)**
- **LFMP-32116 (Open)**

A case with any OPEN linked defect cannot produce a trustworthy PASS, so the run is
short-circuited: no pre-flight login, no navigation, no steps executed. The case will be
picked up automatically on a future run once these bugs close and the case cache is refreshed.

## Steps executed

None — screened out before pre-flight per Rule 7.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6a | 5–6 | Export icon on right-hand side of tile | not evaluated | BLOCKED (open bug) |
| A6b | 5–6 | PNG, CSV, Google Sheets options with icons | not evaluated | BLOCKED (open bug) |
| A6c | 5–6 | Partners PNG file name: `Brand Set - Tab - Chart - YYYY-MM-DD-YYYY-MM-DD.png` | not evaluated | BLOCKED (open bug) |
| A6d | 5–6 | Chart title: `Brand Set Name - Chart Name` | not evaluated | BLOCKED (open bug) |
| A6e | 5–6 | Displaying date below the legend | not evaluated | BLOCKED (open bug) |
| A8c | 7–8 | Sponsors PNG file name pattern | not evaluated | BLOCKED (open bug) |
| A8d | 7–8 | Chart title: `Brand Set Name - Chart Name` | not evaluated | BLOCKED (open bug) |
| A8e | 7–8 | Displaying date below the legend | not evaluated | BLOCKED (open bug) |
| A10c | 9–10 | Partnerships PNG file name pattern | not evaluated | BLOCKED (open bug) |
| A10d | 9–10 | Chart title: `Brand Set Name - Chart Name` | not evaluated | BLOCKED (open bug) |
| A10e | 9–10 | Displaying date below the legend | not evaluated | BLOCKED (open bug) |
| A12 | 11–12 | Chart updates to Pie chart | not evaluated | BLOCKED (open bug) |
| A13 | 13 | Options: Data View Count/Share, Channel View Channel/Aggregate | not evaluated | BLOCKED (open bug) |
| A14 | 14 | Chart values displayed in percentage | not evaluated | BLOCKED (open bug) |
| A15a | 15 | PNG file name: `Brand Set - Tab - Chart - Pie - YYYY-MM-DD-YYYY-MM-DD.png` | not evaluated | BLOCKED (open bug) |
| A15b | 15 | Date displayed below Brand Set Partnership tile | not evaluated | BLOCKED (open bug) |

## Evidence

No artifacts captured (case not run). `.playwright-out/QA-12532/` intentionally empty.

## Bugs filed

None. Two pre-existing open bugs block this case:

- **LFMP-31903 (Open)** — linked to QA-12532.
- **LFMP-32116 (Open)** — linked to QA-12532.

No new Jira tickets created (markdown-only, per instructions).

## Next action

Re-run once LFMP-31903 and LFMP-32116 are closed and the case cache is refreshed from Jira.
