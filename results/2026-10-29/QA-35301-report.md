# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Date:** 2026-10-29 (Thursday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs" section lists one open bug. `results/open-bugs-2026-10-29.json` (today's refreshed list) still shows it as Open.

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

**Attribution:** The case's only assertion (A3) checks that Reel Engagements and Reel Follows show no en-dash. APPS-60871 is a data-rendering defect that shows en-dashes in place of metric values across datasets. A failure here cannot be told apart from the bug, and a PASS would not be trustworthy. Per Rule 7 and the open-bug-auto-fail directive, the case is FAILED and attributed to the bug without running the browser flow.

Not needed for the verdict: the ticket's step 3 says the "Facebook Only: Reels Insights" metric is deprecated and tells the tester to check the Reels data set for the Facebook channel instead. That fallback is ambiguous without a live look at the dataset dropdown. It would need resolving at re-run.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

| Step | Description | Status |
|---|---|---|
| 1 | Hover Brand > Content in the top nav | Not executed |
| 2 | Add MTV brand | Not executed |
| 3 | Open the data set dropdown and select Facebook Only: Reels Insights (or the Facebook-only Reels data set) | Not executed |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A3 | 3 | Reel Engagements and Reel Follows values do not show an en-dash (–) | Not executed — blocked by open bug APPS-60871 | BLOCKED (case verdict FAILED per open-bug policy) |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-35301/`. The decision rests on `cases/QA-35301.md` ("Open linked bugs (as of 2026-10-20)") and `results/open-bugs-2026-10-29.json`.

## Known bugs checked

- **APPS-60871 (Open):** the case is attributed to this bug. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-35301 entries (pre-fetched shell-side).
- No skill was pre-resolved for this flow, and no registry lookup was needed since no steps were run. At re-run, grep `skills/REGISTRY.md` for brand-content table view / `brand-content-grid-math`.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Use the Table View scrape (`brand-content-grid-math`) to read the Reel Engagements and Reel Follows columns for all rows. Treat "–" as no data unless it is structurally absent for the channel.
- Resolve which dataset replaces the deprecated "Facebook Only: Reels Insights" (the Facebook-channel Reels data set) and update the case file.
