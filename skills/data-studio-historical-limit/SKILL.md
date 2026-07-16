---
name: data-studio-historical-limit
version: 1
last_verified: 2026-07-10
last_passed_run: 2026-07-10
trust: untrusted
pass_streak: 3
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

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v1** (2026-05-18): Initial draft from QA-83835. Both directions of the auto-adjust were verified on Adam Orfei.

## 2026-06-11 batch-3 update (QA-83835 re-pass)

- Both clamp directions re-verified (start Jun 10 2025 ⇄ end Jun 9 2026; moving start to Jun 3 auto-pulled end to Jun 2 2026; moving end back to Jun 9 pushed start to Jun 10). Year-long MTV FB Total Fans report rendered (295904).
- **Same duplicate-hidden-datepicker trap as TWC:** two `.from-calendar` instances; filter by `offsetParent` or your day-clicks silently apply to the hidden one and the report runs on the default 7D (looked exactly like a "custom range ignored" product bug — it wasn't).

## 2026-07-10 QA-4204 mop-up re-pass (Playwright MCP)

- Both clamp directions re-verified a 3rd time (start Apr 15 2025 ⇄ end Apr 15 2026; moving end to May 20 2026 pulled start to May 20 2025). Report 302117, MTV Authorized Facebook Total Fans, Sum 16,525,547,297.
- **Promoted to pass_streak 3** (3 separate-day passes: 2026-05-18, 2026-06-11, 2026-07-10) — eligible for stable promotion on next human review per the untrusted→stable rule.
- New Playwright-specific findings: (1) the real commit button is `getByRole('button', {name:'Ok', exact:true})` — a `.refresh-date-range` class selector resolves to the hidden compare-range widget's Ok button and times out; (2) rapid synchronous `.click()` calls on the prev-chevron in a tight loop silently drop most clicks — insert a ~150ms delay between clicks when paging back many months via `evaluate`.
