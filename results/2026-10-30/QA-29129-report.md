# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-30 (Friday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched via the profile menu "Search Account", exact result "UCLA"; breadcrumb "ACCOUNT: UCLA") · **Brand:** University of California, Los Angeles (brand_id=127756, the account default; the case says only "Add a Brand") · **Date range:** Last 30 Days = Sep 29 – Oct 28, 2026 · **Channel:** LinkedIn only (`channels=linkedin`) · **Data set:** Impressions (`table_data_set=impressions`) · **View:** Authorized data (default `perspective=extended`) · **Skill:** `brand-content-grid-math`

**Verdict: PASS (4/4 assertions; the Reach identity is only trivially satisfied, see A5)**
- Organic Impressions + Paid Impressions = Impressions on 129/129 posts.
- Engagements / Impressions = Engagement Rate on 129/129 posts.
- Engaged User Rate is "–" on 129/129 posts.
- Reach, Organic Reach and Paid Reach are all "–" on every LinkedIn post, so the reach identity holds only as no-data = no-data.

## Pre-screen
Case file "Open linked bugs (as of 2026-10-20)": none open, so the Rule 7 screen passed. bug-history / known-quirks: no QA-29129 entries (pre-fetched).

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login via Cognito "With existing account" with `config/.env` creds (devprod-helpers `m.login`) | OK, landed on `#home` |
| pre | Precondition: UCLA account. Profile menu, typed "UCLA" in Search Account, clicked the exact "UCLA" result | OK, `account_id=799` |
| 1 | Hover Brand in the top nav, click Content | OK, `#explore/brand/content?brand_id=127756`, brand selector = University of California, Los Angeles |
| 2 | Brand confirmed (default brand for the account). Data Set dropdown (visible one), "Impressions", picked before the channel | OK, `table_data_set=impressions` |
| 3 | Channels: clicked off all other channels, verified only `linkedin` enabled; Apply | OK, `channels=linkedin`, Posts (30) for the default week |
| 3 | Date picker, "Auto" preset dropdown, **Last 30 Days** | OK, fields "Sep 29, 2026 – Oct 28, 2026", `from=2026-09-29&to=2026-10-28`, Posts (129) |
| 4-6 | Table View (`[title="Table View"]`); scraped all 129 rows plus the Sum row from `table.lfm-table` (Rank header present). Identities evaluated in page JS | OK, 129 rows |

## Data (Table View, LinkedIn, Sep 29 – Oct 28 2026)
- Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Channel icon is `fa-linkedin` on all 129 post rows (the only other row is the aggregate row).
- Post dates span Thu Oct. 01, 2026 to Wed Oct. 28, 2026 (sort is by engagements; first row Sat Oct. 24, last row Wed Oct. 28 04:00 PM PDT).
- Sample rows (Engagements / ER / Impressions / Organic / Paid / Reach / Organic Reach / Paid Reach / EUR):
  - Rank 1 (Oct 24): 1,778 / 5.45% / 32,598 / 32,598 / – / – / – / – / –
  - Rank 2 (Oct 01): 1,331 / 1.65% / 80,749 / 80,749 / – / – / – / – / –
  - Rank 3 (Oct 26): 1,064 / 4.24% / 25,106 / 25,106 / – / – / – / – / –
- Sum row: Engagements 15,787 · Engagement Rate N/A · Impressions 1,519,437 · Organic Impressions 1,519,437 · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- Column totals computed over the 129 post rows: Σ Engagements 15,787, Σ Impressions 1,519,437, Σ Organic 1,519,437, Σ Paid 0. These match the Sum row exactly. Posts with Paid Impressions > 0: 0.
- The Average row was not toggled in this run, because no assertion depends on it.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions for each post | 129/129 exact, 0 mismatches, 0 skipped. Paid Impressions is "–" (treated as 0) on all 129 posts, so Organic = Impressions. Rank 1: 32,598 + – = 32,598 ✓; rank 2: 80,749 ✓; rank 3: 25,106 ✓. Sum row: Impressions 1,519,437 = Organic 1,519,437 + Paid "–". | PASS |
| A5 | 5 | Organic Reach + Promoted (Paid) Reach = Reach for each post | Reach, Organic Reach and Paid Reach are all "–" on 129/129 posts and "N/A" on the Sum row. No post has a numeric value in any reach column, so the identity holds only as 0 = 0 (no data). Per the grid-math skill, LinkedIn Reach is treated as structurally absent. Same outcome as the earlier runs of this case. Not numerically evaluable. | PASS (n/a, consistent) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 129/129 within ±0.005 pp of the 2-decimal display, 0 mismatches, 0 skipped. Rank 1: 1,778 / 32,598 = 5.454% → 5.45% ✓; rank 2: 1,331 / 80,749 = 1.648% → 1.65% ✓; rank 3: 1,064 / 25,106 = 4.238% → 4.24% ✓. The Sum row's own Engagement Rate cell shows "N/A" by design. | PASS |
| A6b | 6 | Engaged User Rate displays en-dash | "–" on 129/129 posts. The Sum row shows "N/A" (aggregate cell). | PASS |

## Evidence
- `.playwright-out/QA-29129/01-content-initial.png`: UCLA account, default brand, Public data set, all channels
- `.playwright-out/QA-29129/03-datepicker.png`: date picker open
- `.playwright-out/QA-29129/04-presets.png`: preset dropdown with Last 30 Days
- `.playwright-out/QA-29129/05-last30-selected.png`: Last 30 Days applied, Posts (129)
- `.playwright-out/QA-29129/06-table-view.png`: Table View
- All numbers were read from the `table.lfm-table` DOM. The final URL carried `channels=linkedin`, `table_data_set=impressions`, `from=2026-09-29&to=2026-10-28`, `perspective=extended`. Screenshots were saved but only 04-presets.png was visually inspected (to locate the preset dropdown); no assertion needed visual judgement.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29129 entries. Nothing reproduced that interferes with the assertions. No table load failure or Reload prompt occurred.
- LinkedIn Reach "–" is consistent with the structural-absence pattern and with the earlier runs of this case (2026-10-20 through 2026-10-29); it is not a new defect.

## Bugs filed
None. Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- `brand-content-grid-math` reused unchanged (pass_streak +1).
- Last 30 Days resolved to Sep 29 – Oct 28 (30 days ending on the run date, inclusive of the run date's previous day's end; yesterday's end date matches "Data last updated").
- The date-picker preset control is the `.lfm-dropdown-select-box` inside `.date-selector-container.display-date-picker` (initial label "Auto"), not the data-set dropdown; selecting a preset applies immediately with no Ok button.
- Table headers contain spaces (`Organic Impressions`); strip whitespace from header names before keying scraped rows.
- The Playwright code tool echoes the code it ran, including a password literal. A creds-injecting snippet leaks the password into the transcript. Prefer a helper that reads `config/.env` inside the Playwright server process (not possible via `require`/`import` in the sandboxed code runner today), or stop echoing code in the headless harness. The temporary creds file was deleted after use.
