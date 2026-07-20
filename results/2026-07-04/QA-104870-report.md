# QA-104870 — Settings > Custom Data Sets - Basic View

- **Run date:** 2026-07-04
- **Environment:** app.lfmdev.in (Playwright MCP, headless, unattended)
- **Account:** Adam Orfei (account_id=54)
- **Skill used:** [settings-custom-data-sets](../../skills/settings-custom-data-sets/SKILL.md) v3 (stable)
- **Open-bug screen (Rule 7):** "None open. Screen only — run normally." → ran.
- **Verdict:** **PASS** — 12/13 assertions PASS, 1 N/A (A5, no blank-table state on this account).

## Pre-flight
- Programmatic Cognito email/password login as `lfiqa@listenfirstmedia.com` via the "With existing account" form → `oauth_callback` → `#home` (title "Home - ListenFirst") rendered. PASS.
- Landed on account_id=342; switched to **Adam Orfei (account_id=54)** via user menu → account typeahead → typed "Adam Orfei" → clicked the `.lfm-ta-option` Results row (not Recent Searches). App reloaded to `#home?account_id=54`. Precondition met.

## Steps executed
1. Hovered **Settings** in the top nav (`.navigation-menu-header` → `fas fa-tools` "Settings") → dropdown opened.
2. Clicked **Custom Data Sets** (`a[href="#custom-data-sets"]`) → navigated to `#custom-data-sets`, listing table rendered (5 rows) under Adam Orfei.
3. Clicked the **ellipsis button** (`fas fa-ellipsis`) in the first row's Actions column → dropdown opened.
4. Reviewed the Data Set listing table (columns + first-5-row values).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | 'Custom Data Sets' appears after 'Brands' in Settings dropdown | Dropdown order: …Brand Sets, **Brands**, **Custom Data Sets**, Custom Metrics… (immediately after Brands) | PASS |
| A2 | 2 | 'Custom Data Sets' is selected in the dropdown | Menu item `<li>` carries `active` class (`navigation-menu-item is-alt active link item-6`) | PASS |
| A3 | 2 | Breadcrumb 'Account: Adam Orfei \| Settings > Custom Data Sets' above the header | DOM: `Account: Adam Orfei` + `\|` (`breadcrumb-account-separator`) + `Settings` + `>` (`far fa-chevron-right`) + `Custom Data Sets` (active) | PASS |
| A4 | 2 | Data Sets Listing Screen opens, displays available Custom Data Sets | Listing table rendered with 5 CDS rows | PASS |
| A5 | 2 | When no CDS created, a blank table is displayed | **N/A** — Adam Orfei has 5 existing CDS; empty state not reachable without deleting real data (no mutation per scope) | N/A |
| A6 | 2 | Text "Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set" below dropdown | Verbatim match: "Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set" | PASS |
| A7 | 2 | "Create a Custom Data Set" button on the right side | Button present, label "Create a Custom Data Set", x=1074 of 1280px (right side) | PASS |
| A8 | 2 | Table fields: Data Set, Created Date, Creator, Metrics, Actions | Headers: Data Set, Created Date, Creator, Metrics, Actions (cell classes `al-table__name`/`__created_at`/`__user`/`__metrics`/`__actions`) | PASS |
| A9 | 3 | Ellipsis options in order: Edit, Delete, Duplicate | `option--edit` "Edit", `option--delete` "Delete", `option--duplicate` "Duplicate" (in order) | PASS |
| A10 | 4 | 'Data Set Name' displayed under 'Data Set' column | Row names: ABcd, AbCd, Test 3 Dupes, performance test, performance test 2 | PASS |
| A11 | 4 | 'Created Date' in format Mon. DD, YYYY | Jun. 05, 2026 / Jun. 05, 2026 / May. 09, 2025 / May. 23, 2025 / Jun. 05, 2025 | PASS |
| A12 | 4 | Creator's name under 'Creator' column | Kumar Keshav Kashyap / Kumar Keshav Kashyap / Phil Cutler / Sasikumar Drylogics / Sasikumar Drylogics | PASS |
| A13 | 4 | Metrics under 'Metrics' column, separated by comma | e.g. "Engagements, Reactions, Comments, Shares, Engagements, Reactions, Comments" (Test 3 Dupes); "Reactions, Comments, Engaged User Rate, Watch Time (Minutes), Shares, Completed Views, Likes" (performance test 2) | PASS |

## Evidence

- **Settings dropdown (A1):** `.playwright-out/QA-104870/step2-settings-dropdown.png`
- **CDS listing table (A4/A6/A7/A8/A10–A13):** `.playwright-out/QA-104870/step2-cds-listing.png`
- **Dropdown active state (A2):** `.playwright-out/QA-104870/step2-dropdown-active.png`
- **Ellipsis menu Edit/Delete/Duplicate (A9):** `.playwright-out/QA-104870/step3-ellipsis-menu.png`

### First-5-row table data (A10–A13)
| Data Set | Created Date | Creator | Metrics |
|----------|--------------|---------|---------|
| ABcd | Jun. 05, 2026 | Kumar Keshav Kashyap | Engagements |
| AbCd | Jun. 05, 2026 | Kumar Keshav Kashyap | Engagements |
| Test 3 Dupes | May. 09, 2025 | Phil Cutler | Engagements, Reactions, Comments, Shares, Engagements, Reactions, Comments |
| performance test | May. 23, 2025 | Sasikumar Drylogics | Engagements, Impressions, Engagement Rate, Video Views, Video Response Rate, Clicks, Plays |
| performance test 2 | Jun. 05, 2025 | Sasikumar Drylogics | Reactions, Comments, Engaged User Rate, Watch Time (Minutes), Shares, Completed Views, Likes |

## Notes
- A5 is **N/A**, not a failure: the blank-table state requires a CDS-less account; Adam Orfei has 5. Consistent with the skill's prior QA-104870 runs ("PASS 12/13 + 1 N/A"). No substitution/mutation performed (Rule 1 / scope).
- Settings surface loaded correctly under the active Adam Orfei account this run (breadcrumb "Account: Adam Orfei") — the known "Settings surfaces don't inherit Home account" quirk did not require a re-switch here.
- No Google Sheets / export / download steps in this case — Rule 6 and GS-scope not engaged.

## Bugs filed
None. All in-scope assertions pass; A5 is a test-data (empty-state) N/A, not a defect.
