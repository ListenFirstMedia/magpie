# QA-281 — TWC report for Relative dates with long intervals

- **Run date:** 2026-07-03 (HEADLESS Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-281 · Priority: Trivial
- **Result:** **FAILED (blocked by open bug)** — not executed. Per [[open-bug-auto-fail]], a case with any OPEN linked bug is marked failed until the bug closes.

## Linked bug scan — OPEN BUG
- **LFMP-31961** — Bug · status **Open** (statusCategory ≠ done). Auto-fail trigger.

## Decision
Not run while LFMP-31961 is open. Re-execute once it's Closed. (Steps: TWC → Relative dates, 15→1 weeks, 3 brands [Disney Channel, Disney Junior, Wells Fargo], key date Feb 01 2025, New Followers, Show Change/Share/Metrics Tables, generate, export CSV; assertion 12 = export matches report.)

## Bugs filed
None (pre-existing open bug LFMP-31961 is the blocker).
