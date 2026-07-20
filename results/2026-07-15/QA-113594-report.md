# QA-113594 — Settings > Audit - External User View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-113594
- **Priority:** Critical
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** External User (testing@drylogics.com) — Adam Orfei (account_id=54)

## Steps executed

1. Signed out of the default `lfiqa@listenfirstmedia.com` session; signed in fresh as `testing@drylogics.com` (external-user test account). Post-login header confirmed **"Account: Adam Orfei"** and user-menu label **"testing"**.
2. Settings (top nav) → Audit tab → table rendered with account_id=54 scope.
3. Clicked the Filter dropdown ("Select").

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 1(a) | 1 | Columns should NOT display "Customer", "Business Unit", "Account" | Table header row = `Date, Actor, Activity Type, Description` only — none of Customer/Business Unit/Account present | PASS |
| 1(b) | 1 | Columns display "Date", "Actor", "Activity Type", "Description" | Confirmed exact 4-column header, in that order | PASS |
| 2 | 2 | Filter dropdown displays only "Activity", "Activity Log", "Actor" | Dropdown search-list rendered exactly `Activity`, `Activity Log`, `Actor` — no other options | PASS |

## Notes

- External-user session ("testing") shows a bell-icon Data-Last-Updated indicator as `(–)` on Home rather than the internal-user's full `Data Last Updated (PT): ...` text — a UI difference between internal/external user chrome, not in scope for this ticket's assertions, noted for awareness.
- No mutating actions — no cleanup required.
- Signed back out and re-authenticated as the default `lfiqa@listenfirstmedia.com` account before proceeding to the next ticket (since remaining QA-22296 tickets require the internal LFIQA session).

## Status: **PASS** (2/2 assertion groups, 3/3 individual checks)

## Cleanup
Non-mutating test — no cleanup required. Session credentials restored to `lfiqa@listenfirstmedia.com` for subsequent tickets.
