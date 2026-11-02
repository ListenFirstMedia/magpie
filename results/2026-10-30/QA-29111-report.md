# QA-29111 — Brand Content > Basic Data Set > Past date range data test - (Twitter and Instagram)

**Date:** 2026-10-30 (Friday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-61116**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-61116 | Open | Brand > Content - Twitter channel - Sum of Reactions + Comments + Shares does not equal Engagements value |

**Interference judgment: INTERFERES (directly).**
- The bug describes the exact assertion this case makes (A5: Reactions + Comments + Shares = Engagements on the Twitter channel).
- `knowledge-base/known-quirks.md` already ties this case to the bug: "Same family as APPS-61116 (QA-29111 ±1 Twitter)". The earlier run saw the Twitter sum off by ±1.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` requires auto-fail for any open linked bug, with no browser flow.

Caveat: the bug status comes from the case cache dated 2026-10-20. The Atlassian MCP is absent in this headless run, so I could not check whether APPS-61116 has since closed. The verdict follows the cached state.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Twitter only: Reactions + Comments + Shares = Engagements in each grid post | Not executed — blocked by open bug APPS-61116 | BLOCKED |
| A7 | 7 | Instagram only: Reactions + Comments + Shares = Engagements in each grid post | Not executed — blocked by open bug APPS-61116 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-29111/`. The decision rests on the case file `cases/QA-29111.md` ("Open linked bugs") and the pre-fetched `known-quirks.md` entry.

## Known bugs checked

- **APPS-61116 (Open):** interferes, so the case is blocked. It was not reproduced in this run, because the browser flow was skipped under the Rule 7 screen. An earlier run (see known-quirks) saw a Twitter ±1 mismatch attributed to this family.
- `knowledge-base/bug-history.md` has no QA-29111 entries (pre-fetched shell-side).
- Skill lookup: none pre-resolved. The likely fit for a re-run is `brand-content-grid-math` (Table View scrape), per the case Notes.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-61116 is closed and the case-file cache is refreshed.
- Weekday rotation: today is Friday, so use Hulu (account and brand). The Description table's Friday row lists only "Hulu" as brand.
- Per case Notes, if the values don't match, switch to the Engagement Breakdown data set.
