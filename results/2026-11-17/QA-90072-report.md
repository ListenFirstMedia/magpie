# QA-90072 — Brand Content > Reels Data Set - LFM vs Native

**Date:** 2026-11-17 (Tuesday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs (as of 2026-10-20)" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

Rule 7 and the 2026-10-22 open-bug-auto-fail directive: any open linked bug fails the case, attributed to that bug, with no interference judgement.

Additional context: the bug is also likely to interfere in practice. Step 4 reads Reel Reactions, Reel Comments and Reel Shares from the first post in the Instagram "Reels" dataset. An en-dash in place of a real value would make the LFM-vs-Native comparison (A6) untrustworthy. The case's own note says to treat "–" as no data, so the bug would be indistinguishable from a legitimately empty metric.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

| Step | Description | Status |
|---|---|---|
| 1–6 | Brand Content > Amazon Prime Video > Reels dataset > read first post's LFM values > open native post > compare | NOT EXECUTED (blocked by APPS-60871) |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A6 | 6 | LFM metric values (Reel Reactions/Comments/Shares) show no big variation vs. Native (Reel Likes/Comments/Shares) | Not executed — blocked by open bug APPS-60871 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-90072/`. The decision rests on `cases/QA-90072.md` ("Open linked bugs").

## Known bugs checked

- **APPS-60871 (Open):** triggers auto-fail. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-90072 entries (pre-fetched shell-side).
- No matching skill was pre-resolved, and I did no further REGISTRY lookup because no steps were run. For the re-run, `brand-content-grid-math` (Table View scrape) and the Dev-vs-Prod helper library are the likely fits.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Cleanup

None (read-only Data Test set; nothing created).

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Precondition for the re-run: the account must be Amazon Prime Video (use the switch-account skill if needed).
- Native-post values (step 6) come from the Instagram post page and are subject to the login wall on prod.
