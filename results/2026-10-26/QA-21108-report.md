# QA-21108 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 2

**Run date:** 2026-10-26 (unattended, headless)
**Test Set:** QA-26183 "Daily Data Testing -2"
**Verdict: FAILED (blocked by open bug)**

## Screening (spec-adherence Rule 7 — open-bug auto-fail)

The case file's "## Open linked bugs" section lists an OPEN defect:

| Bug | Status | Summary |
|---|---|---|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) |

The case compares per-post metric values across the Twitter, Instagram (Insights / Reels / ActionTypes)
and YouTube (Insights / Premium) datasets day over day. APPS-60871 is an open defect for Endash (–)
rendering of metrics in exactly those datasets, so the values noted in steps 4/7/10/13/16/19 cannot be
trusted. Per Rule 7 and the 2026-10-22 open-bug auto-fail directive, the case was NOT executed and no
browser session was opened. No interference judgement is made.

## Steps executed

None. Not run, per Rule 7.

1. Hover over Brand and select Content from the Top Nav: not executed
2. Add "Amazon Prime Video" Brand: not executed
3. Twitter only: Engagements & Follows dataset: not executed
4–5. Note values / compare with attached screenshot: not executed
6–8. Instagram Only: Insights: not executed
9–11. Reels dataset: not executed
12–14. Instagram Only: ActionTypes: not executed
15–17. YouTube Only: Insights dataset: not executed
18–20. YouTube Only: Premium dataset: not executed

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Twitter Engagements & Follows values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |
| A8 | 8 | Instagram Insights values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |
| A11 | 11 | Reels values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |
| A14 | 14 | Instagram ActionTypes values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |
| A17 | 17 | YouTube Insights values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |
| A20 | 20 | YouTube Premium values show no big day-over-day variation | Not evaluated (open bug APPS-60871 on case) | FAILED (blocked by open bug) |

## Evidence

No screenshots or snapshots (browser not opened). The open-bug list was baked into cases/QA-21108.md
on 2026-10-20 and not refreshed from Jira (the Atlassian MCP is absent in headless runs). If APPS-60871
has since closed, refresh the case cache and re-run.

## Known bugs checked

- APPS-60871 (Open) — Endash rendering across Twitter/Instagram/YouTube datasets. Attributed as the
  blocker for all six assertions. knowledge-base/bug-history.md has no entry for QA-21108.
- known-quirks.md records QA-21108/21109 as open-bug auto-fail cases (policy confirmed 2026-10-22).

## Bugs filed

None (markdown-only; no new bugs found — the case was not executed).
