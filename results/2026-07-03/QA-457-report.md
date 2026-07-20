# QA-457 — TWC Rate Data QA

- **Run date:** 2026-07-03 (HEADLESS Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-457 · Priority: Critical
- **Result:** **BLOCKED / OOS** — the sole assertion is a **dev↔stage data-parity** check, and no **stage** environment is configured or reachable in this harness (dev-only: `app.lfmdev.in`; env.md notes `*.lfmdev.in` is internal-network only).

## Linked bug scan
No open linked bugs — [[open-bug-auto-fail]] N/A.

## Why not run
Steps require running the report on **dev** and repeating on **stage** in a new tab (step 9), then the assertion is "Ensure dev and stage data match." This harness has creds/config for **dev only** — no stage URL or auth is available. Running the dev side alone provides nothing to compare against, so the assertion is not verifiable here.

Account: Disney Ad Sales · Config: TWC Absolute, Months / last one year, Disney Channel (Public), all rate datapoints + avg responses per post, graphs off, Show Share + Show Change.

## Assertions
| ID | Expected | Status |
|----|----------|--------|
| — | Dev and stage data match | ⏭ OOS — no stage environment in this dev-only harness |

## Bugs filed
None. Requires a stage environment to execute; out of scope for the dev automation harness.
