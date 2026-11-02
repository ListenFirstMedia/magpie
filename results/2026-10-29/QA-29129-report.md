# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-29 (Thursday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in) · **Account:** UCLA (account_id=799, switched via the profile menu "Search Account", exact result "UCLA"; breadcrumb "ACCOUNT: UCLA") · **Brand:** University of California, Los Angeles (brand_id=127756, the account default; the case says only "Add a Brand") · **Date range:** Last 30 Days = Sep 28 – Oct 27, 2026 · **Channel:** LinkedIn only (`channels=linkedin`) · **Data set:** Impressions (`table_data_set=impressions`) · **Skill:** `brand-content-grid-math`

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
| pre | Login via Cognito "With existing account" with `config/.env` creds | OK, landed on `#home` |
| pre | Precondition: UCLA account. Profile menu (LFQA), typed "UCLA" in Search Account, clicked the exact "UCLA" result | OK, `account_id=799` |
| 1 | Hover Brand in the top nav, click Content | OK, `#explore/brand/content?brand_id=127756`, brand selector = University of California, Los Angeles |
| 2 | Brand confirmed (default brand for the account). Data Set dropdown (visible one), "Impressions", picked before the channel | OK, `table_data_set=impressions` |
| 3 | Channels: clicked off Facebook, Twitter, Instagram, TikTok and Threads; verified only `.channel-ghost.linkedin.enabled` remained; Apply | OK, `channels=linkedin` |
| 3 | Date picker, "Make a Selection" dropdown, **Last 30 Days** | OK, `from=2026-09-28&to=2026-10-27`, Posts (129) |
| 4-6 | Table View (`[title="Table View"]`); scraped all 129 rows plus the Sum row from `table.lfm-table` (Rank header present). Identities evaluated in page JS | OK, 129 rows |

## Data (Table View, LinkedIn, Sep 28 – Oct 27 2026)
- Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Channel icon is `fa-linkedin` on all 129 rows; no other channel icon found.
- Post dates span Mon Sep. 28, 2026 08:00 AM PDT to Tue Oct. 27, 2026 08:00 PM PDT.
- Sample rows (Engagements / ER / Impressions / Organic / Paid / Reach / Organic Reach / Paid Reach / EUR):
  - Rank 1 (Oct 24): 1,624 / 5.41% / 30,046 / 30,046 / – / – / – / – / –
  - Rank 2 (Oct 01): 1,331 / 1.65% / 80,731 / 80,731 / – / – / – / – / –
  - Rank 3 (Oct 26): 966 / 4.21% / 22,929 / 22,929 / – / – / – / – / –
- Sum row: Engagements 15,455 · Engagement Rate N/A · Impressions 1,515,230 · Organic Impressions 1,515,230 · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- Column totals computed over the 129 post rows: Σ Engagements 15,455, Σ Impressions 1,515,230, Σ Organic 1,515,230, Σ Paid 0. These match the Sum row exactly. Posts with Paid Impressions > 0: 0.
- The Average row was not toggled in this run, because no assertion depends on it.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions for each post | 129/129 exact, 0 mismatches, 0 skipped. Paid Impressions is "–" (treated as 0) on all 129 posts, so Organic = Impressions. Rank 1: 30,046 + – = 30,046 ✓; rank 2: 80,731 ✓; rank 3: 22,929 ✓. Sum row: Impressions 1,515,230 = Organic 1,515,230 + Paid "–". | PASS |
| A5 | 5 | Organic Reach + Promoted (Paid) Reach = Reach for each post | Reach, Organic Reach and Paid Reach are all "–" on 129/129 posts and "N/A" on the Sum row. No post has a numeric value in any reach column, so the identity holds only as 0 = 0 (no data). Per the grid-math skill, LinkedIn Reach is treated as structurally absent. Same outcome as the earlier runs of this case. Not numerically evaluable. | PASS (n/a, consistent) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 129/129 within ±0.005 pp of the 2-decimal display, 0 mismatches, 0 skipped. Rank 1: 1,624 / 30,046 = 5.405% → 5.41% ✓; rank 2: 1,331 / 80,731 = 1.649% → 1.65% ✓; rank 3: 966 / 22,929 = 4.213% → 4.21% ✓. The Sum row's own Engagement Rate cell shows "N/A" by design. | PASS |
| A6b | 6 | Engaged User Rate displays en-dash | "–" on 129/129 posts. The Sum row shows "N/A" (aggregate cell). | PASS |

## Evidence
- `.playwright-out/QA-29129/01-content-initial.png`: UCLA account, default brand, Public data set, all channels
- `.playwright-out/QA-29129/03-datepicker.png`: date picker open
- `.playwright-out/QA-29129/04-presets.png`: "Make a Selection" presets list incl. Last 30 Days
- `.playwright-out/QA-29129/05-table-view.png`: Table View, Posts (129)
- All numbers were read from the `table.lfm-table` DOM. The final URL carried `channels=linkedin`, `table_data_set=impressions`, `from=2026-09-28&to=2026-10-27`, `perspective=extended`. Screenshots were saved but not visually inspected; no assertion needed it.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29129 entries. Nothing reproduced that interferes with the assertions. No table load failure or Reload prompt occurred.
- LinkedIn Reach "–" is consistent with the structural-absence pattern and with the earlier runs of this case; it is not a new defect. The browser console showed errors on the app pages, none related to the table data; they were not investigated.

## Bugs filed
None. Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- `brand-content-grid-math` reused unchanged (pass_streak +1).
- Table header text has no spaces (`OrganicImpressions`, `EngagementRate`, `EngagedUserRate`; `Engaged User  Rate` has a double space), so strip all whitespace from header names before keying the scraped rows. The first scrape used spaced keys and read every component as null. It was re-run with the stripped keys.
- Last 30 Days resolved to Sep 28 – Oct 27 (30 days ending on the run date).
- The Playwright code tool echoes the code it ran, including a fill value. A login script that embeds the password therefore leaks it into the transcript. The helper file was deleted after use. Prefer the `devprod-helpers.js` login, which reads the credentials from `ctx._creds`.
