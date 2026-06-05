# QA-113722 — Admin - User Creation and Settings > Audit screen

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-113722
- **Run date:** 2026-06-04 (QA-4325 batch-9; Thursday-only test, executed on Thursday)
- **Account/User:** Adam Orfei context (spec wants Drylogics) / Yash Sharma
- **Result:** BLOCKED on safety policy
- **Skill mapped:** `settings-audit-logs`
- **Mutating:** YES — creates new user, then deactivate; cleanup non-optional

## Steps executed
1. Verified key-icon menu → Admin option present in batch-9 setup.
2. Clicked Admin → redirected to Cognito sign-in (`auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=https%3A%2F%2Fadmin.lfmdev.in%2Foauth%2Fcognito_callback`).

## Why blocked
- Spec steps 2-7 require Admin page access to navigate Accounts → Users → New User → enter first/last/email/select Drylogics primary account → Create User. Admin page is gated by Cognito sign-in requiring password entry — cannot bypass per safety policy.
- Even if Admin access were possible, spec step 8 requires re-logging in as the newly-created user "Drylogics" using a real password to verify the audit row from the Drylogics actor perspective. Per task rules: "Don't enter real passwords; user creation may need a placeholder + immediate deactivation. If a real-password sign-in is required, mark PARTIAL."

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A0 | preflight | Today is Thursday | 2026-06-04 is Thursday | PASS |
| A0b | 1 | Key icon menu Admin option | Visible in batch-9 setup screenshot | PASS |
| A0c | 2 | Admin page reachable | Cognito sign-in challenge — blocked | BLOCKED |
| A7 | 7 | User created in Admin | Cannot execute | NOT VERIFIED |
| A9a | 9 | Audit Account column displays 'Drylogics' | Cannot execute | NOT VERIFIED |
| A9b | 9 | Actor column displays your name | Cannot execute | NOT VERIFIED |
| A9c | 9 | Activity Type = 'User Created' | Cannot execute | NOT VERIFIED |
| A9d | 9 | Description = 'User #{user name} was created.' | Cannot execute | NOT VERIFIED |

## Notes
- Audit page in main app does support `User Created` enum (verified retroactively: the 2026-06-04 audit table on Adam Orfei shows `User Activated` / `User Deactivated` rows with format `User <name> was activated/deactivated.` — same enum family as the spec's 'User Created').
- Cleanup not required because no user was created.
- Recommend: LFIQA executes the Admin User Creation half manually, immediately deactivates the test user as cleanup, and re-confirms the audit row.

## Bugs filed
- None.
