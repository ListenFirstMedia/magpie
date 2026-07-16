# QA-458 — TWC Report Relative Date Rates Data QA

**Run date:** 2026-07-11
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — test-data/environment gap

## Precondition

User is logged in as Adam Orfei.

## Why blocked

The case's only assertion (A1) is **"Ensure data matches between dev and prod"** (step 13: "Repeat all steps in a new tab for stage/prod"). This requires running the identical TWC report configuration on two separate deployments and comparing results.

This framework (`config/env.md`, `MIGRATION.md`, every `knowledge-base/` file) documents and configures exactly **one** reachable environment: `app.lfmdev.in` (dev). No `stage` or `prod` hostname is configured anywhere in the repo. `knowledge-base/bug-history.md:1206` independently confirms this exact gap: "Stage comparison NOT VERIFIED — magpie operates against dev (`app.lfmdev.in`) only... needs manual cross-env access."

This is the same root-cause environment gap already hit and BLOCKED on **QA-457** (2026-07-09, identical "dev vs stage/prod" assertion pattern on the TWC report). Per Rule 1's "spec drift / test-data gap" guidance, running only the dev-side half of the report would not exercise the actual assertion (a same-environment comparison of dev-vs-dev is not "ensure dev and prod data match"), so steps were not started.

## What would unblock this

- A reachable `stage`/`prod`-equivalent URL added to `config/env.md`.
- Confirmation of what "dev and prod" actually refers to in this spec, given LFM's product is documented here as having only one QA-reachable deployment.

## Steps NOT executed

Steps 1–12 (Reporting → Time Window Comparison → Relative Dates → The Walking Dead keydate S9E16 rate metrics + Show Share/Show Change → Run Report) were not started on the dev side alone, since the case's only assertion depends on a second environment to compare against.

## Result: ⛔ BLOCKED (test-data/environment gap — no substitute attempted, per Rule 1)

## Bugs filed

None.

## Cleanup

Not applicable — no steps executed.
