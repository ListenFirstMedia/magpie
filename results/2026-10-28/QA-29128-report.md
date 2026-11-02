# QA-29128 — Brand Content - Impressions - Data Test - (Twitter and Instagram)

**Date:** 2026-10-28 (Wednesday)
**Mode:** unattended, headless (`claude -p`)
**Test Set:** QA-26183 "Daily Data Testing -2"
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

**Interference judgment: INTERFERES.**
- The bug is a data-rendering defect that shows an en-dash (–) in place of real metric values on the Twitter and Instagram datasets.
- This case checks Impressions, Reach, Engagements, Engagement Rate and Engaged User Rate on Instagram-only and Twitter-only. The grid math (Organic + Paid = Impressions, Organic + Promoted = Reach, Engagements / Impressions = Engagement Rate, Engagements / Reach = Engaged User Rate) depends on those cells holding real values. A stray en-dash would corrupt the sums and ratios, and it could not be told apart from a genuine mismatch.
- Assertion 11 (second) also expects Engaged User Rate to display an en-dash for Twitter. That makes en-dash handling the subject of the test, so an en-dash found at run time could not be attributed cleanly to expected behavior or to the bug.
- Rule 7 and the open-bug-auto-fail policy (confirmed by the user on 2026-10-22) require FAILED for any open linked bug, so the run was not attempted.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

| Step | Description | Status |
|---|---|---|
| 1 | Hover Brand > Content from the Top Nav | Not executed |
| 2 | Add a Brand and select the Impressions dataset | Not executed |
| 3 | Enable Instagram Channel Only | Not executed |
| 4 | Add Organic Impressions + Paid Impressions per grid row | Not executed |
| 5 | Add Organic Reach + Paid Reach per grid row | Not executed |
| 6 | Note Engagements and Impressions | Not executed |
| 7 | Divide Engagements by Reach per grid row | Not executed |
| 8 | Enable Twitter Channel Only | Not executed |
| 9 | Add Organic Impressions + Paid Impressions per grid row | Not executed |
| 10 | Add Organic Reach + Paid Reach per grid row | Not executed |
| 11 | Note Engagements and Impressions | Not executed |

The Wednesday account/brand row from the case's table is Apple Services / NBCU Enterprises with brands Apple Music, CNBC and NBC News. It was not exercised.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions (Instagram) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A5 | 5 | Organic Reach + Promoted Reach = Reach (Instagram) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A6 | 6 | Engagements / Impressions = Engagement Rate (Instagram) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A7 | 7 | Engagements / Reach = Engaged User Rate (Instagram) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A9 | 9 | Organic Impressions + Paid Impressions = Impressions (Twitter) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A10 | 10 | Organic Reach + Promoted Reach = Reach (Twitter) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A11a | 11 | Engagements / Impressions = Engagement Rate (Twitter) | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A11b | 11 | Engaged User Rate displays an en-dash (Twitter) | Not executed — blocked by open bug APPS-60871 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-29128/`. The decision rests on the case file `cases/QA-29128.md` ("Open linked bugs").

## Known bugs checked

- **APPS-60871 (Open):** treated as interfering, so the case is FAILED. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` has no QA-29128 entry (pre-fetched shell-side). `knowledge-base/known-quirks.md` only records QA-29128 in the open-bug auto-fail policy entry.
- No matching skill was pre-resolved from `skills/REGISTRY.md`. I did not grep further, because no browser run was done. The case notes point to `brand-content-grid-math` (Table View DOM scrape) as the likely fit on re-run.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Use the Wednesday row (Apple Services / NBCU Enterprises → Apple Music, CNBC, NBC News) from the case's Description table.
- Use the `brand-content-grid-math` Table View scrape for the per-row sums and ratios. Per the case notes, treat "–" as no data unless it is structurally absent for the channel.
- The case lists a typo-like duplicate "11" assertion; it is reported here as A11a (Engagement Rate) and A11b (Engaged User Rate en-dash).
