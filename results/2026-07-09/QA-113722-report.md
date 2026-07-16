# QA-113722 — Admin - User Creation and Settings > Audit screen

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Minor
- **Type:** Mutating (creates a new user)

## Verdict: SKIPPED (precondition not met — Thursday-only + Drylogics login)

## Reason
Preconditions:
- **"Only execute on Thursday."** — run day is **Friday, 2026-07-10** → not met.
- "User logged in as **Drylogics**" — a different account (not the current Adam Orfei session).
- "Only execute on Dev." (satisfied).

The Thursday-only precondition is not satisfied → skipped per test-case-first discipline. Additionally the flow needs the separate **Admin** app (key icon → Admin → Accounts → Users → New User) and a **user-creation mutation** under the Drylogics account.

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Status |
|---|---|---|
| A7 | New user created in Admin | SKIPPED (precondition) |
| A9a | Audit Account = 'Drylogics' | SKIPPED |
| A9b | Audit Actor = your name | SKIPPED |
| A9c | Audit Activity Type = 'User Created' | SKIPPED |
| A9d | Audit Description = 'User #{name} was created.' | SKIPPED |

## Note
Sibling of QA-113595 (both Admin-app → Audit reflection, both Thursday-only). The Audit log's activity tracking is confirmed present in QA-107134. Re-run on a **Thursday** with Admin access + the Drylogics account to complete; remember to deactivate/clean up the created user (mutating).

## Bugs filed
None.
