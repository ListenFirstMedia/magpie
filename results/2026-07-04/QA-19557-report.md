# QA-19557 — Brand Content - Impressions Data Set - Instagram Stories

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19557
- **Priority:** Blocker (P1)

## Verdict: FAILED (blocked by open bug)

Not executed. Per spec-adherence **Rule 7 (open-bug auto-fail)**, a test case with any OPEN
linked bug cannot produce a trustworthy PASS, so the case is marked FAILED (blocked) **without
running** and the browser flow was never opened. Pre-flight/login was intentionally skipped.

## Blocking bugs (from case file "## Open linked bugs", as of 2026-07-03)

| Bug key | Status |
|---------|--------|
| APPS-58817 | Open |
| LFMP-32016 | Open |

## Steps executed

None. Screening halted execution before any browser interaction.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Step 5 | Impressions metric shows data for all Story Publish Type posts | Not evaluated | BLOCKED |
| A2 | Step 6 | LinkedIn posts are showing Impressions data | Not evaluated | BLOCKED |

## Evidence

- Case file `testcases/english/QA-19557.md` "## Open linked bugs" section lists
  `APPS-58817(Open),LFMP-32016(Open)` with the baked-in directive to mark FAILED (blocked)
  without running until these close.
- No screenshots/snapshots captured (browser flow not opened by design).

## Bugs filed

None. (This run files no defect — the case is blocked by pre-existing open bugs APPS-58817 and
LFMP-32016. Markdown-only note; no Jira ticket created.)

## Re-run guidance

Re-runs pick this case up automatically once APPS-58817 and LFMP-32016 are closed and the
`testcases/english/QA-19557.md` cache is refreshed from Jira.
