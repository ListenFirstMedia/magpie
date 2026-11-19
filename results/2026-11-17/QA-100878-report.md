# QA-100878 — Brand > Content - Threads Only: Insights Data Set - Basic View

**Run date:** 2026-11-17 · **Track:** Playwright MCP, headless `claude -p` (unattended) · **Env:** app.lfmdev.in (dev)
**Account:** HBO Max (login landed on ADAM ORFEI → switched via LFQA menu → Search Account "HBO Max" → typeahead result; header `ACCOUNT: HBO MAX`, account_id=657)
**Brand:** HBO Max (brand_id=155614, literal first typeahead result — not an `HBO Max (<region>)` variant)
**Date range:** Jun. 01, 2025 – Jun. 07, 2025 · **Data set:** Threads Only: Insights · **View:** Authorized data (page default; spec names no perspective)

**Verdict: PASS** — all six required metrics (Engagements, Likes, Replies, Quotes, Reposts, Views) display in the aggregate header and on every one of the 21 post cards.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Cognito "With existing account" login; account was Adam Orfei → switched to HBO Max | OK |
| 1 | Brand (top nav) → Content (`a[href^="#explore/brand/content"]`) | OK — URL `#explore/brand/content?brand_id=155614&account_id=657` |
| 2 | Click Brand dropdown (chevron next to brand name) | OK — "Search for a Brand" textarea opened |
| 3 | Typed "HBO Max"; typeahead initially showed Recent Searches, then results after ~5 s; clicked the first, literal `HBO Max` result. Set START Jun 01 2025 / END Jun 07 2025 in the date picker, Ok | OK — range label `Jun. 01, 2025 - Jun. 07, 2025`, URL `from=2025-06-01&to=2025-06-07` |
| 4 | Data Set dropdown → `Threads Only: Insights` | OK — trigger label `Threads Only: Insights`, URL `table_data_set=threads_only:_insights`, channels auto-narrowed to `threads`; `Posts (21)` rendered within ~20 s (well inside the 5-min budget) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Metrics displayed: Engagements, Likes, Replies, Quotes, Reposts, Views | Aggregate header columns: ENGAGEMENTS, LIKES, REPLIES, QUOTES, REPOSTS, SHARES, VIEWS. All 6 required present; 21/21 post cards (`.image-card`) carry all 6 labels with values (0 cards missing any). Extra column "Shares" also shown (not excluded by the assertion). | PASS |

## Evidence
- Posts (21) · Sum: Engagements 3,006 · Likes 2,743 · Replies 39 · Quotes 19 · Reposts 103 · Shares 102 · Views 481,779
- Average: 143 · 131 · 2 · 1 · 5 · 5 · 22,942
- Top post (Sat Jun 07 2025 10:00 AM PDT, "She has a type."): Eng 801 · Likes 746 · Replies 8 · Quotes 0 · Reposts 16 · Shares 31 · Views 192,408
- Values differ slightly from the 2026-10-20 run (Eng 3,020 / Views 481,672) — live metric drift on the 2025 posts; the assertion concerns metric presence, not values, so no impact.
- Screenshots in `.playwright-out/QA-100878/`: `01-after-login.png`, `02-brand-search.png` (typeahead still on Recent Searches right after typing), `03-threads-insights-loaded.png` (full page), `04-viewport-metrics.png` (aggregate header with all metrics, trigger label, date range).

## Known bugs checked
- Case file "Open linked bugs": none open. bug-history.md: no entries for QA-100878 (pre-fetched). Rule 7 screen passed. Nothing reproduced.
- Observation (unrelated to assertions): the brand typeahead needs a few seconds after typing before results replace "Recent Searches"; selecting must wait for the `.lfm-ta-option` rows.

## Bugs filed
None.

## Cleanup
None (read-only).
