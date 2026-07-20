# QA-28799 — Settings > User > Create new user for Admin - Dev

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — account-creation safety policy

## Precondition

User logged in as Adam Orfei.

## Why blocked

This case's steps 4–7 create a real user account (Drylogics account, real email address, real phone number/job title) inside the LFM platform, then step 10 deactivates it, and steps 11–13 require signing into Dev Mixpanel to inspect that user's activity feed.

Per this framework's standing safety policy — "never create accounts on the user's behalf" — creating a user record (even one immediately deactivated as cleanup) is an account-creation action, not a content mutation like a tag or a dashboard. This is the same reasoning already documented for **QA-52779** (`testcases/english/QA-52779.md`, "Why blocked" section), which is the sibling case for creating an *external* Drylogics user rather than an internal Admin/Analyst one — both hit the identical policy boundary.

Additionally, steps 11–13 require Dev Mixpanel access, which this framework has no configured credentials or session for (same gap noted in QA-52779 and in `knowledge-base/bug-history.md`'s Mixpanel-access entries).

## What would unblock this

- Explicit, case-by-case user authorization to create a real (even if immediately deactivated) user account — this is a categorically different risk tier than the mutating tests this framework already runs routinely (tags, dashboards, custom metrics), which mutate content/config, not identity/access records. I did not treat the earlier "run the remaining test cases" instruction as blanket authorization for this tier, consistent with how QA-52779 was already self-blocked without being re-litigated.
- Mixpanel Dev credentials configured into this framework for steps 11–13.

## Steps NOT executed

All steps (1–13). No user was created; no Settings > Users page state was touched.

## Result: ⛔ BLOCKED (account-creation policy, consistent with QA-52779)

## Bugs filed

None.

## Cleanup

Not applicable — no steps executed, no user created.
