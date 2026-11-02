# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Date:** 2026-10-28 (Wednesday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

**Interference judgment: INTERFERES.**
- The bug is a data-rendering defect that shows an en-dash (–) in place of real metric values across datasets.
- The case's only assertion (A3) is that Reel Engagements and Reel Follows must NOT show an en-dash. That is the exact symptom APPS-60871 describes.
- A PASS or FAIL from this run could not be cleanly attributed to the Facebook Reels dataset rather than to the known bug. Rule 7 requires auto-fail for any open linked bug.
- The bug title names Twitter, Instagram and YouTube rather than Facebook, so the bug may not directly affect this dataset. That does not change the verdict, because Rule 7 and the open-bug-auto-fail policy apply to any open linked bug.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

| Step | Description | Status |
|---|---|---|
| 1 | Hover Brand > Content from the Top Nav | Not executed |
| 2 | Add MTV brand | Not executed |
| 3 | Select data set "Facebook Only: Reels Insights" (deprecated metric; check the Facebook-only reels data set) | Not executed |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A3 | 3 | Reel Engagements and Reel Follows values do not show an en-dash | Not executed — blocked by open bug APPS-60871 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-35301/`. The decision rests on the case file `cases/QA-35301.md` ("Open linked bugs").

## Known bugs checked

- **APPS-60871 (Open):** treated as interfering, so the case is blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md` have no QA-35301 entries (pre-fetched shell-side).
- No matching skill was pre-resolved from `skills/REGISTRY.md`. I did not grep further, because no browser run was done. The likely fit on re-run is `brand-content-grid-math` (Table View DOM scrape), per the case notes.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Case note: "Facebook Only: Reels Insights" is flagged as deprecated. On re-run, verify the Facebook-channel-only reels data set exists in the dropdown. If it doesn't, flag a spec-drift / test-data gap rather than substituting another data set.
- Use the `brand-content-grid-math` Table View scrape to read Reel Engagements and Reel Follows for every row.
