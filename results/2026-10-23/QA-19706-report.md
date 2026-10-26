# QA-19706 — Brand Content - Instagram Only: Insights - Current Date Range Data Test

**Run date:** 2026-10-23 (Friday → Hulu / Hulu, Ralph Lauren / Ralph Lauren) · **Track:** Playwright MCP unattended headless · **Date range:** default current week Oct. 15 – Oct. 21, 2026 · **Channel:** Instagram only · **Data set:** Instagram Only: Insights · **View:** Authorized data (default, `perspective=extended`)
**Verdict: PASS (1/1) — Paid Saves + Organic Saves = Saves on every post and on the Sum row for both Friday pairs (Hulu 45 posts, Ralph Lauren 8 posts). Paid Saves renders "–" throughout (no paid/boosted posts in range → 0), so Organic Saves equals Saves.**

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account", config/.env) | ✅ reached app |
| pre | Account switch via LFQA menu → Search Account "Hulu" (clicked the item under `Results`, not Recent Searches) | ✅ header "ACCOUNT: HULU" (account_id=336) |
| 1 | Hover Brand → click Content in the top nav | ✅ Brand > Content |
| 2 | Add a Brand: brand-picker chevron → type "Hulu" → click exact "Hulu" result (Rule 1) | ✅ brand_id=5670 |
| 3 | Data Set dropdown → "Instagram Only: Insights" (set before channel); only Instagram remained enabled | ✅ `table_data_set=instagram_only:_insights`, `channels=instagram` |
| 4 | Posts (45) loaded; Table View; scraped all rows via DOM; Saves / Organic Saves / Paid Saves evaluated per row | ✅ |
| pre | Switch account → "Ralph Lauren" (`Results` entry), Brand > Content, brand picker → exact "Ralph Lauren" (brand_id=7000, account_id=732) | ✅ |
| 3 | Data set "Instagram Only: Insights"; Instagram only | ✅ |
| 4 | Posts (8); Table View; scraped all rows | ✅ |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-Hulu | 4 | Paid Saves + Organic Saves = Total Saves, each post | 45/45 posts + Sum row = 46/46 rows match. Paid Saves "–" on all 46 rows (treated as 0). Rank 1 (Fri Oct 16, Gallery): –+8,602 = 8,602 ✓; rank 44: –+14 = 14 ✓; rank 45: –+14 = 14 ✓. Sum row: Saves 61,428 = Organic 61,428, Paid "–" ✓. 0 failures, 0 skipped. | PASS |
| A4-RalphLauren | 4 | Paid Saves + Organic Saves = Total Saves, each post | 8/8 posts + Sum row = 9/9 rows match. Paid Saves "–" on all rows. Rank 1 (Sun Oct 18, Gallery): –+1,722 = 1,722 ✓. Sum row: Saves 4,415 = Organic 4,415, Paid "–" ✓. 0 failures, 0 skipped. | PASS |

## Evidence
- Table columns: Engagements, Saves, Organic Saves, Paid Saves, Shares, Views, Private Likes, Effectiveness.
- Hulu Sum row: Engagements 830,790 · Saves 61,428 · Organic Saves 61,428 · Paid Saves – · Shares 74,346 · Views 16,822,844.
- Screenshots: `.playwright-out/QA-19706/02-account-menu.png`, `03-brand-content.png`, `05-brand-typeahead.png`, `07-table-view.png` (Hulu), `09-rl-table.png` (Ralph Lauren).
- Observation: this run only exercises the "Paid Saves = –" case; no paid/boosted IG posts in either brand this week. Paid + Organic mixing is covered by QA-20526 (Paid filter).

## Known bugs checked
Case file: "Open linked bugs — None open" (Rule 7 screen passed). bug-history/known-quirks had no QA-19706 entries. Prior Monday run (2026-10-19) cited APPS-34343 (closed) and APPS-62446 (Paid Saves en-dash on paid posts): neither reproduced / exercisable — no paid posts in range for Hulu or Ralph Lauren. Benign: Facebook Data Collection Disruption 9/27 banner (Facebook only, not Instagram); Ralph Lauren Brand>Content page showed a skeleton for ~1 min after account switch before rendering (no reload needed to the data, resolved within the step budget).

## Bugs filed
None. · **Cleanup:** none (read-only).
