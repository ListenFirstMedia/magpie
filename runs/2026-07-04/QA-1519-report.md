# QA-1519 — Brand > Content - All Data set - Engagement Breakdown and Clicks set - CSV & GS

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless, unattended) vs `app.lfmdev.in`
- **Account:** Hulu (account_id=336) — precondition satisfied (app resolved to Hulu on login)
- **Brand:** Hulu (brand_id=5670) — exact spec-brand match (Rule 1)
- **Skills used:** `brand-content-table-view` (untrusted), `brand-content-data-set-selector` (stable)
- **Verdict:** **PASS** (all in-scope assertions A1/A2/A6/A7 pass). A3/A4/A5/A8 skipped — emailed-CSV + Google Sheets out of scope on the Playwright track.

## Scope notes

Per the Playwright-track scope rules and the `brand-content-data-set-selector` skill: Brand > Content
export **delivery is asynchronous by email** (banner/notification "Content Export … is now ready"),
not a synchronous file download. Verifying the **emailed CSV** (filename, columns) and the
**Google Sheets** artifact requires the email inbox + Google 2FA and is **out of scope**. The
in-app export pop-up (selection state + context-dependent enablement) is in scope and was fully
verified for both data sets. Confirmed the export action fires end-to-end (notification bell shows
"Your Content Export with Select Data Sets for Hulu … is now ready. Download file.").

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand (top nav) → Content | Done — opened Brand>Content via Brand Content suggested-view (new tab), account Hulu |
| 2 | Brand dropdown → Type "Hulu" | Attempted — brand already Hulu (5670); typeahead flaky (only "Recent Searches" surfaced, no Results — known automation-friction). Active brand already exact-match "Hulu"; intent satisfied |
| 3 | Select Hulu brand | Satisfied — active brand remained Hulu (brand_id=5670) |
| 4 | Click Table View | Done — `[title="Table View"]` |
| 5 | Data set dropdown → "Engagement Breakdown" | Done — `table_data_set=engagements_breakdown` (channels auto-scoped to twitter+instagram) |
| 6 | Click Export | Done — "Export Select Data Sets" pop-up opened (CSV/Google Sheets toggle) |
| 7 | Select all data sets → OK | Done — "Data Sets" master checked all 15 enabled sets; OK fired async export (notification bell) |
| 8 | Open email → download CSV | **SKIPPED — emailed CSV, out of scope** |
| 9 | Export → toggle to Google Sheet | **SKIPPED — Google Sheets out of scope** |
| 10 | Click OK in popup | **SKIPPED — GS out of scope** |
| 11 | Open email → open Google Sheet | **SKIPPED — GS + email out of scope** |
| 12 | Data set dropdown → "Clicks" | Done — `table_data_set=clicks` (channels auto-scoped to twitter+facebook) |
| 13 | Click Export | Done — pop-up opened, "Clicks" pre-checked |
| 14 | Click OK in popup | Done — fired async export |
| 15 | Open email → download CSV | **SKIPPED — emailed CSV, out of scope** |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Only 'Engagement Breakdown' selected in Export pop-up | Only "Engagements Breakdown" checked; all other rows unchecked | **PASS** |
| A2 | 6b | Enabled: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Twitter Only: Engagements & Follows, Instagram Only: Insights, Instagram Only: Action Types, Instagram Engagements Beta, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards | Exactly those 15 sets enabled. Disabled: Facebook-Only ×3, Threads Only, Pinterest Only, custom Hulu ×3 | **PASS** |
| A3 | 8a | Filename `Brand - Tab - YYYYMMDD - YYYYMMDD - Posts.csv` | Not verifiable in-app (emailed CSV) | **SKIPPED (out of scope)** |
| A4 | 8b | CSV Engagement Breakdown column list | Not verifiable in-app (emailed CSV) | **SKIPPED (out of scope)** |
| A5 | 11 | Google Sheet matches LFM CSV export | Google Sheets out of scope (Google 2FA) | **SKIPPED (out of scope)** |
| A6 | 13a | Only 'Clicks' selected in Export pop-up | Only "Clicks" checked; all other rows unchecked | **PASS** |
| A7 | 13b | Enabled: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, FB Only: Reactions, FB Only: Completed Video Views, FB Engagements Beta, Twitter Only: Engagements & Follows, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards | Exactly those 15 sets enabled. Disabled: Instagram-Only ×3, Threads Only, Pinterest Only, custom Hulu ×3 | **PASS** |
| A8 | 15 | CSV columns (Engagements, Link Clicks, Twitter Organic/Paid Clicks, Other Clicks, Facebook Photo Views) | Not verifiable in-app (emailed CSV) | **SKIPPED (out of scope)** |

## Evidence

### A1/A2 — Engagements Breakdown export pop-up
Screenshot: `.playwright-out/QA-1519/export-popup-engagement-breakdown.png`

Checked on open: **Engagements Breakdown only**.

Enabled (15): Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Twitter Only: Engagements & Follows, Instagram Only: Insights, Instagram Only: Action Types, Instagram Engagements Beta, YouTube Only: Basic, YouTube Only: Insights, YouTube Only: Premium, YouTube Only: Subscribers & Playlists, YouTube Only: Cards.

Disabled (8): Facebook Only: Reactions, Facebook Only: Completed Video Views, Facebook Engagements Beta, Threads Only: Insights, Pinterest Only: Basic, Hulu Engagements, Hulu Impressions, Hulu Video Views.

"Select all" (Data Sets master) checked exactly those 15 enabled sets (16 incl. master) — confirms A2.

### A6/A7 — Clicks export pop-up
Screenshot: `.playwright-out/QA-1519/export-popup-clicks.png`

Checked on open: **Clicks only**.

Enabled (15): Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, Facebook Only: Completed Video Views, Facebook Engagements Beta, Twitter Only: Engagements & Follows, YouTube Only: Basic, YouTube Only: Insights, YouTube Only: Premium, YouTube Only: Subscribers & Playlists, YouTube Only: Cards.

Disabled (8): Instagram Only: Insights, Instagram Only: Action Types, Instagram Engagements Beta, Threads Only: Insights, Pinterest Only: Basic, Hulu Engagements, Hulu Impressions, Hulu Video Views.

Both enablement sets exactly match the spec, and the context flip (EB → Instagram-Only enabled / Clicks → Facebook-Only enabled) is confirmed — matches `brand-content-data-set-selector` skill.

Other artifacts: `.playwright-out/QA-1519/brand-picker-hulu.png` (brand-picker state during step 2).

## Bugs filed

None. No product defects observed. The export pop-up enablement matched the spec exactly for both
data-set contexts.

### Observations (not bugs)
- Brand>Content brand-picker typeahead was flaky under automation (React value-setter surfaced only
  "Recent Searches", no live "Results"). This is documented automation-friction, not a product bug —
  the active brand was already the exact spec brand "Hulu" (brand_id=5670).
- Export button carries a transient `disabled` class + an outer `.content-export-btn` div that
  intercepts pointer events while a newly-selected data set's table loads; enabled after ~4s.
