# QA-135321 — Brand > Content - Verify Additional filter working with tag filter

- **Run date:** 2026-07-04
- **Verdict:** **FAILED (blocked by open bug)**
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-135321
- **Priority:** Critical (P2)

## Result

Not executed. The case's **"## Open linked bugs"** section lists an OPEN defect:

- **LFMP-32155 (Open)**

Per spec-adherence **Rule 7 (Open-bug auto-fail)**, a case with any open linked bug cannot
produce a trustworthy PASS. The case is marked **FAILED (blocked)** WITHOUT running any steps;
the browser flow was not opened. Pre-flight login was skipped since no case steps run.

Re-runs will pick this case up automatically once LFMP-32155 is closed and the cached case file
is refreshed with the updated bug status.

## Steps executed

None — screened out by the open-bug gate before execution.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Include Tag added with green filter pill for TAG_1 | Not evaluated | BLOCKED (open bug LFMP-32155) |
| A2 | 6 | TAG_2 visible as red filter pill (Exclude) in active filters bar | Not evaluated | BLOCKED (open bug LFMP-32155) |
| A3 | 7 | Filter impacts page data | Not evaluated | BLOCKED (open bug LFMP-32155) |
| A4 | 10 | Both tag and Paid filters implemented | Not evaluated | BLOCKED (open bug LFMP-32155) |

## Evidence

- Case file `testcases/english/QA-135321.md` → "Open linked bugs (as of 2026-07-03)": `OPEN: LFMP-32155(Open)`.
- No screenshots (browser not launched).

## Bugs filed

None. LFMP-32155 is a pre-existing open bug on this case (not filed by this run).
