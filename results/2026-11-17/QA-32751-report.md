# QA-32751 — Brand Paid vs TWC > Big Numbers Data QA > Instagram

**Run date:** 2026-11-17 (headless unattended `claude -p`, Playwright MCP), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Instagram only · Window: Nov. 09, 2026 – Nov. 15, 2026 (Authorized data)
**Skill used:** brand-paid-vs-twc (v1)
**Verdict: PASS — all five Instagram Paid big numbers equal the TWC aggregate values exactly (Paid Impressions 54,065,742 · Spend $588,941.99 · Clicks 1,223,518 · Paid Actions 2,696,718 · 95% Completed Video Views 214,581)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account") + precondition: account Michael Kors | Sign-in succeeded first try. Session landed on account Adam Orfei, so switched via LFQA menu > Search Account > `Results` entry "Michael Kors" (real click); breadcrumb confirmed `ACCOUNT: MICHAEL KORS`, `account_id=328`. |
| 1 | Hover Brand > Paid | `#explore/brand/paid?brand_id=3801&account_id=328&from=2026-11-09&to=2026-11-15&channels=facebook&perspective=extended&table_data_set=engagements` |
| 2 | Add Michael Kors brand | Brand was preselected (3801). Re-selected explicitly: opened the brand picker, typed "Michael Kors", clicked the exact first `Michael Kors` option (above "Michael Kors - CA" etc.). URL kept `brand_id=3801`. |
| 3 | Enable Instagram only | Clicked Instagram ghost, then Apply. URL `channels=instagram`; ghost states: facebook/twitter/youtube/tiktok disabled, instagram enabled; all tiles' legend shows Instagram only. |
| 4 | Note big numbers (exact `.tile .count[title]`) | Paid Impressions **54,065,742** · Spend **$588,941.99** · Clicks **1,223,518** · Paid Actions **2,696,718** · 95% Completed Video Views **214,581** (also Active Ads 737; CTR 2.26%; Paid Action Rate 4.99%). Page header: Date Range Nov. 09, 2026 – Nov. 15, 2026, compared to Nov. 02 – Nov. 08. |
| 5 | Hover Reporting > Classic Reporting | The Reporting menu has no "Classic Reporting" item. Visible entries: Home, Dashboards, Data Studio, Time Window Comparison, Content Performance, Social Recap, Follower Demographics. Used "Time Window Comparison" (same mapping as earlier runs). |
| 6 | Select TWC template | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 7 | Add Michael Kors (Authorized) | Typed "Michael Kors", clicked the exact first option. Toggle was unchecked (Public); clicked `label[for="0-perspective-toggle"]`, `#0-perspective-toggle` checked=true; screenshot `twc-brand-added.png` shows View toggle on Authorized Data. |
| 8 | Absolute Dates + Aggregate interval | Absolute Dates tab; Interval dropdown "Days" -> "Aggregate"; From calendar day 9, To calendar day 15, NOVEMBER 2026 (the Paid page window). Active cells confirmed from 9 / to 15. |
| 9 | Data Selection > By Channel | Clicked "By Channel". |
| 10 | Instagram metrics | Searched "Ad" and selected Instagram › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend; searched "Paid Actions" and selected Instagram › Paid › Paid Actions. With the search cleared: `Instagram ( 5 / 99 )`, `Paid ( 5 / 8 )`, no other channel selected. |
| 11 | Deselect Show Metrics Graphs | Was checked (screenshot `twc-graphs.png`); clicked label; `twc-graphs-after.png` shows it unchecked (Show Metrics Tables remains checked). |
| 12 | Run Report | `#story/time_window_comparison/162857`, rendered 5 tables, window "Nov 9, 2026 - Nov 15, 2026". |
| 13 | Compare | All five equal. |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 13 | Paid Impressions == Instagram Ad Impressions | 54,065,742 == 54,065,742 | PASS |
| A2 | 13 | Spend == Instagram Ad Spend | $588,941.99 == $588,941.99 | PASS |
| A3 | 13 | Clicks == Instagram Ad Clicks | 1,223,518 == 1,223,518 | PASS |
| A4 | 13 | Paid Actions == Instagram Paid Actions | 2,696,718 == 2,696,718 | PASS |
| A5 | 13 | 95% Completed Video Views == Instagram Ad 95% Completed Views | 214,581 == 214,581 | PASS |

## Evidence
Screenshots under `.playwright-out/QA-32751/`:
- `login-1.png` (earlier attempt), `home.png`, `paid-1.png`, `paid-brand-typeahead.png`, `paid-brand-selected.png`, `paid-ig-top.png`, `paid-view-toggle.png`, `reporting-menu.png`
- `twc-1.png`, `twc-typeahead.png`, `twc-brand-added.png`, `twc-interval.png`, `twc-dates.png`, `twc-dates-view.png`, `twc-bychannel.png`, `twc-search-ad.png`, `twc-ig-selected-1.png`, `twc-graphs.png`, `twc-graphs-after.png`, `twc-report.png`

Exact values were read from DOM text (Paid: `.tile .count[title]`; TWC: one table per metric — "Brand | Instagram <Metric>" with one row "Michael Kors | value").

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md and known-quirks.md had no QA-32751 entries (pre-grepped). No known bug reproduced or interfered.
- Prior runs of this case (2026-10-20, 2026-10-22) were PASS on the same flow; no regression observed.

## Bugs filed
None.

## Notes / framework observations
- Brand > Paid brand picker: click the visible brand name header (`.brand-selector-name`) to open it, type into `.brand-selector textarea:visible`, click `.option-label` with the exact text.
- TWC By Channel: the "Paid Actions" metric is not matched by the "Ad" search; it needs its own search. Clicking the metric label span via bounding-box centre works.
- `browser_run_code_unsafe` has no `require`; read credentials via Bash instead.
- "Classic Reporting" in the case wording still maps to Reporting > Time Window Comparison.
- Skill/REGISTRY maintenance deferred to harvest.sh.

## Cleanup
None (read-only case; TWC story 162857 is a report run only, nothing created or edited).
