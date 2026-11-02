# QA-29111 — Brand Content > Basic Data Set > Past date range data test - (Twitter and Instagram)

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in
**Verdict: FAILED (blocked by open bug)** — APPS-61116

## Open-bug screen (Rule 7)
- The case file `cases/QA-29111.md` ("Open linked bugs (as of 2026-10-20)") lists **APPS-61116 (Open)**: *Brand > Content - Twitter channel - Sum of Reactions + Comments + Shares does not equal Engagements value*.
- The shell-side refresh `results/open-bugs-2026-10-26.json` confirms the bug is still open as of 2026-10-26: `QA-29111 -> APPS-61116 [Open]`.
- The bug describes exactly what assertion 5 checks (Twitter, Reactions + Comments + Shares = Engagements). It would be expected to reproduce on the Twitter half of this case, so a PASS would not be trustworthy.
- Per spec-adherence Rule 7, the case was **not executed**. The browser was never opened and no login was performed.

## Steps executed
None (blocked by the Rule 7 screen). Steps 1-7 in the spec were not attempted.
Today's weekday-rotation row (Monday: HBO Max, Amazon Prime Video, Conde Nast / brands HBO Max, Amazon Prime Video, Vogue-US) is unchanged for the re-run.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Twitter only, 2024-04-19 to 2024-04-25: per post, Reactions + Comments + Shares = Engagements | Not executed: open bug APPS-61116 | FAILED (blocked by open bug) |
| A7 | 7 | Instagram only, same range: per post, Reactions + Comments + Shares = Engagements | Not executed: open bug APPS-61116 | FAILED (blocked by open bug) |

A7 is on Instagram, which APPS-61116 does not name. It is failed here because the case is screened as a whole under Rule 7, not because Instagram is known to be wrong.

## Evidence
No screenshots (the browser was not opened). Sources: `cases/QA-29111.md` and `results/open-bugs-2026-10-26.json`.

## Known bugs checked
- **APPS-61116** (Open): attributed as the blocker. It is not a new finding. `knowledge-base/bug-history.md` has no QA-29111 entry.
- `knowledge-base/known-quirks.md` records the same "total value with no organic/paid split" family (QA-20321, QA-20324, QA-24277), where Twitter is off by about 1 (a comment counted in Engagements with the splits shown as "–"). It is noted there as the same family as APPS-61116. This is context only and was not re-verified in this run.
- No skill was pre-resolved for this case. `cases/QA-29111.md` points to `brand-content-grid-math` for the per-post math.

## Bugs filed
None. This is a markdown-only report and no Jira tickets were created.

## Re-run note
- Re-running will pick up the case automatically once APPS-61116 is closed and the case cache is refreshed.
