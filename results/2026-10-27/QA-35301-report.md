# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Date:** 2026-10-27 (Tuesday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

**Interference judgment: INTERFERES.**
- The case's only assertion (A3) is that Reel Engagements and Reel Follows show no en-dash. APPS-60871 is a defect where an en-dash is rendered in place of metric values across datasets, so a dash seen in this run could not be attributed to this dataset rather than to the known bug.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` and the open-bug-auto-fail policy require an auto-fail for any open linked bug, and the bug's subject matches the assertion directly.
- Note: the bug title names Twitter, Instagram and YouTube, not Facebook. Whether it reproduces on Facebook Reels is unverified, because the flow was not run. The verdict follows the policy, not a reproduction.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A3 | 3 | Reel Engagements and Reel Follows values do not show an en-dash | Not executed — blocked by open bug APPS-60871 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-35301/`. The decision rests on `cases/QA-35301.md` ("Open linked bugs").

## Known bugs checked

- **APPS-60871 (Open):** treated as interfering, so the case is blocked. It was not reproduced.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-35301 entries (pre-fetched shell-side).
- No skill was pre-resolved and none was searched for, since the case was not run. Likely fits on re-run: `brand-content-grid-math` (Table View scrape).
- Case note: the "Facebook Only: Reels Insights" data set is deprecated. On re-run, check the Facebook-only reels data set that replaces it, and confirm the step wording with the case owner.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Per the case: hover Brand → Content, add the MTV brand (exact typeahead match, Rule 1), open the data set dropdown, pick the Facebook reels data set, switch to Table View and check Reel Engagements and Reel Follows for en-dashes.
- Precondition: logged in on the Viacom account.
