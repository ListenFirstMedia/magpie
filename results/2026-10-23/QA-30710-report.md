# QA-30710 — Brand Insights - Cross-Channel Response Rate Tile (Public Data) - Data QA

**Run date:** 2026-10-23 (re-run) · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in (dev), login `lfiqa@listenfirstmedia.com` · **Account:** HBO Max (account_id=657, switched from the post-login default via LFQA menu → Search Account → `Results` row; breadcrumb `ACCOUNT: HBO MAX`) · **Brand:** HBO Max (exact "HBO Max" typeahead row, not a regional variant) · **Window:** Oct 15 – Oct 21, 2026 (Insights default range; the same days were clicked in TWC)

**Verdict: PASS** — Insights Response Rate 0.41% vs TWC Response Rate 0.40% (raw 0.4001%). The displayed values differ by 0.01 pp, which is inside the ±0.01 pp tolerance the case notes set for rates. See "Observation" below.

This run replaces an earlier 2026-10-23 attempt that was BLOCKED because `GET domain-api.lfmdev.in/stories/<id>` was failing environment-wide. The story load works now (story 161630 rendered on the first run).

Open-bug screen (Rule 7): case file "Open linked bugs" = none, so the case ran normally.

Interpretation: the precondition "HBO Max | Hulu" was read as account/brand HBO Max (first alternative). Steps 5–6 "Classic Reporting → TWC Template" map to the current nav Reporting → **Time Window Comparison**; there is no literal "Classic Reporting" item or template picker.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Cognito "With existing account" login; hover LFQA menu → typed "HBO Max" → clicked the `Results` row `.lfm-ta-option` "HBO Max" | ✅ `account_id=657` |
| 1 | Hover Brand in top nav → Insights | ✅ `#explore/brand/insights`, default brand HBO Max (155614) in Authorized view |
| 2 | Brand picker chevron → typed "HBO Max" → clicked the exact "HBO Max" row (first row; list also held "HBO Max (ANZ)", "HBO Max Global", etc., none used). Real mouse click on **Public data** in the View toggle | ✅ `#perspective` checked true → false, URL `perspective=standard`, brand_id 155614 → 155611 (`r2-04-public.png`) |
| 3 | Channels Facebook, Twitter(X), Instagram, TikTok | ✅ Exactly those four are `.channel-ghost.enabled`; YouTube/Pinterest/Wikipedia/RT/IMDb/Metacritic disabled; URL `channels=` lists the same four |
| 4 | Note Response Rate tile | **0.41%** — heading "Response Rate: 0.41%(-22%)", `.count[title]="0.41%"`, legend Facebook, Twitter, Instagram, TikTok; tile `data-datapoint=lfm.post_engagement_score.public_post_engagement_rate_v5` (`r2-05-rr-tile.png`) |
| 5–6 | Hover Reporting → Time Window Comparison | ✅ `app-reporting.lfmdev.in/#/time_window_comparison` |
| 7 | Add Brand By Name → typed "HBO Max" → clicked the exact `.al-typeahead__option` "HBO Max"; per-brand toggle `0-perspective-toggle` checked=false = **Public Data** | ✅ (`r2-06-twc-brand.png`) |
| 8 | Absolute Dates tab; Interval **Aggregate**; clicked Start Oct 15 / End Oct 21, 2026 (`td.active` 15 / 21) | ✅ (`r2-07-dates.png`) |
| 9 | Clicked "By Channel" | ✅ |
| 10 | Filter Metrics "Response Rate" → ticked **Cross-Channel › Content › Response Rate** (`lfm.post_engagement_score.public_post_engagement_rate_v5_dp`, same datapoint family as the Insights tile); it was the only metric with `aria-checked=true` | ✅ |
| 11 | Deselected **Show Metrics Graphs** (aria-checked true → false; Show Metrics Tables left on) | ✅ (`r2-08-options.png`) |
| 12 | Run Report → `#story/time_window_comparison/161630` in ~85 s; "Time Window Comparison (Oct 15, 2026 - Oct 21, 2026)", HBO Max; one table `Brand \| Response Rate` → `HBO Max \| 0.40%` | ✅ (`r2-09-after-run.png`) |
| extra | Exported the TWC report as CSV and read the file on disk | `"Public","HBO Max","10/15/2026","10/21/2026","0.004001232323416764"` (`.playwright-out/QA-30710/HBO Max - Time Window Comparison - Oct 15, 2026 - Oct 21, 2026.csv`) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights Cross-Channel Response Rate equals the TWC report Response Rate | Insights tile 0.41%; TWC table 0.40% (CSV raw 0.4001232%); displayed difference 0.01 pp, within the case-note tolerance of ±0.01 pp on the 2-decimal display | ✅ PASS (within tolerance) |

## Observation (worth a look, not a verdict driver)
- The values are not displayed identically. TWC's raw value is 0.40012%, so Insights' 0.41% cannot be the same number rounded: Insights must be at or above 0.405%. The true gap is therefore 0.005–0.010 pp.
- The Insights tile exposes only the 2-decimal string (`title="0.41%"`), so the raw Insights value could not be read. A tile like Engagements/Views would settle it if it is ever needed.
- Not filed as a bug: the case defines ±0.01 pp as the compare tolerance, and both surfaces use the same datapoint family. If the product intent is exact 2-decimal equality, this case sits right on the edge and could flip on another day's data.
- The earlier BLOCKED attempt today also read Insights = 0.41%, so the Insights value was stable across both runs.

## Known bugs checked
- Case file "Open linked bugs": none open. `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-30710 entries (pre-grepped shell-side). No known bug interfered with any step or assertion.
- Environment note: the story-load failure from the earlier attempt (`GET /stories/<id>` failing with `net::ERR_FAILED`) did not recur. It was transient and is not a product bug filing.

## Bugs filed
None (markdown-only policy; nothing to file).

## Evidence
- Screenshots under `.playwright-out/QA-30710/` with the `r2-` prefix (this run): `r2-01-insights.png`, `r2-02-brand-click.png`, `r2-03-picker-open.png`, `r2-04-public.png`, `r2-05-rr-tile.png`, `r2-06-twc-brand.png`, `r2-07-dates.png`, `r2-08-options.png`, `r2-09-after-run.png`. Files without the `r2-` prefix are from the earlier attempt.
- CSV: `.playwright-out/QA-30710/HBO Max - Time Window Comparison - Oct 15, 2026 - Oct 21, 2026.csv` (a copy also sits at `.playwright-out/HBO-Max---Time-Window-Comparison---Oct-15-2026---Oct-21-2026.csv`).
- Data stamp on both surfaces: "Data Last Updated (PT): 10-22-2026 04:58 PM", so no freshness skew.
