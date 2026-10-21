# QA-31572 — Brand Insight vs Classic Reports > Data Test > Impressions

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Account:** Amazon Prime Video (account_id=342, switched from default account 657 via the LFQA menu → Search Account → `Results` row) · **Brand:** Amazon Prime Video (exact row, brand_id=25864) · **Perspective:** Authorized data · **Window:** Oct 12 – Oct 18, 2026
**Verdict: PASS (1/1) — Brand > Insights Impressions (FB+TW+IG) = 188,000,285; TWC Aggregate "By Channel" FB Page Impressions + TW Organic Post Impressions + IG Post Impressions = 188,000,285 (Δ 0)**

## Steps
| # | Step | Result |
|---|------|--------|
| Pre | Login (Cognito "With existing account", `config/.env` creds); switched account 657 → **Amazon Prime Video** (typed slowly; `Results` showed "Amazon Prime Video" and "Amazon Prime Video India"; clicked the exact row). Breadcrumb `ACCOUNT: AMAZON PRIME VIDEO`, `account_id=342` | ✅ |
| 1 | Hover Brand (top nav) → Insights | ✅ `#explore/brand/insights?brand_id=25864`, brand header "Amazon Prime Video" |
| 2 | View toggle: `#perspective` was checked / `perspective=extended` (Authorized). Rule 2: toggled explicitly to Public (`perspective=standard`, checked=false) and back to Authorized (`perspective=extended`, checked=true) (screenshots 03b, 03c). The toggle flip reset channels to all 4, so channel selector was reopened → TikTok icon clicked off → Apply: `.channel-ghost.enabled` = facebook, twitter, instagram only; URL `channels=twitter&channels=instagram&channels=facebook` (screenshot 04) | ✅ |
| 3 | Impressions big number (`.count[title]`) | **188,000,285** (displayed "Impressions: 188M(-3%)"); Oct 12–18, 2026, Authorized |
| 4–5 | Hover Reporting → **Time Window Comparison** (the TWC template). The menu has no literal "Classic Reporting" item (Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics) — same as the QA-30670 / QA-30666 runs | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` |
| 6 | Add Brand → typed "Amazon Prime Video" → clicked exact "Amazon Prime Video" `.al-typeahead__option` (first of ~66 options; not "Kids", "India", "Global", etc.). Row toggle `0-perspective-toggle` came up unchecked (Public); clicked → checked=true = **Authorized Data** (screenshot 08) | ✅ |
| 7 | Clicked **Absolute Dates**; Interval dropdown (Days) → **Aggregate**; Start Oct 12 / End Oct 18, 2026 clicked explicitly (matches the Insights window; `range-start`=12, `range-end`=18) (screenshot 09) | ✅ |
| 8 | **By Channel** view-switcher clicked | ✅ |
| 9 | Filter Metrics "Impressions" → ticked Facebook › Page Impressions, Twitter › Organic Post Impressions, Instagram › Post Impressions. Verified `aria-checked=true` on exactly these three leaves, no other metrics checked (screenshot 11) | ✅ |
| 10 | Run Report → story `#story/time_window_comparison/161412`, header "Amazon Prime Video — Time Window Comparison (Oct 12, 2026 - Oct 18, 2026)" | FB 97,157,423 · TW 7,732,834 · IG 83,110,028 |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Sum of the selected TWC report values matches the Brand Insights Impressions big number | 97,157,423 + 7,732,834 + 83,110,028 = **188,000,285** (shell-verified) = Insights **188,000,285** (Δ 0) | ✅ PASS (exact) |

## Evidence
- Insights tile: `title="188,000,285"`, text "Impressions: 188M(-3%)" — read on first load and again after reload (identical). Screenshots: `.playwright-out/QA-31572/04-insights-fb-tw-ig.png`, `05-after-reload.png`
- Perspective toggle round trip: `03b-public.png`, `03c-authorized.png`
- TWC builder/brand/Authorized toggle: `07-twc-brand-added.png`, `08-twc-authorized.png`; dates + Aggregate: `09-dates-aggregate.png`; metric filter/ticked: `10-metric-filter.png`, `11-metrics-ticked.png`; final report: `12-twc-report.png`
- TWC tables read via DOM: `Amazon Prime Video | 97,157,423` (Facebook Page Impressions), `Amazon Prime Video | 7,732,834` (Twitter Organic Post Impressions), `Amazon Prime Video | 83,110,028` (Instagram Post Impressions)
- Both sides use the same Authorized perspective, brand and window (data last updated 10-19-2026 04:47 PM PT).

## Notes
- The case gives no explicit dates; the Insights default window (Oct 12–18, 2026) was used on both sides.
- **UI quirk (observed, not filed):** after the Public → Authorized toggle round trip on Insights, the big-number tile set was stale (showed "Views: 6.27M" and "Public Video Views: 74M" in place of "Impressions" / "Video Views"). A page reload restored the normal Authorized tile set (Impressions 188,000,285). The value used for the assertion is the post-reload read, which equals the pre-toggle first read. Also, toggling perspective resets the channel selection to all four channels, so channels must be (re)selected after the toggle.
- A "Facebook Posts Insights Disruption" status-page banner was visible in the app; it did not affect the Impressions numbers (values matched exactly).
- For harvest: TWC interaction details — Interval dropdown option `.lfm-dropdown-option` "Aggregate"; metric leaves are `li.leaf[title="<Channel> <Metric>"]` (click the li to tick); Insights perspective switch is `input#perspective` (the label click is intercepted); per-brand TWC toggle is `#0-perspective-toggle`.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-31572. The perspective-toggle stale-tile behavior above was noticed during the run but does not touch the assertion (verified post-reload). No known bug reproduced.

## Bugs filed
None. · **Cleanup:** none needed (read-only flow; TWC story 161412 persists like any manual run).
