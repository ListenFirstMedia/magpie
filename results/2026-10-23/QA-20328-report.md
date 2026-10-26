# QA-20328 — Brand Content > Twitter Only: Engagements & Follows Data Set > Past date range data test

**Run date:** 2026-10-23 (Friday) — unattended, headless
**Verdict: FAILED (blocked by open bug)** — LFMP-32088

## Screening (spec-adherence Rule 7)

The case file's "Open linked bugs" section lists one open bug, and the fresh open-bug snapshot
(`results/open-bugs-2026-10-23.json`) confirms it is still open today:

| Bug | Status | Summary |
|---|---|---|
| LFMP-32088 | Open | Brand > Content > Twitter Only: Engagements & Follows, User follows |

The bug is on the same surface and metric as this case's only assertion (User Follows = Organic + Paid
User Follows). Per Rule 7 and the open-bug auto-fail directive (2026-10-22), the case was not executed
and the browser was not opened.

## Steps executed

None (screened out before execution).

| # | Step | Status |
|---|---|---|
| 1 | Hover Brand, select Content from Top Nav | Not run |
| 2 | Add brand, date range Jan 01 2024 - Dec 31 2024 | Not run |
| 3 | Select Twitter Only: Engagements & Follows Dataset | Not run |
| 4 | Sum Organic User Follows + Paid User Follows per post | Not run |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic User Follows + Paid User Follows = User Follows | Not evaluated (blocked by open LFMP-32088) | FAILED (blocked by open bug) |

## Evidence

No screenshots or DOM captured (no browser session was started). Evidence is the bug status in
`results/open-bugs-2026-10-23.json` and the "Open linked bugs" section of `cases/QA-20328.md`.

## Known bugs checked

- LFMP-32088 (Open) — blocking. Also the blocker for QA-19705, which shares this bug.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-20328 (pre-fetched grep).

## Bugs filed

None. No new bugs found (the case was not run). No Jira tickets created.

## Re-run

This case will be picked up automatically once LFMP-32088 is closed and the open-bug cache is refreshed.
On re-run, use the weekday-rotation account/brand row for the run day (Friday: Hulu / Hulu).
