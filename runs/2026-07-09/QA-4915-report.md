# QA-4915 — Full Story - User Properties

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED

## Precondition

Spec precondition: "User is logged in to Full Story as https://app.fullstory.com/ui/HCHY4/onboarding/profile." Every step operates entirely inside the FullStory web app (Segment builder, User Filters), not `app.lfmdev.in`.

## Why blocked

FullStory is a separate external tool with its own login, distinct from the `LFM_EMAIL`/`LFM_PASSWORD` creds in `config/.env`. No FullStory credentials or session are configured for this framework.

## What would unblock this

Provide FullStory login credentials (or an existing FullStory session/storageState) for the automation account, and confirm it's in scope to add a second auth surface to `config/env.md`.

## Cleanup

None — no steps executed.

## Bugs filed

None.
