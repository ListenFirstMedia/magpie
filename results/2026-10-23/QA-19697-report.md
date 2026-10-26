# QA-19697 — Brand Content - Engagements Breakdowns - Data Test

**Run date:** 2026-10-23 (Friday) — unattended / headless
**Verdict: FAILED (blocked by open bug)** — APPS-58817

## Open-bug screen (spec-adherence Rule 7)
- Case file `## Open linked bugs` lists **APPS-58817** (Bug, Open) — "Brand Content - Posts deleted from Native are still visible in LF app".
- Refreshed snapshot `results/open-bugs-2026-10-23.json` confirms it is still `[Open]` on 2026-10-23.
- Per Rule 7 and the open-bug auto-fail policy (2026-10-22 directive): any open linked bug fails the case and it is attributed to that bug. No interference judgement was made.

## Steps executed
None. The browser flow was not opened; no login, brand selection or grid scrape was performed.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 (Twitter) | Organic Eng + Paid Eng = Engagements | Not executed (open bug) | NOT RUN |
| A6 | 6 (Twitter) | Org Reactions + Comments + Shares = Organic Eng | Not executed (open bug) | NOT RUN |
| A7 | 7 (Twitter) | Paid Reactions + Comments + Shares = Paid Eng | Not executed (open bug) | NOT RUN |
| A9 | 9 (Instagram) | Organic Eng + Paid Eng = Engagements | Not executed (open bug) | NOT RUN |
| A10 | 10 (Instagram) | Org Reactions + Comments + Shares = Organic Eng | Not executed (open bug) | NOT RUN |
| A11 | 11 (Instagram) | Paid Reactions + Comments + Shares = Paid Eng | Not executed (open bug) | NOT RUN |

## Evidence
- `results/open-bugs-2026-10-23.json` entry for QA-19697: `APPS-58817 [Open] Brand Content - Posts deleted from Native are still visible in LF app`.
- No screenshots (browser not opened).

## Known bugs checked
- APPS-58817 (Open): posts deleted from the native platform remain visible in the LF app. This plausibly skews per-post Engagements breakdown sums. Not reproduced in this run, because the open-bug policy fails the case before execution.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-19697 entries (pre-fetched grep).
- No matching skill in REGISTRY pre-resolved. The case notes point to the `brand-content-grid-math` pattern for when this is re-run.

## Bugs filed
None. No new bugs found; the failure is attributed to existing APPS-58817.

## Re-run
Re-run once APPS-58817 is closed and the case's open-bug cache is refreshed. Friday's rotation is Hulu account, Hulu / Ralph Lauren brands.
