# QA-138031 — Data Collection - Channel Collection Status Validation 1

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-138031
- **Verdict:** **FAILED (blocked by open bug)**

## Why blocked — open-bug auto-fail (spec-adherence Rule 7)

The cached case file's **"## Open linked bugs (as of 2026-07-03)"** section lists:

- **APPS-61562 (QA Ready)** — OPEN

Per Rule 7 (open-bug auto-fail) and the standing feedback rule "if a test case has ANY open
linked bug, mark it FAILED (blocked) without running, until the bug is closed":

> A case with an open linked defect can't produce a trustworthy PASS. The case was NOT executed.
> No browser flow was opened; no pre-flight login was performed. The case re-runs automatically
> once APPS-61562 is closed and the cache is refreshed.

## Steps executed

None. Execution was skipped at the pre-run open-bug screen (before pre-flight/login).

## Assertions

| ID  | Step | Expected | Actual | Status |
|-----|------|----------|--------|--------|
| A3  | 3    | Selected channel filter applied; only that channel's data feeds shown | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A4  | 4    | 'Data Collection Summary' page opens | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A5a | 5    | 'Collecting' status shows green check icon | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A5b | 5    | 'Last Collection Date' = current date or day before when Collecting | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A5c | 5    | Collecting data visible on Brand Content page matching native source w/ latest date | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A5d | 5    | 'Not Collecting' status shows red exclamation icon | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |
| A5e | 5    | 'To Do' status shows blue plus icon | Not evaluated — blocked by open bug APPS-61562 | NOT RUN |

## Evidence

- Cache file `testcases/english/QA-138031.md`, "Open linked bugs" section (as of 2026-07-03):
  `**OPEN: APPS-61562(QA Ready)**`.
- No screenshots — browser was never launched (correct behavior under Rule 7).

## Bugs filed

None. APPS-61562 is a pre-existing open defect linked to this case; it is not re-filed here.
This report does not create or modify any Jira tickets (markdown only).
