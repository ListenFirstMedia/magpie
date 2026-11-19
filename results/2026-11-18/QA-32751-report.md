# QA-32751 — Brand Paid vs TWC > Big Numbers Data QA > Instagram

**Run date:** 2026-11-18 (headless unattended `claude -p`, Playwright MCP), dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · Channel: Instagram only · Window: Nov. 10, 2026 – Nov. 16, 2026 (Authorized data)
**Skill used:** brand-paid-vs-twc (v1)
**Verdict: PASS — all five Instagram Paid big numbers equal the TWC aggregate values exactly (Paid Impressions 53,097,123 · Spend $598,961.86 · Clicks 1,225,589 · Paid Actions 2,556,836 · 95% Completed Video Views 212,139)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account") + precondition: account Michael Kors | Login succeeded first try. Session landed on account Amazon Prime Video, so switched via LFQA menu > Search Account (typed slowly), confirmed a `Results` header, clicked "Michael Kors". Breadcrumb `ACCOUNT: MICHAEL KORS`, `account_id=328`. |
| 1 | Hover Brand > Paid | `#explore/brand/paid?brand_id=3801&account_id=328&from=2026-11-10&to=2026-11-16...` |
| 2 | Add Michael Kors brand | Brand was preselected (3801). Re-selected via the brand picker: first typeahead showed only `Recent Searches`, so I nudged the input (Backspace + retype) until the full result list appeared, then clicked the exact "Michael Kors" `option-label`. Brand stayed `brand_id=3801`. |
| 3 | Enable Instagram only | Clicked the Instagram ghost (Facebook auto-disabled, single-select), clicked Apply. URL `channels=instagram`; legend on every tile shows Instagram only. Authorized data view active. |
| 4 | Note big numbers (exact `.count[title]`) | Paid Impressions **53,097,123** · Spend **$598,961.86** · Clicks **1,225,589** · Paid Actions **2,556,836** · 95% Completed Video Views **212,139** (also Active Ads 723; CTR 2.31%; Paid Action Rate 4.82%). Date range Nov. 10 – Nov. 16, 2026. |
| 5 | Reporting > Classic Reporting | The Reporting menu has no "Classic Reporting" item; entries are Home, Dashboards, Data Studio, Time Window Comparison, Content Performance, Social Recap, Follower Demographics. Used "Time Window Comparison" (same mapping as prior runs). |
| 6 | Select TWC template | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 7 | Add Michael Kors (Authorized) | Typed "Michael Kors", clicked the exact result; clicked the perspective toggle (`label[for="0-perspective-toggle"]`); `#0-perspective-toggle` checked=true and screenshot shows the toggle on Authorized Data. |
| 8 | Absolute Dates + Aggregate interval | Clicked the Absolute Dates tab; Interval dropdown "Days" -> "Aggregate"; From calendar day 10, To calendar day 16, November 2026 (same window as Paid page). |
| 9 | Data Selection > By Channel | Clicked "By Channel". |
| 10 | Instagram metrics | Selected Instagram › Paid › Ad Clicks, Ad Impressions, Ad 95% Completed Views, Ad Spend, Paid Actions; tree counter `Instagram ( 5 / 99 )`, exactly 5 checked leaves, all under Instagram › Paid. |
| 11 | Deselect Show Metrics Graphs | Clicked the label; screenshot confirms the box is unchecked. |
| 12 | Run Report | `#story/time_window_comparison/162943`, 5 tables, window "Nov 10, 2026 - Nov 16, 2026". |
| 13 | Compare | All five equal. |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 13 | Paid Impressions == Instagram Ad Impressions | 53,097,123 == 53,097,123 | PASS |
| A2 | 13 | Spend == Instagram Ad Spend | $598,961.86 == $598,961.86 | PASS |
| A3 | 13 | Clicks == Instagram Ad Clicks | 1,225,589 == 1,225,589 | PASS |
| A4 | 13 | Paid Actions == Instagram Paid Actions | 2,556,836 == 2,556,836 | PASS |
| A5 | 13 | 95% Completed Video Views == Instagram Ad 95% Completed Views | 212,139 == 212,139 | PASS |

## Evidence
Screenshots under `.playwright-out/QA-32751/`:
- `home.png`, `lfqa-menu2.png`, `acct-search.png`
- `paid-1.png`, `paid-brand-typeahead.png`, `paid-brand-typeahead2.png`, `paid-brand-selected.png`, `paid-ig-top.png`
- `reporting-menu.png`, `twc-1.png`, `twc-brand-added.png`, `twc-perspective.png`, `twc-interval.png`, `twc-dates.png`, `twc-search-ad.png`, `twc-metrics.png`, `twc-graphs-after.png`, `twc-report.png`

Exact values were read from DOM text (Paid: `.tile .count[title]`; TWC: one table per metric).

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md and known-quirks.md had no QA-32751 entries (pre-grepped). No known bug reproduced or interfered.

## Bugs filed
None.

## Notes / framework observations
- Brand > Paid brand picker: the typeahead may show only `Recent Searches` after typing; nudging the input (Backspace + one more character) surfaces the full result list. Click the `span.option-label` with the exact name.
- Account search needed a slowly-typed query; a `Results` header was present, and the Amazon Prime Video session default had to be switched to Michael Kors.
- "Classic Reporting" in the case wording maps to Reporting > Time Window Comparison in the current nav.
- `config/.env` cannot be read from inside `browser_run_code_unsafe` (no `require`/dynamic import); credentials had to be read via the file tool and passed to `browser_fill_form`.
- Skill/REGISTRY maintenance deferred to harvest.sh.

## Cleanup
None (read-only case; TWC story 162943 is a saved report run only).
