# QA-31572 — Brand Insight vs Classic Reports > Data Test > Impressions

**Run date:** 2026-10-26 (headless, unattended `claude -p`, Playwright MCP) — dev `app.lfmdev.in` + `app-reporting.lfmdev.in`, user lfiqa
**Account / Brand:** Amazon Prime Video (account_id=342, brand_id=25864) — exact-match brand from the typeahead (Rule 1)
**Date range:** Oct 18, 2026 – Oct 24, 2026 (Insights default week; TWC absolute range set to the same)
**Verdict: BLOCKED — report-render failure at step 10 (Run Report). The TWC story page never renders, so the assertion cannot be evaluated.**

Insights side captured: Impressions (Facebook + Twitter + Instagram, Authorized) = **231,198,156**. The Classic/TWC side could not be read: every `GET https://domain-api.lfmdev.in/stories/<id>` fails in the browser (CORS error, no `Access-Control-Allow-Origin`, `net::ERR_FAILED`), so the app redirects back to the empty builder.

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Log in (Cognito "With existing account"), switch account to Amazon Prime Video via LFQA menu → Search Account → `.lfm-ta-option` "Amazon Prime Video" (not "…India") | ✅ breadcrumb `ACCOUNT: AMAZON PRIME VIDEO` |
| 1 | Brand (hover) → Insights | ✅ `#explore/brand/insights?brand_id=25864&account_id=342&from=2026-10-18&to=2026-10-24…` |
| 2 | Enable Facebook, Twitter, Instagram only | ✅ page loaded with TikTok also on; clicked `.channel-ghost.tiktok` off → Apply; URL `channels=instagram&channels=facebook&channels=twitter`; `.channel-ghost.enabled` = facebook/twitter/instagram only |
| 3 | Note Impressions big number | ✅ tile "Impressions: 231M(+1%)", exact `.count[title]` = **231,198,156**. View toggle (`#perspective`, `data-ui-name=perspective`) checked, screenshot `02b-view-toggle.png` shows **Authorized data** selected (Rule 2) |
| 4–5 | Reporting → Time Window Comparison (the TWC template; the Reporting menu has no item literally named "Classic Reporting": Home / Dashboards / Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics) | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` (first load sat on "Loading..." ~35 s, then rendered) |
| 6 | Add Amazon Prime Video brand (Authorized) | ✅ clicked the exact `Amazon Prime Video` option (not the country variants). Row toggle defaulted to Public (`#0-perspective-toggle` unchecked); clicked `label[for="0-perspective-toggle"]` → checked, helper button flipped to "Use Public Data" |
| 7 | Absolute Dates + Aggregate interval | ✅ Absolute Dates clicked, Interval = Aggregate, Start/End = Oct 18 / Oct 24 2026 (screenshot `06-twc-dates.png`) |
| 8 | By Channel | ✅ |
| 9 | Select Facebook Page Impressions, Twitter Organic Post Impressions, Instagram Post Impressions | ✅ `aria-checked=true` on exactly Facebook › Impressions & Reach › Page Impressions, Twitter › Impressions & Reach › Organic Post Impressions, Instagram › Impressions & Reach › Post Impressions (screenshot `07-twc-metrics.png`) |
| 10 | Run Report | ❌ BLOCKED. Run Report created stories 161745 (attempt 1) and 161746 (attempt 2, full rebuild of steps 6–10); each navigated to `#story/time_window_comparison/<id>`, sat on "Loading..." ~25–240 s, then fell back to the empty builder `#/time_window_comparison` with 0 report tables |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Sum of the selected report values == Brand Insights Impressions (231,198,156) | Report never rendered — TWC values unavailable | ⛔ BLOCKED (render failure at step 10) |

## Evidence
- Insights tile exact value: `.tile .count[title]` = "231,198,156" (visible "231M"), channels FB+TW+IG, Authorized, Oct 18–24 2026. Screenshots: `.playwright-out/QA-31572/01-insights-landing.png`, `02-insights-3channels.png`, `02b-view-toggle.png`
- TWC builder: `03-twc-landing.png`, `04-twc-brand-added.png`, `05-twc-authorized.png`, `06-twc-dates.png`, `07-twc-metrics.png`, `09-twc-rebuild.png`
- Failure: `10-twc-bounce.png` (builder after redirect). Console (`.playwright-out/console-2026-10-26T09-28-04-723Z.log` L383–L392; `console-2026-10-26T09-34-29-550Z.log`): `Access to XMLHttpRequest at 'https://domain-api.lfmdev.in/stories/161745?_=…' from origin 'https://app-reporting.lfmdev.in' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present` + `Failed to load resource: net::ERR_FAILED`; identical for 161746.
- Retry/diagnosis (5-min budget → one reload + retry, then call):
  1. Re-opened story 161745 by URL → same CORS failure, bounced to the builder.
  2. Rebuilt steps 6–10 from scratch (builder had been reset), re-ran → story 161746, same failure after ~240 s.
  3. Control: opened story **161556** (this same case's passing story from the 2026-10-22 run) → also fails identically. So stories saved earlier now fail too, which points to a dev environment / backend problem with `domain-api.lfmdev.in/stories/*`, not this case's configuration.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md has no entry for QA-31572. No known bug linked.
- Prior results: this case PASSED on 2026-10-22 (Insights 193,540,575 == TWC sum 193,540,575, story 161556) with the same steps, so the failure here is environmental (stories API), not a spec/data mismatch. The "Data Last Updated (PT)" banner read 10-25-2026 04:46 PM.
- Not attributable to a known bug; recommend someone check the dev `domain-api.lfmdev.in` `/stories/{id}` endpoint (a 5xx without CORS headers looks like a CORS error in the browser). I did not verify the HTTP status directly (blocked by CORS in-page).

## Bugs filed
None filed in Jira (per policy). Candidate (unconfirmed, environmental): "Dev `GET domain-api.lfmdev.in/stories/<id>` fails for all TWC stories on 2026-10-26 → TWC report page never renders" — re-run this case once the endpoint recovers.

## Cleanup
Read-only case. Two throwaway TWC stories were created on dev (161745, 161746).
