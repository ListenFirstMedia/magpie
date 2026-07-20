# QA-131492 — Social Recap Vs Brand > Content - YouTube Video Views (Batch 9 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-131492
- **Run date:** 2026-06-02 (batch 9 re-run)
- **Account:** Adam Orfei
- **Brand:** MTV (Public Data, brand_id=10765)
- **Date range:** Jan 1, 2026 – Jan 7, 2026
- **Priority:** Major (P3)
- **Result:** PASS 2/2 — YouTube Video Views parity verified: Social Recap BPC YouTube card = Brand > Content YouTube Post #1.

## Pre-test setup
- Reused Social Recap story 153956 from QA-131491 (same brand + same window).
- Brand>Content for YouTube channel filter via URL (`channels=youtube`).

## Steps executed

| Step | Action | State |
|---|---|---|
| 1-5 | Reuse Social Recap story 153956 (MTV, Jan 1-7 2026) | OK |
| 5 | Locate YouTube card in BPC | Card 4 of 5 carries YouTube icon (red play) |
| 6 | Navigate Brand → Content (MTV) with YouTube channel filter | Posts (1) returned for the window |
| 9 | Review first YouTube post | top row captured |

## Evidence

### Social Recap BPC Card 4 (YouTube) — story 153956
- `@mtv` · Mon Jan 05 2026 06:00 AM PST · Video
- Text: "Lights, Camera, Debate w/ Tom Blyth & Emily Bader"
- Engagements: 2,122 · Reactions: 2,042 · Comments: 80 · **Video Views: 67,332**

### Brand > Content Post #1 (MTV, YouTube-only, Jan 1–7 2026, Public)
- Channel icon: YouTube (red) · Post type: Video · Brand label: MTV
- Date: Mon Jan 05 2026 06:00 AM PST
- Text: "Lights, Camera, Debate w/ Tom Blyth & Emily Bader"
- Engagements: 2,122 · Reactions: 2,042 · Comments: 80 · Response Rate 0.02% · **Video Views: 67,332** · Video Response 3.15%
- Posts (1) — sole YouTube post for the window; also the Sum/Average row equals the post row exactly.

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Report loads successfully | Story 153956 generated cleanly; BPC populated with 5 cards including YouTube card. | PASS |
| A2 | YouTube Video Views value in Social Recap BPC matches Brand → Content first post | Social Recap **67,332** == Brand > Content Post #1 **67,332** (verbatim match on the same Video post "Lights, Camera, Debate w/ Tom Blyth & Emily Bader"). | PASS |

## Bugs filed
None.

## Skill registry impact
- `social-recap-report-run` — pass_streak +1 (shared story 153956 with QA-131491; YouTube channel card capture).
- `brand-content-data-set-selector` — pass_streak +1 (Public data set + YouTube-only channel filter via URL, single-post window).

## Sources
- [QA-131492 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-131492)
- Sibling test QA-131491 (Instagram variant — same story 153956)
