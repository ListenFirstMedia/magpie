# QA-22104 — Brand Content > LFM vs Native > Facebook Channel - Past Date

**Date:** 2026-11-17
**Mode:** unattended / headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — LFMP-32119**

## Screening (Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug (listed twice in the file):

- **LFMP-32119 (Open)** — Brand Content > LFM vs Native > Facebook Channel - Past Date shows big variations when we compare with native

Re-confirmed still open in `results/open-bugs-2026-11-17.json` (entry: "LFMP-32119 [Open] Brand Content > LFM vs Native > Facebook Channel - Past Date shows big variation").

The bug describes exactly this case's assertion (A6: LFM metrics should not vary greatly from Native on the first Facebook post, Jan 1 - Dec 31, 2023). A PASS or FAIL from a fresh run would therefore not be trustworthy, and a failure would simply duplicate the known bug. Per Rule 7 and the open-bug-auto-fail directive, the browser flow was **not executed**. The case can be re-run once LFMP-32119 is closed and the case cache is refreshed.

## Steps executed

None (blocked before execution). Steps 1-6 (open Brand Content, add brand + date range 2023, Facebook only, note first-post Reactions/Comments/Shares, open post, note native Likes/Comments/Shares) not run.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | 6 | LFM metric values (Reactions/Comments/Shares) have no big variation vs Native (Likes/Comments/Shares) | Not executed — blocked by open bug LFMP-32119 | FAILED (blocked by open bug) |

## Evidence

None captured (no browser session was opened). Source of the block: `cases/QA-22104.md`, section "Open linked bugs", and `results/open-bugs-2026-11-17.json`.

## Known bugs checked

- Pre-fetched greps of `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md` for QA-22104: no matches. No matching skill in `skills/REGISTRY.md` was pre-resolved; not needed since the case was not run.
- Case-embedded linked bug: **LFMP-32119 (Open)** — directly matches the assertion under test. Verdict is attributed to this bug. Reproduction was not attempted.

## Bugs filed

None (markdown-only; no new bugs identified; existing bug LFMP-32119 already tracks the issue).
