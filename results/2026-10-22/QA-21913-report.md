# QA-21913 — Brand Content > LFM vs Native > Twitter Channel

**Verdict: FAILED (blocked by open bug)**

- **Run date:** 2026-10-22 (unattended, headless `claude -p`)
- **Test set:** QA-21686 "Daily Data Testing -3"
- **Source:** cases/QA-21913.md (ingested 2026-10-20)

## Screening (Rule 7 — open-bug auto-fail)

The case file's "Open linked bugs" section lists:

- **LFMP-32113 (Open)** — Brand Content > LFM vs Native - Past Date - native data is lower than LFM

Rule 7 says a case with any open linked bug must not be run. The bug also directly interferes with the case's only assertion (#6: LFM metrics should not vary much from Native). The bug describes native values coming in lower than LFM, which is the exact comparison the assertion makes. A PASS or FAIL from a run would not be trustworthy.

## Steps executed

None. The browser flow was not opened.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| 6 | 4–6 | LFM value of metrics (Reactions/Shares/Comments) should not have big variations vs Native (Likes/Retweets/Quote Tweets) | Not evaluated | FAILED (blocked by open bug LFMP-32113) |

## Evidence

No screenshots. Nothing was executed.

## Known bugs checked

- Jira issue-links (baked into the case file): LFMP-32113 (Open), which blocks the case.
- knowledge-base/bug-history.md: no QA-21913 match (pre-fetched).
- knowledge-base/known-quirks.md: no QA-21913 match (pre-fetched).

## Bugs filed

None. No new bugs found; this is a block on the existing LFMP-32113.

## Re-run

The case will be picked up automatically once LFMP-32113 closes and the case cache is refreshed.
