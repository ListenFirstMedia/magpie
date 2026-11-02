# QA-29111 — Brand Content > Basic Data Set > Past date range data test - (Twitter and Instagram)

**Run date:** 2026-10-29 (unattended, headless)
**Verdict: FAILED (blocked by open bug)**

## Verdict rationale

Per spec-adherence Rule 7 (open-bug auto-fail) and the user-confirmed policy of 2026-10-22 ("any open linked bug = FAILED, in the report and in the Xray execution"), the case file's "Open linked bugs" section lists an OPEN bug, so the case was **not executed**. The browser was never opened.

- **APPS-61116** (Open): Brand > Content - Twitter channel - Sum of Reactions + Comments + Shares does not equal Engagements value

This bug describes exactly what assertion 5 checks (Twitter: Reactions + Comments + Shares = Engagements). The same-family "total value with no organic/paid split" pattern is already recorded in `knowledge-base/known-quirks.md` against QA-29111 (Twitter, ±1). Assertion 7 (Instagram) is part of the same case, which can't produce a trustworthy PASS while the linked defect is open.

## Steps executed

None (screened out before execution).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Twitter only: Reactions + Comments + Shares = Engagements in each grid post | Not executed — open bug APPS-61116 | FAILED (blocked by open bug) |
| A7 | 7 | Instagram only: Reactions + Comments + Shares = Engagements in each grid post | Not executed — open bug APPS-61116 (case-level auto-fail) | FAILED (blocked by open bug) |

## Evidence

No screenshots (browser not opened). Source of the open-bug status: `cases/QA-29111.md` section "Open linked bugs (as of 2026-10-20)".

## Known bugs checked

- Case file "Open linked bugs": APPS-61116 (Open) → triggers auto-fail.
- `knowledge-base/bug-history.md`: no entries for QA-29111 (pre-fetched).
- `knowledge-base/known-quirks.md`: records the Twitter ±1 Engagements-vs-sum family (APPS-61116 / QA-29111) from earlier runs.
- Jira was not re-queried (Atlassian MCP absent in headless run); bug status is as of the 2026-10-20 cache. Re-runs pick the case up automatically once the bug closes and the cache is refreshed.

## Bugs filed

None. (No new bugs; the failure is attributed to existing APPS-61116.)
