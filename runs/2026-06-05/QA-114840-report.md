# QA-114840 — Settings > User - Export Functionality (External User)

- **Date:** 2026-06-08 (batch 8/12 QA-22296)
- **Result:** BLOCKED — safety policy

## Reason

Spec preconditions require login as External User Test Account:
- Username: testing@drylogics.com
- Password: 5stS6;7e&My*kt1"Ipdc

Per Cowork safety policy ("Prohibited (never perform; direct the user to do it themselves) → Entering financial credentials, ..., passwords, API keys, or tokens into any field"), magpie cannot enter this account password to log in. Even though the spec embeds the password in the test case, the safety policy takes precedence.

## Status

BLOCKED — magpie cannot perform the login step. LFIQA must execute this case manually:

1. Open incognito/private window or sign out of current LF session.
2. Sign in at `app.lfmdev.in` with testing@drylogics.com / 5stS6;7e&My*kt1"Ipdc.
3. Hover Settings → Users.
4. Click Export → CSV.
5. Verify: Export-button position left of "Add a New User", popup options CSV+Google Sheets, filename `Account-Users-MM-DD-YYYY.csv`, columns First Name / Last Name / Email / Phone / Job Title / Last Active, no column duplicates.

## Notes
- Same blocker pattern as QA-113594 + QA-113723 (Admin-page Cognito-gated) and QA-33510 (external user role provisioning) — credentialed login blocked.
- No bug filed.

## Bugs filed
None.
