# QA-100878 — Brand > Content - Threads Only: Insights Data Set - Basic View

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in
**Account:** HBO Max (switched from Amazon Prime Video via LFQA menu → Search Account → Results) · **Brand:** HBO Max (brand_id=155614, exact match, first typeahead result)
**Date range:** Jun. 01, 2025 – Jun. 07, 2025 · **Data set:** Threads Only: Insights · **View:** Authorized data (page default; spec does not name a perspective)

**Verdict: PASS** — all six required metrics (Engagements, Likes, Replies, Quotes, Reposts, Views) display in the aggregate header and on every one of the 21 post cards.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login via Cognito "With existing account"; account shown was Amazon Prime Video → switched to HBO Max (header `ACCOUNT: HBO MAX`) | OK |
| 1 | Brand (top nav) → Content | OK — URL `#explore/brand/content?brand_id=155614&account_id=657` |
| 2 | Click Brand dropdown (chevron next to brand name) | OK — "Search for a Brand" textarea opened |
| 3 | Typed "HBO Max", clicked the literal `HBO Max` result (not an `HBO Max (<region>)` variant); set START Jun 01 2025 / END Jun 07 2025 in the date picker, Ok | OK — range label `Jun. 01, 2025 - Jun. 07, 2025`, URL `from=2025-06-01&to=2025-06-07` |
| 4 | Data Set dropdown → `Threads Only: Insights` | OK — trigger label reads `Threads Only: Insights`, URL `table_data_set=threads_only:_insights`, channels auto-narrowed to `threads`; content took ~14 s to load after skeletons (well inside the 5-min budget) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Metrics displayed: Engagements, Likes, Replies, Quotes, Reposts, Views | Aggregate header columns: ENGAGEMENTS, LIKES, REPLIES, QUOTES, REPOSTS, SHARES, VIEWS. All 6 required present; 21/21 post cards carry all 6 labels with values. Extra column "Shares" also shown (not excluded by the assertion). | PASS |

## Evidence
- Posts (21) · Sum: Engagements 3,020 · Likes 2,754 · Replies 39 · Quotes 20 · Reposts 105 · Shares 102 · Views 481,672
- Average: 144 · 131 · 2 · 1 · 5 · 5 · 22,937
- Top post (Sat Jun 07 2025 10:00 AM PDT, "She has a type."): Eng 807 · Likes 751 · Replies 8 · Quotes 1 · Reposts 16 · Shares 31 · Views 192,401
- Sum row is identical to the Dev aggregate recorded in the QA-100886 (Dev vs Prod) report for the same brand/range/data set.
- Screenshots: `.playwright-out/QA-100878/` — `12-threads-insights.png` (loading state), `13-loaded.png` (full page, loaded), `14-metrics-header.png`, `11-dataset-open.png` (dropdown incl. `Threads Only: Insights`), `09-range-set.png`, `06-brand-search.png`.

## Known bugs checked
- Case file "Open linked bugs": none open. bug-history.md: no entries for QA-100878. Rule 7 screen passed. Nothing reproduced.
- Observation (not a bug, unrelated to assertions): the orange "Facebook Posts Insights Disruption" platform banner is displayed; Facebook is not in scope for this case.

## Bugs filed
None.

## Cleanup
None (read-only).
