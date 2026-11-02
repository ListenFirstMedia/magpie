# QA-30670 — Brand Insights Cross-Channel Public Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-26, unattended headless (Playwright MCP), env app.lfmdev.in / app-reporting.lfmdev.in
- Account: Viacom (account_id=181), switched from Michael Kors via the profile menu (typed "Viacom", clicked the exact `Results` entry).
- Window used on both sides: 2026-10-18 to 2026-10-24 (the Insights default window; TWC set to the same absolute dates).

## Steps executed
1. Login: lfiqa account. First sign-in attempt hit a Cognito `PreAuthentication ... Task timed out after 3.00 seconds` error (transient lambda cold start); one retry succeeded. Switched account Michael Kors -> Viacom (header showed `ACCOUNT: VIACOM`, URL `account_id=181`).
2. Brand (hover) -> Insights. Opened the brand selector, typed "MTV", clicked the exact `MTV` entry (first of the results; not "MTV (FB)" etc.). Clicked the View toggle `#perspective` (was checked = Authorized) -> unchecked = Public Data; URL became `perspective=standard`, brand_id 4018 -> 10765, brand name still "MTV".
3. Opened the channel selector (`[data-ui-name="channel_selector"]`); Facebook, Twitter, Instagram, TikTok all `enabled`; clicked Apply. URL `channels=` carries all four.
4. Read the tile: `Public Video Views: 10.2M(-12%)`, exact value from `.count[title]` = **10,243,170**.
5-6. Reporting menu -> "Time Window Comparison" (see Notes: there is no menu item labelled "Classic Reporting"; TWC is the TWC template).
7. Added brand: typed "MTV" in `input.al-typeahead__text-input`, clicked the exact `MTV` option. The per-brand View toggle (`#0-perspective-toggle`) was unchecked with the knob on the Public Data side (screenshot 03); a `Use Authorized Data` button was shown, confirming Public mode. Not clicked, since clicking would have flipped it to Authorized.
8. Absolute Dates; Interval = Aggregate; Start = Oct 18, End = Oct 24, 2026.
9. Clicked By Channel.
10. Filtered "Public Video Views" and checked exactly: Facebook > Video > Public Video Views, Twitter > ..., Instagram > ..., TikTok > ... (verified via `aria-checked` / `fa-check-square`; summary counters Facebook 1/2, Twitter 1/1, Instagram 1/2, TikTok 1/1, Cross-Channel 0/2; "Average Public Video Views" left unchecked).
11. Unchecked "Show Metrics Graphs" (`aria-checked` true -> false).
12. Run Report -> story `#story/time_window_comparison/161735` (Oct 18, 2026 - Oct 24, 2026), one table per channel; summed.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights cross-channel Public Video Views == sum of the TWC channel Public Video Views | Insights 10,243,170; TWC sum 1,308,592 (FB) + 18,147 (TW) + 5,185,833 (IG) + 3,730,598 (TT) = 10,243,170; difference 0 | PASS |

## Evidence
- Insights tile: `Public Video Views: 10.2M(-12%)`, count title `10,243,170` (`.playwright-out/QA-30670/01-insights-public-4ch.png`).
- TWC Public toggle: `.playwright-out/QA-30670/03-twc-toggle-default.png`; dates `04-twc-dates.png`; metrics `05-twc-metrics-selected.png`; graphs off `06-twc-graphs-off.png`.
- TWC result (`08-twc-story-161735.png`):
  - Facebook Public Video Views: MTV 1,308,592
  - Twitter Public Video Views: MTV 18,147
  - Instagram Public Video Views: MTV 5,185,833
  - TikTok Public Video Views: MTV 3,730,598
  - Sum: 10,243,170

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-30670. No bug reproduced that affects the assertion.

## Notes / observations (not failures)
- The step 2 View toggle: `#perspective` checked = Authorized on this page; clicking switches the brand to its public-data counterpart (brand_id 4018 -> 10765).
- On Run Report the app navigated to the story, then `GET domain-api.lfmdev.in/stories/161735` failed with a CORS error and the app fell back to a blank builder (state reset). The saved story loaded fine on re-navigating to the app-generated URL `#story/time_window_comparison/161735` (used it to read the result). Environment flake worth a look; it did not affect the data.
- Spec step 5 says "Classic Reporting"; the Reporting menu now lists Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics. TWC used.
- Cognito PreAuthentication lambda 3s timeout on first sign-in (transient).

## Bugs filed
- None (markdown-only; no Jira tickets created).
