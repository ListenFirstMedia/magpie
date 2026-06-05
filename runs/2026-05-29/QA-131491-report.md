# QA-131491 — Social Recap Vs Brand > Content - IG Public Video View (Batch 9 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-131491
- **Run date:** 2026-06-02 (batch 9 re-run)
- **Account:** Adam Orfei
- **Brand:** MTV (Public Data)
- **Date range:** Jan 1, 2026 – Jan 7, 2026
- **Priority:** Major (P3)
- **Result:** PASS 4/4 — parity confirmed end-to-end: Social Recap BPC Instagram card "Look how this girl in the bubble was…" = Brand > Content Post #1 (IG-only) on the same window.

## Pre-test setup
- Account context already Adam Orfei (carried from QA-130076).
- TWC/Social Recap date-picker JS-fallback used for cross-month nav (May 2026 → Jan 2026 via async `th.prev[N].click()` pattern).

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Reporting → Social Recap | OK (`#/social_recap`) |
| 2 | Add brand MTV — exact Results match (Rule 1) | brand row added; View defaulted to Public Data ("MTV (Public)") |
| 3 | Date range Jan 1 – Jan 7 2026 (Week interval auto-spans 7 days) | confirmed via header "Weekly Social Recap (Jan 1, 2026 – Jan 7, 2026)" |
| 4 | Click Run Report | Story 153956 loaded |
| 5 | Scroll to Best Performing Content, capture IG card details | IG Reel Card captured (see below) |
| 6 | Navigate Brand → Content for MTV (Adam Orfei) | URL `account_id=54&brand_id=10765` — note: 10765 is the canonical MTV brand on Adam Orfei (different brand_id from prior `4018`; page header reads "MTV" not Brasil/Argentina variants) |
| 7 | Date range Jan 1 – Jan 7 2026 | locked via URL `from=2026-01-01&to=2026-01-07` |
| 8 | Channels: Instagram only | URL `channels=instagram` only; Posts (15) IG-only result set |
| 9 | Review first post (sorted Engagements desc, default) | top row captured |

## Evidence

### Social Recap BPC Card 3 (Instagram) — story 153956
- `@mtv` · Mon Jan 05 2026 03:23 PM PST · Reel
- Text: "Look how this girl in the bubble was glowing at the #CriticsChoice Awards 🥹🩷 @arianagrande 🎥: @gettyentertainment"
- Engagements: 44,227 · Reactions: 43,971 · Comments: 256 · **Video Views: 691,822**

### Brand > Content Post #1 (MTV, IG-only, Jan 1–7 2026, Public)
- Channel icon: Instagram (purple) · Post type: Video / Reel
- Date: Mon Jan 05 2026 03:23 PM PST · Brand label: MTV
- Text: "Look how this girl in the bubble was glowing at the #CriticsChoice Awards…"
- Engagements: 44,227 · Reactions: 43,971 · Comments: 256 · **Video Views: 691,822** · Response Rate 0.20% · Video Response 6.39%

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Report loads without error | Story 153956 generated cleanly; Social Footprint, Social Activity tiles all populated. | PASS |
| A2 | IG Video View metric unlocked and visible at Brand level when data available | Video Views column populated on Post #1 with 691,822 (no lock icon, no en-dash). | PASS |
| A3 | Video View metric displayed within Instagram card in 'Best Performing Content' | BPC card 3 (Instagram) shows "Video Views 691,822" line item alongside Engagements/Reactions/Comments. | PASS |
| A4 | IG Video View value in Social Recap BPC card matches Brand → Content | Social Recap **691,822** == Brand > Content Post #1 **691,822** (verbatim match on same Reel post). | PASS |

## Bugs filed
None.

## Findings
- Adam Orfei has multiple MTV variants in the brand picker (canonical MTV = brand_id=10765; also MTV (Brasil)=70900, MTV (Argentina)=70901, etc.). The URL `brand_id=10765` correctly resolves to the canonical MTV (per Page header). The earlier published Adam Orfei MTV reference of brand_id=4018 may have been the same brand on a different account, or has been re-mapped. Either way, the Page header confirmation is canonical.

## Skill registry impact
- `social-recap-report-run` — pass_streak +1 (BPC IG Video Views card capture, Week interval auto-spans 7 days starting at Jan 1).
- `brand-content-data-set-selector` — pass_streak +1 (Public data set on Brand > Content, channel filter via URL, sort by Engagements desc).

## Sources
- [QA-131491 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-131491)
