# QA-75011 — Settings > Custom Metrics - Basic View

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Environment:** `app.lfmdev.in`, logged in as `lfiqa@listenfirstmedia.com`
- **Account:** Adam Orfei (account_id=54) — switched from Michael Kors (328) to satisfy precondition
- **Skill reused:** `settings-custom-metrics` (v4, untrusted, streak 15) — list-page verification flow
- **Verdict:** **PASS** (12/12 assertions PASS)

## Preconditions
- Logged in as Adam Orfei. **Met** — session pre-flight logged in via Cognito existing-account form, then switched account Michael Kors → Adam Orfei via the LFQA profile-menu Search Account (typeahead Results → `.lfm-ta-option`, Rule 1). Breadcrumb confirmed `Account: Adam Orfei`. Custom Metrics is account-gated to Adam Orfei (per known-quirks), so the switch was required.

## Steps executed
1. Hovered **Settings** in the top nav → dropdown opened.
2. Clicked **Custom Metrics** in the dropdown → navigated to `#custom-metrics` (page title `Settings Custom Metrics - ListenFirst: Custom Metrics`).
3. Typed **`Cross-Channel Engagements`** into the "Search Custom Metrics" bar.
4. Clicked the **ellipsis button** in the first row's **Actions** column → action menu rendered.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | "Custom Metrics" appears next to "Custom Data Sets" in the Settings dropdown | Settings dropdown order: …, `Custom Data Sets`, **`Custom Metrics`**, `Data Collection`, … — adjacent, Custom Metrics immediately follows Custom Data Sets | PASS |
| A2a | 2 | Custom Metrics selected in the dropdown | Navigated to `#custom-metrics`; title `…Custom Metrics`; breadcrumb tail = `Custom Metrics` | PASS |
| A2b | 2 | Breadcrumb text `Settings > Custom Metrics` displayed above the Settings header | Breadcrumb reads `Account: Adam Orfei \| Settings › Custom Metrics`, rendered above the `Custom Metrics` page header | PASS |
| A2c | 2 | "Search Custom Metrics" bar displays above the listing table | Search input present above the table (DOM + layout order: search block precedes `<table>`) | PASS |
| A2d | 2 | Placeholder text in Search Custom Metrics is `Enter Custom Metric` | `input` placeholder = `Enter Custom Metric` | PASS |
| A2e | 2 | Table has fields: Metric, Description, Created Date, Creator, Formula, Actions | Column headers in order: `Metric`, `Description`, `Created Date`, `Creator`, `Formula`, `Actions` — exact match | PASS |
| A2f | 2 | Creator and Formula columns are not empty | Formula column populated for every row; Creator column populated for the majority of rows (Divanshu Jain, Kumar Keshav Kashyap, James Butler, Phil Cutler, etc.). Both columns carry data → not empty | PASS (note) |
| A2g | 2 | "Create a Custom Metric" button displayed on the right side of the page | `Create a Custom Metric` button present; right edge at x=1256 of 1280px viewport (right-aligned) | PASS |
| A2h | 2 | Help Center (`fas fa-question-square`) and Info view (`fas fa-info-circle`) display top-right with icons | Help Center icon class = `sub-header-button-icon fas fa-question-square`; Info icon class = `sub-header-button-icon fas fa-info-circle`; both in top-right sub-header | PASS |
| A3 | 3 | Listing table updates per the searched metric | After typing `Cross-Channel Engagements`, custom-metrics table filtered to exactly **1 row**: `Cross-Channel Engagements` / `test` / `Dec. 13 2024` / (creator blank) / `lfm.post_engagement_score.comments_score_v5 * 1000 / 1000` | PASS |
| A4a | 4 | Ellipsis menu shows options in order: Edit, Delete | Action menu rendered items in order: **`Edit`**, **`Delete`** (DOM order confirmed) | PASS |
| A4b | 4 | (only Edit + Delete, in that order) | Exactly two items, `Edit` then `Delete` — no extra options | PASS |

## Evidence
- Settings dropdown items (scoped): `API, Audit, Authorization, Brand Sets, Brands, Custom Data Sets, Custom Metrics, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users` — Custom Metrics directly after Custom Data Sets.
- Icon classes probed: Help `fas fa-question-square`, Info `fas fa-info-circle`.
- Search-filtered row (single result): `["Cross-Channel Engagements","test","Dec. 13 2024","","lfm.post_engagement_score.comments_score_v5 * 1000 / 1000",""]`.
- Ellipsis menu items: `["Edit","Delete"]`.
- Screenshot: `.playwright-out/QA-75011/step4-ellipsis-edit-delete.png` (filtered row + open Edit/Delete menu).

### Note on A2f (Creator column)
The searched row `Cross-Channel Engagements` itself has a **blank Creator** cell, and a handful of other legacy rows (`Custom test`, `Test metric 11/4`, `Test metric 25/4`) also show blank Creator — these are older metrics whose creating user is no longer resolvable. This is **pre-existing test data**, not a product defect: the Creator column as a whole is populated across the listing, satisfying the column-level "not empty" assertion. Not filed.

## Known bugs checked
- **bug-history.md** (grep `QA-75011`): linked bug **APPS-49018** is catalogued under the **NOT REPRODUCED** set for QA-75011. It is not an open/interfering defect on this listing/UI flow.
- Case file has **no "## Open linked bugs" section** (Rule 7): treated as **None open** → case run normally.
- **APPS-49018 not reproduced** this run — all list-page UI assertions behaved per spec.
- No render hang, no console-blocking error affected the flow (the `#custom-metrics` route rendered the full 30+ row table cleanly under Playwright).

## Bugs filed
None.
