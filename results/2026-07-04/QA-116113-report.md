# QA-116113 — Youtube Audience Tile level export PNG

- **Run date:** 2026-07-04
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-116113
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open-bug auto-fail (spec-adherence Rule 7). The case's "Open linked bugs" section
  lists an OPEN defect, so the case is not executed — a case with an open linked defect cannot
  produce a trustworthy PASS.

## Blocking bug
- **DATA-12043 (Code Review)** — open, linked to QA-116113 (as of 2026-07-03 cache).

## Execution
- **Not run.** No browser flow was opened for this case. Pre-flight/login skipped — Rule 7 screens
  the case out before execution.

## Steps executed
None. (Case blocked before step 1.)

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4–6 | File Name: `Brand Name - Tab Name - Chart Name - YYYY-MM-DD(Start)-YYYY-MM-DD(End).png` | Not evaluated | BLOCKED |
| A2 | 4–6 | ListenFirst name with logo displays on the chart | Not evaluated | BLOCKED |
| A3 | 4–6 | Chart Title "Brand Name - Chart Name" shows below the logo | Not evaluated | BLOCKED |
| A4 | 4–6 | PNG export chart matches the related tile on web page | Not evaluated | BLOCKED |
| A5 | 4–6 | Tab name "Brand Audience" displays below the chart | Not evaluated | BLOCKED |
| A6 | 4–6 | Displaying date (explorer) displays below Brand Audience | Not evaluated | BLOCKED |

## Evidence
- No screenshots/snapshots captured — case blocked prior to any browser interaction.

## Bugs filed
None. (DATA-12043 already exists and is the blocker; no new bug warranted.)

## Next step
Re-runs pick this case up automatically once DATA-12043 closes and the test-case cache is refreshed.
