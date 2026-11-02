# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

**Date:** 2026-10-30 (Friday)
**Verdict: FAILED (blocked by open bug)** — APPS-60871

## Screening (Rule 7 — open-bug auto-fail)
- Case file `cases/QA-21109.md` "Open linked bugs" lists: **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube).
- Re-confirmed against today's snapshot `results/open-bugs-2026-10-30.json`: `QA-21109 → APPS-60871 [Open]`.
- Per Rule 7 the case was **not executed**. The browser was never opened, so there are no steps, screenshots or evidence.

## Steps executed
None (blocked by open bug before execution).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Metric values (YouTube Subscribers and Playlists dataset) show no big day-over-day variation vs. attached screenshot | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |
| A2 | 8 | Metric values (YouTube Cards dataset) show no big day-over-day variation vs. attached screenshot | Not executed — open bug APPS-60871 | FAILED (blocked by open bug) |

## Known bugs checked
- **APPS-60871 (Open)** — En-dash (–) shown for multiple metrics across datasets, including YouTube. It affects the same metric grids this case compares (Subscribers Gained/Lost, Playlist Adds/Removes, Card/Teaser metrics), so a day-over-day comparison would not be trustworthy while it is open.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-21109 matches (pre-fetched).

## Bugs filed
None. No new bugs found, since the case was not run. Nothing is filed in Jira.

## Notes
- The case will be picked up automatically on re-run once APPS-60871 closes and the case cache is refreshed.
- No registered skill matched in the pre-fetched context. The case notes point to `brand-content-grid-math` for the eventual run.
- Friday housekeeping step ("delete the screenshot attached to this test case") is a Jira-attachment action and was not performed.
