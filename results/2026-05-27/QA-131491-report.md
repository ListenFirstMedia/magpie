# QA-131491 — Social Recap Vs Brand > Content - IG Public Video View — Run Report

- **Date:** 2026-05-27
- **Account:** Adam Orfei (id=54)
- **Brand:** MTV (id=4018), View = Public Data
- **Date range:** Jan 1, 2026 – Jan 7, 2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-131491.md

## Result: PASS

## Execution

1. Logged in app.lfmdev.in, switched account Wasserman → Adam Orfei via Yash picker → Search Account → typed "Adam Orfei" → clicked exact match from Results.
2. Navigated Reporting → Social Recap (`https://app-reporting.lfmdev.in/#/social_recap`).
3. Added brand MTV (default View = Public Data — matches "MTV (Public)").
4. Selected date range Jan 1, 2026 – Jan 7, 2026 via React-aware date picker (JS-fallback prev-arrow clicks + bounding-box-filtered day-cell selection).
5. Clicked Run Report → story 153794 ("Weekly Social Recap (Jan 1, 2026 – Jan 7, 2026)") generated.
6. Scrolled to Best Performing Content (BPC) section via `el.scrollIntoView` on the `<h2>Best Performing Content` element.
7. BPC Card 3 captured: **@mtv Instagram, Mon Jan 05 2026 03:23 PM PST, Video/Reel, "Look how this girl in the bubble was glowing at the #CriticsChoice Awards" — Engagements 44,227; Reactions 43,971; Comments 256; Video Views 691,822**.
8. Navigated Brand → Content for MTV with same account, date range, Instagram-only channel filter, Data Set = Public.
9. Switched Layout to Table View. First post (Rank 1, sorted Engagements desc): Mon Jan 05, 2026 03:23 PM PST, Type Video / Reel, "Look how this girl …" — Engagements 44,227; Reactions 43,971; Comments 256; **Video Views 691,822**.

## Assertions

- **A1 (Report loads without error):** PASS — Social Recap story 153794 generated cleanly.
- **A2 (IG Video View metric unlocked and visible at Brand level when data available):** PASS — metric column visible and populated (no lock icon, no en-dash).
- **A3 (Video View metric displayed within Instagram card in BPC):** PASS — Card 3 explicitly displays "Video Views: 691,822".
- **A4 (IG Video View value in Social Recap BPC card matches Brand → Content):** PASS — Social Recap **691,822** == Brand > Content first post **691,822**.

## Evidence

- Social Recap BPC Card 3 (Instagram): Engagements 44,227, Reactions 43,971, Comments 256, Video Views 691,822.
- Brand > Content table row 1 (Instagram only): Engagements 44,227, Reactions 43,971, Comments 256, Video Views 691,822.
- Same post by text + timestamp.

## Notes

- Account is Adam Orfei not Wasserman — switched via Yash picker (Search Account → click Results exact-match, NOT Recent Searches per [[brand-content-data-set-selector]] / known-quirks).
- For Brand > Content, the URL params channels=instagram, table_data_set=public, sort_key=lfm.content.responses_mixed, sort_order=desc reach the same state described by the spec steps without manual clicks.
- This single Social Recap run also captured the YouTube card needed for [[QA-131492]] — see that report.
