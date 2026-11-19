# QA-21913 — Brand Content > LFM vs Native > Twitter Channel

- **Run date:** 2026-11-17 (Tuesday), unattended headless (`claude -p`)
- **Test Set:** QA-21686 "Daily Data Testing -3"
- **Case file:** cases/QA-21913.md

## Verdict: FAILED (blocked by open bug)

Rule 7 (open-bug auto-fail, `skills/_shared/spec-adherence-rules.md`) applies. The case file's
"Open linked bugs" section lists an open defect. Per the rule, the browser flow was **not executed**.

- **Blocking bug:** LFMP-32113 (Open): Brand Content > LFM vs Native - Past Date - native data is lower than LFM

## Steps executed

None. Execution was stopped at the pre-run open-bug screen (no login, no browser actions).

| # | Step | Status |
| --- | --- | --- |
| 1 | Hover over the Brand and Select Content from the Top Nav | Not executed (open-bug screen) |
| 2 | Add a Brand | Not executed |
| 3 | Enable the Twitter Channel Only | Not executed |
| 4 | Note Reactions, Shares, Comments from the first post | Not executed |
| 5 | Click the image on the first post | Not executed |
| 6 | Note Likes, Retweets, Quote Tweets from the native post | Not executed |

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A6 | 6 | LFM metric values do not show big variations vs Native | Not evaluated. The case is blocked by open bug LFMP-32113, which describes this same comparison (native data lower than LFM for past dates). | FAILED (blocked by open bug LFMP-32113) |

## Evidence

- Case file section "Open linked bugs (as of 2026-10-20)": `LFMP-32113 (Open)`.
- No screenshots (browser never opened). `.playwright-out/QA-21913/` not created.
- Intended data for today (Tuesday): Account UCLA / Wasserman, Brand "University of California, Los Angeles" / Gatorade. Not exercised.

## Known bugs checked

- **Case file "Open linked bugs":** LFMP-32113 is Open, so the case auto-fails.
- **knowledge-base/bug-history.md** (pre-fetched grep for QA-21913): no matches.
- **knowledge-base/known-quirks.md** (pre-fetched grep for QA-21913): no matches.
- The linked-bug list in the case file is dated 2026-10-20. It was not re-fetched from Jira, because the Atlassian MCP is absent in this headless run. If LFMP-32113 has since closed, refresh the cache and re-run.

## Bugs filed

None. This is a markdown-only report and no new bugs were found. The failure is attributed to the existing LFMP-32113.

## Cleanup

None (read-only Data Test; nothing was created).

## Notes for harvest

- No skill used or promoted. Skill lookup was skipped, because the case never reached the browser.
- No REGISTRY or skill maintenance done (deferred to harvest.sh).
