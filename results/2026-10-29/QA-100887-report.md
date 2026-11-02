# QA-100887 — Brand > Insights VS TWC Threads

**Verdict: PASS**

- **Run date:** 2026-10-29 (unattended, headless Playwright MCP)
- **Environment:** https://app.lfmdev.in (login `lfiqa@listenfirstmedia.com`, programmatic Cognito login)
- **Account:** UCLA (account_id=799), switched from the default VIACOM account via the LFQA profile menu
- **Brand:** University of California, Los Angeles (brand_id=127756). Exact-match typeahead result used, not "…Los Angeles Police" (Rule 1).
- **Channel / dates:** Threads only, Dec 06 2024 – Dec 12 2024
- **Perspective:** Authorized (Insights URL `perspective=extended`, toggle `checked=true`; TWC per-brand toggle clicked from Public to Authorized, `checked=true`)
- **TWC story:** https://app-reporting.lfmdev.in/#story/time_window_comparison/161995

## Open-bug screen (Rule 7)
Case file "Open linked bugs": **None open** → screen passed, case executed.

## Steps executed
| # | Step | Result |
|---|------|--------|
| P | Precondition: logged in as UCLA | Logged in as lfiqa (landed on VIACOM). In the profile menu, searched "UCLA" and clicked the exact `UCLA` entry under **Results**. Header `ACCOUNT: UCLA`, URL `account_id=799`. (My first click used a loose selector and landed on **UCLA Law** (account_id=3579) by mistake. I caught it from the header and redid the switch with an exact-text match. No test steps had run yet, so no data was affected.) |
| 1 | Brand > Insights | Hovered Brand, clicked Insights. URL `#explore/brand/insights?brand_id=127756&account_id=799…` |
| 2 | Click Brand dropdown | Opened via `.brand-selector-name-container`; "Search for a Brand" box appeared. |
| 3 | Select 'University of California, Los Angeles' | Typed the full name; Results showed `University of California, Los Angeles` and `…Los Angeles Police`. Clicked the exact match. |
| 4 | Threads channel only | Threads was disabled by default; toggled Facebook, Twitter, Instagram, TikTok off and Threads on. Verified only `channel-ghost threads enabled`, clicked Apply. URL `channels=threads`. |
| 5 | Date range Dec 06 – Dec 12, 2024 | Opened the Date Range overlay, paged the start calendar from October 2026 back to December 2024 and picked 6, then paged the end calendar (it defaulted to December 2025) back to December 2024 and picked 12. Ok → URL `from=2024-12-06&to=2024-12-12`; pill reads `Dec. 06, 2024 - Dec. 12, 2024`. Interval stayed Daily, Make a Selection Auto. |
| 6 | Note values | See table below (exact values from `.count[title]`). |
| 7 | Reporting > Time Window Comparison | Hovered Reporting, clicked the submenu link. Page sat on "Loading..." briefly; the builder rendered within ~45 s with no reload needed. |
| 8 | Add brand (Authorized) | Typed the full name; exact `University of California, Los Angeles` picked from the typeahead (options also listed `…Police`). Row defaulted to Public; clicked the per-brand toggle → `#0-perspective-toggle.checked` false → true (Authorized). |
| 9 | Absolute Dates, Aggregate, Dec 06–12 2024 | Clicked Absolute Dates tab, set Interval from Days to Aggregate, paged both calendars to December 2024; `range-start`=6, `range-end`=12. |
| 10 | Select 5 Threads metrics | Filtered by "Threads"; clicked Threads New Followers, Engagements, Posts, Engagement Rate, Views. All `aria-checked=true`. |
| 11 | Deselect Show Metrics Graphs | Was `true` by default → clicked → `false` (Show Metrics Tables stays `true`). |
| 12 | Run Report | Story 161995 built. Header `Time Window Comparison (Dec 6, 2024 - Dec 12, 2024)`, Type: Education, Threads. 0 charts (graphs off), 5 tables. |

## Brand Insights values (Step 6)
Threads only, Authorized, Dec 06–12 2024, UCLA. Exact values from the tile `.count[title]`.

| Metric (Insights tile) | Exact value | Displayed |
|---|---|---|
| Follower Growth | 13 | 13 (-86%) |
| New Posts | 9 | 9 (–) |
| Engagements | 369 | 369 (-34%) |
| Engagement Rate | 2.52% | 2.52% (+127%) |
| Views | 14,635 | 14.6K (+344%) |

(Also on page: Total Followers 74,123, Fan Growth Rate 0.02%. Not in scope for the assertion.)

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A12-1 | 12 | TWC "Threads New Followers" = Insights Follower Growth | TWC 13 vs Insights 13 | PASS |
| A12-2 | 12 | TWC "Threads Posts" = Insights New Posts | TWC 9 vs Insights 9 | PASS |
| A12-3 | 12 | TWC "Threads Engagements" = Insights Engagements | TWC 369 vs Insights 369 | PASS |
| A12-4 | 12 | TWC "Threads Engagement Rate" = Insights Engagement Rate | TWC 2.52% vs Insights 2.52% | PASS |
| A12-5 | 12 | TWC "Threads Views" = Insights Views | TWC 14,635 vs Insights 14,635 (tile shows 14.6K, exact via title attr) | PASS |

Overall assertion 12 ("TWC and Brand Insights values match for the selected metrics"): **PASS** (5/5).

## Evidence
Screenshots under `.playwright-out/QA-100887/`:
- `02-account-search.png`: account search Results (UCLA, UCLA Law)
- `03-brand-search.png`, `04-brand-selected.png`, `05-channels-before-apply.png`, `06-threads-applied.png`: brand and channel selection
- `09-range-picked.png`, `10-applied.png`, `11-insights-values.png`: Insights date range and tile values
- `12-twc-open.png`, `13-twc-brand-search.png`, `14-twc-brand-added.png`, `16-twc-interval.png`, `17-twc-dates.png`, `18-twc-metric-filter-threads.png`, `19-twc-metrics-selected.png`, `20-twc-before-run.png`: TWC build
- `21-twc-report.png`: built report (full page)

TWC built-report tables (verbatim):
```
Brand | Threads New Followers   → University of California, Los Angeles | 13
Brand | Threads Engagements     → University of California, Los Angeles | 369
Brand | Threads Posts           → University of California, Los Angeles | 9
Brand | Threads Engagement Rate → University of California, Los Angeles | 2.52%
Brand | Threads Views           → University of California, Los Angeles | 14,635
```

## Known bugs checked
- Case file: no open linked bugs (as of the 2026-10-20 cache). Pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-100887: no matches.
- No known bug reproduced or interfered. No mismatch between TWC and Insights, so nothing to attribute.

## Observations (not verdict-affecting)
- **TWC first-load "Loading...":** briefly seen again after navigating to Reporting > Time Window Comparison (it hung ~80 s with a 503 on the 2026-10-28 run). Today it cleared by itself within ~45 s, no reload needed.
- **Perspective for Insights:** the case's Insights steps don't name a perspective. The page opened on Authorized data (`perspective=extended`, toggle `checked=true`) and was left as-is, which matches the TWC Authorized brand that Step 8 specifies.
- **Threads is disabled by default** in the Insights channel selector for this brand, so Step 4 requires toggling all five icons.
- **End-date calendar pagination:** after picking the start date, the Insights end calendar shows December 2025 (start + 1 year), so it must be paged back 12 months before picking Dec 12.
- **Account switch:** a loose text selector can hit "UCLA Law" because it is listed beneath "UCLA" in Results. Use an exact-text match and confirm the `ACCOUNT:` header.
- Values are identical to the 2026-10-28 run (13 / 9 / 369 / 2.52% / 14,635).

## Bugs filed
None (markdown-only policy; no defects found).
