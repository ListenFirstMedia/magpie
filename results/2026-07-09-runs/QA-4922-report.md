# QA-4922 — Full Story - Event Properties

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED

## Precondition

Same FullStory precondition as QA-4915: "User is logged in to Full Story as https://app.fullstory.com/ui/HCHY4/onboarding/profile." All steps operate on the FullStory Segment/Event Filters builder, not `app.lfmdev.in`.

## Why blocked

Same as QA-4915 — no FullStory credentials/session configured in this framework.

## What would unblock this

See QA-4915-report.md. If FullStory access is added, QA-4915 and QA-4922 can both run in the same authenticated session (they share the login precondition).

## Cleanup

None — no steps executed.

## Bugs filed

None.
