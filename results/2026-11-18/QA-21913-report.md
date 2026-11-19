# QA-21913 — Brand Content > LFM vs Native > Twitter Channel

**Verdict: FAILED (blocked by open bug)** — LFMP-32113 (Open) is linked to this case. The case was not executed (spec-adherence Rule 7, open-bug auto-fail).

- Run: 2026-11-18 (Wednesday), unattended headless
- Source: `cases/QA-21913.md` (ingested 2026-10-20, Test Set QA-21686 "Daily Data Testing -3")
- Screen performed: case file section "## Open linked bugs (as of 2026-10-20)", cross-checked against `results/open-bugs-2026-11-18.json`, which also lists LFMP-32113 as `[Open]` on 2026-11-18.
- Browser: not opened. No login, no steps run, no screenshots (`.playwright-out/QA-21913/` is unused).

## Steps executed

None. Per Rule 7, no step of the case was run.

| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand > Content | NOT RUN (open-bug auto-fail) |
| 2 | Add a Brand | NOT RUN |
| 3 | Enable Twitter channel only | NOT RUN |
| 4 | Note Reactions/Shares/Comments of first post | NOT RUN |
| 5 | Click first post image | NOT RUN |
| 6 | Note native Likes/Retweets/Quote Tweets | NOT RUN |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | 6 | LFM metric values do not vary much from Native | Not evaluated: the case was blocked by an open linked bug before execution | FAILED (blocked by open bug LFMP-32113) |

## Evidence

- Case file: `cases/QA-21913.md`, "Open linked bugs" lists `LFMP-32113 (Open): Brand Content > LFM vs Native - Past Date - native data is lower than LFM`.
- `results/open-bugs-2026-11-18.json`, key `QA-21913`: `LFMP-32113 [Open] Brand Content > LFM vs Native - Past Date - native data is lower than LFM`.
- The bug targets the same surface and assertion as this case (LFM vs Native variation on past-date posts), so a run could not give a trustworthy PASS.

## Known bugs checked

| Bug | Status | Relevance |
|-----|--------|-----------|
| LFMP-32113 | Open | Directly attributable: native data is lower than LFM for past dates, the same comparison Assertion 6 makes. The case is failed on this bug under the open-bug auto-fail policy. |

- `knowledge-base/bug-history.md`: no entry for QA-21913 (pre-fetched).
- `knowledge-base/known-quirks.md`: no entry for QA-21913 (pre-fetched).
- Skill lookup: no skill pre-resolved. None was needed because the case was not run. A candidate for a later run is `brand-content-native-post-check` (used by sibling case QA-21912).

## Bugs filed

None. The failure is attributed to the existing bug LFMP-32113, and no new bugs were found. Nothing was filed in Jira (markdown-only policy).

## Cleanup

None (read-only Data Test, and nothing was run).

## Re-run note

The case will run normally on a later run once LFMP-32113 is closed and the open-bug cache is refreshed. Two details in the case file still need fixing before then:
- The Notes weekday-rotation line (Wed = Apple Services/Wasserman) conflicts with the Description table (Wed = Apple Services/Conde Nast; brands Apple Music/GQ - Japan).
- The Notes line also lists a different account set for Mon, Tue and Thu than the table does.
