# QA-113595 — Settings > Audit and Admin page changes

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-113595
- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-12 (Sunday), unattended headless (Playwright MCP)
- **Priority:** Minor
- **Account:** Adam Orfei (account_id=54)
- **Skill:** `settings-audit-logs`

## Verdict: SKIPPED (precondition not met — Thursday-only)

## Reason
The case's Preconditions explicitly state:
- **"This test case should only be executed on Thursday."**
- "Successful completion of QA-56761."
- "Only execute on Dev."

Today is **Sunday, 2026-07-12** (verified via `date "+%Y-%m-%d %A"`), so the **Thursday-only
precondition is not satisfied** → SKIPPED per test-case-first discipline (do not run when a
documented precondition isn't met). The browser flow was not opened.

## Secondary barrier (independent of the day)
Even on a valid day, Steps 1–7 require the separate **Admin** app:
- Key icon → **Admin** navigates to `admin.lfmdev.in` via its own OAuth client
  (`auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=…admin.lfmdev.in%2Foauth%2Fcognito_callback`).
- This is a **second auth surface** (separate Cognito sign-in), which an unattended headless run
  cannot satisfy — matches the 2026-06-04 QA-4325 batch-9 outcome (BLOCKED on Admin Cognito sign-in)
  and the 2026-07-09 SKIPPED report. Falls under the SCOPE RULE for second-identity / separate-auth
  preconditions.
- Steps 5–6 ("Edit the name", "Update Movie") are also an **Admin-interface mutation** on shared
  test data (the brand from QA-56761) with its own login/logout cycle.

## Known bugs checked
- `knowledge-base/bug-history.md` (grep QA-113595): no open linked bug. Prior batch-9 finding on
  record is the Admin/Cognito sign-in block (environment/auth, not a product defect).
- Case file has no "## Open linked bugs" section; Jira issue-links not re-checkable in this headless
  run (Atlassian MCP absent per task). No open defect known → open-bug screen passes; the block here
  is the precondition + auth surface, not a bug.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A6  | 6 | Brand is updated via Admin ("Update Movie") | Not executed — Thursday-only precondition unmet; Admin app requires separate Cognito sign-in | SKIPPED |
| A8a | 8 | Audit Actor column displays your name | Not executed | SKIPPED |
| A8b | 8 | Audit Activity Type = 'Brand Edited' | Not executed | SKIPPED |
| A8c | 8 | Audit Description = 'Brand #{brand name} metadata was edited.' | Not executed | SKIPPED |

## Note
The Audit log's "Brand Edited / metadata was edited" row type is confirmed present on this platform
(QA-107134 / QA-110083, see `settings-audit-logs` skill v2). Re-run this case **on a Thursday** with
Admin (`admin.lfmdev.in`) access to complete the Admin edit and verify A6/A8a–c.

## Bugs filed
None.
