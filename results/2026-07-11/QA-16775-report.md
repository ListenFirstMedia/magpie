# QA-16775 — Dashboard - Short Link Functionality

**Run date:** 2026-07-11
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ SKIPPED — mutation consent not granted + account access unconfirmed

## Precondition

User logged in as **Drylogics** (per Jira; `dashboard-mutation-flows` skill notes this maps to the LFIQA test-account roster and has not been confirmed reachable from the LFIQA account switcher).

## Why skipped

1. **Mutation gate:** the case requires creating a real dashboard (`dashboard-mutation-flows` skill, marked ⚠ MUTATING). The skill's mandatory pre-flight requires the user to explicitly type "OK to mutate dashboard `<name>`" before any create/drag/delete step runs. No such consent was given in this run.
2. **Account access unconfirmed:** the "Drylogics" account has not been previously confirmed reachable from the LFIQA account switcher in this framework (per the existing `testcases/english/QA-16775.md` note from a prior session).
3. Per the run instructions ("if issues come, skip that test case and execute another"), this case was skipped rather than blocking the batch.

## What would unblock this

- Explicit user consent: "OK to mutate dashboard QA-16775-TEST-<date>" (and confirmation that cleanup/delete is acceptable).
- Confirmation that "Drylogics" is reachable via Search Account from the LFIQA login, or the correct substitute account name.

## Note — read-only short-link mechanics already documented

The short-link *mechanism itself* (pin/link icon → `https://app.lfmdev.in/#s/<slug>` → resolves to the full dashboard URL without the `create=success` param) is already documented as verified in `skills/dashboard-mutation-flows/SKILL.md` ("Read-only / navigation details" section) from an earlier session. This run did not re-verify it end-to-end because doing so still requires creating (and then deleting) a real dashboard, which is the same mutation-gate step above.

## Steps NOT executed

All steps (1–5: Create Dashboard → Pin → open short link in new tab) — blocked at step 1 by the mutation gate.

## Result: ⛔ SKIPPED (mutation consent gate + unconfirmed account access)

## Bugs filed

None.

## Cleanup

Not applicable — no steps executed.
