# QA-30670 — Brand Insights - Cross-Channel Public Video Views Tile - Data QA

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Account:** Viacom (account_id=181, switched from default Hulu/336 via the LFQA menu) · **Brand:** MTV (exact "MTV" Results row; Insights brand_id 4018 → 10765 after Public toggle) · **Window:** Oct 12 – Oct 18, 2026
**Verdict: PASS (1/1) — Brand > Insights Public Video Views tile = 9,849,582; TWC Aggregate "By Channel" Public Video Views sum to exactly 9,849,582 (Δ 0)**

## Steps
| # | Step | Result |
|---|------|--------|
| Pre | Login (Cognito "With existing account"), switch account Hulu → Viacom (LFQA menu → Search Account → `Results` row "Viacom"); breadcrumb `Account: Viacom`, URL `account_id=181` | ✅ |
| 1 | Hover Brand in top nav → Insights | ✅ (`#explore/brand/insights`) |
| 2 | Brand picker → typed "MTV" → clicked the exact-match "MTV" row under Results (Rule 1; not "MTV (FB)", "MTV News", etc.). Clicked **Public data** in the View toggle (Rule 2; toggle pill moved to Public, URL `perspective=standard`, brand_id → 10765) | ✅ (screenshot 04) |
| 3 | Channels Facebook, Twitter (X), Instagram, TikTok — these four were highlighted/selected (URL `channels=instagram,tiktok,facebook,twitter`); no other channel selected | ✅ |
| 4 | Public Video Views tile (`.count[title]`) | **9,849,582** (displayed "Public Video Views: 9.85M (-64%)"; legend Facebook/Twitter/Instagram/TikTok) |
| 5–6 | Hover Reporting → **Time Window Comparison** (the TWC template). The menu has no literal "Classic Reporting" item; Reporting lists Data Studio / Time Window Comparison / Content Performance / Social Recap / Follower Demographics — same as the QA-30666 run | ✅ (`app-reporting.lfmdev.in/#/time_window_comparison`) |
| 7 | Add Brand By Name → "MTV" → exact "MTV" `.al-typeahead__option`; row toggle `0-perspective-toggle` checked=false, knob on left = **Public Data** (screenshot 06) | ✅ |
| 8 | Absolute Dates tab clicked; Start Oct 12 / End Oct 18, 2026 clicked (matches the Insights window); Interval → **Aggregate** | ✅ (screenshot 08) |
| 9 | "By Channel" view-switcher clicked | ✅ |
| 10 | Filter Metrics "Public Video Views" → ticked Facebook › Video › Public Video Views, Twitter › Video › Public Video Views, Instagram › Video › Public Video Views, TikTok › Video › Public Video Views (the "Average Public Video Views" and Cross-Channel leaves left unticked); aria-checked=true ×4, no other metrics checked | ✅ |
| 11 | Options → **Show Metrics Graphs** unchecked (true → false) via trusted click; Show Metrics Tables left on | ✅ (screenshot 11) |
| 12 | Run Report → story `#story/time_window_comparison/161409`, header "MTV — Time Window Comparison (Oct 12, 2026 - Oct 18, 2026)"; one Brand/Value table per metric | FB 754,803 · TW 26,191 · IG 3,454,564 · TikTok 5,614,024 |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Insights cross-channel Public Video Views = Σ of the four TWC channel Public Video Views | 754,803 + 26,191 + 3,454,564 + 5,614,024 = **9,849,582** (shell-verified) = Insights **9,849,582** | ✅ PASS (exact, Δ 0) |

## Evidence
- Insights tile: `title="9,849,582"`, text 9.85M — `.playwright-out/QA-30670/05-insights-public-video-views.png`
- Public toggle selected: `04-public-selected.png`; TWC brand + Public toggle: `06-twc-brand-added.png`; dates + Aggregate: `08-dates-aggregate.png`; metric filter: `10-metric-filter.png`; options: `11-options.png`; final report: `13-twc-report.png`
- TWC tables read via DOM: `MTV | 754,803`, `MTV | 26,191`, `MTV | 3,454,564`, `MTV | 5,614,024`
- Both sides use the same Public perspective, MTV, and window Oct 12–18, 2026 (data last updated 10-19-2026 04:47 PM PT).

## Notes
- The case gives no explicit dates; the Insights default window (Oct 12–18, 2026, the last full week) was used on both sides so the comparison is like-for-like. The TWC default range was also Oct 12–18; both date cells were still clicked explicitly.
- A "Facebook Posts Insights Disruption" status-page banner was visible in the app; it did not affect the Public Video Views numbers (values matched exactly).
- Interaction details (menu has no "Classic Reporting" label; TWC brand typeahead accepted real keystrokes this run; Filter Metrics = 4th `input.controlled-text-input`) are for harvest.sh to fold into the skill.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md / known-quirks.md: no entries for QA-30670. Nothing reproduced.

## Bugs filed
None. · **Cleanup:** none needed (read-only flow; TWC story 161409 persists like any manual run).
