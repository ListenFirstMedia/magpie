# QA-131491 — Social Recap Vs Brand > Content - IG Public Video View

- **Run date:** 2026-07-04
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open linked bug **DATA-12223 (QA Ready)** on this case. Per spec-adherence Rule 7 (open-bug auto-fail), a case with any open linked defect cannot produce a trustworthy PASS, so it is marked FAILED (blocked) **without executing any steps**.

## Pre-flight

Not performed. Rule 7 screening happens **before** any browser flow; the open bug short-circuits the run, so no login/pre-flight was attempted.

## Open-bug screen

Read the case file's `## Open linked bugs` section:

> **OPEN: DATA-12223(QA Ready)** — per open-bug auto-fail rule, mark this case FAILED (blocked) WITHOUT running, until these close.

- DATA-12223 is a Bug in status **QA Ready** (an open state) → screen **failed** → do not run.

## Steps executed

None. Browser flow intentionally not opened (Rule 7).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Report loads without error | Not evaluated — case blocked by open bug DATA-12223 | BLOCKED |
| A2 | 5 | IG Video View metric unlocked and visible at Brand level when data available | Not evaluated — case blocked by open bug DATA-12223 | BLOCKED |
| A3 | 5 | Video View metric displayed within Instagram card in 'Best Performing Content' | Not evaluated — case blocked by open bug DATA-12223 | BLOCKED |
| A4 | 9 | IG Video View value in Social Recap BPC card matches Brand → Content | Not evaluated — case blocked by open bug DATA-12223 | BLOCKED |

## Evidence

- Source case: `testcases/english/QA-131491.md` — `## Open linked bugs (as of 2026-07-03)` lists `OPEN: DATA-12223(QA Ready)`.
- No screenshots/snapshots captured (`.playwright-out/QA-131491/` empty) — no browser session was started.

## Bugs filed

None. DATA-12223 already exists and is open; this run does not file new tickets and does not create/modify Jira issues.

## Next steps

Re-run picks this case up automatically once DATA-12223 is closed and the cached case file's `## Open linked bugs` section is refreshed.
