# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Run date:** 2026-10-26 (unattended, headless)
**Test Set:** QA-26183 "Daily Data Testing -2"
**Verdict: FAILED (blocked by open bug)**

## Screening (spec-adherence Rule 7 — open-bug auto-fail)

The case file's "## Open linked bugs" section lists an OPEN defect:

| Bug | Status | Summary |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

The case's only assertion is "Reel Engagements and Reel Follows values should not have Endash".
APPS-60871 is an open defect for Endash rendering in data-set metrics, which is the same failure
class this assertion checks. Per Rule 7 and the 2026-10-22 open-bug auto-fail directive, the case
was NOT executed and no browser session was opened. No interference judgement is made.

## Steps executed

None. Not run, per Rule 7.

1. Hover over Brand and select Content from the Top Nav: not executed
2. Add MTV Brand: not executed
3. Select data set "Facebook Only: Reels Insights": not executed

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A3 | 3 | Reel Engagements and Reel Follows values do not show an Endash | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |

## Evidence

No screenshots or snapshots (browser not opened). The open-bug list was baked into
cases/QA-35301.md on 2026-10-20 and not refreshed from Jira (the Atlassian MCP is absent in
headless runs). If APPS-60871 has since closed, refresh the case cache and re-run.

## Known bugs checked

- Jira issue-links (from case file, as of 2026-10-20): APPS-60871 (Open), which triggers the auto-fail.
- knowledge-base/bug-history.md for QA-35301: no matches (pre-fetched).
- knowledge-base/known-quirks.md for QA-35301: no matches (pre-fetched).
- Skill lookup: no matching skill was pre-resolved. None needed, since the case was not run.
- Note from the case: the "Facebook Only: Reels Insights" data set is flagged deprecated, so on re-run
  check the Facebook-channel Reels data set instead.

## Bugs filed

None. Markdown-only; no new bugs identified. The failure is attributed to existing open bug APPS-60871.
