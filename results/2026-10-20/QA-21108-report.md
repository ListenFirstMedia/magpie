# QA-21108 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 2

**Date:** 2026-10-20
**Mode:** unattended / headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs" section lists one open bug:

- **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

**Interference judgement: INTERFERES.** The case's whole purpose is to read per-post metric values from the Brand Content grid on the Twitter (Engagements & Follows), Instagram (Insights, Reels, ActionTypes) and YouTube (Insights, Premium) datasets and compare them with the previous day's values. APPS-60871 is a data-rendering defect that shows "–" instead of values for multiple metrics on exactly these datasets. Assertions 5/8/11/14/17/20 (no large day-over-day variation) therefore cannot be judged. A "–" would read as no data or a spurious drop, and the result would not be trustworthy.

The browser flow was **not executed**, per Rule 7 and the open-bug-auto-fail rule. Re-runnable once APPS-60871 is closed and the case cache is refreshed.

## Additional note (not the blocking reason)

The case's comparison steps (5, 8, 11, 14, 17, 20) need a baseline screenshot "attached to this test case" (Monday's grid capture). No baseline is available in the local case file, so even without the bug, a headless run could only record current values and not compare them. Whoever picks this up after the bug closes should have a baseline captured first.

## Steps executed

None (blocked before execution).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | No big day-over-day variation (Twitter Engagements & Follows) | Not executed — blocked by APPS-60871 | BLOCKED |
| A8 | 8 | No big day-over-day variation (Instagram Insights) | Not executed — blocked by APPS-60871 | BLOCKED |
| A11 | 11 | No big day-over-day variation (Reels) | Not executed — blocked by APPS-60871 | BLOCKED |
| A14 | 14 | No big day-over-day variation (Instagram ActionTypes) | Not executed — blocked by APPS-60871 | BLOCKED |
| A17 | 17 | No big day-over-day variation (YouTube Insights) | Not executed — blocked by APPS-60871 | BLOCKED |
| A20 | 20 | No big day-over-day variation (YouTube Premium) | Not executed — blocked by APPS-60871 | BLOCKED |

## Evidence

None captured (no browser session was opened). Source of the block: `cases/QA-21108.md`, section "Open linked bugs (as of 2026-10-20)".

## Known bugs checked

- Pre-fetched grep of `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md` for QA-21108: no matches.
- Case-embedded linked bug: APPS-60871 (Open) — judged to interfere (see above). No verification of reproduction was done, because the run was not executed.

## Bugs filed

None (markdown-only; no new bugs identified).
