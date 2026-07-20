# QA-3630 — Reporting > Content Performance Report - BPC filmstrip - Authorized

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-3630 · Priority: Blocker
- **Result:** **FAILED** — blocked by an OPEN linked bug. Not executed.
- **Precondition/brand:** Michael Kors, Authorized

## Why FAILED (not executed)
Per [[open-bug-auto-fail]] ("if a test case has any open bug, mark it failed until it gets closed"), marked **FAILED without execution** due to an open defect on the feature under test:

- **LFMP-32010** — "Reporting > Content performance > Least Engaging Posts & Heading Does not show in 'Preview & Share Report'" · **status: Open** · Major · Bug.

The case explicitly exercises **Least Engaging Content** (step 8: "Check Least Engaging Content and input 5 in Visual Bottom posts") and reviews the report — exactly what LFMP-32010 reports as broken in Preview & Share. Cannot pass while open.

## Linked bug scan
- OPEN: **LFMP-32010** (Bug, Major, Open) — Least Engaging Posts & Heading missing in Preview & Share. ← blocker
- All other linked defects are Closed.

## Next step
Re-run QA-3630 once **LFMP-32010** is resolved/Closed.

## Bugs filed
None (LFMP-32010 already exists and is open).
