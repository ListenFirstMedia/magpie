# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

**Run date:** 2026-10-29 (unattended, headless)
**Verdict: FAILED (blocked by open bug)**

## Verdict rationale

Per spec-adherence Rule 7 (open-bug auto-fail) and the user-confirmed policy of 2026-10-22 ("any open linked bug = FAILED, in the report and in the Xray execution"), the case file's "Open linked bugs" section lists an OPEN bug, so the case was **not executed**. The browser was never opened.

- **APPS-60871** (Open): Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

This bug affects exactly the datasets this case compares (YouTube Only: Subscribers and Playlists; YouTube Only: Cards). Metrics rendered as "–" would make the day-over-day comparison in assertions 5 and 8 unreliable.

## Steps executed

None (screened out before execution).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | YouTube Only: Subscribers and Playlists metrics (Engagements, Video Duration, Views, Interactions, Subscribers Gained/Lost, Playlist Adds/Removes) show no big variation vs. the attached previous-day screenshot | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A8 | 8 | YouTube Only: Cards metrics (Engagements, Video Duration, Views, Interactions, Card Impressions/Clicks/CTR, Teaser Impressions/Clicks/CTR) show no big variation vs. the attached previous-day screenshot | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots (browser not opened). Source of the open-bug status: `cases/QA-21109.md` section "Open linked bugs (as of 2026-10-20)".

## Known bugs checked

- Case file "Open linked bugs": APPS-60871 (Open) → triggers auto-fail.
- `knowledge-base/bug-history.md`: no entries for QA-21109 (pre-fetched).
- `knowledge-base/known-quirks.md`: no entries for QA-21109 (pre-fetched).
- Jira was not re-queried (Atlassian MCP absent in headless run); bug status is as of the 2026-10-20 cache. Re-runs pick the case up automatically once the bug closes and the cache is refreshed.

## Bugs filed

None. (No new bugs; the failure is attributed to existing APPS-60871.)
