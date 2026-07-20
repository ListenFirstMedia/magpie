# QA-29479 — Dashboards - Share Dashboard via Email

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-29479
- **Run date:** 2026-05-27
- **Account:** Adam Orfei (primary) + `lfm-qa@drylogics.com` (recipient)
- **Result:** ⏸ **DEFERRED — same posture as QA-33510. Test requires signing out of the current Yash session and signing back in as `lfm-qa@drylogics.com`, which would terminate the active LFIQA Chrome MCP session.**

## Why deferred (not blocked)
The test steps explicitly require:

> 6. Signout the current User in the LFM page.
> 7. SignIn with `lfm-qa@drylogics.com` mail and Password `[redacted]`.
> 8. Login to Adam Orfei's Account.
> 9. Open Gmail in a new tab and Open the corresponding email in the lfm-qa@drylogics.com.
> 10. Click View Dashboard button.

Plus a precondition that `Mail Testing Dashboard` already exists (from QA-14398).

Per the framework's safety posture:
1. Signing out destroys the active session that's holding the connected Chrome MCP tab group and all the in-flight test state — same concern as QA-33510 (which you previously approved deferring).
2. The test also requires Gmail access for the `lfm-qa@drylogics.com` mailbox — automation cannot reliably read that inbox.

## What was NOT attempted
- Sharing the dashboard (steps 1-5) was also not attempted because step 5 is the irreversible action that sends an email to the test recipient; per Rule 4 + Rule 6, executing the share half without verifying the receipt half adds noise to the recipient inbox.

## Recommended next-pass coverage
A LFIQA hands-on run is the right pattern here:
1. Sign in as Yash (current user).
2. Open `Mail Testing Dashboard` → Options → Share → add `lfm-qa@drylogics.com` → Share.
3. Sign out → sign in as `lfm-qa@drylogics.com` → enter Adam Orfei's account.
4. Open Gmail → open the share email.
5. Verify subject `[lfm-qa] Yash Shared a ListenFirst Dashboard With You`, ListenFirst logo, body text `Hi Automation Account, Yash shared the Mail Testing Dashboard dashboard with you. Please click here to view it`, View Dashboard button.
6. Click View Dashboard → saved dashboard opens.

## Assertion results
All assertions ⏸ DEFERRED.

## Bugs filed
None.
