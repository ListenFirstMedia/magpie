# QA-23969 — Reporting > Social Recap - Download

- **Run date:** 2026-07-04
- **Branch:** feature/playwright-mcp (headless, unattended)
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open linked bug present — screened out per Rule 7 (open-bug auto-fail). Case NOT executed.

## Screening result

The case file's **"## Open linked bugs"** section (as of 2026-07-03) lists:

> **OPEN: LFMP-31925(Open)**

Per `skills/_shared/spec-adherence-rules.md` **Rule 7 (Open-bug auto-fail)**: a case with any
OPEN linked defect cannot produce a trustworthy PASS. The case is marked **FAILED (blocked)**
without running, and the browser flow is not opened. Pre-flight login was intentionally skipped —
no steps were executed, no artifacts generated.

## Steps executed

None. Case blocked at the pre-run screen.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | PDF should be downloaded | Not run (blocked) | BLOCKED |
| A2 | 8a | Each page shows `Page N(N - Page count)` at page end | Not run (blocked) | BLOCKED |
| A3 | 8b | Filename `BrandName - Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` | Not run (blocked) | BLOCKED |
| A4 | 8c | Preview mode page matches PDF file | Not run (blocked) | BLOCKED |
| A5 | 16a | Filename `Primary BrandName - Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` | Not run (blocked) | BLOCKED |
| A6 | 16b | Preview mode page matches PDF file | Not run (blocked) | BLOCKED |

## Evidence

- Source: `testcases/english/QA-23969.md` → "## Open linked bugs (as of 2026-07-03)" → `LFMP-31925(Open)`.
- No screenshots/snapshots (case not executed).

## Bugs filed

None. Existing open bug **LFMP-31925** is the blocker; no new bug warranted.

## Follow-up

Re-runs pick this case up automatically once **LFMP-31925** is closed and the case-file bug
cache is refreshed.
