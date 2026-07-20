# QA-4325 Pre-Sweep Prep Log (2026-06-02)

## Method used to discover members

- Attempted `getJiraIssue("QA-4325", fields=["*all"])` first — the Xray Test Set issue's `issuelinks` only contained a single related QA Task (APPS-60035 Daily Regression Set), not the member test cases. No custom field surfaced the member-test array directly.
- Tried JQL `project = QA AND issuetype = Test AND "Test Sets" = QA-4325` — returned 0 (Test Sets field name not recognized).
- Tried JQL `project = QA AND issuetype = Test AND issue in linkedIssues("QA-4325")` — returned 0.
- Tried JQL `"Test Set" = QA-4325` — returned 0.
- **SUCCEEDED with Xray JQL function:** `issue in testSetTests("QA-4325") ORDER BY key ASC` — returned totalCount=56.

## Discovered count

- 56 member test cases. Matches the expected ~56 ticket sweep size exactly.
- List saved to `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-4325-members.md`.

## Open-bug discovery method

- Per-test JQL: `issuetype in (Bug, "Test Failure") AND statusCategory != Done AND issue in linkedIssues("QA-<id>")` (one call per test, max 56 calls).
- `linkedIssues()` only accepts a single key argument; no batching by key list.

## Count of members with open Bug/Test-Failure

- 12 of 56 members have >=1 open Bug/Test-Failure link.
- 14 total open links (3 share APPS-58574 — LinkedIn cards misalignment).

## Top open bugs (by priority)

- High: APPS-57985 (QA Ready) — LinkedIn Posts Thumbnail Issue [QA-13903]
- Major: LFMP-31947 (Open) — Brand content Sentiment Read Comments not displaying for IG channel [QA-111242]
- Major: DATA-12209 (Open) — Brand > Content Daily Post Analysis Modal TikTok endash 2026-05-16 [QA-103246]
- Major: LFMP-31814 (Open) — Reporting > Data Studio Data fetching pop-up not displayed [QA-92841]
- Minor (4): APPS-50810, APPS-54603, APPS-55559, APPS-55875, APPS-59449, LFMP-31936
- Trivial (1): APPS-58574 (In Progress) — LinkedIn Audience cards misaligned [QA-92735, QA-94977, QA-95067]

## Time / API call accounting

- Time spent: ~1 session (single agent run).
- API calls used:
  - 1 getJiraIssue for QA-4325 (full fields) — confirmed Test Set type but member field not exposed.
  - 12 JQL searches to page through 56 members (5 per page; final page returned 6).
  - 1 getJiraIssue per test for QA-298 and QA-461 (full issuelinks payload to inspect closed-bug shape) before switching strategy.
  - 56 JQL searches (one per member test) for open Bug/Test-Failure links.
  - 2 JQL searches for closed Bug/Test-Failure on QA-298 and QA-461 to surface most recent items.
  - Total ~72 paid API calls (within 60-80 expected budget).

## Tests fully fetched vs. summarized

- QA-298 and QA-461: full closed-bug list captured (10 most recent each).
- All 56 tests: open bugs fully captured (12 with opens, 44 with no opens).
- Closed bugs for the 54 remaining members: NOT enumerated due to response-size budget (each getJiraIssue response was ~10K tokens). Closed bug presence noted in KB with a pointer to Jira for detail.

## Files written

- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-4325-members.md` (numbered list, 56 entries)
- `/Users/yashsharma/git/magpie/knowledge-base/bug-history.md` (new major section appended: `# QA-4325 Daily Regression Test Set - 2 (2026-06-02)`)
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-4325-PREP-LOG.md` (this file)

## Anomalies / caveats

- Closed-bug detail for 54 tests is summarized only; full enumeration would have required ~54 additional large fetches.
- `issue in linkedIssues()` rejects multi-key arguments. Batching would require Xray-specific JQL extensions.
- Some "Open" bugs include `In Progress` and `QA Ready` status as part of statusCategory != Done; these are real pre-test risks.

## Readiness for batch 1 execution

- Member list confirmed.
- Open-bug exposure known per test.
- Highest-risk tests flagged (12 with open bugs).
- Ready to proceed with batch 1 execution once batches are defined.
