# QA-20526 — Brand Content > Data Test > Paid Posts

**Date:** 2026-10-23 (Friday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-62446**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs" section (and the shell-side `results/open-bugs-2026-10-23.json` screen) lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-62446 | Open | Brand Content > Paid Posts > En dash displayed for the Paid Saves metric |

**Interference judgment: INTERFERES.**
- The bug is an en-dash shown in the Paid Saves column on the Paid Posts table, which is exactly what assertion 11 checks (Instagram Only: Insights dataset, "Paid Saves" must not display the en-dash and must contain values).
- The case's purpose is to confirm that Paid columns show values rather than en-dashes under the "Paid: Boosted" filter. The bug is the same symptom on the same column, so A11 is expected to fail on this defect.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` requires auto-fail for any open linked bug, and a PASS would be untrustworthy.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A6 | 6 | Paid Engagements / Reactions / Comments / Shares show values, no en-dash | Not executed — blocked by open bug APPS-62446 | BLOCKED |
| A7 | 7 | Paid Impressions and Promoted Reach show values, no en-dash | Not executed — blocked by open bug APPS-62446 | BLOCKED |
| A8 | 8 | Paid Views shows values, no en-dash | Not executed — blocked by open bug APPS-62446 | BLOCKED |
| A9 | 9 | Paid Completed Views shows values, no en-dash | Not executed — blocked by open bug APPS-62446 | BLOCKED |
| A10 | 10 | Paid Follows shows values, no en-dash | Not executed — blocked by open bug APPS-62446 | BLOCKED |
| A11 | 11 | Paid Saves shows values, no en-dash | Not executed — directly matches open bug APPS-62446 (en-dash on Paid Saves) | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-20526/`. The decision rests on `cases/QA-20526.md` ("Open linked bugs (as of 2026-10-19)") and `results/open-bugs-2026-10-23.json`, which confirms APPS-62446 is still Open as of 2026-10-23.

## Known bugs checked

- **APPS-62446 (Open):** interferes with A11, so the case is failed as blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md`: no entries for QA-20526 (pre-fetched).
- The REGISTRY lookup was skipped because the Rule 7 screen ended the run before any skill was needed.

## Bugs filed

None. Markdown-only; no Jira tickets created. APPS-62446 is already filed.

## Re-run

The case is picked up automatically once APPS-62446 closes and the case cache is refreshed.
