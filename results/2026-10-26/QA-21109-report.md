# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in
**Verdict: FAILED (blocked by open bug)** — APPS-60871

## Open-bug screen (Rule 7)
- The case file `cases/QA-21109.md` ("Open linked bugs (as of 2026-10-20)") lists **APPS-60871 (Open)**: *Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)*.
- The shell-side refresh `results/open-bugs-2026-10-26.json` confirms the bug is still open as of 2026-10-26: `QA-21109 → APPS-60871 [Open]`.
- The bug affects YouTube datasets directly. Steps 3–8 (YouTube Subscribers and Playlists, YouTube Cards) read metric values from those datasets, and the day-over-day comparison in assertions 5 and 8 cannot give a trustworthy result while those metrics can render as "–".
- Per spec-adherence Rule 7, the case was **not executed**. The browser was never opened and no login was performed.

## Steps executed
None (blocked by the Rule 7 screen). Steps 1–8 in the spec were not attempted.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Metric values for the same post (Engagements, Video Duration, Views, Interactions, Subscribers Gained/Lost, Playlist Adds/Removes) show no big day-over-day variation vs the attached screenshot | Not executed: open bug APPS-60871 | FAILED (blocked by open bug) |
| A8 | 8 | Metric values for the same post (Engagements, Video Duration, Views, Interactions, Card/Teaser Impressions, Clicks, CTR) show no big day-over-day variation vs the attached screenshot | Not executed: open bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence
No screenshots (the browser was not opened). Sources: `cases/QA-21109.md` and `results/open-bugs-2026-10-26.json`.

## Known bugs checked
- **APPS-60871** (Open): attributed as the blocker. It is not a new finding. `knowledge-base/bug-history.md` has no QA-21109 entry, and no skill was pre-resolved for this case.
- No other linked bugs appear in either source.

## Bugs filed
None. This is a markdown-only report and no Jira tickets were created.

## Re-run note
- Re-running will pick up the case automatically once APPS-60871 is closed and the case cache is refreshed.
- Weekday-rotation preconditions for the re-run (Amazon Prime Video account; Monday screenshot attachment vs Friday deletion) are unchanged.
- Today is Monday, so the baseline-screenshot step applies on the first clean run.
