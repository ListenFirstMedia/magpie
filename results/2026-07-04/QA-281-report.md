# QA-281 — TWC report for Relative dates with long intervals

- **Run date:** 2026-07-04
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-281
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open linked bug **LFMP-31961 (Open)** — per Rule 7 (open-bug auto-fail), the case was NOT executed.

## Screening result (Rule 7 — open-bug auto-fail)

The case file's **"## Open linked bugs"** section (baked in from Jira at cache time, as of 2026-07-03) lists:

> **OPEN: LFMP-31961(Open)**

Per `skills/_shared/spec-adherence-rules.md` Rule 7, a case with any open linked defect cannot produce a trustworthy PASS. The case was therefore **not run** — no browser flow, no pre-flight login was performed for execution of steps. This mirrors the interactive open-bug-auto-fail discipline and conserves the per-case budget.

## Steps executed

None. Screening halted execution before any UI interaction (Rule 7).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | step 12 | Exports match TWC report | Not evaluated — blocked by open bug LFMP-31961 | BLOCKED |

## Evidence

- Case file: `testcases/english/QA-281.md`, section "## Open linked bugs (as of 2026-07-03)": `**OPEN: LFMP-31961(Open)**`.
- No screenshots captured (no browser flow executed).

## Bugs filed

None. (LFMP-31961 already exists and is open; this report does not create Jira tickets.)

## Next action

Re-run picks this case up automatically once **LFMP-31961** is closed and the case cache is refreshed to reflect "None open".
