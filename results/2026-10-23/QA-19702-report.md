# QA-19702 — Brand Content - Facebook Only: Completed & Live Video DataSet - Data Test

**Run date:** 2026-10-23 (Friday) — headless, unattended, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com
**Skill used:** `brand-content-grid-math` (Table View DOM scrape) + `switch-account` (LFQA hover menu → Search Account → `Results` row)

## Verdict: PASS

Friday rotation row = Account/Brand **Hulu / Hulu** and **Ralph Lauren / Ralph Lauren** (same pairing QA-19701 used today). Both legs executed in full. For every post with data, Completed Views = Organic Completed Views + Paid Completed Views, and the Sum row matches too.

## Known bugs checked
- Case file "Open linked bugs": **None open** (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-19702 entries (pre-grepped).
- Related surface: the dev status banner "Facebook Data Collection Disruption 9/27" is showing. It affected exactly one post per account (a Facebook post whose Completed/Organic/Paid cells are all "–"); those rows are "no data" and were skipped and counted. It did not change the verdict.
- No known bug reproduced.

## Steps executed
Login: Cognito "With existing account" form, credentials from `config/.env`. The session landed on account Ralph Lauren (account_id=732), so that leg ran first, then the account was switched to Hulu.

Per leg:
1. **Step 1** — hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
2. **Step 2** — opened the brand picker (chevron next to the brand name), typed the brand name, and clicked the exact-name first Result (Rule 1): `Ralph Lauren` (brand_id=7000), `Hulu` (brand_id=5670).
3. **Step 3** — Data Set dropdown → **Facebook Only: Completed Video Views**. URL `table_data_set=facebook_only:_completed_video_views`; only `channel-ghost facebook enabled`; clicked Apply. Date range Oct 15 – Oct 21, 2026 and View = Authorized data (app defaults; the spec names neither).
4. **Step 4** — switched to **Table View** (`[title="Table View"]`), scraped every `tbody tr` of the `table.lfm-table` whose header includes Rank, and evaluated the identity per row in page JS. Columns present: Completed Views, Organic Completed Views, Paid Completed Views.

Account switch to Hulu: LFQA hover → Search Account → typed "Hulu" → clicked the `Results` row (`.typeahead-options-list .lfm-ta-option`). Landed on `#home`, breadcrumb `ACCOUNT: HULU`, `account_id=336` confirmed in the Brand > Content URL.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4-RL | 4 | Each grid post: Completed Views = Organic + Paid | 3 of 3 posts with data match (10,939 = 10,939 + 0; 3,922 = 3,922 + 0; 482 = 482 + 0). 1 post (rank 4) has "–" in all three cells, so it is no data and skipped. 0 failures. | PASS |
| A4-RL-Sum | 4 | Sum row: Completed Views = Organic + Paid | 15,343 = 15,343 + 0; also equals the sum of the 3 post rows (10,939 + 3,922 + 482 = 15,343) | PASS |
| A4-Hulu | 4 | Each grid post: Completed Views = Organic + Paid | 40 of 40 posts with data match (0 failures). 1 post (rank 41) has "–" in all three cells, skipped. Samples: rank 1 = 24,965 = 24,965 + 0; rank 2 = 157,672 = 157,672 + 0; rank 3 = 89,768 = 89,768 + 0; rank 4 = 13,359 = 13,359 + 0 | PASS |
| A4-Hulu-Sum | 4 | Sum row: Completed Views = Organic + Paid | 425,254 = 425,254 + 0; equals the sum of the 40 post rows (425,254 / 425,254 / 0) | PASS |

## Evidence
- Ralph Lauren: Posts (4) for Oct 15–21, 2026 on Facebook. Sum row Engagements 4,752 / Completed Views 15,343 / Organic 15,343 / Paid 0.
- Hulu: Posts (41) for Oct 15–21, 2026 on Facebook. Sum row Completed Views 425,254 / Organic 425,254 / Paid 0.
- Paid Completed Views is 0 on every post in both legs (no promoted Facebook video in this window), so the Paid term did not get exercised with a non-zero value. The identity holds, but the check cannot catch a Paid-term defect on this data.
- Screenshots (`.playwright-out/QA-19702/`): `03-RL-typeahead.png`, `06-RL-brand-repicked.png`, `07-RL-dataset-selected.png`, `08-RL-applied.png`, `09-RL-table.png` (Ralph Lauren); `10-hulu-account-search.png`, `11-hulu-switched.png`, `12-hulu-brand-content.png`, `13c-hulu-typeahead.png`, `14-hulu-dataset.png`, `15-hulu-applied.png`, `16-hulu-table.png` (Hulu).

## Notes / scope
- The case's "Amazon Prime Video on alternative days" note was not run. It is not defined for this Friday run, and the Friday row (Hulu, Ralph Lauren) was fully covered.
- **Slow/hung first load (Ralph Lauren), recovered within the step budget.** The first Brand > Content load after the initial login sat on the loading skeleton for about 3.5 minutes. A hard reload stayed on the skeleton for another 2.5 minutes. The console showed CORS errors with `net::ERR_FAILED` on `dsp-api.lfmdev.in/tracked_brands` and `/brand_sets?limit=1`, which points at a failing dev backend call. Navigating Home → Brand → Content from scratch then loaded in 36 s and every later page load was fast. I treated it as transient dev flakiness, not a case failure, since the steps then ran in full. Evidence: `04b-RL-stuck.png`, `04c-RL-stuck-after-reload.png`.
- Playwright's brand-picker click on `.brand-selector-name-container` did not open the picker on Hulu. A mouse click on the chevron (145,165) opened it. The picker input is a `textarea[placeholder="Search for a Brand"]`, not an `<input>`.
- Stray downloads: the MCP reported `Hulu-Brand Content-2026-10-15-2026-10-21-posts.csv` and `Hulu-Brand Content-2024-06-27-2024-07-03-posts.csv` during the Hulu leg. No step in this case triggers an export. QA-19701 saw the same stray download earlier today. They look like artifacts of the shared Playwright session; I did not use them for any assertion.

## Bugs filed
None.
