# QA-29128 — Brand Content - Impressions - Data Test - (Twitter and Instagram)

- **Run date:** 2026-10-30 (Friday, HEADLESS Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-29128 · Test Set QA-26183 "Daily Data Testing -2"
- **Verdict:** **FAILED (blocked by open bug)** — not executed. Per spec-adherence Rule 7 and the user's 2026-10-22 directive, any case with an OPEN linked bug is FAILED until the bug closes.

## Linked bug scan — OPEN BUG
- **APPS-60871** (Open) — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube). Source: case file "Open linked bugs (as of 2026-10-20)". Jira was not re-queried (no Atlassian MCP in this headless run), so the status is the cached one.
- Auto-fail trigger. The bug targets the same surface and metrics as this case (Brand > Content > Impressions, Instagram/Twitter).

## Steps executed
None. The browser flow was not opened.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| 4 | 4 | Organic Impressions + Paid Impressions = Impressions (Instagram) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 5 | 5 | Organic Reach + Promoted Reach = Reach (Instagram) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 6 | 6 | Engagements / Impressions = Engagement Rate (Instagram) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 7 | 7 | Engagements / Reach = Engaged User Rate (Instagram) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 9 | 9 | Organic Impressions + Paid Impressions = Impressions (Twitter) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 10 | 10 | Organic Reach + Promoted Reach = Reach (Twitter) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 11a | 11 | Engagements / Impressions = Engagement Rate (Twitter) | Not executed | FAILED (blocked by open bug APPS-60871) |
| 11b | 11 | Engaged User Rate displays en-dash (Twitter) | Not executed | FAILED (blocked by open bug APPS-60871) |

## Evidence
No screenshots or DOM captures. Nothing was run.

## Known bugs checked
- Case-file "Open linked bugs" section: APPS-60871 (Open) → auto-fail.
- `knowledge-base/known-quirks.md` already records QA-29128 as an open-bug FAILED case (APPS-60871), confirmed by the user on 2026-10-22.
- `knowledge-base/bug-history.md`: no QA-29128 entry.

## Decision
Not run while APPS-60871 is open. Re-execute once the bug is closed and the case cache is refreshed. Today's (Friday) rotation row is Hulu / Ralph Lauren, per the case notes.

## Bugs filed
None. The pre-existing open bug APPS-60871 is the blocker. Nothing was filed in Jira.
