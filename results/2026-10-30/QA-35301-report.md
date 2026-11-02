# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Verdict: FAILED (blocked by open bug)** — APPS-60871

- **Date:** 2026-10-30
- **Mode:** unattended headless (`claude -p`)
- **Source:** cases/QA-35301.md (Test Set QA-26183 "Daily Data Testing -2")

## Open-bug screen (spec-adherence Rule 7)

The case file's "Open linked bugs" section (cached 2026-10-20) lists:

| Bug | Status | Summary |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

Under the open-bug auto-fail policy, any open linked bug means the case is not executed. The result is FAILED, attributed to the open bug. The browser was not opened and no steps were run.

The sole assertion (Reel Engagements and Reel Follows must not show an en-dash) is the same class of defect APPS-60871 describes. A PASS would not be trustworthy while the bug is open.

## Steps executed

None. The case was screened out before execution.

| # | Step | Status |
|---|---|---|
| 1 | Hover Brand > Select Content from Top Nav | NOT RUN (open bug) |
| 2 | Add MTV Brand | NOT RUN (open bug) |
| 3 | Select data set "Facebook Only: Reels Insights" | NOT RUN (open bug) |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3 | Reel Engagements and Reel Follows values must not show an en-dash | Not evaluated; case blocked by open bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots. Nothing was run in the browser.

## Known bugs checked

- Case file "Open linked bugs": APPS-60871 (Open) — the cause of this verdict.
- knowledge-base/bug-history.md and known-quirks.md: no QA-35301 matches (pre-fetched shell-side).
- Jira was not re-queried because the Atlassian MCP is absent in headless runs. The bug status is as of the 2026-10-20 cache, so a re-run after the case cache is refreshed will pick up any closure.

## Notes for re-run

- The step 3 data set note says "Facebook Only: Reels Insights" is deprecated. On re-run, use the Facebook-only reels data set that exists.
- No matching skill was found in the pre-fetched registry lookup. The case notes point to `brand-content-grid-math` (Table View DOM scrape) for the data check.

## Bugs filed

None. This is a markdown-only report, and no new bug was filed. The failure is attributed to existing APPS-60871.
