# QA-24281 — Brand Content - Channel Specific Data Sets - Aggregate Data Test

**Run date:** 2026-10-23 (Friday) — unattended / headless
**Verdict: FAILED (blocked by open bug)**

## Screening (spec-adherence Rule 7 — open-bug auto-fail)

The case file's "Open linked bugs" section (baked in 2026-10-19) lists one OPEN bug. Today's refreshed snapshot
(`results/open-bugs-2026-10-23.json`) confirms it is still open:

| Bug | Status | Summary |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across … |

Per Rule 7 and the open-bug auto-fail directive, the case was **not executed**. The browser flow was not opened, no
login was performed, and no screenshots were captured (`.playwright-out/QA-24281/` is not created).

## Steps executed

None (15 steps in spec, 0 run). Blocked by APPS-60871.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A3 | 3 | Sum of Likes/Loves/Hahas/Wows/Sads/Angries/Others equals Reactions | Not executed | NOT RUN (blocked by APPS-60871) |
| A5 | 5 | Organic + Paid Completed Views sum equals Completed Views | Not executed | NOT RUN (blocked by APPS-60871) |
| A7 | 7 | Paid + Organic User Follows sum equals User Follows | Not executed | NOT RUN (blocked by APPS-60871) |
| A9 | 9 | Organic + Paid Saves sum equals Saves | Not executed | NOT RUN (blocked by APPS-60871) |
| A11 | 11 | Organic + Paid + Unclassified Views sum equals Video Views | Not executed | NOT RUN (blocked by APPS-60871) |
| A12 | 12 | Organic + Paid Watch Time (Min) sum equals YouTube Watch Time (Min) | Not executed | NOT RUN (blocked by APPS-60871) |
| A14 | 14 | Organic + Paid Premium Views sum equals Premium Views | Not executed | NOT RUN (blocked by APPS-60871) |
| A15 | 15 | Organic + Paid Premium Watch Time (Min) sum equals Premium Watch Time (Min) | Not executed | NOT RUN (blocked by APPS-60871) |

## Evidence

- Case file `cases/QA-24281.md`, section "Open linked bugs (as of 2026-10-19)": APPS-60871 (Bug, Open).
- `results/open-bugs-2026-10-23.json`, key `QA-24281`: `APPS-60871 [Open] Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across …`.
- The bug's title (en-dash shown in place of metric values) targets exactly the aggregate-sum assertions this case makes, so a PASS or FAIL here would not be trustworthy while it is open.

## Known bugs checked

- Linked bug: APPS-60871 (Open) — attributed as the cause of this verdict.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-24281 matches (pre-fetched shell-side).
- No further related-bug search was made, because the run stops at the Rule 7 screen.

## Bugs filed

None. No new bugs were found, because the case was not run. No Jira tickets were created.

## Next action

Re-run automatically once APPS-60871 closes and the case cache is refreshed. Weekday rotation for today (Friday) would be Hulu / Hulu, Ralph Lauren.
