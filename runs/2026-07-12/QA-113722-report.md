# QA-113722 — Admin - User Creation and Settings > Audit screen

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-113722
- **Run date:** 2026-07-12 (Sunday)
- **Environment:** app.lfmdev.in (Dev) — Playwright MCP track, headless/unattended
- **Skill:** `settings-audit-logs` (not exercised — case gated at precondition)
- **Verdict:** **SKIPPED — precondition not satisfiable this run (day-of-week gate: "Only execute on Thursday")**

## Precondition screen (before opening the browser)

| Precondition | Required | This run | Met? |
|---|---|---|---|
| User logged in as Drylogics | Drylogics account | account switch available | — (not reached) |
| Environment | Dev only | app.lfmdev.in = Dev | ✅ |
| Day of week | **Thursday only** | **Sunday, 2026-07-12** (`date` confirmed) | ❌ |

The spec restricts execution to Thursdays. Today is Sunday (`date "+%Y-%m-%d %A"` → `2026-07-12 Sunday`). Per Rule 3 (execute every step only when all preconditions are met), an unmet gating precondition means the case cannot be validly executed today. No steps were run; no browser was opened; **no user was created** (mutating flow not entered → no cleanup required).

## Secondary blocker (independent of the day gate)

Even on a Thursday, this case cannot complete unattended on this track:

- **Step 8** ("Log in to app.lfmdev.in as 'Drylogics'") requires signing in as the **newly created user** through AWS Cognito with a **real password**.
- The case Notes explicitly forbid this: *"Don't enter a real password; use placeholder; if real sign-in required → PARTIAL."*
- Bug-history for QA-113722 records the same outcome on the prior attempt: `2026-06-04 QA-4325 batch-9 BLOCKED on Cognito sign-in + real-password rule`.

So the assertions that depend on being logged in as the new Drylogics user (A9a–A9d, read on Settings > Audit) are unreachable in an unattended headless run regardless of the day.

## Steps executed

None. Case gated at the precondition screen (day-of-week) before any browser interaction.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 7 | Brand/user is updated/created | not executed (Thursday-only precondition unmet) | SKIPPED |
| A9a | 9 | Account column displays 'Drylogics' | not executed (precondition unmet; also needs real-password sign-in) | SKIPPED |
| A9b | 9 | Actor column displays your name | not executed | SKIPPED |
| A9c | 9 | Activity Type column displays 'User Created' | not executed | SKIPPED |
| A9d | 9 | Description displays 'User #{user name} was created.' | not executed | SKIPPED |

## Evidence

- `date "+%Y-%m-%d %A"` → `2026-07-12 Sunday` (day-of-week gate fails).
- No screenshots — browser not opened (case gated pre-flight).

## Known bugs checked

- **Jira open linked bugs:** case file has no "## Open linked bugs" section; `knowledge-base/bug-history.md` QA-113722 → **Open bugs (0), _None._** Rule 7 screen: passed (no open blocker).
- **bug-history note:** prior run 2026-06-04 BLOCKED on Cognito sign-in + real-password rule (see Secondary blocker above). No product bug reproduces — this is an environment/scope constraint, not a defect.

## Bugs filed

None. This is a precondition/scope gate, not a product defect.

## Recommendation

Re-run on a **Thursday** with a human who can perform the real-password Cognito sign-in as the newly created Drylogics user (or provision the new user's credentials), then verify A9a–A9d on Settings > Audit and deactivate/clean up the created user. Not executable unattended on this track.
