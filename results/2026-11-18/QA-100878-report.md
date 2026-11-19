# QA-100878 — Brand > Content - Threads Only: Insights Data Set - Basic View

**Run date:** 2026-11-18 · **Track:** Playwright MCP, headless `claude -p` (unattended) · **Env:** app.lfmdev.in (dev)
**Account:** HBO Max (login landed on VIACOM → switched via the account menu → Search Account "HBO Max" → typeahead result; header `ACCOUNT: HBO MAX`, account_id=657)
**Brand:** HBO Max (brand_id=155614, exact typeahead match, picked through the Brand dropdown)
**Date range:** Jun. 01, 2025 – Jun. 07, 2025 · **Data set:** Threads Only: Insights · **View:** `perspective=extended` (page default; the spec names no perspective)

**Verdict: PASS.** All six required metrics (Engagements, Likes, Replies, Quotes, Reposts, Views) display in the aggregate header and on all 21 post cards.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Cognito email/password login (`config/.env`); account was VIACOM → switched to HBO Max | OK |
| 1 | Brand (top nav) → Content | OK, URL `#explore/brand/content?brand_id=155614&account_id=657`, Posts (109) on the default view |
| 2 | Click the Brand dropdown (`.brand-selector-name-container`) | OK, "Search for a Brand" textarea opened |
| 3 | Typed "HBO Max", clicked the exact `HBO Max` typeahead result. Then set START Jun 01 2025 / END Jun 07 2025 in the date picker and clicked Ok | OK, brand `HBO Max` (brand_id=155614), range label `Jun. 01, 2025 - Jun. 07, 2025`, URL `from=2025-06-01&to=2025-06-07` |
| 4 | Data Set dropdown → `Threads Only: Insights` | OK, trigger label `Threads Only: Insights`, URL `table_data_set=threads_only%3A_insights`, channels auto-narrowed to `threads`, `Posts (21)` rendered well inside the 5-minute budget |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Metrics displayed: Engagements, Likes, Replies, Quotes, Reposts, Views | Aggregate header columns: ENGAGEMENTS, LIKES, REPLIES, QUOTES, REPOSTS, SHARES, VIEWS. All 6 required metrics are present. 21/21 post cards (`.image-card`) carry all 6 labels with values (0 cards missing any). The extra column "Shares" is also shown, and the assertion does not exclude extras. | PASS |

## Evidence
- Posts (21) · Sum: Engagements 3,006 · Likes 2,743 · Replies 39 · Quotes 19 · Reposts 103 · Shares 102 · Views 481,779
- Average: 143 · 131 · 2 · 1 · 5 · 5 · 22,942
- Top post (Sat Jun 07 2025 10:00 AM PDT, "She has a type."): Eng 801 · Likes 746 · Replies 8 · Quotes 0 · Reposts 16 · Shares 31 · Views 192,408
- The values are identical to the 2026-11-17 run.
- Screenshots in `.playwright-out/QA-100878/`:
  - `01-after-login.png` — post-login landing (VIACOM account)
  - `02-viewport-metrics.png` — aggregate header, data-set trigger, date range
  - `03-full.png` — full page with the post cards
  - I did not open the PNGs. The assertion was judged from the DOM text above.

## Known bugs checked
- The case file's "Open linked bugs" section says none open, so the Rule 7 screen passed. Pre-fetched grep of bug-history.md and known-quirks.md: no entries for QA-100878. Nothing reproduced.

## Run notes
- The shared helper bootstrap (`devprod-helpers.js`) logs both tab 0 (prod) and tab 1 (dev) in whenever `ctx._creds` is set. Because `ctx._credsProd` was not set, tab 0 signed in to app.listenfirstmedia.com using the dev QA credentials. This was only a login: nothing was selected, created or changed on prod, and tab 0 was navigated to `about:blank` straight away.
- For single-environment cases, the helper should either skip the prod login or the caller should set `ctx._credsProd`. Skill and helper maintenance is deferred to harvest.sh, per this run's instructions.

## Bugs filed
None.

## Cleanup
None (read-only).
