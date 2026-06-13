# QA-104876 — Settings > Custom Data Sets - Delete Functionality

**Run:** 2026-06-05 (batch 6/12 of QA-22296)
**Account:** Adam Orfei (account_id=54)
**Tester:** Yash via magpie
**⚠ MUTATING TEST** — full create + delete + cleanup cycle.

## Pre-test
- Spec: Verify Delete functionality on Settings > Custom Data Sets listing.
- Bug history: no open/closed bug links — clean test.
- Skill: `settings-custom-data-sets`, `dashboard-mutation-flows` patterns.

## Steps executed
1. Navigated to `https://app.lfmdev.in/#custom-data-sets?account_id=54`.
2. Custom Data Sets listing rendered with 8 existing rows. Columns: Data Set / Created Date / Creator / Metrics / Actions.
3. Clicked "Create a Custom Data Set" button. Form opened.
4. Entered Data Set Name: `QA-104876-test-1780915800` (unique timestamped identifier).
5. Selected metric: `Engagements` (Public).
6. Clicked Create. Returned to listing.
7. **Verified** new row `QA-104876-test-1780915800` present (Jun. 08, 2026 / Yash Sharma / Engagements).
8. Clicked Actions ellipsis on the new row. Menu opened with: Edit / Delete / Duplicate.
9. Clicked Delete. Confirmation modal opened:
   - Title: "Delete"
   - Body: **"Are you absolutely sure you want to delete your data set 'QA-104876-test-1780915800'? Click 'Ok' to continue."**
   - Buttons: Cancel + Ok
10. Clicked Ok. Modal closed; row immediately removed from listing.
11. F5 refresh. **Deletion persistent** — row stays gone after reload. Listing back to 8 pre-create rows.

## Findings
- Delete flow is end-to-end functional.
- Confirmation modal includes the **exact CDS name** in the body text — matches QA-135430 Custom Metrics delete pattern (consistent UX across Settings entities).
- Ellipsis menu order: **Edit / Delete / Duplicate** (matches `settings-custom-data-sets` skill enumeration from QA-104870).
- No latency issues; deletion + UI refresh completed within <2 seconds of Ok click.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Custom Data Sets list renders with Actions column | Ellipsis present on each row | Confirmed — 8 rows + Actions | PASS |
| A2 | Ellipsis menu shows Edit / Delete / Duplicate | All 3 actions in this order | Confirmed | PASS |
| A3 | Delete confirmation modal shows CDS name in body | "Are you absolutely sure...'<name>'?" pattern | Verbatim match | PASS |
| A4 | Cancel and Ok buttons present in modal | Yes | Confirmed | PASS |
| A5 | Clicking Ok removes row from listing | Immediate row removal | Confirmed | PASS |
| A6 | Deletion persistent across refresh | F5 reload shows row still absent | Confirmed | PASS |

## Result
PASS — Settings > Custom Data Sets Delete Functionality works end-to-end. Cleanup completed in-flow (test CDS created and deleted in the same session).

## Cleanup status
**Complete** — `QA-104876-test-1780915800` deleted; listing restored to 8 pre-existing rows.

## Bugs filed
None.

## Skill credit
- `settings-custom-data-sets` — extend to cover Delete + confirmation modal pattern (in addition to existing Basic View + Create + Cleanup coverage from QA-106218). +1 streak.
- `dashboard-mutation-flows` — generic mutation+cleanup pattern reused successfully. +1 streak.
