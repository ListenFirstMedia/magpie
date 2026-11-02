# QA-21108 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 2

**Run date:** 2026-10-30 (unattended, headless)
**Verdict: FAILED (blocked by open bug)**

## Verdict rationale

Per spec-adherence Rule 7 (open-bug auto-fail) and the user-confirmed policy of 2026-10-22 ("any open linked bug = FAILED, in the report and in the Xray execution"), the case file's "Open linked bugs" section lists an OPEN bug, so the case was **not executed**. The browser was never opened.

- **APPS-60871** (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

This bug affects exactly the datasets this case compares (Twitter Engagements & Follows, Instagram Insights / Reels / ActionTypes, YouTube Insights / Premium). Metrics rendered as "–" would make the day-over-day comparison in assertions 5, 8, 11, 14, 17 and 20 unreliable.

## Steps executed

None (screened out before execution).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Twitter Engagements & Follows metrics show no big day-over-day variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A8 | 8 | Instagram Insights metrics show no big variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A11 | 11 | Reels dataset metrics show no big variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A14 | 14 | Instagram ActionTypes metrics show no big variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A17 | 17 | YouTube Insights metrics show no big variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A20 | 20 | YouTube Premium metrics show no big variation | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots (browser not opened). Open-bug status sources:
- `cases/QA-21108.md` section "Open linked bugs (as of 2026-10-20)".
- `results/open-bugs-2026-10-30.json`: QA-21108 → APPS-60871 [Open] (today's cache, still open).

## Known bugs checked

- Case file "Open linked bugs": APPS-60871 (Open) → triggers auto-fail.
- `knowledge-base/bug-history.md`: no entries for QA-21108 (pre-fetched).
- `knowledge-base/known-quirks.md`: already records QA-21108/21109 as auto-failed for an open linked bug.
- Jira was not re-queried (Atlassian MCP absent in headless run); bug status per today's open-bugs cache. Re-runs pick the case up automatically once the bug closes and the cache is refreshed.

## Bugs filed

None. (No new bugs; the failure is attributed to existing APPS-60871.)
