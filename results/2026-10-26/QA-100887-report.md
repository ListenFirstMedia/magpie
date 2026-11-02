# QA-100887 — Brand > Insights VS TWC Threads

**Run date:** 2026-10-26 · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in / app-reporting.lfmdev.in
**Account:** UCLA (switched from default HBO MAX via profile menu "LFQA" → Search Account → `Results` item "UCLA"; header showed `ACCOUNT: UCLA`, account_id=799)
**Brand:** University of California, Los Angeles (exact typeahead match, Rule 1; not "… Police") · **Channel:** Threads only · **Range:** Dec 06, 2024 – Dec 12, 2024 · **Perspective:** Authorized on both sides

## Verdict: PASS

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (config/.env, "With existing account") and account switch HBO MAX → UCLA | Done; `ACCOUNT: UCLA` confirmed |
| 1 | Brand → Insights (top-nav hover → Insights link) | Done; `#explore/brand/insights` |
| 2 | Click Brand dropdown | Done; opened "Search for a Brand" panel |
| 3 | Select exact `University of California, Los Angeles` | Typeahead showed 2 results (UCLA, UCLA Police); clicked exact match; `brand_id=127756` |
| 4 | Channels: click Threads icon, Apply | Only `.channel-ghost.threads` enabled; URL `channels=threads` only |
| 5 | Date range Dec 06 – Dec 12, 2024 via picker (22 `th.prev` clicks, start=6; end calendar jumped to Dec 2025, 12 `th.prev`, end=12; Ok) | Header `Dec. 06, 2024 - Dec. 12, 2024`; URL `from=2024-12-06&to=2024-12-12` |
| 6 | Note values (View toggle visually confirmed on **Authorized data**, screenshot 04) | See assertions table |
| 7 | Reporting → Time Window Comparison | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 8 | Add brand `University of California, Los Angeles`; per-brand toggle clicked from Public → Authorized | `0-perspective-toggle` checked=true; screenshot 06 shows "Authorized Data" |
| 9 | Absolute Dates tab clicked, Interval = Aggregate, Dec 06 – Dec 12, 2024 | Both calendars on DECEMBER 2024 with range-start 6 / range-end 12 |
| 10 | Selected Threads New Followers, Threads Engagements, Threads Posts, Threads Engagement Rate, Threads Views | All five `aria-checked=true` |
| 11 | Deselected Show Metrics Graphs | true → false |
| 12 | Run Report | Story `#story/time_window_comparison/161737`, header `(Dec 6, 2024 - Dec 12, 2024)` |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 12 | Threads New Followers (TWC) = Follower Growth (Insights) | Insights 13 · TWC 13 | PASS |
| A2 | 12 | Threads Posts = New Posts | Insights 9 · TWC 9 | PASS |
| A3 | 12 | Threads Engagements = Engagements | Insights 369 · TWC 369 | PASS |
| A4 | 12 | Threads Engagement Rate = Engagement Rate | Insights 2.52% · TWC 2.52% | PASS |
| A5 | 12 | Threads Views = Views | Insights 14,635 (exact in `.count[title]`; tile text 14.6K) · TWC 14,635 | PASS |

Spec assertion 12 ("TWC and Brand Insights values match for the selected metrics"): all 5 match, Views digit-for-digit.

## Evidence
- Insights tile headings: Follower Growth 13(-86%), New Posts 9(–), Engagements 369(-34%), Engagement Rate 2.52%(+127%), Views 14.6K(+344%) with exact `title` 14,635. Also on page: Total Followers 74,123, Fan Growth Rate 0.02% (not part of the compared set).
- TWC aggregate tables (one per metric): New Followers 13 / Engagements 369 / Posts 9 / Engagement Rate 2.52% / Views 14,635.
- Screenshots in `.playwright-out/QA-100887/`: `02-insights-brand-dropdown.png`, `03-insights-threads-values.png`, `04-insights-header-toggle.png` (Authorized data, Threads, date range), `05-twc-brand-added.png`, `06-twc-perspective.png`, `07-twc-dates.png`, `08-twc-ready.png`, `09-twc-report.png`.
- Results are identical to the 2026-10-20 run (13 / 9 / 369 / 2.52% / 14,635), so the Dec 2024 data is stable.

## Notes
- The case states no perspective for the Insights step. Insights was on Authorized (URL `perspective=extended`, UI toggle Authorized data) to match TWC step 8.
- Insights brand search box is found via `getByPlaceholder('Search for a Brand')` (not a `.brand-selector-dropdown-container input`); options are `.lfm-ta-option`.
- The default Insights brand for UCLA was already University of California, Los Angeles; the dropdown selection was still performed per spec.
- The Insights date overlay's end calendar jumps to Dec 2025 after the start click; 12 `th.prev` clicks return it to Dec 2024.
- Profile menu trigger is the `LFQA` header item (clicking the `ACCOUNT:` breadcrumb does not open it).
- Playwright `run_code_unsafe` sandbox has no `require`/`import`, so credentials had to be typed literally into the login call.

## Known bugs checked
- Case "Open linked bugs": none open (Rule 7 screen passed). bug-history.md and known-quirks.md: no QA-100887 match (pre-fetched). Threads Insights renderer-freeze quirk (brand-channels-threads skill) did not occur. No bug interfered with the assertions.

## Bugs filed
None.

## Cleanup
None needed (read-only; TWC story 161737 left as a saved report).
