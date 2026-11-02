# QA-100887 — Brand > Insights VS TWC Threads

**Verdict: PASS**

- **Run date:** 2026-10-30 (unattended, headless Playwright MCP)
- **Environment:** https://app.lfmdev.in (login `lfiqa@listenfirstmedia.com`, programmatic Cognito login)
- **Account:** UCLA (account_id=799), switched from the default account via the LFQA profile menu
- **Brand:** University of California, Los Angeles (brand_id=127756). Exact-match typeahead result used, not "…Los Angeles Police" (Rule 1).
- **Channel / dates:** Threads only, Dec 06 2024 – Dec 12 2024
- **Perspective:** Authorized (Insights URL `perspective=extended`, "Authorized data" active, toggle `checked=true`; TWC per-brand toggle clicked from Public to Authorized, `checked` false -> true)
- **TWC story:** https://app-reporting.lfmdev.in/#story/time_window_comparison/162049

## Open-bug screen (Rule 7)
Case file "Open linked bugs": **None open**, so the screen passed and the case was executed.

## Steps executed
| # | Step | Result |
|---|------|--------|
| P | Precondition: logged in as UCLA | Logged in as lfiqa. Opened the LFQA profile menu, typed "UCLA" in Search Account, clicked the exact `UCLA` entry under **Results** (not `UCLA Law`). Header `ACCOUNT: UCLA`, URL `account_id=799`. |
| 1 | Brand > Insights | Hovered Brand, clicked the visible Insights link. URL `#explore/brand/insights?brand_id=127756&account_id=799…`. |
| 2 | Click Brand dropdown | The brand name already read "University of California, Los Angeles". Clicking the name container did not open the picker. The chevron next to the brand name opened it ("Search for a Brand" box). |
| 3 | Select 'University of California, Los Angeles' | Typed the full name. Results listed `University of California, Los Angeles` and `…Los Angeles Police`. Clicked the exact match. |
| 4 | Threads channel only | Defaults were Facebook, Twitter, Instagram, TikTok enabled and Threads disabled. Toggled the four off and Threads on. Verified only `channel-ghost threads enabled`, then clicked Apply. URL `channels=threads`. |
| 5 | Date range Dec 06 – Dec 12, 2024 | Opened the Date Range overlay, paged the start calendar from October 2026 back to December 2024 and picked 6. Paged the end calendar (it defaulted to December 2025) back to December 2024 and picked 12. Start/End boxes read `Dec 06, 2024` / `Dec 12, 2024`. Ok -> URL `from=2024-12-06&to=2024-12-12`. |
| 6 | Note values | See table below (exact values from `.count[title]`). |
| 7 | Reporting > Time Window Comparison | Hovered Reporting, clicked the submenu link. The builder rendered with no reload needed. |
| 8 | Add brand (Authorized) | Typed the full name. Options were `University of California, Los Angeles` and `…Police`. Picked the exact one. The row defaulted to Public. Clicked the per-brand toggle label, so `#0-perspective-toggle.checked` went false -> true (Authorized). |
| 9 | Absolute Dates, Aggregate, Dec 06–12 2024 | Clicked the Absolute Dates tab and set Interval from Days to Aggregate. Paged both calendars to December 2024. `range-start`=6 and `range-end`=12. |
| 10 | Select 5 Threads metrics | Filtered the metric tree by "Threads" and clicked Threads New Followers, Engagements, Posts, Engagement Rate, Views. All five `aria-checked=true`, and they are the only selected leaves. |
| 11 | Deselect Show Metrics Graphs | Was `true` by default. Clicked it, so it is now `false` (Show Metrics Tables stays `true`). |
| 12 | Run Report | Story 162049 built. Header `Time Window Comparison (Dec 6, 2024 - Dec 12, 2024)`, Type: Education, Threads. 0 charts (graphs off), 5 tables. |

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
|---|------|----------|--------|--------|
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
- `07-date-overlay.png`, `08-start-picked.png`, `09-range-picked.png`, `10-applied.png`, `11-insights-values.png`: Insights date range and tile values
- `12-twc-open.png`, `13-twc-brand-search.png`, `14-twc-brand-added.png`, `16-twc-interval.png`, `17-twc-dates.png`, `18-twc-metric-filter-threads.png`, `19-twc-metrics-selected.png`, `20-twc-before-run.png`: TWC build
- `21-twc-report.png`: built report (full page)

TWC built-report tables (verbatim):
```
Brand | Threads New Followers   -> University of California, Los Angeles | 13
Brand | Threads Engagements     -> University of California, Los Angeles | 369
Brand | Threads Posts           -> University of California, Los Angeles | 9
Brand | Threads Engagement Rate -> University of California, Los Angeles | 2.52%
Brand | Threads Views           -> University of California, Los Angeles | 14,635
```

## Known bugs checked
- Case file: no open linked bugs (as of the 2026-10-20 cache). Pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-100887: no matches.
- No known bug reproduced or interfered. No mismatch between TWC and Insights, so nothing to attribute.

## Observations (not verdict-affecting)
- **Values are identical to the 2026-10-29 / 10-28 runs** (13 / 9 / 369 / 2.52% / 14,635).
- **Brand picker trigger:** clicking `.brand-selector-name-container` did not open the picker this run. The chevron beside the brand name (about x=524, y=165) opened it. The earlier report used the container selector, so this may be flaky or may have changed.
- **Perspective for Insights:** the case's Insights steps don't name a perspective. The page opened on Authorized data (`perspective=extended`) and was left as-is, which matches the TWC Authorized brand that Step 8 specifies.
- **Threads is disabled by default** in the Insights channel selector for this brand, so Step 4 requires toggling all five icons.
- **End-date calendar pagination:** after the start date is picked, the Insights end calendar shows December 2025, so it must be paged back 12 months before picking Dec 12.
- **TWC metric checkboxes** are `i[role=checkbox][aria-checked]` inside `li.leaf[title=<metric>]`, not `<input>` elements. Read state from there.

## Bugs filed
None (markdown-only policy; no defects found).
