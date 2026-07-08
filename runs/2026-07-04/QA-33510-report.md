# QA-33510 — Settings > Users - Access message for External - Dev

**Run date:** 2026-07-04
**Branch:** feature/playwright-mcp
**Verdict:** SKIPPED — external-user precondition (deferred)

## Summary

QA-33510 validates that a user with an **External** role, when navigating Settings → Users, sees:
- A1: NO "Add a New User" button.
- A2: a contact-your-admins message.

The case's **precondition requires authenticating as a different user identity** than the
`config/.env` login: `testing@drylogics.com` (an External-role test user, password only in the
Jira Xray Preconditions field, not in `config/.env`).

Per the run's **SCOPE RULES (external-user / second-identity)**: when the preconditions require
authenticating as a DIFFERENT user identity than `config/.env` — which in-app account-switching
CANNOT satisfy — the flow is **not attempted**. This case is SKIPPED and deferred; no browser
exploration was spent on it (pre-flight login as the config identity would not, and cannot,
make us the External user).

## Why account-switching cannot satisfy this

In-app account switching changes the **account/brand context** of the *currently logged-in user*;
it does **not** change the user's *identity or role*. Evaluating A1/A2 requires the session to be
authenticated as an actual External-role user, which needs a full Sign Out + re-auth as
`testing@drylogics.com` — outside the scope of this unattended run (and, per prior findings below,
even that does not land on an account where the user is External).

## Corroborating prior finding (knowledge-base/known-quirks.md, 2026-06-28)

> **QA-33510 External-user test: named test user is Admin on the reachable account → BLOCKED,
> not a bug.** After full re-authentication as `testing@drylogics.com`, the app pins to the last
> active account (Adam Orfei, account_id=54), where that user is provisioned **Admin**. The Users
> page therefore correctly renders the full admin view (Add a New User visible, Export, full user
> list); the External message is absent. A1/A2 are Not Evaluable — the *precondition* (user being
> External) is unmet, not a product defect. Do NOT file A1/A2 as FAIL (would repeat the QA-91412
> wrong-configuration false-positive; Rules 1 & 5).

This independently confirms the correct handling: do not attempt to force A1/A2, do not substitute
the internal lfiqa account (which is Admin → guaranteed false A1).

## Steps executed

None. The case was screened out at the precondition stage (external-user identity) before opening
the browser flow, per SCOPE RULES.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2a | 'Add a New User' button is NOT displayed | Not evaluated — External-user precondition unmet | SKIPPED |
| A2 | 2b | Message: "If you need assistance with your account, access privileges, or any general support, please contact your Admins listed below:" | Not evaluated — External-user precondition unmet | SKIPPED |

## Open-bug screen (Rule 7)

Case file "## Open linked bugs" (as of 2026-07-03): **None open. Screen only — run normally.**
Rule 7 does not block this case; the SKIP is driven solely by the external-user precondition.

## Evidence

No screenshots captured — no browser flow was run (immediate SKIP per SCOPE RULES).

## Bugs filed

None. Per Rule 5 and the 2026-06-28 known-quirk, the missing External view here is a **test-data /
precondition gap** (the named user is not External on the reachable account), not a product defect.
Do not file A1/A2 as failures.

## Revisit if

- The test user `testing@drylogics.com` is re-provisioned with an **External** role on a reachable
  account, OR the spec names the specific account where that user holds an External role.
- The unattended run gains the ability to authenticate as a second user identity (creds for the
  External user provisioned into `config/.env` or an equivalent secret).
