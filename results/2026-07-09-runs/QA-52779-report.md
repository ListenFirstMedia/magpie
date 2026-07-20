# QA-52779 — Settings > User > Create new user for Admin - External - Dev

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — account-creation safety policy (pre-existing determination, reconfirmed)

## Precondition

Adam Orfei is the runtime account. External User Test Acct `testing@drylogics.com` referenced but not required for the blocked portion.

## Why blocked

This determination was already recorded in `testcases/english/QA-52779.md`'s "Why blocked" section at ingestion time:

1. Step 6 ("Add User") creates an actual external user account — blocked by this framework's "never create accounts on the user's behalf" safety policy, same boundary documented today for **QA-28799** (the sibling internal-Admin-user creation case).
2. Steps 7–10 require Dev Mixpanel access, which this framework has no configured credentials for.

Re-checked today (2026-07-09) for anything that would change this determination — no Mixpanel credentials have been added to `config/`, and the account-creation policy is unchanged. Determination stands.

## Steps NOT executed

All steps (1–10). No user was created; no Settings > Users page state was touched.

## Result: ⛔ BLOCKED (account-creation policy + no Mixpanel access — unchanged from ingestion-time determination)

## Bugs filed

None.

## Cleanup

Not applicable — no steps executed, no user created.
