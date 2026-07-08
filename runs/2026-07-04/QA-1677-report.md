# QA-1677 — Brand Content - Tag Post

- **Run date:** 2026-07-04
- **Verdict:** **FAILED (blocked by open bug)**
- **Blocking bug:** **LFMP-32155 (Open)**
- **Executed:** No steps run. Case screened out before browser launch per spec-adherence Rule 7 (open-bug auto-fail).

## Reason

The case file's `## Open linked bugs` section (baked in from Jira as of 2026-07-03) lists:

> **OPEN: LFMP-32155(Open)** — per open-bug auto-fail rule, mark this case FAILED (blocked) WITHOUT running, until these close.

Per Rule 7, a test case with any open linked defect cannot produce a trustworthy PASS. Running it would waste the per-case budget and risk a misleading result. The case was therefore NOT executed — no login, no browser flow, no mutation (the case is `mutating: YES`, so skipping also avoids adding a stray tag to a real MTV post).

## Steps executed

None. Screening halted execution before pre-flight/login.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4a | Tag button visible in postcard | Not evaluated | BLOCKED |
| A2 | 4b | Tag popup opens on click | Not evaluated | BLOCKED |
| A3 | 5 | Tag count updates in posts | Not evaluated | BLOCKED |
| A4 | 6 | Correct tags present after refresh | Not evaluated | BLOCKED |
| A5 | 7 | 'None' is first option in Tag filter child dropdown | Not evaluated | BLOCKED |
| A6 | 8 | Posts WITHOUT tags display | Not evaluated | BLOCKED |
| A7 | 9 | Posts WITH tags display | Not evaluated | BLOCKED |
| A8 | 10 | Tagged posts display in Table View | Not evaluated | BLOCKED |
| A9 | 11 | Tagged posts display in Detail View | Not evaluated | BLOCKED |

## Evidence

- Source: `testcases/english/QA-1677.md`, `## Open linked bugs` section (line 40-41): `**OPEN: LFMP-32155(Open)**`.
- Rule: `skills/_shared/spec-adherence-rules.md` Rule 7 (Open-bug auto-fail).

## Cleanup

Not applicable — no tag was added (case not run).

## Bugs filed

None. LFMP-32155 is a pre-existing open bug linked to this case; it is the reason for the block, not a new finding. Re-runs will pick this case up automatically once LFMP-32155 closes and the case cache is refreshed.
