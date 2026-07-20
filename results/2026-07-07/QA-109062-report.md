# QA-109062 — Settings > Custom Data Sets support on Brand > Content - Export

- **Run date:** 2026-07-08 (interactive recovery run — was timeout/no-report BLOCKED in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109062 · Priority: Blocker
- **Verdict:** **BLOCKED** — the prerequisite Custom Data Set **"Custom Data Sets Test"** (created by QA-106218) is **not present** on the Adam Orfei account, so the case's data-set-specific assertions cannot be faithfully executed.
- **Account:** Adam Orfei (account_id=54) · **Brand:** MTV (4018) · **Skills:** switch-account, brand-content-data-set-selector, settings-custom-data-sets

## Open linked bugs
None open (cache 2026-07-03).

## Precondition not satisfied
Spec precondition: "Successfully completed QA-106218" — which must leave a Custom Data Set named **"Custom Data Sets Test"** (assertion A3 selects it by that exact name). On MTV → Brand Content → Data Set dropdown, the **Custom Data Set** category contains:
`Main Test 1, Test, Test 3 Dupes, Test Data 123, create-103, performance test, performance test 2, test1234` — **no "Custom Data Sets Test".**

So the required data set doesn't exist on this account right now (QA-106218 in the 2026-07-04 unattended run either created a differently-named set or its artifact isn't present). Per Rule 1 (never substitute), I did not pick one of the other custom data sets — A2 (specific metric list), A3, A6, A7 are all defined against the "Custom Data Sets Test" definition and can't be verified with a substitute.

## Assertions
| ID | Expected | Status |
|----|----------|--------|
| A1–A7 | (all depend on selecting the "Custom Data Sets Test" data set and its metric definition) | ⛔ Not evaluable — prerequisite data set absent |

## Evidence
- DS dropdown full option list captured (31 entries) — no "Custom Data Sets Test" (see `.playwright-out/QA-109062/` context / DOM dump in run log).

## What's needed to run
Re-create/confirm the **"Custom Data Sets Test"** custom data set on Adam Orfei (i.e. genuinely complete QA-106218 with that name), then re-run. The Brand-Content flow itself (dropdown, select, Export popup) is reachable — only the test data is missing.

## Bugs filed
None — this is a test-data/dependency gap, not a product defect.
