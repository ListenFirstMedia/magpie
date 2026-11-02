# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-28 (Wednesday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched via the profile menu, exact option "UCLA") · **Brand:** University of California, Los Angeles (brand_id=127756, the account default; the case says only "Add a Brand") · **Date range:** Last 30 Days = Sep 27 – Oct 26, 2026 · **Channel:** LinkedIn only (`channels=linkedin`) · **Data set:** Impressions (`table_data_set=impressions`) · **Skill:** `brand-content-grid-math` (+ `devprod-helpers.js`)

**Verdict: PASS (4/4 assertions; Reach identity is only trivially satisfied, see A5)**
- Organic Impressions + Paid Impressions = Impressions on 129/129 posts.
- Engagements / Impressions = Engagement Rate on 129/129 posts.
- Engaged User Rate is "–" on 129/129 posts.
- Reach, Organic Reach and Paid Reach are all "–" on every LinkedIn post, so the reach identity holds only as no-data = no-data.

## Pre-screen
Case file "Open linked bugs (as of 2026-10-20)": none open, so Rule 7 screen passed. bug-history / known-quirks: no QA-29129 entries (pre-fetched).

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login via Cognito "With existing account" with `config/.env` creds | OK, landed on `#home` |
| pre | Precondition: UCLA account. Profile menu, typed "UCLA", real mouse click on the exact option. Breadcrumb "ACCOUNT: UCLA" | OK, `account_id=799` |
| 1 | Hover Brand in the top nav, click Content | OK, `#explore/brand/content?brand_id=127756`, default week Posts (145) |
| 2 | Brand confirmed in `.brand-selector-name` = University of California, Los Angeles. Data Set dropdown, "Impressions" (picked before the channel) | OK, `table_data_set=impressions` |
| 3 | Channels: LinkedIn enabled, all other channels clicked off, Apply. Verified `.channel-ghost.enabled` = linkedin only | OK, `channels=linkedin`, Posts (31) for the default week |
| 3 | Date picker, "Make a Selection" dropdown, **Last 30 Days** (applied on selection) | OK, `from=2026-09-27&to=2026-10-26`, Posts (129) |
| 4-6 | Table View (`[title="Table View"]`); scraped all 129 rows plus the Sum row from `table.lfm-table` (Rank header present). Identities evaluated in page JS. Sum/Average toggled to read the Average row | OK, 129 rows |

## Data (Table View, LinkedIn, Sep 27 – Oct 26 2026)
- Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Channel column is an icon (`fab fa-linkedin`) on every row; no other channel icon found.
- Post dates span Mon Oct. 19 – Sat Oct. 24, 2026 on the sorted extremes shown (Pacific time).
- Sample rows (Engagements / ER / Impressions / Organic / Paid / Reach / Organic Reach / Paid Reach / EUR):
  - Rank 1 (Oct 24): 1,470 / 5.39% / 27,270 / 27,270 / – / – / – / – / –
  - Rank 2 (Oct 01): 1,330 / 1.65% / 80,731 / 80,731 / – / – / – / – / –
  - Rank 3 (Oct 20): 868 / 5.46% / 15,897 / 15,897 / – / – / – / – / –
- Sum row: Engagements 15,590 · Engagement Rate N/A · Impressions 1,535,468 · Organic Impressions 1,535,468 · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- Average row (toggle): Engagements 121 · Engagement Rate 1.02% · Impressions 11,903 · Organic 11,903 · Paid – · Reach – · Organic Reach – · Paid Reach – · Engaged User Rate –.
- Column totals computed over the 129 post rows: Σ Engagements 15,590, Σ Impressions 1,535,468, Σ Organic 1,535,468, Σ Paid 0. These match the Sum row exactly. Posts with Paid Impressions > 0: 0.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions for each post | 129/129 exact, 0 mismatches, 0 skipped. Paid Impressions is "–" (treated as 0) on all 129 posts, so Organic = Impressions. Rank 1: 27,270 + – = 27,270 ✓; rank 2: 80,731 ✓; rank 3: 15,897 ✓. Sum row: 1,535,468 = Organic 1,535,468 + Paid "–". | PASS |
| A5 | 5 | Organic Reach + Promoted (Paid) Reach = Reach for each post | Reach, Organic Reach and Paid Reach are all "–" on 129/129 posts and "N/A" on the Sum row. No post has a numeric value in any reach column, so the identity holds only as 0 = 0 (no data). Per the grid-math skill, LinkedIn Reach is treated as structurally absent. Same outcome as the 2026-10-20 and 2026-10-27 runs of this case. Not numerically evaluable. | PASS (n/a, consistent) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 129/129 within ±0.005 pp of the 2-decimal display, 0 mismatches, 0 skipped. Rank 1: 1,470 / 27,270 = 5.391% → 5.39% ✓; rank 2: 1,330 / 80,731 = 1.647% → 1.65% ✓; rank 3: 868 / 15,897 = 5.460% → 5.46% ✓. Aggregate: 15,590 / 1,535,468 = 1.015% → the Average row's 1.02% ✓. The Sum row's own Engagement Rate cell shows "N/A" by design. | PASS |
| A6b | 6 | Engaged User Rate displays en-dash | "–" on 129/129 posts. Average row "–". The Sum row shows "N/A" (aggregate cell). | PASS |

## Evidence
- `.playwright-out/QA-29129/01-content-initial.png`: UCLA account, default brand, Public data set, all channels
- `.playwright-out/QA-29129/02-impressions-linkedin.png`: Impressions data set, LinkedIn only (default week)
- `.playwright-out/QA-29129/03-datepicker.png`: date picker open
- `.playwright-out/QA-29129/04-presets.png`: "Make a Selection" presets list incl. Last 30 Days
- `.playwright-out/QA-29129/05-table-view.png`: Table View, Posts (129)
- `.playwright-out/QA-29129/06-average-row.png`: Average row
- All numbers were read from the `table.lfm-table` DOM. The final URL carried `channels=linkedin`, `table_data_set=impressions`, `from=2026-09-27&to=2026-10-26`, `perspective=extended`. Screenshots were saved but not visually inspected; no assertion needed it.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29129 entries. Nothing reproduced that interferes with the assertions. No table load failure or Reload prompt occurred.
- LinkedIn Reach "–" is consistent with the structural-absence pattern and with the earlier runs of this case; it is not a new defect. The browser console showed errors on the app pages, none related to the table data; they were not investigated.

## Bugs filed
None. Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- `brand-content-grid-math` reused unchanged (pass_streak +1). Helper mechanics worked as documented: `devprod-helpers.js` loaded with `ctx._creds` unset to avoid its automatic prod-tab login, then creds set only for a dev login on the single tab.
- Last 30 Days resolved to Sep 27 – Oct 26 (30 days ending on the run date), one day later than the 2026-10-27 run (Sep 26 – Oct 25).
