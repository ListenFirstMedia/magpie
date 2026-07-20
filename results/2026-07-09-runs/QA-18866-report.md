# QA-18866 — Mixpanel - Session Start/Session End Event Properties

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED

## Precondition

Spec precondition: "User is logged in to Mixpanel Dev as https://mixpanel.com/report/1485629/dashboards# / .../app/insights#...". All steps build an Insights report inside Mixpanel's own UI, not `app.lfmdev.in`.

## Why blocked

Mixpanel is a separate external analytics tool with its own login, distinct from the LFM app creds in `config/.env`. No Mixpanel credentials or session are configured for this framework.

## What would unblock this

Provide Mixpanel login credentials (or an existing Mixpanel session/storageState) for the automation account. Note QA-40815 and QA-52779 (partially) share this same blocker — worth solving once for all three.

## Cleanup

None — no steps executed.

## Bugs filed

None.
