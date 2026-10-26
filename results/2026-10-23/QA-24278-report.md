# QA-24278 — Brand Content - Impressions Data Set - Aggregate Data Test

**Verdict: FAILED (blocked by open bug)**

- **Run date:** 2026-10-23 (Friday), unattended headless `claude -p`
- **Case file:** cases/QA-24278.md (ingested 2026-10-19, open-bug section refreshed 2026-10-23)
- **Test Set:** QA-27628 "Daily Data Testing -1"

## Screening result (spec-adherence Rule 7)

The case file's "Open linked bugs (as of 2026-10-23)" section lists one open bug:

| Bug | Status | Summary |
|---|---|---|
| APPS-62822 | QA Ready | Data Collection: Facebook Posts (Authorized) data is not collected |

Under Rule 7 any open linked bug means the case is not run. The browser flow was not opened and no steps were executed.

## Steps executed

None. Steps 1-18 were not run, per Rule 7.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| 4 | 4 | Organic Impressions + Paid Impressions = Impressions (Facebook) | Not executed (open bug APPS-62822) | FAILED (blocked by open bug) |
| 5 | 5 | Engagements / Impressions = Average Engagement Rate (Facebook) | Not executed (open bug APPS-62822) | FAILED (blocked by open bug) |
| 7 | 7 | Organic + Paid Impressions = Impressions (Instagram) | Not executed | FAILED (blocked by open bug) |
| 8 | 8 | Organic + Paid Reach = Reach (Instagram) | Not executed | FAILED (blocked by open bug) |
| 9 | 9 | Engagements / Impressions = Avg Engagement Rate (Instagram) | Not executed | FAILED (blocked by open bug) |
| 10 | 10 | Engagements / Reach x 100 = Engaged User Rate (Instagram) | Not executed | FAILED (blocked by open bug) |
| 12 | 12 | Organic + Paid Impressions = Impressions (Twitter) | Not executed | FAILED (blocked by open bug) |
| 13 | 13 | Organic + Paid Reach = Reach (Twitter) | Not executed | FAILED (blocked by open bug) |
| 14a | 14 | Engagements / Impressions = Avg Engagement Rate (Twitter) | Not executed | FAILED (blocked by open bug) |
| 14b | 14 | Engaged User Rate shows en-dash (Twitter) | Not executed | FAILED (blocked by open bug) |
| 16 | 16 | Organic + Paid Impressions = Impressions (LinkedIn) | Not executed | FAILED (blocked by open bug) |
| 17 | 17 | Organic + Paid Reach = Reach (LinkedIn) | Not executed | FAILED (blocked by open bug) |
| 18a | 18 | Engagements / Impressions = Avg Engagement Rate (LinkedIn) | Not executed | FAILED (blocked by open bug) |
| 18b | 18 | Engaged User Rate shows en-dash (LinkedIn) | Not executed | FAILED (blocked by open bug) |

Only the Facebook assertions (4, 5) touch the area of the open bug (Facebook post data collection). The case is failed as a whole because Rule 7 makes no judgement about whether the bug interferes.

## Evidence

No screenshots or DOM captures. Nothing was run, so `.playwright-out/QA-24278/` has no artifacts.

## Known bugs checked

- **Case file "Open linked bugs" section:** APPS-62822 (QA Ready), the cause of this verdict.
- **knowledge-base/bug-history.md:** no QA-24278 entry (pre-fetched grep).
- **knowledge-base/known-quirks.md:** no QA-24278 entry (pre-fetched grep).
- **Skill lookup:** no skill was pre-resolved. The case notes point to `brand-content-grid-math`, which will be needed on re-run.
- **Bug reproduction:** not verified, because the flow was not run.

## Bugs filed

None. No new defects were observed. Nothing is filed in Jira, per policy.

## Re-run guidance

- Re-run once APPS-62822 is closed and the case file's open-bug section is refreshed. Closing the bug may not be enough on its own.
- Friday rotation: Hulu / Hulu (Amazon Prime Video on alternate days). Use the exact brand from the typeahead Results (Rule 1).
- Facebook Reach was removed by Meta in Nov 2025, per the case preconditions.
