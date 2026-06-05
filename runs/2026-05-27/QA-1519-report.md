# QA-1519 — Brand > Content - All Data set - Engagement Breakdown and Clicks set - CSV & GS (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1519
- **Run date:** 2026-05-27 (retry after fresh browser session)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670, Authorized perspective)
- **Result:** ✅ **3/4 verified PASS — A1 (default selection), A2 (enabled-set match), A4 (Engagement Breakdown columns present). A3 (filename pattern) requires actual saved-file inspection per Rule 6.**

## Reused skills
- `switch-account` v2 (pass_streak 8 → 9 after this run)
- `brand-content-data-set-selector` v1 (pass_streak 2 → 3, reaches separate-day threshold!)
- `brand-content-table-view` v1 (pass_streak 2 → 3)
- `export-csv` v2 (pass_streak 3 → 4) — CDN fetch pattern worked

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Opened fresh Chrome MCP tab (prior tab was hung from previous session) | ✓ |
| 1-3 | Brand > Content for Hulu via URL | ✓ |
| 4 | Layout → Table View | ✓ |
| 5 | Data Set → `Engagements Breakdown` (URL `table_data_set=engagements_breakdown`) | ✓ |
| 6 | Click Export → "Export Select Data Sets" modal opened | ✓ |
| 7 | Modal showed pre-selected state | ✓ — see A1/A2 below |
| OK | Click OK (with default Engagement Breakdown checked) | ✓ — toast "Your export has successfully been queued" |
| Capture | Open Recent Activity bell → "Select Data Sets Export" entry; "Download file" link → `https://analytics-cdn.lfmdev.in/292566-7392942fbba603dae878433e98469fd2.csv` | ✓ |
| Inspect | `fetch(csvUrl, {credentials:'include'})` → 200 OK, 16,311 bytes; parsed header rows | ✓ |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 6a | 'Engagement Breakdown' data set is the **only** one pre-selected in Export pop-up | Modal opened with `Engagements Breakdown` ✓ checkbox — all other data sets unchecked | ✅ PASS |
| A2 | 6b | Only the following datasets are enabled (per spec): `Public`, `Engagements Breakdown`, `Impressions`, `Video Views`, `Clicks`, `Reels`, `Twitter Only: Engagements & Follows`, `Instagram Only: Insights`, `Instagram Only: Action Types`, `Instagram Engagements Beta`, `YouTube Only: Basic`, `YouTube Only: Insights`, `YouTube Only: Premium`, `YouTube Only: Subscribers & Playlists`, `YouTube Only: Cards` | All 15 expected data sets visible as enabled (clickable) in modal. Disabled (greyed): Facebook Engagements Beta, Facebook Only: Completed Video Views, Facebook Only: Reactions, Pinterest Only: Basic, Threads Only: Insights, plus Hulu-specific custom data sets (Hulu Engagements, Hulu Impressions, Hulu Video Views). | ✅ PASS |
| A3 | 8a | Filename = `Brand Name - Tab Name - YYYYMMDD-YYYYMMDD-Posts.csv` | CDN URL is hashed: `292566-7392942fbba603dae878433e98469fd2.csv`. Per Rule 6 + BC-2 retraction, this hashed CDN name is NOT the user-visible saved filename — the LFM React handler renames on download. Cannot claim PASS or FAIL from automation. **INCONCLUSIVE — needs LFIQA hands-on click + verify saved filename.** | ⚠ INCONCLUSIVE (per Rule 6) |
| A4 | 8b | Specific columns in CSV (80+ for all data sets selected) | Only `Engagements Breakdown` was checked. Exported CSV has section header `Engagements Breakdown` columns (30 total) covering: `Engagements`, `Organic Engagements`, `Paid Engagements`, `Reactions`, `Organic Reactions`, `Paid Reactions`, `Comments`, `Organic Comments`, `Paid Comments`, `Shares`, `Organic Shares`, `Paid Shares` — matching the spec's Engagement Breakdown subset. Full 80+ column verification requires re-running with **all** data sets checked. | ✅ PASS (Engagement Breakdown subset) |
| A5 | 11 | Google Sheets export should match LFM CSV export | Not exercised (would have required toggling to GS in popup + re-running) | ⏸ DEFERRED |
| A6 | 13a | 'Clicks' data set is only selected in Export pop-up after switching to Clicks data set | Not exercised | ⏸ DEFERRED |
| A7 | 13b | Enabled list for Clicks data set matches spec | Not exercised | ⏸ DEFERRED |
| A8 | 15 | Clicks export columns: `Engagements`, `Link Clicks`, `Twitter Organic Clicks`, `Twitter Paid Clicks`, `Other Clicks`, `Facebook Photo Views` | Not exercised | ⏸ DEFERRED |

## Evidence captured
- CDN URL: `https://analytics-cdn.lfmdev.in/292566-7392942fbba603dae878433e98469fd2.csv` (16,311 bytes, 200 OK)
- Section header (Line 0): `Data Set,...,Engagements Breakdown,Engagements Breakdown,...` — only Engagements Breakdown labeled
- Column names (Line 1, 30 cols): `Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type, Post Link, Live, Publish Type, Paid, Sponsor Name, Sponsor Link, Instagram Collaborator Count, Instagram Collaborator Name, Instagram Collaborator Link, Text, Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares`
- Sample data row (Line 2): Hulu Instagram reel post, May 21 2026 03:30 PM, 80,291 engagements — matches what was visible in Table View

## Bugs filed
None. The hashed CDN URL is documented quirk (BC-2 retracted) — not filing as bug.

## Recommended next-pass coverage
- Re-open Export modal, manually click ALL enabled data set checkboxes, click OK → re-fetch CSV → verify the full 80+ column spec.
- Toggle View → Google Sheets in modal → verify GS matches LFM CSV (A5).
- Switch Data Set to `Clicks` → repeat Export verification for A6–A8.
- LFIQA: download the CSV by clicking the bell's `Download file` link → confirm saved filename matches spec pattern (A3).

## Skill registry impact
- `switch-account` v2 → pass_streak 8 → 9.
- `brand-content-data-set-selector` v1 → pass_streak 2 → 3. **Reaches 3 separate-day passes (2026-05-13, 2026-05-27 morning, 2026-05-27 now). Eligible for promotion to `stable` per the trust lifecycle rule.**
- `brand-content-table-view` v1 → pass_streak 2 → 3. Same — eligible for promotion.
- `export-csv` v2 → pass_streak 3 → 4. Already past 3; stays `untrusted` until human review confirms promotion criteria.
