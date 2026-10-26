# QA-19698 — Brand Content - Impressions - Data Test - FB

**Date:** 2026-10-23 (Friday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-62822**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-23)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-62822 | QA Ready | Data Collection: Facebook Posts (Authorized) data is not collected |

**Interference judgment: INTERFERES.**
- The case reads per-post Organic Impressions, Paid Impressions, Impressions, Engagements and Engagement Rate on the Facebook-only Impression dataset.
- The bug says Facebook Posts (Authorized) data is not being collected, so those per-post values may be missing or incomplete. The case notes treat "–" as no data and skip it, so a collection gap would be indistinguishable from a legitimately empty metric.
- A PASS on the sum and ratio assertions could therefore be vacuous or misleading.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` requires auto-fail for any open linked bug (status QA Ready counts as open). The open-bug-auto-fail directive of 2026-10-22 says the same, with no interference judgement needed.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen: no login, no navigation, no screenshots.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions (per post, Facebook only) | Not executed — blocked by open bug APPS-62822 | BLOCKED |
| A5 | 5 | Engagements / Impressions = Engagement Rate (±0.01 pp of the 2-decimal display) | Not executed — blocked by open bug APPS-62822 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-19698/`. The decision rests on `cases/QA-19698.md` ("Open linked bugs (as of 2026-10-23)").

## Known bugs checked

- **APPS-62822 (QA Ready):** interferes, so the case is blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-19698 (pre-fetched).
- No skill was pre-resolved; none was looked up, since no steps were run.

## Bugs filed

None. This is a markdown-only report, and no Jira tickets were created. The case should be re-run once APPS-62822 closes and the case file's open-bug section is refreshed.

## Re-run note

Today is Friday, so the account/brand to use on re-run is Hulu / Hulu (or Ralph Lauren / Ralph Lauren, per the weekday rotation).
