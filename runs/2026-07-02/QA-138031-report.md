# QA-138031 — Data Collection - Channel Collection Status Validation 1

- **Run date:** 2026-07-03 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-138031 · Priority: Major
- **Result:** **FAILED (blocked by open bug)** — not executed. Per the open-linked-bug auto-fail rule ([[open-bug-auto-fail]]), a case with any OPEN linked bug is marked failed until the bug is closed.
- **App:** `app.lfmdev.in` (Settings > Data Collection)

## Linked bug scan — OPEN BUG FOUND
- **APPS-61562** — "Settings > Data Collection : Last Collection Date is showing Incorrect." · Bug · Priority Major · **Status: "QA Ready" (statusCategory = In Progress / indeterminate — NOT done → OPEN).** Link type: Relates.
  - **Directly interferes with assertion 5b** ("'Last Collection Date' column displays the current date or the day before if Status is 'Collecting'"). The open bug is precisely that the Last Collection Date renders incorrectly, so 5b cannot be trusted to pass.

No other linked issues.

## Decision
Auto-FAIL (blocked). The case is not run while APPS-61562 is open. This follows the standing rule: any open linked bug → mark FAILED without executing, re-run once the bug is Closed. (The test case itself is also still in **Draft** status, not fully Defined.)

## Assertions (not executed)
| ID | Expected | Status |
|----|----------|--------|
| 3 | Selected channel filter applied; only that channel's feeds shown | ⛔ Not run (blocked) |
| 4 | 'Data Collection Summary' page opens | ⛔ Not run (blocked) |
| 5a | 'Collecting' → green check icon | ⛔ Not run (blocked) |
| 5b | 'Last Collection Date' = current/previous day when Collecting | ⛔ **Blocked by APPS-61562 (open)** |
| 5c | Collecting → data visible on Brand Content matching native latest date | ⛔ Not run (blocked) |
| 5d | 'Not Collecting' → red exclamation icon | ⛔ Not run (blocked) |
| 5e | 'To Do' → blue plus icon | ⛔ Not run (blocked) |

## Bugs filed
None (pre-existing open bug APPS-61562 is the blocker).

## Re-run condition
Re-execute when APPS-61562 is Closed.
