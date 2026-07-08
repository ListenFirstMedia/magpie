# QA-2706 — Brand > Content - Benchmark - Authorized

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2706 · Priority: Blocker
- **Result:** **FAILED** — blocked by an OPEN linked bug. Not executed.
- **Precondition:** Amazon Prime Video account · **Brand:** Amazon Prime Video

## Why FAILED (not executed)
Per the standing rule "if a test case has any open bug, mark it as failed until it gets closed" ([[open-bug-auto-fail]]), this case is marked **FAILED without execution** due to an OPEN linked defect on the exact feature it tests:

- **LFMP-31886** — "Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in 'Video views' column" · **status: Open (To Do)** · Minor · Bug.

QA-2706 verifies the Benchmark aggregate/Owned Average rows (steps 3–6: apply "Set to Current Brand" benchmark, Rolling 7 Days, Go → check Benchmark Row / Average-row percentage indicators / per-post benchmark values). LFMP-31886 is an open display defect in that Benchmark Owned Average row, so the case cannot cleanly pass.

## Linked bug scan
- OPEN: **LFMP-31886** (Bug, Minor, To Do) — Benchmark Owned Average "Video views" missing parentheses. ← blocker
- (APPS-60964 "Playwright automation of… QA-2706" is Open but is a QA Task, not a defect.)
- All other linked defects (APPS-11612, APPS-11675, APPS-14518, APPS-21439, APPS-28186, APPS-28437, APPS-41894, etc.) are **Closed**.

## Next step
Re-run QA-2706 once **LFMP-31886** is resolved/Closed.

## Bugs filed
None (LFMP-31886 already exists and is open).
