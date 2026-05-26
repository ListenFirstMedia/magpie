---
name: data-studio-historical-limit
version: 1
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 1
preconditions: [data-studio-page]
postconditions: [date-range-respects-365-day-cap]
inputs: []
outputs: []
related_pages: ["/#explore/reporting/data_studio"]
---

# Data Studio Custom Date Range — 365-day historical cap

Reporting → Data Studio supports a Custom date range with a hard cap of **365 days**. When the user selects a start (or end) that would make the range exceed 365 days, the OPPOSITE bound auto-shifts to keep the range exactly 365.

## Steps

### Open the Custom picker
- **Action:** click `Custom` button in the Date Range row.
- **Assertion:** two side-by-side month calendars open: left = Start, right = End. `« »` chevrons navigate months. Today is highlighted.

### Test "start drives end"
1. Click `«` on the left calendar until you reach a month ≥ 366 days before today.
2. Click any day in that month as the start.
3. **Observe:** the right calendar should jump to the month exactly +365 days from the start you picked, with that day highlighted as the new end.
4. **Assertion:** `end_date = start_date + 365 days`.

### Test "end drives start"
1. Navigate the right calendar (`»` chevron) to a later month if needed.
2. Click an end date that would make the range > 365 days (only possible if start was set much earlier).
3. **Observe:** the left calendar jumps to `end - 365` and highlights that day as the new start.
4. **Assertion:** `start_date = end_date - 365 days`.

### Confirm picker auto-closes / range commits
- Click outside the calendar widget. The picker closes and the chosen range remains as the active date range for any subsequent brand/metric selection.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| End date not auto-shifting | Spec broken — range can exceed 365 days | Report as bug. Capture both dates and date diff. |
| Picker doesn't close on outside-click | UI overlay bug | Document quirk; use `Escape` key as workaround. |
| Calendar shows future dates as selectable for end | UI bug — end should be capped at today (data not available in the future) | Capture which future dates are clickable. |

## Notes
- This skill is page-only; it does not validate that data actually exists for the selected range. Combine with metric selection + Go to verify data rendering (see `data-studio-post-level-run` skill).
- The 365-day cap is enforced via the date picker UI. The underlying `from`/`to` URL params are not protected from manual URL edits — that's a separate test.

## Changelog
- **v1** (2026-05-18): Initial draft from QA-83835. Both directions of the auto-adjust were verified on Adam Orfei.
