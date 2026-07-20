# QA-72455 — Brand > Paid - Unauthorized Spend Metrics - Twitter Channel (BLOCKED — account credentials)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-72455
- **Run date:** 2026-06-04 (QA-4325 batch 5 re-run)
- **Env:** Dev (`app.lfmdev.in`)
- **Result:** BLOCKED — precondition requires logging in as External account `testing@drylogics.com` (Analyst No Spend role) on Hulu Account; magpie automation cannot enter passwords on the user's behalf (Cowork prohibited-action rule). Active session is `yash.sharma@listenfirstmedia.com` on `Adam Orfei` account.

## Why BLOCKED

The spec's Preconditions explicitly require two account-level facts that test the role-based access control gating:

1. **External account login** — `testing@drylogics.com` with password `5stS6;7e&My*kt1"Ipdc` (spec provides the credential, but Cowork prohibits the assistant from entering passwords into forms — this is a hard safety rule, not a magpie limitation).
2. **Hulu Account context** — must be logged in to the Hulu account, not Adam Orfei.

The entire test verifies role-based UI degradation for the `Analyst (No Spend)` permission:
- Spend tile shows `Go to Authorize`
- Spend/CPC/CPM/CPE columns show lock symbol
- Aggregate row shows endash for Spend
- CSV export blanks Spend/CPC/CPM/CPE

If Yash were logged in instead, those role-specific signals would not appear — Yash has full permissions and would see populated Spend values. Running the test against the wrong user invalidates the assertion semantics entirely (it is structurally guaranteed to produce a false-FAIL or false-PASS depending on which side of the gate Yash falls on).

## Steps NOT performed

| Step | Reason for skip |
|---|---|
| 1-9 | Cannot reach Hulu+Twitter+Cost data set under the spec-required role without logging in as `testing@drylogics.com`. |

## Best-effort sanity probe (Adam Orfei session, brand_id=5670 URL param)

Navigated to `app.lfmdev.in/#explore/brand/paid?brand_id=5670&channels=twitter&from=2022-09-10&to=2022-09-18`. Page rendered the Brand>Paid shell with `MTV` as the active brand chip — the brand_id=5670 URL param did not switch the active brand off MTV's sticky session-state under Adam Orfei. Skeleton loader remained for the tile grid after 14+ seconds. No assertion-evaluable state reachable in the current account/role; this probe is non-diagnostic.

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | 'Go to Authorize' displays in the Spend tile | Not reachable under current account/role | NOT VERIFIED |
| A2 | 5 | Spend/CPC/CPM/CPE columns show lock symbol in post table | Not reachable | NOT VERIFIED |
| A3 | 5 | Aggregate table displays endash for Spend | Not reachable | NOT VERIFIED |
| A4 | 9 | Spend/CPC/CPM/CPE columns empty in CSV | Not reachable | NOT VERIFIED |

## Bugs filed

None — test is BLOCKED on account-credential precondition, not on a product defect.

## Skill registry impact

None. Future candidate: a `role-based-degradation-verifier` skill once the framework grows a manual-handoff pattern for external-user logins (LFIQA performs the login, then magpie picks up).

## Carry-forward note

QA-4325 batch-5 surfaces a second class of "credentials-blocked" tests (after QA-33510 in QA-4325 batch-11 which required Settings>Users access for a second user). Recommend grouping these into a separate `tests/credentials-blocked.md` index and routing them to LFIQA manual verification.
