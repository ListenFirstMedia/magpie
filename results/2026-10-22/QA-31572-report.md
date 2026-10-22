# QA-31572 — Brand Insight vs Classic Reports > Data Test > Impressions

**Run date:** 2026-10-22 (headless, unattended `claude -p`, Playwright MCP) — dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account / Brand:** Amazon Prime Video (account_id=342, brand_id=25864) — exact-match brand picked from the typeahead (Rule 1)
**Date range:** Oct 14, 2026 – Oct 20, 2026 (Insights default week; TWC absolute range set to the same)
**Verdict: PASS — Brand Insights Impressions (FB+TW+IG, Authorized) = 193,540,575 == sum of the three Classic/TWC report values = 193,540,575**

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Log in (Cognito "With existing account"), switch account to Amazon Prime Video via LFQA profile menu → Search Account → Results item | ✅ breadcrumb `ACCOUNT: AMAZON PRIME VIDEO`. First post-switch load hung on "Loading..." ~25s; one navigate to `app.lfmdev.in` recovered it |
| 1 | Brand (hover) → Insights | ✅ `#explore/brand/insights?brand_id=25864&account_id=342…` |
| 2 | Enable Facebook, Twitter, Instagram only | ✅ page loaded with 4 channels (TikTok on); clicked `.channel-ghost.tiktok` off → Apply; URL `channels=twitter&channels=instagram&channels=facebook`; DOM `.channel-ghost.enabled` = facebook/twitter/instagram only. View toggle visually confirmed on **Authorized data** (screenshot 02) |
| 3 | Note Impressions big number | ✅ tile "Impressions: 194M(+<1%)", exact `.count[title]` = **193,540,575** |
| 4–5 | Reporting → Time Window Comparison (the TWC template; there is no menu item literally named "Classic Reporting" — Reporting menu = Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics) | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` |
| 6 | Add Amazon Prime Video brand (Authorized) | ✅ typed name + Enter, clicked exact `Amazon Prime Video` option (not the country variants). Row View toggle defaulted to Public; clicked the toggle label (`label[for=0-perspective-toggle]`) → checkbox `checked=true`, knob on Authorized, helper button flipped to "Use Public Data" (screenshots 06–07b). Note: a first click on the `.al-toggle` wrapper did NOT flip it — click the label |
| 7 | Absolute Dates + Aggregate interval | ✅ clicked Absolute Dates; Interval → Aggregate (`.lfm-dropdown-option`); calendars `range-start`=14, `range-end`=20 (Oct 2026) |
| 8 | By Channel | ✅ |
| 9 | Select Facebook Page Impressions, Twitter Organic Post Impressions, Instagram Post Impressions | ✅ via Filter Metrics "Impressions"; `aria-checked=true` on exactly those three (Facebook › Page Impressions, Twitter › Organic Post Impressions, Instagram › Post Impressions) |
| 10 | Run Report | ✅ story `#story/time_window_comparison/161556`, title "Amazon Prime Video — Time Window Comparison (Oct 14, 2026 – Oct 20, 2026)" |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Sum of the selected report values == Brand Insights Impressions | 102,038,295 (FB Page Impressions) + 6,400,469 (TW Organic Post Impressions) + 85,101,811 (IG Post Impressions) = **193,540,575** == Insights **193,540,575** (diff 0) | ✅ PASS |

## Evidence
- Insights tile exact value: `.tile .count[title]` = "193,540,575" (visible text "194M"), channels FB+TW+IG, Authorized, Oct 14–20 2026. Screenshots: `.playwright-out/QA-31572/01-insights-landing.png`, `02-insights-3channels.png`
- TWC builder: `03`–`09` PNGs (brand typeahead, Authorized toggle, Aggregate + Oct 14–20, By Channel filter)
- TWC result tables (one per metric): Facebook Page Impressions 102,038,295 · Twitter Organic Post Impressions 6,400,469 · Instagram Post Impressions 85,101,811 — `.playwright-out/QA-31572/10-twc-report.png`
- Arithmetic: 102,038,295 + 6,400,469 = 108,438,764; + 85,101,811 = 193,540,575

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md has no entry for QA-31572. No bug reproduced or interfered with the assertion.
- Environment note: status banner on dev showed "Facebook Posts Insights Disruption (+1 more incident)"; Facebook values nevertheless matched exactly, so it did not affect the verdict.

## Notes (mechanics worth keeping for skills — maintenance deferred to harvest.sh)
- Spec says "Classic Reporting"; in the current nav that is Reporting → **Time Window Comparison** (TWC template).
- Insights "Impressions" tile exposes exact value in `.count[title]`.
- TWC brand search: typeahead options only render after typing + Enter; option class `.al-typeahead__option`.
- TWC brand-row perspective toggle: click `label[for="0-perspective-toggle"]` (the hidden checkbox/wrapper click is a no-op); default is Public.
- TWC By Channel tree: use Filter Metrics (`#filter-metrics-search-bar`) then click the metric text inside the target `li`; verify with `[aria-checked]`.
- After an account switch the app can sit on "Loading..." — a fresh `navigate('https://app.lfmdev.in')` recovers.

## Bugs filed
None.

## Cleanup
Read-only; a report story (161556) was created on dev (harmless).
