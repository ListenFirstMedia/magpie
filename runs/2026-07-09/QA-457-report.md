# QA-457 — TWC Rate Data QA

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — test-data/environment gap

## Precondition

User is logged in as Disney Ad Sales.

## Why blocked

The test case's core assertion is **"Ensure dev and stage data match"** — this requires running the identical TWC report configuration on both a `dev` environment and a `stage` environment, then comparing results.

This framework (`config/env.md`, `MIGRATION.md`, and every `knowledge-base/` file) documents and configures exactly **one** environment: `app.lfmdev.in` (dev), reached via the Cognito "With existing account" login flow. No `stage` hostname is referenced anywhere in the repo.

Confirmed unreachable via direct DNS resolution attempts:
- `stage.lfmdev.in` — `curl: Could not resolve host`
- `app-stage.lfmdev.in` — `curl: Could not resolve host`

Per Rule 1's "spec drift / test-data gap" guidance: this is not a case where a substitute environment exists and I picked the wrong one — no stage environment is configured or reachable from this framework at all. Running the dev-side half of the TWC report alone would not exercise the actual assertion (a same-environment comparison of dev-vs-dev is not "ensure dev and stage data match").

## What would unblock this

- A `stage.lfmdev.in`-equivalent URL, reachable from this network, added to `config/env.md`.
- Confirmation of whether "stage" in this spec refers to a literal separate ListenFirst deployment, or to something else (e.g., a staging data-refresh window on the same dev instance) — the spec wording alone doesn't disambiguate, and I don't want to guess given the BC-3/BC-2 retraction history in this project.

## Steps NOT executed

Steps 1–8 (Reporting → Time Window Comparison → Absolute Date Range → Disney Channel Public Data rate metrics + Show Share/Show Change → Run Report) were not started, since the case's only assertion depends on the stage-side run existing to compare against, and running only the dev half would produce a report with nothing to verify against.

## Result: ⛔ BLOCKED (test-data/environment gap — no substitute attempted, per Rule 1)

## Bugs filed

None.

## Cleanup

Not applicable — no steps executed.
