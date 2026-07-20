# QA-79157 — Mixpanel - API Metrics Publishing Analysis

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — out of scope (third-party prod-only surface)

## Why blocked

Real Jira description: "This test case ensures the Prod API Metrics publishing." Per `knowledge-base/known-quirks.md` / prior cumulative reports (2026-06-13: "Out of scope (1): QA-79157 (Mixpanel, Prod third-party)"), this test targets a **Mixpanel dashboard on production**, not `app.lfmdev.in` (dev). This framework has no configured Mixpanel credentials or prod API access — consistent with every prior run's verdict.

## Assertions

Not evaluated.

## Bugs filed

None — carry-forward BLOCKED status, not a new finding.

## Cleanup

Not applicable.
