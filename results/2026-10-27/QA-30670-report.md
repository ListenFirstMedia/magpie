# QA-30670 — Brand Insights Cross-Channel Public Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-27, unattended headless (Playwright MCP), env app.lfmdev.in / app-reporting.lfmdev.in
- Account: Viacom (account_id=181). Login as lfiqa landed on Michael Kors; switched via the account typeahead (typed "Viacom", confirmed a `Results` header, clicked the exact `Viacom` entry). Header showed `ACCOUNT: VIACOM`.
- Window used on both sides: 2026-10-19 to 2026-10-25 (the Insights default window; TWC set to the same absolute dates).

## Steps executed
1. Brand (hover) -> Insights (visible submenu link). Landed on `#explore/brand/insights?brand_id=4018&account_id=181...` (MTV, Authorized view by default).
2. Opened the brand selector, typed "MTV" slowly, results listed with the exact `MTV` first (above MTV (Africa), MTV (FB) etc.); clicked the exact `MTV` entry (brand_id 4018). Clicked the View toggle `#perspective` (checked = Authorized) -> unchecked = Public Data; URL became `perspective=standard`, brand_id 4018 -> 10765, brand name still "MTV". (A first label-click attempt timed out because the checkbox input intercepted it; moved the mouse off the nav and clicked `#perspective` directly.)
3. Channel selector (`[data-ui-name="channel_selector"]`): Facebook, Twitter, Instagram, TikTok all `enabled`; Apply was disabled (nothing pending); URL `channels=` carries all four.
4. Read the tile: `Public Video Views: 9.89M(+<1%)`, exact value from `.count[title]` = **9,890,173**.
5-6. Reporting menu -> "Time Window Comparison" (there is no menu item labelled "Classic Reporting"; the Reporting menu lists Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics. TWC is the TWC template).
7. Added brand: typed "MTV" in the Add Brand By Name box, clicked the exact `MTV` list item (not "MTV (FB)" etc.). The per-brand View toggle `#0-perspective-toggle` was unchecked, knob on the Public Data side (screenshot 03); a `Use Authorized Data` button was offered, confirming Public mode. Not clicked.
8. Absolute Dates (active); Interval = Aggregate; Start = Oct 19, End = Oct 25, 2026 (calendar `td.active` 19 / 25, both OCTOBER 2026).
9. Clicked By Channel.
10. Filtered "Public Video Views" and checked exactly: Facebook > Video > Public Video Views, Twitter > ..., Instagram > ..., TikTok > ... (verified `aria-checked=true` + `fa-check-square`; counters Facebook 1/2, Twitter 1/1, Instagram 1/2, TikTok 1/1, Cross-Channel 0/2; the "Average Public Video Views" metrics and the Cross-Channel leaf left unchecked).
11. Unchecked "Show Metrics Graphs" (`aria-checked` true -> false).
12. Run Report -> story `#story/time_window_comparison/161826` (Oct 19, 2026 - Oct 25, 2026), one table per channel; summed.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights cross-channel Public Video Views == sum of the TWC channel Public Video Views | Insights 9,890,173; TWC sum 1,286,803 (FB) + 14,964 (TW) + 5,048,277 (IG) + 3,540,129 (TT) = 9,890,173; difference 0 | PASS |

## Evidence
- Insights tile: `Public Video Views: 9.89M(+<1%)`, count title `9,890,173` (`.playwright-out/QA-30670/01-insights-public-4ch.png`).
- Brand typeahead: `01c-mtv-typed.png`. TWC brand added + Public toggle: `03-twc-brand-added.png`; interval `04-twc-interval.png`; dates `05-twc-dates.png`; metrics `06-twc-metrics-selected.png`; graphs off `07-twc-graphs-off.png`.
- TWC result (`08-twc-story-161826.png`):
  - Facebook Public Video Views: MTV 1,286,803
  - Twitter Public Video Views: MTV 14,964
  - Instagram Public Video Views: MTV 5,048,277
  - TikTok Public Video Views: MTV 3,540,129
  - Sum: 9,890,173

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-30670 (pre-fetched). No bug reproduced that affects the assertion.

## Notes / observations (not failures)
- Step 2 View toggle: `#perspective` checked = Authorized on this page; clicking switches the brand to its public-data counterpart (brand_id 4018 -> 10765). The label element is overlapped by the checkbox input; click `#perspective` itself after moving the mouse away from the nav.
- Spec step 5 says "Classic Reporting"; the current Reporting menu has no such item. TWC used (same as the 2026-10-26 run).
- TWC brand search box is now "Add Brand By Name" (textbox "Search for a Brand"); options are `listitem`s rather than `.al-typeahead__option`.
- The 2026-10-26 run saw a CORS fall-back on Run Report; it did not recur today (story 161826 loaded directly).

## Bugs filed
- None (markdown-only; no Jira tickets created).
