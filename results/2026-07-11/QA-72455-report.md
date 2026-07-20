# QA-72455 — Brand > Paid - Unauthorized Spend Metrics - Twitter Channel

- **Date:** 2026-07-11
- **Mode:** unattended / headless (`claude -p`, Playwright MCP track)
- **Component:** Brand Explorer (Brand > Paid)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-72455
- **Verdict:** **SKIPPED — external-user precondition, deferred**

## Verdict rationale

The case cannot be executed under this framework's identity constraints.

Preconditions (verbatim from `testcases/english/QA-72455.md`):
1. **User logged in as External account (Analyst No Spend role)** — Username: `testing@drylogics.com`
2. User logged into Hulu Account

The entire test is a permissions test: every assertion depends on the session
belonging to a user who does **not** hold spend authorization (the "Analyst No
Spend" role). That is a **different login identity** from the framework's
configured user (`yash.sharma@listenfirstmedia.com`, an internal full-access
account in `config/.env`).

Per the framework **SCOPE RULES → EXTERNAL-USER / SECOND-IDENTITY cases**:
> if the precondition needs a DIFFERENT user identity than `config/.env` (e.g.
> an External role, or a second account) — which account-switching CANNOT
> satisfy — mark the whole case SKIPPED ('external-user precondition, deferred').

Account/brand *switches of the same user* are in scope (the switch-account
skill), but this requires a **separate login** as a distinct External user with
a deliberately reduced role. Running the flow as the configured internal user
would exercise the wrong permission set — the "Go to Authorize" prompt, the lock
symbols, and the en-dash Spend cell (A1–A4) only appear for an unauthorized-spend
user — so any result produced under the wrong identity would be meaningless
(and would in fact populate the spend metrics, inverting every assertion).

No browser flow was opened; opening it would only burn budget on a run that
cannot satisfy the precondition.

## Steps

Not executed — precondition (login identity) unsatisfiable under headless
same-user constraints. See rationale above.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | 'Go to Authorize' displays in the Spend tile | Not evaluated — requires Analyst-No-Spend External login | SKIPPED |
| A2 | 5 | Spend, CPC, CPM, CPE metrics display lock symbol in the post table | Not evaluated — same precondition gap | SKIPPED |
| A3 | 5 | Aggregate table displays en-dash for the Spend metric | Not evaluated — same precondition gap | SKIPPED |
| A4 | 9 | Spend, CPC, CPM, CPE columns empty in the CSV file | Not evaluated — same precondition gap | SKIPPED |

## Known bugs checked

- **bug-history.md grep (`QA-72455`)** — hit at `knowledge-base/bug-history.md:1458`.
  Prior record already classifies this case as BLOCKED: *"Requires login as
  External account `testing@drylogics.com` (Analyst No Spend role). Cowork
  prohibits assistant password entry. Test needs to be routed to LFIQA manual
  verification or a future credentials-handoff pattern."* Consistent with this
  SKIPPED verdict (reclassified from BLOCKED → SKIPPED to match the current
  framework's external-user scope rule).
- **APPS-46074** (Test Failure, Major, **Closed**) — "Brand > Paid - Spend Big
  Number tile and Ads are displaying Go to Authorize". Related surface, but it is
  closed and describes the *expected* Go-to-Authorize behavior this test asserts
  (A1). No open defect interferes; irrelevant to the skip decision.
- Case file contains **no "## Open linked bugs" section** — nothing to screen
  under Rule 7.

## Bugs filed

None. (Verdict is a scope skip, not a product finding.)

## Notes

- Prior runs `runs/2026-06-02/QA-72455-report.md` and
  `runs/2026-06-13-qa4325/QA-72455-report.md` reached the same conclusion
  (BLOCKED/PARTIAL on the external-user identity + Paid-tile render artifact).
- This case can only be executed once a credentials-handoff pattern for a second
  login identity (External Analyst-No-Spend user) exists, or via LFIQA manual
  verification. No skill/REGISTRY maintenance performed (deferred to harvest.sh
  per run instructions).
