# QA-29111 — Brand Content > Basic Data Set > Past date range data test (Twitter and Instagram)

**Run date:** 2026-10-28 (Wednesday) | **Mode:** unattended headless (`claude -p`)
**Test Set:** QA-26183 "Daily Data Testing -2"

## Verdict: FAILED (blocked by open bug)

Rule 7 (open-bug auto-fail) was applied. The case file's "Open linked bugs" section lists an open defect, so the case was **not executed**: no browser was opened, no login, and no steps were run. The failure is attributed to the bug below.

| Bug | Status | Summary |
| --- | --- | --- |
| APPS-61116 | Open | Brand > Content - Twitter channel - Sum of Reactions + Comments + Shares does not equal Engagements value |

## Why this case can't produce a trustworthy PASS

APPS-61116 describes the exact defect assertion 5 checks (Twitter: Reactions + Comments + Shares = Engagements). While the bug is open, the Twitter half of the case is expected to fail. The known-quirks KB also records the same family of "total value with no organic/paid split" mismatches on Twitter posts (QA-20324, QA-24277). Assertion 7 (Instagram) is untested, because the case is gated as a whole.

## Steps executed

None. Skipped under Rule 7:

1. Hover Brand > Content (Top Nav)
2. Add a Brand
3. Date range 2024-04-19 to 2024-04-25
4. Enable Twitter Channel Only
5. Sum Reactions + Comments + Shares per grid post
6. Enable Instagram Channel Only
7. Sum Reactions + Comments + Shares per grid post

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A5 | 5 | Reactions + Comments + Shares = Engagements (Twitter) | Not executed, blocked by open bug APPS-61116 | FAILED (blocked by open bug) |
| A7 | 7 | Reactions + Comments + Shares = Engagements (Instagram) | Not executed, case gated by open bug APPS-61116 | FAILED (blocked by open bug) |

## Evidence

No screenshots or DOM captures were taken, since the browser flow was not started. The open-bug listing comes from the case file `cases/QA-29111.md` (baked in from Jira on 2026-10-20).

## Known bugs checked

- **Case-file "Open linked bugs" (as of 2026-10-20):** APPS-61116 (Open). This is the determining factor.
- **knowledge-base/bug-history.md:** no entries for QA-29111.
- **knowledge-base/known-quirks.md:** the pre-fetched match references QA-29111 as a ±1 Twitter engagement discrepancy under the APPS-61116 family.
- **Jira refresh:** not possible in this headless run (no Atlassian MCP). The bug's status is as cached on 2026-10-20 and may have changed since.

## Bugs filed

None. Nothing new was observed, and no Jira tickets are auto-created.

## Re-run guidance

Refresh the case cache from Jira once APPS-61116 is closed, then re-run. If it is closed, the case becomes runnable again, and a failure at A5 would then be a regression of APPS-61116.

Weekday-rotation note for the re-run: today is a Wednesday, so the account/brand row is Apple Services / Wasserman per the case's Notes. The Description table lists Apple Services / NBCU Enterprises with brands Apple Music, CNBC, NBC News. The Notes row and the Description table disagree, so verify the intended brand before the next run.
