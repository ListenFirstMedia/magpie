# QA-100887 — Brand > Insights VS TWC Threads

**Verdict: PASS**

- **Run date:** 2026-10-28 (unattended, headless Playwright MCP)
- **Environment:** https://app.lfmdev.in (login `lfiqa@listenfirstmedia.com`, programmatic Cognito login)
- **Account:** UCLA (account_id=799), switched from the default Condé Nast account via the LFQA profile menu
- **Brand:** University of California, Los Angeles (brand_id=127756). Exact-match typeahead result used, not "…Los Angeles Police" (Rule 1).
- **Channel / dates:** Threads only, Dec 06 2024 – Dec 12 2024
- **Perspective:** Authorized (Insights "Authorized data" toggle active; the tile datapoints are `threads.page.*_authorized`; TWC brand toggle clicked to Authorized, `checked=true`)
- **TWC story:** https://app-reporting.lfmdev.in/#story/time_window_comparison/161909

## Open-bug screen (Rule 7)
Case file "Open linked bugs": **None open** → screen passed, case executed.

## Steps executed
| # | Step | Result |
|---|------|--------|
| P | Precondition: logged in as UCLA | Logged in as lfiqa (landed on Condé Nast). Searched "UCLA" in the profile dropdown, clicked the `UCLA` entry under **Results**. Header: `ACCOUNT: UCLA`, URL `account_id=799`. |
| 1 | Brand > Insights | Hovered Brand, clicked Insights. URL `#explore/brand/insights?brand_id=127756&account_id=799…` |
| 2 | Click Brand dropdown | Opened via `.brand-selector-name-container`; "Search for a Brand" box appeared. |
| 3 | Select 'University of California, Los Angeles' | Typed the full name; Results showed `University of California, Los Angeles` and `…Los Angeles Police`. Clicked the exact match. |
| 4 | Threads channel only | Deselected Facebook, Twitter, Instagram, TikTok and selected Threads (Threads was unselected initially). Verified class states (only `threads enabled`), clicked Apply. URL `channels=threads`. |
| 5 | Date range Dec 06 – Dec 12, 2024 | Opened the Date Range overlay. Banner: "Historical data is available back to Oct. 26, 2020". Navigated the calendar to December 2024 and picked Dec 06, then Dec 12 (end calendar had to be paged back from Dec 2025). Interval stayed Daily, Make a Selection Auto. Ok → URL `from=2024-12-06&to=2024-12-12`; pill reads `Dec. 06, 2024 - Dec. 12, 2024`. |
| 6 | Note values | See table below (exact values from `.count[title]`). |
| 7 | Reporting > Time Window Comparison | First load hung on "Loading..." (see Observations). After one reload the builder rendered. |
| 8 | Add brand (Authorized) | Typed the full name; exact `University of California, Los Angeles` picked from the typeahead. Row defaulted to Public; clicked the per-brand toggle → `#0-perspective-toggle.checked=true` (Authorized). |
| 9 | Absolute Dates, Aggregate, Dec 06–12 2024 | Absolute Dates tab selected, Interval = Aggregate, both calendars paged to DECEMBER 2024; `range-start`=6, `range-end`=12. |
| 10 | Select 5 Threads metrics | Threads › Audience & Growth › New Followers; Content › Engagements; Content › Posts; Content › Engagement Rate; Impressions & Reach › Views. All `aria-checked=true`. |
| 11 | Deselect Show Metrics Graphs | Was `true` by default → clicked → `false` (Show Metrics Tables stays `true`). |
| 12 | Run Report | Story 161909 built. Header `Time Window Comparison (Dec 6, 2024 - Dec 12, 2024)`, Type: Education, Threads. No charts (graphs off), 5 tables. |

## Brand Insights values (Step 6)
Threads only, Authorized, Dec 06–12 2024, UCLA. Exact values from the tile `.count[title]`; displayed text in parentheses.

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
- `04-brand-selected.png`, `05-channels-before-apply.png`, `06-threads-applied.png`: brand and channel selection
- `09-range-picked.png`, `10-applied.png`, `11-insights-values.png`: Insights date range and tile values (full page)
- `12-twc-open.png` (stuck "Loading..."), `12b-twc-after-reload.png`: the TWC load hang and recovery
- `14-twc-brand-added.png`, `15-twc-authorized.png`, `16-twc-interval.png`, `17-twc-dates.png`, `18-twc-metric-filter-threads.png`, `19-twc-options.png`, `20-twc-before-run.png`: TWC build
- `21-twc-report.png`, `22-twc-report-built.png`: built report (full page)

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
- **TWC first-load hang:** after navigating Reporting > Time Window Comparison, `app-reporting.lfmdev.in` sat on "Loading..." for ~80 s. The console showed `503` on `https://accounts.lfmdev.in/global_storage` (cross-domain session bridge). One reload (within the 5-minute step budget) rendered the builder normally. Treated as transient; the case was not blocked. Worth watching if it recurs.
- **Perspective for Insights:** the case's Insights steps don't name a perspective. The page opened on Authorized data (URL `perspective=extended`; toggle verified active, datapoints `*_authorized`). It was left as-is and matches the TWC Authorized brand, which is what Step 8 specifies.
- **Threads is disabled by default** in the Insights channel selector for this brand: the selector starts with FB/TW/IG/TikTok on and Threads off, so Step 4 requires toggling all five icons.
- **End-date calendar pagination:** after picking the start date, the Insights overlay's end calendar shows Dec 2025 (the start+1yr default), so it must be paged back 12 months before picking Dec 12.

## Bugs filed
None (markdown-only policy; no defects found).
