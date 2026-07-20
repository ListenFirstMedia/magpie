# QA-1677 — Brand Content - Tag Post

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1677 · Priority: Critical
- **Result:** **FAILED** — blocked by an OPEN linked bug. Not executed.
- **Precondition:** Adam Orfei account · **Brand:** Hulu
- **Skills:** (not exercised) brand-content-tag-post

## Why FAILED (not executed)
Per the standing rule "if a test case has any open bug, mark it as failed until it gets closed" ([[open-bug-auto-fail]]), this case is marked **FAILED without execution** because it has an OPEN linked defect that directly governs its assertions:

- **LFMP-32155** — "Brand > Content - Tag Select All filter is not working properly" · **status: Open (To Do)** · Major.

Step 9 / assertion 9 of this case ("Click 'Select All' to select all tags including the newly added one" → "Ensure all tags including the tag added in step 5 are selected") is exactly the behavior LFMP-32155 reports as broken. With that bug open, the case cannot pass.

## Linked bug scan
- OPEN: **LFMP-32155** (Bug, Major, Open) — Tag Select All filter not working. ← blocker
- All other linked issues (APPS-9882, LFMP-19413, APPS-11683, APPS-11787, APPS-23750, LFMP-27949, APPS-43825, APPS-44329, automation tasks, etc.) are **Closed**.

## Next step
Re-run QA-1677 once **LFMP-32155** is resolved/Closed. The case also mutates data (creates a unique tag on a Hulu post) — when re-run, that is the intended test action.

## Bugs filed
None (LFMP-32155 already exists and is open).
