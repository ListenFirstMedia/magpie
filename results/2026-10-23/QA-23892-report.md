# QA-23892 — BPC > Brand Content vs Brand Insights

**Date:** 2026-10-23 (Friday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — LFMP-31958, LFMP-32113**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs" section (as of 2026-10-19) lists two open bugs. Today's snapshot `results/open-bugs-2026-10-23.json` confirms both are still Open.

| Bug | Status | Title |
|---|---|---|
| LFMP-31958 | Open | Twitter Reactions Mismatched between Brand > Insights BPC and Brand content |
| LFMP-32113 | Open | Brand Content > LFM vs Native - Past Date - native data is lower than ... |

**Interference judgment: INTERFERES (both).**
- LFMP-31958 describes the exact comparison this case performs: Brand Insights BPC post values vs Brand Content post values, with Twitter metrics mismatching. The case's Twitter channel run and its Public Impressions assertion fall directly in this bug's scope, so a mismatch there could not be told apart from a new defect.
- LFMP-32113 concerns Brand Content data diverging from native values. Brand Content is the comparison target in every step 8 comparison, so a discrepancy could not be attributed reliably.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` requires auto-fail for any open linked bug, with no browser flow run. The open-bug-auto-fail policy gives the same result.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights) matches Brand Content posts data, for Facebook, Instagram, Twitter, YouTube and TikTok (Hulu \| Spotify (Global)) | Not executed — blocked by open bugs LFMP-31958 / LFMP-32113 | BLOCKED |
| A2 | 8 | Twitter posts Public Impressions match between BPC and Brand Content | Not executed — blocked by open bug LFMP-31958 (Twitter mismatch BPC vs Brand Content) | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-23892/`. The decision rests on `cases/QA-23892.md` ("Open linked bugs (as of 2026-10-19)") and `results/open-bugs-2026-10-23.json`.

## Known bugs checked

- **LFMP-31958 (Open):** interferes, so the case is blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- **LFMP-32113 (Open):** interferes, so the case is blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-23892 entries (pre-fetched shell-side).
- No matching skill was pre-resolved and no REGISTRY lookup was done, since no steps were executed. The likely fit on re-run is `brand-content-grid-math` (per the case note).

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

Re-run automatically once LFMP-31958 and LFMP-32113 are closed and the case cache's "Open linked bugs" section is refreshed. If either regresses after closing, attribute it to that bug.
