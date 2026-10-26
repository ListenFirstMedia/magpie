# QA-30666 — Brand Insights - Cross-Channel Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-23 (Friday), headless Playwright, env `app.lfmdev.in` (dev), login `lfiqa@listenfirstmedia.com`
- Account / brand actually tested: **Wasserman / Gatorade** (brand_id=3580, account_id=863), Authorized data
- Window: Absolute **Oct 15, 2026 – Oct 21, 2026** (the Insights default 7-day range; the TWC range was set to the same days by clicking the calendar cells)
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Interpretation notes (spec ambiguity — read first)
- The precondition lists two accounts: "Amazon Prime Video, Wasserman". Steps 2 and 7 write `Amazon Prime Video | Gatorade` (and `(Authorized)` on the TWC side). I read this as an account|brand pair.
- **Amazon Prime Video account -> Gatorade (brand_id=10788)** is Public-only: the Insights View toggle is disabled (`#perspective` disabled, Public data), the TWC per-brand Authorized toggle is disabled (`#0-perspective-toggle` disabled), and the spec's TWC metrics `Facebook Page Video Views` and `Instagram Video Views` are greyed out (authorized-only). That configuration cannot satisfy step 7 "(Authorized)" or step 10.
- **Wasserman account -> Gatorade (brand_id=3580)** is Authorized-capable: the Insights toggle is enabled and checked (Authorized), the TWC Authorized toggle is enabled, and all four spec metrics are selectable. The assertion was therefore evaluated on Wasserman / Gatorade, which satisfies every step as written.
- Steps 5-6 ("Classic Reporting" -> "TWC Template") map to the current nav: Reporting -> **Time Window Comparison** (there is no "Classic Reporting" menu item or template picker in the current UI).
- Reference only (not the assertion basis): on APV / Gatorade (Public) the Insights tile was titled "Public Video Views" = 45,944,520 (screenshot 11). I did not build a TWC counterpart for the Public variant because the spec's Facebook/Instagram metrics are not available there.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"), switch account via LFQA menu -> Search Account -> Results row: Hulu -> Amazon Prime Video -> Wasserman | Done; breadcrumb `ACCOUNT: WASSERMAN` confirmed (account_id=863) |
| 1 | Hover Brand in top nav -> Insights | `#explore/brand/insights` opened. Brand was already Gatorade (3580) under Wasserman |
| 2 | Add Gatorade brand | Brand picker confirmed Gatorade is the active brand (`.brand-selector-name` = "Gatorade"). On the APV account I had selected it from the typeahead Results (exact "Gatorade", not a "Gatorade - <country>" variant) |
| 3 | Select Facebook, Instagram, Twitter, TikTok | Opened the channel selector, confirmed `.channel-ghost.enabled` for exactly facebook/twitter/instagram/tiktok (clicking any that was not enabled), clicked Apply; URL `channels=` carried all four; Authorized view (`#perspective` checked=true) |
| 4 | Note the Video Views tile value | `Video Views: 45.8M (-28%)`, exact `count[title]` = **45,789,221** (screenshot 22) |
| 5-6 | Reporting -> Time Window Comparison | `app-reporting.lfmdev.in/#/time_window_comparison` |
| 7 | Add Gatorade (Authorized) | Typeahead -> clicked exact `Gatorade` option; clicked `label[for=0-perspective-toggle]` -> `checked=true` (Authorized), toggle enabled (screenshot 23) |
| 8 | Absolute Dates + Interval "Aggregate" | Interval dropdown -> Aggregate; clicked `.from-calendar` day 15 and `.to-calendar` day 21 (October 2026); `range-start`=15, `range-end`=21 (screenshot 24) |
| 9 | Click By Channel | Opened; expanded Facebook / Twitter / Instagram / TikTok and each one's Video sub-group with real clicks |
| 10 | Select the 4 metrics | Facebook > Video > **Page Video Views**, Twitter > Video > **Public Video Views**, Instagram > Video > **Video Views**, TikTok > Video > **Public Video Views**; each `aria-checked=true`, each channel counter `1 / N` |
| 11 | Deselect Show Metrics Graphs | Trusted click; `aria-checked` true -> false (screenshot 25); the report shows tables only |
| 12 | Run Report, sum the values | Story built (see "Execution notes" for two failed loads first); values below |

## TWC result (story `#story/time_window_comparison/161627`, "Time Window Comparison (Oct 15, 2026 - Oct 21, 2026)", brand Gatorade)
| Channel metric | Value |
|---|---|
| Facebook Page Video Views | 1,680,759 |
| Twitter Public Video Views | 0 |
| Instagram Video Views | 1,380,640 |
| TikTok Public Video Views | 42,727,822 |
| **Sum** | **45,789,221** |

Arithmetic: 1,680,759 + 0 + 1,380,640 + 42,727,822 = 45,789,221.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights Cross-Channel Video Views value equals the sum of the TWC report's Video Views values | Insights tile `Video Views` = 45,789,221; TWC sum = 45,789,221; difference 0 | **PASS** |

## Evidence
- Screenshots (`.playwright-out/QA-30666/`): `11-insights-gatorade.png` (APV/Public reference), `20-wasserman-insights-initial.png`, `21-wasserman-insights-4ch.png`, `22-wasserman-insights-videoviews.png`, `23-twc-wasserman-brand.png`, `24-twc-wasserman-dates.png`, `25-twc-wasserman-options.png`, `28-twc-report-attempt2.png` (builder after the failed load), `29-twc-wasserman-story-161627.png` (final report). Files `01`-`07` in that folder are from the 2026-10-19 run (Amazon Prime Video brand), not this one.
- Insights Authorized tile list (same load): Total Followers 8,497,661; Follower Growth -751; New Posts 79; Engagements 47,784; Impressions 25,424,031; Video Views 45,789,221.
- The Insights tile is a live-range value; the dev data stamp ("Data Last Updated (PT): 10-22-2026 04:58 PM") was identical for both surfaces, so there is no freshness skew.

## Execution notes
- **TWC story load failed twice, then loaded.** Run Report created stories 161625 and 161626 (`POST domain-api.lfmdev.in/stories` -> 200), but the follow-up `GET /stories/<id>` failed within ~3 s with `net::ERR_FAILED` (browser reports it as a CORS block — no `Access-Control-Allow-Origin` header, which usually means a gateway error response), and the app dropped back to an empty builder. Attempt 1 was the initial run; attempt 2 followed Reload Last Settings with the metrics re-selected. The third run (story 161627) loaded normally with identical settings. Treated as a transient backend error, not a product defect; no "Bugs filed" entry. Within the 5-minute budget (the whole detour cost under 3 minutes).
- "Reload Last Settings" restored brand/perspective/interval/dates but dropped the metric selection after the first failure and restored it after the second; I re-verified the four metrics' `aria-checked` before every run.
- The Twitter value is a real 0 for Gatorade in this window (it is 0 in the TWC table; the Insights total reconciles exactly with it included).

## Known bugs checked
- Case file "Open linked bugs": none. `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-30666 entries (pre-grepped).
- Related but not formally linked: no Insights Video Views bug known; the Facebook Data Collection Disruption banner (9/27) was visible on Insights but did not affect the window's numbers (both surfaces agree).

## Bugs filed
None (markdown-only policy; nothing to file).
