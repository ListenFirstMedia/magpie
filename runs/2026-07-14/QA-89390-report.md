# QA-89390 — Dashboards - Brand Content Insights - Functionality to save filtered tiles to the dashboard

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ⛔ SKIPPED — Mutation policy

## Reason

This case requires creating a **new, permanently-named dashboard** ("Brand Content insights Dashboard" — not a throwaway `QA-XXXXX-TEST-` prefixed name, per the spec's literal step 6 wording) and saving two live tiles to it. The relevant skill, `skills/dashboard-mutation-flows/SKILL.md`, carries an explicit mandatory pre-flight gate:

> ⚠ MUTATING SKILL — every step in this skill alters real database state. Requires explicit user confirmation per the project's no-auto-mutation rule... If not, STOP and request consent. Report the case as ⛔ Skipped — Mutation policy.

No explicit per-dashboard consent (e.g. "OK to mutate dashboard Brand Content insights Dashboard") was given in this session. Per the skill's own gate — which is stricter than the general "mutating test + cleanup" convention used for self-contained entities like Custom Metrics — this case is skipped rather than executed unilaterally, since the dashboard name specified by the spec is not obviously a disposable test artifact and dashboards are more account-visible/shared state than a personal custom metric.

## Steps executed

None (blocked at pre-flight).

## Assertions

Not evaluated.

## Bugs filed

None.

## Cleanup

Not applicable — no mutation was performed.

## Follow-up needed

Ask the user for explicit consent to create+delete a dashboard for this test (or agree on a `QA-89390-TEST-<date>`-prefixed name instead of the spec's literal name), then re-run.
