# QA-104870 — Settings > Custom Data Sets - Basic View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-104870
- **Run date:** 2026-06-02 (batch 7)
- **Account:** Adam Orfei (account_id=54)
- **Priority:** Blocker (P1)
- **Result:** PASS 12/13 + 1 N/A (same as 2026-05-27 batch — A5 blank-state assertion not applicable because Adam Orfei already has 9 custom data sets configured)

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Settings in top nav | OK — full dropdown rendered |
| 2 | Click `Custom Data Sets` in dropdown | OK — navigated to `/#custom-data-sets` |
| 3 | Click Ellipsis (Actions column) on first row "Main Test 1" | OK — Edit / Delete / Duplicate menu appears |
| 4 | Review the listing table | OK — 9 rows visible, all expected columns |

## Settings dropdown contents (Step 1)

Order top→bottom: API, Audit, Authorization, Brand Sets, **Brands**, **Custom Data Sets**, Custom Metrics, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users.

## Listing table contents (Step 4)

| Data Set | Created Date | Creator | Metrics |
|---|---|---|---|
| Main Test 1 | Mar. 28, 2025 | Phil Cutler | Engagements, Impressions, Video Views, Saves, Shares, Shares |
| Some new data set name | Apr. 18, 2025 | Phil Cutler | Likes, Shares, Shares, Reactions, Engagements |
| Test | Jul. 16, 2025 | James Butler | Reactions, Comments, Reactions, Comments |
| Test 3 Dupes | May. 09, 2025 | Phil Cutler | Engagements, Reactions, Comments, Shares, Engagements, Reactions, Comments |
| Test Custom Data Set-775 | Jun. 01, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| Test Data 123 | May. 19, 2026 | LFQA Testing | Engagements, Video Views |
| create-103 | May. 30, 2026 | LFQA Testing | Video Response Rate, Video Views |
| performance test | May. 23, 2026 | Sasikumar Drylogics | Engagements, Impressions, Engagement Rate, Video Views, Video Response Rate, Clicks, Plays |
| performance test 2 | Jun. 05, 2025 | Sasikumar Drylogics | Reactions, Comments, Engaged User Rate, Watch Time (Minutes), Shares, Completed Views, Likes |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | "Custom Data Sets" appears after "Brands" in the Settings dropdown | Dropdown order: …Brands → Custom Data Sets → Custom Metrics… | PASS |
| A2 | "Custom Data Sets" is highlighted/selected in the dropdown | Highlighted entry in dropdown when on this page | PASS |
| A3 | Breadcrumb reads `Account: Adam Orfei | Settings > Custom Data Sets` above the header | Exact text rendered above the "Custom Data Sets" header | PASS |
| A4 | Page opens to Data Sets Listing screen showing available CDSes | 9 rows displayed in a single listing table | PASS |
| A5 | When no CDSes exist, a blank table is displayed | N/A — account has 9 CDSes; blank state not reproducible without admin reset | N/A |
| A6 | Helper text "Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set" displays below dropdown | Exact text rendered between the page header and the "Create a Custom Data Set" button | PASS |
| A7 | "Create a Custom Data Set" button on the right side | Yellow button rendered top-right of the listing area | PASS |
| A8 | Table columns: Data Set, Created Date, Creator, Metrics, Actions | All 5 columns present in this order | PASS |
| A9 | Ellipsis menu items in order: Edit, Delete, Duplicate | Confirmed via screenshot — three menu rows in exact order | PASS |
| A10 | Data Set Name displays under "Data Set" column | All 9 rows have a name | PASS |
| A11 | Created Date format: `Mon. DD, YYYY` | All 9 rows use abbreviated month + period + day comma + year (e.g., `Mar. 28, 2025`, `May. 30, 2026`) | PASS |
| A12 | Creator name displays under Creator column | 4 unique creators rendered: Phil Cutler, James Butler, LFQA Testing, Sasikumar Drylogics | PASS |
| A13 | Metrics displayed under Metrics, comma-separated | All 9 rows use commas + spaces to delimit metric names | PASS |

## Bugs filed
None.

## Skill registry impact

- `settings-custom-data-sets` — pass_streak +1 (Basic View flow). Same outcome as 2026-05-27.

## Sources
- [QA-104870 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-104870)
- Prior run: `/runs/2026-05-27/QA-104870-report.md` (PASS 12/13 + 1 N/A — same outcome)
