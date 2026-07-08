# QA-3630 — Reporting > Content Performance Report - BPC filmstrip - Authorized

- **Run date:** 2026-07-04
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-3630
- **Verdict:** **FAILED (blocked by open bug)**
- **Reason:** Open linked defect **LFMP-32010(Open)** — Rule 7 (open-bug auto-fail).

## Summary

Per the spec-adherence **Rule 7 (Open-bug auto-fail)**, the case file's
`## Open linked bugs` section (baked in from Jira at cache time, as of 2026-07-03) lists:

> **OPEN: LFMP-32010(Open)**

A case with an open linked defect cannot produce a trustworthy PASS. The case was therefore
**not executed** — no browser flow was opened, no steps were run. Pre-flight/login was skipped
because the case is blocked before any execution.

Re-runs will pick this case up automatically once **LFMP-32010** is closed and the cached case
file is refreshed.

## Steps executed

None. Case blocked prior to execution (open-bug screen).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 9 | Correct header (Michael Kors: CONTENT PERFORMANCE) | Not evaluated | BLOCKED |
| A2 | 9 | BPC tiles displayed from the top | Not evaluated | BLOCKED |
| A3 | 9 | Tile headers for Facebook, Twitter, Instagram, YouTube | Not evaluated | BLOCKED |
| A4 | 9 | 5 posts per row | Not evaluated | BLOCKED |
| A5 | 9 | Each post has a unique rank | Not evaluated | BLOCKED |
| A6 | 9 | Posts ordered descending by Engagements (most engaging) | Not evaluated | BLOCKED |
| A7 | 9 | Posts ordered ascending by Engagements (least engaging) | Not evaluated | BLOCKED |
| A8 | 9 | Post type displayed on each post | Not evaluated | BLOCKED |
| A9 | 9 | Post type always displayed and hyperlinked | Not evaluated | BLOCKED |
| A10 | 9 | Posts displayed within date range | Not evaluated | BLOCKED |
| A11 | 9 | Facebook posts: Engagements, Reactions, Comments, Shares, Impressions, Views | Not evaluated | BLOCKED |
| A12 | 9 | Twitter posts: Engagements, Likes, Replies, Retweets, Impressions, Video Views, Link Clicks | Not evaluated | BLOCKED |
| A13 | 9 | Instagram posts: Engagements, Likes, Comments, Impressions, Reach, Organic Saves, Views | Not evaluated | BLOCKED |
| A14 | 9 | YouTube posts: Interactions, Views, Engagements, Likes, Comments | Not evaluated | BLOCKED |

## Evidence

- Case file `testcases/english/QA-3630.md` → `## Open linked bugs (as of 2026-07-03)`:
  `**OPEN: LFMP-32010(Open)**`.
- No screenshots captured (case not executed).

## Bugs filed

None. This report does not create or modify any Jira ticket. The blocking defect
**LFMP-32010** is pre-existing and already open in Jira.
