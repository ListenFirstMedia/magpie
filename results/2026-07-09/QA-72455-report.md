# QA-72455 — Brand > Paid - Unauthorized Spend Metrics - Twitter Channel

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)

## Verdict: SKIPPED

## Reason — external-user / second-identity precondition
Precondition requires being **logged in as an External account with the "Analyst No Spend" role** (`testing@drylogics.com`). Every assertion depends on that no-spend role:
- A1: "Go to Authorize" in the Spend tile
- A2: Spend / CPC / CPM / CPE show lock symbols in the post table
- A3: Aggregate table shows en-dash for Spend
- A4: those metric columns empty in the CSV

These *unauthorized-spend* states are a property of the **user's role**, not the account. The harness authenticates as `lfiqa@listenfirstmedia.com` (a QA super-user, spend-authorized); switching the *account* to Hulu does not change the *user identity/role*, so the no-spend/unauthorized view cannot be reproduced. Per the external-user/second-identity scope rule, this case is SKIPPED (needs a distinct login the harness can't provide).

## No open bugs
Compact open-bug screen for QA-72455 → empty.

## Bugs filed
None.
