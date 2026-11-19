# QA-31572 — Brand Insight vs Classic Reports > Data Test > Impressions

**Run date:** 2026-11-17 (headless, unattended `claude -p`, Playwright MCP) — dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account / Brand:** Amazon Prime Video (account_id=342, brand_id=25864) — exact-match brand from the typeahead / account results (Rule 1; not "…India" or any country variant)
**Date range:** Nov 9, 2026 – Nov 15, 2026 (Insights default week; TWC absolute range set to the same)
**Verdict: PASS** — Insights Impressions (Facebook + Twitter + Instagram, Authorized) = **223,235,646** = TWC sum 110,030,405 + 5,984,646 + 107,220,595 = **223,235,646**.

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Log in (Cognito "With existing account"); landed on Adam Orfei; switched account via LFQA menu → Search Account → `.lfm-ta-option` "Amazon Prime Video" | ✅ breadcrumb `ACCOUNT: AMAZON PRIME VIDEO` |
| 1 | Hover Brand → Insights | ✅ `#explore/brand/insights?brand_id=25864&account_id=342&from=2026-11-09&to=2026-11-15…` |
| 2 | Enable Facebook, Twitter, Instagram only | ✅ TikTok was on by default; opened channel selector, clicked `.channel-ghost.tiktok` off → Apply. URL `channels=twitter&channels=instagram&channels=facebook`; `.channel-ghost.enabled` = facebook/twitter/instagram only |
| 3 | Note Impressions big number | ✅ tile "Impressions: 223M (-14%)", exact `.count[title]` = **223,235,646**. View toggle screenshot shows **Authorized data** selected (Rule 2) |
| 4–5 | Reporting → Time Window Comparison (menu has no item literally named "Classic Reporting": Home / Dashboards / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics) | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` |
| 6 | Add Amazon Prime Video brand (Authorized) | ✅ typed "Amazon Prime", clicked the exact `Amazon Prime Video` option (first entry; not a country variant). Row toggle defaulted to Public (`#0-perspective-toggle` unchecked); clicked `label[for="0-perspective-toggle"]` → checked = true (Authorized) |
| 7 | Absolute Dates + Aggregate interval | ✅ clicked Absolute Dates, Interval dropdown → Aggregate, Start = Nov 9, End = Nov 15 2026 (explicitly clicked; `td.active` = 9 / 15) |
| 8 | By Channel | ✅ |
| 9 | Select Facebook Page Impressions, Twitter Organic Post Impressions, Instagram Post Impressions | ✅ resolved via ancestor `<details>`: Facebook › Impressions & Reach › Page Impressions; Twitter › Impressions & Reach › Organic Post Impressions; Instagram › Impressions & Reach › Post Impressions — exactly these 3 `aria-checked=true` (other same-named leaves, e.g. Twitter › Paid › Post Impressions and Instagram › Page/Organic Post Impressions, left unchecked) |
| 10 | Run Report | ✅ `#story/time_window_comparison/162856`, rendered in ~15 s, header "(Nov 9, 2026 - Nov 15, 2026)" |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Sum of the selected report values == Brand Insights Impressions | Facebook Page Impressions 110,030,405 + Twitter Organic Post Impressions 5,984,646 + Instagram Post Impressions 107,220,595 = 223,235,646; Insights Impressions = 223,235,646 (diff 0) | ✅ PASS |

## Evidence
- Insights tile exact value: `.tile .count[title]` = "223,235,646" (visible "223M"), FB+TW+IG, Authorized, Nov 9–15 2026. Screenshots: `.playwright-out/QA-31572/02-insights-3channels.png` (shows Authorized data selected, channels FB/X/IG highlighted)
- TWC builder: `04-twc-typeahead.png`, `05-twc-authorized.png`, `06-twc-dates.png`, `07-twc-metrics.png`
- TWC report (story 162856): `10-twc-report.png`; tables: "Brand | Facebook Page Impressions | Amazon Prime Video | 110,030,405", "Brand | Twitter Organic Post Impressions | Amazon Prime Video | 5,984,646", "Brand | Instagram Post Impressions | Amazon Prime Video | 107,220,595"
- Arithmetic: 110,030,405 + 107,220,595 = 217,251,000; + 5,984,646 = 223,235,646.
- Data Last Updated (PT) banner: 11-16-2026 03:51 PM.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md has no entry for QA-31572. No known bug linked.
- Observations that did not touch the assertion: on Insights the *Total Followers* tile showed "This tile failed to load" (Reload) on first render — unrelated to the Impressions tile, which loaded and was read. Console showed some app errors (not related to the report values). The 2026-10-26 run's TWC story-render failure (CORS on `domain-api.lfmdev.in/stories/*`) did **not** reproduce today.

## Bugs filed
None.

## Cleanup
None required for the case itself (read-only compare). One throwaway TWC story was generated on dev (162856) by running the report.
