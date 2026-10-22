# QA-32751 — Brand Paid vs TWC > Big Numbers Data QA > Instagram

**Run date:** 2026-10-22 (headless unattended `claude -p`, Playwright MCP), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Instagram only · Window: Oct. 14, 2026 – Oct. 20, 2026 (Authorized data)
**Skill used:** brand-paid-vs-twc (v1)
**Verdict: PASS — all five Instagram Paid big numbers equal the TWC aggregate values exactly (Paid Impressions 68,791,348 · Spend $604,057.25 · Clicks 905,250 · Paid Actions 2,515,442 · 95% Completed Video Views 342,606)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account") + precondition: account Michael Kors | First sign-in attempt returned a transient Cognito error ("PreAuthentication failed ... Task timed out after 3.00 seconds"); retry succeeded. Session landed on account Adam Orfei, so switched via LFQA menu > Search Account > `Results` > "Michael Kors"; breadcrumb confirmed `ACCOUNT: MICHAEL KORS`, `account_id=328`. |
| 1 | Hover Brand > Paid | `#explore/brand/paid?brand_id=3801&account_id=328...` |
| 2 | Add Michael Kors brand | Brand was preselected (3801); re-selected explicitly via the brand picker typeahead by clicking the exact "Michael Kors" result (first in list, above "Michael Kors - CA" etc.). URL kept `brand_id=3801`. |
| 3 | Enable Instagram only | Clicked Instagram ghost (Facebook auto-disabled in single-select mode), clicked Apply; URL `channels=instagram`; legend on all tiles shows Instagram only. |
| 4 | Note big numbers (exact `.count[title]`) | Paid Impressions **68,791,348** · Spend **$604,057.25** · Clicks **905,250** · Paid Actions **2,515,442** · 95% Completed Video Views **342,606** (also Active Ads 868; CTR 1.32%; Paid Action Rate 3.66%). Date range Oct. 14 – Oct. 20, 2026. |
| 5 | Reporting > Classic Reporting | The Reporting menu has no "Classic Reporting" item; entries are Home, Dashboards, Data Studio, Time Window Comparison, Content Performance, Social Recap, Follower Demographics. Used the direct "Time Window Comparison" link (same as the 2026-10-20 run). |
| 6 | Select TWC template | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 7 | Add Michael Kors (Authorized) | Typed "Michael Kors", clicked exact result; clicked the perspective toggle (`label[for="0-perspective-toggle"]`), `#0-perspective-toggle` checked=true, screenshot shows toggle on Authorized Data. |
| 8 | Absolute Dates + Aggregate interval | Absolute Dates tab clicked; Interval dropdown "Days" -> "Aggregate"; From calendar day 14, To calendar day 20, October 2026 (same window as the Paid page). |
| 9 | Data Selection > By Channel | Clicked "By Channel". |
| 10 | Instagram metrics | Selected Instagram › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions; tree counter `Instagram ( 5 / 99 )`. |
| 11 | Deselect Show Metrics Graphs | Was checked; clicked label; screenshot shows unchecked. |
| 12 | Run Report | `#story/time_window_comparison/161557`, rendered with 5 tables, window "Oct 14, 2026 - Oct 20, 2026". |
| 13 | Compare | All five equal. |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 13 | Paid Impressions == Instagram Ad Impressions | 68,791,348 == 68,791,348 | PASS |
| A2 | 13 | Spend == Instagram Ad Spend | $604,057.25 == $604,057.25 | PASS |
| A3 | 13 | Clicks == Instagram Ad Clicks | 905,250 == 905,250 | PASS |
| A4 | 13 | Paid Actions == Instagram Paid Actions | 2,515,442 == 2,515,442 | PASS |
| A5 | 13 | 95% Completed Video Views == Instagram Ad 95% Completed Views | 342,606 == 342,606 | PASS |

## Evidence
Screenshots under `.playwright-out/QA-32751/`:
- `login-1.png` (transient Cognito PreAuthentication timeout), `home.png`, `acct-search.png`
- `paid-1.png`, `paid-brand-typeahead.png`, `paid-ig-top.png`
- `twc-1.png`, `twc-brand-added.png`, `twc-graphs-before.png`, `twc-graphs-after.png`, `twc-report.png`

Exact values were read from DOM text (Paid: `.tile .count[title]`; TWC: one table per metric).

## Known bugs checked
- Case file "Open linked bugs": none open. bug-history.md and known-quirks.md had no QA-32751 entries (pre-grepped). No known bug reproduced or interfered.
- Observation, not a bug filed: the sign-in screen once returned "Invalid input: PreAuthentication failed ... Task timed out after 3.00 seconds" (Cognito pre-auth Lambda cold start); a single retry succeeded.

## Bugs filed
None.

## Notes / framework observations
- Brand > Paid brand picker: the first `.brand-selector textarea` in the DOM is a hidden duplicate; click the visible brand name header to open the visible picker, then `pressSequentially` into `.brand-selector textarea:visible`.
- Channel selector on Paid is single-select: clicking another ghost swaps the selection; Apply is enabled only after a change.
- "Classic Reporting" in the case wording maps to Reporting > Time Window Comparison in the current nav.
- Skill/REGISTRY maintenance deferred to harvest.sh.

## Cleanup
None (read-only case; the TWC story 161557 is a saved report run only).
