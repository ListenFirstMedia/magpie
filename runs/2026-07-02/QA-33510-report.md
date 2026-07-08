# QA-33510 — Settings > Users - Access message for External - Dev

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Result:** **OUT OF SCOPE / NOT RUN** — requires being logged in as an external (non-admin) test user.
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-33510 · Priority: Critical
- **Precondition:** Logged in with **external Test User** `testing@drylogics.com` (password given).

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Why not run
The entire point of the case is to verify that an **external / non-admin user** on Settings > Users sees the restricted view: no "Add a New User" button, and the message "If you need assistance with your account, access privileges, or any general support, please contact your Admins listed below:". This requires **signing out of the current (LFQA/admin) session and signing in as `testing@drylogics.com`** — a different, external user with separate credentials. Cross-user login is out of scope on this track (session teardown + separate creds; same class as QA-24544 / QA-29479). The current LFQA user is not external, so the restricted message would not render for it.

## Next step
Re-run in a browser context authenticated as the external test user `testing@drylogics.com` (then Settings → Users) to verify the no-Add-button + admin-contact message.

## Bugs filed
None.
