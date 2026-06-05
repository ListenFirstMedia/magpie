# QA-24544 — Reporting > TWC - Share Functionality — Run Report

- **Date:** 2026-05-27
- **Account:** Adam Orfei (account_id varies)
- **Story:** time_window_comparison/153801 — "Michael Kors – Time Window Comparison (Jan 1, 2026 – Jan 7, 2026)"
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-24544.md

## Result: PARTIAL PASS (steps 11–15 require password-based sign-in which Claude cannot perform; A5 not verified by Claude)

## Execution
1. Switched account context to Adam Orfei via Yash → Search Account → click Results entry.
2. Navigated Reporting → Time Window Comparison.
3. Added brand **Michael Kors** via React-aware typeahead.
4. Toggled View → **Authorized Data** (Use Authorized Data pill became "Use Public Data" confirming switch).
5. Selected **Absolute Dates** → Jan 1, 2026 – Jan 7, 2026 via JS date-picker navigation.
6. Switched metric tree to **By Channel** view.
7. Expanded **Instagram** node, clicked **Audience & Growth** → **On** button → counter advanced to 7/7 (all 7 metrics selected, total Instagram 7/97).
8. Toggled **Show Change** and **Show Share** story options via controlled-check-box focus + Space dispatch (both = aria-checked="true").
9. Clicked **Run Report** → story 153801 generated, titled "Michael Kors – Time Window Comparison (Jan 1, 2026 – Jan 7, 2026)".
10. Clicked **Preview & Share Report** → preview overlay rendered with Share / Download / X buttons in top bar.
11. Clicked **Share** → "Share Report" modal opened with Invite by email row, People table, and Copy Link / Cancel / Share buttons.
12. Typed `lfiqa@listenfirstmedia.com` in the email input → clicked **Add**.
13. Clicked **Copy Link** → "Copied" green pill appeared (link copied to clipboard).
14. Clicked **Share** → green toast displayed "You've successfully shared a report."

**Steps 11–15 of the spec (sign out → sign in as lfiqa@listenfirstmedia.com → switch to Adam Orfei → paste URL) skipped.** Claude's security policy prohibits entering passwords. The user `lfiqa@listenfirstmedia.com / Testing@123` cannot be authenticated by Claude. A separate manual session by an LFIQA analyst is required to validate A5.

## Assertions
- **A1 (Brand added in Add Brands section):** PASS — Michael Kors appears as Primary in the Add Brands table after typeahead selection.
- **A2 (Given User name and email Id row in People table):** PASS — after typing `lfiqa@listenfirstmedia.com` + Add, a row appeared with `LFQA Testing` / `lfiqa@listenfirstmedia.com`.
- **A3 (Action column displays "Remove"):** PASS — the new row's Actions cell shows blue **Remove** link.
- **A4 (Pop-up disappears; prompt displays "You've successfully shared a report"):** PASS — modal closed and toast read exactly "You've successfully shared a report." (matches spec verbatim).
- **A5 (Shared Report displays after paste):** **NOT VERIFIED BY CLAUDE** — sign-out and password-based re-auth as `lfiqa@listenfirstmedia.com` is outside Claude's allowed actions. The shared URL (`https://app-reporting.lfmdev.in/#story/time_window_comparison/153801`) is in the clipboard and the share record exists server-side (A4 confirms). Manual LFIQA verification required.

## Evidence
- Story URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/153801`
- People table after Add: `Yash Sharma / yash.sharma@listenfirstmedia.com / Creator`; `LFQA Testing / lfiqa@listenfirstmedia.com / Remove`.

## Notes
- The Yash menu user is `Yash Sharma / yash.sharma@listenfirstmedia.com` (internal SSO identity) even though the Cowork session label says lfiqa@... — this is the SSO mapping behavior, not a bug.
- The "By Channel" view is the second tab (right of "By Category"); programmatic click on the tab requires querying `*` for the exact text node since `.al-tab__label` selector may not match.
- The Instagram details element does not pre-render its children. Clicking the summary triggers React to mount the child tree, after which the Audience & Growth subsection becomes available. Setting `details.open = true` alone does NOT mount children — must `summary.click()` to trigger React's onClick handler.
- Recommended follow-up: paste `https://app-reporting.lfmdev.in/#story/time_window_comparison/153801` into a clean session of `lfiqa@listenfirstmedia.com` to verify A5 manually.
