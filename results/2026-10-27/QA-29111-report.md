# QA-29111 — Brand Content > Basic Data Set > Past date range data test (Twitter and Instagram)

- **Run date:** 2026-10-27 (Tuesday)
- **Mode:** unattended / headless (`claude -p`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-29111 (Test Set QA-26183 "Daily Data Testing -2")

## Verdict: FAILED (blocked by open bug)

Attributed to **APPS-61116** (Open): *Brand > Content - Twitter channel - Sum of Reactions + Comments + Shares does not equal Engagements value*.

Per spec-adherence Rule 7 (open-bug auto-fail), the case file's "Open linked bugs" section lists an OPEN defect, so the case was **not executed**. The browser was never opened and no login was attempted. A run could not produce a trustworthy PASS. The listed bug targets the exact assertion this case checks (Twitter, Reactions + Comments + Shares = Engagements, assertion 5).

## Steps executed

None. Execution skipped by the open-bug screen.

| # | Step | Status |
| --- | --- | --- |
| 1 | Hover over Brand and select Content from the Top Nav | NOT RUN |
| 2 | Add a Brand | NOT RUN |
| 3 | Select date range 2024-04-19 to 2024-04-25 | NOT RUN |
| 4 | Enable Twitter Channel Only | NOT RUN |
| 5 | In each grid post add Reactions, Comments, Shares | NOT RUN |
| 6 | Enable Instagram Channel Only | NOT RUN |
| 7 | In each grid post add Reactions, Comments, Shares | NOT RUN |

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A5 | 5 | Reactions + Comments + Shares = Engagements (Twitter) | Not evaluated; blocked by open bug APPS-61116, which describes this exact mismatch | FAILED (blocked by open bug) |
| A7 | 7 | Reactions + Comments + Shares = Engagements (Instagram) | Not evaluated; case halted before reaching this step | FAILED (blocked by open bug) |

## Evidence

- Source of the screen: `cases/QA-29111.md`, section "Open linked bugs (as of 2026-10-20)" → `APPS-61116 (Open)`.
- Weekday rotation for this run: Tuesday → UCLA / University of California, Los Angeles (per case Notes: Tue UCLA / Sony Pictures). Not exercised.
- No screenshots (`.playwright-out/QA-29111/` unused).

## Known bugs checked

- **APPS-61116 (Open)** — Brand > Content, Twitter channel: sum of Reactions + Comments + Shares ≠ Engagements. Drives the verdict. The case file notes it as the known ±1 Twitter family, and `knowledge-base/known-quirks.md` has a "total value with no organic/paid split" pattern (QA-20321, QA-20324, QA-24277) in the same family. None of this was re-verified in the app this run.
- `knowledge-base/bug-history.md`: no entries for QA-29111.
- Skill lookup: no matching skill was pre-resolved. Skipped because the case did not run. The case's own Notes point to the `brand-content-grid-math` skill for the eventual re-run.

## Bugs filed

None. This report is markdown-only and no Jira tickets were created. The failure is attributed to the existing APPS-61116.

## Re-run

Re-run once APPS-61116 is closed and `cases/QA-29111.md` is refreshed from Jira. Re-check for regression on the Twitter step at that point, since a fixed bug can regress.
