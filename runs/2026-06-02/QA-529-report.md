# QA-529 — Facebook Content - Mixed Authorization - Impressions

- **Date:** 2026-06-04
- **Tester:** magpie (batch 2)
- **Account:** Michael Kors (account_id=328)
- **Brand:** SS22 New York Fashion Week Roll-Up (brand_id=265946)
- **Date range:** Oct. 18, 2024 - Oct. 18, 2024
- **Channel:** Facebook only
- **View:** Authorized Data (right toggle position — required for mixed-auth lock display)
- **Filter:** Brand = Tory Burch OR Michael Kors (Include)
- **Data Set:** Impressions
- **Result:** PASS
- **Linked open bugs:** none

## Pre-flight
- Account switched Hulu/Adam Orfei → Michael Kors via profile dropdown.
- Brand picker: typed "SS22 New York Fashion Week" → selected "SS22 New York Fashion Week Roll-Up" from autocomplete.
- Layout: Table View (clicked the Table View layout icon).
- Channels: enabled only Facebook via URL `channels=facebook` + page-render confirmation.

## Posts table (UI)

3 posts under filter:

| Rank | Date | Channel | Brand | Type | Publish Type | Engagements | Engagement Rate | Impressions | Organic Imp | Paid Imp |
|------|------|---------|-------|------|---------------|-------------|------------------|-------------|-------------|----------|
| 1 | Fri Oct. 18, 2024 02:00 PM PDT | FB | Michael Kors | Image | Original Post | 926 | 0.32% | 286,833 | 286,833 | 0 |
| 2 | Fri Oct. 18, 2024 06:21 AM PDT | FB | Michael Kors | Video | Original Post | 538 | 0.59% | 91,228 | 91,228 | 0 |
| 3 | Fri Oct. 18, 2024 06:53 AM PDT | FB | Tory Burch | Video | Reel | `–` | – | 🔒 | 🔒 | 🔒 |

## CSV Export (end-to-end)

URL captured from bell notification: `https://analytics-cdn.lfmdev.in/293898-956af330ec149d5eb04c80b2b20ad012.csv`
Fetched via in-page `fetch({credentials:'include'})` — 1,692 bytes, 200 OK.

Row 1 (Data Set header): `Data Set, "","",...,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions,Impressions`

Row 2 (Column headers): `Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Engagement Rate,Impressions,Organic Impressions,Paid Impressions,Reach,Organic Reach,Paid Reach,Engaged User Rate`

Post rows:
- Row 3 (MK Image): full numerics — Engagements 926, ER 0.00322835935893011, Impressions "286,833", Organic Imp "286,833", Paid Imp 0, Reach "273,227", Organic/Paid Reach `-`, EUR `-`.
- Row 4 (MK Video Reel): full numerics — Engagements 538, ER 0.0058973122287017095, Impressions "91,228", Organic Imp "91,228", Paid Imp 0, Reach "86,865", Organic/Paid Reach `-`, EUR `-`.
- Row 5 (Tory Burch Reel/Video): Engagements `""`, Engagement Rate `""`, Impressions `""`, Organic Imp `""`, Paid Imp `""`, Reach `""`, Organic Reach `""`, Paid Reach `""`, EUR `""` — all metric columns BLANK as spec demands.

Brand column values across rows: only `Michael Kors` and `Tory Burch` — no spurious brands.

Type column: Row 5 = `Video`, Publish Type = `Reel` → Facebook Reel post included in export.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | Brand column shows only Tory Burch + Michael Kors | UI table + CSV both show only those 2 brands | PASS |
| A2 | 7 | Michael Kors posts display data | 2 MK rows with full Engagements/ER/Impressions/Organic/Paid/Reach numerics | PASS |
| A3 | 7 | Tory Burch Reel posts show endash `–` | UI Engagements cell shows `–` for Tory Burch Reel row | PASS |
| A4 | 8 | Tory Burch shows locks for private data points | Impressions/Organic Impressions/Paid Impressions columns render padlock icons in UI for Tory Burch row | PASS |
| A5 | 8 | Michael Kors posts show data for all metrics | All MK metric columns populated | PASS |
| A6 | 12 | Export displays blank cells for lock data points | Tory Burch CSV row has `""` (empty) cells in Engagements, ER, Impressions, Organic Imp, Paid Imp, Reach, Organic Reach, Paid Reach, EUR | PASS |
| A7 | 12 | Only filtered brand names appear in CSV Brand column | Only `Michael Kors` and `Tory Burch` present in CSV Brand column | PASS |
| A8 | 12 | Facebook Reel posts included in export | Row 5: Type=Video, Publish Type=Reel | PASS |

## Bugs filed
- None.

## Skill usage
- `switch-account` (Adam Orfei → Michael Kors).
- `brand-content-table-view` (Table layout icon click).
- `brand-content-filter` (Brand filter Tory Burch OR Michael Kors Include, with `filters` JSON in URL).
- `brand-content-data-set-selector` (Public → Impressions dropdown select).
- `export-csv` (queued CSV via CDN URL captured from bell + fetched in-page).
