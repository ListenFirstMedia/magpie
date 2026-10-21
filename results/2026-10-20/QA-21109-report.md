# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

**Date:** 2026-10-20 (Tuesday)
**Mode:** unattended, headless (`claude -p`)
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Screening (spec-adherence Rule 7 + open-bug-auto-fail)

The case file's "Open linked bugs" section lists one open bug:

| Bug | Status | Title |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

**Interference judgment: INTERFERES.**
- The bug is a data-rendering defect that shows an en-dash in place of real values on YouTube datasets.
- The case's whole purpose is to read per-post metric values from the YouTube Only datasets ("Subscribers and Playlists" in step 4, "Cards" in step 7). It then compares them for day-over-day variation.
- A dash standing in for a real value makes both assertions (A5, A8) unreliable. The case's own note says to treat "–" as no data, so the bug would be indistinguishable from a legitimately empty metric, and a variation check can't be trusted. A PASS would be misleading.
- Rule 7 in `skills/_shared/spec-adherence-rules.md` requires auto-fail for any open linked bug. The refined open-bug-auto-fail policy (block only when the bug touches the assertions) also yields "blocked" here.

Secondary, independent blocker (not needed for the verdict): steps 5 and 8 compare against a baseline screenshot attached to the Jira ticket (Monday's grid-posts capture). It is not present in the local case file, and the Atlassian MCP is absent in this headless run. The comparison could not be done even if the bug were closed. Today is Tuesday, so the baseline would also have to come from this week's Monday capture.

## Steps executed

None. The browser flow was not opened, per the Rule 7 screen (no login, no navigation, no screenshots).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Metric values (Subscribers/Playlists dataset) show no big variation vs. the previous-day screenshot | Not executed — blocked by open bug APPS-60871 | BLOCKED |
| A8 | 8 | Metric values (Cards dataset) show no big variation vs. the previous-day screenshot | Not executed — blocked by open bug APPS-60871 | BLOCKED |

## Evidence

No screenshots were taken, so there is nothing under `.playwright-out/QA-21109/`. The decision rests on the case file `cases/QA-21109.md` ("Open linked bugs (as of 2026-10-20)").

## Known bugs checked

- **APPS-60871 (Open):** interferes, so the case is blocked. It was not reproduced, because the browser flow was skipped under the Rule 7 screen.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-21109 entries (pre-fetched shell-side).
- No matching skill was pre-resolved. The likely fit is `brand-content-grid-math` or `brand-content-table-view`, to use on re-run.

## Bugs filed

None. (Markdown-only policy; no new bugs observed.)

## Re-run guidance

- Re-runnable once APPS-60871 is closed and the case-file cache is refreshed.
- Before re-running, make sure the Monday baseline screenshot of the Amazon Prime Video YouTube grid is available, or capture one on a Monday per the case's notes.
- Use the `brand-content-grid-math` Table View scrape for the per-post metric reads.
