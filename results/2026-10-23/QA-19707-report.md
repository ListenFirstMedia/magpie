# QA-19707 — Brand Content - YouTube Only: Insights & Premium Dataset - Current Date Range Data Test

**Run date:** 2026-10-23 (Friday) — unattended, headless
**Verdict: FAILED (blocked by open bug)**

## Why the case was not executed
Per `skills/_shared/spec-adherence-rules.md` Rule 7 (open-bug auto-fail), a case with any open linked bug is not run. The case file's "Open linked bugs" section and the refreshed snapshot `results/open-bugs-2026-10-23.json` both list:

| Bug | Status | Summary |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across ... |

The bug affects the metric columns this case sums (Organic/Paid Watch Time, Organic/Paid Premium Views, Premium Watch Time). A case with an open linked defect cannot produce a trustworthy PASS. This verdict is attributed to APPS-60871, not to a new defect.

## Steps executed
None. The browser was not opened.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic Watch Time + Paid Watch Time = YouTube Watch Time (per post) | Not evaluated (blocked by open bug) | FAILED (blocked by open bug) |
| A6 | 6 | Organic Premium Views + Paid Premium Views = Premium Views (per post) | Not evaluated (blocked by open bug) | FAILED (blocked by open bug) |
| A7 | 7 | Organic Premium Watch Time + Paid Premium Watch Time = Premium Watch Time (per post) | Not evaluated (blocked by open bug) | FAILED (blocked by open bug) |

## Evidence
- `cases/QA-19707.md` — "Open linked bugs (as of 2026-10-19)": APPS-60871 (Bug, Open)
- `results/open-bugs-2026-10-23.json` — QA-19707 → `APPS-60871 [Open]` (refreshed 2026-10-23)
- No screenshots (no browser session).

## Known bugs checked
- APPS-60871 (Open): confirmed still open on 2026-10-23, so the case is auto-failed.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-19707 (pre-fetched grep).
- Re-runs will pick the case up once APPS-60871 closes and the cache is refreshed. Today's weekday row would be Friday (Hulu, Ralph Lauren / Hulu, Ralph Lauren).

## Bugs filed
None. No new defects were observed, and Jira tickets are never auto-created.
