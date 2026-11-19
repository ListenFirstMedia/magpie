# QA-31572 — Brand Insight vs Classic Reports > Data Test > Impressions

**Run date:** 2026-11-18 (headless, unattended `claude -p`, Playwright MCP) — dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account / Brand:** Amazon Prime Video (account_id=342, brand_id=25864) — exact-match entry from the typeahead Results (Rule 1; not "…India" or any country variant)
**Date range:** Nov 10, 2026 – Nov 16, 2026 (Insights default week; TWC absolute range set to the same)
**Verdict: PASS** — Insights Impressions (Facebook + Twitter + Instagram, Authorized) = **194,397,923** = TWC sum 88,411,650 + 6,486,928 + 99,499,345 = **194,397,923** (diff 0).

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Log in (Cognito "With existing account"); landed on Hulu; switched account via LFQA menu → Search Account → `.lfm-ta-option` "Amazon Prime Video" (not "…India") | ✅ breadcrumb `ACCOUNT: AMAZON PRIME VIDEO` (account_id=342) |
| 1 | Hover Brand → Insights | ✅ `#explore/brand/insights`. The page did NOT open on the spec brand: it defaulted to **Hulu** (brand_id=11003). Opened the brand dropdown, typed "Amazon Prime Video", clicked the exact first entry under the live results (not Recent Searches, not a country variant) → `brand_id=25864`, header "Amazon Prime Video" |
| 2 | Enable Facebook, Twitter, Instagram only | ✅ TikTok was on by default; clicked `.channel-ghost.tiktok` off → Apply. URL `channels=twitter&channels=instagram&channels=facebook`; `.channel-ghost.enabled` = facebook/twitter/instagram only |
| 3 | Note Impressions big number | ✅ tile "Impressions: 194M(-25%)", exact `.count[title]` = **194,397,923**. View toggle: `#perspective` checked and screenshot shows **Authorized data** selected (Rule 2; URL `perspective=extended`) |
| 4–5 | Reporting → Time Window Comparison (the TWC template; the Reporting menu has no item literally named "Classic Reporting": Home / Dashboards / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics) | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` |
| 6 | Add Amazon Prime Video brand (Authorized) | ✅ typed "Amazon Prime Video" in "Add Brand By Name", pressed Enter to open the options (the builder now says "search above and press Enter"; the options did not show until Enter), clicked the exact `Amazon Prime Video` option. Row toggle defaulted to Public (`#0-perspective-toggle` unchecked); clicked `label[for="0-perspective-toggle"]` → checked = true (Authorized) |
| 7 | Absolute Dates + Aggregate interval | ✅ clicked Absolute Dates, Interval dropdown → Aggregate, Start = Nov 10, End = Nov 16 2026 (explicitly clicked; `td.active` = 10 / 16) |
| 8 | By Channel | ✅ clicked the `By Channel` view-switcher option |
| 9 | Select Facebook Page Impressions, Twitter Organic Post Impressions, Instagram Post Impressions | ✅ resolved via ancestor `<details>`: Facebook › Impressions & Reach › Page Impressions; Twitter › Impressions & Reach › Organic Post Impressions; Instagram › Impressions & Reach › Post Impressions. Screenshot `07-twc-metrics.png` shows exactly these 3 checked (Twitter 1/5, Instagram 1/6; same-named leaves such as Twitter › Paid › Post Impressions and Instagram › Page/Organic Post Impressions left unchecked) |
| 10 | Run Report | ✅ `#story/time_window_comparison/162942`, rendered in ~18 s, header "(Nov 10, 2026 - Nov 16, 2026)" |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Sum of the selected report values == Brand Insights Impressions | Facebook Page Impressions 88,411,650 + Twitter Organic Post Impressions 6,486,928 + Instagram Post Impressions 99,499,345 = 194,397,923; Insights Impressions = 194,397,923 (diff 0) | ✅ PASS |

## Evidence
- Insights tile exact value: `.tile .count[title]` = "194,397,923" (visible "194M"), FB+TW+IG, Authorized, Nov 10–16 2026. Screenshots: `.playwright-out/QA-31572/02-insights-3channels.png` (shows Authorized data selected, channels FB/X/IG highlighted and TikTok off)
- Brand selection: `01f-brand-results.png` (Results list, exact "Amazon Prime Video" first)
- TWC builder: `04-twc-typeahead.png`, `05-twc-authorized.png`, `06-twc-dates.png`, `07-twc-metrics.png`, `08-pre-run.png`
- TWC report (story 162942): `10-twc-report.png`; tables: "Brand | Facebook Page Impressions | Amazon Prime Video | 88,411,650", "Brand | Twitter Organic Post Impressions | Amazon Prime Video | 6,486,928", "Brand | Instagram Post Impressions | Amazon Prime Video | 99,499,345"
- Arithmetic (checked in shell): 88,411,650 + 6,486,928 + 99,499,345 = 194,397,923.
- Data Last Updated (PT) banner: 11-17-2026 04:03 PM.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md has no entry for QA-31572. No known bug linked.
- Prior runs of this case: PASS 2026-10-22 and 2026-11-17; BLOCKED 2026-10-26 (TWC story render failure, CORS on `domain-api.lfmdev.in/stories/*`). That failure did **not** reproduce today.
- Observations that did not touch the assertion: the Insights page opens on Hulu (stale default brand) when the account is switched to Amazon Prime Video, so the brand must be picked explicitly. This matches the earlier "brand picker" behavior and is not a data defect. The console showed app errors unrelated to the report values.

## Bugs filed
None.

## Cleanup
None required for the case itself (read-only compare). One throwaway TWC story was generated on dev (162942) by running the report.
