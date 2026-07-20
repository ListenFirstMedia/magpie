# QA-79157 — Mixpanel - API Metrics Publishing Analysis

- **Date:** 2026-06-08 (batch 4/12 of QA-22296)
- **Source spec:** Jira QA-79157 (title + description "ensures the Prod API Metrics publishing")
- **Skill mapped:** none — out-of-app-scope (Mixpanel third-party analytics dashboard)
- **Bug history (Closed):** APPS-46451 (API Metrics not publishing to Mixpanel)
- **Labels:** Mixpanel

## Result: BLOCKED — out-of-scope (third-party Mixpanel dashboard, Prod-only, no automation path)

## Execution

1. Read the Jira ticket — the test concerns publishing of API metrics events to Mixpanel (third-party analytics dashboard `mixpanel.com`).
2. magpie's environment is scoped to ListenFirst dev (`app.lfmdev.in`, `radaac.lfmdev.in`, etc.) plus Atlassian. There is no documented integration with Mixpanel, no credentials available, and the spec explicitly references "Prod API Metrics" — running this test would require Production access plus Mixpanel-side query/dashboard rights, neither of which is part of the magpie account.
3. Per safety policy and Rule 1 (no substitutes), this case is BLOCKED on test-data setup.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | — | Prod API metric events are published to Mixpanel | Not verifiable from magpie — Mixpanel access not available in this environment | BLOCKED |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| APPS-46451 (Closed) — API Metrics not publishing to Mixpanel | Cannot evaluate | Mixpanel dashboard not reachable. LFIQA to verify directly via Mixpanel project. |

## New findings

- **Process gap:** QA-79157 is a Mixpanel observability test that lives outside the magpie-supported surfaces. Recommend either:
  - (a) Marking such tickets as `out-of-magpie-scope` in the test set so they're not pulled into automated batches, OR
  - (b) Adding a documented Mixpanel access flow if dev/Prod has a project-shared dashboard.

## Files
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-79157-report.md` (this report)

## Bugs filed
- None. Carry-forward: ticket needs LFIQA manual verification against Mixpanel project.
