# QA-24894 — Reporting - Data QA - Social Recap Date -Date

**Verdict: FAILED (blocked by open bug)** — LFMP-32081

- **Run date:** 2026-10-23 (unattended, headless `claude -p`)
- **Case file:** cases/QA-24894.md (Test Set QA-27628 "Daily Data Testing -1")
- **Browser flow:** NOT opened. No steps executed, no screenshots taken (`.playwright-out/QA-24894/` is empty by design).

## Why the case was not run

Per `skills/_shared/spec-adherence-rules.md` Rule 7 (open-bug auto-fail), the case's "Open linked bugs" section lists an OPEN bug. That section was baked in from Jira at ingest time (2026-10-19).

I confirmed the status is still current in `results/open-bugs-2026-10-23.json` (today's snapshot):

| Bug | Status | Summary |
|---|---|---|
| LFMP-32081 | Open | Reporting > Social Recap - Negative Engagements |

The bug is on the same surface the case tests: Social Recap, Engagements. Steps 10-11 and assertion 11 (Engagements table sum vs. donut data-tooltip total) are the part most likely affected. A case with an open linked defect cannot produce a trustworthy PASS. The case file's note to "check whether it interferes with the assertions" is superseded by Rule 7 and the 2026-10-22 open-bug directive: no interference judgement.

## Steps executed

None. Steps 1-13 were not attempted.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A7 | 7 | Table Impressions sum = donut data-tooltip total | Not executed (blocked by open bug LFMP-32081) | FAILED (blocked) |
| A9 | 9 | Table Video Views sum = donut data-tooltip total | Not executed (blocked by open bug LFMP-32081) | FAILED (blocked) |
| A11 | 11 | Table Engagements sum = donut data-tooltip total | Not executed (blocked by open bug LFMP-32081); Engagements is the surface the bug names | FAILED (blocked) |
| A13 | 13 | Table New Followers sum = donut data-tooltip total | Not executed (blocked by open bug LFMP-32081) | FAILED (blocked) |

## Evidence

- cases/QA-24894.md, "Open linked bugs (as of 2026-10-19)": LFMP-32081 (Bug, Open)
- results/open-bugs-2026-10-23.json, entry `QA-24894`: `LFMP-32081 [Open] Reporting > Social Recap - Negative Engagements`

## Known bugs checked

- **LFMP-32081 (Open):** attributes this FAIL. No browser verification was done, so whether it reproduces on Sephora | Ralph Lauren, and whether it affects the Impressions, Video Views and New Followers sections, is untested.
- `knowledge-base/bug-history.md`: no entries for QA-24894 (pre-fetched).
- `knowledge-base/known-quirks.md`: no entries for QA-24894 (pre-fetched).
- Skill lookup: none pre-resolved. Not needed, since the case was not run.

## Bugs filed

None. No new bugs. The existing bug LFMP-32081 is already tracked in Jira.

## Re-run guidance

Re-run automatically picks this case up once LFMP-32081 is closed and the cases/QA-24894.md open-bug section is refreshed. When it is re-run, note the following:

- Precondition: Sephora | Ralph Lauren brand, Authorized perspective.
- Facebook Impressions are Paid-only since the Dec 15, 2025 release.
- Exclude TikTok Paid Video Views from the Video Views sum (step 8).
- Exclude negative New Followers values from the sum (step 12).
- A closed bug may regress. Watch the negative Engagements handling in the Engagements sum.
