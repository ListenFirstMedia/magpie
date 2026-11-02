# QA-29128 — Brand Content - Impressions - Data Test - (Twitter and Instagram)

**Run date:** 2026-10-26 (Monday) — unattended / headless (`claude -p`)
**Verdict: FAILED (blocked by open bug)**

## Why this verdict

Per spec-adherence Rule 7 (open-bug auto-fail), the case file's "Open linked bugs" section lists an OPEN defect:

- **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

This defect hits the metrics this case asserts on (Impressions, Reach, Engagement Rate, Engaged User Rate on Instagram and Twitter). A case with an open linked defect cannot produce a trustworthy PASS, so the browser flow was **not executed**. The policy was confirmed by the user on 2026-10-22: any open linked bug means FAILED, in the report and in the Xray execution. The verdict stays FAILED until APPS-60871 closes and the case cache is refreshed.

## Steps executed

None. Browser not opened (Rule 7 screen).

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| 4 | 4 | Instagram: Organic Impressions + Paid Impressions = Impressions | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 5 | 5 | Instagram: Organic Reach + Promoted Reach = Reach | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 6 | 6-7 | Instagram: Engagements / Impressions = Engagement Rate | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 7 | 7 | Instagram: Engagements / Reach = Engaged User Rate | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 9 | 9 | Twitter: Organic Impressions + Paid Impressions = Impressions | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 10 | 10 | Twitter: Organic Reach + Promoted Reach = Reach | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 11a | 11 | Twitter: Engagements / Impressions = Engagement Rate | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |
| 11b | 11 | Twitter: Engaged User Rate displays endash | Not executed (open bug APPS-60871) | FAILED (blocked by open bug) |

## Evidence

No screenshots or DOM captures. Source of the verdict: the "Open linked bugs (as of 2026-10-20)" section of `cases/QA-29128.md`, plus the matching entry in `knowledge-base/known-quirks.md` (QA-29128/35301 — APPS-60871).

## Known bugs checked

- **Jira issue-links (as cached in the case file):** APPS-60871 — Open. This triggers the Rule 7 auto-fail.
- **knowledge-base/bug-history.md:** no entries for QA-29128.
- **knowledge-base/known-quirks.md:** the unattended-runner entry lists QA-29128/35301 as FAILED for APPS-60871.
- Because the browser flow was not run, it is unknown whether APPS-60871 reproduces on Monday's accounts (HBO Max / Amazon Prime Video / Conde Nast; brands HBO Max / Amazon Prime Video / Vogue-US). The verdict is attributed to the bug by policy, not by observation.

## Bugs filed

None. No new bugs found. No Jira tickets were created (reports only). Existing bug APPS-60871 is cited above.

## Next action

Re-run once APPS-60871 is closed and `cases/QA-29128.md` is re-ingested with a refreshed "Open linked bugs" section. If it closes as fixed, watch for regression on the endash assertions (step 11).
