# QA-131492 — Social Recap Vs Brand > Content - YouTube Video Views — Run Report

- **Date:** 2026-05-27
- **Account:** Adam Orfei (id=54)
- **Brand:** MTV (id=4018), View = Public Data
- **Date range:** Jan 1, 2026 – Jan 7, 2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-131492.md

## Result: PASS

## Execution

1. Logged in app.lfmdev.in, switched account → Adam Orfei.
2. Navigated Reporting → Social Recap, added MTV (Public), date range Jan 1–7, 2026, ran report → story 153794.
3. Scrolled to Best Performing Content. Card 4 captured: **@mtv YouTube, Mon Jan 05 2026 06:00 AM PST, Video/Original Post, "Lights, Camera, Debate w/ Tom Blyth & Emily Bader" — Engagements 2,116; Reactions 2,036; Comments 80; Video Views 67,115**.
4. Navigated Brand → Content for MTV with date range Jan 1–7, 2026, channel filter = YouTube only, Data Set = Public.
5. Posts (1) loaded with single YouTube post: Rank 1, Mon Jan 05, 2026 06:00 AM PST. Sum/Average row: Engagements 2,116; Reactions 2,036; Comments 80; **Video Views 67,115**.

## Assertions

- **A1 (Report loads successfully):** PASS — Social Recap story 153794 generated, Brand > Content loaded with 1 YouTube post.
- **A2 (YouTube Video Views in Social Recap BPC matches Brand → Content first post):** PASS — Social Recap **67,115** == Brand > Content first post **67,115**.

## Evidence

- Social Recap BPC Card 4 (YouTube): Engagements 2,116, Reactions 2,036, Comments 80, Video Views 67,115.
- Brand > Content single YouTube post (Jan 5 06:00 AM PST): Sum/Average Video Views 67,115.
- Same post identity (title "Lights, Camera, Debate w/ Tom Blyth & Emily Bader" + timestamp).

## Notes

- Same Social Recap story 153794 satisfied [[QA-131491]] and this ticket — single run captured both Card 3 (IG) and Card 4 (YouTube).
- For Brand > Content with single-channel filter and only one matching post, the Sum and Average rows are equal to the single post's value — no need to scroll table rows.
