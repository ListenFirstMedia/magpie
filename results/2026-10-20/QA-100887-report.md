# QA-100887 — Brand > Insights VS TWC Threads

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in / app-reporting.lfmdev.in
**Account:** UCLA (switched from default VIACOM via profile menu; header showed `ACCOUNT: UCLA`, account_id=799)
**Brand:** University of California, Los Angeles (exact typeahead match, Rule 1) · **Channel:** Threads only · **Range:** Dec 06, 2024 – Dec 12, 2024 · **Perspective:** Authorized on both sides

## Verdict: PASS

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (config/.env) and switch account VIACOM → UCLA via Search Account → `Results` item | Done; `ACCOUNT: UCLA` confirmed |
| 1 | Brand → Insights (top nav hover → Insights link) | Done; `#explore/brand/insights` |
| 2 | Click Brand dropdown | Done |
| 3 | Select exact `University of California, Los Angeles` (not "… Police") | Done; header shows the brand |
| 4 | Channels: click Threads icon, Apply | URL `channels=threads` only |
| 5 | Date range Dec 06 – Dec 12, 2024 via picker (calendar nav + Ok) | Header `Dec. 06, 2024 - Dec. 12, 2024`; URL `from=2024-12-06&to=2024-12-12` |
| 6 | Note values (View toggle visually confirmed on **Authorized data**) | See table below |
| 7 | Reporting → Time Window Comparison | Done |
| 8 | Add brand `University of California, Los Angeles`, clicked per-brand toggle to Authorized | `0-perspective-toggle` checked=true |
| 9 | Absolute Dates tab clicked, Interval = Aggregate, Dec 06 – Dec 12, 2024 | Both calendars show range-start 6 / range-end 12 (Dec 2024) |
| 10 | Selected Threads New Followers, Engagements, Posts, Engagement Rate, Views | All five aria-checked=true |
| 11 | Deselected Show Metrics Graphs | `Show Metrics Graphs:false` (Tables left true) |
| 12 | Run Report | Story `#story/time_window_comparison/161410`, header `(Dec 6, 2024 - Dec 12, 2024)` |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 12 | Threads New Followers (TWC) = Follower Growth (Insights) | Insights 13 · TWC 13 | PASS |
| A2 | 12 | Threads Posts = New Posts | Insights 9 · TWC 9 | PASS |
| A3 | 12 | Threads Engagements = Engagements | Insights 369 · TWC 369 | PASS |
| A4 | 12 | Threads Engagement Rate = Engagement Rate | Insights 2.52% · TWC 2.52% | PASS |
| A5 | 12 | Threads Views = Views | Insights 14.6K (abbreviated) · TWC 14,635 (rounds to 14.6K) | PASS |

Per spec assertion 12 ("TWC and Brand Insights values match for the selected metrics"): all 5 match.

## Evidence
- Insights tiles: Follower Growth 13 (-86%), New Posts 9, Engagements 369 (-34%), Engagement Rate 2.52% (+127%), Views 14.6K (+344%). Daily Follower Growth bars (11, -17, -21, -9, 22, 17, 10) sum to 13, consistent with the tile.
- TWC aggregate tables (one per metric): 13 / 369 / 9 / 2.52% / 14,635.
- Screenshots in `.playwright-out/QA-100887/`: `08-insights-top.png`, `09-view-toggle.png` (Authorized data selected, range + channel), `07-insights-values.png`, `11-twc-builder-ready.png`, `12-twc-report.png`.

## Notes
- Insights Views is only shown abbreviated (14.6K); exact comparison to 14,635 is by rounding, not digit-for-digit.
- The case does not state a perspective for the Insights step. Insights was on Authorized (URL `perspective=extended`, UI toggle Authorized data) to match TWC step 8.
- Insights brand dropdown: typing in `.brand-selector-dropdown-container` with `pressSequentially` filtered the list; the option is `.lfm-ta-option`. The Insights date overlay's end calendar jumps to Dec 2025 after the start click and needs 12 `th.prev` clicks to return to Dec 2024.
- TWC brand typeahead required the React value-setter + InputEvent (consistent with skill v7).

## Known bugs checked
- Case "Open linked bugs": none open. bug-history.md and known-quirks.md: no QA-100887 match (pre-fetched). No bug interfered with the assertions.

## Bugs filed
None.

## Cleanup
None (read-only; TWC story 161410 left as a saved report).
