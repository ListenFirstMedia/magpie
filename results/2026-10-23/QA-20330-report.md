# QA-20330 — Brand Content > YouTube Only: Insights & YouTube Only: Premium Data Set > Past date range data test

- **Run date:** 2026-10-23 (Friday), unattended headless
- **Verdict:** **FAILED (blocked by open bug)** — APPS-60871

## Screening (Rule 7 — open-bug auto-fail)
- The case file's "Open linked bugs" section lists **APPS-60871 (Bug, Open)**.
- The fresh snapshot `results/open-bugs-2026-10-23.json` (2026-10-23) still shows it open:
  `APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across…`
- Per `skills/_shared/spec-adherence-rules.md` Rule 7 and the 2026-10-22 open-bug directive, any open linked bug means the case is FAILED and attributed to the bug. No interference judgement is made. The browser flow was not opened.

## Steps executed
None. Steps 1–8 were not executed (auto-fail before execution).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic + Paid Watch Time (Min) = YouTube Watch Time (Min) | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| A5 | 5 | Organic + Paid + Unclassified Views = Video Views | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| A7 | 7 | Organic Premium Views + Paid Premium Views = Premium Views | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| A8 | 8 | Organic Premium Watch Time + Paid Premium Watch Time = Premium Watch Time | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |

## Evidence
No screenshots (browser not opened). Source of the open-bug status: `cases/QA-20330.md` ("Open linked bugs") and `results/open-bugs-2026-10-23.json`.

## Known bugs checked
- **APPS-60871** (Open) — "Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across…". The case sums per-post metric columns, which this bug can leave as "–". It is the same bug blocking QA-19707 and QA-24281. Not verified in-app this run (auto-fail policy).
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-20330 entries (pre-fetched shell-side).
- Skill lookup: no skill was pre-resolved; the closest pattern is `brand-content-grid-math` (referenced in the case Notes), for the future re-run.

## Bugs filed
None. No new bugs found, and nothing is filed to Jira.

## Re-run note
Re-run once APPS-60871 is closed and `cases/QA-20330.md` is refreshed. Use the Friday row (Hulu / Hulu), Jan 01 – Dec 31 2024, Table View DOM scrape.
