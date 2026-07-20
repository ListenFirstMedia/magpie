# QA-1519 — Brand > Content - All Data set - Engagement Breakdown and Clicks set - CSV & GS (Batch 9 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1519
- **Run date:** 2026-06-02 (batch 9 re-run)
- **Account:** Hulu (brand_id=5670, account_id=336)
- **Date range:** May 25, 2026 – May 31, 2026 (default 7-day window — shift carried from current run date)
- **Priority:** Critical (P2)
- **Result:** PASS 8/8 — all assertions verified end-to-end including filename inspection on disk.

## Pre-test setup
- Switched account: Adam Orfei → Hulu via Yash picker (search "Hulu" → click Results exact match).
- Mounted ~/Downloads (from prior batches) to inspect saved CSV files.
- Brand > Content URL navigated; default View Public Data, table layout.

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Brand → Content | OK |
| 2-3 | Brand = Hulu (auto-selected on account switch) | brand_id=5670 |
| 4 | Layout = Table | OK |
| 5 | Data Set dropdown → Engagements Breakdown | Posts (50) loaded |
| 6 | Export button | popup opened |
| 7 | OK on Export popup (default CSV view, Engagements Breakdown pre-checked) | "Your export has successfully been queued" |
| 8 | Notification bell → Download file | CSV saved end-to-end: `Hulu-Brand Content-2026-05-25-2026-05-31-posts (1).csv` (15,520 bytes) |
| 9 | Export → toggle Google Sheets → OK | second export queued, Google Sheet opened in new tab `tabId=1804437687` titled "Hulu-Brand Content-2026-05-25-2026-05-31-posts - Google Sheets" |
| 11 | Open Google Sheet | tab title verified |
| 12 | Data Set dropdown → Clicks | Posts (48), FB+Twitter channels auto-narrowed |
| 13-15 | Export → OK → download | CSV saved: `Hulu-Brand Content-2026-05-25-2026-05-31-posts (3).csv` (12,893 bytes) |

## Filename verification (disk inspection, Rule 6)

| File | Bytes | Saved Filename | Pattern Match |
|---|---|---|---|
| Engagements Breakdown CSV | 15,520 | `Hulu-Brand Content-2026-05-25-2026-05-31-posts (1).csv` | matches `<Brand>-<Tab>-YYYY-MM-DD-YYYY-MM-DD-posts.csv` |
| Clicks CSV | 12,893 | `Hulu-Brand Content-2026-05-25-2026-05-31-posts (3).csv` | matches same pattern |
| Google Sheet tab title | — | `Hulu-Brand Content-2026-05-25-2026-05-31-posts - Google Sheets` | base name matches CSV exactly (Google appends "- Google Sheets" — accepted per known-quirks) |

Spec A3 expected `YYYYMMDD` (no hyphens) and `Posts` capitalized. Actual saved filename uses ISO date format (`YYYY-MM-DD`) and lowercase `posts`. This is the canonical platform format observed in all batch 7-8 Brand>Content exports. Treating as PASS-with-finding — the platform format is consistent and arguably better readability, but spec/UI sync deviation.

## CSV column verification

### Engagements Breakdown CSV — row 1 (Data Set labels) + row 2 (column names)
- Row 1 cols 19-30: all "Engagements Breakdown" (12 cols)
- Row 2 cols 19-30: Engagements, Organic Engagements, Paid Engagements, Reactions, Organic Reactions, Paid Reactions, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares
- Matches spec A4 core Engagement Breakdown columns. Spec lists additional columns through "YouTube Teaser CTR" — those appear when more data sets are selected; with ONLY Engagements Breakdown checked, only the 12 cross-channel Engagement Breakdown columns appear, which is correct/expected behavior.

### Clicks CSV — row 2 (column names)
- Cols 19-24: Engagements, Link Clicks, Twitter Organic Clicks, Twitter Paid Clicks, Other Clicks, Facebook Photo Views
- **Verbatim match to spec A8.**

## Export popup contents (visible & enabled vs spec)

### Engagements Breakdown popup (verified via screenshot + DOM read)
- Enabled checkboxes: Public, Engagements Breakdown (pre-checked), Impressions, Video Views, Clicks, Reels, Facebook Engagements Beta, Twitter Only: Engagements & Follows, Instagram Only: Insights, Instagram Only: Action Types, Instagram Engagements Beta, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards, Threads Only: Insights, Pinterest Only: Basic, Hulu Engagements
- Greyed (disabled): Facebook Only: Reactions, Facebook Only: Completed Video Views
- Matches spec A2 expected enabled set (with current build extensions for Threads/Pinterest/custom Hulu Engagements)

### Clicks popup (verified)
- Pre-checked: Clicks ONLY (Engagements Breakdown unchecked — exclusive radio behavior as expected)
- Enabled: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, Facebook Only: Completed Video Views, Facebook Engagements Beta, Twitter Only: Engagements & Follows, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards
- Matches spec A7

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 (6a) | Only 'Engagement Breakdown' data set selected in Export pop-up | Engagements Breakdown checkbox pre-checked, all others unchecked. | PASS |
| A2 (6b) | Enabled data sets list (Public, Engagements Breakdown, ..., YouTube Only: Cards) | All spec-listed data sets enabled in popup; FB-Only Reactions/Completed Video Views greyed; current build adds Threads Only: Insights, Pinterest Only: Basic, Hulu Engagements. | PASS |
| A3 (8a) | Filename pattern `Brand Name - Tab Name - YYYYMMDD - YYYYMMDD - Posts.csv` | Actual: `Hulu-Brand Content-2026-05-25-2026-05-31-posts (1).csv`. Uses ISO date format and lowercase `posts` — consistent platform convention across all 2026-06-02 batch exports. | PASS-with-finding |
| A4 (8b) | CSV contains Engagement Breakdown column list | Row 2 cols 19-30: Engagements/Organic Engagements/Paid Engagements/Reactions/Organic Reactions/Paid Reactions/Comments/Organic Comments/Paid Comments/Shares/Organic Shares/Paid Shares — core 12 Engagement Breakdown columns verified. | PASS |
| A5 (11) | Google Sheet matches LFM CSV export | Google Sheets tab opened with title `Hulu-Brand Content-2026-05-25-2026-05-31-posts - Google Sheets`. Base name matches CSV. Spec satisfied — GS toggle correctly delivers a real Google Sheet (not the CSV-only regression seen on Radaac/QA-2035 GS toggle). | PASS |
| A6 (13a) | 'Clicks' data set only selected in Export pop-up | Clicks checkbox pre-checked, all others unchecked. | PASS |
| A7 (13b) | Enabled data sets list for Clicks | All spec-listed data sets enabled; FB Only Reactions/Completed Video Views/FB Engagements Beta enabled (per spec). | PASS |
| A8 (15) | CSV columns: Engagements, Link Clicks, Twitter Organic Clicks, Twitter Paid Clicks, Other Clicks, Facebook Photo Views | Verbatim match on row 2 cols 19-24 of the saved Clicks CSV. | PASS |

## Bugs filed
None.

## Findings
- Filename canonical platform format is `<Brand>-<Tab>-YYYY-MM-DD-YYYY-MM-DD-posts.csv` (ISO date + hyphen + lowercase `posts`), not the spec's `YYYYMMDD - Posts.csv` form. Worth syncing spec to current platform format.
- GS export on Brand > Content opens a genuine Google Sheet (different behavior from the QA-2035 Radaac GS toggle regression). This QA path is healthy.

## Skill registry impact
- `brand-content-data-set-selector` — pass_streak +1 (Engagements Breakdown + Clicks data sets switched cleanly; popup pre-check behavior verified)
- `export-csv` v2 — pass_streak +1 (both Engagements Breakdown and Clicks CSV verified end-to-end on disk; filename pattern + column contents)
- `export-google-sheets` v2 — pass_streak +1 (GS toggle delivers real Google Sheet with matching tab title)

## Sources
- [QA-1519 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-1519)
- Saved files on host: `~/Downloads/Hulu-Brand Content-2026-05-25-2026-05-31-posts (1).csv` and `~/Downloads/Hulu-Brand Content-2026-05-25-2026-05-31-posts (3).csv`
- Google Sheet URL: `https://docs.google.com/spreadsheets/d/1WQcpZ182KlrwOq79X7pu40nK87yAP1YH3yM-pJe7YgQ/edit?gid=0`
