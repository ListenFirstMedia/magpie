# QA-33510 — Settings > Users - Access message for External - Dev (DEFERRED again)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-33510
- **Run date:** 2026-06-02 (batch 11)
- **Account:** Adam Orfei (account_id=54) for baseline; spec calls for sign-in as External user `testing@drylogics.com`.
- **Result:** DEFERRED — same fundamental blocker as 2026-05-27 PARTIAL. Password-based sign-in for second accounts is OUT-OF-BOUNDS per Claude security constraint. Cannot become an External user via automation.

## Baseline (admin view) captured for contrast

Signed in as Yash (admin), navigated to `#users?account_id=54`:

- `Add a New User` button **IS** displayed (yellow primary, top-right).
- No "If you need assistance with your account…" message shown — the page renders a full Users table with: First Name | Last Name | Email | Phone | Job Title | Role | Customer | Business Unit | Account | Status | MFA | API | Last Active | Actions.
- Header shows `Seat Licenses (180/500): 320 seat licenses are available.`
- Filter row: Add Filter / Apply Filter / Load Filter / Save Filter / Clear All
- View by: Active Users (checked) / Deactivated Users.

This confirms the admin path renders as designed; the spec is testing the inverse for an External-role user.

## What would be required to PASS

Sign out → sign in as `testing@drylogics.com` (External role, password supplied in Jira ticket) → navigate to `Settings > Users` → verify:

- A1: `Add a New User` button is NOT displayed.
- A2: Message `If you need assistance with your account, access privileges, or any general support, please contact your Admins listed below:` rendered above an admin-contact list.

## Why this is OUT-OF-BOUNDS for Claude

Claude security rules categorically prohibit entering passwords or credentials to authenticate as another user — sign-in via password is a Prohibited action ("Entering financial credentials, … passwords, API keys, or tokens into any field" and "Creating accounts, or entering passwords to authenticate"). This applies even when the password is provided in the spec.

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 2a | `Add a New User` button is NOT displayed for External user | NOT VERIFIED — cannot sign in as external user | DEFERRED |
| A2 | 2b | External-user message displayed verbatim | NOT VERIFIED — same | DEFERRED |

## Bugs filed

None.

## Skill registry impact

No existing skill covers this. Carry forward: framework needs a manual-LFIQA channel for any test that requires becoming a different user.
