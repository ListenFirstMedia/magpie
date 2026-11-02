# QA-30670 — Brand Insights Cross-Channel Public Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-28, unattended headless (Playwright MCP), env app.lfmdev.in / app-reporting.lfmdev.in
- Account: Viacom (account_id=181). Login as lfiqa landed on account_id=54; switched via profile dropdown > Search Account, typed "Viacom" slowly, clicked the entry under `Results` (`.item-list-wrapper`). Breadcrumb showed `ACCOUNT: VIACOM`.
- Window used on both sides: 2026-10-20 to 2026-10-26 (the Insights default window; TWC set to the same absolute dates).

## Steps executed
1. Brand (hover) -> Insights submenu link. Landed on `#explore/brand/insights?brand_id=4018&account_id=181...` (MTV, Authorized view by default).
2. Opened the brand selector (real mouse click on the chevron at the brand name; a `.click()` via locator did not open it), typed "MTV" slowly; results listed with exact `MTV` first (above MTV (Africa), MTV (FB), ...); clicked the exact `MTV` entry (brand_id 4018). Clicked the View toggle `#perspective` (checked=Authorized -> unchecked=Public Data); URL became `perspective=standard`, brand_id 4018 -> 10765, name still "MTV".
3. Channel selector: Facebook, Twitter, Instagram, TikTok `channel-ghost ... enabled`; Apply disabled (nothing pending); URL `channels=` carries all four.
4. Tile read: `Public Video Views: 9.71M(+5%)`, exact value from `.count[title]` = **9,705,829**.
5-6. Reporting menu -> "Time Window Comparison" (the menu has no item labelled "Classic Reporting": Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics; TWC is the TWC template).
7. "Add Brand By Name": typed "MTV", clicked the exact `MTV` list item. Per-brand View toggle knob on the Public Data side and a `Use Authorized Data` button offered (confirms Public mode; not clicked).
8. Absolute Dates active; Interval = Aggregate; Start Oct 20, End Oct 26, 2026 (explicitly clicked; `td.day.active` 20 / 26, both OCTOBER 2026).
9. Clicked By Channel.
10. Filtered "Public Video Views" and checked exactly Facebook, Twitter, Instagram, TikTok Public Video Views (`aria-checked=true` + `fa-check-square`); Cross-Channel leaf and all "Average Public Video Views" leaves left unchecked.
11. Unchecked "Show Metrics Graphs" (`aria-checked` true -> false).
12. Run Report -> story `#story/time_window_comparison/161906` (Oct 20, 2026 - Oct 26, 2026), one table per channel; summed.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights cross-channel Public Video Views == sum of the TWC channel Public Video Views | Insights 9,705,829; TWC sum 1,232,335 (FB) + 15,742 (TW) + 5,178,535 (IG) + 3,279,217 (TT) = 9,705,829; difference 0 | PASS |

## Evidence
- Insights tile `Public Video Views: 9.71M(+5%)`, count title `9,705,829` (`.playwright-out/QA-30670/05-insights-tile.png`; Public toggle `03-public-toggled.png`; channels `04-insights-public-channels.png`).
- Brand typeahead `02-mtv-typed.png`; TWC brand added + Public toggle `08-twc-brand-added.png`; interval `10-interval-aggregate.png`; dates `11-dates.png`; metrics `13-metrics-selected.png`; graphs off `14-graphs-off.png`.
- TWC result (`16-story-161906.png`):
  - Facebook Public Video Views: MTV 1,232,335
  - Twitter Public Video Views: MTV 15,742
  - Instagram Public Video Views: MTV 5,178,535
  - TikTok Public Video Views: MTV 3,279,217
  - Sum: 9,705,829

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-30670 (pre-fetched). No bug reproduced that affects the assertion.

## Notes / observations (not failures)
- Side effect during the run: while hunting for the brand search box, an unlabeled button next to the brand name was clicked; it is the **favorite-brand heart** and it toggled MTV's favorite state (empty -> filled). Several further clicks did not visibly flip the icon in-session, but after a page reload the heart rendered empty (original state) — verified by `01f-heart-reload.png`. No persistent change observed. The brand selector opener is `.brand-selector-dropdown-container` chevron (real mouse click at the chevron), NOT the adjacent heart button.
- Insights data values differ from the 2026-10-27 run (9,890,173) because the default window shifted to Oct 20-26; the Insights == TWC-sum equality holds on both days.
- Spec step 5 says "Classic Reporting"; the Reporting menu has no such item. TWC used (same as 2026-10-26/27 runs).
- TWC page showed a "Loading..." spinner ~20s on first landing; story tables took a few extra seconds to fill. No render-hang.

## Bugs filed
- None (markdown-only; no Jira tickets created).
