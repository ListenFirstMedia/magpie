# QA-30670 — Brand Insights Cross-Channel Public Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-29, unattended headless (Playwright MCP), env app.lfmdev.in / app-reporting.lfmdev.in
- Account: Viacom (account_id=181). Login as lfiqa landed on account_id=863; switched via profile dropdown (hover `LFQA` header) > `Search Account`, typed "Viacom" slowly, clicked the `.lfm-ta-option` under `Results`. Breadcrumb showed `ACCOUNT: VIACOM`.
- Window used on both sides: 2026-10-21 to 2026-10-27 (the Insights default window today; TWC set to the same absolute dates).

## Steps executed
1. Brand (hover) -> Insights submenu link. Landed on `#explore/brand/insights?brand_id=4018&account_id=181...` (MTV, Authorized view by default, `#perspective` checked=true).
2. Opened the brand selector (real mouse click on `.brand-selector .icon-container` chevron, not the adjacent favorite-heart button). The search box is `textarea[placeholder="Search for a Brand"]` (a hidden `textarea[placeholder=Current]` also exists; do not use it). Typed "MTV" slowly; results listed exact `MTV` first (then MTV (Africa), MTV (Argentina), ...); clicked exact `MTV`. Clicked the View toggle (`label[for="perspective"]`): checked true -> false, URL `perspective=extended` -> `perspective=standard`, brand_id 4018 -> 10765, name still "MTV" (Public Data).
3. Channel selector: Facebook, Twitter, Instagram, TikTok all `channel-ghost ... enabled`; Apply disabled (nothing pending); URL `channels=` carries all four.
4. Tile read: `Public Video Views: 6.27M(-44%)`, exact value from `.count[title]` = **6,271,313** (Date Range Oct. 21, 2026 - Oct. 27, 2026).
5-6. Reporting menu -> "Time Window Comparison" (the menu has no item labelled "Classic Reporting": Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics / Affinities; TWC is the TWC template).
7. "Add Brand By Name": typed "MTV" slowly, clicked the exact `MTV` `.al-typeahead__option`. Per-brand View toggle `#0-perspective-toggle` unchecked with the knob on the Public Data side (visually confirmed in `09-twc-brand-added.png`) and a `Use Authorized Data` button offered (confirms Public mode; not clicked).
8. Absolute Dates active; Interval = Aggregate (`.lfm-option-label` "Aggregate"); Start Oct 21, End Oct 27, 2026 (explicitly clicked; `td.day.active` 21 `range-start` / 27 `range-end`, both OCTOBER 2026).
9. Clicked By Channel (`button.al-view-switcher__option`).
10. Filtered "Public Video Views" in `#filter-metrics-search-bar` and checked exactly Facebook, Twitter, Instagram, TikTok > Video > Public Video Views (`aria-checked=true` on those four only); Cross-Channel Public Video Views and all three "Average Public Video Views" leaves left unchecked.
11. Unchecked "Show Metrics Graphs" (`aria-checked` true -> false).
12. Run Report -> story `#story/time_window_comparison/161992` (Oct 21, 2026 - Oct 27, 2026), one table per channel; summed.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights cross-channel Public Video Views == sum of the TWC channel Public Video Views | Insights 6,271,313; TWC sum 399,612 (FB) + 17,554 (TW) + 2,716,902 (IG) + 3,137,245 (TT) = 6,271,313; difference 0 | PASS |

## Evidence
- Insights tile `Public Video Views: 6.27M(-44%)`, count title `6,271,313` (`.playwright-out/QA-30670/06-insights-tile.png`; MTV typeahead `03-mtv-typed.png`; Public toggle `05-public-toggled.png`).
- TWC: landing `07-twc-landing.png`; brand typeahead `08-twc-mtv-typed.png`; brand added + Public toggle `09-twc-brand-added.png`; interval `10-interval-open.png`; dates `11-dates.png`; By Channel `12-by-channel.png`; metrics `13-metrics-selected.png`; graphs off `14-graphs-off.png`; story `15-story.png`.
- TWC result (story 161992):
  - Facebook Public Video Views: MTV 399,612
  - Twitter Public Video Views: MTV 17,554
  - Instagram Public Video Views: MTV 2,716,902
  - TikTok Public Video Views: MTV 3,137,245
  - Sum: 6,271,313

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-30670 (pre-fetched). No bug reproduced that affects the assertion.

## Notes / observations (not failures)
- Insights value differs from the 2026-10-28 run (9,705,829) because the default window shifted to Oct 21-27 (and the tile now shows -44% vs. prior period); the Insights == TWC-sum equality holds on every run date.
- Spec step 5 says "Classic Reporting"; the Reporting menu has no such item. TWC used (same as 2026-10-26/27/28 runs).
- Brand selector DOM quirk: the dropdown search box is a `textarea` (placeholder "Search for a Brand"), not an `input`; an `input[placeholder="Search for a Brand"]` locator times out. The favorite-heart button was not touched this run.
- TWC landing page needed ~10s before the form rendered; story tables filled within ~25s. No render-hang.

## Bugs filed
- None (markdown-only; no Jira tickets created).
