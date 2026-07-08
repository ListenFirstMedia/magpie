# QA-929 — Pinterest Content - Embedded Post Tooltip

- **Run date:** 2026-07-04
- **Branch:** feature/playwright-mcp (headless, unattended)
- **Verdict:** **FAILED (blocked by open bug)**
- **Blocking bug:** **LFMP-31979 (Open)**

## Summary

This case was **not executed**. Per the spec-adherence **Rule 7 (open-bug auto-fail)**, a
test case whose cached `## Open linked bugs` section lists any OPEN linked defect is marked
`FAILED (blocked by open bug)` **without running** — it cannot produce a trustworthy PASS while
a linked defect is open, and running it would waste the per-case budget on a misleading result.

The `testcases/english/QA-929.md` open-bugs section (baked in from Jira at cache time,
as of 2026-07-03) reads:

> **OPEN: LFMP-31979(Open)** — per open-bug auto-fail rule, mark this case FAILED (blocked)
> WITHOUT running, until these close.

No pre-flight/login or browser flow was started for this case (screening happens before any
browser interaction).

## Steps executed

None — screened out at the open-bug gate before execution.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Post tooltip displays on hover | Not evaluated | BLOCKED |
| A2 | 6b | Only one tooltip visible at a time | Not evaluated | BLOCKED |
| A3 | 6c | Tooltip closes on X click OR clicking elsewhere | Not evaluated | BLOCKED |
| A4 | 6d | Hovering other Type links doesn't open additional tooltips | Not evaluated | BLOCKED |
| A5 | 6e | Clicking post type opens correct channel post in new tab matching tooltip | Not evaluated | BLOCKED |
| A6 | 6f | Post image + Post text match the tooltip content | Not evaluated | BLOCKED |

## Evidence

- Source: `testcases/english/QA-929.md` → `## Open linked bugs (as of 2026-07-03)` → `LFMP-31979(Open)`.
- Rule: `skills/_shared/spec-adherence-rules.md` → Rule 7 (open-bug auto-fail).
- No screenshots/snapshots captured (browser not opened).

## Note on prior test-data drift (context, not this run's verdict)

`knowledge-base/known-quirks.md` (2026-06-29 entry) records that QA-929's fixed historical date
range (Jun 21–22, 2023) has aged out of the rolling ~3-year data-retention floor (~Jun 28, 2023),
which independently would BLOCK the case on test-data. This run's verdict, however, is driven by
the open-bug gate (Rule 7), which takes precedence and short-circuits execution.

## Bugs filed

None. (This case is blocked by the pre-existing open bug **LFMP-31979**; no new bug is filed.
No Jira tickets are created — markdown report only.)

## Re-run condition

Re-runs will pick this case up automatically once **LFMP-31979** closes and the case cache is
refreshed. At that point the aged-out date range should also be verified against the current
retention floor before trusting a PASS.
