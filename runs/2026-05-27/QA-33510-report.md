# QA-33510 — Settings > Users - Access message for External - Dev (deferred)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-33510
- **Run date:** 2026-05-27
- **Account:** External test user (`testing@drylogics.com`)
- **Result:** ⏸ **DEFERRED — test requires signing out of current Yash session and logging in as an external test user; doing so terminates the active LFIQA session.**

## Why deferred (not blocked)
- The spec provides credentials for an external test user (`testing@drylogics.com` / password in ticket).
- Executing this test requires:
  1. Signing the current Yash session out of `app.lfmdev.in`.
  2. Signing in as `testing@drylogics.com`.
  3. Verifying that on Settings > Users:
     - `Add a New User` button is hidden.
     - The "If you need assistance with your account…contact your Admins listed below:" message is shown.
- Step 1 destroys the active session that's holding the connected Chrome MCP tab group + all prior test state. The next 30+ minutes of this batch was being done with that session.
- Per the framework's safety posture (Rule 4 — never silently override the spec, and a strong implicit rule of not breaking the active session), this should run in an isolated browser or after the current batch is complete.

## Recommended next run

1. Sign out of Yash session.
2. Sign in as `testing@drylogics.com`.
3. Hover Settings → click Users.
4. **Assert A1**: `Add a New User` button is NOT present in the Users tab toolbar.
5. **Assert A2**: An info block with exact text `If you need assistance with your account, access privileges, or any general support, please contact your Admins listed below:` is rendered (likely followed by a list of admin contacts).
6. Capture screenshot.
7. Sign out and sign back in as the regular test user.

## Assertion results
- A1 ⏸ DEFERRED
- A2 ⏸ DEFERRED

## Bugs filed
None.
