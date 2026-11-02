# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-27 (Tuesday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched via the profile menu, exact `.lfm-ta-option` "UCLA") · **Brand:** University of California, Los Angeles (brand_id=127756, the account default; the case says only "Add a Brand") · **Date range:** Last 30 Days = Sep 26 – Oct 25, 2026 · **Channel:** LinkedIn only (`channels=linkedin`) · **Data set:** Impressions (`table_data_set=impressions`) · **Perspective:** Authorized (default) · **Posts (127)**

**Verdict: PASS (4/4 assertions)**
- Organic Impressions + Paid Impressions = Impressions on 127/127 posts.
- Engagements / Impressions = Engagement Rate on 127/127 posts.
- Engaged User Rate is "–" on 127/127 posts.
- Reach, Organic Reach and Paid Reach are all "–" on every LinkedIn post, so the reach identity holds only trivially (see A5).

## Pre-screen
Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks: no QA-29129 entries (pre-fetched).

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account", config/.env). The first dev login attempt landed back on the sign-in page, so a second `m.login` was run and succeeded. The helper also logged into a prod tab, which was left unused. | OK |
| pre | Precondition: UCLA account. Profile menu, typed "UCLA", real mouse click on the exact `.lfm-ta-option` "UCLA". Breadcrumb "ACCOUNT: UCLA", `account_id=799` | OK |
| 1 | Hover Brand in top nav, click Content | OK. `#explore/brand/content?brand_id=127756` |
| 2 | Brand = University of California, Los Angeles (confirmed in `.brand-selector-name`); Data Set dropdown, "Impressions" (picked before the channel) | OK. `table_data_set=impressions` |
| 3 | Channels: LinkedIn enabled, all others clicked off, **Apply** | OK. `channels=linkedin`, `Posts (32)` for the default week |
| 3 | Date picker, "Make a Selection" dropdown, **Last 30 Days**. The picker applied on selection (no Ok click needed) | OK. `from=2026-09-26&to=2026-10-25`, `Posts (127)` |
| 4-6 | Table View (`[title="Table View"]`); scraped all 127 rows plus the Sum/Average row from `table.lfm-table` (Rank header present). Identities evaluated in page JS. | OK. 127 rows |

## Data (Table View, LinkedIn, Sep 26 – Oct 25 2026)
- Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Post dates span Oct. 01 – Oct. 19, 2026 (Pacific time).
- Sample rows (Engagements / ER / Impressions / Organic / Paid / Reach / Organic Reach / Paid Reach / EUR):
  - Rank 1: 1,331 / 1.65% / 80,704 / 80,704 / – / – / – / – / –
  - Rank 2: 1,270 / 5.43% / 23,379 / 23,379 / – / – / – / – / –
  - Rank 3: 870 / 5.59% / 15,565 / 15,565 / – / – / – / – / –
- Sum row: Engagements 14,951 · Engagement Rate N/A · Impressions 1,499,050 · Organic Impressions 1,499,050 · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- Average row (toggle): Engagements 118 · Engagement Rate 1.00% · Impressions 11,804 · Organic 11,804 · Paid – · Reach – · Organic Reach – · Paid Reach – · Engaged User Rate –.
- Column totals computed over the 127 post rows: Σ Engagements 14,951, Σ Impressions 1,499,050, Σ Organic 1,499,050, Σ Paid 0. These match the Sum row exactly.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions for each post | 127/127 exact, 0 mismatches, 0 skipped. Paid Impressions is "–" (treated as 0) on all 127 posts, so Organic = Impressions. Rank 1: 80,704 + – = 80,704 ✓; rank 2: 23,379 ✓; rank 3: 15,565 ✓. Sum row: 1,499,050 = Organic 1,499,050 + Paid "–". | PASS |
| A5 | 5 | Organic Reach + Promoted (Paid) Reach = Reach for each post | Reach, Organic Reach and Paid Reach are all "–" on 127/127 posts, and "N/A" on the Sum row. No post has a numeric value in any reach column, so the identity holds only as 0 = 0 (no data). LinkedIn does not populate Reach in this data set, treated as structural absence per the grid-math skill. Same outcome as the 2026-10-20 run of this case. Not numerically evaluable. | PASS (n/a, consistent) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 127/127 within ±0.005 pp of the 2-decimal display, 0 mismatches, 0 skipped. Rank 1: 1,331 / 80,704 = 1.649% → 1.65% ✓; rank 2: 1,270 / 23,379 = 5.432% → 5.43% ✓; rank 3: 870 / 15,565 = 5.589% → 5.59% ✓. Aggregate: 14,951 / 1,499,050 = 0.997% → the Average row's 1.00% ✓. The Sum row's own Engagement Rate cell shows "N/A" by design. | PASS |
| A6b | 6 | Engaged User Rate displays en-dash | "–" on 127/127 posts. Average row "–". The Sum row shows "N/A" (aggregate cell). | PASS |

## Evidence
- `.playwright-out/QA-29129/01-content-initial.png`: UCLA account, default brand, Public data set, all channels
- `.playwright-out/QA-29129/02-datepicker.png`: date picker open (Impressions data set, LinkedIn only)
- `.playwright-out/QA-29129/03-presets.png`: "Make a Selection" presets list incl. Last 30 Days
- `.playwright-out/QA-29129/05-after-preset.png`: state right after picking Last 30 Days (Sep. 26 – Oct. 25, 2026)
- `.playwright-out/QA-29129/04-table-view.png`: Table View, Posts (127)
- `.playwright-out/QA-29129/06-average-row.png`: aggregate Average row
- All numbers were read from the `table.lfm-table` DOM; the final URL carried `channels=linkedin`, `table_data_set=impressions`, `from=2026-09-26&to=2026-10-25`, `perspective=extended`.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29129 entries. Nothing reproduced that interferes with the assertions. No Facebook disruption banner was present this run.
- The Reach "–" on LinkedIn is consistent with the structural-absence pattern and with the 2026-10-20 run of this case; it is not a new defect.

## Bugs filed
None. Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- Flow covered by existing skill `brand-content-grid-math`; this is a second-day pass for this case (UCLA, LinkedIn, Impressions data set, Last 30 Days).
- Last 30 Days preset: date picker, "Make a Selection: Auto" dropdown, `.lfm-dropdown-option` "Last 30 Days". It applies on selection; the Ok button is not present afterwards, so `m.setDates` (which waits for Ok) is not suitable for presets.
- Loading `devprod-helpers.js` with `ctx._creds` set also logs into a prod tab (unused here). The dev tab login can need a second `m.login` call if the first lands on the sign-in page.
