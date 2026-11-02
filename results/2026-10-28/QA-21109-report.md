# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

- **Date:** 2026-10-28
- **Test Set:** QA-26183 "Daily Data Testing -2"
- **Mode:** Unattended / headless (`claude -p`)

## Verdict: FAILED (blocked by open bug)

The case was **not executed**. Per spec-adherence Rule 7 (open-bug auto-fail), the case file's
"Open linked bugs" section lists an open defect, so the case is failed and attributed to that bug.
No browser flow was opened and no login was performed.

## Known bugs checked

| Bug | Status (per case file, as of 2026-10-20) | Summary | Effect |
|-----|------------------------------------------|---------|--------|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) | Auto-fail. Case is attributed to this bug. |

- `knowledge-base/bug-history.md`: no matches for QA-21109 (pre-fetched shell-side).
- `knowledge-base/known-quirks.md`: no matches for QA-21109 (pre-fetched shell-side).
- Jira was not re-queried: the Atlassian MCP is absent in headless runs, so the link status comes from the case file cache.
- The cached bug status is 8 days old (2026-10-20). If APPS-60871 has been closed since, refresh the cache with `Open linked bugs: None open` and re-run.

## Steps executed

None. The run stopped at the Rule 7 screen.

| # | Step | Status |
|---|------|--------|
| 1 | Hover over the Brand and Select Content from the Top Nav | Not run |
| 2 | Add "Amazon Prime Video" Brand | Not run |
| 3 | Select Youtube Only: Subscribers and Playlists Dataset | Not run |
| 4 | Note [Engagements, Video Duration, Views, Interactions, Subscribers Gained, Subscribers Lost, Playlist Adds, Playlist Removes] | Not run |
| 5 | Compare with the attached screenshot | Not run |
| 6 | Select Youtube Only: Cards Dataset | Not run |
| 7 | Note [Engagements, Video Duration, Views, Interactions, Card Impressions, Card Clicks, Card CTR, Teaser Impressions, Teaser Clicks, Teaser CTR] | Not run |
| 8 | Compare with the attached screenshot | Not run |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Metric values show no big variation (double or triple) vs. the previous day | Not evaluated: open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A2 | 8 | Metric values show no big variation (double or triple) vs. the previous day | Not evaluated: open linked bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

- No screenshots were taken and no `.playwright-out/QA-21109/` artifacts exist, because the browser was never opened.
- Basis for the verdict: the "## Open linked bugs (as of 2026-10-20)" section of `cases/QA-21109.md` and Rule 7 in `skills/_shared/spec-adherence-rules.md`.

## Bugs filed

None. Nothing new was observed because the case did not run.
