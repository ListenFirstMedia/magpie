# QA-96665 — Brand Insights - Threads - Basic View

- **Run date:** 2026-07-04
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96665
- **Priority:** Blocker (P1)
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open linked bug on the case — screened out before execution per Rule 7 (open-bug auto-fail).

## Screening result

The case file's **"## Open linked bugs (as of 2026-07-03)"** section lists:

- **LFMP-32027 (Open)**

Per spec-adherence Rule 7 and the open-bug auto-fail discipline: a case with any OPEN linked
defect cannot produce a trustworthy PASS. The case was **NOT run** — no browser flow was opened,
no pre-flight login performed. Re-runs will pick this case up automatically once LFMP-32027 is
closed and the cache is refreshed.

## Steps executed

None. Case blocked at the pre-execution open-bug screen.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Threads icon in single-channel selector, next to LinkedIn with separator | Not evaluated (blocked) | BLOCKED |
| A2 | 3 | Row 1 tiles: Total Followers, Follower Growth, Fan Growth Rate | Not evaluated (blocked) | BLOCKED |
| A3 | 3 | Row 2 tiles: New Posts, Engagements | Not evaluated (blocked) | BLOCKED |
| A4 | 3 | Row 3 tiles: Engagement Rate, Views | Not evaluated (blocked) | BLOCKED |
| A5 | 3 | Row 4: BPC tile displayed | Not evaluated (blocked) | BLOCKED |
| A6 | 3 | BPC posts/sort dropdown metrics: Engagements, Likes, Replies, Reposts, Quotes, Shares, Views | Not evaluated (blocked) | BLOCKED |
| A7 | 3 | BPC contains five posts | Not evaluated (blocked) | BLOCKED |
| A8 | 3 | BPC sorted by Engagements by default | Not evaluated (blocked) | BLOCKED |
| A9 | 4 | Threads channel not available under Public perspective | Not evaluated (blocked) | BLOCKED |

## Evidence

- Case file `testcases/english/QA-96665.md` open-linked-bugs section cites **LFMP-32027 (Open)** as of 2026-07-03.
- No screenshots/snapshots captured (case not executed).

## Bugs filed

None. (LFMP-32027 already exists and is the blocking defect; no new bug created. Report is markdown-only — no Jira tickets created.)
