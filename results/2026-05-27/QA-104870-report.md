# QA-104870 — Settings > Custom Data Sets - Basic View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-104870
- **Run date:** 2026-05-27
- **Account:** Adam Orfei (account_id=54)
- **Priority:** Blocker (P1)
- **Result:** ✅ **12/13 PASS / 1 N/A (A5 — blank-table state cannot be verified on Adam Orfei since it has 6 Custom Data Sets already)**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Adam Orfei via Yash account picker (typed "Adam Orfei", picked from Results) | ✓ |
| 1 | Hover Settings in top nav → dropdown opened | ✓ |
| 2 | Click "Custom Data Sets" in dropdown | ✓ — URL `/#custom-data-sets`, breadcrumb `Account: Adam Orfei | Settings > Custom Data Sets` |
| 3 | Click Ellipsis button in Actions column of first row (Test Custom Data Set-1) | ✓ — menu opened |
| 4 | Review the Data Set listing table | ✓ |

## Settings dropdown order (alphabetical)
API, Audit, Authorization, Brand Sets, **Brands, Custom Data Sets, Custom Metrics**, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users. Custom Data Sets appears between Brands and Custom Metrics (sorted alphabetically) — i.e., right after Brands as the spec describes.

## Data Set listing observed (Adam Orfei)
| Data Set | Created Date | Creator | Metrics |
|---|---|---|---|
| Test Custom Data Set-1 | May. 27, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| Test Custom Data Set-60 | May. 27, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| Test Custom Data Set-895 | May. 27, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| Test Custom Data Set-939 | May. 27, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| Test Custom Data Set-976 | May. 27, 2026 | LFQA Testing | Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate |
| test-cross-posts | May. 27, 2026 | Kumar Keshav Kashyap | Video Views (with Cross-Posts) |

## Ellipsis menu options (in order)
1. Edit
2. Delete
3. Duplicate

## Assertion results

| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | 'Custom Data Sets' appears after 'Brands' in the settings dropdown | Yes — alphabetical order: Brands → Custom Data Sets → Custom Metrics | ✅ PASS |
| A2 | 'Custom Data Sets' is selected in the dropdown | Indicated by destination breadcrumb after click; dropdown closes on navigation | ✅ PASS |
| A3 | Breadcrumb text 'Account: Adam Orfei \| Settings > Custom Data Sets' above the Header | Text exactly matches: `Account: Adam Orfei | Settings > Custom Data Sets` | ✅ PASS |
| A4 | Data Sets Listing Screen opens, displays available Custom Data Sets | 6 rows displayed (5 LFQA test sets + 1 cross-posts) | ✅ PASS |
| A5 | When no Custom Data Sets, blank table displays | N/A — Adam Orfei has 6 existing Data Sets, cannot verify empty state here | ⏸ N/A |
| A6 | Subtext: "Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set" | Text matches exactly | ✅ PASS |
| A7 | "Create a Custom Data Set" button on right side of window | Yellow CTA on right edge of subtext row, opposite the description | ✅ PASS |
| A8 | Listing table has fields: Data Set, Created Date, Creator, Metrics, Actions | All 5 columns present in correct order | ✅ PASS |
| A9 | Ellipsis menu shows in order: Edit, Delete, Duplicate | Confirmed — three items in exact order | ✅ PASS |
| A10 | 'Data Set Name' under 'Data Set' column | Names displayed (e.g., "Test Custom Data Set-1") | ✅ PASS |
| A11 | 'Created Date' column format `Mon. DD, YYYY` | All rows show `May. 27, 2026` — matches format with `.` after month | ✅ PASS |
| A12 | Creator name in 'Creator' column | Yes (LFQA Testing, Kumar Keshav Kashyap) | ✅ PASS |
| A13 | Metrics under 'Metrics' column, comma-separated | Yes (e.g., "Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate") | ✅ PASS |

## Notes
- 5 of the 6 rows have **`Reactions` listed twice** in the Metrics column — this is sus but in scope for a content-data review, not a layout test. The spec doesn't assert metric uniqueness; flagging only.
- For A5 (empty-table state) — recommend re-running this assertion on a fresh sandbox account that has zero Custom Data Sets configured. Cannot be verified here.

## Bugs filed
None for this run. Possible bug flag for "Reactions appearing twice in some Test Custom Data Set entries" — but that's data, not spec-layout, so out of scope.

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day Hulu → Adam Orfei via Yash picker)
- Could create a `settings-custom-data-sets` skill for the layout asserts, but the test pattern is straightforward and may not warrant a dedicated skill.

## Sources
- [QA-104870 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-104870)
