# QA-100887 — Brand > Insights VS TWC Threads

**Run date:** 2026-10-27 · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in / app-reporting.lfmdev.in
**Account:** UCLA (switched from default Amazon Prime Video via profile menu "LFQA" → Search Account → `Results` item "UCLA"; header showed `ACCOUNT: UCLA`, account_id=799)
**Brand:** University of California, Los Angeles (exact typeahead match, Rule 1; the other result "… Police" was not used) · **Channel:** Threads only · **Range:** Dec 06, 2024 – Dec 12, 2024 · **Perspective:** Authorized on both sides

## Verdict: PASS

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (config/.env, "With existing account") and account switch Amazon Prime Video → UCLA | Done; `ACCOUNT: UCLA` confirmed |
| 1 | Brand → Insights (top-nav hover → Insights link) | Done; `#explore/brand/insights?brand_id=127756` |
| 2 | Click Brand dropdown | Opened "Search for a Brand" panel |
| 3 | Select exact `University of California, Los Angeles` | Typeahead returned 2 options (UCLA, UCLA Police); clicked exact match; `brand_id=127756` |
| 4 | Channels: click Threads icon, Apply | Only `.channel-ghost.threads` enabled; URL `channels=threads` only |
| 5 | Date range Dec 06 – Dec 12, 2024 via picker (22 `th.prev` clicks on start calendar, day 6; end calendar jumped to Dec 2025, 12 `th.prev`, day 12; Ok) | URL `from=2024-12-06&to=2024-12-12` |
| 6 | Note values; View toggle visually confirmed on **Authorized data** (screenshot 04b) | See assertions table |
| 7 | Reporting → Time Window Comparison | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 8 | Add brand `University of California, Los Angeles` (exact result); per-brand toggle defaulted to Public (`0-perspective-toggle` checked=false), clicked to Authorized | checked=true; screenshot 06 shows knob on "Authorized Data" |
| 9 | Absolute Dates tab clicked, Interval Days → Aggregate, Dec 06 – Dec 12, 2024 | Both calendars paged to DECEMBER 2024. After the start click the End calendar jumped to Oct 2026 and my first "12" click landed on Oct 12, 2026 (caught in screenshot 07); End calendar paged back 22 months and day 12 re-selected → start=6, end=12 both in Dec 2024 |
| 10 | Selected Threads New Followers, Threads Engagements, Threads Posts, Threads Engagement Rate, Threads Views | All five `isChecked=true` |
| 11 | Deselected Show Metrics Graphs | true → false |
| 12 | Run Report | Story `#story/time_window_comparison/161827`, header `(Dec 6, 2024 - Dec 12, 2024)` |

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
- Insights tile headings: Follower Growth 13 (-86%), New Posts 9 (–), Engagements 369 (-34%), Engagement Rate 2.52% (+127%), Views 14.6K (+344%) with exact `title` 14,635. Also on page, not part of the compared set: Total Followers 74,123, Fan Growth Rate 0.02%.
- TWC aggregate tables (one per metric): New Followers 13 / Engagements 369 / Posts 9 / Engagement Rate 2.52% / Views 14,635.
- Screenshots in `.playwright-out/QA-100887/`: `02-insights-brand-dropdown.png`, `02b-channel-selector.png`, `03b-after-start.png`, `03c-range-picked.png`, `04-insights-header-toggle.png`, `04b-insights-view-toggle.png`, `06-twc-perspective.png`, `07-twc-dates.png` (final, Dec 2024 / Dec 2024, 6 and 12), `08b-metrics-selected.png`, `08-twc-ready.png`, `09-twc-report.png`.
- Results are identical to the 2026-10-20 and 2026-10-26 runs (13 / 9 / 369 / 2.52% / 14,635), so the Dec 2024 data is stable.

## Notes
- The case states no perspective for the Insights step. Insights was on Authorized (URL `perspective=extended`, toggle `checked=true`, "Authorized data" highlighted) to match TWC step 8.
- Insights brand search box: `getByPlaceholder('Search for a Brand')`; options `.lfm-ta-option`.
- Date picker pitfalls, both pickers: day cells are `td.day` (not `td.available`); each calendar has several hidden `th.prev` (months/years/decades views), so use `th.prev:visible`. After a start-date click, the End calendar resets (Dec 2025 on Insights, Oct 2026 on TWC), so always re-read the End calendar's header before clicking the end day.
- TWC per-brand perspective defaults to Public (`#0-perspective-toggle` unchecked) even when Insights was on Authorized; the click is required.
- Metric checkboxes in TWC: `getByRole('listitem', {name: '<metric>', exact: true}).getByRole('checkbox')`; "Filter Metrics" textbox narrows the list.
- Profile menu trigger is the `LFQA` header item.

## Known bugs checked
- Case "Open linked bugs": none open (Rule 7 screen passed). bug-history.md and known-quirks.md: no QA-100887 match (pre-fetched). Threads Insights renderer-freeze quirk did not occur. No bug interfered with the assertions.

## Bugs filed
None.

## Cleanup
None needed (read-only; TWC story 161827 left as a saved report).
